//
//  PCResultTextField.m
//  ProportionCalculator
//
//  Created by Ondrej Rafaj on 24/03/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "PCResultTextField.h"


@implementation PCResultTextField


#pragma mark Text insets

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect origValue = [super textRectForBounds:bounds];
    origValue.size.width -= 40;
    return CGRectOffset(origValue, 35.0f, 2);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}


@end
