//
//  SyncUser.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserSyncDelegate <NSObject>

- (void)userSyncFinished:(BOOL)ifSuccess;

@end

@interface SyncUser : NSObject

@property (weak, nonatomic) id<UserSyncDelegate> delegate;
-(void)startUserSyncing:(BOOL)ifNewUser;
-(NSArray *)getAllContacts;

-(void)checkOfflineMessages;
-(void)syncUserWithoutContactSync;
-(void)callServiceForSyncFriendsList;
-(void)callServiceForPrivateRelations:(BOOL)ifGroups;

@end