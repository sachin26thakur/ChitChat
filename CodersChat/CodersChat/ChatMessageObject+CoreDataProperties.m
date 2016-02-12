//
//  ChatMessageObject+CoreDataProperties.m
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChatMessageObject+CoreDataProperties.h"
#import "MediaObject.h"
#import "VcardObject.h"
#import "Utility.h"
#import "SocketStream.h"
#import "Constants.h"

@implementation ChatMessageObject (CoreDataProperties)

@dynamic ackType;
@dynamic clientMsgID;
@dynamic id_;
@dynamic msgAttributedText;
@dynamic msgDetails;
@dynamic msgLife;
@dynamic msgReqType;
@dynamic msgText;
@dynamic msgType;
@dynamic notifyType;
@dynamic nTimesSent;
@dynamic objType;
@dynamic org_id;
@dynamic rx_id;
@dynamic rxg_id;
@dynamic status;
@dynamic timeFirstSent;
@dynamic timeLastSent;
@dynamic tx_avatar_id;
@dynamic tx_avatar_uname;
@dynamic tx_id;
@dynamic tx_name;
@dynamic tx_uname;
@dynamic media_relationship;
@dynamic post_card_relationship;

+(BOOL)saveObjectFromDict:(NSDictionary *)msgDict{
    
    ChatMessageObject *chatMessage = (ChatMessageObject *)[NSEntityDescription
                                                           insertNewObjectForEntityForName:@"ChatMessageObject"
                                                           inManagedObjectContext:[DatabaseHelper getManagedContext]];
    
    if(msgDict[@"objType"])
        chatMessage.objType = msgDict[@"objType"];
    if(msgDict[@"msgType"])
        chatMessage.msgType = msgDict[@"msgType"];
    if(msgDict[@"notifyType"])
        chatMessage.notifyType = msgDict[@"notifyType"];
    if(msgDict[@"ackType"])
        chatMessage.ackType = msgDict[@"ackType"];
    if(msgDict[@"msgReqType"])
        chatMessage.msgReqType = msgDict[@"msgReqType"];
    if(msgDict[@"clientMsgID"])
        chatMessage.clientMsgID = msgDict[@"clientMsgID"];
    if(msgDict[@"_id"])
        chatMessage.id_ = msgDict[@"_id"];
    if(msgDict[@"org_id"])
        chatMessage.org_id = msgDict[@"org_id"];
    if(msgDict[@"tx_id"])
        chatMessage.tx_id = msgDict[@"tx_id"];
    if(msgDict[@"tx_name"])
        chatMessage.tx_name = msgDict[@"tx_name"];
    if(msgDict[@"tx_uname"])
        chatMessage.tx_uname = msgDict[@"tx_uname"];
    if(msgDict[@"tx_avatar_id"])
        chatMessage.tx_avatar_id = msgDict[@"tx_avatar_id"];
    if(msgDict[@"tx_avatar_uname"])
        chatMessage.tx_avatar_uname = msgDict[@"tx_avatar_uname"];
    
    if(msgDict[@"msgText"])
        chatMessage.msgText = msgDict[@"msgText"];
    if(msgDict[@"msgDetails"])
        chatMessage.msgDetails = msgDict[@"msgDetails"];
    if(msgDict[@"timeFirstSent"])
        chatMessage.timeFirstSent = msgDict[@"timeFirstSent"];
    if(msgDict[@"timeLastSent"])
        chatMessage.timeLastSent = msgDict[@"timeLastSent"];
    if(msgDict[@"nTimesSent"])
        chatMessage.nTimesSent = msgDict[@"nTimesSent"];
    if(msgDict[@"msgLife"])
        chatMessage.msgLife = msgDict[@"msgLife"];
    
    
    if(msgDict[@"media"]){
        MediaObject *mediaObj = [MediaObject setMediaFromDict:msgDict[@"media"]];
        chatMessage.media_relationship = mediaObj;
        if(msgDict[@"media"][@"highRes"]){
            if([Utility MediaTypeFromString:chatMessage.media_relationship.mediaType] == ma_IMAGE){
                
                [[SocketStream sharedSocketObject].library saveImage:[UIImage imageWithData:chatMessage.media_relationship.highRes] toAlbum:@"Zargow" completion:^(NSURL *assetURL, NSError *error) {
                    
                    
                } failure:^(NSError *error) {
                    
                    
                    
                }];
                
            }
            else if([Utility MediaTypeFromString:chatMessage.media_relationship.mediaType] == ma_VIDEO){
                
                NSString *moviePath = [[Utility getDocumentPath] stringByAppendingPathComponent:@"Video.mp4"];
                NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
                [chatMessage.media_relationship.highRes writeToFile:moviePath atomically:YES];
                
                
                [[SocketStream sharedSocketObject].library saveVideo:movieURL toAlbum:@"Zargow" completion:^(NSURL *assetURL, NSError *error) {
                    
                    
                    
                } failure:^(NSError *error) {
                    
                    
                    
                }];
                
            }
        }
    }
    
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VcardObject" inManagedObjectContext:[DatabaseHelper getManagedContext]];
    
    // Setup the fetch request
    [request setEntity:entity];
    //Setup Predicate
    
    NSMutableArray *IDS = (msgDict[@"rx_id"])? [msgDict[@"rx_id"] mutableCopy] : [NSMutableArray array];
    [IDS addObjectsFromArray:msgDict[@"rxg_id"]];
    
    
    if(IDS && [IDS count]){
        NSPredicate *cardPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ IN %@",IDS];
        [request setPredicate:cardPredicate];
    }
    else{
        NSPredicate *cardPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ = %@",msgDict[@"tx_id"]];
        [request setPredicate:cardPredicate];
    }
    
    //Sort Descriptor
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc]
                                                                 initWithKey:@"id_" ascending:true],
                                nil];
    [request setSortDescriptors:sortDescriptors];
    
    // Fetch the card for private group
    NSError *error;
    NSMutableArray *mutableFetchResults = [[[DatabaseHelper getManagedContext] executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {
        // Handle the error.
        // This is a serious error and should advise the user to restart the application
        NSLog(@"Error SAVING");
        // return NO;
    }
    
    if((!IDS || ![IDS count]) && [msgDict[@"msgType"] isEqualToString:[Utility MessageTypeToString:mg_SEND_BROADCAST]]){
        chatMessage.ackType = [Utility AckTypeToString:ak_MSG_RECEIVED];
        [chatMessage setPost_card_relationship:[NSSet setWithArray:mutableFetchResults]];
    }
    else{
        chatMessage.rx_id = msgDict[@"rx_id"];
        chatMessage.rxg_id = msgDict[@"rxg_id"];
        
    }
    
    
    if (![[DatabaseHelper getManagedContext] save:&error]) {
        
        NSLog(@"Error SAVING %@",[error description]);
        return NO;
    }
    
    return YES;
    
}

+(BOOL)UpdateObject:(id)Object FromDict:(NSDictionary *)msgDict{
    
    ChatMessageObject *chatMessage = (ChatMessageObject *)Object;
    
    if(msgDict[@"objType"])
        chatMessage.objType = msgDict[@"objType"];
    if(msgDict[@"msgType"])
        chatMessage.msgType = msgDict[@"msgType"];
    if(msgDict[@"notifyType"])
        chatMessage.notifyType = msgDict[@"notifyType"];
    if(msgDict[@"ackType"])
        chatMessage.ackType = msgDict[@"ackType"];
    if(msgDict[@"msgReqType"])
        chatMessage.msgReqType = msgDict[@"msgReqType"];
    if(msgDict[@"clientMsgID"])
        chatMessage.clientMsgID = msgDict[@"clientMsgID"];
    if(msgDict[@"_id"])
        chatMessage.id_ = msgDict[@"_id"];
    if(msgDict[@"org_id"])
        chatMessage.org_id = msgDict[@"org_id"];
    if(msgDict[@"tx_id"])
        chatMessage.tx_id = msgDict[@"tx_id"];
    if(msgDict[@"tx_uname"])
        chatMessage.tx_uname = msgDict[@"tx_uname"];
    if(msgDict[@"tx_avatar_id"])
        chatMessage.tx_avatar_id = msgDict[@"tx_avatar_id"];
    if(msgDict[@"tx_avatar_uname"])
        chatMessage.tx_avatar_uname = msgDict[@"tx_avatar_uname"];
    
    if(msgDict[@"msgText"])
        chatMessage.msgText = msgDict[@"msgText"];
    if(msgDict[@"msgDetails"])
        chatMessage.msgDetails = msgDict[@"msgDetails"];
    if(msgDict[@"timeFirstSent"])
        chatMessage.timeFirstSent = msgDict[@"timeFirstSent"];
    if(msgDict[@"timeLastSent"])
        chatMessage.timeLastSent = msgDict[@"timeLastSent"];
    if(msgDict[@"nTimesSent"])
        chatMessage.nTimesSent = msgDict[@"nTimesSent"];
    if(msgDict[@"msgLife"])
        chatMessage.msgLife = msgDict[@"msgLife"];
    
    
    if(msgDict[@"media"]){
        MediaObject *mediaObj = chatMessage.media_relationship;
        [MediaObject UpdateObject:mediaObj FromDict:msgDict[@"media"]];
        
        if(msgDict[@"media"][@"highRes"]){
            if([Utility MediaTypeFromString:chatMessage.media_relationship.mediaType] == ma_IMAGE){
                
                [[SocketStream sharedSocketObject].library saveImage:[UIImage imageWithData:chatMessage.media_relationship.highRes] toAlbum:@"Zargow" completion:^(NSURL *assetURL, NSError *error) {
                    
                    
                } failure:^(NSError *error) {
                    
                    
                    
                }];
                
            }
            else if([Utility MediaTypeFromString:chatMessage.media_relationship.mediaType] == ma_VIDEO){
                
                NSString *moviePath = [[Utility getDocumentPath] stringByAppendingPathComponent:@"Video.mp4"];
                NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
                [chatMessage.media_relationship.highRes writeToFile:moviePath atomically:YES];
                
                
                [[SocketStream sharedSocketObject].library saveVideo:movieURL toAlbum:@"Zargow" completion:^(NSURL *assetURL, NSError *error) {
                    
                    
                    
                } failure:^(NSError *error) {
                    
                    
                    
                }];
                
            }
        }
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VcardObject" inManagedObjectContext:[DatabaseHelper getManagedContext]];
    
    // Setup the fetch request
    [request setEntity:entity];
    //Setup Predicate
    
    NSMutableArray *IDS = (msgDict[@"rx_id"])? [msgDict[@"rx_id"] mutableCopy] : [NSMutableArray array];
    [IDS addObjectsFromArray:msgDict[@"rxg_id"]];
    
    
    if(IDS && [IDS count]){
        NSPredicate *cardPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ IN %@",IDS];
        [request setPredicate:cardPredicate];
    }
    else{
        NSPredicate *cardPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ = %@",msgDict[@"tx_id"]];
        [request setPredicate:cardPredicate];
    }
    
    //Sort Descriptor
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc]
                                                                 initWithKey:@"id_" ascending:true],
                                nil];
    [request setSortDescriptors:sortDescriptors];
    
    // Fetch the card for private group
    NSError *error;
    NSMutableArray *mutableFetchResults = [[[DatabaseHelper getManagedContext] executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {
        // Handle the error.
        // This is a serious error and should advise the user to restart the application
        NSLog(@"Error SAVING");
        // return NO;
    }
    
    if((!IDS || ![IDS count]) && [msgDict[@"msgType"] isEqualToString:[Utility MessageTypeToString:mg_SEND_BROADCAST]]){
        chatMessage.ackType = [Utility AckTypeToString:ak_MSG_RECEIVED];
        [chatMessage setPost_card_relationship:[NSSet setWithArray:mutableFetchResults]];
    }
    else{
        chatMessage.rx_id = msgDict[@"rx_id"];
        chatMessage.rxg_id = msgDict[@"rxg_id"];
        
    }
    
    
    if (![[DatabaseHelper getManagedContext] save:&error]) {
        
        NSLog(@"Error SAVING %@",[error description]);
        return NO;
    }
    
    return YES;
    
}
-(BOOL)saveModelObjectTODB{
    
    NSError *error;
    if (![[DatabaseHelper getManagedContext] save:&error]) {
        
        NSLog(@"Error SAVING %@",[error description]);
        return NO;
    }
    
    return YES;
    
}

+(instancetype)getEntityFor:(eObjType)objType_ ackType:(eAckType)ackType_ chatType:(eChatType)chatType_ notifyType:(eNotifyType)notifyType_ msgReqType:(eMsgReqType)msgReqType_ clientMsgID:(long long)clientMsgID_ id:(NSString *)id_ org_id:(NSString *)org_id_ msgLife:(int)msgLife_ msgDetails:(NSString *)msgDetails_ status:(NSString *)status_ nTimesSent:(int)nTimesSent_ timeFirstSent:(long long)timeFirstSent_ timeLastSent:(long long)timeLastSent_ tx_id:(NSString *)tx_id_ tx_name:(NSString *)tx_name_ tx_uname:(NSString *)tx_uname_ tx_avatar_id:(NSString *)tx_avatar_id_ tx_avatar_uname:(NSString *)tx_avatar_uname_ msgText:(NSString *)msgText_ rx_id:(NSArray *)rx_id_ rxg_id:(NSArray *)rxg_id_ mediaObject:(MediaObject *)mediaObject_{
    
    ChatMessageObject *chatMsg = (ChatMessageObject *)[NSEntityDescription
                                                       insertNewObjectForEntityForName:@"ChatMessageObject"
                                                       inManagedObjectContext:[DatabaseHelper getManagedContext]];
    
    chatMsg.objType = [Utility ObjectTypeToString:objType_];
    chatMsg.ackType = [Utility AckTypeToString:ackType_];
    chatMsg.notifyType = [Utility NotifyTypeToString:notifyType_];
    chatMsg.msgReqType = [Utility MessageRequestTypeToString:msgReqType_];
    
    if(objType_ == oj_MESSAGE){
        
        if (!mediaObject_ && !msgText_){
            if(chatType_ == PRIVATE)
                chatMsg.msgType = [Utility MessageTypeToString:mg_SHARE_EMOJI_STICKER];
        }
        else if(tx_name_){
            chatMsg.msgType = [Utility MessageTypeToString:mg_SEND_BROADCAST];
        }
        else if((!rxg_id_ || [rxg_id_ count] == 0 ) && [rx_id_ count] == 1){
            if(chatType_ == PRIVATE)
                chatMsg.msgType = [Utility MessageTypeToString:mg_SEND_PRIVATE_SINGLE];
        }
        else if ((rxg_id_ && [rxg_id_ count] >0) || (rx_id_ && [rx_id_ count]>1)){
            if(chatType_ == PRIVATE)
                chatMsg.msgType = [Utility MessageTypeToString:mg_SEND_PRIVATE_MANY];
        }
        
        
    }
    chatMsg.clientMsgID = @(clientMsgID_);
    chatMsg.id_ = id_;
    chatMsg.org_id = org_id_;
    
    chatMsg.msgLife = @(msgLife_);
    chatMsg.msgDetails = msgDetails_;
    
    chatMsg.status = status_;
    
    chatMsg.nTimesSent = @(nTimesSent_);
    
    unsigned long long numberTimeFirstSent = timeFirstSent_;
    chatMsg.timeFirstSent = [NSNumber numberWithUnsignedLongLong:numberTimeFirstSent];
    unsigned long long numberTimeLastSent = timeLastSent_;
    chatMsg.timeLastSent = [NSNumber numberWithUnsignedLongLong:numberTimeLastSent];
    
    //unsigned long long extracted = [numberValue unsignedLongLongValue];
    
    chatMsg.tx_id = tx_id_;
    chatMsg.tx_uname = tx_uname_;
    chatMsg.tx_name = tx_name_;
    
    chatMsg.tx_avatar_id = tx_avatar_id_;
    chatMsg.tx_avatar_uname = tx_avatar_uname_;
    
    chatMsg.msgText = msgText_;
    chatMsg.media_relationship = mediaObject_;
    
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VcardObject" inManagedObjectContext:[DatabaseHelper getManagedContext]];
    
    // Setup the fetch request
    [request setEntity:entity];
    //Setup Predicate
    
    NSMutableArray *IDS = (rx_id_)? [rx_id_ mutableCopy] : [NSMutableArray array];
    [IDS addObjectsFromArray:rxg_id_];
    
    if(IDS && [IDS count]){
        NSPredicate *cardPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ IN %@",IDS];
        [request setPredicate:cardPredicate];
    }
    else{
        NSPredicate *cardPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ = %@",chatMsg.tx_id];
        [request setPredicate:cardPredicate];
    }
    
    //Sort Descriptor
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc]
                                                                 initWithKey:@"id_" ascending:true],
                                nil];
    [request setSortDescriptors:sortDescriptors];
    
    // Fetch the card for private group
    NSError *error;
    NSMutableArray *mutableFetchResults = [[[DatabaseHelper getManagedContext] executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {
        // Handle the error.
        // This is a serious error and should advise the user to restart the application
        NSLog(@"Error SAVING");
        // return NO;
    }
    
    if(chatType_ == BROADCAST)
        [chatMsg setPost_card_relationship:[NSSet setWithArray:mutableFetchResults]];
    else{
        if(rx_id_)chatMsg.rx_id = [rx_id_ componentsJoinedByString:@","];
        if(rxg_id_) chatMsg.rxg_id = [rxg_id_ componentsJoinedByString:@","];
    }
    return chatMsg;
    
}


+(NSString *)getAuthMessageWithParameters:(BOOL)ifParameters{
    
    NSMutableDictionary *msgDict = [NSMutableDictionary dictionary];
    
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *authDict;
    
    if(!appDelegate.latestDeviceToken)
        ifParameters = false;
    if(ifParameters)
        authDict = @{@"username":[userdefaults objectForKey:UserName],@"password":[userdefaults objectForKey:UserPass],@"deviceToken":appDelegate.latestDeviceToken,@"osVersion":OSVersion,@"appVersion":AppVersion,@"deviceType":DeviceType};
    else{
        authDict = @{@"username":[userdefaults objectForKey:UserName],@"password":[userdefaults objectForKey:UserPass],@"deviceToken":@"9frh76jk82gn69l",@"osVersion":OSVersion,@"appVersion":AppVersion,@"deviceType":DeviceType};
        
    }
    
    
    [msgDict setValue:@"mg_AUTH"forKey:@"msgType"];
    [msgDict setValue:authDict forKey:@"auth"];
    [msgDict setValue:@(-1) forKey:@"msgLife"];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:msgDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *msgString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // NSLog(@"%@",msgString);
    
    return msgString;
}

+(NSString *)getLogMessageString{
    
    return [self getMessageStringFor:[self getMessageLogDict]];
}


-(NSString *)getMessageStringFor:(NSDictionary *)msgDict{
    
    if(!msgDict)
        msgDict = [self getJSONDict];
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:msgDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *msgString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return msgString;
    
}

+(NSString *)getMessageStringFor:(NSDictionary *)msgDict{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:msgDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *msgString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return msgString;
    
}
-(NSDictionary *)getJSONDictForAcknowledgement:(eAckType)ackType{
    
    NSMutableDictionary *msgDict = [NSMutableDictionary dictionary];
    
    
    if(self.objType)
        [msgDict setValue:@"oj_ACKN" forKey:@"objType"];
    [msgDict setValue:[Utility AckTypeToString:ackType] forKey:@"ackType"];
    
    if(![self.clientMsgID  isEqual: @(-1)])
        [msgDict setValue:self.clientMsgID forKey:@"clientMsgID"];
    
    if(self.id_)
        [msgDict setValue:self.id_ forKey:@"org_id"];
    
    if(self.tx_id)
        [msgDict setValue:@[self.tx_id] forKey:@"rx_id"];
    if(self.msgLife)
        [msgDict setValue:self.msgLife forKey:@"msgLife"];
    //  if(self.media_relationship)
    //    [msgDict setValue:[self.media_relationship getMediaObjectDict] forKey:@"media"];
    
    [msgDict setValue:[SocketStream sharedSocketObject].userID forKey:@"tx_id"];
    return msgDict;
    
}

-(NSDictionary *)getJSONDictForFullAcknowledgementOnAck:(NSString *)ackType{
    
    NSMutableDictionary *msgDict = [[self getJSONDictForSimpleAcknowledgement] mutableCopy];
    
    if(self.tx_id)
        [msgDict setValue:@[self.tx_id] forKey:@"rx_id"];
    
    return msgDict;
    
}

-(NSDictionary *)getJSONDictForSimpleAcknowledgement{
    
    NSMutableDictionary *msgDict = [NSMutableDictionary dictionary];
    
    [msgDict setValue:@"oj_ACKN" forKey:@"objType"];
    [msgDict setValue:@"ak_MSG_DELIVERED" forKey:@"ackType"];
    //Changed to send org_id if acknowledgment received.
    if (self.ackType && self.org_id)
        [msgDict setValue:self.org_id forKey:@"org_id"];
    else if(self.id_)
        [msgDict setValue:self.id_ forKey:@"org_id"];
    
    [msgDict setValue:[SocketStream sharedSocketObject].userID forKey:@"tx_id"];
    return msgDict;
    
}

+(NSDictionary *)getNewGroupNotifDictFor:(NSArray *)grpID{
    
    NSMutableDictionary *msgDict = [NSMutableDictionary dictionary];
    
    [msgDict setValue:[Utility ObjectTypeToString:oj_NOTIFY] forKey:@"objType"];
    [msgDict setValue:[Utility NotifyTypeToString:ny_ADDED_TO_PRIVATE_GROUP] forKey:@"notifyType"];
    [msgDict setValue:@1 forKey:@"clientMsgID"];
    [msgDict setValue:grpID forKey:@"rxg_id"];
    [msgDict setValue:[SocketStream sharedSocketObject].userID forKey:@"tx_id"];
    
    
    return msgDict;
    
}

+(NSDictionary *)getUpdateNotifDictForStatus:(NSString *)msgDetails_ withNotify:(eNotifyType)notif_type{
    
    NSMutableDictionary *msgDict = [NSMutableDictionary dictionary];
    
    [msgDict setValue:[Utility ObjectTypeToString:oj_NOTIFY] forKey:@"objType"];
    [msgDict setValue:[Utility NotifyTypeToString:notif_type] forKey:@"notifyType"];
    [msgDict setValue:[SocketStream sharedSocketObject].userID forKey:@"tx_id"];
    if(msgDetails_)
        [msgDict setValue:msgDetails_ forKey:@"msgDetails"];
    
    return msgDict;
    
    
}
+(NSDictionary *)getUpdateNotifDictForSelf:(NSString *)cardID withNotify:(eNotifyType)notif_type msgDetails:(NSString *)msgDetails_ msgText:(NSString *)msgText_ clientIdRequired:(BOOL)clientIdRequired_{
    
    long long clientID = [[NSDate date] timeIntervalSince1970];
    
    NSMutableDictionary *msgDict = [NSMutableDictionary dictionary];
    
    [msgDict setValue:[Utility ObjectTypeToString:oj_NOTIFY] forKey:@"objType"];
    [msgDict setValue:[Utility NotifyTypeToString:notif_type] forKey:@"notifyType"];
    if(clientIdRequired_)
        [msgDict setValue:@(clientID) forKey:@"clientMsgID"];
    if(cardID)
        [msgDict setValue:cardID forKey:@"tx_id"];
    if(msgDetails_)
        [msgDict setValue:msgDetails_ forKey:@"msgDetails"];
    if(msgText_)
        [msgDict setValue:msgText_ forKey:@"msgText"];
    
    [msgDict setValue:[SocketStream sharedSocketObject].userID forKey:@"tx_id"];
    
    
    return msgDict;
    
}


+(NSDictionary *)getUpdateNotifDictForGroup:(NSArray *)grpIds andReceiverID:(NSArray *)rxIDS withNotify:(eNotifyType)notif_type msgDetails:(NSString *)msgDetails_ msgText:(NSString *)msgText_ clientIdRequired:(BOOL)clientIdRequired_{
    
    long long clientID = [[NSDate date] timeIntervalSince1970];
    
    NSMutableDictionary *msgDict = [NSMutableDictionary dictionary];
    
    [msgDict setValue:[Utility ObjectTypeToString:oj_NOTIFY] forKey:@"objType"];
    [msgDict setValue:[Utility NotifyTypeToString:notif_type] forKey:@"notifyType"];
    if(clientIdRequired_)
        [msgDict setValue:@(clientID) forKey:@"clientMsgID"];
    if(rxIDS)
        [msgDict setValue:rxIDS forKey:@"rx_id"];
    if(grpIds)
        [msgDict setValue:grpIds forKey:@"rxg_id"];
    if(msgDetails_)
        [msgDict setValue:msgDetails_ forKey:@"msgDetails"];
    if(msgText_)
        [msgDict setValue:msgText_ forKey:@"msgText"];
    
    [msgDict setValue:[SocketStream sharedSocketObject].userID forKey:@"tx_id"];
    
    return msgDict;
    
}


+(NSDictionary *)getMessageLogDict{
    
    NSMutableDictionary *logDict = [NSMutableDictionary dictionary];
    
    [logDict setValue:[Utility ObjectTypeToString:oj_MSG_REQ] forKey:@"objType"];
    [logDict setValue:[Utility MessageRequestTypeToString:mq_GET_PRIVATE_MSG_LOG] forKey:@"msgReqType"];
    [logDict setValue:@"highRes" forKey:@"msgDetails"];
    [logDict setValue:@-1 forKey:@"msgLife"];
    
    return logDict;
    
}

+(NSDictionary *)getFriendsAddedDict:(NSArray *)frndIds{
    
    NSMutableDictionary *msgDict = [NSMutableDictionary dictionary];
    
    [msgDict setValue:[Utility ObjectTypeToString:oj_NOTIFY] forKey:@"objType"];
    [msgDict setValue:[Utility NotifyTypeToString:ny_PRIVATE_FRIEND_ADDED] forKey:@"notifyType"];
    [msgDict setValue:[SocketStream sharedSocketObject].userID forKey:@"tx_id"];
    [msgDict setValue:frndIds forKey:@"rx_id"];
    
    return msgDict;
    
}


-(NSDictionary *)getJSONDict{
    
    NSMutableDictionary *msgDict = [NSMutableDictionary dictionary];
    
    if(self.objType)
        [msgDict setValue:self.objType forKey:@"objType"];
    if(self.msgType)
        [msgDict setValue:self.msgType forKey:@"msgType"];
    if(self.notifyType)
        [msgDict setValue:self.notifyType forKey:@"notifyType"];
    if(self.ackType)
        [msgDict setValue:self.ackType forKey:@"ackType"];
    if(self.msgReqType)
        [msgDict setValue:self.msgReqType forKey:@"msgReqType"];
    if(![self.clientMsgID  isEqual: @(-1)])
        [msgDict setValue:self.clientMsgID forKey:@"clientMsgID"];
    if(self.id_)
        [msgDict setValue:self.id_ forKey:@"_id"];
    if(self.org_id)
        [msgDict setValue:self.org_id forKey:@"org_id"];
    if(self.tx_id)
        [msgDict setValue:self.tx_id forKey:@"tx_id"];
    
    if(self.tx_name)
        [msgDict setValue:self.tx_name forKey:@"tx_name"];
    if(self.tx_uname)
        [msgDict setValue:self.tx_uname forKey:@"tx_uname"];
    if(self.tx_avatar_id)
        [msgDict setValue:self.tx_avatar_id forKey:@"tx_avatar_id"];
    if(self.tx_avatar_uname)
        [msgDict setValue:self.tx_avatar_uname forKey:@"tx_avatar_uname"];
    if(self.msgText)
        [msgDict setValue:self.msgText forKey:@"msgText"];
    
    if(self.msgDetails)
        [msgDict setValue:self.msgDetails forKey:@"msgDetails"];
    
    if(self.timeFirstSent && ![self.timeFirstSent isEqualToNumber:@0])
        [msgDict setValue:self.timeFirstSent forKey:@"timeFirstSent"];
    if(self.timeLastSent && ![self.timeLastSent isEqualToNumber:@0])
        [msgDict setValue:self.timeLastSent forKey:@"timeLastSent"];
    if(self.nTimesSent && ![self.nTimesSent isEqualToNumber:@0])
        [msgDict setValue:self.nTimesSent forKey:@"nTimesSent"];
    
    if(![self.msgLife  isEqual: @(0)])
        [msgDict setValue:self.msgLife forKey:@"msgLife"];
    
    if(self.media_relationship)
        [msgDict setValue:[self.media_relationship getMediaObjectDict] forKey:@"media"];
    
    // if(self.loc)
    //[msgDict setValue:[loc getLocationDict] forKey:@"loc"];
    
    [msgDict setValue:[self.rx_id componentsSeparatedByString:@","] forKey:@"rx_id"];
    [msgDict setValue:[self.rxg_id componentsSeparatedByString:@","] forKey:@"rxg_id"];
    
    if([Utility ObjectTypeFromString:self.objType] == oj_NOTIFY && ([Utility NotifyTypeFromString:self.notifyType] == ny_PRIVATE_FRIEND_ACCEPT || [Utility NotifyTypeFromString:self.notifyType] == ny_PRIVATE_FRIEND_REQUEST ) && self.rx_id && [self.rx_id length]){
        [msgDict setValue:[self.rx_id componentsSeparatedByString:@","][0] forKey:@"tx_id"];
        [msgDict setValue:@[self.tx_id] forKey:@"rx_id"];
    }
    
    /*
     if(self.card_relationship){
     
     NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"cardType = %@",[Utility CardTypeToString:cd_PRIVATE_GROUP]];
     NSPredicate *singlePredicate = [NSPredicate predicateWithFormat:@"cardType = %@",[Utility CardTypeToString:cd_USER]];
     
     NSArray *rxg_id = [[[self.card_relationship filteredSetUsingPredicate:groupPredicate] allObjects] valueForKeyPath:@"id_"];
     NSArray *rx_id = [[[self.card_relationship filteredSetUsingPredicate:singlePredicate] allObjects] valueForKeyPath:@"id_"];
     
     if(rx_id && [rx_id count] &&  ![rx_id containsObject:[SocketStream sharedSocketObject].userData.id_] && ![rx_id containsObject:[SocketStream sharedSocketObject].avatarData.id_])
     {
     
     [msgDict setValue:rx_id forKey:@"rx_id"];
     
     }
     if([Utility ObjectTypeFromString:self.objType] == oj_NOTIFY && ([Utility NotifyTypeFromString:self.notifyType] == ny_PRIVATE_FRIEND_ACCEPT || [Utility NotifyTypeFromString:self.notifyType] == ny_PRIVATE_FRIEND_REQUEST ) && rx_id && [rx_id count]){
     [msgDict setValue:rx_id[0] forKey:@"tx_id"];
     [msgDict setValue:@[self.tx_id] forKey:@"rx_id"];
     }
     
     if(rxg_id && [rxg_id count])
     [msgDict setValue:rxg_id forKey:@"rxg_id"];
     
     }
     */
    
    return msgDict;
}


+(NSDictionary *)getJsonDictFromSocketString:(NSString *)msgString{
    
    NSError *error;
    NSData *data = [msgString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
}

+(NSString *)getAuthIDFromString:(NSString *)msgString{
    
    NSDictionary *msgDict = [self getJsonDictFromSocketString:msgString];
    if([msgDict[@"msgDetails"] isEqualToString:@"false"])
        return nil;
    else
        return msgDict[@"_id"];
    
}


+(instancetype)setMessageFromDict:(NSDictionary *)msgDict{
    
    
    if([Utility MessageTypeFromString:msgDict[@"msgType"]] == mg_AUTH)
        return nil;
    if(msgDict[@"ackType"]){
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        // Define our table/entity to use
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChatMessageObject" inManagedObjectContext:[DatabaseHelper getManagedContext]];
        
        // Setup the fetch request
        [request setEntity:entity];
        
        if(msgDict[@"clientMsgID"])
        {
            NSPredicate *clientIDPredicate = [NSPredicate predicateWithFormat:@"clientMsgID = %@ OR id_ = %@",msgDict[@"clientMsgID"],msgDict[@"org_id"]];
            [request setPredicate:clientIDPredicate];
        }
        else{
            NSPredicate *orgIDPredicate = [NSPredicate predicateWithFormat:@"id_ = %@",msgDict[@"org_id"]];
            [request setPredicate:orgIDPredicate];
        }
        
        
        //Sort Descriptor
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc]
                                                                     initWithKey:@"clientMsgID" ascending:true],
                                    nil];
        [request setSortDescriptors:sortDescriptors];
        
        // Fetch the card for private group
        
        NSError *error;
        NSMutableArray *mutableFetchResults = [[[DatabaseHelper getManagedContext] executeFetchRequest:request error:&error] mutableCopy];
        if (!mutableFetchResults) {
            // Handle the error.
            // This is a serious error and should advise the user to restart the application
            NSLog(@"Error SAVING");
            // return NO;
        }
        if(mutableFetchResults && [mutableFetchResults count]){
            
            ChatMessageObject *ackMessage = [mutableFetchResults lastObject];
            //ackMessage.objType = msgDict[@"objType"];
            if(!ackMessage.ackType && msgDict[@"timeFirstSent"]){
                ackMessage.timeFirstSent = msgDict[@"timeFirstSent"];
                ackMessage.timeLastSent = msgDict[@"timeFirstSent"];
            }
            
            if([msgDict[@"ackType"] isEqualToString:@"ak_MSG_RECEIVED"]){
                ackMessage.org_id = msgDict[@"_id"]; //Earliar from _id here VS
                ackMessage.id_ = msgDict[@"org_id"]; // //Earliar from org_id here VS
                if(![ackMessage.ackType isEqualToString:@"ak_MSG_DELIVERED"] && ![ackMessage.ackType isEqualToString:@"ak_MSG_READ"])
                    ackMessage.ackType = msgDict[@"ackType"];
            }
            else{
                ackMessage.org_id = msgDict[@"_id"]; //Earliar from _id here VS
                ackMessage.ackType = msgDict[@"ackType"];
            }
            
            [DatabaseHelper saveManagedContext];
            return ackMessage;
        }
        else{
            ChatMessageObject *chatMessage = (ChatMessageObject *)[NSEntityDescription
                                                                   insertNewObjectForEntityForName:@"ChatMessageObject"
                                                                   inManagedObjectContext:[DatabaseHelper getManagedContext]];
            
            if(msgDict[@"objType"])
                chatMessage.objType = msgDict[@"objType"];
            if(msgDict[@"ackType"])
                chatMessage.ackType = msgDict[@"ackType"];
            if(msgDict[@"_id"])
                chatMessage.id_ = msgDict[@"org_id"];  ////Earliar in org_id here VS
            if(msgDict[@"org_id"])
                chatMessage.org_id = msgDict[@"_id"]; ////Earliar in id_ here VS
            
            
            return chatMessage;
        }
        
        
    }
    else{
        
        ChatMessageObject *chatMessage = [DatabaseHelper getExistingRecordModel:@"ChatMessageObject" byID:msgDict[@"_id"]];
        
        if(!chatMessage){
            
            chatMessage = (ChatMessageObject *)[NSEntityDescription
                                                insertNewObjectForEntityForName:@"ChatMessageObject"
                                                inManagedObjectContext:[DatabaseHelper getManagedContext]];
            
            if(msgDict[@"objType"])
                chatMessage.objType = msgDict[@"objType"];
            if(msgDict[@"msgType"])
                chatMessage.msgType = msgDict[@"msgType"];
            if(msgDict[@"_id"])
                chatMessage.id_ = msgDict[@"_id"];
            
            if(msgDict[@"notifyType"])
                chatMessage.notifyType = msgDict[@"notifyType"];
            if(msgDict[@"ackType"])
                chatMessage.ackType = msgDict[@"ackType"];
            if(msgDict[@"msgReqType"])
                chatMessage.msgReqType = msgDict[@"msgReqType"];
            if(msgDict[@"clientMsgID"])
                chatMessage.clientMsgID = msgDict[@"clientMsgID"];
            
            if(msgDict[@"org_id"])
                chatMessage.org_id = msgDict[@"org_id"];
            if(!chatMessage.id_)
                chatMessage.id_  = chatMessage.org_id; ////Earliar from chatMessage.org_id here VS
            if(msgDict[@"tx_id"])
                chatMessage.tx_id = msgDict[@"tx_id"];
            if(msgDict[@"tx_uname"])
                chatMessage.tx_uname = msgDict[@"tx_uname"];
            if(msgDict[@"tx_avatar_id"])
                chatMessage.tx_avatar_id = msgDict[@"tx_avatar_id"];
            if(msgDict[@"tx_avatar_uname"])
                chatMessage.tx_avatar_uname = msgDict[@"tx_avatar_uname"];
            
            if(msgDict[@"msgText"])
                chatMessage.msgText = msgDict[@"msgText"];
            
            if(msgDict[@"msgDetails"])
                chatMessage.msgDetails = msgDict[@"msgDetails"];
            
            if([Utility ObjectTypeFromString:chatMessage.objType] == oj_NOTIFY && ([Utility NotifyTypeFromString:chatMessage.notifyType] == ny_ADDED_TO_PRIVATE_GROUP || [Utility NotifyTypeFromString:chatMessage.notifyType] == ny_PRIVATE_GROUP_UPDATE))
                chatMessage.msgDetails = msgDict[@"rxg_id"][0];
            
            if(msgDict[@"timeFirstSent"])
                chatMessage.timeFirstSent = msgDict[@"timeFirstSent"];
            if(msgDict[@"timeLastSent"])
                chatMessage.timeLastSent = msgDict[@"timeLastSent"];
            if(msgDict[@"nTimesSent"])
                chatMessage.nTimesSent = msgDict[@"nTimesSent"];
            if(msgDict[@"msgLife"])
                chatMessage.msgLife = msgDict[@"msgLife"];
            
            if(msgDict[@"media"]){
                chatMessage.media_relationship =  [MediaObject setMediaFromDict:msgDict[@"media"]];
                //            chatMessage.media_relationship = [MediaObject getEntityFor:(msgDict[@"media"][@"highRes"]) ?[[NSData alloc] initWithBase64EncodedString:msgDict[@"media"][@"highRes"] options:0]:nil lowRes:(msgDict[@"media"][@"lowRes"]) ? [[NSData alloc] initWithBase64EncodedString:msgDict[@"media"][@"lowRes"] options:0] : nil mediaFormat:[Utility MediaFormatFromString:msgDict[@"media"][@"mediaFormat"]] mediaType:[Utility MediaTypeFromString:msgDict[@"media"][@"mediaType"]] mediaPath:nil];
                
                if(chatMessage.media_relationship.highRes){
                    if([Utility MediaTypeFromString:chatMessage.media_relationship.mediaType] == ma_IMAGE){
                        
                        [[SocketStream sharedSocketObject].library saveImage:[UIImage imageWithData:chatMessage.media_relationship.highRes] toAlbum:@"Zargow" completion:^(NSURL *assetURL, NSError *error) {
                            
                            
                        } failure:^(NSError *error) {
                            
                            
                            
                        }];
                        
                    }
                    else if([Utility MediaTypeFromString:chatMessage.media_relationship.mediaType] == ma_VIDEO){
                        
                        NSString *moviePath = [[Utility getDocumentPath] stringByAppendingPathComponent:@"Video.mp4"];
                        NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
                        [chatMessage.media_relationship.highRes writeToFile:moviePath atomically:YES];
                        
                        
                        [[SocketStream sharedSocketObject].library saveVideo:movieURL toAlbum:@"Zargow" completion:^(NSURL *assetURL, NSError *error) {
                            
                        } failure:^(NSError *error) {
                            
                        }];
                        
                    }
                }
            }
            
            //New Change
            if([chatMessage.msgType isEqualToString:[Utility MessageTypeToString:mg_SEND_BROADCAST]])
            {
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                
                // Define our table/entity to use
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"VcardObject" inManagedObjectContext:[DatabaseHelper getManagedContext]];
                
                // Setup the fetch request
                [request setEntity:entity];
                
                //Setup Predicate
                NSMutableArray *IDS = [NSMutableArray array];
                if([msgDict[@"rx_id"] containsObject:[SocketStream sharedSocketObject].userID])
                {
                    if([Utility ObjectTypeFromString:chatMessage.objType] == oj_NOTIFY && ([Utility NotifyTypeFromString:chatMessage.notifyType] == ny_PRIVATE_FRIEND_ACCEPT || [Utility NotifyTypeFromString:chatMessage.notifyType] == ny_PRIVATE_FRIEND_REQUEST )){
                        
                        [IDS addObjectsFromArray:msgDict[@"rx_id"]];
                        
                    }
                    else
                        [IDS addObject:msgDict[@"tx_id"]];
                }
                
                [IDS addObjectsFromArray:msgDict[@"rxg_id"]];
                
                NSPredicate *cardPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ IN %@",IDS];
                [request setPredicate:cardPredicate];
                
                //Sort Descriptor
                NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc]
                                                                             initWithKey:@"id_" ascending:true],
                                            nil];
                [request setSortDescriptors:sortDescriptors];
                
                // Fetch the card for private group
                
                NSError *error;
                NSMutableArray *mutableFetchResults = [[[DatabaseHelper getManagedContext] executeFetchRequest:request error:&error] mutableCopy];
                if (mutableFetchResults && [mutableFetchResults count])
                    [chatMessage setPost_card_relationship:[NSSet setWithArray:mutableFetchResults]];
            }
            else{
                if(msgDict[@"rx_id"] && [msgDict[@"rx_id"] containsObject: [SocketStream sharedSocketObject].userID])
                    chatMessage.rx_id = msgDict[@"tx_id"];
                chatMessage.rxg_id = [msgDict[@"rxg_id"] componentsJoinedByString:@","];
            }
            
            NSError *error;
            if (![[DatabaseHelper getManagedContext] save:&error]) {
                
                NSLog(@"Error SAVING %@",[error description]);
                return chatMessage;
            }
            return chatMessage;
        }
        return nil;
        
    }
    
    //        NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //
    //        // Define our table/entity to use
    //        NSEntityDescription *entity = [NSEntityDescription entityForName:@"VcardObject" inManagedObjectContext:[DatabaseHelper getManagedContext]];
    //
    //        // Setup the fetch request
    //        [request setEntity:entity];
    //
    //        //Setup Predicate
    //        NSMutableArray *IDS = [NSMutableArray array];
    //        if([msgDict[@"rx_id"] containsObject:[SocketStream sharedSocketObject].userID])
    //        {
    //            if([Utility ObjectTypeFromString:chatMessage.objType] == oj_NOTIFY && ([Utility NotifyTypeFromString:chatMessage.notifyType] == ny_PRIVATE_FRIEND_ACCEPT || [Utility NotifyTypeFromString:chatMessage.notifyType] == ny_PRIVATE_FRIEND_REQUEST )){
    //
    //                [IDS addObjectsFromArray:msgDict[@"rx_id"]];
    //
    //            }
    //            else
    //                [IDS addObject:msgDict[@"tx_id"]];
    //        }
    //
    //        [IDS addObjectsFromArray:msgDict[@"rxg_id"]];
    //
    //        NSPredicate *cardPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ IN %@",IDS];
    //        [request setPredicate:cardPredicate];
    //
    //        //Sort Descriptor
    //        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc]
    //                                                                     initWithKey:@"id_" ascending:true],
    //                                    nil];
    //        [request setSortDescriptors:sortDescriptors];
    //
    //        // Fetch the card for private group
    //
    //        NSError *error;
    //        NSMutableArray *mutableFetchResults = [[[DatabaseHelper getManagedContext] executeFetchRequest:request error:&error] mutableCopy];
    //        if (!mutableFetchResults || ![mutableFetchResults count]) {
    //            // Handle the error.
    //            // This is a serious error and should advise the user to restart the application
    //           // NSLog(@"Error SAVING");
    //            // return NO;
    //        }
    //        else{
    //
    //            if([chatMessage.msgType isEqualToString:[Utility MessageTypeToString:mg_SEND_BROADCAST]])
    //                [chatMessage setPost_card_relationship:[NSSet setWithArray:mutableFetchResults]];
    //            else{
    //                chatMessage.rx_id = [msgDict[@"rx_id"] componentsJoinedByString:@","];
    //                chatMessage.rxg_id = [msgDict[@"rxg_id"] componentsJoinedByString:@","];
    //
    //            }
    //
    //        }
    //
    
    
}

+(instancetype)setMessageFromString:(NSString *)msgString{
    NSDictionary *msgDict = [self getJsonDictFromSocketString:msgString];
    return [self setMessageFromDict:msgDict];
    
}


-(BOOL)ifMessageReceived{
    
    if([Utility ObjectTypeFromString:self.objType] == oj_MESSAGE  && [Utility MessageTypeFromString:self.msgType] != mg_AUTH && [Utility MessageTypeFromString:self.msgType] != mg_ERROR && [Utility MessageTypeFromString:self.msgType] != NOMSG && [Utility AckTypeFromString:self.ackType] == NOACK){
        return true;
    }
    return false;
    
}
-(BOOL)ifMessageRequestReceived{
    
    if([Utility ObjectTypeFromString:self.objType] == oj_MSG_REQ){
        return true;
    }
    return false;
    
}

-(BOOL)ifMessageAcknowledgementReceived{
    
    if([Utility ObjectTypeFromString:self.objType] == oj_ACKN || [Utility AckTypeFromString:self.ackType] != NOACK){
        return true;
    }
    return false;
    
}
-(BOOL)ifMessageAcknowledgementOnlyReceived{
    
    if([Utility ObjectTypeFromString:self.objType] == oj_ACKN){
        return true;
    }
    return false;
    
}

-(BOOL)ifNotificationReceived{
    
    if([Utility ObjectTypeFromString:self.objType] == oj_NOTIFY && [Utility NotifyTypeFromString:self.notifyType] != NONOTIFY){
        return true;
    }
    return false;
    
}

-(BOOL)ifAuthMessageReceived{
    
    if([Utility ObjectTypeFromString:self.objType] == oj_MESSAGE && [Utility MessageTypeFromString:self.msgType] == mg_AUTH){
        return true;
    }
    return false;
    
}


-(NSString *)getDeliveredAcknowledgement{
    return[self getMessageStringFor:[self getJSONDictForAcknowledgement:ak_MSG_DELIVERED]];
}

-(NSString *)getReadAcknowledgement{
    
    return[self getMessageStringFor:[self getJSONDictForAcknowledgement:ak_MSG_READ]];
    
}

/*
 {
 "objType": "oj_ACKN",
 "ackType": "ak_MSG_DELIVERED",
 "org_id": "54f870fa818a79be39103bd2",
 "tx_id": "54f09289818a3efe88c2cb52"
 }
 Example 3.2: Full Acknowledgment (with rx_id)
 This is the same as above with the addition of the rx_id field:
 {
 "objType": "oj_ACKN",
 "ackType": "ak_MSG_DELIVERED",
 "org_id": "54f870fa818a79be39103bd2",
 "tx_id": "54f09289818a3efe88c2cb52",
 "rx_id": [
 "54bbf805a24d23aecccf6968"
 ]
 }
 */

-(NSString *)getSimpleAcknowledgement{
    
    return[self getMessageStringFor:[self getJSONDictForSimpleAcknowledgement]];
}

-(NSString *)getFullAcknowledgementOnAck:(NSString *)ackType{
    
    return[self getMessageStringFor:[self getJSONDictForFullAcknowledgementOnAck:ackType]];
}

+(NSString *)getNewGroupNotifString:(NSArray *)grpIDS{
    
    return [self getMessageStringFor:[self getNewGroupNotifDictFor:grpIDS]];
    
}

+(NSString *)getFriendAddedNotificationFor:(NSArray *)frndIds{
    
    return [self getMessageStringFor:[self getFriendsAddedDict:frndIds]];
    
}

+(NSString *)getUpdateNotifStringForGroup:(NSArray *)grpIds andReceiverID:(NSArray *)rxIDS withNotify:(eNotifyType)notif_type msgDetails:(NSString *)msgDetails_ msgText:(NSString *)msgText_ clientIdRequired:(BOOL)clientIdRequired_{
    
    return [self getMessageStringFor:[self getUpdateNotifDictForGroup:grpIds andReceiverID:rxIDS withNotify:notif_type msgDetails:msgDetails_ msgText:msgText_ clientIdRequired:clientIdRequired_]];
    
}

+(NSString *)getUpdateNotifStringForSelf:(NSString *)cardID withNotify:(eNotifyType)notif_type msgDetails:(NSString *)msgDetails_ msgText:(NSString *)msgText_ clientIdRequired:(BOOL)clientIdRequired_{
    
    return [self getMessageStringFor:[self getUpdateNotifDictForSelf:cardID withNotify:notif_type msgDetails:msgDetails_ msgText:msgText_ clientIdRequired:clientIdRequired_]];
    
}

+(NSString *)getUpdateNotifStringForStatus:(NSString *)msgDetails_ withNotify:(eNotifyType)notif_type{
    
    return [self getMessageStringFor:[self getUpdateNotifDictForStatus:msgDetails_ withNotify:notif_type]];
    
    
}
-(NSArray *)getReceiverGroupIDs{
    
    return [self.rxg_id componentsSeparatedByString:@","];
    //    if(self.card_relationship){
    //
    //        NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"cardType = %@",[Utility CardTypeToString:cd_PRIVATE_GROUP]];
    //        NSArray *rxg_id = [[[self.card_relationship filteredSetUsingPredicate:groupPredicate] allObjects] valueForKeyPath:@"id_"];
    //        return rxg_id;
    //    }
    //    else
    //        return nil;
    
}

-(NSArray *)getReceiverUserIDs{
    
    return [self.rx_id componentsSeparatedByString:@","];
    //    if(self.card_relationship){
    //
    //        NSPredicate *singlePredicate = [NSPredicate predicateWithFormat:@"cardType = %@",[Utility CardTypeToString:cd_USER]];
    //        NSArray *rx_id = [[[self.card_relationship filteredSetUsingPredicate:singlePredicate] allObjects] valueForKeyPath:@"id_"];
    //        return rx_id;
    //    }
    //    else
    //        return nil;
}

-(NSString *)getTransmitterIDs{
    
    return self.tx_id;
}

-(NSString *)getLastMessageString{
    
    if(self.media_relationship)
        return [self cellDescription:self.media_relationship.mediaType];
    else if([self.msgType isEqualToString:[Utility MessageTypeToString:mg_SHARE_EMOJI_STICKER]])
        return NSLocalizedString(@"Emoji/Stickers Shared", nil);
    else if([self.msgDetails isEqualToString:EmojiMessageIdentifier])
        return NSLocalizedString(@"Emoji Message", nil);
    else if([self.msgDetails isEqualToString:StickerMessageIdentifier])
        return NSLocalizedString(@"Sticker Message", nil);
    else if(self.msgText)
        return self.msgText;
    else
        return nil;
    
}

-(NSString *)cellDescription:(NSString *)desc{
    if([desc isEqualToString:@"ma_IMAGE"])
        return NSLocalizedString(@"Image", nil);
    else if([desc isEqualToString:@"ma_VIDEO"])
        return NSLocalizedString(@"Video", nil);
    else if([desc isEqualToString:@"ma_AUDIO"])
        return NSLocalizedString(@"Audio", nil);
    else
        return desc;
}
@end
