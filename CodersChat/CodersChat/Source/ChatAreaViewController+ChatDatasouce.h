//
//  ChatAreaViewController+ChatDatasouce.h
//  ChitChat
//
//  Created by GlobalLogic on 13/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "ChatAreaViewController.h"

typedef  NS_ENUM(NSInteger, TYPE_OF_MESSAGE){
    MediaMessage,
    TextMessage,
    EmojiStickerShareMessage
};

typedef  NS_ENUM(NSInteger, TYPE_OF_MEDIA_MESSAGE){
    AudioMessage,
    ImageMessage,
    VideoMessage
};

@interface ChatAreaViewController(ChatDatasouce)

-(void)getAllMessagesConverted;
-(void)getMessageConverted:(ChatMessageObject *)messageObj forIndex:(NSInteger)index;

-(BOOL)isNormalMessage:(ChatMessageObject *)messageObj;
-(BOOL)isMessageSent:(ChatMessageObject *)messageObj byCardId:(NSString *)cardID;
@end
