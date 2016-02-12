//
//  Utility.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Utility:NSObject

+ (NSString*)ObjectTypeToString:(eObjType)obType;
+ (eObjType)ObjectTypeFromString:(NSString*)obType;

+ (NSString*)MessageTypeToString:(eMsgType)mType;
+ (eMsgType)MessageTypeFromString:(NSString*)typeString;

+ (NSString*)MessageRequestTypeToString:(eMsgReqType)mType ;
+ (eMsgReqType)MessageRequestTypeFromString:(NSString*)typeString;

+ (NSString*)NotifyTypeToString:(eNotifyType)notType;
+ (eNotifyType)NotifyTypeFromString:(NSString*)typeString;

+ (NSString*)AckTypeToString:(eAckType)akType;
+ (eAckType)AckTypeFromString:(NSString*)typeString;

+ (NSString*)CardTypeToString:(eCardType)eCType;
+ (eCardType)CardTypeFromString:(NSString*)typeString;

+ (NSString*)ReqTypeToString:(eReqType)reqType;
+ (eReqType)ReqTypeFromString:(NSString*)typeString;

+ (NSString*)MediaTypeToString:(eMediaType)mdType;
+ (eMediaType)MediaTypeFromString:(NSString*)mdType;


+ (NSString*)MediaFormatToString:(eMediaFormat)mtType;
+ (eMediaFormat)MediaFormatFromString:(NSString*)mtType;

+(NSDate *)getDateFromMilliseconds:(long long)millis;

+(UIImage *)compressImage:(UIImage *)image forThumbnail:(BOOL)isThumbnail;
+(NSData *)compressImage:(UIImage *)img ImageData:(NSData *)data forThumbnail:(BOOL)isThumbnail;
+(NSData *)compressImage:(UIImage *)img forEmoji:(BOOL)forEmoji forHeader:(BOOL)forHeader_;

+(NSString *)getDocumentPath;

+ (BOOL) isValidName:(NSString*)username;
+ (BOOL) isValidUserName:(NSString*)userName;
+ (BOOL) isValidPassword:(NSString*)password;
+ (BOOL) isValidEmailID:(NSString*)emailID;
+ (BOOL) isvalidatePhoneNumber:(NSString *)phoneNumber;

+ (NSString *)ignoresDiacriticsAndUnfoldCharacters:(NSString *)inputString;

+(void)copyDefaultPlist;
+(BOOL)isApplicationLaunchedFirstTime;
+(void)setIsApplicationLaunchedFirstTime;

+ (BOOL)isValidSetName:(NSString*)name;
+ (BOOL)areValidSetTags:(NSString*)tags;
+ (BOOL)areValidSetDesc:(NSString*)desc;


+(NSDictionary *)getEmojiContraints;
+(NSDictionary *)getStickerContraints;

+(void)createMuteList:(NSArray *)cardIDs;
+(void)addIdToMuteList:(NSString *)cardID;
+(void)removeIdFromMuteList:(NSString *)cardID;
+(BOOL)muteListContainsID:(NSString *)cardID;

+(NSString *)getYouTubeVideoID:(NSString*)youtubeVideoURL;

+(NSString *)isMessageIDValidForEmoji:(NSString *)messageID;
+ (BOOL)isAlphaNumeric_24CharacterLengthID:(NSString *)messageID;

@end