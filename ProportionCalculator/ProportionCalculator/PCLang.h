//
//  PCLang.h
//  ProportionCalculator
//
//  Created by Ondrej Rafaj on 24/03/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


#define PCLangGet(key) [PCLang get:key]


@interface PCLang : NSObject

+ (NSString *)get:(NSString *)key;


@end
