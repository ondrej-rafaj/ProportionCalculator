//
//  PCHomeViewController.m
//  ProportionCalculator
//
//  Created by Ondrej Rafaj on 24/03/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "PCHomeViewController.h"
#import "PCProportionCalculatorView.h"


@interface PCHomeViewController ()

@property (nonatomic, strong) PCProportionCalculatorView *proportionCalculatorView;

@end


@implementation PCHomeViewController


#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    
    [super setBackgroundImage:([super isBigPhone] ? @"Default-568h" : @"Default")];
    
    _proportionCalculatorView = [[PCProportionCalculatorView alloc] initWithFrame:self.view.bounds];
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


@end
