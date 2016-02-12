//
//  UserAuth.h
//  CodersChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAuth : NSObject
-(UserAuth *)initWithUsername:(NSString *)user Password:(NSString *)pass;
-(UserAuth *)initWithUsername:(NSString *)user Password:(NSString *)pass DeviceToken:(NSString *)token osVersion:(NSString *)osVersion_ appVersion:(NSString *)appVersion_ deviceType:(NSString *)deviceType_;
-(NSDictionary *)getAuthDict;
@end
