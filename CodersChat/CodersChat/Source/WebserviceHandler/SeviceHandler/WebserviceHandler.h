//
//  WebserviceHandler.h
//  MedlinxPatient
//
//  Created by Vandana Singh on 08/5/14.
//  Copyright (c) 2013 Vandana Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
@class WebserviceHandler;

//Methods for handle webservice Response
@protocol WebServiceHandlerDelegate <NSObject>
@optional
-(void) webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponce;
-(void) webServiceHandler:(WebserviceHandler *)webHandler requestFailedWithError:(NSError *)error;
@end

@interface WebserviceHandler : NSObject
@property (nonatomic,strong) NSMutableURLRequest *request;
@property (nonatomic,strong) NSMutableData *responseData;
@property (nonatomic,strong) id <WebServiceHandlerDelegate> delegate;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,strong) NSString *id_;
@property (nonatomic) NSInteger index;
@property (nonatomic,strong) AFHTTPRequestOperation *operation;

#pragma mark -call url
-(void) AFNcallThePassedURLASynchronouslyWithRequest:(NSDictionary*)valueDic withMethod:(NSString *)methodName withUrl:(NSString *)urlStr forKey:(NSString *)key;
-(void)callWebserviceWithRequest:(NSString *)methodName RequestString:(NSDictionary *)parameters RequestType:(NSString*)reqType;
-(NSMutableString*)getJsonFormateFromDic :(NSDictionary*)valueDic :(NSString*)methodName;
@end
