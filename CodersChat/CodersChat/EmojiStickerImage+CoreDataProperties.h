//
//  EmojiStickerImage+CoreDataProperties.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EmojiStickerImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface EmojiStickerImage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *crc_checksum;
@property (nullable, nonatomic, retain) NSString *creatorId;
@property (nullable, nonatomic, retain) NSString *fileFormat;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) NSString *id_;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *imageType;
@property (nullable, nonatomic, retain) NSNumber *isActive;
@property (nullable, nonatomic, retain) NSNumber *isAnimated;
@property (nullable, nonatomic, retain) NSNumber *isFree;
@property (nullable, nonatomic, retain) NSNumber *isPublished;
@property (nullable, nonatomic, retain) NSData *kb_image;
@property (nullable, nonatomic, retain) NSNumber *kheight;
@property (nullable, nonatomic, retain) NSNumber *kwidth;
@property (nullable, nonatomic, retain) NSString *objType;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *set_id;
@property (nullable, nonatomic, retain) NSNumber *sizeInBytes;
@property (nullable, nonatomic, retain) NSNumber *timeStamp;
@property (nullable, nonatomic, retain) NSString *url_highRes;
@property (nullable, nonatomic, retain) NSNumber *width;
@property (nullable, nonatomic, retain) NSNumber *x0;
@property (nullable, nonatomic, retain) NSNumber *y0;
@property (nullable, nonatomic, retain) EmojiStickerSet *headerStickerSet;
@property (nullable, nonatomic, retain) EmojiStickerSet *sticketSet;

@end

NS_ASSUME_NONNULL_END
