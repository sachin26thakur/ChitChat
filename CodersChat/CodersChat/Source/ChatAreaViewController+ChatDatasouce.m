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
#import "FGTranslator.h"


@implementation ChatAreaViewController(ChatDatasouce)




- (FGTranslator *)translator {
    /*
     * using Bing Translate
     *
     * Note: The client id and secret here is very limited and is included for demo purposes only.
     * You must use your own credentials for production apps.
     */
    FGTranslator *translator = [[FGTranslator alloc] initWithBingAzureClientId:@"fgtranslator-demo" secret:@"GrsgBiUCKACMB+j2TVOJtRboyRT8Q9WQHBKJuMKIxsU="];
    
    // or use Google Translate
    
    // using Google Translate
    // translator = [[FGTranslator alloc] initWithGoogleAPIKey:@"your_google_key"];
    
    return translator;
}

- (void)translateMyText:(NSArray*)array atIndex:(NSUInteger)actualIndex{
    [self.translator translateText:((ChatMessageObject *)[individualChatData objectAtIndex:actualIndex]).msgText withSource:nil target:@"hi"
                        completion:^(NSError *error, NSString *translated, NSString *sourceLanguage)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             ChatMessageObject *msg = [individualChatData objectAtIndex:actualIndex];
             //msg.msgText = translated;
             NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
             paragraphStyle.lineSpacing = 7;
             [paragraphStyle setAlignment:NSTextAlignmentNatural];
             
             
             NSDictionary *attrsDictionary =
             @{ NSFontAttributeName: TEXT_FONT,
                NSParagraphStyleAttributeName: paragraphStyle,NSForegroundColorAttributeName:RGB(99, 99, 101)};
             
             if (translated) {
                 msg.msgAttributedText = [[NSAttributedString alloc] initWithString:translated attributes:attrsDictionary];
             }
             else {
                 msg.msgAttributedText = [[NSAttributedString alloc] initWithString:((ChatMessageObject *)[individualChatData objectAtIndex:actualIndex]).msgText attributes:attrsDictionary];
                 
             }
             
//             msg.msgAttributedText = [[NSAttributedString alloc] initWithString:translated attributes:attrsDictionary];
             msg.status = @"Converted";
             
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCollection" object:nil];
             
         });
         
         
     }];
}

- (void)translateText:(NSArray*)array atIndex:(NSUInteger)index{
    
    __block NSUInteger indexi = index;
    NSMutableArray *chatArray =[NSMutableArray new];
    [self.translator translateText:((ChatMessageObject *)[individualChatData objectAtIndex:indexi]).msgText withSource:nil target:@"hi"
                        completion:^(NSError *error, NSString *translated, NSString *sourceLanguage)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             ChatMessageObject *msg = [individualChatData objectAtIndex:indexi];
             //msg.msgText = translated;
             NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
             paragraphStyle.lineSpacing = 7;
             [paragraphStyle setAlignment:NSTextAlignmentNatural];
             
             
             NSDictionary *attrsDictionary =
             @{ NSFontAttributeName: TEXT_FONT,
                NSParagraphStyleAttributeName: paragraphStyle,NSForegroundColorAttributeName:RGB(99, 99, 101)};
             if (translated) {
                 msg.msgAttributedText = [[NSAttributedString alloc] initWithString:translated attributes:attrsDictionary];
             }
             else {
                 msg.msgAttributedText = [[NSAttributedString alloc] initWithString:((ChatMessageObject *)[individualChatData objectAtIndex:indexi]).msgText attributes:attrsDictionary];

             }
             msg.status = @"Converted";
             
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCollection" object:nil];
             indexi = indexi +1;
             
             if ([array count] == indexi) {
                 //individualChatData = chatArray;
                 return ;
             }
             
             [self translateText:array atIndex:indexi];
         });
        
         
     }];
    
}








-(void)getAllMessagesConverted{
    
    @synchronized(individualChatData) {
        
        for (int i =0 ;i<[individualChatData count] ;i++) {
            
            ChatMessageObject *messageObj = individualChatData[i];
            [self getSingleMessageConverted:messageObj forIndex:i];
        }
    }
    
    NSArray *arr = [individualChatData valueForKeyPath:@"msgText"];
    [self translateText:arr atIndex:0];
    
    
}


- (void)translateSingleText:(NSArray*)array atIndex:(NSUInteger)index{
    
    __block NSUInteger indexi = index;
    NSMutableArray *chatArray =[NSMutableArray new];
    [self.translator translateText:((ChatMessageObject *)[individualChatData objectAtIndex:index]).msgText withSource:nil target:@"hi"
                        completion:^(NSError *error, NSString *translated, NSString *sourceLanguage)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             ChatMessageObject *msg = [individualChatData objectAtIndex:indexi];
             //msg.msgText = translated;
             NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
             paragraphStyle.lineSpacing = 7;
             [paragraphStyle setAlignment:NSTextAlignmentNatural];
             
             
             NSDictionary *attrsDictionary =
             @{ NSFontAttributeName: TEXT_FONT,
                NSParagraphStyleAttributeName: paragraphStyle,NSForegroundColorAttributeName:RGB(99, 99, 101)};
             
             msg.msgAttributedText = [[NSAttributedString alloc] initWithString:translated attributes:attrsDictionary];
             msg.status = @"Converted";
             
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCollection" object:nil];
             indexi = indexi +1;
             
             if ([array count] == indexi) {
                 //individualChatData = chatArray;
                 return ;
             }
             
             [self translateText:array atIndex:indexi];
         });
         
         
     }];
    
}



-(void)getMessageConverted:(ChatMessageObject *)messageObj forIndex:(NSInteger)index{
    
    [self getSingleMessageConverted:messageObj forIndex:index-1];
    if (index>0) {
        index = index -1;
    }
    [self translateMyText:@[messageObj.msgText] atIndex:index];

}

-(void)getSingleMessageConverted:(ChatMessageObject *)messageObj forIndex:(NSInteger)index{

    if(!messageObj.media_relationship && ![messageObj.msgType isEqualToString:[Utility MessageTypeToString:mg_SHARE_EMOJI_STICKER]] && (messageObj.status == nil || [messageObj.status isEqualToString:@"Downloading"] || !messageObj.msgAttributedText))
    {
        
        
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7;
        [paragraphStyle setAlignment:NSTextAlignmentNatural];
        
        
        NSDictionary *attrsDictionary =
        @{ NSFontAttributeName: TEXT_FONT,
           NSParagraphStyleAttributeName: paragraphStyle,NSForegroundColorAttributeName:RGB(99, 99, 101)};
       
                messageObj.status = @"Downloading";
    
    
    messageObj.msgAttributedText = [[NSAttributedString alloc] initWithString:messageObj.msgText attributes:attrsDictionary];
        

    
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
