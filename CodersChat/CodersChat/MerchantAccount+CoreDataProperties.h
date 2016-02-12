//
//  MerchantAccount+CoreDataProperties.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MerchantAccount.h"

NS_ASSUME_NONNULL_BEGIN

@interface MerchantAccount (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *accountActive;
@property (nullable, nonatomic, retain) NSNumber *accountSet;
@property (nullable, nonatomic, retain) NSString *creatorId;
@property (nullable, nonatomic, retain) NSDate *dataLastModified;
@property (nullable, nonatomic, retain) NSDate *dataSet;
@property (nullable, nonatomic, retain) NSString *objType;

@end

NS_ASSUME_NONNULL_END
