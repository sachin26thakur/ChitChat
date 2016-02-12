//
//  VCard.m
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "VCard.h"
#import "Media.h"
#import "Utility.h"

@interface VCard ()
{
    // Member variables
    
    eObjType objType;
    eCardType cardType;
    
    NSString *_id;
    NSString *name;
    NSString *uname;
    NSString *creator_id;
    NSString *creator_name;
    NSString *creator_uname;
    NSString *otherStuff;
    NSString *status;
    
    NSDate *timeCreated;
    NSDate *timeUpdated;
    
    Media *picture;
    Media *video;
    
}
@end

@implementation VCard

-(VCard *)init {
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
    
    objType = oj_VCARD;
    cardType = NOCARD;
    
    _id		= nil;
    name		= nil;
    uname  		= nil;
    creator_id	= nil;
    creator_name	= nil;
    creator_uname	= nil;
    otherStuff	= nil;
    timeCreated 	= nil;
    timeUpdated	= nil;
    
    picture		= nil;
    video		= nil;
    
}

-(VCard *)initZNameCardWithName:(NSString *)name_ Uname:(NSString *)uName_ andStuff:(NSString *)stuff_ {
    
    self = [self init];
    if(self)
    {
        cardType = cd_USER;
        name = name_;
        uname = uName_;
        otherStuff = stuff_;
    }
    return self;
}

-(VCard *)initCard:(eCardType)cardType_ cardName:(NSString *)name_ Uname:(NSString *)uName_ andStuff:(NSString *)stuff_ picture:(NSData *)picture_ video:(NSData *)video_{
    
    self = [self init];
    if(self)
    {
        cardType = cardType_;
        name = name_;
        uname = uName_;
        otherStuff = stuff_;
        if(picture_)
            picture = [Media getMedia:picture_ andFormat:@"jpg" ifLowRes:false andMediaType:ma_IMAGE];
        if(video_)
            video = [Media getMedia:video_ andFormat:@"avi" ifLowRes:false andMediaType:ma_VIDEO];
        
    }
    return self;
}

-(NSString *)getCardString{
    
    NSDictionary *cardDict = [self getCardDict];
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:cardDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *msgString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    return msgString;
}

-(NSDictionary *)getCardDict{
    
    NSMutableDictionary *cardDict = [NSMutableDictionary dictionary];
    
    if(objType !=NOOBJ)
        [cardDict setValue:[Utility ObjectTypeToString:objType]forKey:@"objType"];
    if(cardType !=NOCARD)
        [cardDict setValue:[Utility CardTypeToString:cardType]forKey:@"cardType"];
    if(_id)
        [cardDict setValue:_id forKey:@"_id"];
    if(name)
        [cardDict setValue:name forKey:@"name"];
    if(uname)
        [cardDict setValue:uname forKey:@"uname"];
    if(creator_id)
        [cardDict setValue:creator_id forKey:@"creator_id"];
    if(creator_name)
        [cardDict setValue:creator_name forKey:@"creator_name"];
    if(creator_uname)
        [cardDict setValue:creator_uname forKey:@"creator_uname"];
    if(otherStuff)
        [cardDict setValue:otherStuff forKey:@"otherStuff"];
    if(timeCreated)
        [cardDict setValue:timeCreated forKey:@"timeCreated"];
    if(timeUpdated)
        [cardDict setValue:timeUpdated forKey:@"timeUpdated"];
    if(picture){
        [cardDict setValue:[picture getMediaDict] forKey:@"picture"];
    }
    if(status){
        [cardDict setValue:status forKey:@"status"];
    }
    if(video){
        [cardDict setValue:[video getMediaDict] forKey:@"video"];
        
    }
    
    return cardDict;
}

-(NSString *)getCardID{
    return _id;
}

+(NSDictionary *)getUserCardDictWithName:(NSString *)name number:(NSString*)number uname:(NSString *)uname pass:(NSString *)pass{
    
    VCard *vCard = [[VCard alloc] init];
    vCard->objType = oj_VCARD;
    vCard->cardType = cd_USER;
    vCard->name = name;
    vCard->uname = uname;
    vCard->otherStuff = nil;
    
    if (false) {
       // UIImage *imageResize =[[UIImage imageWithData:objSharedData.dictSignUpInfo[@"image"]] userProfileImageForSize:CGSizeMake(180, 180)];
       // vCard->picture =  [Media getMedia:UIImageJPEGRepresentation(imageResize, 1) highData:objSharedData.dictSignUpInfo[@"image"] andFormat:@"png" andMediaType:ma_IMAGE];
    } else
        vCard->picture = nil;
    
 //   vCard->video = (objSharedData.dictSignUpInfo[@"video"])? [Media getMedia:objSharedData.dictSignUpInfo[@"lowVideo"] highData:objSharedData.dictSignUpInfo[@"video"] andFormat:@"MP4" andMediaType:ma_VIDEO] : nil;
    
    return [vCard getCardDict];
}

+(NSDictionary *)getEditedCardDictForType:(eCardType)cardType_ WithID:(NSString *)id_ andRequestData:(NSDictionary *)requestDict{
    
    VCard *vCard = [[VCard alloc] init];
    vCard->objType = oj_VCARD;
    vCard->cardType = cardType_;//cd_USER;//
    vCard->_id = id_;//[SocketStream sharedSocketObject].userID;
    
    if(requestDict[@"EditedStuff"])
            vCard->otherStuff = requestDict[@"EditedStuff"];
        
    if(requestDict[@"EditedStatus"])
            vCard->status = requestDict[@"EditedStatus"];
    
    
    return [vCard getCardDict];
}


+(instancetype)setCardFromDict:(NSDictionary *)cardDict{
    
    VCard *vCard = [[VCard alloc] init];
    
    if(cardDict[@"objType"])
        vCard->objType = [Utility ObjectTypeFromString:cardDict[@"objType"]];
    if(cardDict[@"cardType"])
        vCard->cardType = [Utility CardTypeFromString:cardDict[@"cardType"]];
    if(cardDict[@"_id"])
        vCard->_id = cardDict[@"_id"];
    if(cardDict[@"name"])
        vCard->name = cardDict[@"name"];
    if(cardDict[@"uname"])
        vCard->uname = cardDict[@"uname"];
    if(cardDict[@"creator_id"])
        vCard->creator_id = cardDict[@"creator_id"];
    if(cardDict[@"creator_name"])
        vCard->creator_name = cardDict[@"creator_name"];
    if(cardDict[@"creator_uname"])
        vCard->creator_uname = cardDict[@"creator_uname"];
    if(cardDict[@"otherStuff"])
        vCard->otherStuff = cardDict[@"otherStuff"];
    if(cardDict[@"timeCreated"])
        vCard->timeCreated = [NSDate dateWithTimeIntervalSince1970:[cardDict[@"timeCreated"] longLongValue]];
    if(cardDict[@"timeUpdated"])
        vCard->timeUpdated = [NSDate dateWithTimeIntervalSince1970:[cardDict[@"timeUpdated"] longLongValue]];
    if(cardDict[@"picture"] && (cardDict[@"picture"][@"lowRes"] || cardDict[@"picture"][@"highRes"])){
        if(cardDict[@"picture"][@"lowRes"])
            vCard->picture = [Media getMedia:[[NSData alloc] initWithBase64EncodedString:cardDict[@"picture"][@"lowRes"] options:0] andFormat:@"jpg" ifLowRes:true andMediaType:ma_IMAGE];
        else
            vCard->picture = [Media getMedia:[[NSData alloc] initWithBase64EncodedString:cardDict[@"picture"][@"highRes"] options:0] andFormat:@"jpg" ifLowRes:false andMediaType:ma_IMAGE];
    }
    if(cardDict[@"video"] && (cardDict[@"video"][@"lowRes"] || cardDict[@"video"][@"highRes"])){
        if(cardDict[@"picture"][@"lowRes"])
            vCard->video = [Media getMedia:[[NSData alloc] initWithBase64EncodedString:cardDict[@"video"][@"lowRes"] options:0] andFormat:@"avi" ifLowRes:true andMediaType:ma_VIDEO];
        else
            vCard->video = [Media getMedia:[[NSData alloc] initWithBase64EncodedString:cardDict[@"video"][@"highRes"] options:0] andFormat:@"avi" ifLowRes:false andMediaType:ma_VIDEO];
        
    }
    
    return vCard;
}

@end

