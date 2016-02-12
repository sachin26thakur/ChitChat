//
//  ChatAreaViewController+ChatDatasouce.m
//  ChitChat
//
//  Created by GlobalLogic on 13/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatAreaViewController+ChatDatasouce.h"
#import "ChatAreaViewController.h"


@implementation ChatAreaViewController(ChatDatasouce)

-(void)getAllMessagesConverted{
    
    @synchronized(individualChatData) {
        
        for (int i =0 ;i<[individualChatData count] ;i++) {
            
            ChatMessageObject *messageObj = individualChatData[i];
            [self getMessageConverted:messageObj forIndex:i];
            
        }
    }
    
}

-(void)getMessageConverted:(ChatMessageObject *)messageObj forIndex:(NSInteger)index{
    
    if(!messageObj.media_relationship && ![messageObj.msgType isEqualToString:[Utility MessageTypeToString:mg_SHARE_EMOJI_STICKER]] && (messageObj.status == nil || [messageObj.status isEqualToString:@"Downloading"] || !messageObj.msgAttributedText))
    {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7;
        [paragraphStyle setAlignment:NSTextAlignmentNatural];
        
        
        NSDictionary *attrsDictionary =
        @{ NSFontAttributeName: TEXT_FONT,
           NSParagraphStyleAttributeName: paragraphStyle,NSForegroundColorAttributeName:RGB(99, 99, 101)};
        
        if([messageObj.msgDetails isEqualToString:EmojiMessageIdentifier] || [messageObj.msgDetails isEqualToString:StickerMessageIdentifier]){
            
            
            NSMutableArray *individualImageToBeDownloaded = [NSMutableArray new];
            NSMutableArray *individualURLImageToBeLoaded = [NSMutableArray new];
            
            NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:messageObj.msgText  attributes:attrsDictionary];
            
            
            NSMutableArray *substrings = [NSMutableArray new];
            NSScanner *scanner = [NSScanner scannerWithString:messageObj.msgText];
            [scanner scanUpToString:@"__" intoString:nil]; // Scan all characters before #
            while(![scanner isAtEnd]) {
                NSString *substring = nil;
                [scanner scanString:@"__" intoString:nil]; // Scan the # character
                if([scanner scanUpToString:@"__" intoString:&substring]) {
                    // If the space immediately followed the #, this will be skipped
                    if ([Utility isAlphaNumeric_24CharacterLengthID:substring]) {
                        [substrings addObject:substring];
                    }
                }
                [scanner scanUpToString:@"__" intoString:nil]; // Scan all characters before next #
            }
            NSLog(@"id is %@",substrings);
            
            for (NSString *strEmojiId in substrings) {
                if ([Utility isAlphaNumeric_24CharacterLengthID:strEmojiId]) {
                    NSString *IdValue = [[NSString alloc] initWithString:strEmojiId];
                    IdValue = [IdValue stringByReplacingOccurrencesOfString:@"_" withString:@""];
                    IdValue = [IdValue stringByReplacingOccurrencesOfString:@"__" withString:@""];
                    
                    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:IdValue options:0 error:nil];
                    
                    //  enumerate matches
                    NSRange range = NSMakeRange(0,[attributedString length]);
                    __block NSRange IdRange;
                    [expression enumerateMatchesInString:[attributedString string] options:0 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                        IdRange = [result rangeAtIndex:0];
                    }];
                    
                        [individualImageToBeDownloaded addObject:IdValue];
                        NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"  "];
                        [attributedString replaceCharactersInRange:NSMakeRange(IdRange.location-2, IdRange.length+4) withAttributedString:string];
                    
                }
            }
            
            if([individualImageToBeDownloaded count] || [individualURLImageToBeLoaded count]){
                if([individualImageToBeDownloaded count])
                    [self downlaodEmojiImageForIndex:index withID:individualImageToBeDownloaded];
                if([individualURLImageToBeLoaded count])
                    [self loadEmojiImagesForIndex:index withID:individualURLImageToBeLoaded];
                
                messageObj.status = @"Downloading";
            }
            else
                messageObj.status = @"Converted";
            
            [attributedString addAttributes:attrsDictionary range:NSMakeRange(0, attributedString.length)];
            messageObj.msgAttributedText = attributedString;
            
        }
        else if(messageObj.msgText)
        {
            
            messageObj.msgAttributedText = [[NSAttributedString alloc] initWithString:messageObj.msgText attributes:attrsDictionary];
        }
        
    }
}

-(TYPE_OF_MESSAGE)getType:(ChatMessageObject *)messageObj{
    
    if(messageObj.media_relationship)
        return MediaMessage;
    else if([messageObj.msgType isEqualToString:[Utility MessageTypeToString:mg_SHARE_EMOJI_STICKER]])
        return EmojiStickerShareMessage;
    else
        return TextMessage;
    
    
}
-(TYPE_OF_MEDIA_MESSAGE)getMediaType:(ChatMessageObject *)messageObj{
    
    if(ma_AUDIO == [Utility MediaTypeFromString:messageObj.media_relationship.mediaType])
        return AudioMessage;
    else if(ma_IMAGE == [Utility MediaTypeFromString:messageObj.media_relationship.mediaType])
        return ImageMessage;
    else
        return VideoMessage;
}

-(BOOL)isNormalMessage:(ChatMessageObject *)messageObj{
    if([messageObj.msgLife isEqual:@(-1)])
        return true;
    else
        return false;
}

-(BOOL)isMessageSent:(ChatMessageObject *)messageObj byCardId:(NSString *)cardID{
    if([messageObj.tx_id isEqualToString:cardID])
        return true;
    else
        return false;
}

@end
