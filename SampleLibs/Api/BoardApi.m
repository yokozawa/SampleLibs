//
//  BoardApi.m
//  SampleLibs
//
//  Created by yoko_net on 2014/02/02.
//  Copyright (c) 2014年 yoko_net. All rights reserved.
//

#import "BoardApi.h"
#import "Board.h"

@implementation BoardApi

// OVERRIDE
- (id)init
{
    _api = [[Api alloc] init];
    return self;
}

- (Board *)jsonToBoard:(NSDictionary *)result
{
    Board *board = [[Board alloc] init];
    board.boardId = [[result objectForKey:@"id"] intValue];
    board.title = [NSString stringWithFormat:@"%@", [result objectForKey:@"title"]];
    return board;
}

- (void)getBoard:(NSDictionary *)param
        okHandler:(void (^)(Board *board))okHandler
        ngHandler:(void (^)(NSDictionary *errors))ngHandler
{
    NSString *path = [NSString stringWithFormat:@"res/%@/id/%@/title/%@"
                      ,[param objectForKey:@"res"]
                      ,[param objectForKey:@"board_id"]
                      ,[param objectForKey:@"title"]];
    [_api.sharedClient getJsonResponse:path onResponse:^(NSDictionary *response) {
        if([[response objectForKey:@"res"] isEqualToString:@"ok"]){
            okHandler([self jsonToBoard:response]);
        } else {
            ngHandler(nil);
        }
    }];
}

@end
