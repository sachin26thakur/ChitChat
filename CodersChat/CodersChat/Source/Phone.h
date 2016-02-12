//
//  Phone.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Phone:NSObject

+(Phone *)initWithCountry:(NSString *)country andNumber:(NSString *)number;
-(NSDictionary *)getPhoneDict;
@end
