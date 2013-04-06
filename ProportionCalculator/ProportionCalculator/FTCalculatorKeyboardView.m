//
//  FTCalculatorKeyboardView.m
//  ProportionCalculator
//
//  Created by Ondrej Rafaj on 03/04/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTCalculatorKeyboardView.h"


@interface FTCalculatorKeyboardView ()

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *plusMinusButton;

@end


@implementation FTCalculatorKeyboardView


#pragma mark Layout

- (BOOL)isBigPhone {
    return ([[UIScreen mainScreen] bounds].size.height == 568);
}

- (CGFloat)screenHeight {
    return [self isBigPhone] ? 548 : 460;
}

#pragma mark Create elements

- (void)createNumberButtons {
    UIImage *bcg = [UIImage imageNamed:@"PC_btn_calc_light"];
    CGFloat xPos = 8;
    CGFloat yPos = 10;
    int x = 1;
    for (int i = 1; i < 11; i++) {
        int v = i;
        if (v == 10) {
            v = 0;
        }
        UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(xPos, yPos, bcg.size.width, bcg.size.height)];
        [b addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
        [b setTag:(666 + v)];
        [b setTitle:[NSString stringWithFormat:@"%d", v] forState:UIControlStateNormal];
        [b.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [b.titleLabel setFont:[UIFont boldSystemFontOfSize:28]];
        [b setTitleColor:[UIColor colorWithHexString:@"2B3127"] forState:UIControlStateNormal];
        [b setBackgroundImage:bcg forState:UIControlStateNormal];
        [self addSubview:b];
        if (v != 9) xPos += (3 + bcg.size.width);
        if ((x % 3) == 0) {
            x = 0;
            if (v != 9) xPos = 8;
            yPos += (8 + bcg.size.height);
        }
        x++;
    }
}

- (void)createSpecialButtons {
    UIImage *bcg = [UIImage imageNamed:@"PC_btn_calc_dark"];
    CGFloat xPos = (8 + ((3 + bcg.size.width) * 3));
    CGFloat yPos = 10;
    for (int i = 0; i < 4; i++) {
        UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(xPos, yPos, bcg.size.width, bcg.size.height)];
        [b addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
        [b setTag:(566 + i)];
        NSString *t;
        switch (i) {
            case FTCalculatorKeyboardViewSpecialKeyTypeClear:
                t = @"C";
                break;
                
            case FTCalculatorKeyboardViewSpecialKeyTypeErase:
                t = @"<";
                break;
                
            case FTCalculatorKeyboardViewSpecialKeyTypePlusMinus:
                t = @"+-";
                break;
                
            case FTCalculatorKeyboardViewSpecialKeyTypeDot:
                t = @".";
                break;
                
            default:
                break;
        }
        [b setTitle:t forState:UIControlStateNormal];
        [b.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [b.titleLabel setFont:[UIFont boldSystemFontOfSize:28]];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setBackgroundImage:bcg forState:UIControlStateNormal];
        [self addSubview:b];
        yPos += (8 + bcg.size.height);
    }
}

- (void)createAllElements {
    [self createNumberButtons];
    [self createSpecialButtons];
}

#pragma mark Initialization

- (id)init
{
    CGRect frame = CGRectMake(0, [self screenHeight], 320, 240);
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithHexString:@"A8A8A8" andAlpha:0.8]];
        [self createAllElements];
    }
    return self;
}

#pragma mark Settings

- (void)show {
    CGRect r = self.frame;
    r.origin.y = ([self screenHeight] - r.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:r];
    }];
}

- (void)hide {
    CGRect r = self.frame;
    r.origin.y = [self screenHeight];
    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:r];
    }];
}

- (void)didPressButton:(UIButton *)sender {
    int buttonValue = (sender.tag - 666);
    if (buttonValue >= 0) {
        if ([_delegate respondsToSelector:@selector(calculatorKeyboardView:didClickNumberKeyWithValue:)]) {
            [_delegate calculatorKeyboardView:self didClickNumberKeyWithValue:buttonValue];
        }
    }
    else {
        buttonValue += 100;
        if ([_delegate respondsToSelector:@selector(calculatorKeyboardView:didClickSpecialKey:)]) {
            [_delegate calculatorKeyboardView:self didClickSpecialKey:buttonValue];
        }
    }
}


@end
