//
//  MediaObject+CoreDataProperties.m
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MediaObject+CoreDataProperties.h"

@implementation MediaObject (CoreDataProperties)

@dynamic highRes;
@dynamic lowRes;
@dynamic mediaFormat;
@dynamic mediaPath;
@dynamic mediaType;
@dynamic objType;
@dynamic thumbnailImage;
@dynamic url_highRes;
@dynamic url_lowRes;
@dynamic url_thumbnail;
@dynamic cardImage_relationship;
@dynamic cardVideo_relationship;
@dynamic owner_relationship;

+(instancetype)setMediaFromDict:(NSDictionary *)mediaDict{
    
    MediaObject *media = (MediaObject *)[NSEntityDescription
                                         insertNewObjectForEntityForName:@"MediaObject"
                                         inManagedObjectContext:[DatabaseHelper getManagedContext]];
    if(mediaDict[@"thumbnailImage"])
        media.thumbnailImage = [[NSData alloc] initWithBase64EncodedString:mediaDict[@"thumbnailImage"] options:0];
    if(mediaDict[@"lowRes"])
        media.lowRes = [[NSData alloc] initWithBase64EncodedString:mediaDict[@"lowRes"] options:0];
    if(mediaDict[@"highRes"])
        media.highRes = [[NSData alloc] initWithBase64EncodedString:mediaDict[@"highRes"] options:0];
    if(mediaDict[@"mediaFormat"])
        media.mediaFormat = mediaDict[@"mediaFormat"];
    if(mediaDict[@"mediaType"])
        media.mediaType = mediaDict[@"mediaType"];
    if(mediaDict[@"objType"])
        media.objType = mediaDict[@"objType"];
    else
        media.objType = [Utility ObjectTypeToString:oj_MEDIA];
    
    if(mediaDict[@"url_highRes"])
        media.url_highRes = mediaDict[@"url_highRes"];
    if(mediaDict[@"url_lowRes"])
        media.url_lowRes = mediaDict[@"url_lowRes"];
    if(mediaDict[@"url_thumbnail"])
        media.url_thumbnail = mediaDict[@"url_thumbnail"];
    
    // if(mediaDict[@"mediaPath"])
    //media.mediaPath = mediaDict[@"mediaPath"];
    else{
        
    }
    
    //  media->lowRes = UIImageJPEGRepresentation([Utility compressImage:[UIImage imageWithData:mediaData] forThumbnail:YES], 1);
    
    return media;
}

+(instancetype)setMediaFromDict:(NSDictionary *)mediaDict mediaType:(BOOL)ifPicture{
    NSMutableDictionary *dict = [mediaDict mutableCopy];
    dict[@"mediaType"] = (ifPicture)? @"ma_IMAGE" : @"ma_VIDEO";
    return [self setMediaFromDict:dict];
}

+(instancetype)getEntityFor:(NSData *)highRes_ lowRes:(NSData *)lowRes_ mediaFormat:(eMediaFormat)mediaFormat_ mediaType:(eMediaType)mediaType_ mediaPath:(NSString *)mediaPath_{
    
    MediaObject *mediaObj = (MediaObject *)[NSEntityDescription
                                            insertNewObjectForEntityForName:@"MediaObject"
                                            inManagedObjectContext:[DatabaseHelper getManagedContext]];
    
    mediaObj.highRes = highRes_;
    mediaObj.lowRes = lowRes_;
    mediaObj.mediaFormat = [Utility MediaFormatToString:mediaFormat_];
    mediaObj.mediaType = ([Utility MediaTypeToString:mediaType_]) ?: [Utility MediaTypeToString:ma_IMAGE];
    mediaObj.objType = [Utility ObjectTypeToString:oj_MEDIA];
    mediaObj.mediaPath = mediaPath_;
    
    return mediaObj;
    
}


-(NSDictionary *)getMediaObjectDict{
    NSMutableDictionary *mediaDict = [NSMutableDictionary dictionary];
    
    [mediaDict setValue:@"oj_MEDIA" forKey:@"objType"];
    [mediaDict setValue:self.mediaType forKey:@"mediaType"];
    
    if(self.mediaFormat)
        [mediaDict setValue:self.mediaFormat forKey:@"mediaFormat"];
    if(self.lowRes)
        [mediaDict setValue:[self.lowRes base64EncodedStringWithOptions:0] forKey:@"lowRes"];
    if(self.highRes)
        [mediaDict setValue:[self.highRes base64EncodedStringWithOptions:0] forKey:@"highRes"];
    
    return mediaDict;
}

+(BOOL)UpdateObject:(id)Object FromDict:(NSDictionary *)mediaDict{
    
    MediaObject *media = (MediaObject *)Object;
    if(mediaDict[@"thumbnailImage"])
        media.thumbnailImage = [[NSData alloc] initWithBase64EncodedString:mediaDict[@"thumbnailImage"] options:0];
    if(mediaDict[@"lowRes"])
        media.lowRes = [[NSData alloc] initWithBase64EncodedString:mediaDict[@"lowRes"] options:0];
    if(mediaDict[@"highRes"])
        media.highRes = [[NSData alloc] initWithBase64EncodedString:mediaDict[@"highRes"] options:0];
    if(mediaDict[@"mediaFormat"])
        media.mediaFormat = mediaDict[@"mediaFormat"];
    if(mediaDict[@"mediaType"])
        media.mediaType = mediaDict[@"mediaType"];
    if(mediaDict[@"objType"])
        media.objType = mediaDict[@"objType"];
    
    if(mediaDict[@"url_highRes"])
        media.url_highRes = mediaDict[@"url_highRes"];
    if(mediaDict[@"url_lowRes"])
        media.url_lowRes = mediaDict[@"url_lowRes"];
    if(mediaDict[@"url_thumbnail"])
        media.url_thumbnail = mediaDict[@"url_thumbnail"];
    
    
    return true;
    
}

@end
