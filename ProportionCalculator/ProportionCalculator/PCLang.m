//
//  PCLang.m
//  ProportionCalculator
//
//  Created by Ondrej Rafaj on 24/03/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "PCLang.h"


@implementation PCLang

+ (NSString *)get:(NSString *)key {
    return NSLocalizedString(key, nil);
}


@end
