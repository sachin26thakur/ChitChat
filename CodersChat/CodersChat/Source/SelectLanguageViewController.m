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



@interface SelectLanguageViewController ()
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


- (IBAction)finishAction:(UIButton *)sender
{
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
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    
    ChatListViewController *chatListVc = (ChatListViewController*)[ChitChatFactoryContorller viewControllerForType:ViewControllerTypeChitChatList];
    
    [self.navigationController pushViewController:chatListVc animated:YES];
    
    [tableView reloadData];
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


