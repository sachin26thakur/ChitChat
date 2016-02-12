//
//  ViewController.m
//  CodersChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "SignUpViewController.h"
#import "Constants.h"
#import "LoginViewController.h"
#import "SelectLanguageViewController.h"

@interface SignUpViewController ()
@property (strong, nonatomic) IBOutlet UITextField *userFullName;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIPickerView *languagePickerVIew;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"languageScreenSegue" sender:self];
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:LOGIN_VIEW_CONTROLLER_SEGUE])
    {
        LoginViewController *loginVC = (LoginViewController *)segue.destinationViewController;
        
    }
    
    else if ([segue.identifier isEqualToString:@"languageScreenSegue"])
    {
        SelectLanguageViewController *languageVC = (SelectLanguageViewController *)segue.destinationViewController;
        
    }
}
@end
