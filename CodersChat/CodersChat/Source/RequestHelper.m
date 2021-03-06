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
#import "ChitchatUserDefault.h"

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
    

    Phone *phone = [Phone initWithCountry:@"in" andNumber:number];
    requestDetail[@"phone"] = [phone getPhoneDict];    
    
    //Set Vcard
    requestDetail[@"vCard"] = [VCard getUserCardDictWithName:name number:number uname:uname pass:pass];
    
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

+(NSDictionary *)syncAddressBookRequest:(NSArray *)numbers {
    
    RequestHelper *req= [[RequestHelper alloc] init];
    req->reqType1 = rq_ADD_PRIVATE_FRIEND;
    req->reqType2 = rq_PHONE;
    req->reqDetails = @{@"phones":numbers};
    
    //Set AUth
    req->auth = [[UserAuth alloc] initWithUsername:[ChitchatUserDefault username] Password:[ChitchatUserDefault password]];
    
    return [req getRequestDict];
}


+(NSDictionary *)getPrivateFriendsRequest{
    
    RequestHelper *req= [[RequestHelper alloc] init];
    req->reqType1 = rq_GET_PRIVATE_FRIENDS;
    //Set AUth
    req->auth = [[UserAuth alloc] initWithUsername:[ChitchatUserDefault username] Password:[ChitchatUserDefault password]];
    
    return [req getRequestDict];
}


+(NSDictionary *)getPrivateGroupsRequest{
    
    RequestHelper *req= [[RequestHelper alloc] init];
    req->reqType1 = rq_GET_PRIVATE_GROUPS;
    //Set AUth
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    req->auth = [[UserAuth alloc] initWithUsername:[userdefaults objectForKey:UserName] Password:[userdefaults objectForKey:UserPass]];
    return [req getRequestDict];
}

+(NSDictionary *)getVcards:(NSArray *)cardIDS withResolution:(NSString *)resolution {
    
    RequestHelper *req= [[RequestHelper alloc] init];
    req->reqType1 = rq_GET;
    req->reqType2 = rq_GET_VCARD;
    req->reqDetails = @{@"vcard_ids":cardIDS,@"resolution":resolution};
    
    //Set AUth
    req->auth = [[UserAuth alloc] initWithUsername:[ChitchatUserDefault username] Password:[ChitchatUserDefault password]];
    
    return [req getRequestDict];
}

+(NSDictionary *)getVcardBy:(eReqType)type_ andValue:(NSString *)value_ andHighRes:(BOOL)ifHighRes{
    
    RequestHelper *req= [[RequestHelper alloc] init];
    req->reqType1 = rq_GET_VCARD;
    req->reqType2 = type_;
    if(value_)
        req->reqDetails = @{@"highRes":(ifHighRes) ? @"true" :@"false",@"_id":value_};
    else
        req->reqDetails = @{@"highRes":(ifHighRes) ? @"true" :@"false"};
    
    
    //Set AUth
    req->auth = [[UserAuth alloc] initWithUsername:[ChitchatUserDefault username] Password:[ChitchatUserDefault password]];
    
    return [req getRequestDict];
}


+(NSDictionary *)getMuteListRequest{
    
    RequestHelper *req= [[RequestHelper alloc] init];
    req->reqType1 = rq_GET;
    req->reqType2 = rq_MUTE;
    
    //Set AUth
    req->auth = [[UserAuth alloc] initWithUsername:[ChitchatUserDefault username] Password:[ChitchatUserDefault password]];
    
    return [req getRequestDict];
}

+(NSDictionary *)getPrivateGroupRequest:(NSString *)grpID{
    
    RequestHelper *req= [[RequestHelper alloc] init];
    
    req->reqType1 = rq_GET;
    req->reqType2 = rq_PRIVATE_GROUP;
    
    //Set AUth
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    req->auth = [[UserAuth alloc] initWithUsername:[userdefaults objectForKey:UserName] Password:[userdefaults objectForKey:UserPass]];
    
    req->reqDetails = @{@"group_id":grpID};
    
    return [req getRequestDict];
}


+(NSDictionary *)getGroupVCardRequest:(NSString *)grpID forHighRes:(BOOL)highRes{
    
    RequestHelper *req= [[RequestHelper alloc] init];
    
    req->reqType1 = rq_GET_VCARD;
    req->reqType2 = rq_ID;
    
    //Set AUth
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    req->auth = [[UserAuth alloc] initWithUsername:[userdefaults objectForKey:UserName] Password:[userdefaults objectForKey:UserPass]];
    
    req->reqDetails = @{@"highRes":(highRes)? @"true" :@"false",@"_id":grpID};
    
    return [req getRequestDict];
}

+(NSDictionary *)getPrivateGroupCreationRequest:(NSArray *)members grpName:(NSString *)name grpImage:(NSData *)imageData{
    
    RequestHelper *req= [[RequestHelper alloc] init];
    
    req->reqType1 = rq_NEW_OBJECT;
    req->reqType2 = rq_PRIVATE_GROUP;
    
    //Set AUth
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    req->auth = [[UserAuth alloc] initWithUsername:[userdefaults objectForKey:UserName] Password:[userdefaults objectForKey:UserPass]];
    
    //Set Request Detail
    NSMutableDictionary *requestDetail = [NSMutableDictionary dictionary];
    
    //Set Email
    requestDetail[@"members"] = members;
    
    //Set Vcard
    requestDetail[@"vCard"] = [[[VCard alloc] initCard:cd_PRIVATE_GROUP cardName:name Uname:name andStuff:@"Other Stuff goes here" picture:imageData video:nil] getCardDict];
    
    req->reqDetails = requestDetail;
    
    return [req getRequestDict];
    
}



+(NSDictionary *)getMessageForID:(NSString*)cardID{
    
    RequestHelper *req= [[RequestHelper alloc] init];
    
    req->reqType1 = rq_GET;
    req->reqType2 = rq_MESSAGE;
    
    //Set AUth
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    req->auth = [[UserAuth alloc] initWithUsername:[userdefaults objectForKey:UserName] Password:[userdefaults objectForKey:UserPass]];
    
    req->reqDetails = @{@"_id":@[cardID],@"highRes":@"true",@"msgType":@"private"};
    
    return [req getRequestDict];
}

+(NSDictionary *)getIndividualImagesFor:(NSArray *)imagesArray forEmoji:(BOOL)forEmoji_{
    
    RequestHelper *req= [[RequestHelper alloc] init];
    
    req->reqType1 = (forEmoji_) ? rq_EMOJI : rq_STICKER;
    req->reqType2 = rq_MISC_ACTIONS;
    
    //Set AUth
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    req->auth = [[UserAuth alloc] initWithUsername:[userdefaults objectForKey:UserName] Password:[userdefaults objectForKey:UserPass]];
    
    req->reqDetails = @{@"image_ids":imagesArray, @"action":@"getImage"};
    
    return [req getRequestDict];
    
}

@end
