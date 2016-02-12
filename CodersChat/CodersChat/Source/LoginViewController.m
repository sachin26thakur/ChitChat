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

#import "ChitchatUserDefault.h"
#import "ChitChatFactoryContorller.h"
#import "ChatListViewController.h"

#import "WebserviceHandler.h"
#import "AppDelegate.h"

#import "SelectLanguageViewController.h"
#import "SignUpViewController.h"





@interface LoginViewController ()<WebServiceHandlerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signInButtonClicked:(id)sender
{


    [self callServiceForDashboard];


}

// call web services
-(void)callServiceForDashboard
{

        WebserviceHandler *objWebServiceHandler = [[WebserviceHandler alloc]init];
        objWebServiceHandler.delegate = self;

        
        //for ActivityIndicator start
        [appDelegate startActivityIndicator:self.view withText:Progressing];
        
        //for AFNetworking request
        [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getLoginRequestWithUsername:@"himanshi" andPassword:@"user123"]  withMethod:@"" withUrl:@"" forKey:@""];

//else  {
//        ShowAlert(AlertTitle, NSLocalizedString(@"Please check internet connection", nil));
//    }
}


#pragma mark WebService Delegate
-(void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)responce
{
    //  //NSLog(@"dicResponce:-%@",responce);
    
    //check service responce
    if([responce[@"oprSuccess"] integerValue]){
        
            if (YES || [ChitchatUserDefault selectedUserLanguage]) {
                // go to home screen
        
                ChatListViewController *chatListVc = (ChatListViewController*)[ChitChatFactoryContorller viewControllerForType:ViewControllerTypeChitChatList];
        
                [self.navigationController pushViewController:chatListVc animated:YES];
 
            }else{
                //go for select languge screen
            }

        
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
       // ShowAlert(AppName,NSLocalizedString(@"Invalid login credentials \n Please try again!", nil));
        [appDelegate stopActivityIndicator];
        
        SelectLanguageViewController *selectLngVc = (SelectLanguageViewController*)[ChitChatFactoryContorller viewControllerForType:ViewControllerTypeSelectLanguage];
        [self.navigationController pushViewController:selectLngVc animated:YES];
    }
}

-(void) webServiceHandler:(WebserviceHandler *)webHandler requestFailedWithError:(NSError *)error
{
    
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

@end
