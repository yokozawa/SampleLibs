//
//  DescriptionBuilder.m
//  DescriptionBuilder
//
//  Created by Morita Naoki on 2014/01/01.
//  Copyright (c) 2014年 molabo. All rights reserved.
//

#import "DescriptionBuilder.h"
#import <objc/runtime.h>

@implementation DescriptionBuilder

+ (NSString *)reflectDescription:(id)obj {
    return [DescriptionBuilder reflectDescription:obj style:DescriptionStyleDefault];
}

+ (NSString *)reflectDescription:(id)obj style:(DescriptionStyle)style {
    return [DescriptionBuilder reflectDescription:obj style:style targetClass:[obj class]];
}

#pragma mark - private

+ (NSString *)reflectDescription:(id)obj style:(DescriptionStyle)style targetClass:(Class)cls {
    
    NSMutableString *description = [[NSMutableString alloc] init];
    if (style == DescriptionStyleMultiLine) {
        [description appendFormat:@"<%s: 0x%x;\n", class_getName(cls), [obj hash]];
    } else if (style == DescriptionStyleNoNames) {
        [description appendFormat:@"<%s: 0x%x; ", class_getName(cls), [obj hash]];
    } else if (style == DescriptionStyleShortPrefix) {
        [description appendFormat:@"<%s; ", class_getName(cls)];
    } else if (style == DescriptionStyleSimple) {
        [description appendString:@"<"];
    } else {
        [description appendFormat:@"<%s: 0x%x; ", class_getName(cls), [obj hash]];
    }
    
    NSDictionary *properties = [self propertiesOfObject:obj];
    [properties enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        
        // name
        if (style == DescriptionStyleMultiLine) {
            [description appendFormat:@"%@ = ", key];
        } else if (style == DescriptionStyleNoNames) {
            //Nothing to do.;
        } else if (style == DescriptionStyleShortPrefix) {
            [description appendFormat:@"%@ = ", key];
        } else if (style == DescriptionStyleSimple) {
            //Nothing to do.;
        } else {
            [description appendFormat:@"%@ = ", key];
        }
        
        [description appendFormat:@"%@", value];
        
        // line
        if (style == DescriptionStyleMultiLine) {
            [description appendString:@";\n"];
        } else if (style == DescriptionStyleNoNames) {
            [description appendString:@"; "];
        } else if (style == DescriptionStyleShortPrefix) {
            [description appendString:@"; "];
        } else if (style == DescriptionStyleSimple) {
            [description appendString:@"; "];
        } else {
            [description appendString:@"; "];
        }
    }];
    
    [description appendString:@">"];
    return description;
}

+ (NSDictionary *)propertiesOfObject:(id)obj
{
    NSMutableDictionary *properties = [[NSMutableDictionary alloc]init];
    NSUInteger propertyListCount;
    objc_property_t *propertyList = class_copyPropertyList([obj class], &propertyListCount);
    for( int i=0; i<propertyListCount; i++ ){
        objc_property_t property = propertyList[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property)
                                                    encoding:NSASCIIStringEncoding];
        id propertyValue = [obj valueForKey:propertyName];
        
        if (propertyValue) {
            [properties setObject:propertyValue forKey:propertyName];
        }
    }
    return properties;
}

@end
