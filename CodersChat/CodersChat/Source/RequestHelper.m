//
//  RequestHelper.m
//  CodersChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "RequestHelper.h"
#import "AppDelegate.h"
#import "Phone.h"
#import "VCard.h"
#import "Utility.h"

@interface RequestHelper ()
{
    // Member variables
    
    
    eObjType 	objType;
    eReqType 	reqType1;
    eReqType 	reqType2;
    UserAuth 		*auth;
    id 			reqDetails;
    
    
}

@end
@implementation RequestHelper

+(NSDictionary *)getSignUpRequestWithName:(NSString *)name number:(NSString*)number uname:(NSString *)uname pass:(NSString *)pass{
    
    RequestHelper *req= [[RequestHelper alloc] init];
    
    req->reqType1 = rq_NEW_OBJECT;
    req->reqType2 = rq_USER;
    
    //Set AUth
    req->auth = [[UserAuth alloc] initWithUsername:uname Password:pass DeviceToken:appDelegate.latestDeviceToken osVersion:OSVersion appVersion:AppVersion deviceType:DeviceType];
    
    //Set Request Detail
    NSMutableDictionary *requestDetail = [NSMutableDictionary dictionary];
    

    Phone *phone = [Phone initWithCountry:@"in" andNumber:phone];
    requestDetail[@"phone"] = [phone getPhoneDict];    
    
    //Set Vcard
    requestDetail[@"vCard"] = [VCard getUserCardDict];
    
    req->reqDetails = requestDetail;
    
    return [req getRequestDict];
}

-(NSDictionary *)getRequestDict{
    
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    if(objType !=NOOBJ)
        [requestDict setValue:[Utility ObjectTypeToString:objType]forKey:@"objType"];
    if(reqType1 != NOREQ)
        [requestDict setValue:[Utility ReqTypeToString:reqType1]forKey:@"reqType1"];
    if(reqType2 != NOREQ)
        [requestDict setValue:[Utility ReqTypeToString:reqType2]forKey:@"reqType2"];
    if(reqDetails)
        [requestDict setValue:reqDetails forKey:@"reqDetails"];
    if(auth)
        [requestDict setValue:[auth getAuthDict] forKey:@"auth"];
    
    //    [LogUtil writeStringToFile:[NSString stringWithFormat:@"Request %@",requestDict]];
    //   NSLog(@"Request %@",requestDict);
    return requestDict;
}

+(NSDictionary *)getLoginRequestWithUsername:(NSString *)user andPassword:(NSString *)pass{
    
    RequestHelper *req= [[RequestHelper alloc] init];
    
    req->reqType1 = rq_AUTH;
    req->reqType2 = NOREQ;
    
    //Set AUth
    req->auth = [[UserAuth alloc] initWithUsername:user Password:pass DeviceToken:appDelegate.latestDeviceToken osVersion:OSVersion appVersion:AppVersion deviceType:DeviceType];
    
    return [req getRequestDict];
    
}


@end
