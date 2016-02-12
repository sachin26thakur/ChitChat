//
//  PrivateGroupObject+CoreDataProperties.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PrivateGroupObject.h"
#import "DatabaseHelper.h"
#import "Utility.h"
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrivateGroupObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *id_;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *objType;
@property (nullable, nonatomic, retain) NSSet *admin_relationship;
@property (nullable, nonatomic, retain) VcardObject *group_card_relationship;
@property (nullable, nonatomic, retain) NSSet *member_relationship;

+(instancetype)setObjectFromDict:(NSDictionary *)groupDict;
+(BOOL)saveObjectFromDict:(NSDictionary *)groupDict;
+(BOOL)UpdateObject:(id)Object FromDict:(NSDictionary *)cardDict;
-(NSDictionary *)getPrivateGroupObjectDict;

@end

@interface PrivateGroupObject (CoreDataGeneratedAccessors)

- (void)addAdmin_relationshipObject:(VcardObject *)value;
- (void)removeAdmin_relationshipObject:(VcardObject *)value;
- (void)addAdmin_relationship:(NSSet*)values;
- (void)removeAdmin_relationship:(NSSet*)values;

- (void)addMember_relationshipObject:(VcardObject *)value;
- (void)removeMember_relationshipObject:(VcardObject *)value;
- (void)addMember_relationship:(NSSet*)values;
- (void)removeMember_relationship:(NSSet*)values;

@end

NS_ASSUME_NONNULL_END
