//
//  MediaObject.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChatMessageObject, VcardObject;

NS_ASSUME_NONNULL_BEGIN

@interface MediaObject : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "MediaObject+CoreDataProperties.h"
