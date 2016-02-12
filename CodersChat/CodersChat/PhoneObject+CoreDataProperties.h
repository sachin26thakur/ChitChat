//
//  PhoneObject+CoreDataProperties.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PhoneObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhoneObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *countryCode;
@property (nullable, nonatomic, retain) NSString *countryLetters;
@property (nullable, nonatomic, retain) NSString *internationalNum;
@property (nullable, nonatomic, retain) NSString *nationalNum;
@property (nullable, nonatomic, retain) VcardObject *card_relationship;

@end

NS_ASSUME_NONNULL_END
