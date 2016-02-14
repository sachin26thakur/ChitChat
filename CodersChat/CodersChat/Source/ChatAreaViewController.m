//
//  ChatAreaViewController.m
//  CodersChat
//
//  Created by Vishal Bhadade on 12/02/16.
//  Copyright (c) 2016 GlobalLogic. All rights reserved.
//

#import "ChatAreaViewController.h"
#import "FGTranslator.h"

@interface ChatAreaViewController ()

@end

@implementation ChatAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (FGTranslator *)translator {
    /*
     * using Bing Translate
     *
     * Note: The client id and secret here is very limited and is included for demo purposes only.
     * You must use your own credentials for production apps.
     */
    FGTranslator *translator = [[FGTranslator alloc] initWithBingAzureClientId:@"fgtranslator-demo" secret:@"GrsgBiUCKACMB+j2TVOJtRboyRT8Q9WQHBKJuMKIxsU="];
    
    // or use Google Translate
    
    // using Google Translate
    // translator = [[FGTranslator alloc] initWithGoogleAPIKey:@"your_google_key"];
    
    return translator;
}
-(void)translateChatString:(NSString *)chatString withSource:(NSString *)source andDestination:(NSString *)destination {
    
    [self.translator translateText:chatString withSource:source target:destination
                        completion:^(NSError *error, NSString *translated, NSString *sourceLanguage)
     {
         if (error)
         {
             
         }
         else
         {
             
         
             
         }
     }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
