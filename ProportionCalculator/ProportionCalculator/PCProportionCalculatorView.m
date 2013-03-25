//
//  PCProportionCalculatorView.m
//  ProportionCalculator
//
//  Created by Ondrej Rafaj on 24/03/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "PCProportionCalculatorView.h"
#import "PCValueTextField.h"
#import "PCResultTextField.h"


@interface PCProportionCalculatorView ()

@property (nonatomic, strong) UISegmentedControl *typeSelector;

@property (nonatomic, strong) PCValueTextField *value1Field;
@property (nonatomic, strong) PCValueTextField *value2Field;
@property (nonatomic, strong) PCValueTextField *value3Field;
@property (nonatomic, strong) PCValueTextField *value4Field;

@property (nonatomic, strong) UILabel *value1Label;
@property (nonatomic, strong) UILabel *value2Label;
@property (nonatomic, strong) UILabel *value3Label;
@property (nonatomic, strong) UILabel *value4Label;

@property (nonatomic, strong) UIImageView *leftArrow;
@property (nonatomic, strong) UIImageView *rightArrow;

@property (nonatomic, strong) PCResultTextField *resultField;
@property (nonatomic, strong) UILabel *explanationLabel;

@property (nonatomic) NSInteger currentXField;

@end


@implementation PCProportionCalculatorView


#pragma mark Calculations

- (BOOL)allValuesAvailable {
    BOOL ok = YES;
    if (_value1Field.text.length == 0) ok = NO;
    if (_value2Field.text.length == 0) ok = NO;
    if (_value3Field.text.length == 0) ok = NO;
    if (_value4Field.text.length == 0) ok = NO;
    return ok;
}

- (void)disableField:(PCValueTextField *)textField {
    [_value1Field disable:(textField == _value1Field)];
    [_value2Field disable:(textField == _value2Field)];
    [_value3Field disable:(textField == _value3Field)];
    [_value4Field disable:(textField == _value4Field)];
}

- (void)showRightLabels {
    if (_currentXField == 4) {
        [_value1Label setText:@"a"];
        [_value2Label setText:@"b"];
        [_value3Label setText:@"c"];
        [_value4Label setText:@"x"];
        [self disableField:_value4Field];
    }
    else if (_currentXField == 3) {
        [_value1Label setText:@"a"];
        [_value2Label setText:@"b"];
        [_value3Label setText:@"x"];
        [_value4Label setText:@"c"];
        [self disableField:_value3Field];
    }
    else if (_currentXField == 2) {
        [_value1Label setText:@"a"];
        [_value2Label setText:@"x"];
        [_value3Label setText:@"b"];
        [_value4Label setText:@"c"];
        [self disableField:_value2Field];
    }
    else if (_currentXField == 1) {
        [_value1Label setText:@"x"];
        [_value2Label setText:@"a"];
        [_value3Label setText:@"b"];
        [_value4Label setText:@"c"];
        [self disableField:_value1Field];
    }
    
    [_resultField setText:nil];
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
    if ([self allValuesAvailable]) {
        CGFloat a = [[_value1Field text] floatValue];
        CGFloat b = [[_value2Field text] floatValue];
        CGFloat c = [[_value3Field text] floatValue];
        CGFloat d = [[_value4Field text] floatValue];
        CGFloat x = 0;
        if (_currentXField == 4) {
            x = ((c * b) / a);
        }
        [_resultField setText:[NSString stringWithFormat:@"%.3f", x]];
    }
    else {
        [_resultField setText:nil];
    }
}

#pragma mark Creating elements

- (void)createTypeSelector {
    _propType = PCProportionCalculatorViewPropTypeProportional;
    NSArray *itemArray = [NSArray arrayWithObjects:PCLangGet(@"PROPORT"), PCLangGet(@"DISPROP"), nil];
    _typeSelector = [[UISegmentedControl alloc] initWithItems:itemArray];
    [_typeSelector addTarget:self action:@selector(didSwitchProportionType:) forControlEvents:UIControlEventValueChanged];
    [_typeSelector setFrame:CGRectMake(0, 20, 288, 48)];
    [self addSubview:_typeSelector];
    [_typeSelector centerHorizontally];
    [_typeSelector setSelectedSegmentIndex:_propType];
}

- (PCValueTextField *)valueTextFieldForPosition:(CGPoint)origin {
    PCValueTextField *tf = [[PCValueTextField alloc] initWithFrame:CGRectMake(origin.x, origin.y, 91, 54)];
    [tf setDelegate:self];
    [tf setText:@"345"];
    return tf;
}

- (void)createValueFields {
    _currentXField = 4;
    
    _value1Field = [self valueTextFieldForPosition:CGPointMake(54, 139)];
    [self addSubview:_value1Field];
    
    _value2Field = [self valueTextFieldForPosition:CGPointMake(180, 139)];
    [self addSubview:_value2Field];
    
    _value3Field = [self valueTextFieldForPosition:CGPointMake(54, 209)];
    [self addSubview:_value3Field];
    
    _value4Field = [self valueTextFieldForPosition:CGPointMake(180, 209)];
    [self addSubview:_value4Field];
}

- (UILabel *)valueLabelForPosition:(CGPoint)origin {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(origin.x, origin.y, 30, 30)];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setShadowColor:[UIColor lightGrayColor]];
    [label setShadowOffset:CGSizeMake(1, 1)];
    [label setUserInteractionEnabled:YES];
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
    _resultField = [[PCResultTextField alloc] initWithFrame:CGRectMake(0, (self.height - 82), 200, 62)];
    [_resultField setBackground:[UIImage imageNamed:@"PC_result_field"]];
    [_resultField setEnabled:NO];
    [_resultField setTextAlignment:NSTextAlignmentRight];
    [_resultField setText:nil];
    //[_resultField setPlaceholder:PCLangGet(@"RESULT")];
    [_resultField setFont:[UIFont boldSystemFontOfSize:50]];
    [_resultField setMinimumFontSize:6];
    [_resultField setAdjustsFontSizeToFitWidth:YES];
    [_resultField setTextColor:[UIColor colorWithHexString:@"303030"]];
    [_resultField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self addSubview:_resultField];
    [_resultField centerHorizontally];
}

- (void)putTapRecognizerOnLabel:(UILabel *)label {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTapValueLabel:)];
    [doubleTap setNumberOfTapsRequired:2];
    [label addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapValueLabel:)];
    [tap requireGestureRecognizerToFail:doubleTap];
    [label addGestureRecognizer:tap];
}

- (void)addGestureRecognizers {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhereToDismissKeyboard:)];
    [self addGestureRecognizer:tap];
    
    [self putTapRecognizerOnLabel:_value1Label];
    [self putTapRecognizerOnLabel:_value2Label];
    [self putTapRecognizerOnLabel:_value3Label];
    [self putTapRecognizerOnLabel:_value4Label];
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

- (void)resignFirstResponders {
    if ([_value1Field isFirstResponder]) [_value1Field resignFirstResponder];
    if ([_value2Field isFirstResponder]) [_value2Field resignFirstResponder];
    if ([_value3Field isFirstResponder]) [_value3Field resignFirstResponder];
    if ([_value4Field isFirstResponder]) [_value4Field resignFirstResponder];
    if ([_resultField isFirstResponder]) [_resultField resignFirstResponder];
}

- (void)didTapAnywhereToDismissKeyboard:(UITapGestureRecognizer *)recognizer {
    [self resignFirstResponders];
}

- (void)didTapValueLabel:(UITapGestureRecognizer *)recognizer {
    UILabel *l = (UILabel *)recognizer.view;
    if ([l.text isEqualToString:@"x"]) return;
    if (l == _value1Label) {
        [_value1Field setText:nil];
    }
    else if (l == _value2Label) {
        [_value2Field setText:nil];
    }
    else if (l == _value3Label) {
        [_value3Field setText:nil];
    }
    else if (l == _value4Label) {
        [_value4Field setText:nil];
    }
    [self resignFirstResponders];
}

- (void)didDoubleTapValueLabel:(UITapGestureRecognizer *)recognizer {
    if (recognizer.view == _value1Label) {
        _currentXField = 1;
    }
    else if (recognizer.view == _value2Label) {
        _currentXField = 2;
    }
    else if (recognizer.view == _value3Label) {
        _currentXField = 3;
    }
    else if (recognizer.view == _value4Label) {
        _currentXField = 4;
    }
    [self showRightLabels];
    [self resignFirstResponders];
}

#pragma mark Actions

- (void)didSwitchProportionType:(UISegmentedControl *)sender {
    _propType = sender.selectedSegmentIndex;
    [self recalculate];
    [self showRightArrows];
    [self resignFirstResponders];
}

#pragma mark Text field delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL ok = [string isEqualToString:filtered];
    [self recalculate];
    return ok;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (![super isBigPhone]) [self setYOrigin:-50];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (![super isBigPhone]) [self setYOrigin:0];
}


@end
