//
//  JSONParser.h
//  Zargow
//
//  Created by Northout_101 on 23/01/15.
//  Copyright (c) 2015 Northout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject

+ (NSData *)dataWithJSONObject:(id)obj;
+ (id)JSONObjectWithData:(NSData *)data;

@end