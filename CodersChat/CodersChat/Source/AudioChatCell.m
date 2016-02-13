//
//  AudioChatCell.m
//  ChitChat
//
//  Created by GlobalLogic on 13/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "AudioChatCell.h"
#import "ChatMessageObject.h"
#import "MediaObject.h"
#import "SocketStream.h"
#import "Utility.h"


@implementation AudioChatCell

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
    
    if([messageObj.msgType isEqualToString:[Utility MessageTypeToString:mg_SEND_BROADCAST]]){
        //  self.textViewBottomConstraint.constant = -35;
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
        //   self.textViewBottomConstraint.constant = -8;
        
        self.nTimesLbl.hidden = true;
        self.dateLbl.hidden = true;
        self.viewBtn.hidden = true;
        self.creatorLabel.hidden = true;
        
        
        
    }
    
    self.indicator.hidden = YES;
    
    if(messageObj.media_relationship.highRes){
        
        self.playBtn.hidden = NO;
        [self.playBtn setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
    }
    
    else{
        
        self.playBtn.hidden = NO;
        [self.playBtn setImage:[UIImage imageNamed:@"download-icon.png"] forState:UIControlStateNormal];
        
    }
    
    self.creatorLabel.userInteractionEnabled = true;
    self.creatorTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(creatorLabelTapped:)];
    [self.creatorLabel addGestureRecognizer:self.creatorTapped];
    
    self.timeLabel.text = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:([messageObj.timeFirstSent longLongValue]/1000)]];
    
    VcardObject *cardObj = (VcardObject *)[[SocketStream sharedSocketObject] getCardByID:messageObj.tx_id];
    
    if(cardObj.image_relationship)
    {
        if(cardObj.image_relationship.lowRes || cardObj.image_relationship.highRes)
        {
            
            self.userImageView.image = [UIImage imageWithData:(cardObj.image_relationship.highRes) ? : cardObj.image_relationship.lowRes];
            self.userImageView.layer.masksToBounds = NO;
            self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
            self.userImageView.clipsToBounds = YES;
            
            
        }
        
        
    }
    else{
        if(cd_PRIVATE_GROUP == [Utility CardTypeFromString:((VcardObject *)[[SocketStream sharedSocketObject] getCardByID:messageObj.tx_id]).cardType]) {
            self.userImageView.image = [UIImage imageNamed:@"DefaultGroup"];
        } else
            self.userImageView.image = [UIImage imageNamed:@"DefaultUser"];
        
        //  self.userImageView.image = [UIImage imageNamed:@"smiley1.png"];
        self.userImageView.clipsToBounds = NO;
        self.userImageView.layer.cornerRadius = 0;
    }
    
    if([messageObj.tx_id isEqualToString:[SocketStream sharedSocketObject].userID]){
        
        
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
        
        //self.chatBoxImage.image = [UIImage imageNamed:@""];//blue_chat_box.png
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
}

-(void)setCellProperties:(ChatMessageObject *)messageObj setSelected:(BOOL)isSelected{
    
    [self setCellProperties:messageObj];
    self.memberNameLabel.text = @"";
    
    if(isSelected)
        self.selectionView.hidden = NO;
    else
        self.selectionView.hidden = YES;
    
}
-(void)setCellProperties:(ChatMessageObject *)messageObj setSelected:(BOOL)isSelected withTag:(NSInteger)tag ifPlaying:(BOOL)ifPlaying_{
    [self setCellProperties:messageObj setSelected:isSelected];
    self.playBtn.tag = tag;
    if(ifPlaying_)
        [self.playBtn setImage:[UIImage imageNamed:@"stop-button.png"] forState:UIControlStateNormal];
    else{
        [self.playBtn setImage:[UIImage imageNamed:@"btn-play.png"] forState:UIControlStateNormal];
        self.audioTimer.text = @"00:00";
        self.audioSlider.maximumValue = 0;
        self.audioSlider.value = 0;
        
    }
    
}

-(void)setCellProperties:(ChatMessageObject *)messageObj setSelected:(BOOL)isSelected withTag:(NSInteger)tag maxTime:(NSInteger)maxTime_ currentTime:(NSInteger)currentTime_{
    
    [self setCellProperties:messageObj setSelected:isSelected withTag:tag ifPlaying:true];
    self.audioTimer.text = [NSString stringWithFormat:@"%d:%02d", (int)maxTime_ / 60, (int)maxTime_ % 60, nil];
    self.audioSlider.maximumValue = maxTime_;
    self.audioSlider.value = currentTime_;
    
    
    
}

-(void)updateAudioSliderIsPlaying:(BOOL)isPlaying withMaxTime:(NSInteger)maxTime_ currentTime:(NSInteger)currentTime
{
    
    
    if(isPlaying){
        [self.playBtn setImage:[UIImage imageNamed:@"stop-button.png"] forState:UIControlStateNormal];
        self.audioTimer.text = [NSString stringWithFormat:@"%d:%02d", (int)maxTime_ / 60, (int)maxTime_ % 60, nil];
        self.audioSlider.maximumValue = maxTime_;
        self.audioSlider.value = currentTime;
    }
    else{
        [self.playBtn setImage:[UIImage imageNamed:@"btn-play.png"] forState:UIControlStateNormal];
        self.audioTimer.text = @"00:00";
        self.audioSlider.maximumValue = 0;
        self.audioSlider.value = 0;
        
    }
    
    
}

-(void)setCellProperties:(ChatMessageObject *)messageObj setSelected:(BOOL)isSelected fromGroupMember:(BOOL)isGrpMember{
    
    [self setCellProperties:messageObj setSelected:isSelected];
    
    
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
        [self.playBtn setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
    else
        [self.playBtn setImage:[UIImage imageNamed:@"download-icon.png"] forState:UIControlStateNormal];
    
}

- (IBAction)playAudio:(UIButton *)sender {
    
    if([self.delegate respondsToSelector:@selector(playAudioForIndex:)]){
        [self.delegate playAudioForIndex:sender.tag];
    }
}
-(void)creatorLabelTapped:(UITapGestureRecognizer *)recognizer{
    [self.delegate creatorLabelTapped:self.creatorID];
}


@end
