//
//  Utility.m
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (NSString*)ObjectTypeToString:(eObjType)obType {
    
    NSString *result = nil;
    switch(obType) {
            
        case oj_MESSAGE:
            result = @"oj_MESSAGE";
            break;
        case oj_ACKN:
            result = @"oj_ACKN";
            break;
        case oj_NOTIFY:
            result = @"oj_NOTIFY";
            break;
        case oj_MSG_REQ:
            result = @"oj_MSG_REQ";
            break;
        case oj_LOC:
            result = @"oj_LOC";
            break;
        case oj_MEDIA:
            result = @"oj_MEDIA";
            break;
        case oj_SRV_REQ:
            result = @"oj_SRV_REQ";
            break;
        case oj_SRV_RESP:
            result = @"oj_SRV_RESP";
            break;
        case oj_VCARD:
            result = @"oj_VCARD";
            break;
        case oj_EMOJI_STICKER_IMAGE:
            result = @"oj_EMOJI_STICKER_IMAGE";
            break;
        case oj_EMOJI:
            result = @"oj_EMOJI";
            break;
        case oj_STICKER:
            result = @"oj_STICKER";
            break;
        default:
            result = nil;
            break;
    }
    
    return result;
}

+ (eObjType)ObjectTypeFromString:(NSString*)obType {
    
    eObjType result;
    
    if([obType isEqualToString:@"oj_MESSAGE"])
        result = oj_MESSAGE;
    else if([obType isEqualToString:@"oj_ACKN"])
        result = oj_ACKN;
    else if([obType isEqualToString:@"oj_NOTIFY"])
        result = oj_NOTIFY;
    else if([obType isEqualToString:@"oj_MSG_REQ"])
        result = oj_MSG_REQ;
    else if([obType isEqualToString:@"oj_LOC"])
        result = oj_LOC;
    else if([obType isEqualToString:@"oj_MEDIA"])
        result = oj_MEDIA;
    else if([obType isEqualToString:@"oj_SRV_REQ"])
        result = oj_SRV_REQ;
    else if([obType isEqualToString:@"oj_SRV_RESP"])
        result = oj_SRV_RESP;
    else if([obType isEqualToString:@"oj_VCARD"])
        result = oj_VCARD;
    else if([obType isEqualToString:@"oj_EMOJI_STICKER_IMAGE"])
        result = oj_EMOJI_STICKER_IMAGE;
    else if([obType isEqualToString:@"oj_EMOJI"])
        result = oj_EMOJI;
    else if([obType isEqualToString:@"oj_STICKER"])
        result = oj_STICKER;
    else
        result = NOOBJ;
    
    return result;
}


+ (NSString*)MessageTypeToString:(eMsgType)mType {
    
    NSString *result = nil;
    switch(mType) {
        case mg_AUTH:
            result = @"mg_AUTH";
            break;
        case mg_ERROR:
            result = @"mg_ERROR";
            break;
        case mg_SEND_PRIVATE_SINGLE:
            result = @"mg_SEND_PRIVATE_SINGLE";
            break;
        case mg_SEND_PRIVATE_MANY:
            result = @"mg_SEND_PRIVATE_MANY";
            break;
        case mg_SEND_HANGOUT_SINGLE:
            result = @"mg_SEND_HANGOUT_SINGLE";
            break;
        case mg_SEND_HANGOUT_MANY:
            result = @"mg_SEND_HANGOUT_MANY";
            break;
        case mg_SEND_BROADCAST:
            result = @"mg_SEND_BROADCAST";
            break;
        case mg_SHARE_EMOJI_STICKER:
            result = @"mg_SHARE_EMOJI_STICKER";
            break;
        default:
            result = nil;
            break;
    }
    
    return result;
}

+ (eMsgType)MessageTypeFromString:(NSString*)typeString {
    
    eMsgType result;
    
    if([typeString isEqualToString:@"mg_AUTH"])
        result = mg_AUTH;
    else if([typeString isEqualToString:@"mg_ERROR"])
        result = mg_ERROR;
    else if([typeString isEqualToString:@"mg_SEND_PRIVATE_SINGLE"])
        result = mg_SEND_PRIVATE_SINGLE;
    else if([typeString isEqualToString:@"mg_SEND_PRIVATE_MANY"])
        result = mg_SEND_PRIVATE_MANY;
    else if([typeString isEqualToString:@"mg_SEND_HANGOUT_SINGLE"])
        result = mg_SEND_HANGOUT_SINGLE;
    else if([typeString isEqualToString:@"mg_SEND_HANGOUT_MANY"])
        result = mg_SEND_HANGOUT_MANY;
    else if([typeString isEqualToString:@"mg_SEND_BROADCAST"])
        result = mg_SEND_BROADCAST;
    else if([typeString isEqualToString:@"mg_SHARE_EMOJI_STICKER"])
        result = mg_SHARE_EMOJI_STICKER;
    else
        result = NOMSG;
    
    return result;
}

+ (NSString*)MessageRequestTypeToString:(eMsgReqType)mType {
    
    NSString *result = nil;
    switch(mType) {
        case mq_GET_PRIVATE_MSG_LOG:
            result = @"mq_GET_PRIVATE_MSG_LOG";
            break;
        case mq_GET_PUBLIC_MSG_LOG:
            result = @"mq_GET_PUBLIC_MSG_LOG";
            break;
        default:
            result = nil;
            break;
    }
    
    return result;
}

+ (eMsgReqType)MessageRequestTypeFromString:(NSString*)typeString {
    
    eMsgReqType result;
    
    if([typeString isEqualToString:@"mq_GET_PRIVATE_MSG_LOG"])
        result = mq_GET_PRIVATE_MSG_LOG;
    else if([typeString isEqualToString:@"mq_GET_PRIVATE_MSG_LOG"])
        result = mq_GET_PRIVATE_MSG_LOG;
    else
        result = NOMSGREQ;
    
    return result;
}



+ (NSString*)NotifyTypeToString:(eNotifyType)notType {
    
    NSString *result = nil;
    switch(notType) {
        case ny_VCARD_UPDATE:
            result = @"ny_VCARD_UPDATE";
            break;
        case ny_GROUP_MEMBERS_ADDED:
            result = @"ny_GROUP_MEMBERS_ADDED";
            break;
        case ny_GROUP_MEMBERS_REMOVED:
            result = @"ny_GROUP_MEMBERS_REMOVED";
            break;
        case ny_HANGOUT_MEMBERS_ADDED:
            result = @"ny_HANGOUT_MEMBERS_ADDED";
            break;
        case ny_HANGOUT_MEMBERS_REMOVED:
            result = @"ny_HANGOUT_MEMBERS_REMOVED";
            break;
        case ny_ADDED_TO_PRIVATE_GROUP:
            result = @"ny_ADDED_TO_PRIVATE_GROUP";
            break;
        case ny_PRIVATE_FRIEND_REQUEST:
            result = @"ny_PRIVATE_FRIEND_REQUEST";
            break;
        case ny_PRIVATE_FRIEND_ACCEPT:
            result = @"ny_PRIVATE_FRIEND_ACCEPT";
            break;
        case ny_PRIVATE_FRIEND_ADDED:
            result = @"ny_PRIVATE_FRIEND_ADDED";
            break;
        case ny_PRIVATE_GROUP_UPDATE:
            result = @"ny_PRIVATE_GROUP_UPDATE";
            break;
        case ny_STATUS_UPDATE:
            result = @"ny_STATUS_UPDATE";
            break;
        default:
            result = nil;
            break;
    }
    return result;
}

+ (eNotifyType)NotifyTypeFromString:(NSString*)typeString {
    
    eNotifyType result;
    
    if([typeString isEqualToString:@"ny_VCARD_UPDATE"])
        result = ny_VCARD_UPDATE;
    else if([typeString isEqualToString:@"ny_GROUP_MEMBERS_ADDED"])
        result = ny_GROUP_MEMBERS_ADDED;
    else if([typeString isEqualToString:@"ny_GROUP_MEMBERS_REMOVED"])
        result = ny_GROUP_MEMBERS_REMOVED;
    else if([typeString isEqualToString:@"ny_HANGOUT_MEMBERS_ADDED"])
        result = ny_HANGOUT_MEMBERS_ADDED;
    else if([typeString isEqualToString:@"ny_HANGOUT_MEMBERS_REMOVED"])
        result = ny_HANGOUT_MEMBERS_REMOVED;
    else if([typeString isEqualToString:@"ny_ADDED_TO_PRIVATE_GROUP"])
        result = ny_ADDED_TO_PRIVATE_GROUP;
    else if([typeString isEqualToString:@"ny_PRIVATE_FRIEND_REQUEST"])
        result = ny_PRIVATE_FRIEND_REQUEST;
    else if([typeString isEqualToString:@"ny_PRIVATE_FRIEND_ACCEPT"])
        result = ny_PRIVATE_FRIEND_ACCEPT;
    else if([typeString isEqualToString:@"ny_PRIVATE_FRIEND_ADDED"])
        result = ny_PRIVATE_FRIEND_ADDED;
    else if([typeString isEqualToString:@"ny_PRIVATE_GROUP_UPDATE"])
        result = ny_PRIVATE_GROUP_UPDATE;
    else if([typeString isEqualToString:@"ny_STATUS_UPDATE"])
        result = ny_STATUS_UPDATE;
    else
        result = NONOTIFY;
    return result;
}

+ (NSString*)AckTypeToString:(eAckType)akType {
    
    NSString *result = nil;
    switch(akType) {
        case ak_MSG_RECEIVED:
            result = @"ak_MSG_RECEIVED";
            break;
        case ak_MSG_DELIVERED:
            result = @"ak_MSG_DELIVERED";
            break;
        case ak_MSG_READ:
            result = @"ak_MSG_READ";
            break;
        default:
            result = nil;
            break;
    }
    
    return result;
}


+ (eAckType)AckTypeFromString:(NSString*)typeString {
    
    eAckType result;
    
    if([typeString isEqualToString:@"ak_MSG_RECEIVED"])
        result = ak_MSG_RECEIVED;
    else if([typeString isEqualToString:@"ak_MSG_DELIVERED"])
        result = ak_MSG_DELIVERED;
    else if([typeString isEqualToString:@"ak_MSG_READ"])
        result = ak_MSG_READ;
    else
        result = NOACK;
    
    return result;
}

+ (NSString*)CardTypeToString:(eCardType)eCType {
    
    NSString *result = nil;
    switch(eCType) {
        case cd_USER:
            result = @"cd_USER";
            break;
        case cd_AVATAR:
            result = @"cd_AVATAR";
            break;
        case cd_TAG:
            result = @"cd_TAG";
            break;
        case cd_WALL:
            result = @"cd_WALL";
            break;
        case cd_PRIVATE_GROUP:
            result = @"cd_PRIVATE_GROUP";
            break;
        default:
            result = nil;
            break;
    }
    
    return result;
}


+ (eCardType)CardTypeFromString:(NSString*)typeString {
    
    eCardType result;
    
    if([typeString isEqualToString:@"cd_USER"])
        result = cd_USER;
    else if([typeString isEqualToString:@"cd_AVATAR"])
        result = cd_AVATAR;
    else if([typeString isEqualToString:@"cd_TAG"])
        result = cd_TAG;
    else if([typeString isEqualToString:@"cd_WALL"])
        result = cd_WALL;
    else if([typeString isEqualToString:@"cd_PRIVATE_GROUP"])
        result = cd_PRIVATE_GROUP;
    else
        result = NOCARD;
    
    return result;
}


+ (NSString*)ReqTypeToString:(eReqType)reqType {
    
    NSString *result = nil;
    switch(reqType) {
        case rq_AUTH:
            result = @"rq_AUTH";
            break;
        case rq_CHNG_PWD:
            result = @"rq_CHNG_PWD";
            break;
        case rq_RESET_PWD:
            result = @"rq_RESET_PWD";
            break;
        case rq_IS_UNIQUE:
            result = @"rq_IS_UNIQUE";
            break;
        case rq_ZNAME:
            result = @"rq_ZNAME";
            break;
        case rq_TAG_NAME:
            result = @"rq_TAG_NAME";
            break;
        case rq_WALL_NAME:
            result = @"rq_WALL_NAME";
            break;
        case rq_WALL_LOCATION:
            result = @"rq_WALL_LOCATION";
            break;
        case rq_NEW_OBJECT:
            result = @"rq_NEW_OBJECT";
            break;
        case rq_AVATAR:
            result = @"rq_AVATAR";
            break;
        case rq_TAG:
            result = @"rq_TAG";
            break;
        case rq_WALL:
            result = @"rq_WALL";
            break;
        case rq_USER:
            result = @"rq_USER";
            break;
        case rq_USER_AVATAR:
            result = @"rq_USER_AVATAR";
            break;
        case rq_PRIVATE_GROUP:
            result = @"rq_PRIVATE_GROUP";
            break;
        case rq_EDIT_VCARD:
            result = @"rq_EDIT_VCARD";
            break;
        case rq_GET_VCARD:
            result = @"rq_GET_VCARD";
            break;
        case rq_GET_NUMBER:
            result = @"rq_GET_NUMBER";
            break;
        case rq_NAME:
            result = @"rq_NAME";
            break;
        case rq_PHONE:
            result = @"rq_PHONE";
            break;
        case rq_ID:
            result = @"rq_ID";
            break;
        case rq_GET:
            result = @"rq_GET";
            break;
        case rq_FIND_VCARD:
            result = @"rq_FIND_VCARD";
            break;
        case rq_FOLLOW:
            result = @"rq_FOLLOW";
            break;
        case rq_FOLLOW_REMOVE:
            result = @"rq_FOLLOW_REMOVE";
            break;
        case rq_FOLLOWERS:
            result = @"rq_FOLLOWERS";
            break;
        case rq_FOLLOWED:
            result = @"rq_FOLLOWED";
            break;
        case rq_FIND_VCARD_BY_NAME:
            result = @"rq_FIND_VCARD_BY_NAME";
            break;
        case rq_GET_PUBLIC_MSGS:
            result = @"rq_GET_PUBLIC_MSGS";
            break;
        case rq_GET_PRIVATE_MSGS:
            result = @"rq_GET_PRIVATE_MSGS";
            break;
        case rq_GET_PRIVATE_FRIENDS:
            result = @"rq_GET_PRIVATE_FRIENDS";
            break;
        case rq_GET_PRIVATE_GROUPS:
            result = @"rq_GET_PRIVATE_GROUPS";
            break;
        case rq_ENTER_HANGOUT:
            result = @"rq_ENTER_HANGOUT";
            break;
        case rq_GET_HANGOUT_MEMBES:
            result = @"rq_GET_HANGOUT_MEMBES";
            break;
        case rq_EXIT_HANGOUT:
            result = @"rq_EXIT_HANGOUT";
            break;
        case rq_GET_GROUP_MEMBERS:
            result = @"rq_GET_GROUP_MEMBERS";
            break;
        case rq_ADD_PRIVATE_FRIEND:
            result = @"rq_ADD_PRIVATE_FRIEND";
            break;
        case rq_GET_USERS_BY_PHONE:
            result = @"rq_GET_USERS_BY_PHONE";
            break;
        case rq_ENTER:
            result = @"rq_ENTER";
            break;
        case rq_EXIT:
            result = @"rq_EXIT";
            break;
        case rq_GET_MEMBRES:
            result = @"rq_GET_MEMBRES";
            break;
        case rq_UPDATE_LOCATION:
            result = @"rq_UPDATE_LOCATION";
            break;
        case rq_RESET_TIMER:
            result = @"rq_RESET_TIMER";
            break;
        case rq_UPDATE_VCARD:
            result = @"rq_UPDATE_VCARD";
            break;
        case rq_MUTE:
            result = @"rq_MUTE";
            break;
        case rq_MESSAGE:
            result = @"rq_MESSAGE";
            break;
        case rq_EMOJI:
            result = @"rq_EMOJI";
            break;
        case rq_STICKER:
            result = @"rq_STICKER";
            break;
        case rq_EMOJI_STICKER:
            result = @"rq_EMOJI_STICKER";
            break;
        case rq_MISC_ACTIONS:
            result = @"rq_MISC_ACTIONS";
            break;
        case rq_MERCHANT_ACCOUNT:
            result = @"rq_MERCHANT_ACCOUNT";
            break;
        case rq_POSTS:
            result = @"rq_POSTS";
            break;
        default:
            result = nil;
            break;
    }
    
    return result;
}


+ (eReqType)ReqTypeFromString:(NSString*)typeString {
    
    eReqType result;
    
    if([typeString isEqualToString:@"rq_AUTH"])
        result = rq_AUTH;
    else if([typeString isEqualToString:@"rq_CHNG_PWD"])
        result = rq_CHNG_PWD;
    else if([typeString isEqualToString:@"rq_RESET_PWD"])
        result = rq_RESET_PWD;
    else if([typeString isEqualToString:@"rq_IS_UNIQUE"])
        result = rq_IS_UNIQUE;
    else if([typeString isEqualToString:@"rq_ZNAME"])
        result = rq_ZNAME;
    else if([typeString isEqualToString:@"rq_TAG_NAME"])
        result = rq_TAG_NAME;
    else if([typeString isEqualToString:@"rq_WALL_NAME"])
        result = rq_WALL_NAME;
    else if([typeString isEqualToString:@"rq_WALL_LOCATION"])
        result = rq_WALL_LOCATION;
    else if([typeString isEqualToString:@"rq_NEW_OBJECT"])
        result = rq_NEW_OBJECT;
    else if([typeString isEqualToString:@"rq_AVATAR"])
        result = rq_AVATAR;
    else if([typeString isEqualToString:@"rq_TAG"])
        result = rq_TAG;
    else if([typeString isEqualToString:@"rq_WALL"])
        result = rq_WALL;
    else if([typeString isEqualToString:@"rq_USER"])
        result = rq_USER;
    else if([typeString isEqualToString:@"rq_USER_AVATAR"])
        result = rq_USER_AVATAR;
    else if([typeString isEqualToString:@"rq_PRIVATE_GROUP"])
        result = rq_PRIVATE_GROUP;
    else if([typeString isEqualToString:@"rq_EDIT_VCARD"])
        result = rq_EDIT_VCARD;
    else if([typeString isEqualToString:@"rq_GET_VCARD"])
        result = rq_GET_VCARD;
    else if([typeString isEqualToString:@"rq_GET_NUMBER"])
        result = rq_GET_NUMBER;
    else if([typeString isEqualToString:@"rq_NAME"])
        result = rq_NAME;
    else if([typeString isEqualToString:@"rq_PHONE"])
        result = rq_PHONE;
    else if([typeString isEqualToString:@"rq_ID"])
        result = rq_ID;
    else if([typeString isEqualToString:@"rq_GET"])
        result = rq_GET;
    else if([typeString isEqualToString:@"rq_FIND_VCARD"])
        result = rq_FIND_VCARD;
    else if([typeString isEqualToString:@"rq_FOLLOW"])
        result = rq_FOLLOW;
    else if([typeString isEqualToString:@"rq_FOLLOW_REMOVE"])
        result = rq_FOLLOW_REMOVE;
    else if([typeString isEqualToString:@"rq_FOLLOWERS"])
        result = rq_FOLLOWERS;
    else if([typeString isEqualToString:@"rq_FOLLOWED"])
        result = rq_FOLLOWED;
    else if([typeString isEqualToString:@"rq_FIND_VCARD_BY_NAME"])
        result = rq_FIND_VCARD_BY_NAME;
    else if([typeString isEqualToString:@"rq_GET_PUBLIC_MSGS"])
        result = rq_GET_PUBLIC_MSGS;
    else if([typeString isEqualToString:@"rq_GET_PRIVATE_MSGS"])
        result = rq_GET_PRIVATE_MSGS;
    else if([typeString isEqualToString:@"rq_GET_PRIVATE_FRIENDS"])
        result = rq_GET_PRIVATE_FRIENDS;
    else if([typeString isEqualToString:@"rq_GET_PRIVATE_GROUPS"])
        result = rq_GET_PRIVATE_GROUPS;
    else if([typeString isEqualToString:@"rq_ENTER_HANGOUT"])
        result = rq_ENTER_HANGOUT;
    else if([typeString isEqualToString:@"rq_EXIT_HANGOUT"])
        result = rq_EXIT_HANGOUT;
    else if([typeString isEqualToString:@"rq_GET_GROUP_MEMBERS"])
        result = rq_GET_GROUP_MEMBERS;
    else if([typeString isEqualToString:@"rq_ADD_PRIVATE_FRIEND"])
        result = rq_ADD_PRIVATE_FRIEND;
    else if([typeString isEqualToString:@"rq_GET_USERS_BY_PHONE"])
        result = rq_GET_USERS_BY_PHONE;
    else if([typeString isEqualToString:@"rq_ENTER"])
        result = rq_ENTER;
    else if([typeString isEqualToString:@"rq_EXIT"])
        result = rq_EXIT;
    else if([typeString isEqualToString:@"rq_GET_MEMBRES"])
        result = rq_GET_MEMBRES;
    else if([typeString isEqualToString:@"rq_UPDATE_LOCATION"])
        result = rq_UPDATE_LOCATION;
    else if([typeString isEqualToString:@"rq_RESET_TIMER"])
        result = rq_RESET_TIMER;
    else if([typeString isEqualToString:@"rq_UPDATE_VCARD"])
        result = rq_UPDATE_VCARD;
    else if([typeString isEqualToString:@"rq_MUTE"])
        result = rq_MUTE;
    else if([typeString isEqualToString:@"rq_MESSAGE"])
        result = rq_MESSAGE;
    else if([typeString isEqualToString:@"rq_EMOJI"])
        result = rq_EMOJI;
    else if([typeString isEqualToString:@"rq_STICKER"])
        result = rq_STICKER;
    else if([typeString isEqualToString:@"rq_EMOJI_STICKER"])
        result = rq_EMOJI_STICKER;
    else if([typeString isEqualToString:@"rq_MISC_ACTIONS"])
        result = rq_MISC_ACTIONS;
    else if([typeString isEqualToString:@"rq_MERCHANT_ACCOUNT"])
        result = rq_MERCHANT_ACCOUNT;
    else if([typeString isEqualToString:@"rq_POSTS"])
        result = rq_POSTS;
    else
        result = NOREQ;
    
    return result;
}


+ (NSString*)MediaTypeToString:(eMediaType)mdType {
    
    NSString *result = nil;
    switch(mdType) {
        case ma_IMAGE:
            result = @"ma_IMAGE";
            break;
        case ma_AUDIO:
            result = @"ma_AUDIO";
            break;
        case ma_VIDEO:
            result = @"ma_VIDEO";
            break;
        case ma_FILE:
            result = @"ma_FILE";
            break;
        default:
            result = nil;
            break;
    }
    
    return result;
}

+ (eMediaType)MediaTypeFromString:(NSString*)mdType {
    
    eMediaType result;
    
    if([mdType isEqualToString:@"ma_IMAGE"])
        result = ma_IMAGE;
    else if([mdType isEqualToString:@"ma_AUDIO"])
        result = ma_AUDIO;
    else if([mdType isEqualToString:@"ma_VIDEO"])
        result = ma_VIDEO;
    else if([mdType isEqualToString:@"ma_FILE"])
        result = ma_FILE;
    else
        result = NOMEDIA;
    
    return result;
}


+ (NSString*)MediaFormatToString:(eMediaFormat)mtType {
    
    NSString *result = nil;
    switch(mtType) {
        case mt_JPG:
            result = @"JPG";
            break;
        case mt_PNG:
            result = @"PNG";
            break;
        case mt_JPEG:
            result = @"JPEG";
            break;
        case mt_AVI:
            result = @"AVI";
            break;
        case mt_MP4:
            result = @"MP4";
            break;
        case mt_MP3:
            result = @"MP3";
            break;
        case mt_CAF:
            result = @"caf";
            break;
        case mt_M4A:
            result = @"m4a";
            break;
        default:
            result = nil;
            break;
    }
    
    return result;
}


+ (eMediaFormat)MediaFormatFromString:(NSString*)mtType {
    
    eMediaFormat result;
    
    if([mtType isEqualToString:@"JPG"])
        result = mt_JPG;
    else if([mtType isEqualToString:@"PNG"])
        result = mt_PNG;
    else if([mtType isEqualToString:@"JPEG"])
        result = mt_JPEG;
    else if([mtType isEqualToString:@"AVI"])
        result = mt_AVI;
    else if([mtType isEqualToString:@"MP4"])
        result = mt_MP4;
    else if([mtType isEqualToString:@"MP3"])
        result = mt_MP3;
    else if([mtType isEqualToString:@"caf"])
        result = mt_CAF;
    else if([mtType isEqualToString:@"m4a"])
        result = mt_M4A;
    
    else
        result = NOMEDIAFORMAT;
    
    return result;
}



+(void)updateUserID:(NSString *)userID{
    
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    if(![[userdefaults objectForKey:UserID] isEqualToString:userID]){
        [userdefaults setObject:userID forKey:UserID];
        [userdefaults synchronize];
        
    }
}

+(NSDate *)getDateFromMilliseconds:(long long)millis{
    
    NSTimeZone *currentTimeZone = [NSTimeZone defaultTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDate *sourceDate = [NSDate dateWithTimeIntervalSince1970:millis/1000];
    
    /*
     NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:sourceDate];
     NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:sourceDate];
     NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
     
     NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:sourceDate];
     */
    return sourceDate;
}



+(UIImage *)compressImage:(UIImage *)image forThumbnail:(BOOL)isThumbnail{
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    if(isThumbnail){
        maxHeight = 100.0;
        maxWidth = 100.0;
    }
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}

+(NSData *)compressImage:(UIImage *)img ImageData:(NSData *)data forThumbnail:(BOOL)isThumbnail{
    
    UIImage *image = img;
    if(!image)
        image = [UIImage imageWithData:data];
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    if(isThumbnail){
        maxHeight = 100.0;
        maxWidth = 100.0;
    }
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *imgCom = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(imgCom, compressionQuality);
    UIGraphicsEndImageContext();
    
    return imageData;
}




+(NSString *)getDocumentPath{
    
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0];
    NSLog(@"Doc PATH %@",docPath);
    return docPath;
}



+ (NSString *)ignoresDiacriticsAndUnfoldCharacters:(NSString *)inputString {
    
    inputString = [inputString stringByReplacingOccurrencesOfString:@"Œ" withString:@"OE"];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"œ" withString:@"oe"];
    return [[NSString alloc] initWithData:[[inputString precomposedStringWithCompatibilityMapping] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding];
    
}


+ (BOOL)isValidName:(NSString*)name{
    
    NSString *str = [NSString stringWithFormat:@"\\\"\'"];
    NSCharacterSet *inValidCharacterSet = [NSCharacterSet characterSetWithCharactersInString:str] ;
    
    NSString *actualName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([actualName length]<2)
        return NO;
    else if ([actualName length] > 50)
        return NO;
    else
        return ([[Utility ignoresDiacriticsAndUnfoldCharacters:actualName] rangeOfCharacterFromSet:inValidCharacterSet].location == NSNotFound);
}


+ (BOOL)isValidUserName:(NSString*)userName {
    
    BOOL isValidUserName = YES;
    
    NSString *str = [NSString stringWithFormat:@"!\"#'()*,/:;<=>?[\\]^`{|}~"];
    
    NSCharacterSet *inValidCharacterSet = [NSCharacterSet characterSetWithCharactersInString:str] ;
    
    NSString *actualName = [userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([actualName length]<2)
        isValidUserName = NO;
    else if ([actualName length] > 50)
        isValidUserName =  NO;
    else if(!((([actualName characterAtIndex:0] == '@' || [actualName characterAtIndex:0] == '#' || [actualName characterAtIndex:0] == '^') && ([actualName characterAtIndex:([actualName length]-1)] != '@' && [actualName characterAtIndex:([actualName length]-1)] != '#' && [actualName characterAtIndex:([actualName length]-1)] != '^')) || (([actualName characterAtIndex:([actualName length]-1)] == '@' || [actualName characterAtIndex:([actualName length]-1)] == '#' || [actualName characterAtIndex:([actualName length]-1)] == '^') && ([actualName characterAtIndex:0] != '@' && [actualName characterAtIndex:0] != '#' && [actualName characterAtIndex:0] != '^'))))
        isValidUserName =  NO;
    else{
        
        long index =  ([actualName characterAtIndex:0] == '@' || [actualName characterAtIndex:0] == '#' || [actualName characterAtIndex:0] == '^') ? 0 : ([actualName length]-1);
        NSString *stringForSetCheck = (index) ?  [actualName substringToIndex:[actualName length]-1] : [actualName substringFromIndex:1];
        isValidUserName =  ([stringForSetCheck rangeOfCharacterFromSet:inValidCharacterSet].location == NSNotFound);
        
    }
    
    
    return isValidUserName;
}


+ (BOOL)isValidPassword:(NSString*)password{
    
    NSString *str = [NSString stringWithFormat:@"\\\"\'"];
    NSCharacterSet *inValidCharacterSet = [NSCharacterSet characterSetWithCharactersInString:str] ;
    
    NSString *actualPass = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([actualPass length]<3)
        return NO;
    else if ([actualPass length] > 20)
        return NO;
    else
        return ([[Utility ignoresDiacriticsAndUnfoldCharacters:actualPass] rangeOfCharacterFromSet:inValidCharacterSet].location == NSNotFound);
}

+ (BOOL)isValidEmailID:(NSString*)emailID {
    //  NSString *emailRegex = @"^((?:(?:(?:[a-zA-Z0-9][\\.\\-\\+\\_\\%]?)*)[a-zA-Z0-9])+)\\@((?:(?:(?:[a-zA-Z0-9][\\.\\-]?){0,62})[a-zA-Z0-9])+)\\.([a-zA-Z]{2,6})$";
    
    NSString *emailExpRegex = @"^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailExpRegex];
    return [emailTest evaluateWithObject:[Utility ignoresDiacriticsAndUnfoldCharacters:emailID]];
}

//+(void)copyDefaultPlist{
//    
//    NSFileManager *fileManger=[NSFileManager defaultManager];
//    NSError *error;
//    NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    
//    NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
//    
//    NSString *destinationPath= [doumentDirectoryPath stringByAppendingPathComponent:Status_Plist_Path];
//    
//    NSLog(@"plist path %@",destinationPath);
//    if ([fileManger fileExistsAtPath:destinationPath]){
//        //NSLog(@"database localtion %@",destinationPath);
//    }
//    else{
//        NSString *sourcePath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:Status_Plist_Path];
//        [fileManger copyItemAtPath:sourcePath toPath:destinationPath error:&error];
//    }
//    
//    NSString *destinationPath2= [doumentDirectoryPath stringByAppendingPathComponent:Recent_Emoji_Plist];
//    
//    NSLog(@"plist path %@",destinationPath2);
//    if ([fileManger fileExistsAtPath:destinationPath2]){
//        //NSLog(@"database localtion %@",destinationPath);
//        // return;
//    }
//    NSString *sourcePath2=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:Recent_Emoji_Plist];
//    [fileManger copyItemAtPath:sourcePath2 toPath:destinationPath2 error:&error];
//    
//    
//    NSString *destinationPath3= [doumentDirectoryPath stringByAppendingPathComponent:Recent_Sticker_Plist];
//    
//    NSLog(@"plist path %@",destinationPath3);
//    if ([fileManger fileExistsAtPath:destinationPath3]){
//        //NSLog(@"database localtion %@",destinationPath);
//        return;
//    }
//    NSString *sourcePath3=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:Recent_Sticker_Plist];
//    [fileManger copyItemAtPath:sourcePath3 toPath:destinationPath3 error:&error];
//    
//    
//    
//}


+(BOOL)isApplicationLaunchedFirstTime{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return ![userDefaults boolForKey:@"isApplicationLaunchedFirstTime"];
}

+(void)setIsApplicationLaunchedFirstTime{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:true forKey:@"isApplicationLaunchedFirstTime"];
}

+ (BOOL)isValidSetName:(NSString*)name{
    
    //    NSString *str = [NSString stringWithFormat:@"\\\"\'"];
    //    NSCharacterSet *inValidCharacterSet = [NSCharacterSet characterSetWithCharactersInString:str] ;
    //
    NSString *actualName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!actualName || [actualName length]==0)
        return NO;
    else if ([actualName length] > 50)
        return NO;
    else
        return YES;
}

+(BOOL) isvalidatePhoneNumber:(NSString *)phoneNumber {
    return true;
    //return [phoneNumber isMatchedByRegex:@"^([0-9]{3}(-)?[0-9]{3}(-)?[0-9]{2,4})$"];
}


+ (BOOL)areValidSetTags:(NSString*)tags{
    
    NSString *actualTags = [tags stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!actualTags || [actualTags length]==0)
        return YES;
    else if ([actualTags length] > 100)
        return NO;
    else
        return YES;
}

+ (BOOL)areValidSetDesc:(NSString*)desc{
    
    NSString *actualDesc = [desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!actualDesc || [actualDesc length]==0)
        return YES;
    else if ([actualDesc length] > 4000)
        return NO;
    else
        return YES;
}

/*
 
 
 
 + (NSDictionary*)validPassword:(NSString*)password{
 
 NSDictionary *passwordDictionary;
 if (password.length>0) {
 
 if ([password length] < [[Utility getValueForKey:PASSWORD_MIN] integerValue]) {
 
 passwordDictionary = @{@"message": [NSString stringWithFormat:TRANSLATION_PASSWORD_MIN_CHRACTERS, [[Utility getValueForKey:PASSWORD_MIN] integerValue]]};
 }
 else if ([password length]>[[Utility getValueForKey:PASSWORD_MAX] integerValue])
 {
 passwordDictionary = @{@"message": [NSString stringWithFormat:TRANSLATION_PASSWORD_MAX_CHRACTERS, [[Utility getValueForKey:PASSWORD_MAX] integerValue]]};
 }
 
 else if ([password rangeOfString:@" "].length != 0) {
 
 passwordDictionary = @{@"message": [NSString stringWithFormat:TRANSLATION_PASSSWORD_CHRACTER_TYPE, [[Utility getValueForKey:PASSWORD_MIN] integerValue]]};
 }
 else {
 
 NSCharacterSet *alpha = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ"];
 
 NSCharacterSet *numeric = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
 
 NSCharacterSet * special = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
 
 BOOL isAlpha,isNumeric,isSpecial,isValidPassword;
 
 if ([password rangeOfCharacterFromSet:alpha] .location == NSNotFound) {
 isAlpha = NO;
 } else {
 isAlpha = YES;
 }
 
 if ([password rangeOfCharacterFromSet:numeric].location == NSNotFound) {
 isNumeric = NO;
 } else {
 isNumeric = YES;
 }
 
 if ([password rangeOfCharacterFromSet:special ].location == NSNotFound) {
 isSpecial = NO;
 } else {
 isSpecial = YES;
 }
 
 isValidPassword =  ((isAlpha&&isNumeric)||(isAlpha&&isSpecial)||(isNumeric&&isSpecial)||(isAlpha&&isSpecial&&isNumeric));
 
 
 if (isValidPassword) {
 
 passwordDictionary = @{@"message": @"NO"};
 }
 else{
 
 passwordDictionary = @{@"message": [NSString stringWithFormat:TRANSLATION_PASSSWORD_CHRACTER_TYPE, [[Utility getValueForKey:PASSWORD_MIN] integerValue]]};
 }
 }
 }
 else{
 
 passwordDictionary = @{@"message": TRANSLATION_PASSWORD_CANNOT_BLANK};
 }
 return passwordDictionary;
 }
 
 + (NSDictionary*)validUsername:(NSString*)username{
 
 NSDictionary *usernameDictionary;
 
 if (username.length>0) {
 
 if ([username length]>18)
 {
 usernameDictionary = @{@"message": TRANSLATION_FIRST_NAME_COMBINATION_MESSAGE};
 }
 else if ([[self class] isValidUserName:username]) {
 
 usernameDictionary = @{@"message": @"NO"};
 }
 else{
 
 usernameDictionary = @{@"message": TRANSLATION_FIRST_NAME_COMBINATION_MESSAGE};
 }
 }
 
 else{
 
 usernameDictionary = @{@"message": TRANSLATION_FIRST_NAME_BLANK_MESSAGE};
 }
 return usernameDictionary;
 }
 
 + (NSDictionary*)validMobileNumber:(NSString*)mobileNumber{
 
 
 NSDictionary *mobileNumberDictionary;
 NSCharacterSet *zero = [[NSCharacterSet characterSetWithCharactersInString:@"0"] invertedSet];
 NSCharacterSet *numeric = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
 
 NSInteger minLength = [[Utility getValueForKey:PHONE_NUMBER_MIN] integerValue];
 NSInteger maxLength = [[Utility getValueForKey:PHONE_NUMBER_MAX] integerValue];
 
 
 if ([mobileNumber rangeOfCharacterFromSet:numeric].location != NSNotFound) {
 mobileNumberDictionary = @{@"message": TRANSLATION_INVALID_MOBILE_NUMBER_MESSAGE};
 
 } else {
 if ((mobileNumber.length >= minLength) && (mobileNumber.length <= maxLength)) {
 if ([mobileNumber rangeOfCharacterFromSet:zero].location == NSNotFound) {
 mobileNumberDictionary = @{@"message": TRANSLATION_INVALID_MOBILE_NUMBER_MESSAGE};
 }
 else{
 mobileNumberDictionary = @{@"message": @"NO"};
 }
 }
 else{
 mobileNumberDictionary = @{@"message": (maxLength == minLength)? [NSString stringWithFormat:TRANSLATION_MOBILE_EXACT_LIMIT,maxLength]: [NSString stringWithFormat:TRANSLATION_MOBILE_BETWEEN_LIMIT, minLength, maxLength]};
 }
 }
 return mobileNumberDictionary;
 }
 */

+ (UIImage*)imageWithImage:(UIImage *)image
              scaledToSize:(CGSize)newSize
{
    
    float heightToWidthRatio = image.size.height / image.size.width;
    float scaleFactor = 1;
    if(heightToWidthRatio > 0) {
        scaleFactor = newSize.height / image.size.height;
    } else {
        scaleFactor = newSize.width / image.size.width;
    }
    
    CGSize newSize2 = newSize;
    newSize2.width = image.size.width * scaleFactor;
    newSize2.height = image.size.height * scaleFactor;
    
    UIGraphicsBeginImageContext(newSize2);
    [image drawInRect:CGRectMake(0,0,newSize2.width,newSize2.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(NSDictionary *)getEmojiContraints{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:@"EmojiConstraints"];
    
}

+(NSDictionary *)getStickerContraints{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:@"StickerConstraints"];
    
}



+(NSString *)getYouTubeVideoID:(NSString*)youtubeVideoURL{
    
    NSString *regexString = @"(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:regexString
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:youtubeVideoURL
                                                    options:0
                                                      range:NSMakeRange(0, [youtubeVideoURL length])];
    if(match){
        NSRange videoIDRange = [match rangeAtIndex:0];
        return [youtubeVideoURL substringWithRange:videoIDRange];
        
    }
    
    return nil;
}


+(NSString *)isMessageIDValidForEmoji:(NSString *)messageID{
    if(messageID.length == 26){
        if([messageID rangeOfString:@"__"].location == 0){
            if( [messageID rangeOfString:@"__" options:NSBackwardsSearch].location == messageID.length -2)
                return [messageID substringWithRange:NSMakeRange(2, 24)];
            else
                return nil;
        }
    }
    return nil;
}


+ (BOOL)isAlphaNumeric_24CharacterLengthID:(NSString *)messageID
{
    NSCharacterSet *unwantedCharacters =
    [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    if ([messageID rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound)
    {
        if ([messageID rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound
            && [messageID rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]] .location != NSNotFound) {
            return (messageID.length == 24);
        }
        else
            return false;
        
    }
    else
        return false;
}


@end



