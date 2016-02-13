//
//  SocketStream.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessageObject.h"
#import "PrivateGroupObject.h"
#import "VCardObject.h"
//#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "GeoLocationObject.h"
#import "Constants.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"


@interface SocketStream :NSObject

@property (readonly, nonatomic) NSMutableArray *chatMessagesData;
@property (readonly, nonatomic) NSArray *historyChatData;
@property (readonly, nonatomic) NSArray *radarChatData;

@property (readonly, nonatomic) VcardObject *userData;

@property (readonly,nonatomic) NSString *userID;
@property (readonly,nonatomic) NSString *userName;
@property (readonly, atomic) ALAssetsLibrary* library;

@property (readonly, nonatomic) GeoLocationObject *currentLocation;

@property (readwrite,nonatomic) NSNumber *activeMode;

//@property (readonly, atomic) ALAssetsLibrary* library;

@property (readonly, nonatomic) NSArray *notificationsArray;
@property (readonly,nonatomic) NSNumber *activeNotificationNumber;

@property (assign, nonatomic) NSInteger unreadMessageCount;

- (void)translateText:(NSArray*)array atIndex:(NSUInteger)index;
+ (instancetype)sharedSocketObject;
- (void)refreshHistoryChatData;
- (void)refreshRadarChatData;
- (void)sendMessage:(ChatMessageObject *)chatMessage;
- (void)addPrivateGroup:(PrivateGroupObject *)group;
- (void)sendGroupNotification:(NSArray *)groupID;
- (NSArray *)getIndividualMembersData;
- (NSArray *)getMyGroupIDs;
-(NSArray *)getVCardsToAdd:(BOOL)forGroups withGroupID:(NSArray *)grpIDs;
- (void)addToTimer:(NSDictionary *)timerDict;
- (void)startStandardUpdates;
- (void)stopStandardUpdates;
- (void)refreshCardsData;
-(void)refreshNotifications;

//VS - Count Unread Message
- (void) refreshCardUnreadCount;
- (NSInteger) getUnreadMessageCount;
//


-(void)sendUpdateNotificationForGroup:(NSArray *)grpIds andReceiverID:(NSArray *)rxIDS withNotify:(eNotifyType)notif_type msgDetails:(NSString *)msgDetails_ msgText:(NSString *)msgText_ clientIdRequired:(BOOL)clientIdRequired_;
-(void)sendUpdateNotificationForSelfCard:(id)cardID withNotify:(eNotifyType)notif_type msgDetails:(NSString *)msgDetails_ msgText:(NSString *)msgText_ clientIdRequired:(BOOL)clientIdRequired_;
-(void)sendUpdateNotificationForStatus:(NSString*)msgDetails_ withNotify:(eNotifyType)notif_type;
-(void)sendFriendAddedNotification:(NSArray *)cardIDs;

-(NSMutableArray *)getPostsDataForUser:(NSString *)userID;
-(void)deletePostsDataForUser:(NSString *)userID;

-(id)getCardByID:(NSString *)id_;


-(void)sendAcknowledgement:(NSString *)jsonAckString;

-(void)deleteMessages:(NSArray *)messageArray;

-(void)restartSocket;
-(void)disconnectSocket;

- (void)peakBuzzed:(NSDictionary *)timerDct;

@end
