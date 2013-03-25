//
//  PCTextField.m
//  ProportionCalculator
//
//  Created by Ondrej Rafaj on 24/03/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "PCValueTextField.h"


@implementation PCValueTextField


#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setKeyboardAppearance:UIKeyboardAppearanceAlert];
        [self setKeyboardType:UIKeyboardTypeNumberPad];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setFont:[UIFont boldSystemFontOfSize:35]];
        [self setMinimumFontSize:6];
        [self setAdjustsFontSizeToFitWidth:YES];
        [self setTextColor:[UIColor colorWithHexString:@"303030"]];
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    }
    return self;
}

#pragma mark Settings

- (void)disable:(BOOL)disable {
    if (disable) {
        [self setText:@"x"];
        [self setTextColor:[UIColor grayColor]];
    }
    else {
        [self setText:nil];
        [self setTextColor:[UIColor colorWithHexString:@"303030"]];
    }
    [self setEnabled:!disable];
}

#pragma mark Text insets

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect origValue = [super textRectForBounds:bounds];
    return CGRectOffset(origValue, 0.0f, 0.0f);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect origValue = [super textRectForBounds:bounds];
    return CGRectOffset(origValue, 0.0f, 0.0f);
}


@end
