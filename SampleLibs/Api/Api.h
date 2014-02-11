//
//  Api.h
//  SampleLibs
//
//  Created by yoko_net on 2014/02/02.
//  Copyright (c) 2014年 yoko_net. All rights reserved.
//

#import "AFNetworking.h"

@interface Api : AFHTTPRequestOperationManager

- (Api *)sharedClient;

-(void)getJsonResponse:(NSString *)path
            onResponse:(void (^)(NSDictionary *response))onResponse;

-(void)getJsonResponse:(NSString *)path
            onResponse:(void (^)(NSDictionary *response))onResponse
               onError:(void (^)(NSError *error))onError;

@end
