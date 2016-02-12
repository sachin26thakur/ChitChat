//
//  Constants.h
//  CodersChat
//
//  Created by Vishal Bhadade on 12/02/16.
//  Copyright (c) 2016 GlobalLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef CodersChat_Constants_h
#define CodersChat_Constants_h


#define LOGIN_VIEW_CONTROLLER_SEGUE @"loginVCSegue"

#endif

#define SocialType                @"Mobile"
#define DeviceType                @"de_IPHONE"
#define AppVersion                @"1.0"
#define OSVersion                 [NSString stringWithFormat:@"%f", [[[UIDevice currentDevice] systemVersion] floatValue]]

#define UserID @"userID"
#define URL_DOMAIN               @"http://54.174.18.36:8080/webServlet/restAPI"
#define URL_SOCKET               @"ws://54.174.18.36:8080/webSocket/socketAPI"
#define Progressing       @""
#define Name     @"Name"
#define UserName @"UserName"
#define UserPass @"UserPass"
#define ES_IMG_MIN_HEIGHT @"imgMinHeight"
#define ES_IMG_MAX_HEIGHT @"imgMaxHeight"
#define ES_IMG_MIN_WIDTH @"imgMinWidth"
#define ES_IMG_MAX_WIDTH @"imgMaxWidth"
#define ES_IMG_MIN_ASPECT @"imgMinAspect"
#define ES_IMG_MAX_ASPECT @"imgMaxAspect"
#define ES_HEADER_IMG_HEIGHT @"headerImgHeight"
#define ES_HEADER_IMG_WIDTH @"headerImgWidth"
#define ES_SNAPSHOT_HEIGHT @"snapShotHeight"
#define ES_SNAPSHOT_WIDTH @"snapShotWidth"
#define ES_MIN_COUNT @"minCount"
#define ES_MAX_COUNT @"maxCount"
#define ES_MIN_PRICE @"minPrice"
#define ES_MAX_PRICE @"maxPrice"
#define ES_MIN_DOWNLOADS @"minDownloadsToSetPrice"



#define Card_Text_Resolution @"textOnly"
#define Card_Thumbnail_Resolution @"thumbnail"
#define Card_Low_Res_Resolution @"lowRes"
#define Card_High_Res_Resolution @"highRes"

#define VCard_OBJ @"VcardObject"
#define PrivateGroup_OBJ @"PrivateGroupObject"
#define ChatMessage_OBJ @"ChatMessageObject"
#define EmojiStickerSet_OBJ @"EmojiStickerSet"

#define MuteList @"MuteList"

#define YouTubeIdentifier @"_#youtube#_"
#define EmojiMessageIdentifier @"_#emoji#_"
#define StickerMessageIdentifier @"_#sticker#_"

#define Default_Creator_ID @"562ce46ee4b0a22df05b2dce"

//Enums for Chat Message Object
typedef enum {
    oj_MESSAGE,			// This object represents a message. Check the msgType for details.
    oj_ACKN,			// This object is an acknowledgment. Check the ackType for details.
    oj_NOTIFY,			// This object is a notification. Check the notifyType for details.
    oj_MSG_REQ,      // This object is a request. Check the msgReqType for details.
    oj_LOC,
    oj_MEDIA,
    oj_SRV_REQ,
    oj_SRV_RESP,
    oj_VCARD,
    oj_PRIVATE_GROUP,
    oj_EMOJI_STICKER_IMAGE,
    oj_EMOJI,
    oj_STICKER,
    NOOBJ
} eObjType;


typedef enum  {
    cd_USER,	// A user vcard.
    cd_AVATAR,		// An avatar vcard
    cd_TAG,		// A Tag (i.e., HashTag) card.
    cd_WALL,		// A Wall vcard. A wall is similar to a Tag but is tied to a specific GeoLocation
    cd_PRIVATE_GROUP,	// A Private Group vcard.
    NOCARD
} eCardType;

typedef enum {
    rq_AUTH,
    rq_CHNG_PWD,
    rq_RESET_PWD,
    rq_IS_UNIQUE,
    rq_ZNAME,
    rq_TAG_NAME,
    rq_WALL_NAME,
    rq_WALL_LOCATION,
    rq_NEW_OBJECT,
    rq_AVATAR,
    rq_TAG,
    rq_WALL,
    rq_USER,
    rq_USER_AVATAR,
    rq_PRIVATE_GROUP,
    rq_EDIT_VCARD,
    rq_GET_VCARD,
    rq_GET_NUMBER,
    rq_NAME,
    rq_PHONE,
    rq_ID,
    rq_GET,
    rq_FIND_VCARD,
    rq_FOLLOW,
    rq_FOLLOW_REMOVE,
    rq_FOLLOWERS,
    rq_FOLLOWED,
    rq_FIND_VCARD_BY_NAME,
    rq_GET_PUBLIC_MSGS,
    rq_GET_PRIVATE_MSGS,
    rq_GET_PRIVATE_FRIENDS,
    rq_GET_PRIVATE_GROUPS,
    rq_ENTER_HANGOUT,
    rq_GET_HANGOUT_MEMBES,
    rq_EXIT_HANGOUT,
    rq_GET_GROUP_MEMBERS,
    rq_ADD_PRIVATE_FRIEND,
    rq_GET_USERS_BY_PHONE,
    rq_RADAR,
    rq_ENTER,
    rq_EXIT,
    rq_GET_MEMBRES,
    rq_UPDATE_LOCATION,
    rq_RESET_TIMER,
    rq_UPDATE_VCARD,
    rq_MUTE,
    rq_MESSAGE,
    rq_EMOJI,
    rq_STICKER,
    rq_EMOJI_STICKER,
    rq_MISC_ACTIONS,
    rq_MERCHANT_ACCOUNT,
    rq_POSTS,
    NOREQ
    
} eReqType;


typedef enum  {
    mg_AUTH,			// Authentication message
    mg_ERROR,			// Error message
    mg_SEND_PRIVATE_SINGLE,	// Private message to a single recipient
    mg_SEND_PRIVATE_MANY,	// Private message to multiple recipients
    mg_SEND_HANGOUT_SINGLE,	// Hangout message to a single recipient
    mg_SEND_HANGOUT_MANY,	// Hangout message to multiple recipients
    mg_SEND_BROADCAST,		// Broadcast message
    mg_SHARE_EMOJI_STICKER, //Share emoji or sticker
    NOMSG
} eMsgType;

typedef enum  {
    PRIVATE,
    HANGOUT,
    BROADCAST,
    PUBLIC,
    NOCHAT
} eChatType;

typedef enum  {
    ak_MSG_RECEIVED,		// Message has been received at the server.
    ak_MSG_DELIVERED,		// Message has been delivered to the recipient.
    ak_MSG_READ,			// Message has been read by the recipient.
    NOACK
} eAckType;


typedef enum  {
    ny_VCARD_UPDATE,		// Authentication message
    ny_GROUP_MEMBERS_ADDED,	// Error message
    ny_GROUP_MEMBERS_REMOVED,	// Private message to a single recipient
    ny_HANGOUT_MEMBERS_ADDED,	// Private message to multiple recipients
    ny_HANGOUT_MEMBERS_REMOVED, // Hangout message to a single recipient
    ny_ADDED_TO_PRIVATE_GROUP,
    ny_PRIVATE_FRIEND_REQUEST,
    ny_PRIVATE_FRIEND_ACCEPT,
    ny_PRIVATE_FRIEND_ADDED,
    ny_PRIVATE_GROUP_UPDATE,
    ny_STATUS_UPDATE,
    NONOTIFY
} eNotifyType;

typedef enum {
    mq_GET_PRIVATE_MSG_LOG,	// A request for the server to get the log of private messages
    mq_GET_PUBLIC_MSG_LOG,	// A request for the server to get the log of public messages
    NOMSGREQ
} eMsgReqType;

typedef enum {
    ma_IMAGE,	// An image. The image format (extension) is specified in mediaFormat
    ma_AUDIO,		// Audio. Format is specified in mediaFormat
    ma_VIDEO,		// Video. Format is specified in mediaFormat
    ma_FILE,	// Other file format. Reserved for future use. Not used now.
    NOMEDIA
} eMediaType;

typedef enum {
    mt_JPG,
    mt_PNG,
    mt_JPEG,
    mt_AVI,
    mt_MP4,
    mt_MP3,
    mt_CAF,
    mt_M4A,
    NOMEDIAFORMAT
} eMediaFormat;