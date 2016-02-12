//
//  IndividualChatCell.m
//  ChitChat
//
//  Created by GlobalLogic on 13/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "IndividualChatCell.h"

@implementation IndividualChatCell

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)setCellProperties:(ChatMessageObject *)messageObj{
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM hh:mm"];
    
    self.dateFormatterMediumDate = [[NSDateFormatter alloc] init];
    [self.dateFormatterMediumDate setDateStyle:NSDateFormatterMediumStyle];
    
}


@end
