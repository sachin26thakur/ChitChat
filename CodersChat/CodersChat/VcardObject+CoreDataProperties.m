//
//  VcardObject+CoreDataProperties.m
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "VcardObject+CoreDataProperties.h"
#import "ChatMessageObject.h"
#import "MediaObject.h"
#import "PrivateGroupObject.h"
#import "Utility.h"

@implementation VcardObject (CoreDataProperties)

@dynamic cardType;
@dynamic creator_id;
@dynamic creator_name;
@dynamic creator_uname;
@dynamic friendRequestPending;
@dynamic friendRequestSeen;
@dynamic id_;
@dynamic isAvatarFollowing;
@dynamic isFriend;
@dynamic isRadarFriend;
@dynamic lastMessage;
@dynamic lastMessageTimeStamp;
@dynamic name;
@dynamic objType;
@dynamic otherStuff;
@dynamic status;
@dynamic timeCreated;
@dynamic timeUpdated;
@dynamic uname;
@dynamic unReadMessageCount;
@dynamic downloaded_emoji_sticker_relationship;
@dynamic group_admin_relationship;
@dynamic group_card_relationship;
@dynamic group_relationship;
@dynamic image_relationship;
@dynamic my_emoji_sticker_relationship;
@dynamic phone_relationship;
@dynamic post_relationship;
@dynamic video_relationship;



+(VcardObject *)setObjectFromDict:(NSDictionary *)cardDict{
    
    VcardObject *vCard = (VcardObject *)[NSEntityDescription
                                         entityForName:@"VcardObject"
                                         inManagedObjectContext:[DatabaseHelper getManagedContext]];
    if(cardDict[@"objType"])
        vCard.objType = cardDict[@"objType"];
    if(cardDict[@"cardType"])
        vCard.cardType = cardDict[@"cardType"];
    if(cardDict[@"_id"])
        vCard.id_ = cardDict[@"_id"];
    if(cardDict[@"name"])
        vCard.name = cardDict[@"name"];
    if(cardDict[@"uname"])
        vCard.uname = cardDict[@"uname"];
    if(cardDict[@"creator_id"])
        vCard.creator_id = cardDict[@"creator_id"];
    if(cardDict[@"creator_name"])
        vCard.creator_name = cardDict[@"creator_name"];
    if(cardDict[@"creator_uname"])
        vCard.creator_uname = cardDict[@"creator_uname"];
    if(cardDict[@"otherStuff"])
        vCard.otherStuff = cardDict[@"otherStuff"];
    
    if(cardDict[@"timeCreated"])
        vCard.timeCreated = cardDict[@"timeCreated"];
    if(cardDict[@"timeUpdated"])
        vCard.timeUpdated = cardDict[@"timeUpdated"];
    
    if(cardDict[@"isRadarFriend"])
        vCard.isRadarFriend = cardDict[@"isRadarFriend"];
    if(cardDict[@"isFriend"])
        vCard.isFriend = cardDict[@"isFriend"];
    if(cardDict[@"isAvatarFollowing"])
        vCard.isAvatarFollowing = cardDict[@"isAvatarFollowing"];
    
    if(cardDict[@"friendRequestPending"])
        vCard.friendRequestPending = cardDict[@"friendRequestPending"];
    if(cardDict[@"friendRequestSeen"])
        vCard.friendRequestSeen = cardDict[@"friendRequestSeen"];
    
    if (cardDict[@"unReadMessageCount"]) {
        vCard.unReadMessageCount = cardDict[@"unReadMessageCount"];
    }
    
    if(cardDict[@"picture"])
        [vCard setImage_relationship:[MediaObject setMediaFromDict:cardDict[@"picture"]]];
    if(cardDict[@"video"])
        [vCard setVideo_relationship:[MediaObject setMediaFromDict:cardDict[@"video"]]];
    
    return vCard;
}

+(BOOL)saveObjectFromDict:(NSDictionary *)cardDict{
    
    
    VcardObject *vCard = (VcardObject *)[NSEntityDescription
                                         insertNewObjectForEntityForName:@"VcardObject"
                                         inManagedObjectContext:[DatabaseHelper getManagedContext]];
    if(cardDict[@"objType"])
        vCard.objType = cardDict[@"objType"];
    if(cardDict[@"cardType"])
        vCard.cardType = cardDict[@"cardType"];
    if(cardDict[@"_id"])
        vCard.id_ = cardDict[@"_id"];
    if(cardDict[@"name"])
        vCard.name = cardDict[@"name"];
    if(cardDict[@"uname"])
        vCard.uname = cardDict[@"uname"];
    if(cardDict[@"creator_id"])
        vCard.creator_id = cardDict[@"creator_id"];
    if(cardDict[@"creator_name"])
        vCard.creator_name = cardDict[@"creator_name"];
    if(cardDict[@"creator_uname"])
        vCard.creator_uname = cardDict[@"creator_uname"];
    if(cardDict[@"otherStuff"])
        vCard.otherStuff = cardDict[@"otherStuff"];
    if(cardDict[@"status"])
        vCard.status = cardDict[@"status"];
    
    if(cardDict[@"timeCreated"])
        vCard.timeCreated = cardDict[@"timeCreated"];
    if(cardDict[@"timeUpdated"])
        vCard.timeUpdated = cardDict[@"timeUpdated"];
    if (cardDict[@"unReadMessageCount"]) {
        vCard.unReadMessageCount = cardDict[@"unReadMessageCount"];
    }
    
    if(cardDict[@"isRadarFriend"])
        vCard.isRadarFriend = cardDict[@"isRadarFriend"];
    if(cardDict[@"isFriend"])
        vCard.isFriend = cardDict[@"isFriend"];
    if(cardDict[@"isAvatarFollowing"])
        vCard.isAvatarFollowing = cardDict[@"isAvatarFollowing"];
    
    if(cardDict[@"friendRequestPending"])
        vCard.friendRequestPending = cardDict[@"friendRequestPending"];
    if(cardDict[@"friendRequestSeen"])
        vCard.friendRequestSeen = cardDict[@"friendRequestSeen"];
    
    
    if(cardDict[@"picture"]){
        [vCard setImage_relationship:[MediaObject setMediaFromDict:cardDict[@"picture"] mediaType:true]];
    }
    if(cardDict[@"video"]){
        [vCard setVideo_relationship:[MediaObject setMediaFromDict:cardDict[@"video"] mediaType:false]];
    }
    
    if(cardDict[@"phone"]){
        //  [vCard setPhone_relationship:[PhoneObject setPhoneFromDict:cardDict[@"phone"]]];
    }
    
    NSError *error;
    if (![[DatabaseHelper getManagedContext] save:&error]) {
        
        NSLog(@"Error SAVING %@",[error description]);
        return NO;
    }
    
    return YES;
    
}

+(BOOL)UpdateObject:(id)Object FromDict:(NSDictionary *)cardDict{
    
    VcardObject *vCard = (VcardObject *)Object;
    if(cardDict[@"objType"])
        vCard.objType = cardDict[@"objType"];
    if(cardDict[@"cardType"])
        vCard.cardType = cardDict[@"cardType"];
    if(cardDict[@"_id"])
        vCard.id_ = cardDict[@"_id"];
    if(cardDict[@"name"])
        vCard.name = cardDict[@"name"];
    if(cardDict[@"uname"])
        vCard.uname = cardDict[@"uname"];
    if(cardDict[@"creator_id"])
        vCard.creator_id = cardDict[@"creator_id"];
    if(cardDict[@"creator_name"])
        vCard.creator_name = cardDict[@"creator_name"];
    if(cardDict[@"creator_uname"])
        vCard.creator_uname = cardDict[@"creator_uname"];
    if(cardDict[@"otherStuff"])
        vCard.otherStuff = cardDict[@"otherStuff"];
    if(cardDict[@"status"])
        vCard.status = cardDict[@"status"];
    
    if (cardDict[@"unReadMessageCount"]) {
        vCard.unReadMessageCount = cardDict[@"unReadMessageCount"];
    }
    
    
    if(cardDict[@"timeCreated"])
        vCard.timeCreated = cardDict[@"timeCreated"];
    if(cardDict[@"timeUpdated"])
        vCard.timeUpdated = cardDict[@"timeUpdated"];
    
    
    if(cardDict[@"isRadarFriend"])
        vCard.isRadarFriend = cardDict[@"isRadarFriend"];
    if(!vCard.isFriend && cardDict[@"isFriend"])
        vCard.isFriend = cardDict[@"isFriend"];
    if(cardDict[@"isAvatarFollowing"])
        vCard.isAvatarFollowing = cardDict[@"isAvatarFollowing"];
    
    if(!vCard.friendRequestPending && cardDict[@"friendRequestPending"])
        vCard.friendRequestPending = cardDict[@"friendRequestPending"];
    if(!vCard.friendRequestSeen && cardDict[@"friendRequestSeen"])
        vCard.friendRequestSeen = cardDict[@"friendRequestSeen"];
    
    
    if(cardDict[@"picture"]){
        [vCard setImage_relationship:[MediaObject setMediaFromDict:cardDict[@"picture"] mediaType:true]];
    }
    if(cardDict[@"video"]){
        [vCard setVideo_relationship:[MediaObject setMediaFromDict:cardDict[@"video"] mediaType:false]];
    }
    
    
    NSError *error;
    if (![[DatabaseHelper getManagedContext] save:&error]) {
        
        NSLog(@"Error SAVING %@",[error description]);
        return NO;
    }
    
    return YES;
    
}


@end
