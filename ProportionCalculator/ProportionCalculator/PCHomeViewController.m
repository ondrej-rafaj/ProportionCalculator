//
//  PCHomeViewController.m
//  ProportionCalculator
//
//  Created by Ondrej Rafaj on 24/03/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "PCHomeViewController.h"


#define kPCHomeViewControllerMoveUpDistance             72


@interface PCHomeViewController ()

@property (nonatomic, strong) PCProportionCalculatorView *proportionCalculatorView;
@property (nonatomic, strong) FTCalculatorKeyboardView *calculatorKeyboard;

@end


@implementation PCHomeViewController


#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    
    [super setBackgroundImage:([super isBigPhone] ? @"Default-568h" : @"Default")];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"D7D7D7"]];
    
    _proportionCalculatorView = [[PCProportionCalculatorView alloc] initWithFrame:self.view.bounds];
    [_proportionCalculatorView setDelegate:self];
    [_proportionCalculatorView setAlpha:0];
    [self.view addSubview:_proportionCalculatorView];
    
    _calculatorKeyboard = [[FTCalculatorKeyboardView alloc] init];
    [_calculatorKeyboard setDelegate:self];
    [self.view addSubview:_calculatorKeyboard];
}

#pragma mark View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        [_proportionCalculatorView setAlpha:1];
    }];
}

#pragma mark Proportional calculator view delegate methods

- (void)proportionCalculatorView:(PCProportionCalculatorView *)view requiresToMoveInDirection:(PCProportionCalculatorViewDirectionMove)direction {
    [UIView animateWithDuration:0.3 animations:^{
        if (direction == PCProportionCalculatorViewDirectionMoveUp) {
            [self.backgroundImageView setYOrigin:-(kPCHomeViewControllerMoveUpDistance + 20)];
            [_proportionCalculatorView setYOrigin:-kPCHomeViewControllerMoveUpDistance];
        }
        else {
            [self.backgroundImageView setYOrigin:-20];
            [_proportionCalculatorView setYOrigin:0];
        }
    }];
}

- (void)proportionCalculatorViewRequestsKeyboard:(PCProportionCalculatorView *)view {
    [_calculatorKeyboard show];
}

- (void)proportionCalculatorViewRequestsKeyboardToBeDismissed:(PCProportionCalculatorView *)view {
    [_calculatorKeyboard hide];
}

#pragma mark Custom Keyboard delegate methods

- (void)calculatorKeyboardView:(FTCalculatorKeyboardView *)view didClickNumberKeyWithValue:(NSInteger)value {
    NSString *t = _proportionCalculatorView.currentlyEditedTextField.text ? _proportionCalculatorView.currentlyEditedTextField.text : @"";
    NSRange isRange = [t rangeOfString:@"." options:NSCaseInsensitiveSearch];
    BOOL isDot = (isRange.location != NSNotFound);
    double i = [[NSString stringWithFormat:@"%.5g%@%d", [t doubleValue], (isDot ? @"." : @""), value] doubleValue];
    NSString *v = [NSString stringWithFormat:@"%.5g", i];
    [_proportionCalculatorView.currentlyEditedTextField setText:v];
    [_proportionCalculatorView recalculate];
}

- (void)calculatorKeyboardView:(FTCalculatorKeyboardView *)view didClickSpecialKey:(FTCalculatorKeyboardViewSpecialKeyType)key {
    NSString *string = _proportionCalculatorView.currentlyEditedTextField.text;
    
    if (!string) string = @"";
    if (key == FTCalculatorKeyboardViewSpecialKeyTypeClear) {
        [_proportionCalculatorView.currentlyEditedTextField setText:@""];
    }
    else if (key == FTCalculatorKeyboardViewSpecialKeyTypeErase) {
        if ([string length] > 0) string = [string substringToIndex:[string length] - 1];
        [_proportionCalculatorView.currentlyEditedTextField setText:string];
    }
    else if (key == FTCalculatorKeyboardViewSpecialKeyTypePlusMinus) {
        
        [_proportionCalculatorView.currentlyEditedTextField setText:[@"-" stringByAppendingString:string]];
    }
    else if (key == FTCalculatorKeyboardViewSpecialKeyTypeDot) {
        NSRange isRange = [string rangeOfString:@"." options:NSCaseInsensitiveSearch];
        if (isRange.location == NSNotFound) [_proportionCalculatorView.currentlyEditedTextField setText:[string stringByAppendingString:@"."]];
    }
    [_proportionCalculatorView recalculate];
}


@end
