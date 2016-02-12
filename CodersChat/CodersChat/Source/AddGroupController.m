//
//  AddGroupController.m
//  ChitChat
//
//  Created by GlobalLogic on 13/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "AddGroupController.h"
#import "WebserviceHandler.h"
#import "Constants.h"
#import "Utility.h"
#import "SocketStream.h"
#import "ChatListCell.h"
#import "RequestHelper.h"

@interface AddGroupController ()<WebServiceHandlerDelegate>{
    BOOL isAllChecked;
    NSMutableIndexSet *selectedUsers;
    NSMutableSet *selectedUsersID;
    NSDateFormatter *dateFormatter;
    NSArray *cardsLists;
    NSDictionary *privateGroupDictResponse;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *grpName;

@end

@implementation AddGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedUsers = [NSMutableIndexSet indexSet];
    selectedUsersID = [NSMutableSet set];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
   
   cardsLists = [[SocketStream sharedSocketObject] getVCardsToAdd:true withGroupID:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [cardsLists count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddGroupCellIdentifier" forIndexPath:indexPath];
    // [cell setCellProperties:cardsLists[indexPath.row] setSelected:[selectedUsers containsIndex:indexPath.item]];
    [cell setCellProperties:cardsLists[indexPath.row] setSelected:[selectedUsersID containsObject:((VcardObject *)cardsLists[indexPath.row]).id_]];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language rangeOfString:@"ar"].location != NSNotFound) {
        [cell.descriptionLabel setTextAlignment:NSTextAlignmentRight];
        [cell.nameLabel setTextAlignment:NSTextAlignmentRight];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([selectedUsersID containsObject:((VcardObject *)cardsLists[indexPath.row]).id_])
    {
        [selectedUsersID removeObject:((VcardObject *)cardsLists[indexPath.row]).id_];
        
    }
    else{
        [selectedUsersID addObject:((VcardObject *)cardsLists[indexPath.row]).id_];
    }
    
    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexPath.item inSection:0]]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(screenWidth, 75);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneSelected:(UIButton *)sender {
    
    if(![selectedUsersID count]){
        //ShowAlertNative(AppName,NSLocalizedString(@"Please select at least one friend or group.", nil));
    }
    else{
        [self callServiceForGroupCreation];
    }

    
}
- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


// call web services
-(void)callServiceForGroupCreation
{
    
    WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
    objWebServiceHandler.delegate = self;
    
    //for ActivityIndicator start
    [appDelegate startActivityIndicator:self.view withText:Progressing];
    
    NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"SELF.id_ IN %@",[selectedUsersID allObjects]];
    NSArray *members = [[cardsLists filteredArrayUsingPredicate:idPredicate] valueForKeyPath:@"id_"];
    
    //for AFNetworking request
    [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getPrivateGroupCreationRequest:members grpName:self.grpName.text grpImage:nil]  withMethod:@"" withUrl:@"" forKey:@""];
    
}

-(void)callServiceToGetAddedGroupVCARD:(NSString *)grpIDs{
    
    WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
    objWebServiceHandler.delegate = self;
    
    //for AFNetworking request
    [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getGroupVCardRequest:grpIDs forHighRes:true] withMethod:@"" withUrl:@"" forKey:@""];
    
}


-(void)callServiceToGetAddedPrivateGroup:(NSArray*)grpIDs{
    
    WebserviceHandler *objWebServiceHandler=[[WebserviceHandler alloc]init];
    objWebServiceHandler.delegate = self;
    
    //for AFNetworking request
    [objWebServiceHandler AFNcallThePassedURLASynchronouslyWithRequest:[RequestHelper getPrivateGroupRequest:grpIDs[0]] withMethod:@"" withUrl:@"" forKey:@""];
    
}

-(void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponce
{
    //NSLog(@"dicResponce:-%@",dicResponce);
    
    //check resvice responce
    if([dicResponce[@"oprSuccess"] integerValue]){
        
        if([dicResponce[@"respDetails"] objectForKey:@"objType"] && [[dicResponce[@"respDetails"] objectForKey:@"objType"] isEqualToString:@"oj_VCARD"]){
            
            [DatabaseHelper saveModel:@"VcardObject" FromResponseDict:dicResponce[@"respDetails"]];
            [DatabaseHelper saveModel:@"PrivateGroupObject" FromResponseDict:privateGroupDictResponse];
            
            [appDelegate stopActivityIndicator];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if([dicResponce[@"respDetails"] objectForKey:@"objType"] && [[dicResponce[@"respDetails"] objectForKey:@"objType"] isEqualToString:@"oj_PRIVATE_GROUP"]){
            
            privateGroupDictResponse = dicResponce[@"respDetails"];
            [self callServiceToGetAddedGroupVCARD:dicResponce[@"respDetails"][@"_id"]];
            
            
        }
        else{
            [appDelegate stopActivityIndicator];
            //ShowAlert(AppName,@"Failed in creating group. Please try again!");
            
        }
        
    }else{
        [appDelegate stopActivityIndicator];
        
       // ShowAlert(AppName,@"Failed in creating group. Please try again!");
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

@end
