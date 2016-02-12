//
//  Media.m
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "Media.h"
#import "Utility.h"

@interface Media(){
    eObjType objType;
    eMediaType mediaType;
    NSString *mediaFormat; // e.g., JPG, PNG, AVI, MPG, ...
    NSData *lowRes; // Low resolution file (image, audio, video)
    NSData *highRes; // High resolution file (image, audio, video)
    long highResKBs;
    long lowResKBs;
    
}
@end

@implementation Media

-(Media *)init {
    // Construct this object:
    
    self = [super init];
    if(self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    // Construct this object:
    objType  	= oj_MEDIA;
    mediaType	= NOMEDIA;
    mediaFormat 	= nil;
    lowRes  	= nil;
    highRes 	= nil;
    highResKBs = -1;
    lowResKBs = -1;
}

+(NSDictionary *)getMediaDict:(NSData *)mediaData andFormat:(NSString *)format ifLowRes:(BOOL)lowResolution andMediaType:(eMediaType)type_{
    
    Media *media = [[self alloc] init];
    
    media->mediaType = type_;
    media->mediaFormat = format;
    media->highRes = mediaData;
    if(type_ == ma_IMAGE)
        media->lowRes = UIImageJPEGRepresentation([Utility compressImage:[UIImage imageWithData:mediaData] forThumbnail:YES], 1);
    
    return [media getMediaDict];
}


+(Media *)getMedia:(NSData *)mediaData andFormat:(NSString *)format ifLowRes:(BOOL)lowResolution andMediaType:(eMediaType)type_{
    
    Media *media = [[self alloc] init];
    
    media->mediaType = type_;
    media->mediaFormat = format;
    media->highRes = mediaData;
    if(type_ == ma_IMAGE)
        media->lowRes = UIImageJPEGRepresentation([Utility compressImage:[UIImage imageWithData:mediaData] forThumbnail:YES], 1);
    
    return media;
}


+(Media *)getMedia:(NSData *)lowData highData:(NSData *)highData andFormat:(NSString *)format andMediaType:(eMediaType)type_{
    
    Media *media = [[self alloc] init];
    
    media->mediaType = type_;
    media->mediaFormat = format;
    media->highRes = highData;
    media->lowRes = lowData;
    
    return media;
}


-(NSDictionary *)getMediaDict{
    NSMutableDictionary *mediaDict = [NSMutableDictionary dictionary];
    
    if(objType !=NOOBJ)
        [mediaDict setValue:[Utility ObjectTypeToString:objType]forKey:@"objType"];
    if(mediaType !=NOMEDIA)
        [mediaDict setValue:[Utility MediaTypeToString:mediaType]forKey:@"mediaType"];
    if(mediaFormat)
        [mediaDict setValue:mediaFormat forKey:@"mediaFormat"];
    if(lowRes)
        [mediaDict setValue:[lowRes base64EncodedStringWithOptions:0] forKey:@"lowRes"];
    if(highRes)
        [mediaDict setValue:[highRes base64EncodedStringWithOptions:0] forKey:@"highRes"];
    [mediaDict setValue:@15 forKey:@"highResKBs"];
    [mediaDict setValue:@2 forKey:@"lowResKBs"];
    
    return mediaDict;
}

-(NSData *)getHighResMedia{
    if(highRes)
        return highRes;
    else
        return lowRes;
}

-(NSData *)getLowResMedia{
    if(lowRes)
        return lowRes;
    else
        return highRes;
}

-(eMediaType)getMediaType{
    return mediaType;
}
@end