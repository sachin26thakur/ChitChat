//
//  ChatAreaViewController.m
//  CodersChat
//
//  Created by Vishal Bhadade on 12/02/16.
//  Copyright (c) 2016 GlobalLogic. All rights reserved.
//

#import "ChatAreaViewController.h"
#import "FGTranslator.h"
#import <AddressBook/AddressBook.h>
#import "WebserviceHandler.h"
#import "TextChatCell.h"
#import "SocketStream.h"
#import "ChatListViewController.h"
#import "MediaChatCell.h"
#import "AudioChatCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RequestHelper.h"
#import "UIImageView+WebCache.h"
#import <AudioToolbox/AudioServices.h>
#import "ChatAreaViewController+ChatDatasouce.h"
#import <objc/runtime.h>
#import "IndividualChatHeaderView.h"
#import "RequestHelper.h"


@interface ChatAreaViewController ()<WebServiceHandlerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,MPMediaPickerControllerDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate, IndividualCellDelegate,UINavigationControllerDelegate>
{
    NSDateFormatter *dateFormatter;
    //NSMutableIndexSet *selectedChatMessages;
    NSMutableSet *selectedChatIDs;
    NSMutableSet *imageIDCache;
    
    MPMoviePlayerController *moviePlayer;
    UILongPressGestureRecognizer *longTapGesture;
    UITapGestureRecognizer *disMissKeyboard;
    
    NSMutableSet *peekMessageToDelete;
    NSTimer *peekMessageTimer;
    
    BOOL currentMessagePeaked;
    BOOL inSelecionMode;
    NSData *tempVideoData;
    
    BOOL sendEnabled;
    BOOL isRecording;
    
    BOOL isWaitingForPrevious;
    BOOL isPreviousMessagesAvailable;
    
    
    BOOL imageFilterActive;
    NSMutableSet *mediaDownloadInProgress;
    NSMutableSet *emojiStickerDownloadInProgress;
    
    
    AVAudioRecorder *recorder;
    AVAudioPlayer * player;
    NSData *currentRecordedData;
    BOOL isRecordedAudioPlaying;
    
    
    NSMutableDictionary *audioPlayerDict;
    NSString *currentMessageAudioPlaying;
    BOOL isAudioPlaying;
    BOOL keyboardAreaShown;
    
    NSTimer								*updateTimer;
    NSTimer								*recorderTimer;
    
    //For Emoji Messages
    NSMutableString *emojiString;
    BOOL ifEmojiIsSelected;
    BOOL ifStickerIsSelected;
    BOOL isSendButtonActive;
    NSAttributedString *defaultMessageText;
    NSAttributedString *emptyMessageText;
    NSAttributedString *tempMessageText;
    NSMutableArray *chatListArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *mikeBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *smilyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smilyTextHSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraTextHSpace;
@property (weak, nonatomic) IBOutlet UITextView *msgTextView;
@property (weak, nonatomic) IBOutlet UIButton *peakBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *soundBtn;
@property (weak, nonatomic) IBOutlet UIButton *add_FriendBtn;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIButton *imgFilterBtn;
@property (weak, nonatomic) IBOutlet UIView *moreOptionsView;

@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *soundSpacingHConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalCollectionViewContraint;
@property (weak, nonatomic) IBOutlet UIButton *viewSetsBtn;
@property (weak, nonatomic) IBOutlet UIButton *keyboardBtn;


@property (weak, nonatomic) IBOutlet UIView *audioPeakVew;
@property (weak, nonatomic) IBOutlet UIButton *audioRecordingIcon;
@property (weak, nonatomic) IBOutlet UILabel *audioTimerLabel;
@property (weak, nonatomic) IBOutlet UIButton *audioPlayBtn;
@property (weak, nonatomic) IBOutlet UISlider *audioScrubber;
@property (weak, nonatomic) IBOutlet UILabel *audioRightTimerlabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelAudioBtn;
@property (weak, nonatomic) IBOutlet UIButton *peakAudioMsg;
@property (weak, nonatomic) IBOutlet UIButton *sendAudioMsg;

//@property (strong, nonatomic) NSMutableArray *defaultKeyboardEmojiSticker;
@property (weak, nonatomic) IBOutlet UIView *morePopUpView;
@property (weak, nonatomic) IBOutlet UIButton *moreReportBtn;
@property (weak, nonatomic) IBOutlet UIButton *contentReportBtn;

@property (weak, nonatomic) IBOutlet UIButton *reportUserBtn;
@property (weak, nonatomic) IBOutlet UIView *reportView;
@property (weak, nonatomic) IBOutlet UIButton *reportGrpContent;



@end

const char stickerCreatorKey;

@implementation ChatAreaViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
//    self = [NSMutableArray new];
//    [chatListArr addObject:@"Hi"];
//    [chatListArr addObject:@"How Are You"];
//    [chatListArr addObject:@"Are you there"];
//    [chatListArr addObject:@"I am here"];
//    [chatListArr addObject:@"Where do you live"];
//    [chatListArr addObject:@"I live in Nagpur"];
//    [chatListArr addObject:@"that's it"];
//    
//    // Do any additional setup after loading the view.
//    [self translateChatString:chatListArr withSource:nil andDestination:@"hi"];
//    

    
    isPreviousMessagesAvailable = false;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    self.collectionView.alwaysBounceVertical = true;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getMessage:)
                                                 name:@"MessageReceived"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(groupUpdated:)
                                                 name:@"GroupUpdated"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(exitRadarChat:)
                                                 name:@"ExitRadar"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getMessageAcknowledgement:)
                                                 name:@"AcknowledgementReceived"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peakTimerBuzzed:)
                                                 name:@"PeakTimerBuzzed"
                                               object:nil];
    
    
    
    
    peekMessageToDelete = [NSMutableSet set];
    selectedChatIDs = [NSMutableSet set];
    mediaDownloadInProgress = [NSMutableSet set];
    emojiStickerDownloadInProgress = [NSMutableSet set];
    audioPlayerDict = [NSMutableDictionary new];
    imageIDCache = [NSMutableSet set];
    currentMessageAudioPlaying = @"";
    
    
    //Set font of text view
    self.msgTextView.font = TEXT_FONT;
    self.msgTextView.textColor = RGB(99, 99, 101);
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    
    NSDictionary *attrsDefaultDictionary =
    @{ NSFontAttributeName: TEXT_FONT,
       NSParagraphStyleAttributeName: paragraphStyle,NSForegroundColorAttributeName:RGB(169, 169, 169)};
    NSDictionary *attrsMsgDictionary =
    @{ NSFontAttributeName: TEXT_FONT,
       NSParagraphStyleAttributeName: paragraphStyle,NSForegroundColorAttributeName:RGB(99, 99, 101)};
    
    defaultMessageText = [[NSAttributedString alloc] initWithString:DEFAULT_MESSAGE_TEXT attributes:attrsDefaultDictionary];
    emptyMessageText = [[NSAttributedString alloc] initWithString:@"" attributes:attrsMsgDictionary];
    tempMessageText = [[NSAttributedString alloc] initWithString:@"temp" attributes:attrsMsgDictionary];
    
    
    self.msgTextView.attributedText  = defaultMessageText;
    
    longTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongTapped:)];
    [self.collectionView addGestureRecognizer:longTapGesture];
    
    [self.cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)]];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *recorderFilePath = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    NSError *setOverrideError;
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&setOverrideError];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:recorderFilePath settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    //[recorder prepareToRecord];
    
    
    
    disMissKeyboard = [[UITapGestureRecognizer alloc]
                       initWithTarget:self
                       action:@selector(dismissKeyboard)];
    disMissKeyboard.delegate = self;
    [self reloadView];
    
       emojiString = [NSMutableString new];
    ifEmojiIsSelected = false;
    [self.msgTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    if( [userdefaults boolForKey:@"userLoggedIn"])
        [[SocketStream sharedSocketObject] restartSocket];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    
    [self sendReadAcknowledgments];
    [self startTimerForPeakMessage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [self stopMusic];
}

-(void)viewDidLayoutSubviews{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Custom View
-(void)reloadView {
    
    // Do any additional setup after loading the view
    self.friendName.text = self.cardObject.name;
    
    if(cd_USER == [Utility CardTypeFromString:self.cardObject.cardType]){
        self.friendActiveStatus.text = self.cardObject.status;
        self.reportGrpContent.hidden = YES;
    }
    else{
        self.friendActiveStatus.hidden = true;
        self.contentReportBtn.hidden = true;
        self.reportUserBtn.hidden = YES;
    }
    
    
    @synchronized(individualChatData)
    {
        BOOL isFirstTime = false;
        if(!individualChatData || [individualChatData count]==0)
            isFirstTime = true;
        individualChatData = [[DatabaseHelper getChatMessagesForCard:self.cardObject.id_ fromTimeStamp:nil withLimit:10] mutableCopy];
        [self getAllMessagesConverted];
        self.transmiterID = self.cardObject.id_;
        if(!individualChatData)
            individualChatData = [NSMutableArray array];
        else if (isFirstTime && [individualChatData count]>=10)
            isPreviousMessagesAvailable = true;
    }
    if(self.cardObject.image_relationship && (self.cardObject.image_relationship.highRes || self.cardObject.image_relationship.lowRes))
    {
        self.friendImage.image = [UIImage imageWithData:self.cardObject.image_relationship.lowRes] ;
        self.friendImage.layer.masksToBounds = NO;
        self.friendImage.layer.cornerRadius = self.friendImage.frame.size.width/2;
        self.friendImage.clipsToBounds = YES;
    }
    else{
        if(cd_PRIVATE_GROUP == [Utility CardTypeFromString:self.cardObject.cardType]) {
            self.friendImage.image = [UIImage imageNamed:@"DefaultGroup"];
        } else
            self.friendImage.image = [UIImage imageNamed:@"DefaultUser"];
        
        if(self.cardObject.image_relationship.url_lowRes)
        {
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.cardObject.image_relationship.url_lowRes]
                                                            options:SDWebImageRetryFailed
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                               // progression tracking code
                                                           }
                                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                              if (image && finished) {
                                                                  // do something with image
                                                                  self.friendImage.image = image;
                                                                  self.friendImage.layer.masksToBounds = NO;
                                                                  self.friendImage.layer.cornerRadius = self.friendImage.frame.size.width/2;
                                                                  self.friendImage.clipsToBounds = YES;
                                                                  self.cardObject.image_relationship.lowRes = UIImagePNGRepresentation(image);
                                                                  [DatabaseHelper saveDBManagedContext];
                                                              }
                                                          }];
            
        }
    }
    
    if([self.cardObject.isFriend isEqualToNumber:@true])
    {
        self.add_FriendBtn.hidden = YES;
    }
    
    if((imageFilterActive && [[self getMediaMessages] count]) || (!imageFilterActive && [individualChatData count]))
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(imageFilterActive) ? [[self getMediaMessages] count] -1 : [individualChatData count]-1 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionNone
                                            animated:YES];
}


#pragma mark Socket Acknowledgments
- (void)updateCurrentTime
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id_ = %@ || SELF.clientMsgID.stringValue = %@",currentMessageAudioPlaying,currentMessageAudioPlaying];
    
    NSArray *msgArray =[individualChatData filteredArrayUsingPredicate:predicate];
    if(msgArray && [msgArray count])
    {
        ChatMessageObject *chatObj = msgArray[0];
        
        NSInteger index = (imageFilterActive) ? [[self getMediaMessages] indexOfObject:chatObj] : [individualChatData indexOfObject:chatObj];
        IndividualChatCell *cell = (IndividualChatCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        
        if(isAudioPlaying)
            [cell updateAudioSliderIsPlaying:true withMaxTime:player.duration currentTime:player.currentTime];
        else
            [cell updateAudioSliderIsPlaying:false withMaxTime:0 currentTime:0];
        
        //  [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    }
}

-(void)newGroupCreated:(NSArray*)grpIDs withChatMessage:(ChatMessageObject *)msgObj sendNotification:(BOOL)notificationNeeded{
    
    if(notificationNeeded){
        
        [[SocketStream sharedSocketObject] sendGroupNotification:grpIDs];
    }
    [[SocketStream sharedSocketObject] sendMessage:msgObj];
    
}


- (void)sendReadAcknowledgments {
    @synchronized(individualChatData)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.ackType = nil || SELF.ackType = %@) AND SELF.tx_id != %@",[Utility AckTypeToString:ak_MSG_DELIVERED],[SocketStream sharedSocketObject].userID];
        NSArray *messages = [individualChatData filteredArrayUsingPredicate:predicate];
        for (ChatMessageObject *chatMessage in messages) {
            [[SocketStream sharedSocketObject] sendAcknowledgement:[chatMessage getReadAcknowledgement]];
            chatMessage.ackType = [Utility AckTypeToString:ak_MSG_READ];
            [DatabaseHelper saveManagedContext];
        }
    }
}

-(void)peakTimerBuzzed:(NSNotification *)aNotification{
    
    NSDictionary *timerDict = [aNotification object];
    NSPredicate *peakPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF.clientMsgID IN %@) AND NOT (SELF.org_id IN %@) AND NOT (SELF.org_id = nil AND SELF.clientMsgID = nil)", timerDict[@"msgID"],timerDict[@"msgID"]];
    
    @synchronized(individualChatData)
    {
        [individualChatData filterUsingPredicate:peakPredicate];
        [self.collectionView reloadData];
    }
    [[SocketStream sharedSocketObject] peakBuzzed:timerDict];
}


-(void)startTimerForPeakMessage {
    
    NSPredicate *msgPredicate = [NSPredicate predicateWithFormat:@"SELF.msgLife = %@ AND SELF.media_relationship = nil AND SELF.tx_id != %@",@(PEAK_MESSAGE_LIFE),[SocketStream sharedSocketObject].userID];
    NSPredicate *mediaPredicate = [NSPredicate predicateWithFormat:@"SELF.msgLife = %@ AND SELF.media_relationship != %@ AND SELF.tx_id != %@",@(PEAK_MESSAGE_LIFE),nil,[SocketStream sharedSocketObject].userID];
    
    @synchronized(individualChatData)
    {
        NSArray *messages = [individualChatData filteredArrayUsingPredicate:msgPredicate];
        if([messages count])
            [[SocketStream sharedSocketObject] addToTimer:@{@"time":@([NSDate timeIntervalSinceReferenceDate]+PEAK_MESSAGE_TIMER),@"msgID":[messages valueForKeyPath:@"org_id"]}];
        
        NSArray *mediaMessages = [individualChatData filteredArrayUsingPredicate:mediaPredicate];
        if([mediaMessages count])
            [[SocketStream sharedSocketObject] addToTimer:@{@"time":@([NSDate timeIntervalSinceReferenceDate]+PEAK_MEDIA_TIMER),@"msgID":[mediaMessages valueForKeyPath:@"org_id"]}];
    }
}

-(void)sendMessageWithText:(NSString *)msgText media:(MediaObject *)mediaObj{
    
    [appDelegate stopActivityIndicator];
    
    @synchronized(individualChatData)
    {
        NSArray *rxgIDs;
        NSArray *rxIDs;
        
        if([self.cardObject.cardType isEqualToString:@"cd_PRIVATE_GROUP"]){
            rxgIDs = @[self.cardObject.id_];
        }
        else{
            rxIDs = @[self.cardObject.id_];
        }
        
        long long clientID = ([[NSDate date] timeIntervalSince1970] * 1000);
        
        ChatMessageObject *chatMessage = [ChatMessageObject getEntityFor:oj_MESSAGE ackType:NOACK chatType:PRIVATE notifyType:NONOTIFY msgReqType:NOMSGREQ clientMsgID:clientID id:nil org_id:nil msgLife:(currentMessagePeaked) ? 10: -1 msgDetails:(ifStickerIsSelected)?StickerMessageIdentifier:((ifEmojiIsSelected)?EmojiMessageIdentifier:nil) status:nil nTimesSent:1 timeFirstSent:clientID timeLastSent:clientID tx_id:[SocketStream sharedSocketObject].userID tx_name:nil  tx_uname:[SocketStream sharedSocketObject].userName tx_avatar_id:nil tx_avatar_uname:nil msgText:msgText rx_id:rxIDs rxg_id:rxgIDs mediaObject:mediaObj];
        
        currentMessagePeaked = NO;
        
        [self getMessageConverted:chatMessage forIndex:individualChatData.count];
        [individualChatData addObject:chatMessage];
        
        [self.collectionView reloadData];
        
        if((imageFilterActive && [[self getMediaMessages] count]) || (!imageFilterActive && [individualChatData count]))
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(imageFilterActive) ? [[self getMediaMessages] count] -1 : [individualChatData count]-1 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionBottom
                                                animated:YES];
        [[SocketStream sharedSocketObject] sendMessage:chatMessage];
        sendEnabled = true;
        if(ifStickerIsSelected)
            ifStickerIsSelected = false;
        else if (ifEmojiIsSelected){
            ifEmojiIsSelected = false;
            emojiString = [NSMutableString new];
        }
        isSendButtonActive = true;
    }
    
}

-(void)groupUpdated:(NSNotification *)aNotification{
    
    NSString *cardID = [aNotification object];
    if([self.cardObject.id_ isEqualToString:cardID]){
        self.cardObject = [[SocketStream sharedSocketObject] getCardByID:cardID];
    }
    
    [self reloadView];
    
    
}
-(void)exitRadarChat:(NSNotification *)aNotification{
    
    if(!(self.cardObject && self.cardObject.id_ && [[SocketStream sharedSocketObject] getCardByID:self.cardObject.id_])){
        [self backAction:nil];
    }
}

-(void)getMessage:(NSNotification *)aNotification{
    
    @synchronized(individualChatData)
    {
        ChatMessageObject *message = [aNotification object];
        
        
        if((([self.cardObject.cardType isEqualToString:[Utility CardTypeToString:cd_PRIVATE_GROUP]] && [[message getReceiverGroupIDs] containsObject:self.cardObject.id_]) || ([self.cardObject.cardType isEqualToString:[Utility CardTypeToString:cd_USER]] && [self.cardObject.id_ isEqualToString:message.tx_id]))  && ![[individualChatData valueForKeyPath:@"id_"] containsObject:message.id_]){
            
            [self getMessageConverted:message forIndex:individualChatData.count];
            [individualChatData addObject:message];
            [self.collectionView reloadData];
            
            if((imageFilterActive && [[self getMediaMessages] count]) || (!imageFilterActive && [individualChatData count]))
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(imageFilterActive) ? [[self getMediaMessages] count] -1 : [individualChatData count]-1 inSection:0]
                                            atScrollPosition:UICollectionViewScrollPositionBottom
                                                    animated:YES];
            
            [self sendReadAcknowledgments];
            [self startTimerForPeakMessage];
        }
    }
    
    
}

-(void)getMessageAcknowledgement:(NSNotification *)aNotification{
    
    @synchronized(individualChatData)
    {
        individualChatData = [[DatabaseHelper getChatMessagesForCard:self.cardObject.id_ afterTimeStamp:((ChatMessageObject *)individualChatData[0]).timeFirstSent] mutableCopy];
        // [self getAllMessagesConverted];
        [self.collectionView reloadData];
        
    }
}

-(void)reLoadVisibleMessages{
    
    if(individualChatData.count)
    {
        
        NSArray *previousMessages = [DatabaseHelper getChatMessagesForCard:self.cardObject.id_ fromTimeStamp:((ChatMessageObject *)individualChatData[0]).timeFirstSent withLimit:10];
        if(previousMessages.count)
        {
            @synchronized(individualChatData) {
                for (int i =0 ;i<[previousMessages count] ;i++) {
                    
                    ChatMessageObject *messageObj = previousMessages[i];
                    [self getMessageConverted:messageObj forIndex:i];
                    
                }
                [individualChatData insertObjects:previousMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, previousMessages.count)]];
                [self.collectionView reloadData];
            }
            isPreviousMessagesAvailable = true;
        }
        else
            isPreviousMessagesAvailable = false;
    }
}

#pragma mark Collection View

-(void)loadPreviousMessages{
    
    if(individualChatData.count && isPreviousMessagesAvailable)
    {
        NSArray *previousMessages = [DatabaseHelper getChatMessagesForCard:self.cardObject.id_ fromTimeStamp:((ChatMessageObject *)individualChatData[0]).timeFirstSent withLimit:10];
        if(previousMessages.count)
        {
            @synchronized(individualChatData) {
                for (int i =0 ;i<[previousMessages count] ;i++) {
                    
                    ChatMessageObject *messageObj = previousMessages[i];
                    [self getMessageConverted:messageObj forIndex:i];
                    
                }
                if(previousMessages.count < 10)
                    isPreviousMessagesAvailable = false;
                else
                    isPreviousMessagesAvailable = true;
                
                [individualChatData insertObjects:previousMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, previousMessages.count)]];
                [self.collectionView reloadData];
                
                isWaitingForPrevious = false;
            }
            
        }
        else{
            isWaitingForPrevious = false;
            isPreviousMessagesAvailable = false;
            [self.collectionView reloadData];
            
        }
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio
{
    if(imageFilterActive)
        return [[self getMediaMessages] count];
    else
        return [individualChatData count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row ==0)
    {
        
    }
    IndividualChatCell *cell;
    ChatMessageObject *messageObj;
    
    if(imageFilterActive)
        messageObj = [self getMediaMessages][indexPath.item];
    else
        messageObj = individualChatData[indexPath.item];
    
    if(messageObj.media_relationship && ma_AUDIO == [Utility MediaTypeFromString:messageObj.media_relationship.mediaType])
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AudioChatCellIdentifier" forIndexPath:indexPath];
    else if(messageObj.media_relationship)
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MediaChatCellIdentifier" forIndexPath:indexPath];
    else if([messageObj.msgType isEqualToString:[Utility MessageTypeToString:mg_SHARE_EMOJI_STICKER]])
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiStickerCellIdentifier" forIndexPath:indexPath];
    else
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TextChatCellIdentifier" forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    //[cell setCellProperties:messageObj setSelected:(inSelecionMode && [selectedChatMessages containsIndex:indexPath.item])];
    
    
    if(messageObj.media_relationship && ma_AUDIO == [Utility MediaTypeFromString:messageObj.media_relationship.mediaType])
    {
        if(isAudioPlaying && ([currentMessageAudioPlaying isEqualToString:messageObj.id_] || [currentMessageAudioPlaying isEqualToString:messageObj.clientMsgID.stringValue]))
            [cell setCellProperties:messageObj setSelected:(inSelecionMode && ([selectedChatIDs containsObject:messageObj.id_] || [selectedChatIDs containsObject:messageObj.clientMsgID] )) withTag:indexPath.row maxTime:player.duration currentTime:player.currentTime];
        else
            [cell setCellProperties:messageObj setSelected:(inSelecionMode && ([selectedChatIDs containsObject:messageObj.id_] || [selectedChatIDs containsObject:messageObj.clientMsgID] )) withTag:indexPath.row ifPlaying:false];
        
    }
    else if(cd_PRIVATE_GROUP == [Utility CardTypeFromString:self.cardObject.cardType])
        [cell setCellProperties:messageObj setSelected:(inSelecionMode && ([selectedChatIDs containsObject:messageObj.id_] || [selectedChatIDs containsObject:messageObj.clientMsgID] )) fromGroupMember:true];
    else
        [cell setCellProperties:messageObj setSelected:(inSelecionMode && ([selectedChatIDs containsObject:messageObj.id_] || [selectedChatIDs containsObject:messageObj.clientMsgID] ))];
    
    
    if(([mediaDownloadInProgress containsObject:messageObj.id_] && [cell isKindOfClass:[MediaChatCell class]]) || ([mediaDownloadInProgress containsObject:messageObj.id_] && [cell isKindOfClass:[AudioChatCell class]]))
        [cell showIndicator];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.audioPeakVew.hidden)
    {
        [self cancelSendingAudio:nil];
    }
    else if (!self.moreOptionsView.hidden)
        self.moreOptionsView.hidden = true;
    else{
        
        ChatMessageObject *msgObj = (imageFilterActive) ? ((ChatMessageObject *)[self getMediaMessages][indexPath.item]) : ((ChatMessageObject *)individualChatData[indexPath.item]);
        
        if(inSelecionMode){
            if([self isNormalMessage:msgObj] || [self isMessageSent:msgObj byCardId:self.cardObject.id_]){
                if([selectedChatIDs containsObject:(msgObj.id_)? :msgObj.clientMsgID])
                {
                    [selectedChatIDs removeObject:(msgObj.id_)? :msgObj.clientMsgID];
                    
                } else {
                    [selectedChatIDs addObject:(msgObj.id_)? :msgObj.clientMsgID];
                }
                
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                if([selectedChatIDs count] == 0)
                    [self removeSelectionMode];
            }
        }
        
        else{
            if(msgObj.media_relationship) {
                if(msgObj.media_relationship.highRes)
                {
                    
                }
                else{
                    if(msgObj.id_)
                    {
                        
                        NSString *highResURL = msgObj.media_relationship.url_highRes;
                        
                        if([msgObj.media_relationship.mediaType isEqualToString:[Utility MediaTypeToString:ma_IMAGE]])
                        {
                            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:highResURL]
                                                                            options:SDWebImageRetryFailed
                                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                                               // progression tracking code
                                                                           }
                                                                          completed:^(UIImage *imageDownloaded, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                                              if (imageDownloaded && finished) {
                                                                                  // do something with image
                                                                                  [mediaDownloadInProgress removeObject:msgObj.id_];
                                                                                  
                                                                                  msgObj.media_relationship.highRes = UIImagePNGRepresentation(imageDownloaded);
                                                                                  [DatabaseHelper saveDBManagedContext];
                                                                                  [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                                                                              }
                                                                              else
                                                                                  [appDelegate stopActivityIndicator];
                                                                          }];
                            
                        }
                        
                        else{
                            
                            //download the file in a seperate thread.
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                NSLog(@"Downloading Started");
                                NSURL  *url = [NSURL URLWithString:highResURL];
                                NSData *urlData = [NSData dataWithContentsOfURL:url];
                                if ( urlData )
                                {
                                    NSString *moviePath;
                                    if([msgObj.media_relationship.mediaType isEqualToString:[Utility MediaTypeToString:ma_VIDEO]])
                                        moviePath = [[Utility getDocumentPath] stringByAppendingPathComponent:@"Video.MP4"];
                                    else
                                        moviePath = [[Utility getDocumentPath] stringByAppendingPathComponent:@"audio.m4a"];
                                    
                                    //saving is done on main thread
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [urlData writeToFile:moviePath atomically:YES];
                                        [mediaDownloadInProgress removeObject:msgObj.id_];
                                        
                                        msgObj.media_relationship.highRes = urlData;
                                        [DatabaseHelper saveDBManagedContext];
                                        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                                        NSLog(@"File Saved !");
                                    });
                                }
                                else{
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                      //  ShowAlert(AlertTitle, NSLocalizedString(@"Video download failed.", nil));
                                        [appDelegate stopActivityIndicator];
                                    });
                                }
                                
                            });
                            
                        }
                        [mediaDownloadInProgress addObject:msgObj.id_];
                        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    }
                    else if([msgObj.msgType isEqualToString:[Utility MessageTypeToString:mg_SEND_BROADCAST]])
                    {
                        
                        
                    }
                    
                    
                }
            }
            else if ([msgObj.msgType isEqualToString:[Utility MessageTypeToString:mg_SHARE_EMOJI_STICKER]]){
            } else if ([msgObj.msgDetails isEqualToString:StickerMessageIdentifier]) {
                
            }
        }
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatMessageObject *messageObj = (imageFilterActive)? (ChatMessageObject *)[self getMediaMessages][indexPath.row] : (ChatMessageObject *)individualChatData[indexPath.row];
    
    if(imageFilterActive || messageObj.media_relationship || [messageObj.msgType isEqualToString:[Utility MessageTypeToString:mg_SHARE_EMOJI_STICKER]]){
        
        if(!messageObj.media_relationship && [messageObj.msgDetails isEqualToString:StickerMessageIdentifier]){
            
            if([((NSAttributedString *)messageObj.msgAttributedText).string isEqualToString:@"Sticker"])
                return CGSizeMake(screenWidth, 200);
            
            CGRect rect =[messageObj.msgAttributedText boundingRectWithSize:CGSizeMake(screenWidth-80, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            if([messageObj.msgType isEqualToString:[Utility MessageTypeToString:mg_SEND_BROADCAST]])
                rect.size.height +=17;
            
            if(cd_PRIVATE_GROUP == [Utility CardTypeFromString:self.cardObject.cardType])
                return  CGSizeMake(screenWidth, rect.size.height+65);
            else
                return  CGSizeMake(screenWidth, rect.size.height+55);
            
            
            
        }
        else if ((!imageFilterActive && ma_AUDIO == [Utility MediaTypeFromString:((ChatMessageObject *)individualChatData[indexPath.row]).media_relationship.mediaType]) || (imageFilterActive && ma_AUDIO == [Utility MediaTypeFromString:((ChatMessageObject *)([self getMediaMessages][indexPath.row])).media_relationship.mediaType])){
            
            if([messageObj.msgType isEqualToString:[Utility MessageTypeToString:mg_SEND_BROADCAST]])
                return  CGSizeMake(screenWidth,110);
            else
                return  CGSizeMake(screenWidth,90);
            
        }
        else if(cd_PRIVATE_GROUP == [Utility CardTypeFromString:self.cardObject.cardType]){
            
            ChatMessageObject *messageObj;
            if(imageFilterActive)
                messageObj = [self getMediaMessages][indexPath.item];
            else
                messageObj = individualChatData[indexPath.item];
            
            if([messageObj.tx_id isEqualToString:[SocketStream sharedSocketObject].userID])
                return  CGSizeMake(screenWidth,250);
            else
                return  CGSizeMake(screenWidth,260);
            
        }
        else
            return  CGSizeMake(screenWidth,250);
        
    }
    else{
        
        
        CGRect rect =[messageObj.msgAttributedText boundingRectWithSize:CGSizeMake(screenWidth-80, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        if([messageObj.msgType isEqualToString:[Utility MessageTypeToString:mg_SEND_BROADCAST]])
            rect.size.height +=17;
        
        if([messageObj.msgDetails isEqualToString:StickerMessageIdentifier]){
            
            if(cd_PRIVATE_GROUP == [Utility CardTypeFromString:self.cardObject.cardType])
                return  CGSizeMake(screenWidth, rect.size.height+65);
            else
                return  CGSizeMake(screenWidth, rect.size.height+55);
            
            
            
        } else {
            
            if(cd_PRIVATE_GROUP == [Utility CardTypeFromString:self.cardObject.cardType])
                return  CGSizeMake(screenWidth, rect.size.height+75);
            else
                return  CGSizeMake(screenWidth, rect.size.height+75);
        }
        
    }
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    IndividualChatHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    [headerView.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [headerView.activityIndicator startAnimating];
    headerView.whiteBackGroundView.clipsToBounds = YES;
    headerView.whiteBackGroundView.layer.cornerRadius = headerView.whiteBackGroundView.frame.size.width/1;
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHeaderTap:)];
    // make your gesture recognizer priority
    headerTap.delaysTouchesBegan = YES;
    headerTap.numberOfTapsRequired = 1;
    //  [headerView addGestureRecognizer:headerTap];
    
    return headerView;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if(isPreviousMessagesAvailable && isWaitingForPrevious)
        return CGSizeMake(320, 50);
    else
        return CGSizeMake(0, 0);
}


-(void)handleHeaderTap:(UITapGestureRecognizer *)tapGesture{
    [self loadPreviousMessages];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < 0 && !isWaitingForPrevious && isPreviousMessagesAvailable){
        isWaitingForPrevious = true;
        [self.collectionView reloadData];
        // Delay execution of my block for 10 seconds.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //reach top so load previous messages
            [self loadPreviousMessages];
        });
        
        
    }
}

#pragma mark Keyboard Notification

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.viewSetsBtn.isSelected)
        [self btnKeyboard_ButtonAction:nil];
    [[self KeyboardAvoiding_findFirstResponderBeneathView:self.view] resignFirstResponder];
    [super touchesEnded:touches withEvent:event];
    self.collectionView.userInteractionEnabled = YES;
    self.morePopUpView.hidden = YES;
}

- (UIView*)KeyboardAvoiding_findFirstResponderBeneathView:(UIView*)view {
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self KeyboardAvoiding_findFirstResponderBeneathView:childView];
        if ( result ) return result;
    }
    return nil;
}

#pragma mark Call WebService


-(void)callSeviceToDownloadHighResMedia:(NSString *)mesID{
    
    WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
    objWebServiceHandler.delegate = self;
    objWebServiceHandler.str = mesID;
    
    //for AFNetworking request
    [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getMessageForID:mesID] withMethod:@"" withUrl:@"" forKey:@""];
    
    
}

-(void)callSeviceToDownloadIndividualSetImage:(NSArray *)imageIDs forIndex:(NSInteger)index forEmoji:(BOOL)forEmoji{
    
    WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
    objWebServiceHandler.delegate = self;
    objWebServiceHandler.str = GET_INDIVIDUAL_IMAGE_REQUEST;
    objWebServiceHandler.id_ = [imageIDs componentsJoinedByString:@"__"];
    objWebServiceHandler.index = index;
    
    //for AFNetworking request
    [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getIndividualImagesFor:imageIDs forEmoji:forEmoji] withMethod:@"" withUrl:@"" forKey:@""];
    
    
}


- (IBAction)getEmojiStickerSet:(UIButton *)sender {
}



#pragma mark Web Service Response

-(void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponse{
    
    @synchronized(individualChatData)
    {
        //NSLog(@"dicResponce:-%@",dicResponse);
        [appDelegate stopActivityIndicator];
        
        if ([webHandler.str isEqualToString:GET_INDIVIDUAL_IMAGE_REQUEST]) {
            
        }
        
        else if ([webHandler.str isEqualToString:DEFAULT_EMOJI_STICKER_REQUEST]) {
            
            
        }
        else if ([webHandler.str isEqualToString:GET_FULL_SET_REQUEST]) {
            
        }
        else if([webHandler.str isEqualToString:EMOJI_STICKER_REQUEST])
        {
            for (NSDictionary *emojiStickerDict in dicResponse[@"respDetails"]) {
                [DatabaseHelper saveModel:@"EmojiStickerSet" FromResponseDict:emojiStickerDict];
            }
            [emojiStickerDownloadInProgress removeObject:webHandler.id_];
            [self.collectionView reloadData];
            
        }
        else if(![webHandler.str isEqualToString:MUTE_REQUEST]){
            if(dicResponse[@"respDetails"])
            {
                [DatabaseHelper saveModel:@"ChatMessageObject" FromResponseDict:dicResponse[@"respDetails"]];
                
            }
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id_ = %@",webHandler.str];
            ChatMessageObject *chatObj = [individualChatData filteredArrayUsingPredicate:predicate][0];
            NSInteger index = [individualChatData indexOfObject:chatObj];
            individualChatData[index] = [DatabaseHelper getExistingRecordModel:@"ChatMessageObject" byID:webHandler.str];
            [mediaDownloadInProgress removeObject:webHandler.str];
            [self.collectionView reloadData];
        }
        else
        {
            if([Utility muteListContainsID:self.cardObject.id_]){
                [Utility removeIdFromMuteList:self.cardObject.id_];
            }
            else{
                [Utility addIdToMuteList:self.cardObject.id_];
            }
        }
        //        [(MediaChatCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]] hideIndicatorOnSuccess:true];
        //        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    }
}

-(void) webServiceHandler:(WebserviceHandler *)webHandler requestFailedWithError:(NSError *)error
{
    
    //NSLog(@"dicResponce:-%@",[error description]);
    
    if ([webHandler.str isEqualToString:GET_INDIVIDUAL_IMAGE_REQUEST]) {
        NSMutableSet *idSet = [NSMutableSet setWithArray:[webHandler.id_ componentsSeparatedByString:@"__"]];
        [imageIDCache minusSet:idSet];
    }
    else if ([webHandler.str isEqualToString:GET_FULL_SET_REQUEST]) {
    }
    else if ([webHandler.str isEqualToString:DEFAULT_EMOJI_STICKER_REQUEST]) {
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id_ = %@",webHandler.str];
        ChatMessageObject *chatObj = [individualChatData filteredArrayUsingPredicate:predicate][0];
        NSInteger index = [individualChatData indexOfObject:chatObj];
        [mediaDownloadInProgress removeObject:webHandler.str];
        [self.collectionView reloadData];
    }
    [appDelegate stopActivityIndicator];
    //remove it after WS call
}

#pragma mark Textview Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    const char * _char = [text cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    if (isBackSpace == -8) {
        // if backspace pressed
        if ([emojiString length]>range.location) {
            NSString *tmpString = [emojiString substringFromIndex:range.location+1];
            if ([[tmpString substringFromIndex:0] isEqualToString:@"_"]) { //Deleting Emoji
                NSScanner *scanner = [NSScanner scannerWithString:[emojiString substringFromIndex:range.location]];
                [scanner scanUpToString:@"__" intoString:nil];
                
                while(![scanner isAtEnd]) {
                    NSString *substring = nil;
                    [scanner scanString:@"__" intoString:nil]; // Scan the # character
                    if([scanner scanUpToString:@"__" intoString:&substring]) {
                        if ([Utility isAlphaNumeric_24CharacterLengthID:substring]) {
                            // If the space immediately followed the #, this will be skipped
                            NSString *StringText = [[NSString alloc] initWithString:emojiString];
                            emojiString = [[NSMutableString alloc] initWithString:[StringText stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"__%@__",substring] withString:@""]];
                            break;
                        }
                    }
                    [scanner scanUpToString:@"__" intoString:nil]; // Scan all characters before next #
                }
            } else { //Deleting Character
                emojiString =  [[NSMutableString alloc] initWithString:[emojiString stringByReplacingCharactersInRange:NSMakeRange(range.location, 1) withString:@""]];
            }
        }
    } else {
        
        NSString *strTempEmojiString = [[NSString alloc] initWithString:emojiString];
        NSMutableArray *substrings = [NSMutableArray new];
        NSScanner *scanner = [NSScanner scannerWithString:strTempEmojiString];
        [scanner scanUpToString:@"__" intoString:nil]; // Scan all characters before #
        while(![scanner isAtEnd]) {
            NSString *substring = nil;
            [scanner scanString:@"__" intoString:nil]; // Scan the # character
            if([scanner scanUpToString:@"__" intoString:&substring]) {
                // If the space immediately followed the #, this will be skipped
                if ([Utility isAlphaNumeric_24CharacterLengthID:substring]) {
                    [substrings addObject:substring];
                }
            }
            [scanner scanUpToString:@"__" intoString:nil]; // Scan all characters before next #
        }
        
        for (NSString *strTemp in substrings) {
            strTempEmojiString = [strTempEmojiString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"__%@__",strTemp] withString:@"^"];
        }
        
        if (strTempEmojiString.length>range.location) {
            
            NSString *tmpFirst = [strTempEmojiString substringWithRange:NSMakeRange(0, range.location)];
            NSString *tmpString = [strTempEmojiString substringFromIndex:range.location];
            
            NSString *orifinalString = [NSString stringWithFormat:@"%@%@%@",tmpFirst,text,tmpString];
            
            for (NSString *strTemp in substrings) {
                NSRange rOriginal = [orifinalString rangeOfString: @"^"];
                if (NSNotFound != rOriginal.location) {
                    orifinalString = [[NSMutableString alloc] initWithString:[orifinalString stringByReplacingCharactersInRange:rOriginal withString:[NSString stringWithFormat:@"__%@__",strTemp]]];
                }
                
                //orifinalString = [orifinalString stringByReplacingOccurrencesOfString:@"^" withString:[NSString stringWithFormat:@"__%@__",strTemp]];
            }
            emojiString = [[NSMutableString alloc] initWithString:orifinalString];
        } else {
            
            emojiString = [[NSMutableString alloc] initWithString:strTempEmojiString];
            [emojiString insertString:text atIndex:range.location];
            if (substrings.count !=0) {
                for (NSString *strTempEm in substrings) {
                    NSRange rOriginal = [emojiString rangeOfString: @"^"];
                    if (NSNotFound != rOriginal.location) {
                        emojiString = [[NSMutableString alloc] initWithString:[emojiString stringByReplacingCharactersInRange:rOriginal withString:[NSString stringWithFormat:@"__%@__",strTempEm]]];
                    }
                }
            }
        }
    }
    
    
    return true;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if(!ifEmojiIsSelected && [self.msgTextView.attributedText.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0 && ![self.msgTextView.attributedText.string isEqualToString:defaultMessageText.string] && !keyboardAreaShown && isSendButtonActive) {
        [self sendMessageWithText:textView.text media:nil];
        self.msgTextView.attributedText = defaultMessageText;
    } else if (ifEmojiIsSelected && emojiString.length>0 && !keyboardAreaShown && isSendButtonActive) {
        [self sendMessageWithText:emojiString media:nil];
        self.msgTextView.attributedText = defaultMessageText;
    }
    else if ([self.msgTextView.attributedText.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        self.msgTextView.attributedText = defaultMessageText;
    
    
    if (!keyboardAreaShown) {
        [self.msgTextView setTranslatesAutoresizingMaskIntoConstraints:YES];
        [self.msgTextView setFrame:CGRectMake(self.msgTextView.frame.origin.x, self.msgTextView.frame.origin.y, self.cameraBtn.frame.origin.x-40, self.msgTextView.frame.size.height)];
    } else {
        [self setViewMovedUp:YES withKeyBoardSize:CGSizeZero];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if(!self.audioPeakVew.hidden)
    {
        [self cancelSendingAudio:nil];
    }
    
    if([textView.attributedText.string isEqualToString:defaultMessageText.string]){
        self.msgTextView.attributedText = tempMessageText;
        self.msgTextView.attributedText = emptyMessageText;
    }
    keyboardAreaShown = false;
    [[self.viewChatBox viewWithTag:90] removeFromSuperview];
    [self.keyboardBtn setSelected:NO];
    [self.msgTextView becomeFirstResponder];
    
    [self.msgTextView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.msgTextView setFrame:CGRectMake(self.msgTextView.frame.origin.x, self.msgTextView.frame.origin.y, self.sendBtn.frame.origin.x-40, self.msgTextView.frame.size.height)];
}

#pragma mark IBAction
- (IBAction)backAction:(id)sender {
    
    if(inSelecionMode)
        [self removeSelectionMode];
    else{
        self.backBtn.enabled = false;
        self.msgTextView.delegate = nil;
        [self.navigationController popViewControllerAnimated:YES];
//        for (UIViewController *controller in appDelegate.objNavigationController.viewControllers) {
//            if([controller isKindOfClass:[ChatListViewController class]]){
//                
//                [appDelegate.objNavigationController popToViewController:controller animated:NO];
//                [(ChatListViewController *)controller newChatMessageInitiated:NO withText:nil];
//                
//            }
//        }
    }
}

- (IBAction)addFriendAction:(id)sender {
    
    ChatMessageObject *chatMessage = [ChatMessageObject getEntityFor:oj_NOTIFY ackType:NOACK chatType:PRIVATE notifyType:ny_PRIVATE_FRIEND_REQUEST msgReqType:NOMSGREQ clientMsgID:-1 id:nil org_id:nil msgLife:0 msgDetails:nil status:nil nTimesSent:0 timeFirstSent:0 timeLastSent:0 tx_id:self.cardObject.id_ tx_name:nil tx_uname:nil tx_avatar_id:nil tx_avatar_uname:nil msgText:nil rx_id:@[[SocketStream sharedSocketObject].userID] rxg_id:nil mediaObject:nil];
    
    [[SocketStream sharedSocketObject] sendMessage:chatMessage];
    //[appDelegate startPopUpMessage:self.view withText:NSLocalizedString(@"Friend Request Sent!", nil)];
    
    
}
- (IBAction)forwardAction:(id)sender {
    
    if(![selectedChatIDs count]){
        //ShowAlert(AppName,NSLocalizedString(@"Please select any chat message to copy.", nil));
    }
    else{
        [self copyAndSendAllSelectedMessages];
        [self removeSelectionMode];
    }
    
}

- (IBAction)deleteAction:(UIButton *)sender {
    if(![selectedChatIDs count]){
        //ShowAlert(AppName,NSLocalizedString(@"Please select any chat message to copy.", nil));
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ChitChat" message:NSLocalizedString(@"Are you sure you want to delete message(s)?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
        alertView.tag = 20;
        [alertView show];
    }
}

- (IBAction)moreOptionAction:(UIButton *)sender {
    if(!self.audioPeakVew.hidden)
    {
        [self cancelSendingAudio:nil];
    }
    
    if(self.morePopUpView.hidden){
        self.collectionView.userInteractionEnabled = NO;
        self.morePopUpView.hidden = NO;
    }
    else{
        self.collectionView.userInteractionEnabled = YES;
        self.morePopUpView.hidden = YES;
    }
    
    [self.reportUserBtn setTitle:NSLocalizedString (@"Report Offensive User",nil) forState:UIControlStateNormal];
    [self.contentReportBtn setTitle:NSLocalizedString (@"Report Objectionable Content",nil) forState:UIControlStateNormal];
    [self.reportGrpContent setTitle:NSLocalizedString (@"Report Group Objectionable Content",nil) forState:UIControlStateNormal];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language rangeOfString:@"ar"].location != NSNotFound) {
        [self.contentReportBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.reportUserBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.reportGrpContent setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        
        [self.contentReportBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 15)];
        [self.reportUserBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 15)];
        [self.reportGrpContent setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 15)];
    }
}

-(void)removeSelectionMode{
    
    inSelecionMode = NO;
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    [selectedChatIDs enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if(imageFilterActive){
            [indexPaths addObject:[NSIndexPath indexPathForItem:[[self getMediaMessages] indexOfObject:obj] inSection:0]];
        }
        else{
            [indexPaths addObject:[NSIndexPath indexPathForItem:[individualChatData indexOfObject:obj] inSection:0]];
            
        }
        
    }];
    
    [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    [self.backBtn setImage:[UIImage imageNamed:@"back-arrow.png"] forState:UIControlStateNormal];
    self.deleteBtn.hidden = true;
    self.forwardBtn.hidden = true;
    self.soundSpacingHConstraint.constant = BUTTON_SPACING_ON_NORMAL_MODE;
    [selectedChatIDs removeAllObjects];
    self.collectionView.userInteractionEnabled = YES;
    self.morePopUpView.hidden = YES;
}

-(void)deleteAllSelectedMessages
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id_ IN %@ OR SELF.clientMsgID IN %@",selectedChatIDs,selectedChatIDs];
    NSArray *chatMessages = [individualChatData filteredArrayUsingPredicate:predicate];
    
    @synchronized(individualChatData)
    {
        [individualChatData removeObjectsInArray:chatMessages];
        [self.collectionView reloadData];
        [[SocketStream sharedSocketObject] deleteMessages:chatMessages];
    }
}

-(void)copyAndSendAllSelectedMessages
{
  }

- (IBAction)soundAction:(id)sender {
  
}

- (IBAction)settingsAction:(id)sender {
}

- (IBAction)cameraAction:(id)sender {
    
    if(!self.audioPeakVew.hidden)
    {
        [self cancelSendingAudio:nil];
    }
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = hasCamera ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
    
}

- (IBAction)belowMikeAction:(id)sender {
    
    if (!self.moreOptionsView.hidden)
        self.moreOptionsView.hidden = true;
    
    if(!self.audioPeakVew.hidden)
    {
        [self cancelSendingAudio:nil];
    }
    else{
        self.audioPeakVew.hidden = false;
        
        self.cancelAudioBtn.hidden = true;
        self.peakAudioMsg.hidden = true;
        self.sendAudioMsg.hidden = true;
        self.audioPlayBtn.hidden = true;
        self.audioScrubber.hidden = true;
        self.audioRightTimerlabel.hidden = true;
        
        self.audioRecordingIcon.hidden = false;
        self.audioTimerLabel.hidden = false;
        
        self.audioTimerLabel.text = [self getTimeStringFromAudio:true];
    }
    
}

- (IBAction)smilyAction:(id)sender {
}

- (IBAction)sendAction:(id)sender {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    if( [userdefaults boolForKey:@"userLoggedIn"])
        [[SocketStream sharedSocketObject] restartSocket];
    
        isSendButtonActive = true;
        if([self.msgTextView isFirstResponder])
            [self.msgTextView resignFirstResponder];
        else{
            [self closeEmojiKeyboard];
            [self textViewDidEndEditing:self.msgTextView];
        }
}

- (IBAction)moreAction:(id)sender {
    self.moreOptionsView.hidden = !self.moreOptionsView.hidden;
}

- (IBAction)peakBtnClicked:(UIButton *)sender {
    isSendButtonActive = true;
    currentMessagePeaked = YES;
    if([self.msgTextView isFirstResponder])
        [self.msgTextView resignFirstResponder];
    else{
        [self closeEmojiKeyboard];
        [self textViewDidEndEditing:self.msgTextView];
    }
}



-(void)postDeleted{
    [self reloadView];
}

- (IBAction)reportOffensiveUser:(UIButton *)sender {
    
 
}

- (IBAction)reportOffensiveContent:(UIButton *)sender {
   }


#pragma mark Emoji/Sticker Keyboard Action
- (IBAction)btnKeyboard_ButtonAction:(id)sender {
    
}

-(void)closeEmojiKeyboard{
    keyboardAreaShown = false;
    [self.keyboardBtn setSelected:false];
    [self setViewMovedUp:NO withKeyBoardSize:CGSizeZero];
    [[self.viewChatBox viewWithTag:90] removeFromSuperview];
    [self.view removeGestureRecognizer:disMissKeyboard];
    if([self.msgTextView.attributedText.string isEqualToString:emptyMessageText.string])
        self.msgTextView.attributedText = defaultMessageText;
    [self.msgTextView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.msgTextView setFrame:CGRectMake(self.msgTextView.frame.origin.x, self.msgTextView.frame.origin.y, self.cameraBtn.frame.origin.x-40, self.msgTextView.frame.size.height)];
}


-(void)dismissKeyboard{
    
    self.moreOptionsView.hidden = true;
    if(!self.audioPeakVew.hidden)
    {
        [self cancelSendingAudio:nil];
    }
    sendEnabled = true;
    isSendButtonActive = false;
    if(!keyboardAreaShown)
        [self.msgTextView resignFirstResponder];
    else
        [self closeEmojiKeyboard];
    [self.view removeGestureRecognizer:disMissKeyboard];
    
}


-(void)keyboardWillShow:(NSNotification *)aNotification{
    
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    kbSize.height = kbSize.height - 216;
    
    
    [self setViewMovedUp:YES withKeyBoardSize:kbSize];
    
}
-(void)keyboardWillHide:(NSNotification *)aNotification{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self setViewMovedUp:NO withKeyBoardSize:kbSize];
    
    
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp withKeyBoardSize:(CGSize)kbSize
{
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    CGRect frame = self.viewChatBox.frame;

    if (movedUp)
    {
        self.VSpaceKeyboardView.constant =  kbSize.height;
        self.verticalCollectionViewContraint.constant = 0;
        self.viewChatBox.frame = CGRectMake(frame.origin.x, frame.origin.y-216, frame.size.width, frame.size.height);
    }
    else
    {
        self.VSpaceKeyboardView.constant = -216;
        self.verticalCollectionViewContraint.constant = 0;
        self.viewChatBox.frame = CGRectMake(frame.origin.x, frame.origin.y+216, frame.size.width, frame.size.height);

    }
    
    [UIView commitAnimations];
    
    if(movedUp){
        self.moreOptionsView.hidden = true;
        self.smilyBtn.hidden = NO;
        self.sendBtn.hidden = NO;
        
        self.cameraBtn.hidden = YES;
        self.mikeBtn.hidden = YES;
        self.moreBtn.hidden = YES;
        self.sepratorIcon1.hidden = YES;
        self.sepratorIcon2.hidden = YES;
        
        self.cameraTextHSpace.constant = -(screenWidth -self.cameraBtn.frame.origin.x-10-self.sendBtn.frame.size.width);
        self.smilyTextHSpace.constant = 15;
        [self.view addGestureRecognizer:disMissKeyboard];
        self.collectionView.allowsSelection = NO;
        
    }
    else{
        [self.view removeGestureRecognizer:disMissKeyboard];
        self.collectionView.allowsSelection = YES;
        self.smilyBtn.hidden = YES;
        self.sendBtn.hidden = YES;
        
        self.sepratorIcon1.hidden = NO;
        self.sepratorIcon2.hidden = NO;
        
        self.cameraBtn.hidden = NO;
        self.mikeBtn.hidden = NO;
        self.moreBtn.hidden = NO;
        self.smilyTextHSpace.constant = -32;
        self.cameraTextHSpace.constant = 19;
        
        [self.sendBtn setSelected:false];
        self.peakBtn.hidden = YES;
        
        
        
    }
}

- (NSUInteger)characterCount:(NSString *) string {
    NSUInteger cnt = 0;
    NSUInteger index = 0;
    while (index < string.length) {
        
        NSRange range = [string rangeOfComposedCharacterSequenceAtIndex:index];
        cnt++;
        index += range.length;
    }
    
    return cnt;
}


-(void)downlaodEmojiImageForIndex:(NSInteger)rowIndex withID:(NSArray *)imageIDs{
    
    if([imageIDs count]){
        NSMutableSet *idSet = [NSMutableSet setWithArray:imageIDs];
        [idSet minusSet:imageIDCache];
        [imageIDCache unionSet:idSet];
        if(idSet.count)
            [self callSeviceToDownloadIndividualSetImage:[idSet allObjects] forIndex:rowIndex forEmoji:([imageIDs count]>1)];
    }
}

-(void)scrollTextViewToBottom:(UITextView *)textView {
    if(textView.text.length > 0 ) {
        NSRange bottom = NSMakeRange(textView.text.length -1, 1);
        [textView scrollRangeToVisible:bottom];
    }
    
}

#pragma mark ImagePicker Controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    
//    if ([type isEqualToString:(NSString *)kUTTypeVideo] ||
//        [type isEqualToString:(NSString *)kUTTypeMovie])
//    {
//        NSURL *urlvideo = [info objectForKey:UIImagePickerControllerMediaURL];
//        
//        EditImageViewController *editController = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil] instantiateViewControllerWithIdentifier:@"EditImageViewScene"];
//        editController.videoURL = urlvideo;
//        editController.delegate = self;
//        editController.forMessage = true;
//        [appDelegate.objNavigationController pushViewController:editController animated:YES];
//        
//    } else if ([type isEqualToString:(NSString *)kUTTypeImage]){
//        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        
//        EditImageViewController *editController = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil] instantiateViewControllerWithIdentifier:@"EditImageViewScene"];
//        editController.image = image;
//        editController.delegate = self;
//        editController.forMessage = true;
//        [appDelegate.objNavigationController pushViewController:editController animated:YES];
//        
//    } else {
//        
//    }
}

- (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
                                     handler:(void (^)(AVAssetExportSession*))handler
{
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(exportSession);
     }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)MPMoviePlayerThumbnailImageRequestDidFinishNotification:(NSNotification *)notif{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                                  object:moviePlayer];
    
    UIImage *image = [notif.userInfo objectForKey:MPMoviePlayerThumbnailImageKey];
    MediaObject *mediaObj = [MediaObject getEntityFor:tempVideoData lowRes:[Utility compressImage:image ImageData:nil forThumbnail:YES] mediaFormat:mt_MP4 mediaType:ma_VIDEO mediaPath:nil];
    tempVideoData = nil;
    
    [self sendMessageWithText:nil media:mediaObj];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopMusic];
    
}


#pragma mark Cell Gesture
-(void)cellLongTapped:(UILongPressGestureRecognizer *)sender{
    if (sender.state != UIGestureRecognizerStateEnded) {
        return;
    }
    if(!inSelecionMode){
        
        
        CGPoint p = [sender locationInView:self.collectionView];
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
        if(indexPath){
            ChatMessageObject *msgObj = (ChatMessageObject *)((imageFilterActive) ? [self getMediaMessages] :individualChatData[indexPath.item]);
            
            if([self isNormalMessage:msgObj] || [self isMessageSent:msgObj byCardId:self.cardObject.id_]){
                
                inSelecionMode = YES;
                self.deleteBtn.hidden = false;
                self.forwardBtn.hidden = false;
                self.soundSpacingHConstraint.constant = BUTTON_SPACING_ON_SELECTION_MODE;
                [self.backBtn setImage:[UIImage imageNamed:@"icon-close.png"] forState:UIControlStateNormal];
                //  [selectedChatMessages addIndex:indexPath.item];
                [selectedChatIDs addObject:msgObj.id_ ? : msgObj.clientMsgID];
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }
        
    }
}


- (IBAction)imageFilterBtnClicked:(UIButton *)sender {
    
    imageFilterActive = !imageFilterActive;
    [self.collectionView reloadData];
    
    if((imageFilterActive && [[self getMediaMessages] count]) || (!imageFilterActive && [individualChatData count]))
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(imageFilterActive) ? [[self getMediaMessages] count] -1 : [individualChatData count]-1 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionBottom
                                            animated:YES];
    
    if(imageFilterActive)
        [self.imgFilterBtn setImage:[UIImage imageNamed:@"icons-show-photos-active.png"] forState:UIControlStateNormal];
    else
        [self.imgFilterBtn setImage:[UIImage imageNamed:@"icons-show-photos-inactive.png"] forState:UIControlStateNormal];
    
    
}



-(NSArray *)getMediaMessages{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.media_relationship !=nil OR SELF.msgDetails = %@",StickerMessageIdentifier];
    return [individualChatData filteredArrayUsingPredicate:predicate];
}




- (IBAction)galleryActionTapped:(UIButton *)sender {
    
    
    self.moreOptionsView.hidden = true;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    if (![sourceTypes containsObject:(NSString *)kUTTypeMovie ])
    {
        //NSLog(@"no video");
    }
    
    
    if(sender.tag == 1){
        //video
        imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        
    }
    else if (sender.tag == 2){
        //Audio
        
        MPMediaPickerController *picker=[[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
        picker.showsCloudItems = NO;
        
        [picker setDelegate:self];
        [self presentViewController:picker animated:YES completion:nil];
        
        
    }
    else if (sender.tag == 3){
        //Image
        imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        
    }
    
    
    
}

#pragma mark Video Media Delegate
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    
    if(mediaItemCollection.items && [mediaItemCollection.items count]){
        
        MPMediaItem *anItem = (MPMediaItem *)[mediaItemCollection.items objectAtIndex:0];
        [mediaPicker dismissViewControllerAnimated:false completion:nil];
        [mediaPicker dismissMoviePlayerViewControllerAnimated];
        [appDelegate startActivityIndicator:self.view withText:Progressing];
        
        // Implement in your project the media item picker
        [self mediaItemToData:anItem];
        
    }
    else{
        [mediaPicker dismissViewControllerAnimated:false completion:nil];
        [mediaPicker dismissMoviePlayerViewControllerAnimated];
        
    }
    
}

-(void)mediaItemToData : (MPMediaItem * ) curItem
{
    NSURL *url = [curItem valueForProperty: MPMediaItemPropertyAssetURL];
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL: url options:nil];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset: songAsset
                                                                      presetName:AVAssetExportPresetAppleM4A];
    
    exporter.outputFileType =   @"com.apple.m4a-audio";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * myDocumentsDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    [[NSDate date] timeIntervalSince1970];
    NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
    NSString *intervalSeconds = [NSString stringWithFormat:@"%0.0f",seconds];
    
    NSString * fileName = [NSString stringWithFormat:@"%@.m4a",intervalSeconds];
    
    NSString *exportFile = [myDocumentsDirectory stringByAppendingPathComponent:fileName];
    
    NSURL *exportURL = [NSURL fileURLWithPath:exportFile];
    exporter.outputURL = exportURL;
    
    // do the export
    // (completion handler block omitted)
    __weak typeof(self) weakSelf = self;
    
    [exporter exportAsynchronouslyWithCompletionHandler:
     ^{
         int exportStatus = exporter.status;
         
         switch (exportStatus)
         {
             case AVAssetExportSessionStatusCompleted:
             {
                 NSLog (@"AVAssetExportSessionStatusCompleted");
                 
                 NSData *data = [NSData dataWithContentsOfFile: [myDocumentsDirectory
                                                                 stringByAppendingPathComponent:fileName]];
                 MediaObject *mediaObj = [MediaObject getEntityFor:data lowRes:nil mediaFormat:mt_M4A mediaType:ma_AUDIO mediaPath:nil];
                 
                 [weakSelf sendMessageWithText:nil media:mediaObj];
                 
                 
                 break;
             }
             case AVAssetExportSessionStatusFailed:
             {
                 NSError *exportError = exporter.error;
                 NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                 break;
             }
                 
             case AVAssetExportSessionStatusUnknown:
             {
                 NSLog (@"AVAssetExportSessionStatusUnknown"); break;
             }
             case AVAssetExportSessionStatusExporting:
             {
                 NSLog (@"AVAssetExportSessionStatusExporting"); break;
             }
             case AVAssetExportSessionStatusCancelled:
             {
                 NSLog (@"AVAssetExportSessionStatusCancelled"); break;
             }
             case AVAssetExportSessionStatusWaiting:
             {
                 NSLog (@"AVAssetExportSessionStatusWaiting"); break;
             }
             default:
             {
                 NSLog (@"didn't get export status");
                 break;
             }
         }
     }];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
}

// Audio Record Steps:
// If tapped then show slide to cancel view by sliding and also help view
// If long presses then show slide to cancel view by sliding
// start timer for audio
// On tap on help view hide it
// On slide cancel and delete audio
// On touch up..send the recorded audio


- (void) startRecording{
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder recordForDuration:MAX_RECORD_DURATION*60];
    }
    else{
        
        // Start recording
        [recorder recordForDuration:MAX_RECORD_DURATION*60];
    }
    
}

- (void) stopRecording{
    
    [recorder stop];
    [self.mikeBtn setImage:[UIImage imageNamed:@"icon_009.png"] forState:UIControlStateNormal];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
    // your actions here
    
    
    NSError *err = nil;
    currentRecordedData = [NSData dataWithContentsOfFile:[recorder.url path] options: 0 error:&err];
    if(isRecording)
        [self mikeRecorderAction:nil];
    
}

-(void)playAudioForIndex:(NSInteger)rowIndex{
    
    ChatMessageObject *messageObj;
    
    if(imageFilterActive)
        messageObj = [self getMediaMessages][rowIndex];
    else
        messageObj = individualChatData[rowIndex];
    
    if(!messageObj.media_relationship.highRes) {
        
        NSString *highResURL = messageObj.media_relationship.url_highRes;
        
        
        //download the file in a seperate thread.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"Downloading Started");
            NSURL  *url = [NSURL URLWithString:highResURL];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if ( urlData )
            {
                NSString *moviePath = [[Utility getDocumentPath] stringByAppendingPathComponent:@"audio.m4a"];
                
                //saving is done on main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [urlData writeToFile:moviePath atomically:YES];
                    [mediaDownloadInProgress removeObject:messageObj.id_];
                    
                    messageObj.media_relationship.highRes = urlData;
                    [DatabaseHelper saveDBManagedContext];
                    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:rowIndex inSection:0]]];
                    NSLog(@"File Saved !");
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //ShowAlert(AlertTitle, NSLocalizedString(@"Video download failed.", nil));
                    [appDelegate stopActivityIndicator];
                });
            }
            
        });
        
        
        [mediaDownloadInProgress addObject:messageObj.id_];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:rowIndex inSection:0]]];
    }
    
    else{
        
        if (updateTimer)
            [updateTimer invalidate];
        
        if (isAudioPlaying) {
            [player stop];
            isAudioPlaying = false;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id_ = %@ || SELF.clientMsgID.stringValue = %@",currentMessageAudioPlaying,currentMessageAudioPlaying];
            currentMessageAudioPlaying = (messageObj.id_) ? : [messageObj.clientMsgID stringValue];
            
            NSArray *msgArray =[individualChatData filteredArrayUsingPredicate:predicate];
            if(msgArray && [msgArray count])
            {
                ChatMessageObject *chatObj = msgArray[0];
                NSInteger index = (imageFilterActive) ? [[self getMediaMessages] indexOfObject:chatObj] : [individualChatData indexOfObject:chatObj];
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
            }
            
            currentMessageAudioPlaying = @"";
        }
        else{
            isAudioPlaying = true;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id_ = %@ || SELF.clientMsgID.stringValue = %@",currentMessageAudioPlaying,currentMessageAudioPlaying];
            currentMessageAudioPlaying = (messageObj.id_) ? : [messageObj.clientMsgID stringValue];
            
            NSArray *msgArray =[individualChatData filteredArrayUsingPredicate:predicate];
            if(msgArray && [msgArray count])
            {
                ChatMessageObject *chatObj = msgArray[0];
                NSInteger index = (imageFilterActive) ? [[self getMediaMessages] indexOfObject:chatObj] : [individualChatData indexOfObject:chatObj];
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
            }
            
            
            NSData *msgAudioData = (messageObj.media_relationship.highRes) ? : (messageObj.media_relationship.lowRes);
            NSError *error;
            
            player = [[AVAudioPlayer alloc] initWithData:msgAudioData error:&error];
            [player setDelegate:self];
            player.volume = 1;
            [player play];
            
            
            updateTimer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
            
            
        }
    }
}


#pragma mark Audio Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    if (isAudioPlaying) {
        isAudioPlaying = false;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id_ = %@ || SELF.clientMsgID.stringValue = %@",currentMessageAudioPlaying,currentMessageAudioPlaying];
        NSArray *msgArray =[individualChatData filteredArrayUsingPredicate:predicate];
        if(msgArray && [msgArray count])
        {
            ChatMessageObject *chatObj = msgArray[0];
            NSInteger index = (imageFilterActive) ? [[self getMediaMessages] indexOfObject:chatObj] : [individualChatData indexOfObject:chatObj];
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        }
        currentMessageAudioPlaying = @"";
        
    }
    else if (isRecordedAudioPlaying)
    {
        [self playRecordedAudio:nil];
    }
    
    
    if (updateTimer)
        [updateTimer invalidate];
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    isAudioPlaying = false;
    
}

#pragma mark ImageEditViewControllerDelegate

- (void)imageEditViewControllerDidCancel{
    
}

- (void)imageEditViewControllerDidEditWithImage:(UIImage *)editedImage withAction:(BOOL)ifPeaked{
    
    
    [[SocketStream sharedSocketObject].library saveImage:[Utility compressImage:editedImage forThumbnail:NO] toAlbum:@"Zargow" completion:^(NSURL *assetURL, NSError *error) {
        
    } failure:^(NSError *error) {
        
    }];
    if(ifPeaked)
        currentMessagePeaked = YES;
    
    
    MediaObject *mediaObj = [MediaObject getEntityFor:[Utility compressImage:editedImage ImageData:nil forThumbnail:NO] lowRes:[Utility compressImage:editedImage ImageData:nil forThumbnail:YES] mediaFormat:mt_JPG mediaType:ma_IMAGE mediaPath:nil];
    
    [self sendMessageWithText:nil media:mediaObj];
    
}

- (void)imageEditViewControllerDidSelectWithVideoURL:(NSURL *)urlvideo withAction:(BOOL)ifPeaked{
    
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:urlvideo];
    moviePlayer.shouldAutoplay = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerThumbnailImageRequestDidFinishNotification:)
                                                 name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                               object:moviePlayer];
    
    
    [[SocketStream sharedSocketObject].library saveVideo:urlvideo toAlbum:@"Zargow" completion:^(NSURL *assetURL, NSError *error) {
        
    } failure:^(NSError *error) {
        
    }];
    
    if(ifPeaked)
        currentMessagePeaked = YES;
    
    NSString *moviePath = [[Utility getDocumentPath] stringByAppendingPathComponent:@"Video.MOV"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    [self convertVideoToLowQuailtyWithInputURL:urlvideo outputURL:movieURL handler:^(AVAssetExportSession *exportSession)
     {
         if (exportSession.status == AVAssetExportSessionStatusCompleted)
         {
             printf("completed\n");
             tempVideoData =  [NSData dataWithContentsOfFile:moviePath];
             
             [moviePlayer requestThumbnailImagesAtTimes:@[@0.0f] timeOption:MPMovieTimeOptionNearestKeyFrame];
         }
         else
         {
             printf("error\n");
             
            // ShowAlert(AlertTitle, NSLocalizedString(@"Error occured", nil))
         }
     }];
    
}

#pragma mark Audio Sending Methods

- (IBAction)cancelSendingAudio:(UIButton *)sender {
    if(isRecordedAudioPlaying){
        [self playRecordedAudio:nil];
    }
    if(isRecording)
        [self mikeRecorderAction:nil];
    
    if(recorder){
        if ([[NSFileManager defaultManager] fileExistsAtPath:recorder.url.path]) {
            if (![recorder deleteRecording])
                NSLog(@"Failed to delete %@", recorder.url);
        }
    }
    currentRecordedData = nil;
    self.audioPeakVew.hidden = true;
    
}

- (IBAction)peakAudioMsg:(UIButton *)sender {
    
    currentMessagePeaked = true;
    [self sendRecordedData];
    
}

- (IBAction)sendAudioMsg:(UIButton *)sender {
    
    [self sendRecordedData];
    
}

-(void)sendRecordedData{
    
    MediaObject *mediaObj = [MediaObject getEntityFor:currentRecordedData lowRes:nil mediaFormat:mt_M4A mediaType:ma_AUDIO mediaPath:nil];
    [self sendMessageWithText:nil media:mediaObj];
    currentRecordedData = nil;
    self.audioPeakVew.hidden = true;
    if(recorder){
        if ([[NSFileManager defaultManager] fileExistsAtPath:recorder.url.path]) {
            if (![recorder deleteRecording])
                NSLog(@"Failed to delete %@", recorder.url);
        }
    }
}

- (IBAction)playRecordedAudio:(UIButton *)sender {
    
    if(isRecordedAudioPlaying){
        if (updateTimer)
            [updateTimer invalidate];
        [player stop];
        isRecordedAudioPlaying = false;
        [self.audioPlayBtn setImage:[UIImage imageNamed:@"btn-play.png"] forState:UIControlStateNormal];
    }
    else{
        NSError *error;
        
        player = [[AVAudioPlayer alloc] initWithData:currentRecordedData error:&error];
        [player setDelegate:self];
        
        player.volume = 1;
        [player play];
        isRecordedAudioPlaying = true;
        [self.audioPlayBtn setImage:[UIImage imageNamed:@"stop-button.png"] forState:UIControlStateNormal];
        
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateRecordedMusicTime) userInfo:nil repeats:YES];
        
    }
}

- (IBAction)mikeRecorderAction:(UIButton *)sender {
    
    if(isRecording){
        
        isRecording = false;
        [self stopRecording];
        if (recorderTimer)
            [recorderTimer invalidate];
        
        self.cancelAudioBtn.hidden = false;
        self.peakAudioMsg.hidden = false;
        self.sendAudioMsg.hidden = false;
        self.audioPlayBtn.hidden = false;
        self.audioScrubber.value = 0;
        self.audioScrubber.hidden = false;
        self.audioRightTimerlabel.hidden = false;
        [self.audioRecordingIcon setImage:[UIImage imageNamed:@"icon_009.png"] forState:UIControlStateNormal];
        
        self.audioRightTimerlabel.text = [self getTimeStringFromAudio:true];
        self.audioRecordingIcon.hidden = true;
        self.audioTimerLabel.hidden = true;
        
        
        
    }
    else{
        isRecording = true;
        [self startRecording];
        recorderTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateRecordingMusicTime) userInfo:nil repeats:YES];
        
        [self.audioRecordingIcon setImage:[UIImage imageNamed:@"icon-mic.png"] forState:UIControlStateNormal];
        self.audioTimerLabel.text = [self getTimeStringFromAudio:true];
        
    }
    
    
}

- (void)updateRecordedMusicTime
{
    
    if(isRecordedAudioPlaying){
        [self.audioPlayBtn setImage:[UIImage imageNamed:@"stop-button.png"] forState:UIControlStateNormal];
        self.audioRightTimerlabel.text = [self getTimeStringFromAudio:false];
        self.audioScrubber.maximumValue = player.duration;
        self.audioScrubber.value = player.currentTime;
    }
    else{
        [self.audioPlayBtn setImage:[UIImage imageNamed:@"btn-play.png"] forState:UIControlStateNormal];
        self.audioRightTimerlabel.text = [self getTimeStringFromAudio:true];
        self.audioScrubber.maximumValue = 0;
        self.audioScrubber.value = 0;
        
    }
}



- (void)updateRecordingMusicTime
{
    self.audioTimerLabel.text = [self getTimeStringFromAudio:true];
}

-(NSString *)getTimeStringFromAudio:(BOOL)fromRecorder{
    
    float initialMinutes;
    float initialSeconds;
    
    float finalMinutes;
    float finalSeconds;
    
    if (fromRecorder) {
        initialMinutes = floor(recorder.currentTime/60);
        initialSeconds = recorder.currentTime - (initialMinutes * 60);
        
        finalMinutes = 2;
        finalSeconds = 0;
        
    }
    else{
        initialMinutes = floor(player.currentTime/60);
        initialSeconds = player.currentTime - (initialMinutes * 60);
        
        finalMinutes = floor(player.duration/60);
        finalSeconds = player.duration - (finalMinutes * 60);
        
    }
    
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%0.f:%.f/%0.f:%.f",
                      initialMinutes, initialSeconds,finalMinutes,finalSeconds];
    
    return time;
}


#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 20) {
        if(buttonIndex == 1){
            [self deleteAllSelectedMessages];
            [self removeSelectionMode];
        }
    } else {
        if (buttonIndex == 1) {
            NSLog(@"Yes");
            NSString *associatedString = objc_getAssociatedObject(alertView, &stickerCreatorKey);
            [self creatorLabelTapped:associatedString];
            
            //            NSLog(@"associated string: %@", associatedString);
            //
            //            ChannelViewController *channelController = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ChannelViewScene"];
            //            channelController.cardID = associatedString;
            //            channelController.isEmojiActive = YES;
            //            [appDelegate.objNavigationController pushViewController:channelController animated:YES];
        }
    }
}

#pragma mark Notifications

-(void) appWillResignActive:(NSNotification*)note{
    
    NSLog(@"App is going to the background");
    // This is where you stop the music
    [self stopMusic];
    
}

-(void) appWillTerminate:(NSNotification*)note{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    
    NSLog(@"App will terminate");
}

-(void)stopMusic{
    if(isAudioPlaying){
        [player stop];
        isAudioPlaying = false;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id_ = %@ || SELF.clientMsgID.stringValue = %@",currentMessageAudioPlaying,currentMessageAudioPlaying];
        NSArray *msgArray =[individualChatData filteredArrayUsingPredicate:predicate];
        if(msgArray && [msgArray count])
        {
            ChatMessageObject *chatObj = msgArray[0];
            NSInteger index = (imageFilterActive) ? [[self getMediaMessages] indexOfObject:chatObj] : [individualChatData indexOfObject:chatObj];
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        }
        
        currentMessageAudioPlaying = @"";
    }
}

- (FGTranslator *)translator {
    /*
     * using Bing Translate
     *
     * Note: The client id and secret here is very limited and is included for demo purposes only.
     * You must use your own credentials for production apps.
     */
    FGTranslator *translator = [[FGTranslator alloc] initWithBingAzureClientId:@"fgtranslator-demo" secret:@"GrsgBiUCKACMB+j2TVOJtRboyRT8Q9WQHBKJuMKIxsU="];
    
    // or use Google Translate
    
    // using Google Translate
    // translator = [[FGTranslator alloc] initWithGoogleAPIKey:@"your_google_key"];
    
    return translator;
}


- (void)translateText:(NSArray*)array atIndex:(NSUInteger)index{
    
    __block NSUInteger indexi = index;
    
//    [self.translator translateText:[chatListArr objectAtIndex:index] withSource:nil target:nil
//                        completion:^(NSError *error, NSString *translated, NSString *sourceLanguage)
//     {
//         indexi = indexi +1;
//         
//         if ([array count] == indexi) {
//             return ;
//         }
//         [self translateText:array atIndex:indexi];
//     }];

}



-(void)translateChatString:(NSMutableArray *)chatListArray withSource:(NSString *)source andDestination:(NSString *)destination {
    
//    if (chatListArr.count == 0) {
//        return;
//    }
//   __block int index = 0;
//    
//    while ( index < chatListArr.count )
//    {
//        [self.translator translateText:[chatListArr objectAtIndex:index] withSource:source target:destination
//                            completion:^(NSError *error, NSString *translated, NSString *sourceLanguage)
//         {
//             if (error)
//             {
//                 index++;
//
//             }
//             else
//             {
//                 
//                 
//                 index++;
//
//             }
//         }];
//
//    }
//    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
