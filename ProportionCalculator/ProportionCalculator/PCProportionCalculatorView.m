//
//  PCProportionCalculatorView.m
//  ProportionCalculator
//
//  Created by Ondrej Rafaj on 24/03/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "PCProportionCalculatorView.h"


@interface PCProportionCalculatorView ()

@property (nonatomic, strong) UISegmentedControl *typeSelector;

@property (nonatomic, strong) UITextField *value1Field;
@property (nonatomic, strong) UITextField *value2Field;
@property (nonatomic, strong) UITextField *value3Field;
@property (nonatomic, strong) UITextField *value4Field;

@property (nonatomic, strong) UILabel *value1Label;
@property (nonatomic, strong) UILabel *value2Label;
@property (nonatomic, strong) UILabel *value3Label;
@property (nonatomic, strong) UILabel *value4Label;

@property (nonatomic, strong) UIImageView *leftArrow;
@property (nonatomic, strong) UIImageView *rightArrow;

@property (nonatomic, strong) UITextField *resultField;
@property (nonatomic, strong) UILabel *explanationLabel;


@end


@implementation PCProportionCalculatorView


#pragma mark Calculations

- (void)showRightLabels {
    [_value1Label setText:@"a"];
    [_value2Label setText:@"b"];
    [_value3Label setText:@"c"];
    [_value4Label setText:@"x"];

    [_value1Field setPlaceholder:_value1Label.text];
    [_value2Field setPlaceholder:_value2Label.text];
    [_value3Field setPlaceholder:_value3Label.text];
    [_value4Field setPlaceholder:_value4Label.text];
}

- (void)showRightArrows {
    UIImage *img;
    CGFloat yPos;
    if (_propType == PCProportionCalculatorViewPropTypeProportional) {
        img = [UIImage imageNamed:@"PC_arrow_down"];
        yPos = 129;
    }
    else {
        img = [UIImage imageNamed:@"PC_arrow_up"];
        yPos = 135;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [_leftArrow setXOrigin:-11];
        [_rightArrow setXOrigin:320];
    } completion:^(BOOL finished) {
        [_rightArrow setImage:img];
        [_rightArrow setYOrigin:yPos];
        [UIView animateWithDuration:0.3 animations:^{
            [_leftArrow setXOrigin:10];
            [_rightArrow setXOrigin:300];
        }];
    }];
}

- (void)recalculate {
    [self showRightArrows];
    
}

#pragma mark Creating elements

- (void)createTypeSelector {
    _propType = PCProportionCalculatorViewPropTypeProportional;
    NSArray *itemArray = [NSArray arrayWithObjects:PCLangGet(@"PROPORT"), PCLangGet(@"DISPROP"), nil];
    _typeSelector = [[UISegmentedControl alloc] initWithItems:itemArray];
    [_typeSelector addTarget:self action:@selector(didSwitchProportionType:) forControlEvents:UIControlEventValueChanged];
    [_typeSelector setFrame:CGRectMake(0, 20, 288, 46)];
    [self addSubview:_typeSelector];
    [_typeSelector centerHorizontally];
    [_typeSelector setSelectedSegmentIndex:_propType];
}

- (UITextField *)valueTextFieldForPosition:(CGPoint)origin {
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(origin.x, origin.y, 95, 54)];
    [tf setTextColor:[UIColor darkGrayColor]];
    [tf setTextAlignment:NSTextAlignmentCenter];
    [tf setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.3]];
    return tf;
}

- (void)createValueFields {
    _value1Field = [self valueTextFieldForPosition:CGPointMake(52, 139)];
    [self addSubview:_value1Field];
}

- (UILabel *)valueLabelForPosition:(CGPoint)origin {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(origin.x, origin.y, 30, 30)];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setShadowColor:[UIColor lightGrayColor]];
    [label setShadowOffset:CGSizeMake(1, 1)];
    return label;
}

- (void)createValueLabels {
    _value1Label = [self valueLabelForPosition:CGPointMake(19, 102)];
    [self addSubview:_value1Label];
    
    _value2Label = [self valueLabelForPosition:CGPointMake((320 - 30 - 17), 102)];
    [self addSubview:_value2Label];
    
    _value3Label = [self valueLabelForPosition:CGPointMake(19, 272)];
    [self addSubview:_value3Label];
    
    _value4Label = [self valueLabelForPosition:CGPointMake((320 - 30 - 17), 272)];
    [self addSubview:_value4Label];
    
    [self showRightLabels];
}

- (void)createArrows {
    _leftArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PC_arrow_down"]];
    [_leftArrow setOrigin:CGPointMake(10, 129)];
    [self addSubview:_leftArrow];

    _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PC_arrow_down"]];
    [_rightArrow setOrigin:CGPointMake(300, 129)];
    [self addSubview:_rightArrow];
}

- (void)createResultSection {
    _resultField = [[UITextField alloc] initWithFrame:CGRectMake(0, (self.height - 82), 200, 62)];
    [_resultField setBackground:[UIImage imageNamed:@"PC_result_field"]];
    [_resultField setEnabled:NO];
    [self addSubview:_resultField];
    [_resultField centerHorizontally];
}

- (void)addGestureRecognizers {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhereToDismissKeyboard:)];
    [self addGestureRecognizer:tap];
}

- (void)createAllElements {
    [super createAllElements];
    [self createTypeSelector];
    [self createValueFields];
    [self createValueLabels];
    [self createArrows];
    [self createResultSection];
    [self addGestureRecognizers];
}

#pragma mark Gesture recognizers

- (void)didTapAnywhereToDismissKeyboard:(UITapGestureRecognizer *)recognizer {
    if ([_value1Field isFirstResponder]) [_value1Field resignFirstResponder];
    if ([_value2Field isFirstResponder]) [_value2Field resignFirstResponder];
    if ([_value3Field isFirstResponder]) [_value3Field resignFirstResponder];
    if ([_value4Field isFirstResponder]) [_value4Field resignFirstResponder];
}

#pragma mark Actions

- (void)didSwitchProportionType:(UISegmentedControl *)sender {
    _propType = sender.selectedSegmentIndex;
    [self recalculate];
}


@end
