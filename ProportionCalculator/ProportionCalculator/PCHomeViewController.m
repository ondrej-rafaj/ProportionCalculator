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


@end
