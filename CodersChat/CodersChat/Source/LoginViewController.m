//
//  LoginViewController.m
//  CodersChat
//
//  Created by Vishal Bhadade on 12/02/16.
//  Copyright (c) 2016 GlobalLogic. All rights reserved.
//

#import "LoginViewController.h"

#import "RequestHelper.h"
#import "Constants.h"
#import "Utility.h"

#import "ChitchatUserDefault.h"
#import "ChitChatFactoryContorller.h"
#import "ChatListViewController.h"

#import "WebserviceHandler.h"
#import "AppDelegate.h"

#import "SelectLanguageViewController.h"
#import "SignUpViewController.h"
#import "SyncUser.h"





@interface LoginViewController ()
<
  WebServiceHandlerDelegate,
  UITextFieldDelegate,
  UIAlertViewDelegate
>
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;

@property (strong, nonatomic) NSString *userNameValue;
@property (strong, nonatomic) NSString *passwordValue;
@property (nonatomic) BOOL signInPressed;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if ([ChitchatUserDefault isUserLogginIn]) {
//        [self gotoHomeScreen];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag == 1) {
        [_password becomeFirstResponder];
    }
    else if (textField == _password) {
        [textField resignFirstResponder];
    }
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.userName)
    {
        NSMutableString *userNameString = [textField.text mutableCopy];
        if ([userNameString length])
        {
            if (![textField.text hasPrefix:@"@"])
            {
                userNameString = [NSMutableString stringWithFormat:@"\\@%@",textField.text];
                [userNameString replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
            }
            self.userNameValue = userNameString;
        }
        
    }
    else if (textField == self.password)
    {
        if ([textField.text length])
        {
            self.passwordValue = [textField.text lowercaseString];
        }
        
    }
    if(_signInPressed){
    
    if (![self.userNameValue length])
    {
        [self showAlertVieWithTitle:@"Alert" message:@"Please enter user name" cancelButtonTitle:@""];
    }
    else if (![self.passwordValue length])
    {
        [self showAlertVieWithTitle:@"Alert" message:@"Please enter password" cancelButtonTitle:@""];
    }
    else
    {
        [self callServiceForDashboard];
    }
    }
}

- (void)showAlertVieWithTitle:(NSString *)aTitle message:(NSString *)aMessage cancelButtonTitle:(NSString *)cTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:aTitle message:aMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0://Cancel
        {
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
            break;
        case 1://OK
        {
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
            break;
        default:
            break;
    }
}

- (IBAction)signInButtonClicked:(id)sender
{
    _signInPressed = true;
    if ([self.userName isFirstResponder])
    {
        [self.userName resignFirstResponder];
    }
    else if ([self.password isFirstResponder])
    {
        [self.password resignFirstResponder];
    }
    else{
        
        if (![self.userNameValue length])
        {
            [self showAlertVieWithTitle:@"Alert" message:@"Please enter user name" cancelButtonTitle:@""];
        }
        else if (![self.passwordValue length])
        {
            [self showAlertVieWithTitle:@"Alert" message:@"Please enter password" cancelButtonTitle:@""];
        }
        else
            NSLog(@"");
        {
            [self callServiceForDashboard];
        }
    }
    
    
    
}

// call web services
-(void)callServiceForDashboard
{
        WebserviceHandler *objWebServiceHandler = [[WebserviceHandler alloc]init];
        objWebServiceHandler.delegate = self;
    
        //for ActivityIndicator start
        [appDelegate startActivityIndicator:self.view withText:Progressing];
        
        //for AFNetworking request
        [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getLoginRequestWithUsername:self.userNameValue andPassword:self.passwordValue]  withMethod:@"" withUrl:@"" forKey:@""];

//else  {
//        ShowAlert(AlertTitle, NSLocalizedString(@"Please check internet connection", nil));
//    }
}


#pragma mark WebService Delegate
-(void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)responce
{
    //  //NSLog(@"dicResponce:-%@",responce);
    
    _signInPressed = false;

    //check service responce
    if([responce[@"oprSuccess"] integerValue]){
        [ChitchatUserDefault setIsUserLoggin:YES];
        [ChitchatUserDefault setContactSynced:false];
        [ChitchatUserDefault setUserID:responce[@"respDetails"]];
        [ChitchatUserDefault setUserName:_userName.text];
        [ChitchatUserDefault setPassword:_password.text];
        
        [appDelegate startActivityIndicator:self.view withText:NSLocalizedString(@"Synchronizing Contacts", nil)];
        SyncUser *syncUser = [[SyncUser alloc] init];
        syncUser.delegate =self;
        [syncUser startUserSyncing:YES];
        
        
//        NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
//        [userdefaults setObject:_txtUsername.text.lowercaseString forKey:UserName];
//        [userdefaults setObject:_txtPassword.text forKey:UserPass];
//        [userdefaults setObject:responce[@"respDetails"] forKey:UserID];
//        [userdefaults setBool:false forKey:@"contactSynced"];
//        [userdefaults setBool:true forKey:@"userLoggedIn"];
//        
//        [userdefaults synchronize];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AlertTitle message:NSLocalizedString(@"We need to upload phone numbers only (no names) from your address book to our servers to connect you with friends already using Zargow. We will not share or use that information without your approval.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Decline", nil) otherButtonTitles:NSLocalizedString(@"Accept", nil), nil];
//        alert.delegate =self;
//        [alert show];
        
    } else {
        [appDelegate stopActivityIndicator];
    
    }
}

-(void) webServiceHandler:(WebserviceHandler *)webHandler requestFailedWithError:(NSError *)error
{
    
    _signInPressed = false;

    //NSLog(@"dicResponce:-%@",[error description]);
    [appDelegate stopActivityIndicator];
    //remove it after WS call
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)signUpPressed:(UIButton *)sender {
    
    SignUpViewController *chatListVc = (SignUpViewController*)[ChitChatFactoryContorller viewControllerForType:ViewControllerTypeSignUp];
    
    [self.navigationController pushViewController:chatListVc animated:YES];
}

- (void)userSyncFinished:(BOOL)ifSuccess{
    
    [appDelegate stopActivityIndicator];
    [self gotoHomeScreen];

}


#pragma mark -

- (void)gotoHomeScreen{
    
    if ([ChitchatUserDefault selectedUserLanguage]) {
        // go to home screen
        
        ChatListViewController *chatListVc = (ChatListViewController*)[ChitChatFactoryContorller viewControllerForType:ViewControllerTypeChitChatList];
        [self.navigationController pushViewController:chatListVc animated:YES];
    }else{
        //go for select languge screen
        SelectLanguageViewController *selectLngVc = (SelectLanguageViewController*)[ChitChatFactoryContorller viewControllerForType:ViewControllerTypeSelectLanguage];
        [self.navigationController pushViewController:selectLngVc animated:YES];
    }
}


@end
