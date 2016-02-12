//
//  DatabaseHelper.h
//  ChitChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "DatabaseHelper.h"
#import "AppDelegate.h"
#import "VcardObject.h"
#import "PrivateGroupObject.h"
#import "EmojiStickerImage.h"
#import "EmojiStickerSet.h"
#import "MerchantAccount.h"
#import <CoreData/CoreData.h>



#define EmojiStickerSetName @"EmojiStickerSet"
#define EmojiStickerImageName @"EmojiStickerImage"

@interface DatabaseHelper:NSObject
+(NSManagedObjectContext *)getManagedContext;
+(void)saveManagedContext;
+(BOOL)saveDBManagedContext;
+(void)deleteModelObject:(id)object;
+(BOOL)saveModel:(NSString *)modelName FromResponseDict:(NSDictionary *)dict;
+(id)getModelObject:(NSString *)modelName FromResponseDict:(NSDictionary *)dict;
+(void)startFollowingVcard:(VcardObject *)cardObj withMode:(NSNumber *)mode;
+(NSMutableArray *)initializedChatData;
+(void)deleteModelObjects:(NSArray *)objects;
+(id)getExistingRecordModel:(NSString *)modelName byID:(NSString *)id_;

+(NSArray *)getSearchedCardsList:(NSArray *)ids;
+(id)getDBObjectsForModel:(NSString *)modelName filterbyPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortArray;
+(BOOL)isDefaultSetDownloaded;
+(id)getChatMessagesForCard:(NSString *)id_ fromTimeStamp:(NSNumber *)lastTimestamp withLimit:(NSUInteger)fetchlimit;
+(id)getChatMessagesForCard:(NSString *)id_ afterTimeStamp:(NSNumber *)lastTimestamp;
@end

