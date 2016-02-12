//
//  UserAuth.m
//  CodersChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "UserAuth.h"

@interface UserAuth(){
    NSString *username;
    NSString *password;
    NSString *deviceToken;
    NSString *osVersion;
    NSString *appVersion;
    NSString *deviceType;
}
@end

@implementation UserAuth


// Initializer:
-(void) UserAuth {
    username	= nil;
    password	= nil;
    deviceToken	= nil;
    osVersion	= nil;
    appVersion	= nil;
    deviceType	= nil;
    
}


-(UserAuth *)init {
    // Construct this object:
    
    self = [super init];
    if(self)
    {
        [self initialize];
    }
    return self;
}
- (void)initialize
{
    //Do Initialization of all
    
    username	= nil;
    password	= nil;
    deviceToken	= nil;
    osVersion	= nil;
    appVersion	= nil;
    deviceType	= nil;
}

-(UserAuth *)initWithUsername:(NSString *)user Password:(NSString *)pass{
    // Construct this object:
    
    self = [super init];
    if(self)
    {
        username = user;
        password = pass;
        
    }
    return self;
}

-(UserAuth *)initWithUsername:(NSString *)user Password:(NSString *)pass DeviceToken:(NSString *)token osVersion:(NSString *)osVersion_ appVersion:(NSString *)appVersion_ deviceType:(NSString *)deviceType_ {
    
    // Construct this object:
    
    self = [super init];
    if(self)
    {
        username = user;
        password = pass;
        if(!token)
            token = @"sjhfj732hef78jh32jkh4899";
        deviceToken = token;
        osVersion = osVersion_;
        appVersion = appVersion_;
        deviceType = deviceType_;
        
    }
    return self;
}

-(NSDictionary *)getAuthDict{
    
    
    NSMutableDictionary *authDict = [@{@"username":username,@"password":password} mutableCopy];
    
    if(deviceToken)
        authDict[@"deviceToken"] = deviceToken;
    if(osVersion)
        authDict[@"osVersion"] = osVersion;
    if(appVersion)
        authDict[@"appVersion"] = appVersion;
    if(deviceType)
        authDict[@"deviceType"] = deviceType;
    
    authDict[@"objType"] = @"oj_AUTH";
    
    return authDict;
}

@end