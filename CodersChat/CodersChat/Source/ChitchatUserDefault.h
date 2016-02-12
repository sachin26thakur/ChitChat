//
//  ChitchatUserDefault.h
//  CodersChat
//
//  Created by Vishal Bhadade on 12/02/16.
//  Copyright (c) 2016 GlobalLogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChitchatUserDefault : NSObject

+ (NSString*)selectedUserLanguage;
+ (void)setSelectedUserLanguage:(NSString*)languge;
+ (NSArray*)languageList;



+ (void)setUserName:(NSString*)username;
+ (NSString *)username;
+ (void)setPassword:(NSString*)password;
+ (NSString *)password;
+ (void)setUserID:(NSString*)userID;
+ (NSString *)userId;
+ (void)setContactSynced:(BOOL)iscontactSynced;
+ (BOOL)isContactSynced;
+ (void)setIsUserLoggin:(BOOL)isLoggedIn;
+ (BOOL)isUserLogginIn;


@end
