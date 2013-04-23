//
//  UIView+AttributeByObject.m
//  ProportionCalculator
//
//  Created by Antonio Corrado on 23/04/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "UIView+AttributeByObject.h"

@implementation UIView (AttributeByObject)

- (void)setAlphaByObject:(NSNumber*)alpha {
    [self setAlpha:[alpha doubleValue]];
}

@end
