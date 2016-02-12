//
//  AppDelegate.h
//  CodersChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertDialogProgressView.h"

@class AppDelegate;

extern AppDelegate *appDelegate;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    AlertDialogProgressView *_alertDialogProgressView;

}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) NSString *latestDeviceToken;
//Methods
-(void)startActivityIndicator:(UIView *)view withText:(NSString *)text;
-(void)stopActivityIndicator;
-(void)showAlertwithselctor:(SEL)seletor anddelegate:(id)del andTitle:(NSString *)title;

@end

