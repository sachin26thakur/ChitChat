//
//  ActivityIndicator+UIView.m
//  HackathoneDemo
//
//  Created by Amit Gupta on 08/02/16.
//  Copyright (c) 2016 GlobalLogic. All rights reserved.
//

#import "ActivityIndicator+UIView.h"

@implementation UIView(ActivityIndicator)

-(void)showLoading {
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
//    activityIndicatorView.center = self.center;
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicatorView.tag = INT32_MAX;
    [self addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
}

-(void)stopLoading {
    [self viewWithTag:INT32_MAX]?[[self viewWithTag:INT32_MAX] removeFromSuperview]: nil;
}

@end
