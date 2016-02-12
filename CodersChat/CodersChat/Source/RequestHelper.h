//
//  RequestHelper.h
//  CodersChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "SrvReq.h"
#import "UserAuth.h"

@interface RequestHelper : NSObject
+(NSDictionary *)getUniqueNameRequestForSignUP:(BOOL)forSignUp;
+(NSDictionary *)getUniquePhoneRequest:(NSString *)country andNumber:(NSString *)number;
+(NSDictionary *)getLoginRequestWithUsername:(NSString *)user andPassword:(NSString *)pass;
+(NSDictionary *)getSignUpRequestWithName:(NSString *)name number:(NSString*)number uname:(NSString *)uname pass:(NSString *)pass;
+(NSDictionary *)getCreateAvatarRequest;
+(NSDictionary *)getEditVCardRequestForType:(eCardType)cardType_ WithID:(NSString *)id_ andRequestData:(NSDictionary *)requestDict;
+(NSDictionary *)getPrivateGroupCreationRequest:(NSArray *)members grpName:(NSString *)name grpImage:(NSData *)imageData;
+(NSDictionary *)getCardUpdateRequestForAction:(NSString *)action onGrp:(NSString *)grpID members:(NSArray *)members_;
+(NSDictionary *)syncAddressBookRequest:(NSArray *)numbers;
+(NSDictionary *)getPrivateFriendsRequest;
+(NSDictionary *)getPrivateGroupsRequest;
+(NSDictionary *)getMuteListRequest;
+(NSDictionary *)getVcardBy:(eReqType)type_ andValue:(NSString *)value_ andHighRes:(BOOL)ifHighRes;
+(NSDictionary *)getVcards:(NSArray *)cardIDS withResolution:(NSString *)resolution;
+(NSDictionary *)getGroupVCardRequest:(NSString *)grpID forHighRes:(BOOL)highRes;
+(NSDictionary *)getPrivateGroupRequest:(NSString *)grpID;
+(NSDictionary *)getUserPrivateGroupsRequest:(NSString *)grpID;
+(NSDictionary *)getFollowVCardRequest:(NSString *)card_uname andCardType:(NSString *)cardType withMode:(NSNumber *)mode;

+(NSDictionary *)getRadarJoinRequest;
+(NSDictionary *)getRefreshRadarRequest;
+(NSDictionary *)getExitRadarRequest;
+(NSDictionary *)getRestTimerRadarRequest;

+(NSDictionary *)getSearchRequestForString:(NSString *)value_;

+(NSDictionary *)getMuteOperationRequest:(BOOL)ifMute forCardType:(eCardType)cardType_ onID:(NSString*)cardID;

+(NSDictionary *)getMessageForID:(NSString*)cardID;
+(NSDictionary *)getDefaultSet;

//Channel Requests
+(NSDictionary *)getConstraintsForEmoji:(BOOL)forEmoji_;
+(NSDictionary *)getIsMerchantAccountActive;
+(NSDictionary *)getUserCanSetPrice;
+(NSDictionary *)getCreateNewSetFor:(BOOL)forEmoji_ withName:(NSString *)name_ desc:(NSString *)desc_ keywords:(NSString *)keyWords isFree:(BOOL)isFree_ price:(double)price_ headerImageData:(NSDictionary *)headerImageData_ imageList:(NSArray *)imageList_;
+(NSDictionary *)getPublishSet:(NSString *)setID forEmoji:(BOOL)forEmoji_ forPublish:(BOOL)isPublish;
+(NSDictionary *)getDownloadEmojiSetForID:(NSString *)setID forEmoji:(BOOL)forEmoji_ downloadFull:(BOOL)ifFullList;
+(NSDictionary *)getAddSetToDownloadList:(NSString *)setID forEmoji:(BOOL)forEmoji_;
+(NSDictionary *)getIndividualImagesFor:(NSArray *)imagesArray forEmoji:(BOOL)forEmoji_;
+(NSDictionary *)getAddImagesToSet:(NSString *)setID imagesArray:(NSArray *)imagesArray_ forEmoji:(BOOL)forEmoji_;
+(NSDictionary *)geDeleteSet:(NSString *)setID forEmoji:(BOOL)forEmoji_;
+(NSDictionary *)getDeleteImagesFromSet:(NSString *)setID imagesArray:(NSArray *)imagesArray_ forEmoji:(BOOL)forEmoji_;
+(NSDictionary *)getUpdateInfoOfSet:(NSString *)setID setKeyWords:(NSString *)keywords_ setDescription:(NSString *)desc_ forEmoji:(BOOL)forEmoji_;
+(NSDictionary *)getChangePriceOfSet:(NSString *)setID setPrice:(double)price_ makeItFree:(BOOL)ifFree forEmoji:(BOOL)forEmoji_;
+(NSDictionary *)getSetsCreatedByUser:(NSString *)userID;
+(NSDictionary *)getSetsDownloadedByUser:(NSString *)userID;
+(NSDictionary *)getSetWithID:(NSString *)setID forEmoji:(BOOL)forEmoji_;
+(NSDictionary *)getDownloadSetWithID:(NSString *)setID forEmoji:(BOOL)forEmoji_;
+(NSDictionary *)getDownloadSetsWithIDs:(NSArray *)setIDs forEmoji:(BOOL)forEmoji_;
+(NSDictionary *)getViewSetWithID:(NSString *)setID forEmoji:(BOOL)forEmoji_;
+(NSDictionary *)getViewSetsWithIDs:(NSArray *)setIDs forEmoji:(BOOL)forEmoji_;
+(NSDictionary *)getMuteCardRequest:(NSString *)cardID forMuteType:(BOOL)forMute cardType:(eCardType)cardType;

//Edit Channel Requests
+(NSDictionary *)getAddImageToSetFor:(NSString *)setID forEmoji:(BOOL)forEmoji_ imageList:(NSArray *)imageList_;

//Posts Requests
+(NSDictionary *)getFirstTimePostsRequestForUser:(NSString *)userID;
+(NSDictionary *)getPostsRequestForUser:(NSString *)setID onBase:(NSString *)baseID withAscendingDirection:(BOOL)ifAscending;
+(NSDictionary *)getDeletePosts:(NSArray *)postIDs;
+(NSDictionary *)getViewPost:(NSString *)postID;

@end
