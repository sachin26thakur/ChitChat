//
//  VCard.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface VCard:NSObject{
    BOOL deletePicture;
    BOOL deleteVideo;
    
}
-(VCard *)initZNameCardWithName:(NSString *)name_ Uname:(NSString *)uName_ andStuff:(NSString *)stuff_;
-(VCard *)initCard:(eCardType)cardType_ cardName:(NSString *)name_ Uname:(NSString *)uName_ andStuff:(NSString *)stuff_ picture:(NSData *)picture_ video:(NSData *)video_;
-(NSDictionary *)getCardDict;
-(NSString *)getCardID;
+(NSDictionary *)getUserCardDict;
+(NSDictionary *)getAvatarCardDict;
+(NSDictionary *)getEditedCardDictForType:(eCardType)cardType_ WithID:(NSString *)id_ andRequestData:(NSDictionary *)requestDict;
+(instancetype)setCardFromDict:(NSDictionary *)cardDict;
@end