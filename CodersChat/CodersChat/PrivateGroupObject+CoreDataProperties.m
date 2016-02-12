//
//  PrivateGroupObject+CoreDataProperties.m
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PrivateGroupObject+CoreDataProperties.h"

@implementation PrivateGroupObject (CoreDataProperties)

@dynamic id_;
@dynamic name;
@dynamic objType;
@dynamic admin_relationship;
@dynamic group_card_relationship;
@dynamic member_relationship;

+(instancetype)setObjectFromDict:(NSDictionary *)groupDict{
    
    PrivateGroupObject *privateGroup = (PrivateGroupObject *)[NSEntityDescription
                                                              entityForName:@"PrivateGroupObject"
                                                              inManagedObjectContext:[DatabaseHelper getManagedContext]];
    
    if(groupDict[@"_id"])
        privateGroup.id_ = groupDict[@"_id"];
    if(groupDict[@"name"])
        privateGroup.name = groupDict[@"name"];
    
    // if(groupDict[@"members"])
    //   privateGroup->members = groupDict[@"members"];
    // if(groupDict[@"admins"])
    //  privateGroup->admins = groupDict[@"admins"];
    
    return privateGroup;
}

+(BOOL)saveObjectFromDict:(NSDictionary *)groupDict{
    
    PrivateGroupObject *privateGroup = (PrivateGroupObject *)[NSEntityDescription
                                                              insertNewObjectForEntityForName:@"PrivateGroupObject"
                                                              inManagedObjectContext:[DatabaseHelper getManagedContext]];
    
    if(groupDict[@"objType"])
        privateGroup.objType = groupDict[@"objType"];
    if(groupDict[@"_id"])
        privateGroup.id_ = groupDict[@"_id"];
    if(groupDict[@"name"])
        privateGroup.name = groupDict[@"name"];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VcardObject" inManagedObjectContext:[DatabaseHelper getManagedContext]];
    
    // Setup the fetch request
    [request setEntity:entity];
    //Setup Predicate
    NSPredicate *cardPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ = %@",privateGroup.id_];
    [request setPredicate:cardPredicate];
    
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
        return NO;
    }
    
    [privateGroup setGroup_card_relationship:mutableFetchResults[0]];
    
    //Set Admin Relation
    
    NSPredicate *adminPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ IN %@",groupDict[@"admins"]];
    [request setPredicate:adminPredicate];
    mutableFetchResults = [[[DatabaseHelper getManagedContext] executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {
        // Handle the error.
        // This is a serious error and should advise the user to restart the application
        NSLog(@"Error SAVING");
        //return NO;
    }
    
    [privateGroup setAdmin_relationship:[NSSet setWithArray:mutableFetchResults]];
    
    //Set Member Relation
    
    NSPredicate *memberPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ IN %@",groupDict[@"members"]];
    [request setPredicate:memberPredicate];
    mutableFetchResults = [[[DatabaseHelper getManagedContext] executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {
        // Handle the error.
        // This is a serious error and should advise the user to restart the application
        NSLog(@"Error SAVING");
        // return NO;
    }
    
    [privateGroup setMember_relationship:[NSSet setWithArray:mutableFetchResults]];
    
    if (![[DatabaseHelper getManagedContext] save:&error]) {
        
        NSLog(@"Error SAVING");
        return NO;
    }
    
    return YES;
    
}

+(BOOL)UpdateObject:(id)Object FromDict:(NSDictionary *)groupDict{
    
    PrivateGroupObject *privateGroup = (PrivateGroupObject *)Object;
    
    if(groupDict[@"objType"])
        privateGroup.objType = groupDict[@"objType"];
    if(groupDict[@"_id"])
        privateGroup.id_ = groupDict[@"_id"];
    if(groupDict[@"name"])
        privateGroup.name = groupDict[@"name"];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VcardObject" inManagedObjectContext:[DatabaseHelper getManagedContext]];
    
    // Setup the fetch request
    [request setEntity:entity];
    //Setup Predicate
    NSPredicate *cardPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ = %@",privateGroup.id_];
    [request setPredicate:cardPredicate];
    
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
        return NO;
    }
    
    [privateGroup setGroup_card_relationship:mutableFetchResults[0]];
    
    //Set Admin Relation
    
    NSPredicate *adminPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ IN %@",groupDict[@"admins"]];
    [request setPredicate:adminPredicate];
    mutableFetchResults = [[[DatabaseHelper getManagedContext] executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {
        // Handle the error.
        // This is a serious error and should advise the user to restart the application
        NSLog(@"Error SAVING");
        //return NO;
    }
    [privateGroup setAdmin_relationship:nil];
    [privateGroup setAdmin_relationship:[NSSet setWithArray:mutableFetchResults]];
    
    //Set Member Relation
    
    NSPredicate *memberPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ IN %@",groupDict[@"members"]];
    [request setPredicate:memberPredicate];
    mutableFetchResults = [[[DatabaseHelper getManagedContext] executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {
        // Handle the error.
        // This is a serious error and should advise the user to restart the application
        NSLog(@"Error SAVING");
        // return NO;
    }
    
    [privateGroup setMember_relationship:nil];
    [privateGroup setMember_relationship:[NSSet setWithArray:mutableFetchResults]];
    
    if (![[DatabaseHelper getManagedContext] save:&error]) {
        
        NSLog(@"Error SAVING");
        return NO;
    }
    
    return YES;
    
}


-(NSDictionary *)getPrivateGroupObjectDict{
    
    NSMutableDictionary *groupDict = [NSMutableDictionary dictionary];
    
    if([Utility ObjectTypeFromString:self.objType] !=NOOBJ)
        [groupDict setValue:self.objType forKey:@"objType"];
    if(self.id_)
        [groupDict setValue:self.id_ forKey:@"_id"];
    if(self.name)
        [groupDict setValue:self.name forKey:@"name"];
    if(self.member_relationship)
        ;// [groupDict setValue:[self.members mutableCopy] forKey:@"members"];
    if(self.admin_relationship)
        ;//[groupDict setValue:[self.admins mutableCopy] forKey:@"admins"];
    
    return groupDict;
}


@end
