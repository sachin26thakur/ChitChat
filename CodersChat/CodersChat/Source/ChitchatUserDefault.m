//
//  ChitchatUserDefault.m
//  CodersChat
//
//  Created by Vishal Bhadade on 12/02/16.
//  Copyright (c) 2016 GlobalLogic. All rights reserved.
//

#import "ChitchatUserDefault.h"

#define SELECTED_LANGUAGE @"selectedLanguage"
#define Username @"UserName"
#define Password @"UserPass"
#define UserID @"userID"

#define contactSynced @"contactSynced"
#define userLoggedIn @"userLoggedIn"


@implementation ChitchatUserDefault


+ (NSString*)selectedUserLanguage{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_LANGUAGE];
}



+ (void)setSelectedUserLanguage:(NSString*)languge{
    
    if (languge == nil) {
        return;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:languge forKey:SELECTED_LANGUAGE];
    [userDefault synchronize];
}


+ (NSArray*)languageList{
    NSMutableDictionary *languageDictionary = [NSMutableDictionary new];
    [languageDictionary setObject:@"mr" forKey:@"Marathi"];
    [languageDictionary setObject:@"ar" forKey:@"Arabic"];
    [languageDictionary setObject:@"bs_Latn" forKey:@"Bosnian(Latin)"];
    [languageDictionary setObject:@"bg" forKey:@"Bulgarian"];
    [languageDictionary setObject:@"ca" forKey:@"Catalan"];
    [languageDictionary setObject:@"zh_CHS" forKey:@"Chinese Simplified"];
    [languageDictionary setObject:@"zh_CHT" forKey:@"Chinese Traditional"];
    [languageDictionary setObject:@"hr" forKey:@"Croatian"];
    [languageDictionary setObject:@"cs" forKey:@"Czech"];
    [languageDictionary setObject:@"da" forKey:@"Danish"];
    [languageDictionary setObject:@"nl" forKey:@"Dutch"];
    [languageDictionary setObject:@"en" forKey:@"English"];
    [languageDictionary setObject:@"et" forKey:@"Estonian"];
    [languageDictionary setObject:@"fi" forKey:@"Finnish"];
    [languageDictionary setObject:@"fr" forKey:@"French"];
    [languageDictionary setObject:@"de" forKey:@"German"];
    [languageDictionary setObject:@"el" forKey:@"Greek"];
    [languageDictionary setObject:@"ht" forKey:@"Haitian Creole"];
    [languageDictionary setObject:@"he" forKey:@"Hebrew"];
    [languageDictionary setObject:@"hi" forKey:@"Hindi"];
    [languageDictionary setObject:@"hu" forKey:@"Hungarian"];
    [languageDictionary setObject:@"id" forKey:@"Indonesian"];
    [languageDictionary setObject:@"it" forKey:@"Italian"];
    [languageDictionary setObject:@"ja" forKey:@"Japanese"];
    [languageDictionary setObject:@"sw" forKey:@"Swahili"];
    [languageDictionary setObject:@"ko" forKey:@"Korean"];
    [languageDictionary setObject:@"lv" forKey:@"Latvian"];
    [languageDictionary setObject:@"it" forKey:@"Lithuanian"];
    [languageDictionary setObject:@"ms" forKey:@"malay"];
    [languageDictionary setObject:@"mt" forKey:@"Maltese"];
    [languageDictionary setObject:@"fa" forKey:@"Persian"];
    [languageDictionary setObject:@"pl" forKey:@"Polish"];
    [languageDictionary setObject:@"pt" forKey:@"Portuguese"];
    [languageDictionary setObject:@"ro" forKey:@"Romanian"];
    [languageDictionary setObject:@"ru" forKey:@"Russian"];
    [languageDictionary setObject:@"sr_Cyrl" forKey:@"Serbian (Cyrillic)"];
    [languageDictionary setObject:@"sr_Latn" forKey:@"Serbian (Latin)"];
    [languageDictionary setObject:@"sk" forKey:@"Slovak"];
    [languageDictionary setObject:@"sl" forKey:@"Slovenian"];
    [languageDictionary setObject:@"es" forKey:@"Spanish"];
    [languageDictionary setObject:@"sv" forKey:@"Swedish"];
    [languageDictionary setObject:@"th" forKey:@"Thai"];
    [languageDictionary setObject:@"tr" forKey:@"Turkish"];
    [languageDictionary setObject:@"uk" forKey:@"Ukrainian)"];
    [languageDictionary setObject:@"ur" forKey:@"urdu"];
    [languageDictionary setObject:@"vi" forKey:@"Vietnamese"];
    [languageDictionary setObject:@"cy" forKey:@"Welsh"];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *keys = [languageDictionary allKeys];
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [arr addObject:obj];
    }];
    
    return arr;
}


+ (NSString*)lanuageCodeForSelectedLanaguge{
    
    
    NSMutableDictionary *languageDictionary = [NSMutableDictionary new];
    [languageDictionary setObject:@"mr" forKey:@"Marathi"];
    [languageDictionary setObject:@"ar" forKey:@"Arabic"];
    [languageDictionary setObject:@"bs_Latn" forKey:@"Bosnian(Latin)"];
    [languageDictionary setObject:@"bg" forKey:@"Bulgarian"];
    [languageDictionary setObject:@"ca" forKey:@"Catalan"];
    [languageDictionary setObject:@"zh_CHS" forKey:@"Chinese Simplified"];
    [languageDictionary setObject:@"zh_CHT" forKey:@"Chinese Traditional"];
    [languageDictionary setObject:@"hr" forKey:@"Croatian"];
    [languageDictionary setObject:@"cs" forKey:@"Czech"];
    [languageDictionary setObject:@"da" forKey:@"Danish"];
    [languageDictionary setObject:@"nl" forKey:@"Dutch"];
    [languageDictionary setObject:@"en" forKey:@"English"];
    [languageDictionary setObject:@"et" forKey:@"Estonian"];
    [languageDictionary setObject:@"fi" forKey:@"Finnish"];
    [languageDictionary setObject:@"fr" forKey:@"French"];
    [languageDictionary setObject:@"de" forKey:@"German"];
    [languageDictionary setObject:@"el" forKey:@"Greek"];
    [languageDictionary setObject:@"ht" forKey:@"Haitian Creole"];
    [languageDictionary setObject:@"he" forKey:@"Hebrew"];
    [languageDictionary setObject:@"hi" forKey:@"Hindi"];
    [languageDictionary setObject:@"hu" forKey:@"Hungarian"];
    [languageDictionary setObject:@"id" forKey:@"Indonesian"];
    [languageDictionary setObject:@"it" forKey:@"Italian"];
    [languageDictionary setObject:@"ja" forKey:@"Japanese"];
    [languageDictionary setObject:@"sw" forKey:@"Swahili"];
    [languageDictionary setObject:@"ko" forKey:@"Korean"];
    [languageDictionary setObject:@"lv" forKey:@"Latvian"];
    [languageDictionary setObject:@"it" forKey:@"Lithuanian"];
    [languageDictionary setObject:@"ms" forKey:@"malay"];
    [languageDictionary setObject:@"mt" forKey:@"Maltese"];
    [languageDictionary setObject:@"fa" forKey:@"Persian"];
    [languageDictionary setObject:@"pl" forKey:@"Polish"];
    [languageDictionary setObject:@"pt" forKey:@"Portuguese"];
    [languageDictionary setObject:@"ro" forKey:@"Romanian"];
    [languageDictionary setObject:@"ru" forKey:@"Russian"];
    [languageDictionary setObject:@"sr_Cyrl" forKey:@"Serbian (Cyrillic)"];
    [languageDictionary setObject:@"sr_Latn" forKey:@"Serbian (Latin)"];
    [languageDictionary setObject:@"sk" forKey:@"Slovak"];
    [languageDictionary setObject:@"sl" forKey:@"Slovenian"];
    [languageDictionary setObject:@"es" forKey:@"Spanish"];
    [languageDictionary setObject:@"sv" forKey:@"Swedish"];
    [languageDictionary setObject:@"th" forKey:@"Thai"];
    [languageDictionary setObject:@"tr" forKey:@"Turkish"];
    [languageDictionary setObject:@"uk" forKey:@"Ukrainian)"];
    [languageDictionary setObject:@"ur" forKey:@"urdu"];
    [languageDictionary setObject:@"vi" forKey:@"Vietnamese"];
    [languageDictionary setObject:@"cy" forKey:@"Welsh"];

    NSString *selectedLanguge = [self selectedUserLanguage];

    return [languageDictionary objectForKey:selectedLanguge];
}



+ (void)setUserName:(NSString*)username{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:username forKey:Username];
    [userdefaults synchronize];
}


+ (NSString *)username{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:Username];
}


+ (void)setPassword:(NSString*)password{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:password forKey:Password];
    [userdefaults synchronize];
}


+ (NSString *)password{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:Password];
}


+ (void)setUserID:(NSString*)userID{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:userID forKey:UserID];
    [userdefaults synchronize];
}

+ (NSString *)userId{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:UserID];
}


+ (void)setContactSynced:(BOOL)iscontactSynced{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setBool:iscontactSynced forKey:contactSynced];
    [userdefaults synchronize];
}


+ (BOOL)isContactSynced{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    return [userdefaults boolForKey:contactSynced];
}


+ (void)setIsUserLoggin:(BOOL)isLoggedIn{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setBool:isLoggedIn forKey:userLoggedIn];
    [userdefaults synchronize];
}


+ (BOOL)isUserLogginIn{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    return [userdefaults boolForKey:userLoggedIn];
}




@end
