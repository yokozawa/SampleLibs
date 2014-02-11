//
//  BoardApi.h
//  SampleLibs
//
//  Created by yoko_net on 2014/02/02.
//  Copyright (c) 2014年 yoko_net. All rights reserved.
//

#import "Api.h"
#import "Board.h"

@interface BoardApi : Api

@property (nonatomic, strong) Api *api;

- (void)getBoard:(NSDictionary *)param
       okHandler:(void (^)(Board *board))okHandler
       ngHandler:(void (^)(NSDictionary *errors))ngHandler;

@end
