//
//  SyncUser.m
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "SyncUser.h"
#import <AddressBook/AddressBook.h>
#import "WebserviceHandler.h"
//#import "ChatMessage.h"
#import "SocketStream.h"
#import "RequestHelper.h"
#import "VCard.h"
#import "VcardObject.h"
#import "DatabaseHelper.h"
#import "Utility.h"
#import "Constants.h"

#define CONTACT_SYNCH @"contactSync"
#define GET_GROUP_IDS @"getGroups"
#define GET_FRIEND_IDS @"getFriends"
#define GET_MUTE_LIST @"getMuteList"
#define GET_CARDS @"getCards"
#define PAGINATION_COUNT 20


@interface SyncUser ()<WebServiceHandlerDelegate>{
    
    int cardsToBeFetched;
    int groupsCardsToBeFetched;
    BOOL friendsRetrived;
    int requestNumber; // 1 for Sync Adrees Book, 2 for get friends, 3 for get groups, 4 for get frnd's or group cards, 5 for geting Private group
    
    NSMutableSet *cardsIDs;
    NSMutableArray *cardsIDsToBeFetched;
    NSMutableArray *newFriendsAdded;
    
    NSArray *groupIDsToBeFetched;
    
    NSMutableOrderedSet *grpMemberCardIDS;
    
    NSArray *objectIDs;
    NSMutableSet *groupIDs;
    NSDateFormatter *dateFormatter;
    int fetchedIndex;
    int lastFetchedIndex;
    int lastCardIndex;
    
    
    NSArray *phoneNumbersRetrived;
    
}
@end

@implementation SyncUser

-(SyncUser *)init {
    // Construct this object:
    
    self = [super init];
    if(self)
    {
        cardsIDs = [NSMutableSet set];
        cardsIDsToBeFetched = [NSMutableArray new];
        groupIDsToBeFetched = [NSMutableArray new];
        newFriendsAdded = [NSMutableArray new];
        grpMemberCardIDS = [NSMutableOrderedSet orderedSet];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        groupIDs = [NSMutableSet set];
        
    }
    return self;
}


-(void)startUserSyncing:(BOOL)ifNewUser{
    
    (ifNewUser) ?  [self callServiceForSyncFriendsList] : [self checkForNewFriends];
    
}

-(void)checkForNewFriends{
    [self checkOfflineMessages];
}

-(void)syncUserWithoutContactSync{
    [self callServiceForPrivateRelations:NO];
}

-(void)checkOfflineMessages{
    
    [SocketStream sharedSocketObject];
    [[SocketStream sharedSocketObject] refreshHistoryChatData];
    [[SocketStream sharedSocketObject] refreshRadarChatData];
    if(newFriendsAdded && [newFriendsAdded count])
        [[SocketStream sharedSocketObject] sendFriendAddedNotification:newFriendsAdded];
    
    [self.delegate userSyncFinished:YES];
    
}

-(void)callServiceForSyncFriendsList
{
    
    phoneNumbersRetrived = [self getAllContacts];
    if(phoneNumbersRetrived && [phoneNumbersRetrived count]){
        
        WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
        objWebServiceHandler.delegate = self;
        objWebServiceHandler.str = CONTACT_SYNCH;
        requestNumber = 1;
        //for AFNetworking request
        [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper syncAddressBookRequest:phoneNumbersRetrived] withMethod:@"" withUrl:@"" forKey:@""];
        
    }
    else{
        //        NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
        //        [userdefaults setBool:true forKey:@"contactSynced"];
        //        [userdefaults synchronize];
        //        [self checkOfflineMessages];
        //
        [self callServiceForPrivateRelations:NO];
        
    }
}


-(void)callServiceForCards
{
    WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
    objWebServiceHandler.delegate = self;
    objWebServiceHandler.str = GET_CARDS;
    
    [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getVcards:[cardsIDsToBeFetched objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, ([cardsIDsToBeFetched count] > PAGINATION_COUNT) ? PAGINATION_COUNT:[cardsIDsToBeFetched count])]] withResolution:Card_Text_Resolution] withMethod:@"" withUrl:@"" forKey:@""];
}


-(void)callServiceForPrivateRelations:(BOOL)ifGroups
{
    
    WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
    objWebServiceHandler.delegate = self;
    
    // User Friends ID's
    // User Groups ID's
    if(ifGroups){
        //Call LoggedIn User Group
        requestNumber =3;
        objWebServiceHandler.str = GET_GROUP_IDS;
        
        [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getPrivateGroupsRequest] withMethod:@"" withUrl:@"" forKey:@""];
    }
    
    else{
        //Call LoggedIn User Friends
        requestNumber =2;
        objWebServiceHandler.str = GET_FRIEND_IDS;
        
        [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getPrivateFriendsRequest] withMethod:@"" withUrl:@"" forKey:@""];
    }
    
}




-(void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponse
{
    //NSLog(@"dicResponce:-%@",dicResponse);
    // Check resvice responce
    
    if([dicResponse[@"oprSuccess"] integerValue]){
        
        if([webHandler.str isEqualToString:CONTACT_SYNCH]){
            //Sync Contact List Response
            for(NSDictionary *vCard in dicResponse[@"respDetails"]){
                NSMutableDictionary *vCardDict = [vCard[@"vcard"] mutableCopy];
                vCardDict[@"isFriend"] = @true;
                vCardDict[@"cardType"] = [Utility CardTypeToString:cd_USER];
                [newFriendsAdded addObject:vCardDict[@"_id"]];
                [DatabaseHelper saveModel:@"VcardObject" FromResponseDict:vCardDict];
            }
            [self callServiceForPrivateRelations:NO];
            
        }
        else if([webHandler.str isEqualToString:GET_FRIEND_IDS]){
            [cardsIDsToBeFetched addObjectsFromArray:dicResponse[@"respDetails"]];
            NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
            [cardsIDsToBeFetched addObject:[userdefaults objectForKey:UserID]];
            [self callServiceForPrivateRelations:YES];
            
        }
        else if([webHandler.str isEqualToString:GET_GROUP_IDS]){
            [cardsIDsToBeFetched addObjectsFromArray:dicResponse[@"respDetails"]];
            groupIDsToBeFetched = dicResponse[@"respDetails"];
            
            if(cardsIDsToBeFetched && [cardsIDsToBeFetched count])
                [self callServiceToGetMuteList];
            else{
                NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
                [userdefaults setBool:true forKey:@"contactSynced"];
                [userdefaults synchronize];
                [self checkOfflineMessages];
            }
            
        }
        else if([webHandler.str isEqualToString:GET_MUTE_LIST]){
            [Utility createMuteList:dicResponse[@"respDetails"]];
            [self callServiceForCards];
        }
        else if([webHandler.str isEqualToString:GET_CARDS]){
            for(NSDictionary *vCard in dicResponse[@"respDetails"]){
                NSMutableDictionary *vCardDict = [vCard mutableCopy];
                vCardDict[@"isFriend"] = @true;
                
                if([groupIDsToBeFetched containsObject:vCardDict[@"_id"]])
                    vCardDict[@"cardType"] = [Utility CardTypeToString:cd_PRIVATE_GROUP];
                else
                    vCardDict[@"cardType"] = [Utility CardTypeToString:cd_USER];
                NSLog(@"%@",vCardDict[@"video"][@"url_highRes"]);
                [DatabaseHelper saveModel:@"VcardObject" FromResponseDict:vCardDict];
            }
            
            [cardsIDsToBeFetched removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, ([cardsIDsToBeFetched count] > PAGINATION_COUNT) ? PAGINATION_COUNT:[cardsIDsToBeFetched count])]];
            if([cardsIDsToBeFetched count])
                [self callServiceForCards];
            else {
                NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
                [userdefaults setBool:true forKey:@"contactSynced"];
                [userdefaults synchronize];
                [self checkOfflineMessages];
            }
        }
    }
    else
        [self deleteDBAndShowError];
}



//-(void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponse
//{
//   // //NSLog(@"dicResponce:-%@",dicResponse);
//    //  check resvice responce
//
//    @try {
//
//        if([dicResponse[@"oprSuccess"] integerValue]){
//
//
//            if([dicResponse[@"respDetails"] isKindOfClass:[NSArray class]]){
//
//                [cardsIDs addObjectsFromArray:dicResponse[@"respDetails"]];
//
//                if(friendsRetrived){
//                    [self callServiceForObjects:NO ForGroupParticipants:NO];
//
//                }
//                else{
//                    friendsRetrived = YES;
//                    [self callServiceForPrivateRelations:YES];
//                }
//
//            }
//            else if([dicResponse[@"respDetails"] isKindOfClass:[NSString class]]){
//
//                if([dicResponse[@"respDetails"] isEqualToString:@"NOT FOUND"]){
//
//                    fetchedIndex++;
//
//                    if(fetchedIndex == [objectIDs count])
//                    {
//                        fetchedIndex = 0;
//                        [self callServiceForObjects:YES ForGroupParticipants:NO];
//
//                    }
//                    else if (lastFetchedIndex + 5 == fetchedIndex){
//                        [self callServiceForObjects:NO ForGroupParticipants:NO];
//                    }
//                }
//            }
//
//            else if([dicResponse[@"respDetails"] objectForKey:@"objType"]){
//
//                if([[dicResponse[@"respDetails"] objectForKey:@"objType"] isEqualToString:@"oj_VCARD"] && [[dicResponse[@"respDetails"] objectForKey:@"cardType"] isEqualToString:@"cd_PRIVATE_GROUP"]){
//
//                    fetchedIndex++;
//                    [groupIDs addObject:dicResponse[@"respDetails"][@"_id"]];
//                    [DatabaseHelper saveModel:@"VcardObject" FromResponseDict:dicResponse[@"respDetails"]];
//                    if(fetchedIndex == [objectIDs count])
//                    {
//                        fetchedIndex = 0;
//                        [self callServiceForObjects:YES ForGroupParticipants:NO];
//
//
//                    }
//                    else if (lastFetchedIndex + 5 == fetchedIndex){
//                        [self callServiceForObjects:NO ForGroupParticipants:NO];
//                    }
//
//                }
//                else if([[dicResponse[@"respDetails"] objectForKey:@"objType"] isEqualToString:@"oj_VCARD"]){
//
//                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//
//                    if([[dicResponse[@"respDetails"] objectForKey:@"cardType"] isEqualToString:@"cd_AVATAR"] &&  [[dicResponse[@"respDetails"] objectForKey:@"creator_id"] isEqualToString:[defaults objectForKey:UserID]] ){
//
//                        [defaults setObject:[dicResponse[@"respDetails"] objectForKey:@"_id"] forKey:AvatarID];
//                        [defaults synchronize];
//                    }
//
//                    fetchedIndex++;
//                    NSMutableDictionary *actualDict = [dicResponse[@"respDetails"] mutableCopy];
//                    actualDict[@"isFriend"] = ([webHandler.str isEqualToString:@"isFriend"]) ? @true :@false;
//                    [DatabaseHelper saveModel:@"VcardObject" FromResponseDict:actualDict];
//
//                    if(fetchedIndex == [objectIDs count])
//                    {
//                        if([grpMemberCardIDS count]){
//                            NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
//                            [userdefaults setBool:true forKey:@"contactSynced"];
//                            [userdefaults synchronize];
//
//                            [self checkOfflineMessages];
//                        }
//                        else{
//                            fetchedIndex = 0;
//                            [self callServiceForObjects:YES ForGroupParticipants:NO];
//                        }
//
//                    }
//                    else if (lastFetchedIndex + 5 == fetchedIndex){
//                        if([grpMemberCardIDS count])
//                            [self callServiceForObjects:NO ForGroupParticipants:NO];
//                        else
//                            [self callServiceForObjects:YES ForGroupParticipants:YES];
//
//                    }
//
//
//                }
//                else if([[dicResponse[@"respDetails"] objectForKey:@"objType"] isEqualToString:@"oj_PRIVATE_GROUP"]){
//
//                    fetchedIndex++;
//                    [grpMemberCardIDS addObjectsFromArray:dicResponse[@"respDetails"][@"admins"]];
//                    [grpMemberCardIDS addObjectsFromArray:dicResponse[@"respDetails"][@"members"]];
//                    [DatabaseHelper saveModel:@"PrivateGroupObject" FromResponseDict:dicResponse[@"respDetails"]];
//                    if(fetchedIndex == [objectIDs count])
//                    {
//                        fetchedIndex = 0;
//                        [grpMemberCardIDS removeObjectsInArray:[cardsIDs allObjects]];
//                        [self callServiceForObjects:YES ForGroupParticipants:YES];
//                    }
//
//                    else if (lastFetchedIndex + 5 == fetchedIndex){
//                        [self callServiceForObjects:YES ForGroupParticipants:NO];
//
//                    }
//                }
//            }
//
//            else{
//
//                //Sync Contact List Response
//                NSMutableDictionary *dictFriends = [dicResponse[@"respDetails"] mutableCopy];
//                NSArray *keysForNullValues = [dictFriends allKeysForObject:[NSNull null]];
//                [dictFriends removeObjectsForKeys:keysForNullValues];
//                [cardsIDs addObjectsFromArray:[dictFriends allValues]];
//                [self callServiceForPrivateRelations:NO];
//
//
//            }
//
//        }
//        else{
//            if(requestNumber == 4 || requestNumber == 5){
//                fetchedIndex++;
//
//                if(fetchedIndex == [objectIDs count])
//                {
//                    fetchedIndex = 0;
//                    [self callServiceForObjects:YES ForGroupParticipants:NO];
//
//                }
//                else if (lastFetchedIndex + 5 == fetchedIndex){
//                    [self callServiceForObjects:NO ForGroupParticipants:NO];
//                }
//
//            }
//            else
//                [self deleteDBAndShowError];
//
//        }
//
//    }
//    @catch (NSException *exception) {
//    }
//
//}

-(void) webServiceHandler:(WebserviceHandler *)webHandler requestFailedWithError:(NSError *)error
{
    
    //NSLog(@"dicResponce:-%@",[error description]);
    [self deleteDBAndShowError];
    //remove it after WS call
}


-(void)deleteDBAndShowError{
    //ShowAlert(AppName,@"User Sycing Not Successful. Please try again.");
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate) resetApplicationModel];
    
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setBool:false forKey:@"contactSynced"];
    [userdefaults synchronize];
    
    
    //delete all wb calls
    [self.delegate userSyncFinished:NO];
}


-(NSArray *)getAllContacts
{
    CFErrorRef *error = nil;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    
    __block BOOL accessGranted = NO;
    
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        accessGranted = NO;
        
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //2
        accessGranted = YES;
    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    
    
    if (accessGranted) {
        
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
        CFRetain(allPeople);
        //  CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
        NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < CFArrayGetCount(allPeople); i++)
        {
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            CFRetain(person);
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for(CFIndex i=0;i<ABMultiValueGetCount(multiPhones);i++) {
                
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
                if(phoneNumber){
                    phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if([phoneNumber characterAtIndex:0] == '+')
                        phoneNumber = [NSString stringWithFormat:@"+%@",[phoneNumber stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phoneNumber length])]];
                    else
                        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phoneNumber length])];
                }
                
                if (phoneNumber && [phoneNumber length])
                    [phoneNumbers addObject:phoneNumber];
                
                // CFRelease(person);
            }
        }
        
        //     CFRelease(allPeople);
        //  CFRelease(source);
        //    CFRelease(addressBook);
        
        return phoneNumbers;
        
    }
    else{
        NSLog(@"Cannot fetch Contacts :( ");
        return nil;
    }
    
    
    
}

-(void)retriveFriends{
    
}


-(void)callServiceForObjects:(BOOL)ifGroups ForGroupParticipants:(BOOL)forParticipants{
    
    if(fetchedIndex == 0){
        if(!ifGroups){
            NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
            [cardsIDs addObject:[userdefaults objectForKey:UserID]];
        }
        
        requestNumber = ifGroups ? ((forParticipants)? 6 : 5): 4;
        objectIDs = ifGroups ? ((forParticipants)? grpMemberCardIDS.array : [groupIDs allObjects]) :[cardsIDs allObjects];
        
        if([objectIDs count] == 0)
        {
            
            NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
            [userdefaults setBool:true forKey:@"contactSynced"];
            [userdefaults synchronize];
            
            [self checkOfflineMessages];
            return;
        }
        
    }
    
    lastFetchedIndex = fetchedIndex;
    for (int i = fetchedIndex; i<fetchedIndex +5; i++) {
        
        if(i == [objectIDs count])
            break;
        WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
        objWebServiceHandler.delegate = self;
        
        if(ifGroups && !forParticipants)
            //for AFNetworking request
            [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getPrivateGroupRequest:objectIDs[i]] withMethod:@"" withUrl:@"" forKey:@""];
        else if([objectIDs[i] isEqualToString:@"Avatar"])
            //for AFNetworking request
            [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getVcardBy:rq_AVATAR andValue:nil andHighRes:false] withMethod:@"" withUrl:@"" forKey:@""];
        else{
            //for AFNetworking request
            if(forParticipants)
                objWebServiceHandler.str = @"isNotFriend";
            else
                objWebServiceHandler.str = @"isFriend";
            
            [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getVcardBy:rq_ID andValue:objectIDs[i] andHighRes:false] withMethod:@"" withUrl:@"" forKey:@""];
        }
        
    }
    
    
    
}


-(void)callServiceToGetPrivateGroup:(NSString *)grpID{
    
    WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
    objWebServiceHandler.delegate = self;
    
    //for AFNetworking request
    [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getPrivateGroupRequest:grpID] withMethod:@"" withUrl:@"" forKey:@""];
    
}


-(void)callServiceToGetMuteList
{
    
    WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
    objWebServiceHandler.delegate = self;
    objWebServiceHandler.str = GET_MUTE_LIST;
    [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getMuteListRequest] withMethod:@"" withUrl:@"" forKey:@""];
}
@end