//
//  ChitChatFactoryContorller.h
//  CodersChat
//
//  Created by Vishal Bhadade on 12/02/16.
//  Copyright (c) 2016 GlobalLogic. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ViewControllerType)
{
    ViewControllerTypeChitChatList,
    ViewControllerTypeSelectLanguage,
    ViewControllerTypeSignUp,
    ViewControllerTypeChatArea,
    ViewControllerTypeNewGroup
};

extern NSString * const ChitChatListViewControllerID;


@interface ChitChatFactoryContorller : NSObject

+ (UIViewController *)viewControllerForType:(ViewControllerType)type;

+ (void)clearCache;

@end
