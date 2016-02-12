//
//  MediaObject+CoreDataProperties.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MediaObject.h"
#import "Constants.h"
#import "DatabaseHelper.h"
#import "Utility.h"

NS_ASSUME_NONNULL_BEGIN

@interface MediaObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *highRes;
@property (nullable, nonatomic, retain) NSData *lowRes;
@property (nullable, nonatomic, retain) NSString *mediaFormat;
@property (nullable, nonatomic, retain) NSString *mediaPath;
@property (nullable, nonatomic, retain) NSString *mediaType;
@property (nullable, nonatomic, retain) NSString *objType;
@property (nullable, nonatomic, retain) NSData *thumbnailImage;
@property (nullable, nonatomic, retain) NSString *url_highRes;
@property (nullable, nonatomic, retain) NSString *url_lowRes;
@property (nullable, nonatomic, retain) NSString *url_thumbnail;
@property (nullable, nonatomic, retain) VcardObject *cardImage_relationship;
@property (nullable, nonatomic, retain) VcardObject *cardVideo_relationship;
@property (nullable, nonatomic, retain) ChatMessageObject *owner_relationship;

+(instancetype)setMediaFromDict:(NSDictionary *)mediaDict;
+(instancetype)setMediaFromDict:(NSDictionary *)mediaDict mediaType:(BOOL)ifPicture;
+(instancetype)getEntityFor:(NSData *)highRes_ lowRes:(NSData *)lowRes_ mediaFormat:(eMediaFormat)mediaFormat_ mediaType:(eMediaType)mediaType_ mediaPath:(NSString *)mediaPath_;
-(NSDictionary *)getMediaObjectDict;
+(BOOL)UpdateObject:(id)Object FromDict:(NSDictionary *)mediaDict;
@end

NS_ASSUME_NONNULL_END
