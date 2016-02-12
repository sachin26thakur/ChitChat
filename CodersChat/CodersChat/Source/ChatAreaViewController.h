//
//  ChatAreaViewController.h
//  CodersChat
//
//  Created by Vishal Bhadade on 12/02/16.
//  Copyright (c) 2016 GlobalLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VcardObject.h"
#import "Utility.h"
#import "Constants.h"
#import "ChatMessageObject.h"
#import "MediaObject.h"
#import "IndividualChatCell.h"


@interface ChatAreaViewController : UIViewController{
    NSMutableArray *individualChatData;
    
}

#define kOFFSET_FOR_KEYBOARD 216.0
#define PEAK_MESSAGE_TIMER 10
#define PEAK_MEDIA_TIMER 30
#define PEAK_MESSAGE_LIFE 10
#define MAX_MESSAGE_VIEW_HEIGHT 100
#define MAX_RECORD_DURATION 2
#define MAX_RECORD_DURATION_STRING 2.0
#define SPACING_FOR_STICKER_MESSAGES 80
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define MUTE_REQUEST @"mute_request"
#define EMOJI_STICKER_REQUEST @"emojiStickerRequest"
#define DEFAULT_MESSAGE_TEXT NSLocalizedString(@"send message", nil)
#define DEFAULT_EMOJI_STICKER_REQUEST @"DefaultEmojiStickerRequest"
#define GET_FULL_SET_REQUEST @"getFullSetRequest"
#define GET_INDIVIDUAL_IMAGE_REQUEST @"getIndividualImageRequest"

#define BUTTON_SPACING_ON_SELECTION_MODE -80
#define BUTTON_SPACING_ON_NORMAL_MODE 0

@property (weak, nonatomic) IBOutlet UIImageView *friendImage;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *friendActiveStatus;

@property (nonatomic,strong) VcardObject *cardObject;

@property (nonatomic,strong) IBOutlet UIView *viewChatBox;
@property (nonatomic,strong) NSNumber* chatType;
@property (nonatomic) NSInteger chatNumber;
@property (nonatomic,strong) NSString *transmiterID;
@property (nonatomic,strong) NSString *chatName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VSpaceKeyboardView;

@property (nonatomic,strong) IBOutlet UIImageView *sepratorIcon1;
@property (nonatomic,strong) IBOutlet UIImageView *sepratorIcon2;

@property (nonatomic,strong) NSString *chatStatus;

-(void)newGroupCreated:(NSArray*)grpIDs withChatMessage:(ChatMessageObject *)msgObj sendNotification:(BOOL)notificationNeeded;
-(void)postDeleted;

-(void)downlaodEmojiImageForIndex:(NSInteger)rowIndex withID:(NSArray *)imageIDs;
-(void)loadEmojiImagesForIndex:(NSInteger)rowIndex withID:(NSArray *)imageURLs;
@end