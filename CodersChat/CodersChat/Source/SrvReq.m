//
//  SrvReq.m
//  CodersChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "SrvReq.h"

@interface SrvReq ()
{
    // Member variables
    
    
    eObjType 	objType;
    eReqType 	reqType1;
    eReqType 	reqType2;
    UserAuth 		*auth;
    id 			reqDetails;
    
    
}
@end

@implementation SrvReq

-(SrvReq *)init {
    // Construct this object:
    
    self = [super init];
    if(self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    //Do Initialization of all
    
    objType = oj_SRV_REQ;
    reqType1	= NOREQ;
    reqType2	= NOREQ;
    auth		= nil;
    reqDetails	= nil;
}
@end

