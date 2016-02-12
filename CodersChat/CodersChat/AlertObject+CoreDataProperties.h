//
//  AlertObject+CoreDataProperties.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AlertObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlertObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isViewed;
@property (nullable, nonatomic, retain) NSString *notif_type;
@property (nullable, nonatomic, retain) VcardObject *friend_relationship;

@end

NS_ASSUME_NONNULL_END
