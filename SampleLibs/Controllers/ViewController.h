//
//  ViewController.h
//  SampleLibs
//
//  Created by yoko_net on 2014/02/02.
//  Copyright (c) 2014年 yoko_net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Validator.h"
#import "TooltipView.h"

@interface ViewController : UIViewController
<UITextFieldDelegate, UITextViewDelegate,ValidatorDelegate> {
    TooltipView *_tooltipView;
}


@end
