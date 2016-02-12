//
//  ChatListViewController.m
//  CodersChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//
//
//  ChatListViewController.m
//  Zargow
//
//  Created by Northout_101 on 28/01/15.
//  Copyright (c) 2015 Northout. All rights reserved.
//

#import "ChatListViewController.h"
#import "WebserviceHandler.h"
#import <AddressBook/AddressBook.h>
#import "ChatListCell.h"
#import "ChatAreaViewController.h"
#import "ChatMessageObject.h"
#import "SocketStream.h"
#import "RequestHelper.h"
#import "VcardObject.h"
#import "ChitChatFactoryContorller.h"

#import "AddGroupController.h"
#import "SyncUser.h"
#import "MediaObject.h"
#import "Utility.h"

#define RADAR_SECONDS 3600

@interface ChatListViewController ()<WebServiceHandlerDelegate,AlertDialogProgressViewDelegate,UserSyncDelegate>{
    int friendCardsToBeFetched;
    BOOL currentMessagePeaked;
    BOOL isRadarON;
    BOOL isTimerON;
    
    NSMutableSet *radarCardIDs;
    NSMutableArray *radarCardIDArray;
    NSMutableSet *friendRequestCardIDArray;
    NSMutableSet *friendAceeptCardIDArray;
    NSMutableSet *friendAddedCardIDArray;
    
    
    int fetchedIndex;
    int lastFetchedIndex;
    NSTimer *timer;
    int hours, minutes, seconds;
    int secondsLeft;
    
    
}

@property (weak, nonatomic) IBOutlet UIView *settingPopUpView;
@property (weak, nonatomic) IBOutlet UIView *profilePopUpView;
@property (weak, nonatomic) IBOutlet UIImageView *popUpUserImageView;
@property (weak, nonatomic) IBOutlet UIImageView *popUpAvatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *popUpUserButton;
@property (weak, nonatomic) IBOutlet UIButton *popUpAvatarButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewVConstraint;

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

@property (weak, nonatomic) IBOutlet UIButton *addChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *notifBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIButton *timerBtn;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *radarBtn;
@property (weak, nonatomic) IBOutlet UILabel *notif_number;
@property (weak, nonatomic) IBOutlet UIImageView *notif_circle_image;
@property (weak, nonatomic) IBOutlet UILabel *timer_label;
@property (weak, nonatomic) IBOutlet UIButton *start_radar_btn;
@property (strong, nonatomic) AlertDialogProgressView *alertDialogProgressView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *radarActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorMsgLbl2;
@property (weak, nonatomic) IBOutlet UILabel *errorMsgLbl3;

@property (weak, nonatomic) IBOutlet UIButton *moreTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *findFriendBtn;

@property (strong,nonatomic) IBOutlet UIView *viewRadarAlertBG;
@property (weak, nonatomic) IBOutlet UIButton *btnKeepItOff;
@property (weak, nonatomic) IBOutlet UIButton *btnTurnON;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckBoxOnOff;

@end

@implementation ChatListViewController

@synthesize alertDialogProgressView = _alertDialogProgressView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.findFriendBtn.hidden = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getMessage:)
                                                 name:@"MessageReceived"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getNotification:)
                                                 name:@"NotificationReceived"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newGroupCreated:)
                                                 name:@"GroupCreated"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cardUpdated:)
                                                 name:@"CardUpdated"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startRadarRequest:)
                                                 name:@"StartRadar"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshNotificationNumber:)
                                                 name:@"RefreshNotificationNumber"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peakTimerBuzzed:)
                                                 name:@"PeakTimerBuzzed"
                                               object:nil];
    
    self.timer_label.text = @"";
    //    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    //
    //    if(![userdefaults boolForKey:@"contactSynced"]){
    //        [appDelegate startActivityIndicator:self.view withText:@"Syncing Contacts"];
    //        SyncUserModel *syncUser = [[SyncUserModel alloc] init];
    //        syncUser.delegate = self;
    //        [syncUser startUserSyncing:YES];
    //
    //    }
    //    else{
    //        SyncUserModel *syncUser = [[SyncUserModel alloc] init];
    //        syncUser.delegate = self;
    //        [syncUser startUserSyncing:NO];
    //
    //    }
    
    radarCardIDs = [NSMutableSet set];
    friendRequestCardIDArray = [NSMutableSet set];
    friendAceeptCardIDArray = [NSMutableSet set];
    friendAddedCardIDArray = [NSMutableSet new];
    
    [[SocketStream sharedSocketObject] refreshNotifications];
    [self.notif_number setHidden:YES];
    //self.notif_number.text = [[SocketStream sharedSocketObject].activeNotificationNumber stringValue];
    
    self.radarActivityIndicator.hidden = YES;
    
    [self reloadChatListView];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language rangeOfString:@"ar"].location != NSNotFound) {
        self.exitBtn.translatesAutoresizingMaskIntoConstraints = YES;
        self.exitBtn.frame = CGRectMake(self.timerBtn.frame.origin.x+self.timerBtn.frame.size.width, self.exitBtn.frame.origin.y, self.exitBtn.frame.size.width, self.exitBtn.frame.size.height);
    }
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    if( [userdefaults boolForKey:@"userLoggedIn"])
        [[SocketStream sharedSocketObject] restartSocket];
    
    [[SocketStream sharedSocketObject] refreshHistoryChatData];
    [self refreshNotificationNumber:nil];
    
    //Hide startup naigation bar
    //  appDelegate.objNavigationController.navigationBar.hidden=YES;
}


- (void)userSyncFinished:(BOOL)ifSuccess{
    
    [appDelegate stopActivityIndicator];
    
}

-(void)viewWillDisappear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark WebService Delegate
-(void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponce
{
    //NSLog(@"dicResponce:-%@",dicResponce);
    
    
    //check resvice responce
    if(![dicResponce[@"oprSuccess"] integerValue]){
        if(fetchedIndex > -1){
            fetchedIndex++;
            
            if(fetchedIndex == [radarCardIDArray count])
            {
                [self showRadarFriends];
                
            }
            else if (lastFetchedIndex + 5 == fetchedIndex){
                [self callServiceToGetVcards];
            }
        }
    }
    else{
        if(dicResponce[@"respDetails"] && [dicResponce[@"respDetails"] isKindOfClass:[NSString class]]){
            
            
        }
        else if(dicResponce[@"respDetails"] && [dicResponce[@"respDetails"] isKindOfClass:[NSArray class]]){
            
            
            NSArray *existingIdArray =  [[SocketStream sharedSocketObject].chatMessagesData valueForKeyPath:@"id_"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",existingIdArray];
            NSMutableArray *cardIds = [dicResponce[@"respDetails"] mutableCopy];
            NSArray *cardTobeRetrived = [cardIds filteredArrayUsingPredicate:predicate];
            [cardIds removeObjectsInArray:cardTobeRetrived];
            [self updateCardsAsRadarFriends:cardIds];
            fetchedIndex =0;
            [radarCardIDs addObjectsFromArray:cardTobeRetrived];
            [self callServiceToGetVcards];
            
            if(!(isRadarON && isTimerON))
                [self startRadarTimer];
            
        }
        
        else if([dicResponce[@"respDetails"] objectForKey:@"objType"] && [[dicResponce[@"respDetails"] objectForKey:@"objType"] isEqualToString:@"oj_VCARD"] && [[dicResponce[@"respDetails"] objectForKey:@"cardType"] isEqualToString:@"cd_PRIVATE_GROUP"]){
            
            [DatabaseHelper saveModel:@"VcardObject" FromResponseDict:dicResponce[@"respDetails"]];
            [self callServiceToGetAddedPrivateGroup:([dicResponce[@"respDetails"][@"_id"] isKindOfClass:[NSArray class]]) ? dicResponce[@"respDetails"][@"_id"] : @[dicResponce[@"respDetails"][@"_id"]]];
        }
        
        else if([dicResponce[@"respDetails"] objectForKey:@"objType"] && [[dicResponce[@"respDetails"] objectForKey:@"objType"] isEqualToString:@"oj_PRIVATE_GROUP"]){
            
            [DatabaseHelper saveModel:@"PrivateGroupObject" FromResponseDict:dicResponce[@"respDetails"]];
            [self reloadChatListView];
            fetchedIndex = 0;
            
            if([friendAceeptCardIDArray count] || [friendRequestCardIDArray count]){
                fetchedIndex = -10;
                [self callServiceToGetVcards];
            }
        }
        
        else if([dicResponce[@"respDetails"] objectForKey:@"objType"] && [[dicResponce[@"respDetails"] objectForKey:@"objType"] isEqualToString:@"oj_VCARD"]){
            
            NSMutableDictionary *dict = [dicResponce[@"respDetails"] mutableCopy];
            fetchedIndex++;
            
            if([friendRequestCardIDArray containsObject:dict[@"_id"]])
            {
                dict[@"friendRequestPending"] = @true;
                dict[@"friendRequestSeen"] = @false;
                dict[@"isFriend"] = @false;
                dict[@"isRadarFriend"] = @false;
                
            }
            if([friendAceeptCardIDArray containsObject:dict[@"_id"]]){
                
                dict[@"friendRequestPending"] = @false;
                dict[@"friendRequestSeen"] = @true;
                dict[@"isFriend"] = @true;
                dict[@"isRadarFriend"] = @false;
                
            }
            if([friendAddedCardIDArray containsObject:dict[@"_id"]]){
                
                dict[@"isFriend"] = @true;
                
            }
            if([radarCardIDs containsObject:dict[@"_id"]]){
                dict[@"isRadarFriend"] = @true;
                dict[@"isFriend"] = @false;
                
            }
            
            
            [DatabaseHelper saveModel:@"VcardObject" FromResponseDict:dict];
            
            
            if(fetchedIndex < 0 && [friendRequestCardIDArray containsObject:dict[@"_id"]]){
                [friendRequestCardIDArray removeObject:dict[@"_id"]];
                [[SocketStream sharedSocketObject] refreshNotifications];
                self.notif_number.text = [[SocketStream sharedSocketObject].activeNotificationNumber stringValue];
                fetchedIndex = 0;
            }
            
            else if(fetchedIndex < 0 && [friendAceeptCardIDArray containsObject:dict[@"_id"]]){
                
                [friendAceeptCardIDArray removeObject:dict[@"_id"]];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id_ = %@",dict[@"_id"]];
                NSArray *existingIdArray =  [[SocketStream sharedSocketObject].chatMessagesData filteredArrayUsingPredicate:predicate];
                
                for(VcardObject *card in existingIdArray){
                    
                    long long clientID = ([[NSDate date] timeIntervalSince1970] * 1000);
                    
                    ChatMessageObject *chatMessage = [ChatMessageObject getEntityFor:oj_MESSAGE ackType:NOACK chatType:PRIVATE notifyType:NONOTIFY msgReqType:NOMSGREQ clientMsgID:clientID id:nil org_id:nil msgLife:-1 msgDetails:nil status:nil nTimesSent:1 timeFirstSent:clientID timeLastSent:clientID tx_id:card.id_ tx_name:nil tx_uname:[SocketStream sharedSocketObject].userName tx_avatar_id:nil tx_avatar_uname:nil msgText:NSLocalizedString(@"Thank you my friend", nil) rx_id:@[[SocketStream sharedSocketObject].userID] rxg_id:nil mediaObject:nil];
                    //   [card addChat_relationshipObject:chatMessage] ;
                    [DatabaseHelper saveManagedContext];
                    [[SocketStream sharedSocketObject] refreshHistoryChatData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageReceived" object:chatMessage];
                    
                }
                fetchedIndex = 0;
                
            }
            else if(fetchedIndex < 0 && [friendAddedCardIDArray containsObject:dict[@"_id"]]){
                
                fetchedIndex = 0;
                [friendAddedCardIDArray removeObject:dict[@"_id"]];
                
            }
            else if(fetchedIndex == [radarCardIDArray count])
            {
                [self showRadarFriends];
            }
            else if (lastFetchedIndex + 5 == fetchedIndex){
                [self callServiceToGetVcards];
            }
        }
    }
}

-(void) webServiceHandler:(WebserviceHandler *)webHandler requestFailedWithError:(NSError *)error
{
    
    //NSLog(@"dicResponce:-%@",[error description]);
    [appDelegate stopActivityIndicator];
    //  ShowAlert(AppName,@"Address book Synch not Successful");
    //remove it after WS call
}

#define mark Call WebService
-(void)callServiceToGetGroupVCARD:(NSString *)grpIDs{
    
    WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
    objWebServiceHandler.delegate = self;
    
    //for AFNetworking request
    [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getGroupVCardRequest:grpIDs forHighRes:true] withMethod:@"" withUrl:@"" forKey:@""];
    
}


-(void)callServiceToGetAddedPrivateGroup:(NSArray*)grpIDs{
    
    WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
    objWebServiceHandler.delegate = self;
    
    //for AFNetworking request
    [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getPrivateGroupRequest:grpIDs[0]] withMethod:@"" withUrl:@"" forKey:@""];
    
}

-(void)callServiceToGetVcards {
    
    if(fetchedIndex == 0){
        
        radarCardIDArray = [[radarCardIDs allObjects] mutableCopy];
        
        if([radarCardIDArray count] == 0)
        {
            [self showRadarFriends];
            return;
        }
    }
    
    if(fetchedIndex == -10){
        NSString *cardID ;
        if([friendRequestCardIDArray count])
            cardID = friendRequestCardIDArray.allObjects[0];
        else if([friendAceeptCardIDArray count])
            cardID = friendAceeptCardIDArray.allObjects[0];
        
        WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
        objWebServiceHandler.delegate = self;
        
        //for AFNetworking request
        [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getVcardBy:rq_ID andValue:cardID andHighRes:false] withMethod:@"" withUrl:@"" forKey:@""];
        
    }
    if(radarCardIDArray &&[radarCardIDArray count]>fetchedIndex){
        
        lastFetchedIndex = fetchedIndex;
        for (int i = fetchedIndex; i<fetchedIndex +5; i++) {
            
            if(i == [radarCardIDArray count])
                break;
            
            WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
            objWebServiceHandler.delegate = self;
            
            //for AFNetworking request
            [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getVcardBy:rq_ID andValue:radarCardIDArray[i] andHighRes:false] withMethod:@"" withUrl:@"" forKey:@""];
        }
    }
}

-(void)getNotification:(NSNotification *)aNotification{
    
    // get vcard
    // save with isfriend no
    // update notificaton number
    // show all requests in a controller
    
    
    if([Utility NotifyTypeFromString:aNotification.userInfo[@"type"]] == ny_PRIVATE_FRIEND_REQUEST)
        [friendRequestCardIDArray addObject:aNotification.object];
    
    if([Utility NotifyTypeFromString:aNotification.userInfo[@"type"]] == ny_PRIVATE_FRIEND_ACCEPT)
        [friendAceeptCardIDArray addObject:aNotification.object];
    
    if([Utility NotifyTypeFromString:aNotification.userInfo[@"type"]] == ny_PRIVATE_FRIEND_ADDED)
        [friendAddedCardIDArray addObject:aNotification.object];
    
    
    if([radarCardIDArray containsObject:aNotification.object] || [[[SocketStream sharedSocketObject].chatMessagesData valueForKeyPath:@"id_"]  containsObject:aNotification.object]){
        
        [self updateCardForFriendRequest:aNotification.object andType:aNotification.userInfo[@"type"]];
        
    }
    else{
        if(fetchedIndex == 0)
        {
            
            WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
            objWebServiceHandler.delegate = self;
            
            //for AFNetworking request
            [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getVcardBy:rq_ID andValue:aNotification.object andHighRes:false] withMethod:@"" withUrl:@"" forKey:@""];
            
            fetchedIndex = -10;
        } else if(fetchedIndex == -10) {
            
        } else {
            [radarCardIDArray addObject:aNotification.object];
        }
    }
}





#pragma mark Collection View
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self getVcardsForActiveMode] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChatListCellIdentifier" forIndexPath:indexPath];
    [cell setCellProperties:[self getVcardsForActiveMode][indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatAreaViewController *charAreadVc = (ChatAreaViewController*)[ChitChatFactoryContorller viewControllerForType:ViewControllerTypeChatArea];
    charAreadVc.cardObject = [self getVcardsForActiveMode][indexPath.row];
    charAreadVc.chatType = [SocketStream sharedSocketObject].activeMode;
    [self.navigationController pushViewController:charAreadVc animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"screen %f",screenWidth);
    return  CGSizeMake(screenWidth, 75);
}


#pragma mark Button Action

- (IBAction)textAction:(id)sender {
}

- (IBAction)menuAction:(id)sender {
    //  [LogUtil deleteFile];
    // [[[UIAlertView alloc] initWithTitle:@"Log Deleted" message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil] show];
}

- (IBAction)settingsAction:(id)sender {
    if(self.settingPopUpView.hidden){
        self.collectionView.userInteractionEnabled = NO;
        self.settingPopUpView.hidden = NO;
    }
    else{
        self.collectionView.userInteractionEnabled = YES;
        self.settingPopUpView.hidden = YES;
    }
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language rangeOfString:@"ar"].location != NSNotFound) {
        
        
        [self.btnMyChannel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.btnEditProfile setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.btnNewGroup setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        
        [self.btnNewGroup setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 15)];
        [self.btnEditProfile setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 15)];
        [self.btnMyChannel setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 15)];
    }
    
    
}

- (IBAction)addChat:(UIButton *)sender {
 
    
}

- (IBAction)findFriendsCkicked:(UIButton *)sender {
    
   
    
}

- (IBAction)newGroupCkicked:(UIButton *)sender {
    
    self.collectionView.userInteractionEnabled = YES;
    self.settingPopUpView.hidden = YES;
    
   // AddGroupController *addGroupController = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil] instantiateViewControllerWithIdentifier:@"AddGroupScene"];
    
   // [appDelegate.objNavigationController pushViewController:addGroupController animated:YES];
   // ChatAreaViewController *chatListVc = (ChatAreaViewController*)[ChitChatFactoryContorller viewControllerForType:ViewControllerTypeChatArea];
    //[self.navigationController pushViewController:chatListVc animated:YES];

    
}


- (IBAction)statusCkicked:(UIButton *)sender {
}


- (IBAction)businessCardCkicked:(UIButton *)sender {
}


- (IBAction)changePasswordCkicked:(UIButton *)sender {
}

- (IBAction)refreshAction:(UIButton *)sender {
  
}




- (IBAction)timerAction:(UIButton *)sender {
}


- (IBAction)exitAction:(UIButton *)sender {
}


- (IBAction)showChatAction:(UIButton *)sender {
    
}


- (IBAction)showRadarAction:(UIButton *)sender{
    
}



- (IBAction)editProfileClicked:(UIButton *)sender {
    
   
}

- (IBAction)myChannelButtonClicked:(UIButton *)sender {
    
}

- (IBAction)startRadarAction:(UIButton *)sender {

}

- (IBAction)btnCheckBoxRadarAlertAction:(id)sender {
    UIButton *btnSender = (UIButton *) sender;
    self.btnCheckBoxOnOff.selected = !btnSender.selected;
    
    if (self.btnCheckBoxOnOff.isSelected) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"Off" forKey:@"RadarAlertOptions"];
        [userDefault synchronize];
    } else {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"On" forKey:@"RadarAlertOptions"];
        [userDefault synchronize];
    }
}

- (IBAction)btnRadarAlertAction:(id)sender {
    UIButton *btnSender = (UIButton *) sender;
    switch (btnSender.tag) {
        case 101: {
            [UIView animateWithDuration:0.5 animations:^{
                [self.viewRadarAlertBG setFrame:CGRectMake(self.viewRadarAlertBG.frame.origin.x, -self.viewRadarAlertBG.frame.size.height, self.viewRadarAlertBG.frame.size.width, self.viewRadarAlertBG.frame.size.height)];
            }completion:^(BOOL finished) {
                
            }];
        }
            break;
        case 102: {
            [UIView animateWithDuration:0.5 animations:^{
                [self.viewRadarAlertBG setFrame:CGRectMake(self.viewRadarAlertBG.frame.origin.x, -self.viewRadarAlertBG.frame.size.height, self.viewRadarAlertBG.frame.size.width, self.viewRadarAlertBG.frame.size.height)];
            } completion:^(BOOL finished) {
                isRadarON = YES;
                [[SocketStream sharedSocketObject] startStandardUpdates];
                self.start_radar_btn.hidden = YES;
                self.radarActivityIndicator.hidden = NO;
                [self.radarActivityIndicator startAnimating];
            }];
        }
            break;
        default:
            break;
    }
}


- (IBAction)findFriendAction:(UIButton *)sender {
}

- (IBAction)resetTimerAction:(UIButton *)sender {
   
}


#pragma mark Custom Methods

-(void)followersAdded{
    
    [self reloadChatListView];
    
}

-(void)reloadChatListView{
    
    
        self.refreshBtn.hidden = YES;
        self.timerBtn.hidden = YES;
        self.exitBtn.hidden = YES;
        self.timer_label.hidden = YES;
        self.start_radar_btn.hidden = YES;
        self.errorMessageLabel.hidden = YES;
        self.errorMsgLbl2.hidden = YES;
        self.errorMsgLbl3.hidden = YES;
        self.moreTimeBtn.hidden = YES;
        
        self.addChatBtn.hidden = NO;
        self.notifBtn.hidden = NO;
        self.searchBtn.hidden = NO;
        [self refreshNotificationNumber:nil];
        
        [self.chatBtn setBackgroundImage:[UIImage imageNamed:@"chat-filled_btnbg"] forState:UIControlStateNormal];
        [self.radarBtn setBackgroundImage:[UIImage imageNamed:@"radar-empty_btnbg"] forState:UIControlStateNormal];
        
        if([[self getVcardsForActiveMode] count])
            self.findFriendBtn.hidden = YES;
        else
            self.findFriendBtn.hidden = NO;
        

    [self.collectionView reloadData];
}

#pragma mark Socket Calling



-(void)newGroupCreated:(NSArray*)grpIDs sendNotification:(BOOL)notificationNeeded{
    
   // [appDelegate startPopUpMessage:self.view withText:NSLocalizedString(@"Group Created", nil)];
    
    
    [self reloadChatListView];
    
    if(notificationNeeded){
        
        [[SocketStream sharedSocketObject] sendGroupNotification:grpIDs];
    }
    
}

-(NSArray *)getVcardsForActiveMode{
    return [[[SocketStream sharedSocketObject] getVCardsToAdd:false withGroupID:nil] mutableCopy];
}

-(void)newGroupCreated:(NSNotification *)notificationNeeded{
    NSArray *getIds = notificationNeeded.object;
    [self callServiceToGetGroupVCARD:getIds[0]];
    
}

-(void)cardUpdated:(NSNotification *)notificationNeeded{
    NSArray *getIds = notificationNeeded.object;
    fetchedIndex = -10;
    [self callServiceToGetGroupVCARD:getIds[0]];
    
}

-(void)newFriendTexted:(NSNotification *)notificationNeeded{
    NSArray *friendId = notificationNeeded.object;
    // [self callServiceToGetAddedPrivateGroup:friendId];
    
}

-(void)getMessage:(NSNotification *)aNotification{
    
    [self reloadChatListView];
}

-(void)peakTimerBuzzed:(NSNotification *)aNotification{
    
    [self reloadChatListView];
}

-(void)updateCardForFriendRequest:(NSString *)cardId andType:(NSString *)type_{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id_ = %@",cardId];
    NSArray *existingIdArray =  [[SocketStream sharedSocketObject].chatMessagesData filteredArrayUsingPredicate:predicate];
    
    for(VcardObject *card in existingIdArray){
        
        if([Utility NotifyTypeFromString:type_] == ny_PRIVATE_FRIEND_REQUEST)
        {
            if(![card.isFriend boolValue]){
                card.friendRequestPending = @true;
                card.friendRequestSeen = @false;
                [friendRequestCardIDArray removeObject:cardId];
                [DatabaseHelper saveManagedContext];
                
            }
        }
        if([Utility NotifyTypeFromString:type_] == ny_PRIVATE_FRIEND_ACCEPT)
        {
            card.friendRequestPending = @false;
            card.friendRequestSeen = @true;
            card.isFriend = @true;
            long long clientID = ([[NSDate date] timeIntervalSince1970] * 1000);
            
            ChatMessageObject *chatMessage = [ChatMessageObject getEntityFor:oj_MESSAGE ackType:NOACK chatType:PRIVATE notifyType:NONOTIFY msgReqType:NOMSGREQ clientMsgID:clientID id:nil org_id:nil msgLife:-1 msgDetails:nil status:nil nTimesSent:1 timeFirstSent:clientID timeLastSent:clientID tx_id:[SocketStream sharedSocketObject].userID tx_name:nil tx_uname:[SocketStream sharedSocketObject].userName tx_avatar_id:nil tx_avatar_uname:nil msgText:NSLocalizedString(@"Thank you my friend", nil) rx_id:@[card.id_] rxg_id:nil mediaObject:nil];
            // [card addChat_relationshipObject:chatMessage] ;
            [DatabaseHelper saveManagedContext];
            [[SocketStream sharedSocketObject] refreshHistoryChatData];
            [friendAceeptCardIDArray removeObject:cardId];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageReceived" object:chatMessage];
            
            
        }
        
        if([Utility NotifyTypeFromString:type_] == ny_PRIVATE_FRIEND_ADDED)
        {
            card.friendRequestPending = @false;
            card.friendRequestSeen = @false;
            card.isFriend = @true;
            [DatabaseHelper saveManagedContext];
            [friendAddedCardIDArray removeObject:cardId];
            
            [[SocketStream sharedSocketObject] refreshHistoryChatData];
            
        }
        
    }
    
    [[SocketStream sharedSocketObject] refreshNotifications];
}

-(void)updateCardsAsRadarFriends:(NSArray *)cardIds{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id_ IN %@",cardIds];
    NSArray *existingIdArray =  [[SocketStream sharedSocketObject].chatMessagesData filteredArrayUsingPredicate:predicate];
    
    for(VcardObject *card in existingIdArray){
        card.isRadarFriend = @true;
    }
    [DatabaseHelper saveManagedContext];
    
}

-(void)startRadarRequest:(NSNotification *) notif{
    
    
}

-(void)refreshNotificationNumber:(NSNotification *) notif{
    
    if (![[SocketStream sharedSocketObject].activeNotificationNumber integerValue] == 0) {
        self.notif_number.text = [[SocketStream sharedSocketObject].activeNotificationNumber stringValue];
        [self.notif_number setHidden:NO];
        self.notif_circle_image.hidden = NO;
    } else {
        [self.notif_number setHidden:YES];
        self.notif_circle_image.hidden = YES;
    }
}

-(void)showRadarFriends{
    fetchedIndex = 0;
    [self stopActivityIndicator];
    [[SocketStream sharedSocketObject] refreshRadarChatData];
    [self reloadChatListView];
}

-(void)stopRadarTimer{
    secondsLeft = 0;
    isTimerON = NO;
    if(timer!= nil)
    {
        [timer invalidate];
        timer = nil;
    }
    self.timer_label.text = @"";
    
    
}

-(void)startRadarTimer{
    
    secondsLeft = RADAR_SECONDS;
    [self countdownTimer];
}
-(void)stopActivityIndicator{
    
    [self.radarActivityIndicator stopAnimating];
    self.radarActivityIndicator.hidden = YES;
    [self reloadChatListView];
    
}

- (void)updateCounter:(NSTimer *)theTimer {
    if(secondsLeft > 0 ){
        secondsLeft -- ;
        hours = secondsLeft / RADAR_SECONDS;
        minutes = (secondsLeft % RADAR_SECONDS) / 60;
        seconds = (secondsLeft % RADAR_SECONDS) % 60;
        self.timer_label.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    else{
        [self exitAction:nil];
    }
}

-(void)countdownTimer{
    
    hours = minutes = seconds = 0;
    if(timer!= nil)
    {
        [timer invalidate];
        timer = nil;
    }
    isTimerON = YES;
    @autoreleasepool {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.moreTimeBtn.hidden = YES;
    self.collectionView.userInteractionEnabled = YES;
    self.settingPopUpView.hidden = YES;
}



@end
