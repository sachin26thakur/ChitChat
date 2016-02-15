//
//  WebserviceHandler.m
//  MedlinxPatient
//
//  Created by Vandana Singh on 08/5/14.
//  Copyright (c) 2013 Vandana Singh. All rights reserved.
//

#import "WebserviceHandler.h"
#import "AFHTTPRequestOperation.h"
#import "JSONParser.h"
#import "Constants.h"
#import "AppDelegate.h"

//For encryption
#import "NSData+Base64.h"
#import "StringEncryption.h"
#import "Base64.h"
#define gkey			@"0123456789abcdeffedcba9876543210"
#define gIv             @"fedcba9876543210"

@implementation WebserviceHandler

@synthesize request;
@synthesize responseData;
@synthesize delegate,str,id_;//,operation;
@synthesize index;

-(id)init {
    if ( self = [super init] ) {
    }
    return self;
}
#pragma mark - GetWebservice
-(void)callWebserviceWithRequest:(NSString *)methodName RequestString:(NSDictionary *)parameters RequestType:(NSString*)reqType{
    NSMutableString *postString=[[NSMutableString alloc] init];
    for (int i=0; i<[parameters allKeys].count; i++) {
        if ([parameters allKeys].count-1==i) {
            [postString appendString:[NSString stringWithFormat:@"%@=%@",[[parameters allKeys] objectAtIndex:i],[[parameters allValues] objectAtIndex:i]]];
        }else{
            [postString appendString:[NSString stringWithFormat:@"%@=%@&",[[parameters allKeys] objectAtIndex:i],[[parameters allValues] objectAtIndex:i]]];
        }
    }
    NSString *reqString=[NSString stringWithFormat:@"%@/%@?%@",URL_DOMAIN,methodName,postString];
    NSLog(@"dicttttt +++ %@",reqString);

    NSString *msgLength =[NSString stringWithFormat:@"%lu",(unsigned long)[reqString length]];
    request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:reqString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:reqType];
    [request setTimeoutInterval:120];
    [request setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([delegate respondsToSelector:@selector(webServiceHandler:recievedResponse:)])
            [delegate performSelector:@selector(webServiceHandler:recievedResponse:) withObject:self withObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
       // ShowAlert(AlertTitle, msgReqFail)
        if([delegate respondsToSelector:@selector(webServiceHandler:requestFailedWithError:)])
            [delegate performSelector:@selector(webServiceHandler:requestFailedWithError:) withObject:self withObject:error];
    }];
    [operation start];
}
#pragma mark - AFNtworking
// Create request ASynchrinously
// You will pass Method name, Method url name, and tag dictionary in below function
-(void) AFNcallThePassedURLASynchronouslyWithRequest:(NSDictionary*)valueDic withMethod:(NSString *)methodName withUrl:(NSString *)urlStr forKey:(NSString *)key
{
    NSString *UrlString = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,urlStr];

    if([UIApplication sharedApplication].delegate)
    {
           //Use below code if you want pass argumants like HTTP function
            //for append tag
        /*
        if(![valueDic[@"reqType1"] isEqualToString:@"AUTH"] && ![valueDic[@"reqType1"] isEqualToString:@"NEW_OBJECT"] && ![valueDic[@"reqType1"] isEqualToString:@"GET_VCARD"] )
        {
            NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
            NSMutableDictionary *valueDicWithAuth = [valueDic mutableCopy];
            [valueDicWithAuth setValue:@{@"username":[userdefaults valueForKey:UserName],@"password":[userdefaults valueForKey:UserPass]} forKey:@"auth"];
            valueDic = valueDicWithAuth;
        }
        */
        
        NSData *data = [JSONParser dataWithJSONObject:valueDic];
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
      //  URL_Log(UrlString, dataString)
        
        NSString *msgLength =[NSString stringWithFormat:@"%lu",(unsigned long)[dataString length]];
        
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:UrlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setTimeoutInterval:60];
        [request setHTTPBody:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
      
        //used with new AfNetworking framework
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];

        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
             //NSLog(@"response %@",responseObject);
            if([delegate respondsToSelector:@selector(webServiceHandler:recievedResponse:)])
                [delegate performSelector:@selector(webServiceHandler:recievedResponse:) withObject:self withObject:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
           // ShowAlert(AppName, msgReqFail)
            if([delegate respondsToSelector:@selector(webServiceHandler:requestFailedWithError:)])
                [delegate performSelector:@selector(webServiceHandler:requestFailedWithError:) withObject:self withObject:error];
        }];
      [operation start];
        }
    
    else
    {
        [appDelegate stopActivityIndicator];
        //ShowAlert (NetworkReachabilityTitle, NetworkReachabilityAlert)
    }
    
}
-(NSMutableString*)getJsonFormateFromDic :(NSDictionary*)valueDic :(NSString*)methodName{
   
   NSMutableString* requestStr = [[NSMutableString alloc] init];
    NSMutableArray *arrayValues = [[NSMutableArray alloc] init];
    
//    if([key length]!=0)
//    {
//        NSArray *array=[strArray componentsSeparatedByString:@","];
//        arrayValues = [[NSMutableArray alloc] initWithArray:array];
//    }
    [requestStr appendString:@"{"];
    NSArray *keyArr = [valueDic allKeys];
    for (int i=0; i<[keyArr count]; i++) {
        if(i==[keyArr count]-1)
        {
            if([arrayValues count]!=0)
            {
                BOOL isCheck = FALSE;
                for (int j=0; j<[arrayValues count]; j++) {
                    if([[keyArr objectAtIndex:i] isEqualToString:[arrayValues objectAtIndex:j]])
                    {
                        [requestStr appendString:[NSString stringWithFormat:@"\"%@\":%@",[keyArr objectAtIndex:i],[valueDic objectForKey:[keyArr objectAtIndex:i]]]];
                        [arrayValues removeObjectAtIndex:j];
                        isCheck = TRUE;
                    }
                }
                if(!isCheck)
                {
                    [requestStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\"",[keyArr objectAtIndex:i],[valueDic objectForKey:[keyArr objectAtIndex:i]]]];
                }
                
            }
            else
            {
                if([methodName length]>1 && [[keyArr objectAtIndex:i] isEqualToString:methodName])
                {
                    [requestStr appendString:[NSString stringWithFormat:@"\"%@\":%@",[keyArr objectAtIndex:i],[valueDic objectForKey:[keyArr objectAtIndex:i]]]];
                }else
                {
                    [requestStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\"",[keyArr objectAtIndex:i],[valueDic objectForKey:[keyArr objectAtIndex:i]]]];
                }
            }
        }else
        {
            if([arrayValues count]!=0)
            {
                BOOL isCheck = FALSE;
                for (int j=0; j<[arrayValues count]; j++) {
                    
                    if([[keyArr objectAtIndex:i] isEqualToString:[arrayValues objectAtIndex:j]])
                    {
                        [requestStr appendString:[NSString stringWithFormat:@"\"%@\":%@,",[keyArr objectAtIndex:i],[valueDic objectForKey:[keyArr objectAtIndex:i]]]];
                        [arrayValues removeObjectAtIndex:j];
                        isCheck= TRUE;
                    }
                }
                if(!isCheck)
                {
                    [requestStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",[keyArr objectAtIndex:i],[valueDic objectForKey:[keyArr objectAtIndex:i]]]];
                }
                
            }
            else
            {
                if([methodName length]>1 && [[keyArr objectAtIndex:i] isEqualToString:methodName])
                {
                    [requestStr appendString:[NSString stringWithFormat:@"\"%@\":%@,",[keyArr objectAtIndex:i],[valueDic objectForKey:[keyArr objectAtIndex:i]]]];
                }else
                    
                {
                    [requestStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",[keyArr objectAtIndex:i],[valueDic objectForKey:[keyArr objectAtIndex:i]]]];
                    
                }
            }
            
        }
    }
    [requestStr appendString:@"}"];
    
    return requestStr;
}
@end
