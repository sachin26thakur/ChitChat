//
//  IndividualChatCell.h
//  ChitChat
//
//  Created by GlobalLogic on 13/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageObject.h"

#define TEXT_FONT_SIZE 13.0
#define EMOJI_FONT_SIZE 20.0
#define TEXT_FONT [UIFont fontWithName:@"SinkinSans-500Medium" size:TEXT_FONT_SIZE]
#define EMOJI_FONT [UIFont fontWithName:@"SinkinSans-500Medium" size:EMOJI_FONT_SIZE]
#define TIME_LEADING_CONSTRAINT -105.0


@protocol IndividualCellDelegate <NSObject>

-(void)playAudioForIndex:(NSInteger)rowIndex;
-(void)pauseAudioForIndex:(NSInteger)rowIndex;
-(void)creatorLabelTapped:(NSString *)creatorID;
-(void)reatorLabelTapped:(NSString *)creatorID;
-(void)downlaodEmojiImageForIndex:(NSInteger)rowIndex withID:(NSArray *)imageIDs;

@end

@interface IndividualChatCell : UICollectionViewCell

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatterMediumDate;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) id<IndividualCellDelegate> delegate;

-(void)setCellProperties:(ChatMessageObject *)messageObj;
-(void)setCellProperties:(ChatMessageObject *)messageObj setSelected:(BOOL)isSelected;
-(void)setCellProperties:(ChatMessageObject *)messageObj setSelected:(BOOL)isSelected fromGroupMember:(BOOL)isGrpMember;
-(void)setCellProperties:(ChatMessageObject *)messageObj setSelected:(BOOL)isSelected withTag:(NSInteger)tag ifPlaying:(BOOL)ifPlaying_;
-(void)setCellProperties:(ChatMessageObject *)messageObj setSelected:(BOOL)isSelected withTag:(NSInteger)tag maxTime:(NSInteger)maxTime_ currentTime:(NSInteger)currentTime_;
-(void)updateAudioSliderIsPlaying:(BOOL)isPlaying withMaxTime:(NSInteger)maxTime_ currentTime:(NSInteger)currentTime;
-(void)showIndicator;
-(void)hideIndicatorOnSuccess:(BOOL)ifSuccess;

@end

