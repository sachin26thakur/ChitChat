//
//  SocketStream.m
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "SocketStream.h"
#import "JFRWebSocket.h"
#import "DatabaseHelper.h"
#import "Utility.h"
#import "Constants.h"
#import "FGTranslator.h"
#import "ChitchatUserDefault.h"



#import <CoreLocation/CoreLocation.h>

@interface SocketStream ()<JFRWebSocketDelegate,CLLocationManagerDelegate>

@property (strong,nonatomic) JFRWebSocket *socket;
@property (nonatomic) BOOL isAuthenticated;

@property (strong,nonatomic) NSString *userID;
@property (strong,nonatomic) NSString *avatarID;

@property (strong,nonatomic) NSString *deviceToken;

@property (strong, nonatomic) VcardObject *userData;
@property (strong, nonatomic) VcardObject *avatarData;
@property (strong, atomic) ALAssetsLibrary* library;

@property (strong,nonatomic) NSDateFormatter *dateFormatter;
@property (strong,nonatomic) NSTimer *peakTimer;
@property (strong,nonatomic) NSMutableArray *peakTimeArray;

@property (strong,nonatomic) NSMutableArray *chatMessagesData; // All the vcard objects with their chats

@property (strong, nonatomic) NSMutableArray *stringsToBeSent; // All the vcard objects having chats and in private chat

@property (strong, nonatomic) NSArray *historyChatData; // All the vcard objects having chats and in private chat
@property (strong, nonatomic) NSArray *radarChatData; // All the vcard objects having chats in public avatar chat


@property (strong, nonatomic) GeoLocationObject *currentLocation; // All the vcard objects having chats in public avatar chat

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSArray *notificationsArray;
@property (strong,nonatomic) NSNumber *activeNotificationNumber;




@end


@implementation SocketStream

static SocketStream *socketStream;
@synthesize avatarID = _avatarID;
@synthesize avatarData = _avatarData;
@synthesize activeMode =_activeMode;

+ (instancetype)sharedSocketObject{
    
    static dispatch_once_t dispathOnce;
    dispatch_once(&dispathOnce, ^{
        
        socketStream = [[self alloc] init];
        socketStream.socket = [[JFRWebSocket alloc] initWithURL:[NSURL URLWithString:URL_SOCKET] protocols:@[]];
        socketStream.socket.delegate = socketStream;
        socketStream.deviceToken = appDelegate.latestDeviceToken;
        
        [socketStream.socket connect];
        socketStream.chatMessagesData = [DatabaseHelper initializedChatData];
        [socketStream translateText:socketStream.chatMessagesData atIndex:0];
        
        socketStream.userData = [socketStream getUserData];
        
        socketStream.activeMode = @1;
        
        socketStream.historyChatData = [socketStream getHistoryChatData];
        socketStream.radarChatData = [socketStream getRadarChatData];
        
        
        socketStream.peakTimeArray = [NSMutableArray array];
        socketStream.dateFormatter = [[NSDateFormatter alloc] init];
        [socketStream.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        socketStream.stringsToBeSent = [NSMutableArray array];
        socketStream.library = [[ALAssetsLibrary alloc] init];

        
        [[NSNotificationCenter defaultCenter] addObserver:socketStream
                                                 selector:@selector(networkChanged:)
                                                     name:@"NetworkChanged"
                                                   object:nil];
        
    });
    return socketStream;
    
}

-(void)restartSocket{
    if(![socketStream.socket isConnected])
        [socketStream.socket connect];
    
}

-(void)disconnectSocket{
    if([socketStream.socket isConnected])
        [socketStream.socket disconnect];
    
}


-(void)networkChanged:(NSNotification *)aNotification{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    if (appDelegate.networkStatus && [userdefaults boolForKey:@"userLoggedIn"] && !self.socket.isConnected) {
        [self.socket connect];
    }
}



- (FGTranslator *)translator {
    /*
     * using Bing Translate
     *
     * Note: The client id and secret here is very limited and is included for demo purposes only.
     * You must use your own credentials for production apps.
     */
    FGTranslator *translator = [[FGTranslator alloc] initWithBingAzureClientId:@"fgtranslator-demo" secret:@"GrsgBiUCKACMB+j2TVOJtRboyRT8Q9WQHBKJuMKIxsU="];
    
    // or use Google Translate
    
    // using Google Translate
    // translator = [[FGTranslator alloc] initWithGoogleAPIKey:@"your_google_key"];
    
    return translator;
}


+ (NSString*)lanuageCodeForSelectedLanaguge1{
    
    
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
    
    NSString *selectedLanguge = [ChitchatUserDefault selectedUserLanguage];
    
    return [languageDictionary objectForKey:selectedLanguge];
}



- (void)translateText:(NSArray*)array atIndex:(NSUInteger)index{
    
    
    if (index >= [array count]) {
        return;
    }
    
    
    NSString *selectedLanguage =   [[self class] lanuageCodeForSelectedLanaguge1];
    if (!selectedLanguage) {
        selectedLanguage = @"en";
    }
    
    __block NSUInteger indexi = index;
    
    
    VcardObject *obj = [array objectAtIndex:indexi];
    
    NSString *translateText = obj.lastMessage;
    
    
    if (translateText == nil || translateText.length == 0) {
        indexi = indexi + 1;
        [self translateText:array atIndex:indexi];
    }
    
    
    
    
    [self.translator translateText:translateText withSource:nil target:selectedLanguage
                        completion:^(NSError *error, NSString *translated, NSString *sourceLanguage)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             
             VcardObject *obj = [array objectAtIndex:indexi];
             obj.lastMessage = translated;
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadList" object:nil];
             indexi = indexi +1;

             if ([array count] == indexi) {
                 return ;
             }
             

             
             
             [self translateText:array atIndex:indexi];
         });
         
         
     }];
    
}




-(void)refreshCardsData{
    
    self.chatMessagesData = [DatabaseHelper initializedChatData];
    self.userData = [socketStream getUserData];
    self.historyChatData = [socketStream getHistoryChatData];
    self.radarChatData = [socketStream getRadarChatData];
    
    
    [self translateText:self.chatMessagesData atIndex:0];
    
    
    
}


-(NSArray *)getVCardsToAdd:(BOOL)forGroups withGroupID:(NSArray *)grpIDs{
    
    NSPredicate *predicate;
    if(forGroups && grpIDs && [grpIDs count])
        predicate = [NSPredicate predicateWithFormat:@"SELF.id_ != %@ AND SELF.id_ != %@ AND SELF.isFriend = %@ AND SELF.cardType != %@ AND NOT (SELF.id_ IN %@)",self.userID, self.avatarID, @true , @"cd_PRIVATE_GROUP",grpIDs];
    else if(forGroups)
        predicate = [NSPredicate predicateWithFormat:@"SELF.id_ != %@ AND SELF.id_ != %@ AND SELF.isFriend = %@ AND SELF.cardType != %@",self.userID, self.avatarID, @true , @"cd_PRIVATE_GROUP"];
    else
        predicate = [NSPredicate predicateWithFormat:@"SELF.id_ != %@ AND SELF.id_ != %@ AND SELF.isFriend = %@",self.userID, self.avatarID, @true];
    
    NSMutableArray *chatData = [[self.chatMessagesData filteredArrayUsingPredicate:predicate] mutableCopy];
    return chatData;
    
}


-(NSArray *)getHistoryChatData{
    
    NSPredicate *historyPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ != %@ AND SELF.isFriend = %@",self.userID,@true];
    
    NSArray *historyPeopleData = [self.chatMessagesData filteredArrayUsingPredicate:historyPredicate];
    
    NSMutableArray *historyChatData = [NSMutableArray new];
    for (VcardObject *card in historyPeopleData) {
        NSArray *chatMessages = [DatabaseHelper getChatMessagesForCard:card.id_ fromTimeStamp:nil withLimit:1];
        
        
        NSArray *chatForUnreadMessages = [DatabaseHelper getChatMessagesForCard:card.id_ fromTimeStamp:nil withLimit:0];
        NSInteger countUnRead = 0;
        for (ChatMessageObject *message in chatForUnreadMessages) {
            if ([message.ackType isEqualToString:@"ak_MSG_DELIVERED"] ) {
                countUnRead ++;
            }
        }
        
        if([chatMessages count]){
            card.lastMessage = [(ChatMessageObject *)chatMessages[0] getLastMessageString];
            card.lastMessageTimeStamp = [(ChatMessageObject *)chatMessages[0] timeFirstSent];
            card.unReadMessageCount = [NSString stringWithFormat:@"%ld",(long)countUnRead];
            [historyChatData addObject:card];
        }
        else{
            card.lastMessage = nil;
        }
    }
    return [historyChatData sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastMessageTimeStamp" ascending:false]]];
}

- (NSInteger) getUnreadMessageCount {
    
    NSPredicate *historyPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ != %@ AND SELF.isFriend = %@",self.userID,@true];
    
    NSArray *historyPeopleData = [self.chatMessagesData filteredArrayUsingPredicate:historyPredicate];
    
    NSMutableArray *historyChatData = [NSMutableArray new];
    for (VcardObject *card in historyPeopleData) {
        NSArray *chatMessages = [DatabaseHelper getChatMessagesForCard:card.id_ fromTimeStamp:nil withLimit:1];
        NSInteger count = 0;
        for (ChatMessageObject *message in chatMessages) {
            
            if ([message.ackType isEqualToString:@"ak_MSG_RECEIVED"] || [message.ackType isEqualToString:@"ak_MSG_DELIVERED"] ) {
                count ++;
            }
        }
        
        
        
        //        if([chatMessages count]){
        //            card.lastMessage = [(ChatMessageObject *)chatMessages[0] getLastMessageString];
        //            card.lastMessageTimeStamp = [(ChatMessageObject *)chatMessages[0] timeFirstSent];
        //            [historyChatData addObject:card];
        //        }
        //        else{
        //            card.lastMessage = nil;
        //        }
    }
    
    
    //    NSPredicate *historyPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ != %@ AND SELF.isFriend = %@",self.userID,@true];
    //
    //    NSArray *historyPeopleData = [self.chatMessagesData filteredArrayUsingPredicate:historyPredicate];
    //
    //    NSMutableArray *historyChatData = [NSMutableArray new];
    //
    //    for (VcardObject *card in historyPeopleData) {
    //        NSArray *chatMessages = [DatabaseHelper getChatMessagesForCard:card.id_ fromTimeStamp:nil withLimit:0];
    //
    //
    //        for (ChatMessageObject *chatMessage in chatMessages) {
    //            if ([chatMessage.ackType isEqualToString:@"ak_MSG_READ"]) {
    //                 [historyChatData addObject:chatMessage];
    //            }
    //        }
    //    }
    
    return 0;
}


-(NSArray *)getRadarChatData{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id_ != %@ AND SELF.isRadarFriend = %@",self.userID,@true];
    NSMutableArray *chatData = [[self.chatMessagesData filteredArrayUsingPredicate:predicate] mutableCopy];
    return chatData;
    
}


-(NSMutableArray *)getPostsDataForUser:(NSString *)userID{
    
    NSPredicate *postPredicate = [NSPredicate predicateWithFormat:@"id_ = %@",userID];
    NSArray *tmp = [self.chatMessagesData filteredArrayUsingPredicate:postPredicate];
    if (tmp.count !=0) {
        NSArray *postDataArray = [[[(tmp[0]) valueForKeyPath:@"post_relationship"] allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timeFirstSent" ascending:true]]];
        
        return (postDataArray && [postDataArray count]) ? [postDataArray mutableCopy] : nil;
    } else
        return nil;
    
    
}


-(void)deletePostsDataForUser:(NSString *)userID{
    
    NSPredicate *postPredicate = [NSPredicate predicateWithFormat:@"id_ = %@",userID];
    ((VcardObject *)([self.chatMessagesData filteredArrayUsingPredicate:postPredicate][0])).post_relationship = nil;
    [DatabaseHelper saveDBManagedContext];
    
}


-(VcardObject *)getUserData{
    
    if(!self.userID){
        NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
        self.userID = [userdefaults objectForKey:UserID];
    }
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"id_ = %@", self.userID];
    NSArray *userArray = [self.chatMessagesData filteredArrayUsingPredicate:userPredicate];
    if(userArray && [userArray count])
    {VcardObject *userData = userArray[0];
        return userData;
    }
    else
        return nil;
}




-(NSArray *)getIndividualMembersData{
    
    NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"SELF.cardType = %@",@"cd_PRIVATE_GROUP"];
    
    return [self.chatMessagesData filteredArrayUsingPredicate:groupPredicate];
}

- (void) refreshCardUnreadCount {
    self.unreadMessageCount = [self getUnreadMessageCount];
}


-(void)refreshHistoryChatData{
    self.historyChatData = [self getHistoryChatData];
    
}

-(void)refreshRadarChatData{
    self.radarChatData = [self getRadarChatData];
    
}

-(void)websocketDidConnect:(JFRWebSocket*)socket
{
    NSLog(@"websocket is connected");
    self.isAuthenticated = false;
    [self authenticateConnection];
}


-(void)websocketDidDisconnect:(JFRWebSocket*)socket error:(NSError*)error
{
    NSLog(@"websocket is disconnected: %@",error);
    self.isAuthenticated = false;
    
    if(((!error && appDelegate.networkStatus) || ((error.code == 54 || error.code == 32) && appDelegate.networkStatus)) &&  ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive
                                                                                                                             ))
        [self.socket connect];
    else{
    }
}


-(void)websocket:(JFRWebSocket*)socket didReceiveMessage:(NSString*)string
{
    if(string) {
        dispatch_async(dispatch_get_main_queue(),^{
            //do some UI work
            NSLog(@"Socket Response %@",string);
            // [LogUtil writeStringToFile:string];
            ChatMessageObject *recievedMessage = [ChatMessageObject setMessageFromString:string];
            //    NSLog(@"SOCKET RESPONSE: %@",string);
            if ([string containsString:@"ny_PRIVATE_FRIEND_ADDED"]) {
                NSLog(@"");
            }
            
            if (!recievedMessage && ![string containsString:@"ackType"] && [string containsString:@"mg_AUTH"]) {
                if(!self.userID){
                    self.userID = [ChatMessageObject getAuthIDFromString:string];
                }
                if(self.userID){
                    if(![string containsString:@"\"_id\":null"]){
                        NSLog(@"websocket is authenticated");
                        self.isAuthenticated = true;
                        NSArray *messages = [DatabaseHelper getDBObjectsForModel:ChatMessage_OBJ filterbyPredicate:[NSPredicate predicateWithFormat:@"SELF.ackType = %@ AND SELF.tx_id = %@",nil,[SocketStream sharedSocketObject].userID] withSortDescriptors:nil];
                        for (ChatMessageObject *chatMessage in messages) {
                            NSString *jsonString = [chatMessage getMessageStringFor:nil];
                            [self writeString:jsonString];
                        }
                        
                        [self requestForOfflineMessages];
                    }
                    else
                    {
                        [self.socket connect];
                    }
                    
                }
                
            }
            else if (recievedMessage && [recievedMessage ifMessageAcknowledgementOnlyReceived]) {
                //send simple acknowledgement
                [self processMessageAckKnowledgementOnly:recievedMessage];
                
            }
            else if(recievedMessage){
                
                if ([recievedMessage ifMessageReceived]) {
                    
                    if([recievedMessage getReceiverUserIDs] || [recievedMessage getReceiverGroupIDs])
                        [self processRecievedMessage:recievedMessage];
                    else
                        [DatabaseHelper deleteModelObject:recievedMessage];
                    
                    
                }
                
                else if ([recievedMessage ifMessageRequestReceived]  && [[recievedMessage getReceiverUserIDs] count]>0) {
                    [self processMessageRequest:recievedMessage];
                }
                
                
                else if ([recievedMessage ifMessageAcknowledgementReceived]) {
                    
                    [self processMessageAckKnowledgement:recievedMessage];
                    
                }
                
                else if ([recievedMessage ifNotificationReceived]) {
                    [self processNotification:recievedMessage];
                    
                }
                else{
                    [DatabaseHelper deleteModelObject:recievedMessage];
                    
                }
            }
            
        });
    }
}


-(void)websocket:(JFRWebSocket*)socket didReceiveData:(NSData*)data
{
    NSLog(@"got some binary data: %lu",(unsigned long)data.length);
}


-(void) authenticateConnection{
    
    if([self.socket isConnected]){
        if(![appDelegate.latestDeviceToken isEqualToString:self.deviceToken] && appDelegate.latestDeviceToken)
            [self.socket writeString:[ChatMessageObject getAuthMessageWithParameters:true]];
        else{
            [self.socket writeString:[ChatMessageObject getAuthMessageWithParameters:true]];
        }
        
        //    NSLog(@"%@",[ChatMessageObject getAuthMessage]);
        //     [self writeString:[ChatMessageObject getAuthMessage]];
        
    }
}

-(void) requestForOfflineMessages{
    
    if([self.socket isConnected]){
        NSLog(@"Offline Messages%@",[ChatMessageObject getLogMessageString]);
        [self writeString:[ChatMessageObject getLogMessageString]];
        
    }
    else
        [self.socket connect];
}

-(void)sendMessage:(ChatMessageObject *)chatMessage{
    
    if([self.socket isConnected]){
        
        // if([Utility ObjectTypeFromString:chatMessage.objType] != oj_NOTIFY)
        [chatMessage saveModelObjectTODB];
        NSString *jsonString = [chatMessage getMessageStringFor:nil];
        // [LogUtil writeStringToFile:jsonString];
        [self writeString:jsonString];
    }
    else
        [self.socket connect];
    
}


-(void)addPrivateGroup:(PrivateGroupObject *)group{
    
    NSMutableDictionary *grpChatDictionary = [[group getPrivateGroupObjectDict] mutableCopy];
    [grpChatDictionary setValue:[@[@{@"message":@"Hi all, I just added you to this group.",@"time":[self.dateFormatter stringFromDate:[NSDate date]],@"party":@(0)}] mutableCopy] forKey:@"chat"];
    
    [self.chatMessagesData addObject:grpChatDictionary];
    
    
}

-(void)sendFriendAddedNotification:(NSArray *)cardIDs{
    
    NSString *jsonString = [ChatMessageObject getFriendAddedNotificationFor:cardIDs];
    [self sendNotification:jsonString];
    
}

-(void)sendGroupNotification:(NSArray *)groupID{
    
    NSString *jsonString = [ChatMessageObject getNewGroupNotifString:groupID];
    [self sendNotification:jsonString];
}

-(void)sendUpdateNotificationForGroup:(NSArray *)grpIds andReceiverID:(NSArray *)rxIDS withNotify:(eNotifyType)notif_type msgDetails:(NSString *)msgDetails_ msgText:(NSString *)msgText_ clientIdRequired:(BOOL)clientIdRequired_{
    
    NSString *jsonString = [ChatMessageObject getUpdateNotifStringForGroup:grpIds andReceiverID:rxIDS withNotify:notif_type msgDetails:msgDetails_ msgText:msgText_ clientIdRequired:clientIdRequired_];
    [self sendNotification:jsonString];
}

-(void)sendUpdateNotificationForSelfCard:(id)cardID withNotify:(eNotifyType)notif_type msgDetails:(NSString *)msgDetails_ msgText:(NSString *)msgText_ clientIdRequired:(BOOL)clientIdRequired_{
    
    NSString *jsonString = [ChatMessageObject getUpdateNotifStringForSelf:cardID withNotify:notif_type msgDetails:msgDetails_ msgText:msgText_ clientIdRequired:clientIdRequired_];
    [self sendNotification:jsonString];
}

-(void)sendUpdateNotificationForStatus:(NSString*)msgDetails_ withNotify:(eNotifyType)notif_type {
    
    NSString *jsonString = [ChatMessageObject getUpdateNotifStringForStatus:msgDetails_ withNotify:notif_type];
    [self sendNotification:jsonString];
    
}
-(void)sendNotification:(NSString *)jsonNotifString{
    
    [self writeString:jsonNotifString];
    
}


-(void)sendAcknowledgement:(NSString *)jsonAckString{
    
    [self writeString:jsonAckString];
    
}
-(void)writeString:(NSString *)msgString{
    NSLog(@"SOCKET Request %@",msgString);
    
    if(self.isAuthenticated)
        [self.socket writeString:msgString];
    //else
    //  [self.stringsToBeSent addObject:msgString];
    
}


-(NSArray *)getMyGroupIDs{
    
    NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"cardType = %@",@"cd_PRIVATE_GROUP"];
    NSArray *filteredArray = [self.chatMessagesData filteredArrayUsingPredicate:groupPredicate];
    
    return [filteredArray valueForKeyPath:@"id_"];
}



-(void)processRecievedMessage:(ChatMessageObject *)recievedMessage{
    
    if(!recievedMessage.msgText && !recievedMessage.media_relationship && ![recievedMessage.msgType isEqualToString:@"mg_SHARE_EMOJI_STICKER"])
        [DatabaseHelper deleteModelObject:recievedMessage];
    
    if([recievedMessage.msgType isEqualToString:@"mg_SEND_PRIVATE_SINGLE"] || [recievedMessage.msgType isEqualToString:@"mg_SEND_PRIVATE_MANY"]){
        
        if(([recievedMessage.msgType isEqualToString:@"mg_SEND_PRIVATE_MANY"] && [[recievedMessage getReceiverUserIDs] containsObject:[SocketStream sharedSocketObject].userID]) || [recievedMessage.msgType isEqualToString:@"mg_SEND_PRIVATE_SINGLE"])
        {
            [self writeString:[recievedMessage getDeliveredAcknowledgement]];
        }
        else{
            [self writeString:[recievedMessage getSimpleAcknowledgement]];
        }
        recievedMessage.ackType = [Utility AckTypeToString:ak_MSG_DELIVERED];
        [DatabaseHelper saveManagedContext];
        [self refreshHistoryChatData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageReceived" object:recievedMessage];
        
        // Get vcard of this friend with transmitter id
        // save it
        // ready for display on chat window
        
    }
    if([recievedMessage.msgType isEqualToString:@"mg_SHARE_EMOJI_STICKER"]){
        [self writeString:[recievedMessage getDeliveredAcknowledgement]];
        recievedMessage.ackType = [Utility AckTypeToString:ak_MSG_DELIVERED];
        [DatabaseHelper saveManagedContext];
        [self refreshHistoryChatData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageReceived" object:recievedMessage];
        
    }
    
    if([recievedMessage.msgType isEqualToString:@"mg_SEND_HANGOUT_SINGLE"]){
        
    }
    if([recievedMessage.msgType isEqualToString:@"mg_SEND_HANGOUT_MANY"]){
        
    }
    if([recievedMessage.msgType isEqualToString:@"mg_SEND_BROADCAST"]){
        
    }
    
}

-(void)processMessageRequest:(ChatMessageObject *)recievedMessage{
    
}

-(void)processMessageAckKnowledgement:(ChatMessageObject *)recievedMessage{
    if(self.peakTimeArray && [self.peakTimeArray count]){
        NSPredicate *chatPeakPredicate = [NSPredicate predicateWithFormat:@"SELF.msgID = %@",recievedMessage.clientMsgID];
        NSArray *chatPeakArray = [self.peakTimeArray filteredArrayUsingPredicate:chatPeakPredicate];
        
        [chatPeakArray enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL *stop) {
            obj[@"msgID"] = recievedMessage.org_id;
        }];
    }
    [self refreshHistoryChatData];
    [self writeString:[recievedMessage getSimpleAcknowledgement]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AcknowledgementReceived" object:recievedMessage];
    
}

-(void)processMessageAckKnowledgementOnly:(ChatMessageObject *)recievedMessage{
    [self writeString:[recievedMessage getSimpleAcknowledgement]];
    [[DatabaseHelper getManagedContext] deleteObject:recievedMessage];
    
}


-(void)processNotification:(ChatMessageObject *)recievedMessage{
    
    if([Utility NotifyTypeFromString:recievedMessage.notifyType] == ny_ADDED_TO_PRIVATE_GROUP || [Utility NotifyTypeFromString:recievedMessage.notifyType] == ny_VCARD_UPDATE || [Utility NotifyTypeFromString:recievedMessage.notifyType] == ny_PRIVATE_GROUP_UPDATE || [Utility NotifyTypeFromString:recievedMessage.notifyType] ==ny_STATUS_UPDATE){
        
        //Check if this group alerady exists
        if([Utility NotifyTypeFromString:recievedMessage.notifyType] == ny_STATUS_UPDATE && [recievedMessage getTransmitterIDs] && [[self.chatMessagesData valueForKeyPath:@"id_"] containsObject:[recievedMessage getTransmitterIDs]]){
            //Update vcard
            
        }
        else if (([recievedMessage getReceiverGroupIDs] && [[recievedMessage getReceiverGroupIDs] count] && [[self.chatMessagesData valueForKeyPath:@"id_"] containsObject:[recievedMessage getReceiverGroupIDs][0]])){
            
            
        }
        else{
            //get Vcard and get PG
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GroupCreated" object:@[recievedMessage.msgDetails] userInfo:nil];
        }
        [self writeString:[recievedMessage getSimpleAcknowledgement]];
        
    }
    
    else if([Utility NotifyTypeFromString:recievedMessage.notifyType] == ny_GROUP_MEMBERS_ADDED){
        
        NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"SELF._id = %@",[recievedMessage getReceiverGroupIDs][0]];
        NSArray *filteredArray = [self.chatMessagesData filteredArrayUsingPredicate:groupPredicate];
        
        if(filteredArray && [filteredArray count]){
            
            NSDictionary *dict = filteredArray[0];
            NSInteger chatIndex = [self.chatMessagesData indexOfObjectIdenticalTo:dict];
            
            self.chatMessagesData[chatIndex][@"members"] = recievedMessage.getReceiverGroupIDs;
            [self refreshHistoryChatData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageReceived" object:recievedMessage];
            
        }
        [self writeString:[recievedMessage getSimpleAcknowledgement]];
        
    }
    
    else if([Utility NotifyTypeFromString:recievedMessage.notifyType] == ny_PRIVATE_FRIEND_REQUEST || [Utility NotifyTypeFromString:recievedMessage.notifyType] == ny_PRIVATE_FRIEND_ACCEPT || [Utility NotifyTypeFromString:recievedMessage.notifyType] == ny_PRIVATE_FRIEND_ADDED){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationReceived" object:[recievedMessage getTransmitterIDs] userInfo:@{@"type":recievedMessage.notifyType}];
        [self writeString:[recievedMessage getFullAcknowledgementOnAck:recievedMessage.notifyType]];
        
    }
    [DatabaseHelper deleteModelObject:recievedMessage];
    
}

- (void)peakBuzzed:(NSDictionary *)timerDct {
    
    NSPredicate *peakPredicate = [NSPredicate predicateWithFormat:@"SELF.clientMsgID IN %@ OR SELF.org_id IN %@", timerDct[@"msgID"],timerDct[@"msgID"]];
    NSArray *filteredPeakArray = [DatabaseHelper getDBObjectsForModel:ChatMessage_OBJ filterbyPredicate:peakPredicate withSortDescriptors:nil];
    if(filteredPeakArray && [filteredPeakArray count])
        [DatabaseHelper deleteModelObjects:filteredPeakArray];
    [self refreshHistoryChatData];
}


- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if ([CLLocationManager locationServicesEnabled] == NO) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }
    
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 0; // meters
    
    [self startUpdatingLocation];
}

- (void)startUpdatingLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied)
    {
        NSLog(@"Location services are disabled in settings.");
    }
    else
    {
        // for iOS 8
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    }
}

- (void)stopStandardUpdates{
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    self.currentLocation = nil;
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = -[eventDate timeIntervalSinceNow];
    BOOL notificationToBeSent = NO;
    
    if (howRecent > 5.0) return;
    
    if (location.horizontalAccuracy < 0) return;
    if(!self.currentLocation)
        notificationToBeSent = YES;
    
    float lat = location.coordinate.latitude;
    float lan = location.coordinate.longitude;
    
    //self.currentLocation = [GeoLocationObject getEntityFor:lan latitude:lat];
    //  self.currentLocation = [GeoLocationObject getEntityFor:79.0838547 latitude:21.0876274];
    
    if(notificationToBeSent)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartRadar" object:nil];
    
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied) {
        //you had denied
    }
    
    if(!self.currentLocation)
    {
        //self.currentLocation = [GeoLocationObject getEntityFor:10 latitude:10];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartRadar" object:nil];
    }
    [self.locationManager stopUpdatingLocation];
}


-(void)refreshNotifications{
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF.id_ != %@ AND SELF.friendRequestPending = %@",self.userID,@true];
    NSMutableArray *chatData1 = [[self.chatMessagesData filteredArrayUsingPredicate:predicate1] mutableCopy];
    self.notificationsArray = chatData1;
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.id_ != %@ AND SELF.friendRequestPending = %@ AND SELF.friendRequestSeen = %@",self.userID,@true,@false];
    NSMutableArray *chatData2 = [[self.chatMessagesData filteredArrayUsingPredicate:predicate2] mutableCopy];
    self.activeNotificationNumber = @([chatData2 count]);
    
    
    
}

-(NSArray *)notificationsArray {
    
    if(!_notificationsArray)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id_ != %@ AND SELF.friendRequestPending = %@",self.userID,@true];
        NSMutableArray *chatData = [[self.chatMessagesData filteredArrayUsingPredicate:predicate] mutableCopy];
        _notificationsArray = chatData;
    }
    return _notificationsArray;
}

-(NSNumber *)activeNotificationNumber{
    
    if(!_activeNotificationNumber)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id_ != %@ AND SELF.friendRequestPending = %@ AND SELF.friendRequestSeen = %@",self.userID,@true,@false];
        NSMutableArray *chatData = [[self.chatMessagesData filteredArrayUsingPredicate:predicate] mutableCopy];
        _activeNotificationNumber = @([chatData count]);
    }
    return _activeNotificationNumber;
    
}
-(void)setUserID:(NSString *)id_{
    _userID = id_;
}

-(id)getCardByID:(NSString *)id_{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ = %@", id_];
    NSArray *cardArr = [self.chatMessagesData filteredArrayUsingPredicate:predicate];
    if(cardArr && [cardArr count])
        return cardArr[0];
    else
        return nil;
    
}



-(void)deleteMessages:(NSArray *)messageArray{
    
    
    for (ChatMessageObject *msg in messageArray) {
        // [obj removeChat_relationshipObject:mesObj];
        [DatabaseHelper deleteModelObject:msg];
        
    }
    [self refreshHistoryChatData];
}

@end

