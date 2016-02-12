//
//  Media.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Media:NSObject
-(NSDictionary *)getMediaDict;
+(NSDictionary *)getMediaDict:(NSData *)mediaData andFormat:(NSString *)format ifLowRes:(BOOL)lowResolution andMediaType:(eMediaType)type_;
+(Media *)getMedia:(NSData *)mediaData andFormat:(NSString *)format ifLowRes:(BOOL)lowResolution andMediaType:(eMediaType)type_;
+(Media *)getMedia:(NSData *)lowData highData:(NSData *)highData andFormat:(NSString *)format andMediaType:(eMediaType)type_;

-(NSData *)getHighResMedia;
-(NSData *)getLowResMedia;
-(eMediaType)getMediaType;
@end
