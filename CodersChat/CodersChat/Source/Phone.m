//
//  Phone.m
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "Phone.h"

@interface Phone ()
{
    // Member variables
    
    NSString *countryCode;
    NSString *countryLetters;
    NSString *nationalNum;
    NSString *internationalNum;		// This follows E164 format. Number as would be dialed with the country code (no + sign).
    
}
@end

@implementation Phone

-(Phone *)init {
    // Construct this object:
    
    self = [super init];
    if(self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    //Do Initialization of all
    
    countryCode		= nil;
    countryLetters		= nil;
    nationalNum		= nil;
    internationalNum	= nil;
}

+(Phone *)initWithCountry:(NSString *)country andNumber:(NSString *)number {
    
    Phone *phone= [[Phone alloc] init];
    phone->countryLetters = country;
    phone->nationalNum = number;
    return phone;
}

-(NSDictionary *)getPhoneDict{
    
    
    NSMutableDictionary *phoneDict = [NSMutableDictionary dictionary];
    
    if(countryCode)
        [phoneDict setValue:countryCode forKey:@"countryCode"];
    if(countryLetters)
        [phoneDict setValue:countryLetters forKey:@"countryLetters"];
    if(nationalNum)
        [phoneDict setValue:nationalNum forKey:@"nationalNum"];
    if(internationalNum)
        [phoneDict setValue:internationalNum forKey:@"internationalNum"];
    
    return phoneDict;
}

@end

