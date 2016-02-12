//
//  ChatListCell.h
//  ChitChat
//
//  Created by GlobalLogic on 13/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VcardObject.h"

@interface ChatListCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImage;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *adminBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTrailing;
@property (weak, nonatomic) IBOutlet UIButton *edtMemberBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageCountBtn;

@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIView *cellMainView;
@property (nonatomic) BOOL isCellForGroup;

@property (weak, nonatomic) IBOutlet UIView *cellSliderView;
@property (nonatomic,retain)UISwipeGestureRecognizer *recognizer;
@property (weak, nonatomic) IBOutlet UIButton *makeAdminBtn;
@property (weak, nonatomic) IBOutlet UIButton *removeMember;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIView *makeAdminView;
@property (weak, nonatomic) IBOutlet UIView *removeAdminView;

//pass reference delegate
@property (nonatomic, assign) id delegate;

-(void)setCellProperties:(VcardObject *)cardObj;
-(void)setCellProperties:(VcardObject *)cardObj setSelected:(BOOL)isSelected;
-(void)setSliderCellProperties:(VcardObject *)cardObj ifSlideAllowed:(BOOL)slideAllowed;
-(void)setCellAlphaProperties:(float)alpha;
-(void)hideSliderShareCell;
@end
