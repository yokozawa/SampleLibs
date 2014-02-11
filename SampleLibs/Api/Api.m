//
//  Api.m
//  SampleLibs
//
//  Created by yoko_net on 2014/02/02.
//  Copyright (c) 2014年 yoko_net. All rights reserved.
//

#import "Api.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@implementation Api

#define kApiBaseUrl @"http://echo.jsontest.com/parse_time_nanoseconds/196008/"
#define kUserAgent @"myAgent 1.0"

- (Api *)init
{
    return [self sharedClient];
}

- (Api *)sharedClient
{
    static Api *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[Api alloc] initWithBaseURL:[NSURL URLWithString:kApiBaseUrl]];
    });
    
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.requestSerializer setValue:kUserAgent forHTTPHeaderField:@"User-Agent"];
    }
    
    return self;
}

-(void)alertConnetionError
{
    [SVProgressHUD showErrorWithStatus:@"connection error"];
}

-(void)getJsonResponse:(NSString *)path
     onResponse:(void (^)(NSDictionary *response))onResponse
{
    [self getJsonResponse:path onResponse:onResponse onError:nil];
}

-(void)getJsonResponse:(NSString *)path
     onResponse:(void (^)(NSDictionary *response))onResponse
        onError:(void (^)(NSError *error))onError
{
    Api *api = [[Api alloc] init];
    [api.sharedClient GET:path parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                onResponse(responseObject);
            });
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
            if(onError == nil) {
                [api alertConnetionError];
            } else {
                onError(error);
            }
        });
    }];
}

@end
