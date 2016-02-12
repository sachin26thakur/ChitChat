//
//  VcardObject+CoreDataProperties.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "VcardObject.h"
#import "DatabaseHelper.h"

@class ChatMessageObject, MediaObject, PrivateGroupObject, PhoneObject, EmojiStickerSet;

NS_ASSUME_NONNULL_BEGIN


@interface VcardObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *cardType;
@property (nullable, nonatomic, retain) NSString *creator_id;
@property (nullable, nonatomic, retain) NSString *creator_name;
@property (nullable, nonatomic, retain) NSString *creator_uname;
@property (nullable, nonatomic, retain) NSNumber *friendRequestPending;
@property (nullable, nonatomic, retain) NSNumber *friendRequestSeen;
@property (nullable, nonatomic, retain) NSString *id_;
@property (nullable, nonatomic, retain) NSNumber *isAvatarFollowing;
@property (nullable, nonatomic, retain) NSNumber *isFriend;
@property (nullable, nonatomic, retain) NSNumber *isRadarFriend;
@property (nullable, nonatomic, retain) NSString *lastMessage;
@property (nullable, nonatomic, retain) NSNumber *lastMessageTimeStamp;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *objType;
@property (nullable, nonatomic, retain) NSString *otherStuff;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSNumber *timeCreated;
@property (nullable, nonatomic, retain) NSNumber *timeUpdated;
@property (nullable, nonatomic, retain) NSString *uname;
@property (nullable, nonatomic, retain) NSString *unReadMessageCount;
@property (nullable, nonatomic, retain) NSSet<EmojiStickerSet *> *downloaded_emoji_sticker_relationship;
@property (nullable, nonatomic, retain) NSSet<PrivateGroupObject *> *group_admin_relationship;
@property (nullable, nonatomic, retain) PrivateGroupObject *group_card_relationship;
@property (nullable, nonatomic, retain) NSSet<PrivateGroupObject *> *group_relationship;
@property (nullable, nonatomic, retain) MediaObject *image_relationship;
@property (nullable, nonatomic, retain) NSSet<EmojiStickerSet *> *my_emoji_sticker_relationship;
@property (nullable, nonatomic, retain) PhoneObject *phone_relationship;
@property (nullable, nonatomic, retain) NSSet<ChatMessageObject *> *post_relationship;
@property (nullable, nonatomic, retain) MediaObject *video_relationship;

+(VcardObject *)setObjectFromDict:(NSDictionary *)cardDict;
+(BOOL)saveObjectFromDict:(NSDictionary *)cardDict;
+(BOOL)UpdateObject:(id)Object FromDict:(NSDictionary *)cardDict;

@end

@interface VcardObject (CoreDataGeneratedAccessors)

- (void)addDownloaded_emoji_sticker_relationshipObject:(EmojiStickerSet *)value;
- (void)removeDownloaded_emoji_sticker_relationshipObject:(EmojiStickerSet *)value;
- (void)addDownloaded_emoji_sticker_relationship:(NSSet<EmojiStickerSet *> *)values;
- (void)removeDownloaded_emoji_sticker_relationship:(NSSet<EmojiStickerSet *> *)values;

- (void)addGroup_admin_relationshipObject:(PrivateGroupObject *)value;
- (void)removeGroup_admin_relationshipObject:(PrivateGroupObject *)value;
- (void)addGroup_admin_relationship:(NSSet<PrivateGroupObject *> *)values;
- (void)removeGroup_admin_relationship:(NSSet<PrivateGroupObject *> *)values;

- (void)addGroup_relationshipObject:(PrivateGroupObject *)value;
- (void)removeGroup_relationshipObject:(PrivateGroupObject *)value;
- (void)addGroup_relationship:(NSSet<PrivateGroupObject *> *)values;
- (void)removeGroup_relationship:(NSSet<PrivateGroupObject *> *)values;

- (void)addMy_emoji_sticker_relationshipObject:(EmojiStickerSet *)value;
- (void)removeMy_emoji_sticker_relationshipObject:(EmojiStickerSet *)value;
- (void)addMy_emoji_sticker_relationship:(NSSet<EmojiStickerSet *> *)values;
- (void)removeMy_emoji_sticker_relationship:(NSSet<EmojiStickerSet *> *)values;

- (void)addPost_relationshipObject:(ChatMessageObject *)value;
- (void)removePost_relationshipObject:(ChatMessageObject *)value;
- (void)addPost_relationship:(NSSet<ChatMessageObject *> *)values;
- (void)removePost_relationship:(NSSet<ChatMessageObject *> *)values;

@end

NS_ASSUME_NONNULL_END
