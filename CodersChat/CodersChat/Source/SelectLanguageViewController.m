//
//  SelectLanguageViewController.m
//  CodersChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "SelectLanguageViewController.h"
#import "ActivityIndicator+UIView.h"
#import "ChitchatUserDefault.h"
#import "ChatListViewController.h"
#import "ChitChatFactoryContorller.h"
#import "ChatAreaViewController.h"
#import "WebserviceHandler.h"
#import "RequestHelper.h"
#import "SyncUser.h"
#import "SignUpViewController.h"



@interface SelectLanguageViewController ()<WebServiceHandlerDelegate,UserSyncDelegate>
@property (nonatomic, strong) NSArray *langugeData;
@end

@implementation SelectLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.langugeData = [ChitchatUserDefault languageList];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// call web services
-(void)callServiceForSignUp
{
    WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
    objWebServiceHandler.delegate = self;
    
    //for ActivityIndicator start
    [appDelegate startActivityIndicator:self.view withText:Progressing];

    NSMutableString *userName = [self.allDataDict[@"userName"] mutableCopy];
    if (![self.allDataDict[@"userName"] hasPrefix:@"@"])
    {
        userName = [NSMutableString stringWithFormat:@"\\@%@",self.allDataDict[@"userName"]];
        [userName replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getSignUpRequestWithName:self.allDataDict[@"fullName"] number:self.allDataDict[@"phoneNumber"] uname:userName pass:self.allDataDict[@"password"]] withMethod:@"" withUrl:@"" forKey:@""];
    
}

-(void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponce
{
    //check resvice responce
    if([dicResponce[@"oprSuccess"] integerValue]){
       
        [ChitchatUserDefault setIsUserLoggin:YES];
        [ChitchatUserDefault setContactSynced:false];
        [ChitchatUserDefault setUserID:dicResponce[@"respDetails"]];
        [ChitchatUserDefault setUserName:self.allDataDict[@"userName"]];
        [ChitchatUserDefault setPassword:self.allDataDict[@"password"]];

     
        
        [appDelegate startActivityIndicator:self.view withText:NSLocalizedString(@"Synchronizing Contacts", nil)];
        SyncUser *syncUser = [[SyncUser alloc] init];
        syncUser.delegate =self;
        [syncUser startUserSyncing:YES];
        

        
    } else {
        [appDelegate stopActivityIndicator];
       // ShowAlert(AppName,dicResponce[@"respDetails"]);
    }
}


- (void)userSyncFinished:(BOOL)ifSuccess{
    
    [appDelegate stopActivityIndicator];
    [self gotoHomeScreen];
    
}


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

-(void) webServiceHandler:(WebserviceHandler *)webHandler requestFailedWithError:(NSError *)error
{
    
    //NSLog(@"dicResponce:-%@",[error description]);
    [appDelegate stopActivityIndicator];
    //remove it after WS call
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.langugeData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    // TableCell created
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *languge = [self.langugeData objectAtIndex:indexPath.row];
    
    NSString *selectedLanguage = [ChitchatUserDefault selectedUserLanguage];
    
    if ([languge isEqualToString:selectedLanguage]) {
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    

    
    [cell.textLabel setText:[self.langugeData objectAtIndex:indexPath.row]];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [ChitchatUserDefault setSelectedUserLanguage:[self.langugeData objectAtIndex:indexPath.row]];

    
    __block BOOL goBack = NO;
    
    NSArray *viewControllers = [self.navigationController viewControllers];

    [viewControllers enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * stop) {
        if ([obj isKindOfClass:[ChatAreaViewController class] ]) {
            goBack = YES;
        }
    }];
    
    if (goBack) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFERESH_CHAT_FOR_LANGUAGE_SELECTION" object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    __block BOOL isFromSignUp = NO;
    
    
    [viewControllers enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * stop) {
        if ([obj isKindOfClass:[SignUpViewController class] ]) {
            isFromSignUp = YES;
        }
    }];
    
    if (isFromSignUp) {
        [self callServiceForSignUp];

    }
    else
        [self gotoHomeScreen];
    
//    ChatListViewController *chatListVc = (ChatListViewController*)[ChitChatFactoryContorller viewControllerForType:ViewControllerTypeChitChatList];
//    
//    [self.navigationController pushViewController:chatListVc animated:YES];
//    
//    [tableView reloadData];
}


@end







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


