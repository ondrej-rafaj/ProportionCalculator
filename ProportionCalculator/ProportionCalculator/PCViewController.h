//
//  PCViewController.h
//  ProportionCalculator
//
//  Created by Ondrej Rafaj on 24/03/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PCViewController : UIViewController

@property (nonatomic) BOOL isLandscape;

// Positioning
- (CGFloat)screenHeight;
- (BOOL)isTablet;
- (BOOL)isBigPhone;
- (BOOL)isRetina;

// Creating and configuring view
- (void)setBackgroundImage:(NSString *)imageName;
- (void)setupView;
- (void)layoutElements;
- (void)createAllElements;

// Navigation
- (void)pushViewController:(PCViewController *)controller;
- (void)closeModal;


@end
