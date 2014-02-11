//
//  DescriptionBuilder.h
//  DescriptionBuilder
//
//  Created by Morita Naoki on 2014/01/01.
//  Copyright (c) 2014年 molabo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum DescriptionStyle {
    DescriptionStyleDefault,
    DescriptionStyleMultiLine,
    DescriptionStyleNoNames,
    DescriptionStyleShortPrefix,
    DescriptionStyleSimple,
} DescriptionStyle;

@interface DescriptionBuilder : NSObject

+ (NSString *)reflectDescription:(id)obj;
+ (NSString *)reflectDescription:(id)obj style:(DescriptionStyle)style;

@end
