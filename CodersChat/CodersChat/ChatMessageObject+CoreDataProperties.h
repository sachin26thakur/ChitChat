//
//  ChatMessageObject+CoreDataProperties.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChatMessageObject.h"
#import "Constants.h"
#import "Utility.h"
#import "DatabaseHelper.h"

@class MediaObject, VcardObject;

NS_ASSUME_NONNULL_BEGIN

@interface ChatMessageObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *ackType;
@property (nullable, nonatomic, retain) NSNumber *clientMsgID;
@property (nullable, nonatomic, retain) NSString *id_;
@property (nullable, nonatomic, retain) id msgAttributedText;
@property (nullable, nonatomic, retain) NSString *msgDetails;
@property (nullable, nonatomic, retain) NSNumber *msgLife;
@property (nullable, nonatomic, retain) NSString *msgReqType;
@property (nullable, nonatomic, retain) NSString *msgText;
@property (nullable, nonatomic, retain) NSString *msgType;
@property (nullable, nonatomic, retain) NSString *notifyType;
@property (nullable, nonatomic, retain) NSNumber *nTimesSent;
@property (nullable, nonatomic, retain) NSString *objType;
@property (nullable, nonatomic, retain) NSString *org_id;
@property (nullable, nonatomic, retain) NSString *rx_id;
@property (nullable, nonatomic, retain) NSString *rxg_id;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSNumber *timeFirstSent;
@property (nullable, nonatomic, retain) NSNumber *timeLastSent;
@property (nullable, nonatomic, retain) NSString *tx_avatar_id;
@property (nullable, nonatomic, retain) NSString *tx_avatar_uname;
@property (nullable, nonatomic, retain) NSString *tx_id;
@property (nullable, nonatomic, retain) NSString *tx_name;
@property (nullable, nonatomic, retain) NSString *tx_uname;
@property (nullable, nonatomic, retain) MediaObject *media_relationship;
@property (nullable, nonatomic, retain) NSSet<VcardObject *> *post_card_relationship;

+(instancetype)getEntityFor:(eObjType)objType_ ackType:(eAckType)ackType_ chatType:(eChatType)chatType_ notifyType:(eNotifyType)notifyType_ msgReqType:(eMsgReqType)msgReqType_ clientMsgID:(long long)clientMsgID_ id:(NSString *)id_ org_id:(NSString *)org_id_ msgLife:(int)msgLife_ msgDetails:(NSString *)msgDetails_ status:(NSString *)status_ nTimesSent:(int)nTimesSent_ timeFirstSent:(long long)timeFirstSent_ timeLastSent:(long long)timeLastSent_ tx_id:(NSString *)tx_id_ tx_name:(NSString *)tx_name_ tx_uname:(NSString *)tx_uname_ tx_avatar_id:(NSString *)tx_avatar_id_ tx_avatar_uname:(NSString *)tx_avatar_uname_ msgText:(NSString *)msgText_ rx_id:(NSArray *)rx_id_ rxg_id:(NSArray *)rxg_id_ mediaObject:(MediaObject *)mediaObject_;

-(BOOL)saveModelObjectTODB;
+(NSString *)getAuthMessageWithParameters:(BOOL)ifParameters;
+(NSString *)getAuthIDFromString:(NSString *)msgString;
+(NSString *)getLogMessageString;

+(instancetype)setMessageFromDict:(NSDictionary *)msgDict;
+(instancetype)setMessageFromString:(NSString *)msgString;

+(NSString *)getNewGroupNotifString:(NSArray *)grpIDS;
-(NSString *)getMessageStringFor:(NSDictionary *)msgDict;

+(NSString *)getFriendAddedNotificationFor:(NSArray *)frndIds;

-(BOOL)ifMessageReceived;
-(BOOL)ifMessageRequestReceived;
-(BOOL)ifMessageAcknowledgementReceived;
-(BOOL)ifMessageAcknowledgementOnlyReceived;
-(BOOL)ifNotificationReceived;
-(BOOL)ifAuthMessageReceived;

-(NSString *)getDeliveredAcknowledgement;
-(NSString *)getReadAcknowledgement;
-(NSString *)getSimpleAcknowledgement;
-(NSString *)getFullAcknowledgementOnAck:(NSString *)ackType;


-(NSArray *)getReceiverGroupIDs;
-(NSArray *)getReceiverUserIDs;
-(NSString *)getTransmitterIDs;
-(NSString *)getLastMessageString;

-(void)addCard_relationship:(NSSet *)objects;
-(void)addCard_relationshipObject:(VcardObject *)object;
-(void)removeCard_relationship:(NSSet *)objects;
-(void)removeCard_relationshipObject:(VcardObject *)object;

+(NSString *)getUpdateNotifStringForGroup:(NSArray *)grpIds andReceiverID:(NSArray *)rxIDS withNotify:(eNotifyType)notif_type msgDetails:(NSString *)msgDetails_ msgText:(NSString *)msgText_ clientIdRequired:(BOOL)clientIdRequired_;
+(NSString *)getUpdateNotifStringForSelf:(NSString *)cardID withNotify:(eNotifyType)notif_type msgDetails:(NSString *)msgDetails_ msgText:(NSString *)msgText_ clientIdRequired:(BOOL)clientIdRequired_;
+(NSString *)getUpdateNotifStringForStatus:(NSString *)msgDetails_ withNotify:(eNotifyType)notif_type;


-(void)setMsgAttributedText:(id)msgAttributedText;
-(id)msgAttributedText;

@end

@interface ChatMessageObject (CoreDataGeneratedAccessors)

- (void)addPost_card_relationshipObject:(VcardObject *)value;
- (void)removePost_card_relationshipObject:(VcardObject *)value;
- (void)addPost_card_relationship:(NSSet<VcardObject *> *)values;
- (void)removePost_card_relationship:(NSSet<VcardObject *> *)values;

@end

NS_ASSUME_NONNULL_END
