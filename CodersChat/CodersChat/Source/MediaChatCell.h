//
//  MediaChatCell.h
//  ChitChat
//
//  Created by GlobalLogic on 13/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndividualChatCell.h"

@interface MediaChatCell : IndividualChatCell

@property (weak, nonatomic) IBOutlet UIImageView *triangle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *chatBoxImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeTriangleDistance;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgIconTrailingDistance;
@property (weak, nonatomic) IBOutlet UIImageView *msgIcon;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mediaViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mediaViewBottomContraint;
@property (weak, nonatomic) IBOutlet UIButton *viewBtn;

@property (weak, nonatomic) IBOutlet UILabel *nTimesLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;

@property (nonatomic,retain) UITapGestureRecognizer *creatorTapped;
@property (strong, nonatomic) NSString *creatorID;


@end

