//
//  ChatListViewController.h
//  CodersChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface ChatListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
@property (strong, nonatomic) IBOutlet UIButton *btnNewGroup;
@property (strong, nonatomic) IBOutlet UIButton *btnMyChannel;
@property (strong, nonatomic) IBOutlet UIButton *btnEditProfile;

-(void)newChatMessageInitiated:(BOOL)isSentMessage withText:(NSString *)text;
-(void)avatarAdded;
-(void)cardUpdatedForGroup:(NSArray *)grpIds andReceiverID:(NSArray *)rxIDS withNotify:(eNotifyType)notif_type msgDetails:(NSString *)msgDetails_ msgText:(NSString *)msgText_ clientIdRequired:(BOOL)clientIdRequired_ onAction:(NSString *)action;
-(void)followersAdded;
-(void)newGroupCreated:(NSArray*)grpIDs sendNotification:(BOOL)notificationNeeded;
-(void)cardUpdated:(NSArray*)grpIDs sendNotification:(BOOL)notificationNeeded;
@end
