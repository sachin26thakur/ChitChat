//
//  TextChatCell.m
//  ChitChat
//
//  Created by GlobalLogic on 13/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "TextChatCell.h"
#import "ChatMessageObject.h"
#import "SocketStream.h"
#import "Utility.h"
#import "Constants.h"

#define SPACING_FOR_STICKER_MESSAGES 80

@implementation TextChatCell

-(void)setCellProperties:(ChatMessageObject *)messageObj{
    
    [super setCellProperties:messageObj];
    
    
    if([messageObj.msgType isEqualToString:[Utility MessageTypeToString:mg_SEND_BROADCAST]]){
        self.textViewBottomConstraint.constant = -35;
        self.nTimesLbl.text = [NSString stringWithFormat:@"%@",messageObj.nTimesSent];
        self.dateLbl.text = [self.dateFormatterMediumDate stringFromDate:[NSDate dateWithTimeIntervalSince1970:([messageObj.timeFirstSent longLongValue]/1000)]];
        self.creatorLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"By", nil),messageObj.tx_name];
        [self.creatorLabel sizeToFit];
        self.creatorLabel.adjustsFontSizeToFitWidth = YES;
        
        self.creatorID = messageObj.tx_id;
        
        self.nTimesLbl.hidden = false;
        self.dateLbl.hidden = false;
        self.viewBtn.hidden = false;
        self.creatorLabel.hidden = false;
        
    }
    else if([messageObj.msgDetails isEqualToString:StickerMessageIdentifier]){
        
        self.textViewBottomConstraint.constant = 0;
        //  self.textView.layer.borderWidth = 1.0f;
        // self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.nTimesLbl.hidden = true;
        self.dateLbl.hidden = true;
        self.viewBtn.hidden = true;
        self.creatorLabel.hidden = true;
    }
    else {
        self.textViewBottomConstraint.constant = -8;
        
        self.nTimesLbl.hidden = true;
        self.dateLbl.hidden = true;
        self.viewBtn.hidden = true;
        self.creatorLabel.hidden = true;
        
    }
    
    self.creatorLabel.userInteractionEnabled = true;
    self.creatorTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(creatorLabelTapped:)];
    [self.creatorLabel addGestureRecognizer:self.creatorTapped];
    
    [self.indicator stopAnimating];
    self.indicator.hidden = true;
    
    
    
    if(messageObj.msgAttributedText)
    {
        self.textView.attributedText = messageObj.msgAttributedText;
        
        if(NSLocaleLanguageDirectionLeftToRight== [NSLocale characterDirectionForLanguage:messageObj.msgText])
            self.textView.textAlignment = NSTextAlignmentLeft;
        else
            self.textView.textAlignment = NSTextAlignmentRight;
        
        if([messageObj.status isEqualToString:@"Downloading"]){
            [self.indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
            self.indicator.hidden = false;
            [self.indicator startAnimating];
            
        }
    }
    self.timeLabel.text = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([messageObj.timeFirstSent longLongValue]/1000)]];
    
    if([messageObj.tx_id isEqualToString:[SocketStream sharedSocketObject].userID]){
        
        self.chatBoxImage.image = [UIImage imageNamed:@""];//white_chat_box.png
        [self.chatBoxImage setBackgroundColor:[UIColor whiteColor]];
        self.triangle.image = [UIImage imageNamed:@""];//white_chat_box_tri
        [self.triangle setBackgroundColor:[UIColor whiteColor]];
        UIBezierPath *path = [UIBezierPath new];
        [path moveToPoint:(CGPoint){0, 0}];
        
        [path addLineToPoint:(CGPoint){0, 30}];
        [path addLineToPoint:(CGPoint){30, 0}];
        [path addLineToPoint:(CGPoint){0, 0}];
        
        // Create a CAShapeLayer with this triangular path
        // Same size as the original imageView
        CAShapeLayer *mask = [CAShapeLayer new];
        mask.frame = self.triangle.bounds;
        mask.path = path.CGPath;
        
        // Mask the imageView's layer with this shape
        self.triangle.layer.mask = mask;
        
        self.trailingConstant.constant = 21;
        if(!messageObj.ackType){
            self.timeTriangleDistance.constant = 5;
            self.msgIcon.image = nil;
            
        }
        else{
            self.timeTriangleDistance.constant = 30;
            
            if([messageObj.ackType isEqualToString:@"ak_MSG_RECEIVED"])
                self.msgIcon.image = [UIImage imageNamed:@"message-undeliverd.png"];
            else if([messageObj.ackType isEqualToString:@"ak_MSG_DELIVERED"])
                self.msgIcon.image = [UIImage imageNamed:@"message-deliverd.png"];
            else if([messageObj.ackType isEqualToString:@"ak_MSG_READ"])
                self.msgIcon.image = [UIImage imageNamed:@"Message-opened.png"];
        }
    }
    else{
        
        self.chatBoxImage.image = [UIImage imageNamed:@""];//blue_chat_box.png
        [self.chatBoxImage setBackgroundColor: RGB(219,246,255)];
        
        self.triangle.image = [UIImage imageNamed:@""];//blue_chat_box_tri
        [self.triangle setBackgroundColor:RGB(219,246,255)];
        UIBezierPath *path = [UIBezierPath new];
        [path moveToPoint:(CGPoint){0, 0}];
        [path addLineToPoint:(CGPoint){40, 40}];
        [path addLineToPoint:(CGPoint){100, 0}];
        [path addLineToPoint:(CGPoint){0, 0}];
        
        // Create a CAShapeLayer with this triangular path
        // Same size as the original imageView
        CAShapeLayer *mask = [CAShapeLayer new];
        mask.frame = self.triangle.bounds;
        mask.path = path.CGPath;
        
        // Mask the imageView's layer with this shape
        self.triangle.layer.mask = mask;
        
        self.trailingConstant.constant = screenWidth-91;
        self.timeTriangleDistance.constant = TIME_LEADING_CONSTRAINT;
        self.msgIcon.image = nil;
    }
    
    if([messageObj.msgDetails isEqualToString:StickerMessageIdentifier])
    {
        self.chatBoxImage.image = [UIImage imageNamed:@""];
        [self.chatBoxImage setBackgroundColor: [UIColor clearColor]];
        self.triangle.image = [UIImage imageNamed:@""];//blue_chat_box_tri
        [self.triangle setBackgroundColor:[UIColor clearColor]];
    }
    self.timeLabel.hidden = true;
}

-(void)setCellProperties:(ChatMessageObject *)messageObj setSelected:(BOOL)isSelected{
    
    [self setCellProperties:messageObj];
    self.memberNameLabel.text = @"";
    
    if(isSelected)
        self.selectionView.hidden = NO;
    else
        self.selectionView.hidden = YES;
    
}

-(void)setCellProperties:(ChatMessageObject *)messageObj setSelected:(BOOL)isSelected fromGroupMember:(BOOL)isGrpMember{
    
    [self setCellProperties:messageObj setSelected:isSelected];
    if(![messageObj.tx_id isEqualToString:[SocketStream sharedSocketObject].userID]){
        
        self.textViewTopConstraint.constant = 17;
        self.memberNameLabel.text = ((VcardObject *)[[SocketStream sharedSocketObject] getCardByID:messageObj.tx_id]).creator_name;
    }
    else{
        self.textViewTopConstraint.constant = 7;
        self.memberNameLabel.text = @"";
    }
}

-(void)setImageWithChatObject:(ChatMessageObject *)chatMes{
    
}

-(void)creatorLabelTapped:(UITapGestureRecognizer *)recognizer{
    [self.delegate creatorLabelTapped:self.creatorID];
}

-(void)reatorLabelTapped:(UITapGestureRecognizer *)recognizer{
    [self.delegate reatorLabelTapped:self.creatorID];
}



@end
