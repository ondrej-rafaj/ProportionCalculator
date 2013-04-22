//
//  PCTextField.m
//  ProportionCalculator
//
//  Created by Ondrej Rafaj on 24/03/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "PCValueTextField.h"


#define kPCValueTextFieldTextColor                       [UIColor colorWithHexString:@"303030"]

@interface PCValueTextField ()

@end

@implementation PCValueTextField


#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setKeyboardAppearance:UIKeyboardAppearanceAlert];
        [self setKeyboardType:UIKeyboardTypeDecimalPad];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setFont:[UIFont boldSystemFontOfSize:35]];
        [self setMinimumFontSize:6];
        [self setAdjustsFontSizeToFitWidth:YES];
        [self setTextColor:kPCValueTextFieldTextColor];
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        _realValueString=nil;
    }
    return self;
}

#pragma mark Settings

- (void)setRealValueString:(NSString *)realValueString {
    _realValueString=realValueString;
    if (_realValueString.length>0) {
        BOOL minus =([_realValueString characterAtIndex:0]==[@"-" characterAtIndex:0]);
        NSUInteger adder =(minus)?1:0;
        if (_realValueString.length<=MAX_LENGTH_DOT+adder) {
            self.text=_realValueString;
        }
        else{
            self.text = [NSString stringWithFormat:@"%.5g", [_realValueString doubleValue]];
        }
    }
    else {
        self.text=@"";
    }
}

- (void)disable:(BOOL)disable {
    if (disable) {
        [self setText:@"x"];
        _realValueString=@"";
        [self setTextColor:[UIColor grayColor]];
    }
    else {
        [self setText:nil];
        _realValueString=@"";
        [self setTextColor:kPCValueTextFieldTextColor];
    }
    [self setEnabled:!disable];
}

- (void)setDefaultTextColor {
    [self setTextColor:kPCValueTextFieldTextColor];
}

- (void)setLightTextColor {
    [self setTextColor:[UIColor colorWithHexString:@"555555"]];
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
