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
#import "Utility.h"

@interface SignUpViewController ()
@property (strong, nonatomic) IBOutlet UITextField *userFullName;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;

@property (strong, nonatomic) IBOutlet UIPickerView *languagePickerVIew;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIButton *previousBtn;

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
    if ([self validateAllFields]) {
        [self performSegueWithIdentifier:@"languageScreenSegue" sender:self];
    }
}

-(BOOL)validateAllFields {
    BOOL isValidate = YES;
    if (![Utility isValidName:self.userFullName.text]) {
        [self showAlertWithTitle:@"Name" andDescription:@"Please enter valid name."];
        isValidate = NO;
    }
    else if (![Utility isValidName:self.phoneNumber.text]) {
        [self showAlertWithTitle:@"Phone Number" andDescription:@"Please enter valid phone number."];
        isValidate = NO;

    }
    else if (![Utility isValidName:self.userName.text]) {
        [self showAlertWithTitle:@"User Number" andDescription:@"Please enter valid user name."];
        isValidate = NO;

    }
    else if (![Utility isValidName:self.password.text]) {
        [self showAlertWithTitle:@"User Number" andDescription:@"Please enter your password."];
        isValidate = NO;

    }
    else if (![Utility isValidName:self.confirmPassword.text]) {
        [self showAlertWithTitle:@"User Number" andDescription:@"Please enter confirm password."];
        isValidate = NO;

    }
    else if (![self.password.text isEqualToString:self.confirmPassword.text]){
        [self showAlertWithTitle:@"Confirm Password" andDescription:@"Password and confirm password should be same."];
        isValidate = NO;

    }
    return isValidate;
}
-(void)showAlertWithTitle:(NSString *)title andDescription:(NSString *)description {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:description delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}


- (IBAction)previousButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
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
