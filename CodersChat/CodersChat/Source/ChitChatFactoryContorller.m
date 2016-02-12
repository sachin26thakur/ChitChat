//
//  ChitChatFactoryContorller.m
//  CodersChat
//
//  Created by Vishal Bhadade on 12/02/16.
//  Copyright (c) 2016 GlobalLogic. All rights reserved.
//

#import "ChitChatFactoryContorller.h"


NSString * const ChitChatListViewControllerID = @"chitChatListViewControllerID";

NSString * const SelectLangugeControllerID = @"selectLangugeControllerID";

NSString * const SignUPControllerID = @"signUPControllerID";

NSString * const ChatAreaControllerID = @"ChatAreaControllerID";





@interface ChitChatFactoryContorller ()
@property (nonatomic, strong) NSMutableDictionary *cache;
@end

@implementation ChitChatFactoryContorller : NSObject

+ (NSMutableDictionary *)cache
{
    static NSMutableDictionary *cache = nil;
    
    if(cache == nil) {
        cache = [NSMutableDictionary new];
    }
    
    return cache;
}

+ (void)clearCache
{
    [self.cache removeAllObjects];
}

+ (UIViewController *)viewControllerForType:(ViewControllerType)type
{
    UIViewController *vc = self.cache[@(type)];
    
    if (vc) {
        return vc;
    }
    
    static UIStoryboard *storyboard = nil;
    if(storyboard == nil) {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    
    switch (type) {
        case ViewControllerTypeChitChatList:
        {
            
            vc = [storyboard instantiateViewControllerWithIdentifier:ChitChatListViewControllerID];
            self.cache[@(type)] = vc;
        }
            break;
    
        case ViewControllerTypeSelectLanguage:
        {
            
            vc = [storyboard instantiateViewControllerWithIdentifier:SelectLangugeControllerID];
           // self.cache[@(type)] = vc;
        }
            break;
          
        case ViewControllerTypeSignUp:
        {
            
            vc = [storyboard instantiateViewControllerWithIdentifier:SignUPControllerID];
            // self.cache[@(type)] = vc;
        }
            break;
        
       
        case ViewControllerTypeChatArea:
        {
            UIStoryboard *chitChatStoryBoard = [UIStoryboard storyboardWithName:@"chitChat" bundle:nil];
            vc = [chitChatStoryBoard instantiateViewControllerWithIdentifier:ChatAreaControllerID];

        }
            break;
        default:
            break;
    }
    
    return vc;
}



@end
