//
//  ChatAreaViewController.m
//  CodersChat
//
//  Created by Vishal Bhadade on 12/02/16.
//  Copyright (c) 2016 GlobalLogic. All rights reserved.
//

#import "ChatAreaViewController.h"

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
#import <AudioToolbox/AudioServices.h>
#import "ChatAreaViewController+ChatDatasouce.h"
#import <objc/runtime.h>
#import "IndividualChatHeaderView.h"
#import "RequestHelper.h"
#import "SelectLanguageViewController.h"
#import "ChitChatFactoryContorller.h"

#import "ChitchatUserDefault.h"


@interface ChatAreaViewController ()<WebServiceHandlerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,MPMediaPickerControllerDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate, IndividualCellDelegate,UINavigationControllerDelegate>
{
    NSDateFormatter *dateFormatter;
    //NSMutableIndexSet *selectedChatMessages;
    NSMutableSet *selectedChatIDs;
    NSMutableSet *imageIDCache;
    
    MPMoviePlayerController *moviePlayer;
    UILongPressGestureRecognizer *longTapGesture;
    UITapGestureRecognizer *disMissKeyboard;
    
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


@property (weak, nonatomic) IBOutlet UIButton *languageButton;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *mikeBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *smilyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smilyTextHSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraTextHSpace;
@property (weak, nonatomic) IBOutlet UITextView *msgTextView;
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


@property (weak, nonatomic) IBOutlet UIButton *audioRecordingIcon;
@property (weak, nonatomic) IBOutlet UILabel *audioTimerLabel;
@property (weak, nonatomic) IBOutlet UIButton *audioPlayBtn;
@property (weak, nonatomic) IBOutlet UISlider *audioScrubber;
@property (weak, nonatomic) IBOutlet UILabel *audioRightTimerlabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelAudioBtn;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollectionView) name:@"UpdateCollection" object:nil];
    
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
                                             selector:@selector(getMessageAcknowledgement:)
                                                 name:@"AcknowledgementReceived"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refeshPreviousChat) name:@"REFERESH_CHAT_FOR_LANGUAGE_SELECTION" object:nil];
    
    
    
    
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

-(void)refeshPreviousChat {
    
//    NSString *selectedLanguage =   [ChitchatUserDefault lanuageCodeForSelectedLanaguge];
//    if (!selectedLanguage) {
//        selectedLanguage = @"en";
//    }
//    [self.translator translateText:((ChatMessageObject *)[individualChatData objectAtIndex:actualIndex]).msgText withSource:nil target:selectedLanguage
//                        completion:^(NSError *error, NSString *translated, NSString *sourceLanguage)
//     {
//         
//         
//     }];
    [self getAllMessagesConverted];
}
-(void)updateCollectionView{
    [self.collectionView reloadData];
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
    [self sendReadAcknowledgments];

    NSString *codeStr = [ChitchatUserDefault lanuageCodeForSelectedLanaguge];
    [self.languageButton setTitle:codeStr forState:UIControlStateNormal];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.msgTextView resignFirstResponder];

    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
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
        self.friendActiveStatus.text = @"";
        self.reportGrpContent.hidden = YES;
    }
    else{
        self.friendActiveStatus.text = @"Group";
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
        self.friendImage.image = [UIImage imageWithData:self.cardObject.image_relationship.lowRes] ;
        self.friendImage.layer.masksToBounds = NO;
        self.friendImage.layer.cornerRadius = self.friendImage.frame.size.width/2;
        self.friendImage.clipsToBounds = YES;
  
    
    if([self.cardObject.isFriend isEqualToNumber:@true])
    {
        self.add_FriendBtn.hidden = YES;
    }
    
    if([individualChatData count])
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[individualChatData count]-1 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionNone
                                            animated:YES];
}


#pragma mark Socket Acknowledgments

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
        
        ChatMessageObject *chatMessage = [ChatMessageObject getEntityFor:oj_MESSAGE ackType:NOACK chatType:PRIVATE notifyType:NONOTIFY msgReqType:NOMSGREQ clientMsgID:clientID id:nil org_id:nil msgLife:-1 msgDetails:(ifStickerIsSelected)?StickerMessageIdentifier:((ifEmojiIsSelected)?EmojiMessageIdentifier:nil) status:nil nTimesSent:1 timeFirstSent:clientID timeLastSent:clientID tx_id:[SocketStream sharedSocketObject].userID tx_name:nil  tx_uname:[SocketStream sharedSocketObject].userName tx_avatar_id:nil tx_avatar_uname:nil msgText:msgText rx_id:rxIDs rxg_id:rxgIDs mediaObject:mediaObj];
        
        [individualChatData addObject:chatMessage];

        [self getMessageConverted:chatMessage forIndex:individualChatData.count];
        
        [self.collectionView reloadData];
        
        if([individualChatData count])
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[individualChatData count]-1 inSection:0]
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

-(void)getMessage:(NSNotification *)aNotification{
    
    @synchronized(individualChatData)
    {
        ChatMessageObject *message = [aNotification object];
        
        
       if((([self.cardObject.cardType isEqualToString:[Utility CardTypeToString:cd_PRIVATE_GROUP]] && [[message getReceiverGroupIDs] containsObject:self.cardObject.id_]) || ([self.cardObject.cardType isEqualToString:[Utility CardTypeToString:cd_USER]] && [self.cardObject.id_ isEqualToString:message.tx_id]))  && ![[individualChatData valueForKeyPath:@"id_"] containsObject:message.id_]){
            
            [individualChatData addObject:message];
        [self getMessageConverted:message forIndex:individualChatData.count];

            [self.collectionView reloadData];
            
            if([individualChatData count])
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[individualChatData count]-1 inSection:0]
                                            atScrollPosition:UICollectionViewScrollPositionBottom
                                                    animated:YES];
            
            [self sendReadAcknowledgments];
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
    return [individualChatData count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row ==0)
    {
        
    }
    IndividualChatCell *cell;
    ChatMessageObject *messageObj = individualChatData[indexPath.item];
    
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


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatMessageObject *messageObj = (ChatMessageObject *)individualChatData[indexPath.row];
    
    
    if (ma_AUDIO == [Utility MediaTypeFromString:((ChatMessageObject *)individualChatData[indexPath.row]).media_relationship.mediaType]){
        
        if([messageObj.msgType isEqualToString:[Utility MessageTypeToString:mg_SEND_BROADCAST]])
            return  CGSizeMake(screenWidth,110);
        else
            return  CGSizeMake(screenWidth,90);
        
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
            
//            [self translateText:individualChatData atIndex:0];
            
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
  
        self.backBtn.enabled = false;
        self.msgTextView.delegate = nil;
        [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)sendAction:(id)sender {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    if( [userdefaults boolForKey:@"userLoggedIn"])
        [[SocketStream sharedSocketObject] restartSocket];
    
        isSendButtonActive = true;
        if([self.msgTextView isFirstResponder])
            [self.msgTextView resignFirstResponder];
        else{
            [self textViewDidEndEditing:self.msgTextView];
        }
    
}


-(void)dismissKeyboard{
    
    self.moreOptionsView.hidden = true;
    sendEnabled = false;
    isSendButtonActive = false;
    [self.msgTextView resignFirstResponder];
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

       CGRect frame = self.viewChatBox.frame;
    self.viewChatBox.frame = CGRectMake(frame.origin.x, frame.origin.y-216, frame.size.width,frame.size.height);
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
        
        
        
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)selectLangugeButton:(id)sender {
    SelectLanguageViewController *selectLngVc = (SelectLanguageViewController*)[ChitChatFactoryContorller viewControllerForType:ViewControllerTypeSelectLanguage];
    [self.navigationController pushViewController:selectLngVc animated:YES];
}









//-(void)translateChatString:(NSMutableArray *)chatListArray withSource:(NSString *)source andDestination:(NSString *)destination {
//    
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
//    
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
