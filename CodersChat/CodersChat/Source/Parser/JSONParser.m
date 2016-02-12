//
//  JSONParser.m
//  Zargow
//
//  Created by Northout_101 on 23/01/15.
//  Copyright (c) 2015 Northout. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser


+ (NSData *)dataWithJSONObject:(id)obj{
    
    NSError * error;
    return [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];

}

+ (id)JSONObjectWithData:(NSData *)data{
    
    
    NSError * error;
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];

}


@end