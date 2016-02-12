//
//  EmojiStickerSet+CoreDataProperties.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EmojiStickerSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface EmojiStickerSet (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *creator_id;
@property (nullable, nonatomic, retain) NSString *creator_name;
@property (nullable, nonatomic, retain) NSString *creator_uname;
@property (nullable, nonatomic, retain) NSNumber *dateCreated;
@property (nullable, nonatomic, retain) NSNumber *dateLastUpdated;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) NSString *id_;
@property (nullable, nonatomic, retain) NSNumber *isActiveSet;
@property (nullable, nonatomic, retain) NSNumber *isFree;
@property (nullable, nonatomic, retain) NSNumber *isPublished;
@property (nullable, nonatomic, retain) NSString *keywords;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *numberOfDownloads;
@property (nullable, nonatomic, retain) NSNumber *numOfImages;
@property (nullable, nonatomic, retain) NSString *objType;
@property (nullable, nonatomic, retain) NSNumber *padding;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *rawKeywords;
@property (nullable, nonatomic, retain) NSNumber *scaleFactor;
@property (nullable, nonatomic, retain) NSNumber *width;
@property (nullable, nonatomic, retain) EmojiStickerImage *headerImage;
@property (nullable, nonatomic, retain) MediaObject *screenshot_relationship;
@property (nullable, nonatomic, retain) NSSet<EmojiStickerImage *> *stickerImages;

@end

@interface EmojiStickerSet (CoreDataGeneratedAccessors)

- (void)addStickerImagesObject:(EmojiStickerImage *)value;
- (void)removeStickerImagesObject:(EmojiStickerImage *)value;
- (void)addStickerImages:(NSSet<EmojiStickerImage *> *)values;
- (void)removeStickerImages:(NSSet<EmojiStickerImage *> *)values;

@end

NS_ASSUME_NONNULL_END
