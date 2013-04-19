//
//  PCProportionCalculatorView.m
//  ProportionCalculator
//
//  Created by Ondrej Rafaj on 24/03/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "PCProportionCalculatorView.h"
#import "PCResultTextField.h"


@interface PCProportionCalculatorView ()

@property (nonatomic, strong) UISegmentedControl *typeSelector;

@property (nonatomic, strong) PCValueTextField *value1Field;
@property (nonatomic, strong) PCValueTextField *value2Field;
@property (nonatomic, strong) PCValueTextField *value3Field;
@property (nonatomic, strong) PCValueTextField *value4Field;

@property (nonatomic, strong) UIImageView *value1FieldBcg;
@property (nonatomic, strong) UIImageView *value2FieldBcg;
@property (nonatomic, strong) UIImageView *value3FieldBcg;
@property (nonatomic, strong) UIImageView *value4FieldBcg;

@property (nonatomic, strong) UILabel *value1Label;
@property (nonatomic, strong) UILabel *value2Label;
@property (nonatomic, strong) UILabel *value3Label;
@property (nonatomic, strong) UILabel *value4Label;

@property (nonatomic, strong) UIImageView *leftArrow;
@property (nonatomic, strong) UIImageView *rightArrow;

@property (nonatomic, strong) UILabel *calculationsLabel;

@property (nonatomic, strong) PCResultTextField *resultField;
@property (nonatomic, strong) UILabel *explanationLabel;

@property (nonatomic) NSInteger currentXField;

@end


@implementation PCProportionCalculatorView

#pragma mark Calculations & related

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
    
    NSString *calc;
    if (_propType == PCProportionCalculatorViewPropTypeProportional) {
        if (_currentXField == 1) calc = @"x = ((b * a) / c)";
        else if (_currentXField == 2) calc = @"x = ((a * c) / b)";
        else if (_currentXField == 3) calc = @"x = ((a * c) / b)";
        else if (_currentXField == 4) calc = @"x = ((c * b) / a)";
    }
    else {
        if (_currentXField == 1) calc = @"x = ((b * c) / a)";
        else if (_currentXField == 2) calc = @"x = ((b * c) / a)";
        else if (_currentXField == 3) calc = @"x = ((a * b) / c)";
        else if (_currentXField == 4) calc = @"x = ((a * b) / c)";
    }
    [UIView animateWithDuration:0.15 animations:^{
        [_calculationsLabel setAlpha:0];
    } completion:^(BOOL finished) {
        [_calculationsLabel setText:calc];
        [UIView animateWithDuration:0.15 animations:^{
            [_calculationsLabel setAlpha:1];
        }];
    }];
    
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
    [UIView animateWithDuration:0.15 animations:^{
        [_leftArrow setAlpha:0];
        [_rightArrow setAlpha:0];
    } completion:^(BOOL finished) {
        [_rightArrow setImage:img];
        [_rightArrow setYOrigin:yPos];
        [UIView animateWithDuration:0.15 animations:^{
            [_leftArrow setAlpha:1];
            [_rightArrow setAlpha:1];
        }];
    }];
}

- (void)recalculate {
    if ([self allValuesAvailable]) {
        double a = [[_value1Field realValueString] doubleValue];
        double b = [[_value2Field realValueString] doubleValue];
        double c = [[_value3Field realValueString] doubleValue];
        double d = [[_value4Field realValueString] doubleValue];
        double x = 0;
        NSString *calc;
        if (_propType == PCProportionCalculatorViewPropTypeProportional) {
            if (_currentXField == 1) {
                x = ((c * b) / d);
                calc = @"x = ((b * a) / c)";
            }
            else if (_currentXField == 2) {
                x = ((a * d) / c);
                calc = @"x = ((a * c) / b)";
            }
            else if (_currentXField == 3) {
                x = ((a * d) / b);
                calc = @"x = ((a * c) / b)";
            }
            else if (_currentXField == 4) {
                x = ((c * b) / a);
                calc = @"x = ((c * b) / a)";
            }
        }
        else {
            if (_currentXField == 1) {
                x = ((c * d) / b);
                calc = @"x = ((b * c) / a)";
            }
            else if (_currentXField == 2) {
                x = ((c * d) / a);
                calc = @"x = ((b * c) / a)";
            }
            else if (_currentXField == 3) {
                x = ((a * b) / d);
                calc = @"x = ((a * b) / c)";
            }
            else if (_currentXField == 4) {
                x = ((a * b) / c);
                calc = @"x = ((a * b) / c)";
            }
        }
        [_resultField setText:[NSString stringWithFormat:@"%.5g", x]];
    }
    else {
        [_resultField setText:nil];
    }
}

#pragma mark Creating elements

- (void)createTypeSelector {
    UIImage *segmentSelected = [[UIImage imageNamed:@"PC_bcg_segment_green"] stretchableImageWithLeftCapWidth:26 topCapHeight:26];
    UIImage *segmentUnselected = [[UIImage imageNamed:@"PC_bcg_segment_gray"] stretchableImageWithLeftCapWidth:26 topCapHeight:26];
    UIImage *emptyImg = [UIImage imageNamed:@"PC_transparent_1x48"];
    
    [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:segmentSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:emptyImg forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:emptyImg forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:emptyImg forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    _propType = PCProportionCalculatorViewPropTypeProportional;
    NSArray *itemArray = [NSArray arrayWithObjects:PCLangGet(@"PROPORT"), PCLangGet(@"DISPROP"), nil];
    _typeSelector = [[UISegmentedControl alloc] initWithItems:itemArray];
    
    UIFont *font = [UIFont boldSystemFontOfSize:14];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjects:@[font, [UIColor whiteColor], [UIColor clearColor]] forKeys:@[UITextAttributeFont, UITextAttributeTextColor, UITextAttributeTextShadowColor]];
    [_typeSelector setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [_typeSelector setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
    
    [_typeSelector addTarget:self action:@selector(didSwitchProportionType:) forControlEvents:UIControlEventValueChanged];
    [_typeSelector setFrame:CGRectMake(0, 20, 288, 48)];
    [self addSubview:_typeSelector];
    [_typeSelector centerHorizontally];
    [_typeSelector setSelectedSegmentIndex:_propType];
}

- (PCValueTextField *)valueTextFieldForPosition:(CGPoint)origin {
    PCValueTextField *tf = [[PCValueTextField alloc] initWithFrame:CGRectMake(origin.x, origin.y, 91, 54)];
    [tf setDelegate:self];
    [tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return tf;
}

- (void)createValueFields {
    _currentXField = 4;
    
    UIImage *img = [UIImage imageNamed:@"PC_active-field"];
    
    _value1FieldBcg = [[UIImageView alloc] initWithImage:img];
    [_value1FieldBcg setAlpha:0];
    [_value1FieldBcg setOrigin:CGPointMake(48, 135)];
    [self addSubview:_value1FieldBcg];
    
    _value1Field = [self valueTextFieldForPosition:CGPointMake(54, 139)];
    [self addSubview:_value1Field];
    
    _value2FieldBcg = [[UIImageView alloc] initWithImage:img];
    [_value2FieldBcg setAlpha:0];
    [_value2FieldBcg setOrigin:CGPointMake(174, 135)];
    [self addSubview:_value2FieldBcg];
    
    _value2Field = [self valueTextFieldForPosition:CGPointMake(180, 139)];
    [self addSubview:_value2Field];
    
    _value3FieldBcg = [[UIImageView alloc] initWithImage:img];
    [_value3FieldBcg setAlpha:0];
    [_value3FieldBcg setOrigin:CGPointMake(48, 205)];
    [self addSubview:_value3FieldBcg];
    
    _value3Field = [self valueTextFieldForPosition:CGPointMake(54, 209)];
    [self addSubview:_value3Field];
    
    _value4FieldBcg = [[UIImageView alloc] initWithImage:img];
    [_value4FieldBcg setAlpha:0];
    [_value4FieldBcg setOrigin:CGPointMake(174, 205)];
    [self addSubview:_value4FieldBcg];
    
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

- (void)createCalculationsLabel {
    _calculationsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_value4Label.bottom + ([self isBigPhone] ? 4 : 2)), 320, 20)];
    [_calculationsLabel setTextColor:[UIColor colorWithWhite:0 alpha:0.2]];
    [_calculationsLabel setBackgroundColor:[UIColor clearColor]];
    [_calculationsLabel setTextAlignment:NSTextAlignmentCenter];
    [_calculationsLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [self addSubview:_calculationsLabel];
}

- (void)createResultSection {
    _resultField = [[PCResultTextField alloc] initWithFrame:CGRectMake(0, (self.height - 82), 200, 62)];
    [_resultField setBackground:[UIImage imageNamed:@"PC_result_field"]];
    [_resultField setEnabled:NO];
    [_resultField setTextAlignment:NSTextAlignmentRight];
    [_resultField setText:nil];
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
    [self createCalculationsLabel];
    [self createResultSection];
    [self addGestureRecognizers];
}

#pragma mark Gesture recognizers

- (void)resignFirstResponders {    
    _currentlyEditedTextField = nil;
    [_value1Field setDefaultTextColor];
    [_value2Field setDefaultTextColor];
    [_value3Field setDefaultTextColor];
    [_value4Field setDefaultTextColor];
    [UIView animateWithDuration:0.3 animations:^{
        [_value1FieldBcg setAlpha:0];
        [_value2FieldBcg setAlpha:0];
        [_value3FieldBcg setAlpha:0];
        [_value4FieldBcg setAlpha:0];
    }];
    if ([_delegate respondsToSelector:@selector(proportionCalculatorViewRequestsKeyboardToBeDismissed:)]) {
        [_delegate proportionCalculatorViewRequestsKeyboardToBeDismissed:self];
    }
    if (![super isBigPhone] && [_delegate respondsToSelector:@selector(proportionCalculatorView:requiresToMoveInDirection:)]) {
        [_delegate proportionCalculatorView:self requiresToMoveInDirection:PCProportionCalculatorViewDirectionMoveDown];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [_calculationsLabel setYOrigin:(_value4Label.bottom + ([self isBigPhone] ? 4 : 2))];
    }];
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
    [self showRightLabels];
    [self showRightArrows];
    [self resignFirstResponders];
}

#pragma mark Text field delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _currentlyEditedTextField = (PCValueTextField *)textField;
    [_value1Field setLightTextColor];
    [_value2Field setLightTextColor];
    [_value3Field setLightTextColor];
    [_value4Field setLightTextColor];
    [UIView animateWithDuration:0.3 animations:^{
        [_value1FieldBcg setAlpha:0];
        [_value2FieldBcg setAlpha:0];
        [_value3FieldBcg setAlpha:0];
        [_value4FieldBcg setAlpha:0];
        if (_currentlyEditedTextField == _value1Field) {
            [_value1FieldBcg setAlpha:1];
        }
        else if (_currentlyEditedTextField == _value2Field) {
            [_value2FieldBcg setAlpha:1];
        }
        else if (_currentlyEditedTextField == _value3Field) {
            [_value3FieldBcg setAlpha:1];
        }
        else if (_currentlyEditedTextField == _value4Field) {
            [_value4FieldBcg setAlpha:1];
        }
    } completion:^(BOOL finished) {
        
    }];
    
    [_currentlyEditedTextField setDefaultTextColor];
    if ([_delegate respondsToSelector:@selector(proportionCalculatorViewRequestsKeyboard:)]) {
        [_delegate proportionCalculatorViewRequestsKeyboard:self];
    }
    return NO;
}

- (void)textFieldDidChange:(UITextField *)sender {
    [self recalculate];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.-"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL ok = [string isEqualToString:filtered];
    return ok;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self recalculate];
    if (![super isBigPhone] && [_delegate respondsToSelector:@selector(proportionCalculatorView:requiresToMoveInDirection:)]) {
        [_delegate proportionCalculatorView:self requiresToMoveInDirection:PCProportionCalculatorViewDirectionMoveUp];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [_calculationsLabel setYOrigin:(_value4Label.bottom - ([self isBigPhone] ? 4 : 10))];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self recalculate];
}


@end
