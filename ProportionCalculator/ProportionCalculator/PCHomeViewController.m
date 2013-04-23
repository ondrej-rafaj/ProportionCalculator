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
@property (nonatomic, strong) UIScrollView* scroller;
@end


@implementation PCHomeViewController


#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    
    [super setBackgroundImage:([super isBigPhone] ? @"Default-568h" : @"Default")];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"D7D7D7"]];
    [_scroller addSubview:self.backgroundImageView];
    
    _proportionCalculatorView = [[PCProportionCalculatorView alloc] initWithFrame:self.view.bounds];
    [_proportionCalculatorView setDelegate:self];
    [_proportionCalculatorView setAlpha:0];
    [_scroller addSubview:_proportionCalculatorView];
    
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


- (void)loadView {
    [super loadView];
    _scroller =[[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scroller];
    
}

#pragma mark Proportional calculator view delegate methods
/*
 - (void)proportionCalculatorView:(PCProportionCalculatorView *)view requiresToMoveInDirection:(PCProportionCalculatorViewDirectionMove)direction {
 [UIView animateWithDuration:0.3 animations:^{
 if (direction == PCProportionCalculatorViewDirectionMoveUp) {
 [self.backgroundImageView setYOrigin:-(kPCHomeViewControllerMoveUpDistance + 20)];
 [_proportionCalculatorView setYOrigin:-kPCHomeViewControllerMoveUpDistance];
 }
 else {
 //[self.backgroundImageView setYOrigin:-20];
 //[_proportionCalculatorView setYOrigin:0];
 }
 }];
 }
 */


- (void)proportionCalculatorViewRequestsKeyboard:(PCProportionCalculatorView *)view {
    [_calculatorKeyboard show];
    if (![self isBigPhone]) {
        [UIView animateWithDuration:0.3 animations:^{
            [_scroller setContentOffset:CGPointMake(0, 93)];
        }];
    }
}

- (void)proportionCalculatorViewRequestsKeyboardToBeDismissed:(PCProportionCalculatorView *)view {
    [_calculatorKeyboard hide];
    if (![self isBigPhone]) {
        [UIView animateWithDuration:0.3 animations:^{
            [_scroller setContentOffset:CGPointMake(0, 0)];
        }];
    }
}

#pragma mark Custom Keyboard delegate methods

-(NSString*)stringByTrimmingLeadingZeroesFromNSString:(NSString*)str {
    NSInteger i = 0;
    while ((i < [str length])
           && [[NSCharacterSet characterSetWithCharactersInString:@"0"] characterIsMember:[str characterAtIndex:i]]) {
        i++;
    }
    return [str substringFromIndex:i];
}


- (void)calculatorKeyboardView:(FTCalculatorKeyboardView *)view didClickNumberKeyWithValue:(NSInteger)value {
    NSString *t = _proportionCalculatorView.currentlyEditedTextField.realValueString ? _proportionCalculatorView.currentlyEditedTextField.realValueString : @"";
    NSString *v = [NSString stringWithFormat:@"%@%d", t,value];
    if ([t isEqualToString:@"0"] && value==0) {
        v=@"0";
    }
    else if ([t isEqualToString:@"0"] && value!=0) {
        v=[NSString stringWithFormat:@"%d",value];
    }
    NSRange isRange = [v rangeOfString:@"." options:NSCaseInsensitiveSearch];
    BOOL minus =([v characterAtIndex:0]==[@"-" characterAtIndex:0]);
    NSUInteger adder =(minus)?1:0;
    NSString* zeroChecker = [[v stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    /** Cases
     0.000...000n should be possible
     -0.000...000n should be possible
     0. ...abcde0....000f should be NOT possible
     0. ...a00...000b should be NOT possible if distance a-b (or a-c.. a-e) > MAX_LENGTH_DOT
     ABCDE0000...000 possible
     a.0...0bcde should be NOT possible if distance a-b (or a-c.. a-e) > MAX_LENGTH_DOT
     */
    
    BOOL isFirstDigit0 = [zeroChecker characterAtIndex:0]==[@"0" characterAtIndex:0];
    BOOL tooManySignificantDigits = NO;
    zeroChecker = [self stringByTrimmingLeadingZeroesFromNSString:zeroChecker];
    NSUInteger lenghtOfNonZeroElem = zeroChecker.length;
    if (isFirstDigit0) {
        tooManySignificantDigits = ((isRange.location != NSNotFound) && (lenghtOfNonZeroElem>MAX_LENGTH_DOT+adder));
    }
    else {
        tooManySignificantDigits = ((isRange.location != NSNotFound) && (v.length>MAX_LENGTH_DOT+adder));
    }
    if (tooManySignificantDigits) {
        v=t;
    }
    [_proportionCalculatorView.currentlyEditedTextField setRealValueString:v];
    [_proportionCalculatorView recalculate];
}

- (void)calculatorKeyboardView:(FTCalculatorKeyboardView *)view didClickSpecialKey:(FTCalculatorKeyboardViewSpecialKeyType)key {
    NSString *string = _proportionCalculatorView.currentlyEditedTextField.realValueString;
    
    if (!string) string = @"";
    if (key == FTCalculatorKeyboardViewSpecialKeyTypeClear) {
        [_proportionCalculatorView.currentlyEditedTextField setRealValueString:@""];
    }
    else if (key == FTCalculatorKeyboardViewSpecialKeyTypeErase) {
        if ([string length] > 0) string = [string substringToIndex:[string length] - 1];
        [_proportionCalculatorView.currentlyEditedTextField setRealValueString:string];
    }
    else if (key == FTCalculatorKeyboardViewSpecialKeyTypePlusMinus) {
        NSRange isRange = [string rangeOfString:@"-" options:NSCaseInsensitiveSearch];
        BOOL minus = (isRange.location != NSNotFound);
        if (!minus) {
            [_proportionCalculatorView.currentlyEditedTextField setRealValueString:[@"-" stringByAppendingString:string]];
        }
        else {
            [_proportionCalculatorView.currentlyEditedTextField setRealValueString:[string substringFromIndex:1]];
        }
        
    }
    else if (key == FTCalculatorKeyboardViewSpecialKeyTypeDot) {
        NSRange isRange = [string rangeOfString:@"." options:NSCaseInsensitiveSearch];
        if (isRange.location == NSNotFound) [_proportionCalculatorView.currentlyEditedTextField setRealValueString:[string stringByAppendingString:@"."]];
    }
    [_proportionCalculatorView recalculate];
}


@end
