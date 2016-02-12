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


@end
