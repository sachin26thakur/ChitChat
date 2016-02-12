//
//  DatabaseHelper.m
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "DatabaseHelper.h"
#import "SocketStream.h"
#import "Constants.h"
#import "AppDelegate.h"


#define MESSAGE_FETCH_LIMIT 2

@implementation DatabaseHelper


+(NSManagedObjectContext *)getManagedContext{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
}

+(void)saveManagedContext{
    
    @try {
        
        // Fetch the records and handle an error
        NSError *error;
        if (![[DatabaseHelper getManagedContext] save:&error]) {
            NSLog(@"Error SAVING %@",[error description]);
        }
        [[SocketStream sharedSocketObject] refreshCardsData];
    }
    @catch (NSException *exception) {
        
    }
    
}


+(BOOL)saveDBManagedContext{
    @try {
        
        // Fetch the records and handle an error
        NSError *error;
        if (![[DatabaseHelper getManagedContext] save:&error]) {
            NSLog(@"Error SAVING %@",[error description]);
            return false;
        }
        [[SocketStream sharedSocketObject] refreshCardsData];
        return true;
    }
    @catch (NSException *exception) {
        
    }
}

+(void)deleteModelObject:(id)object{
    @try {
        
        [[DatabaseHelper getManagedContext] deleteObject:object];
        [DatabaseHelper saveManagedContext];
        [[SocketStream sharedSocketObject] refreshCardsData];
    }
    @catch (NSException *exception) {
        
    }
}

+(void)deleteModelObjects:(NSArray *)objects{
    @try {
        
        for(id object in objects){
            [[DatabaseHelper getManagedContext] deleteObject:object];
            [DatabaseHelper saveManagedContext];
            
        }
        [[SocketStream sharedSocketObject] refreshCardsData];
    }
    @catch (NSException *exception) {
        
    }
}

+(NSArray *)getSearchedCardsList:(NSArray *)ids{
    @try {
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        // Define our table/entity to use
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"VcardObject" inManagedObjectContext:[self getManagedContext]];
        // Setup the fetch request
        [request setEntity:entity];
        
        NSPredicate *filterMePredicate = [NSPredicate predicateWithFormat:@"SELF.id_ IN %@",ids];
        [request setPredicate:filterMePredicate];
        
        //Sort Descriptor
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc]
                                                                     initWithKey:@"id_" ascending:NO],
                                    nil];
        [request setSortDescriptors:sortDescriptors];
        
        // Fetch the records and handle an error
        NSError *error;
        NSMutableArray *mutableFetchResults = [[[self getManagedContext] executeFetchRequest:request error:&error] mutableCopy];
        if (!mutableFetchResults) {
            // Handle the error.
            // This is a serious error and should advise the user to restart the application
        }
        
        return mutableFetchResults;
    }
    @catch (NSException *exception) {
        
    }
    
}


+(BOOL)saveModel:(NSString *)modelName FromResponseDict:(NSDictionary *)dict{
    @try {
        
        
        id Object = [self getExistingRecordModel:modelName byID:dict[@"_id"]];
        if (Object) {
            if([NSClassFromString(modelName) UpdateObject:Object FromDict:dict])
            {
                [[SocketStream sharedSocketObject] refreshCardsData];
                return true;
            }
        }
        else
        {
            NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
            if([NSClassFromString(modelName) saveObjectFromDict:dict] && [userdefaults boolForKey:@"userLoggedIn"])
            {
                [[SocketStream sharedSocketObject] refreshCardsData];
                return true;
            }
        }
        return false;
    }
    @catch (NSException *exception) {
        
    }
}




+(NSMutableArray *)initializedChatData{
    
    return [self fetchRecords];
}

+(id)getExistingRecordModel:(NSString *)modelName byID:(NSString *)id_{
    
    @try {
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        // Define our table/entity to use
        NSEntityDescription *entity = [NSEntityDescription entityForName:modelName inManagedObjectContext:[self getManagedContext]];
        // Setup the fetch request
        [request setEntity:entity];
        
        NSPredicate *filterMePredicate = [NSPredicate predicateWithFormat:@"SELF.id_ = %@",id_];
        [request setPredicate:filterMePredicate];
        
        //Sort Descriptor
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc]
                                                                     initWithKey:@"id_" ascending:NO],
                                    nil];
        [request setSortDescriptors:sortDescriptors];
        
        // Fetch the records and handle an error
        NSError *error;
        NSMutableArray *mutableFetchResults = [[[self getManagedContext] executeFetchRequest:request error:&error] mutableCopy];
        if (!mutableFetchResults) {
            // Handle the error.
            // This is a serious error and should advise the user to restart the application.
            return nil;
        }
        else if (![mutableFetchResults count])
            return nil;
        else
            return mutableFetchResults[0];
    }
    @catch (NSException *exception) {
        
    }
}


+ (NSMutableArray *)fetchRecords {
    
    @try {
        
        NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
        NSString *userID = [userdefaults objectForKey:UserID];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        // Define our table/entity to use
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"VcardObject" inManagedObjectContext:[self getManagedContext]];
        // Setup the fetch request
        [request setEntity:entity];
        
        //NSPredicate *filterMePredicate = [NSPredicate predicateWithFormat:@"SELF.id_ != %@",userID];
        //[request setPredicate:filterMePredicate];
        
        //Sort Descriptor
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc]
                                                                     initWithKey:@"id_" ascending:NO],
                                    nil];
        [request setSortDescriptors:sortDescriptors];
        
        // Fetch the records and handle an error
        NSError *error;
        NSMutableArray *mutableFetchResults = [[[self getManagedContext] executeFetchRequest:request error:&error] mutableCopy];
        if (!mutableFetchResults) {
            // Handle the error.
            // This is a serious error and should advise the user to restart the application
        }
        
        return mutableFetchResults;
    }
    @catch (NSException *exception) {
        
    }
}

+(id)getDBObjectsForModel:(NSString *)modelName filterbyPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortArray{
    
    @try{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        // Define entity
        NSEntityDescription *entity = [NSEntityDescription entityForName:modelName inManagedObjectContext:[self getManagedContext]];
        
        // Setup the fetch request
        [request setEntity:entity];
        
        //Setting Predicate
        if(predicate)
            [request setPredicate:predicate];
        
        //Settign sort descriptors
        if(sortArray)
            [request setSortDescriptors:sortArray];
        
        // Fetch the records and handle an error
        NSError *error;
        NSArray *fetchResultArray = [[self getManagedContext] executeFetchRequest:request error:&error];
        
        if (!fetchResultArray || ([fetchResultArray count] == 0))
            return nil;
        else
            return fetchResultArray;
    }
    @catch (NSException *exception) {
        
    }
    
    
}

+(id)getChatMessagesForCard:(NSString *)id_ fromTimeStamp:(NSNumber *)lastTimestamp withLimit:(NSUInteger)fetchlimit {
    
    @try{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        // Define entity
        NSEntityDescription *entity = [NSEntityDescription entityForName:ChatMessage_OBJ inManagedObjectContext:[self getManagedContext]];
        
        // Setup the fetch request
        [request setEntity:entity];
        
        //Get count of records
        NSError *error;
        
        // Limit
        if (fetchlimit !=0) {
            [request setFetchLimit:fetchlimit];
        }
        
        
        //Settign sort descriptors
        [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timeFirstSent" ascending:NO]]];
        
        
        
        // Setting Predicate
        if(lastTimestamp)
            [request setPredicate:[NSPredicate predicateWithFormat:@"(SELF.rx_id CONTAINS[cd] %@ || SELF.rxg_id CONTAINS[cd] %@) AND SELF.timeFirstSent < %@ AND SELF.objType = %@",id_,id_,lastTimestamp,@"oj_MESSAGE"]];
        else
            [request setPredicate:[NSPredicate predicateWithFormat:@"(SELF.rx_id CONTAINS[cd] %@ || SELF.rxg_id CONTAINS[cd] %@) AND SELF.objType = %@",id_,id_,@"oj_MESSAGE"]];
        
        
        //        if(lastTimestamp)
        //            [request setPredicate:[NSPredicate predicateWithFormat:@"(((SELF.rx_id CONTAINS[cd] %@ || SELF.rxg_id CONTAINS[cd] %@) AND SELF.tx_id = %@) OR ((SELF.rx_id CONTAINS[cd] %@ || SELF.rxg_id CONTAINS[cd] %@) AND SELF.tx_id = %@)) AND SELF.timeFirstSent < %@ AND SELF.objType = %@",id_,id_,[SocketStream sharedSocketObject].userID,[SocketStream sharedSocketObject].userID,[SocketStream sharedSocketObject].userID,id_,lastTimestamp,"oj_MESSAGE"]];
        //        else
        //            [request setPredicate:[NSPredicate predicateWithFormat:@"(((SELF.rx_id CONTAINS[cd] %@ || SELF.rxg_id CONTAINS[cd] %@) AND SELF.tx_id = %@) OR ((SELF.rx_id CONTAINS[cd] %@ || SELF.rxg_id CONTAINS[cd] %@) AND SELF.tx_id = %@)) AND SELF.objType = %@",id_,id_,[SocketStream sharedSocketObject].userID,[SocketStream sharedSocketObject].userID,[SocketStream sharedSocketObject].userID,id_,"oj_MESSAGE"]];
        
        // Fetch the records and handle an error
        NSArray *fetchResultArray = [[self getManagedContext] executeFetchRequest:request error:&error];
        
        
        if (!fetchResultArray || ([fetchResultArray count] == 0))
            return nil;
        else{
            return [[fetchResultArray reverseObjectEnumerator] allObjects];;
            
        }
    }
    @catch (NSException *exception) {
        
        return nil;
    }
    
}

+(id)getChatMessagesForCard:(NSString *)id_ afterTimeStamp:(NSNumber *)lastTimestamp{
    
    @try{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        // Define entity
        NSEntityDescription *entity = [NSEntityDescription entityForName:ChatMessage_OBJ inManagedObjectContext:[self getManagedContext]];
        
        // Setup the fetch request
        [request setEntity:entity];
        
        NSError *error;
        
        //Settign sort descriptors
        [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timeFirstSent" ascending:YES]]];
        
        // Setting Predicate
        if(lastTimestamp)
            [request setPredicate:[NSPredicate predicateWithFormat:@"(SELF.rx_id CONTAINS[cd] %@ || SELF.rxg_id CONTAINS[cd] %@) AND SELF.timeFirstSent >= %@",id_,id_,lastTimestamp]];
        
        // Fetch the records and handle an error
        NSArray *fetchResultArray = [[self getManagedContext] executeFetchRequest:request error:&error];
        
        
        if (!fetchResultArray || ([fetchResultArray count] == 0))
            return nil;
        else{
            return fetchResultArray;
            
        }
    }
    @catch (NSException *exception) {
        
    }
    
}


+(BOOL)isDefaultSetDownloaded{
    
    VcardObject *cardObj = [DatabaseHelper getExistingRecordModel:VCard_OBJ byID:[SocketStream sharedSocketObject].userID];
    NSPredicate *defaultPredicate = [NSPredicate predicateWithFormat:@"SELF.creator_id = %@",Default_Creator_ID];
    NSSet *defaultSets = [cardObj.downloaded_emoji_sticker_relationship filteredSetUsingPredicate:defaultPredicate];
    
    if(defaultSets && [defaultSets count])
        return true;
    else
        return false;
}

@end
