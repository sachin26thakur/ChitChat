//
//  ChatListCell.m
//  ChitChat
//
//  Created by GlobalLogic on 13/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "ChatListCell.h"
#import "ChatMessageObject.h"
#import "MediaObject.h"
#import "Utility.h"
#import "Constants.h"
#import "SocketStream.h"

static const float animationTime = 0.25f;

@interface ChatListCell ()
{
    UITapGestureRecognizer *tapOnRemove;
    UITapGestureRecognizer *tapOnAdmin;
    
}

@end

@implementation ChatListCell

- (void)awakeFromNib{
    // Initialization code
    [self initialiseCell];
}

-(void)initialiseCell{
    
    tapOnRemove = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMember:)];
    tapOnRemove.numberOfTapsRequired = 1;
    [self.removeAdminView addGestureRecognizer:tapOnRemove];
    
    tapOnAdmin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeAdmin:)];
    tapOnAdmin.numberOfTapsRequired = 1;
    [self.makeAdminView addGestureRecognizer:tapOnAdmin];
    
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.descriptionLabel setPreferredMaxLayoutWidth:200.0];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

- (NSInteger) getUnReadMessageCount :(VcardObject *) obj {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.ackType = nil || SELF.ackType = %@ || SELF.ackType = %@) AND SELF.tx_id != %@ AND self.id_ = ",[Utility AckTypeToString:ak_MSG_RECEIVED],[Utility AckTypeToString:ak_MSG_DELIVERED],[SocketStream sharedSocketObject].userID,obj.id_];
    
    NSArray *messages = [[SocketStream sharedSocketObject].chatMessagesData filteredArrayUsingPredicate:predicate];
    
    //        for (ChatMessageObject *chatMessage in messages) {
    //            [[SocketStream sharedSocketObject] sendAcknowledgement:[chatMessage getReadAcknowledgement]];
    //            chatMessage.ackType = [Utility AckTypeToString:ak_MSG_READ];
    //            [DatabaseHelper saveManagedContext];
    //        }
    //  }
    return messages.count;
}


-(void)setCellProperties:(VcardObject *)cardObj{
    
    
    if (![cardObj.unReadMessageCount isEqualToString:@"0"]) {
        [self.messageCountBtn setHidden:NO];
        [self.messageCountBtn setTitle:cardObj.unReadMessageCount forState:UIControlStateNormal];
    } else {
        [self.messageCountBtn setHidden:YES];
    }
    
    self.nameLabel.text = cardObj.name;
    self.cellSliderView.hidden = true;
    self.cardTypeLabel.text = [self getCharFromCardType:cardObj.cardType];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //paragraphStyle.headIndent = 0; // <--- indention if you need it
    //paragraphStyle.firstLineHeadIndent = 15;
    paragraphStyle.lineSpacing = 4; // <--- magic line spacing here!
    
    NSDictionary *attrsDictionary =
    @{ NSFontAttributeName: [UIFont fontWithName:@"SinkinSans-500Medium" size:12.0],
       NSParagraphStyleAttributeName: paragraphStyle};
    
    self.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:(cardObj.lastMessage)? :@"" attributes:attrsDictionary];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language rangeOfString:@"ar"].location != NSNotFound) {
        [self.descriptionLabel setTextAlignment:NSTextAlignmentLeft];
    }
    
    self.userImage.image = nil;
    if(cardObj.image_relationship && (cardObj.image_relationship.thumbnailImage || cardObj.image_relationship.lowRes))
    {
        self.userImage.image = [UIImage imageWithData:(cardObj.image_relationship.lowRes) ? cardObj.image_relationship.lowRes:cardObj.image_relationship.thumbnailImage];
        self.userImage.layer.masksToBounds = NO;
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2;
        self.userImage.clipsToBounds = YES;
    }
    else{
        
        if(cd_PRIVATE_GROUP == [Utility CardTypeFromString:cardObj.cardType]) {
            self.userImage.image = [UIImage imageNamed:@"profile_placeholder"];
        } else
            self.userImage.image = [UIImage imageNamed:@"profile_placeholder"];
        
        self.userImage.clipsToBounds = NO;
        self.userImage.layer.cornerRadius = 0;
        
        if(cardObj.image_relationship.url_lowRes)
        {
            
           
            
        }
    }
    
    
    [self.userImage setContentMode:UIViewContentModeScaleAspectFit];
    //[self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.userImage.image = nil;
}
-(void)setCellProperties:(VcardObject *)cardObj setSelected:(BOOL)isSelected{
    
    [self setCellProperties:cardObj];
    
    if(isSelected)
        self.checkBoxImage.image = [UIImage imageNamed:@"icon-checked.png"];
    else
        self.checkBoxImage.image = [UIImage imageNamed:@"icon-unchecked.png"];
}


-(void)setSliderCellProperties:(VcardObject *)cardObj ifSlideAllowed:(BOOL)slideAllowed{
    
    [self setCellProperties:cardObj];
    
    //set share slider color
    self.cellSliderView.alpha = 1.0f;
    self.cellSliderView.hidden = true;
    self.cellSliderView.backgroundColor = [UIColor whiteColor];
    self.cellMainView.backgroundColor = [UIColor whiteColor];
    self.makeAdminBtn.tag = self.tag;
    self.removeMember.tag = self.tag;
    if(slideAllowed)
    {
        //add swipe gesture for left right to show/hide share view
        //UISwipeGestureRecognizer *recognizer;
        self.recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRightToLeft:)];
        [self.recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self.contentView addGestureRecognizer:self.recognizer];
        
        self.recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeftToRight:)];
        [self.recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self.contentView addGestureRecognizer:self.recognizer];
    }
    else
    {
        [self.contentView removeGestureRecognizer:self.recognizer];
    }
    
    
    
    
}

-(void)setCellAlphaProperties:(float)alpha{
    self.acceptBtn.alpha = alpha;
    self.userImage.alpha = alpha;
    self.nameLabel.alpha = alpha;
    self.descriptionLabel.alpha = alpha;
    
}

-(void)hideSliderShareCell{
    [self hideSliderShareView];
}

#pragma mark    -   UISwipeGesture Event

-(void)handleSwipeFromLeftToRight:(UISwipeGestureRecognizer *)swipeGesture{
    
    //hide swipe gesture with animation
    self.cellSliderView.hidden = NO;
    CGRect viewFrame = self.bounds;
    CGRect sliderFrame = [self.cellMainView bounds];
    
    // self.cellSliderView.frame = CGRectMake(viewFrame.size.width, 0, sliderFrame.size.width, sliderFrame.size.height);
    
    [UIView animateWithDuration:animationTime animations:^{
        self.cellMainView.frame = CGRectMake(-253, 0, sliderFrame.size.width, sliderFrame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1f animations:^{
            // self.cellSliderView.frame = CGRectMake(viewFrame.size.width-sliderFrame.size.width, 0, sliderFrame.size.width, sliderFrame.size.height);
        }];
        
    }];
    
    //return cell index tag/number
    swipeGesture.view.tag = self.tag;
    
    
    //return delegate to access outside the class
    [self.delegate handleSwipeFromLeftToRight:swipeGesture];
    
}
-(void)handleSwipeFromRightToLeft:(UISwipeGestureRecognizer *)swipeGesture{
    
    //return cell index tag/number
    swipeGesture.view.tag = self.tag;
    
    //hide slider
    [self hideSliderShareView];
    
    //return delegate to access outside the class
    [self.delegate handleSwipeFromRightToLeft:swipeGesture];
}

-(void)hideSliderShareView{
    
    //hide slider with animation
    CGRect viewFrame = self.bounds;
    CGRect sliderFrame = [self.cellSliderView bounds];
    float xPoint = viewFrame.size.width-sliderFrame.size.width;
    self.cellMainView.frame = CGRectMake(-253, 0, sliderFrame.size.width, sliderFrame.size.height);
    [UIView animateWithDuration:animationTime animations:^{
        self.cellMainView.frame = CGRectMake(0, 0, sliderFrame.size.width, sliderFrame.size.height);
    } completion:^(BOOL finished) {
        self.cellSliderView.hidden = YES;
    }];
}

-(NSString *)cellDescription:(NSString *)desc{
    if([desc isEqualToString:@"ma_IMAGE"])
        return NSLocalizedString(@"Image", nil);
    else if([desc isEqualToString:@"ma_VIDEO"])
        return NSLocalizedString(@"Video", nil);
    else if([desc isEqualToString:@"ma_AUDIO"])
        return NSLocalizedString(@"Audio", nil);
    else
        return desc;
}

-(void)setImageWithChatObject:(ChatMessageObject *)chatMes{
    
    
    
}

-(NSString *)getCharFromCardType:(NSString *)type{
    if([Utility CardTypeFromString:type] == cd_AVATAR)
        return @"A";
    else if([Utility CardTypeFromString:type] == cd_USER)
        return @"M";
    else if([Utility CardTypeFromString:type] == cd_PRIVATE_GROUP)
        return @"G";
    else if([Utility CardTypeFromString:type] == cd_TAG)
        return @"T";
    else if([Utility CardTypeFromString:type] == cd_WALL)
        return @"W";
    else
        return nil;
}

#pragma mark    -   Recognizer ActionEvent

//return delgate to access outside class
-(void)removeMember:(UITapGestureRecognizer *)recognizer{
    [self.delegate removeMember:self];
}
-(void)makeAdmin:(UITapGestureRecognizer *)recognizer{
    [self.delegate makeAdmin:self];
}


@end
