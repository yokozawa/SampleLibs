//
//  ViewController.m
//  SampleLibs
//
//  Created by yoko_net on 2014/02/02.
//  Copyright (c) 2014年 yoko_net. All rights reserved.
//

#import "ViewController.h"
#import "BoardApi.h"
#import "Board.h"

#import "InvalidTooltipView.h"
#import "TooltipView.h"
#import "ValidatorRules.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UITextField *tfId;
@property (nonatomic, strong) IBOutlet UITextField *tfTitle;
@property (nonatomic, strong) IBOutlet UIButton *btnOk;
@property (nonatomic, strong) IBOutlet UIButton *btnNg;

@property (nonatomic) bool result;

@end

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    __block ViewController __weak *weakSelf = self;
    [_btnOk bk_addEventHandler:^(id sender) {
        _result = true;
        [weakSelf doValidation:nil];
    } forControlEvents:UIControlEventTouchUpInside];
 
    [_btnNg bk_addEventHandler:^(id sender) {
        _result = false;
        [weakSelf doValidation:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)doValidation:(id)sender
{
    if (_tooltipView != nil)
    {
        [_tooltipView removeFromSuperview];
        _tooltipView = nil;
    }
    
    Validator *validator = [[Validator alloc] init];
    validator.delegate   = self;
    
    [validator putRule:[Rules minLength:1 withFailureString:NSLocalizedString(@"validateRequire", @"") forTextField:_tfId]];
    
    [validator putRule:[Rules minLength:1 withFailureString:NSLocalizedString(@"validateRequire", @"") forTextField:_tfTitle]];
    
    
    [validator validate];
    // call ValidatorDelegate
    
}

- (void) getContents:(bool)res
{
    NSString *result = res ? @"ok" : @"ng";
    
    NSDictionary *param = @{@"res":result
                            , @"board_id": _tfId.text
                            , @"title": _tfTitle.text};
    
    [SVProgressHUD showWithMaskType: SVProgressHUDMaskTypeClear];
    BoardApi *boardApi = [[BoardApi alloc] init];
    [boardApi getBoard:param okHandler:^(Board *getBoard) {
        [SVProgressHUD showSuccessWithStatus:[getBoard description]];
    } ngHandler:^(NSDictionary *errors) {
        [SVProgressHUD showErrorWithStatus:[errors description]];
    }];
}


#pragma ValidatorDelegate - Delegate methods

- (void) preValidation
{
    for (UIView *view in [self.view subviews]) {
        if([view isKindOfClass:[UITextField class]]) {
            view.layer.borderWidth = 0;
        }
    }
}

- (void)onSuccess
{
    if (_tooltipView != nil)
    {
        [_tooltipView removeFromSuperview];
        _tooltipView  = nil;
    }
    [self getContents:_result];
}

- (void)onFailure:(Rule *)failedRule
{
    failedRule.textField.layer.borderColor   = [[UIColor redColor] CGColor];
    failedRule.textField.layer.cornerRadius  = 5;
    failedRule.textField.layer.borderWidth   = 2;
    
    CGPoint point = [failedRule.textField convertPoint:CGPointMake(0.0, failedRule.textField.frame.size.height - 4.0) toView:self.view];
    CGRect tooltipViewFrame = CGRectMake(6.0, point.y, 309.0, _tooltipView.frame.size.height);
    
    _tooltipView       = [[InvalidTooltipView alloc] init];
    _tooltipView.frame = tooltipViewFrame;
    _tooltipView.text  = [NSString stringWithFormat:@"%@",failedRule.failureMessage];
    _tooltipView.rule  = failedRule;
    [self.view addSubview:_tooltipView];
}

@end
