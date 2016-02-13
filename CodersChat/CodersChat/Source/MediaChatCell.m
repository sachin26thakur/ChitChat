//
//  MediaChatCell.m
//  ChitChat
//
//  Created by GlobalLogic on 13/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "MediaChatCell.h"
#import "ChatMessageObject.h"
#import "MediaObject.h"
#import "SocketStream.h"
#import "Utility.h"
#import "Constants.h"


@implementation MediaChatCell

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.chatBoxImage.layer.cornerRadius = 10.0;
    self.chatBoxImage.layer.shadowRadius = 1;
    self.chatBoxImage.layer.masksToBounds = NO;
    self.chatBoxImage.layer.shadowColor = RGB(242, 242, 242).CGColor;
    self.chatBoxImage.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    self.chatBoxImage.layer.shadowOpacity = 0.5f;
    
}


-(void)setCellProperties:(ChatMessageObject *)messageObj{
    
    [super setCellProperties:messageObj];
    
    [self.downloadBtn setImage:[UIImage imageNamed:@"download-icon.png"] forState:UIControlStateNormal];
    self.indicator.hidden = YES;
    
    if([messageObj.msgType isEqualToString:[Utility MessageTypeToString:mg_SEND_BROADCAST]]){
        self.mediaViewBottomContraint.constant = -35;
        self.nTimesLbl.text = [NSString stringWithFormat:@"%@",messageObj.nTimesSent];
        self.dateLbl.text = [self.dateFormatterMediumDate stringFromDate:[NSDate dateWithTimeIntervalSince1970:([messageObj.timeFirstSent longLongValue]/1000)]];
        self.creatorLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"By", nil),messageObj.tx_name];
        self.creatorID = messageObj.tx_id;
        
        
        self.nTimesLbl.hidden = false;
        self.dateLbl.hidden = false;
        self.viewBtn.hidden = false;
        self.creatorLabel.hidden = false;
        
        
    }
    else{
        self.mediaViewBottomContraint.constant = -8;
        
        self.nTimesLbl.hidden = true;
        self.dateLbl.hidden = true;
        self.viewBtn.hidden = true;
        self.creatorLabel.hidden = true;
        
        
        
    }
    
    self.creatorLabel.userInteractionEnabled = true;
    self.creatorTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(creatorLabelTapped:)];
    [self.creatorLabel addGestureRecognizer:self.creatorTapped];
    
    if(messageObj.media_relationship.highRes || messageObj.media_relationship.lowRes){
        
        if([messageObj.media_relationship.mediaType isEqualToString:@"ma_IMAGE"]){
            if(messageObj.media_relationship.highRes){
                
                self.imageView.image =  [UIImage imageWithData:messageObj.media_relationship.highRes];
                self.downloadBtn.hidden = YES;
            }
            else{
                
                self.imageView.image = [UIImage imageWithData:messageObj.media_relationship.lowRes];
                self.downloadBtn.hidden = NO;
            }
            
        }
        else{
            if(messageObj.media_relationship.highRes){
                
                self.imageView.image =  [UIImage imageWithData:messageObj.media_relationship.lowRes];
                self.downloadBtn.hidden = NO;
                [self.downloadBtn setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
            }
            else if ([messageObj.msgDetails isEqualToString:YouTubeIdentifier])
            {
                self.downloadBtn.hidden = NO;
                [self.downloadBtn setImage:[UIImage imageNamed:@"youtube_btn.png"] forState:UIControlStateNormal];
                self.imageView.hidden = false;
                self.imageView.image =  [UIImage imageWithData:messageObj.media_relationship.lowRes];
            }
            else{
                
                self.imageView.image = [UIImage imageWithData:messageObj.media_relationship.lowRes];
                self.downloadBtn.hidden = NO;
                
            }
            
        }
        
    }
    else{
        if ([messageObj.msgDetails isEqualToString:YouTubeIdentifier])
        {
            NSString *youTubeLinkID = [Utility getYouTubeVideoID:messageObj.msgText];
            youTubeLinkID = [NSString stringWithFormat:@"https://img.youtube.com/vi/%@/mqdefault.jpg",youTubeLinkID];
            self.downloadBtn.hidden = NO;
            [self.downloadBtn setImage:[UIImage imageNamed:@"youtube_btn.png"] forState:UIControlStateNormal];
            
            
        }
        else{
            if(messageObj.media_relationship.url_lowRes){
                
                
            }
        }
    }
    self.timeLabel.text = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:([messageObj.timeFirstSent longLongValue]/1000)]];
    
    if([messageObj.tx_id isEqualToString:[SocketStream sharedSocketObject].userID]){
        
        // self.chatBoxImage.image = [UIImage imageNamed:@""];//white_chat_box.png
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
            
        } else {
            self.timeTriangleDistance.constant = 30;
            
            if([messageObj.ackType isEqualToString:@"ak_MSG_RECEIVED"])
                self.msgIcon.image = [UIImage imageNamed:@"message-undeliverd.png"];
            else if([messageObj.ackType isEqualToString:@"ak_MSG_DELIVERED"])
                self.msgIcon.image = [UIImage imageNamed:@"message-deliverd.png"];
            else if([messageObj.ackType isEqualToString:@"ak_MSG_READ"])
                self.msgIcon.image = [UIImage imageNamed:@"Message-opened.png"];
        }
    } else {
        
        [self.chatBoxImage setBackgroundColor: RGB(219,246,255)];
        self.triangle.image = [UIImage imageNamed:@""];//blue_chat_box_tri
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
        
        [self.triangle setBackgroundColor:RGB(219,246,255)];
        self.trailingConstant.constant = screenWidth-91;
        self.timeTriangleDistance.constant = TIME_LEADING_CONSTRAINT;
        self.msgIcon.image = nil;
    }
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
        self.mediaViewTopConstraint.constant = 17;
        self.memberNameLabel.text = ((VcardObject *)[[SocketStream sharedSocketObject] getCardByID:messageObj.tx_id]).creator_name;
    }
    else{
        self.mediaViewTopConstraint.constant = 7;
        self.memberNameLabel.text = @"";
    }
    
}
-(void)showIndicator{
    [self.indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    self.indicator.hidden = NO;
    self.downloadBtn.hidden = YES;
    [self.indicator startAnimating];
    
}


-(void)hideIndicatorOnSuccess:(BOOL)ifSuccess{
    
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
    self.downloadBtn.hidden = false;
    if (ifSuccess)
        [self.downloadBtn setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
    else
        [self.downloadBtn setImage:[UIImage imageNamed:@"download-icon.png"] forState:UIControlStateNormal];
    
    
}
-(void)creatorLabelTapped:(UITapGestureRecognizer *)recognizer{
    [self.delegate creatorLabelTapped:self.creatorID];
}

@end
