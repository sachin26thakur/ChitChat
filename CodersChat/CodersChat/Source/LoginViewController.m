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
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([ChitchatUserDefault isUserLogginIn]) {
        [self gotoHomeScreen];
    }
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
        [ChitchatUserDefault setIsUserLoggin:YES];
        [ChitchatUserDefault setContactSynced:false];
        [ChitchatUserDefault setUserID:responce[@"respDetails"]];
        [ChitchatUserDefault setUserName:_userName.text];
        [ChitchatUserDefault setPassword:_password.text];
        
    } else {
        [appDelegate stopActivityIndicator];
    
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
