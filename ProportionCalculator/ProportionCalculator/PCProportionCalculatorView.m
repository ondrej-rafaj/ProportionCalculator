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

@property (nonatomic, strong) NSArray* valuesFields;
@property (nonatomic, strong) NSArray* valuesFieldBcgs;
@property (nonatomic, strong) NSArray* valuesLabels;

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
    __block BOOL ok=YES;
    [_valuesFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (((PCValueTextField*)obj).text.length==0) {
            ok=YES;
            *stop=YES;
        }
    }];
    return ok;
}

- (void)showRightLabels {
    __block NSUInteger currentCounter=0;
    NSArray* letterArray = @[@"a",@"b",@"c"];
    [_valuesLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx==(_currentXField-1)) {
            [obj setText:@"x"];
            [_valuesFields[idx] disable:YES];
        }
        else {
            [obj setText:letterArray[currentCounter]];
            [_valuesFields[idx] disable:NO];
            currentCounter++;
        }
    }];
    
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
    [_valuesLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_valuesFields[idx] setPlaceholder:[obj text]];
    }];
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
        double a = [[_valuesFields[0] realValueString] doubleValue];
        double b = [[_valuesFields[1] realValueString] doubleValue];
        double c = [[_valuesFields[2] realValueString] doubleValue];
        double d = [[_valuesFields[3] realValueString] doubleValue];
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
    NSMutableArray* auxFieldsArray = [NSMutableArray arrayWithCapacity:4];
    NSMutableArray* auxFieldBcgsArray = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i<4; i++) {
        CGFloat positionX = (i%2)?180:54;
        CGFloat positionY = (i<2)?139:209;
        PCValueTextField* field = [self valueTextFieldForPosition:CGPointMake(positionX, positionY)];
        field.tag = i;
        
        positionX = (i%2)?174:48;
        positionY = (i<2)?135:205;
        UIImageView* fieldBcg = [[UIImageView alloc] initWithImage:img];
        [fieldBcg setAlpha:0];
        [fieldBcg setOrigin:CGPointMake(positionX, positionY)];
        [self addSubview:fieldBcg];
        [auxFieldBcgsArray addObject:fieldBcg];
        [self addSubview:field];
        [auxFieldsArray addObject:field];
    }
    _valuesFields = [NSArray arrayWithArray:auxFieldsArray];
    _valuesFieldBcgs = [NSArray arrayWithArray:auxFieldBcgsArray];
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
    NSMutableArray* auxlabelsArray = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i<4; i++) {
        CGFloat positionX = (i%2)?(320 - 30 - 17):19;
        CGFloat positionY = (i<2)?102:272;
        UILabel* label = [self valueLabelForPosition:CGPointMake(positionX, positionY)];
        label.tag=i;
        [self addSubview:label];
        [auxlabelsArray addObject:label];
    }
    _valuesLabels = [NSArray arrayWithArray:auxlabelsArray];
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
    _calculationsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (((UIView*)_valuesLabels[3]).bottom + ([self isBigPhone] ? 4 : 2)), 320, 20)];
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
    [_valuesLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self putTapRecognizerOnLabel:obj];
    }];
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
    [_valuesFields makeObjectsPerformSelector:@selector(setDefaultTextColor)];
    [UIView animateWithDuration:0.3 animations:^{
        [_valuesFieldBcgs makeObjectsPerformSelector:@selector(setAlphaByObject:) withObject:@(0.0)];
    }];
    if ([_delegate respondsToSelector:@selector(proportionCalculatorViewRequestsKeyboardToBeDismissed:)]) {
        [_delegate proportionCalculatorViewRequestsKeyboardToBeDismissed:self];
    }
    if (![super isBigPhone] && [_delegate respondsToSelector:@selector(proportionCalculatorView:requiresToMoveInDirection:)]) {
        [_delegate proportionCalculatorView:self requiresToMoveInDirection:PCProportionCalculatorViewDirectionMoveDown];
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat yOrigin =(((UIView*)_valuesLabels[3]).bottom + ([self isBigPhone] ? 4 : 2));
        [_calculationsLabel setYOrigin:yOrigin];
    }];
}

- (void)didTapAnywhereToDismissKeyboard:(UITapGestureRecognizer *)recognizer {
    [self resignFirstResponders];
}

- (void)didTapValueLabel:(UITapGestureRecognizer *)recognizer {
    UILabel *l = (UILabel *)recognizer.view;
    if ([l.text isEqualToString:@"x"]) return;
    [_valuesFields[l.tag] setRealValueString:nil];
    [self resignFirstResponders];
}

- (void)didDoubleTapValueLabel:(UITapGestureRecognizer *)recognizer {
    _currentXField=recognizer.view.tag+1;
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
    NSUInteger currentTag = textField.tag;
    [_valuesFields makeObjectsPerformSelector:@selector(setLightTextColor)];
    [UIView animateWithDuration:0.3 animations:^{
        [_valuesFieldBcgs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx==currentTag) {
                [obj setAlpha:1.0];
            }
            else {
                [obj setAlpha:0.0];
            }
        }];
        CGFloat yOrigin =(((UIView*)_valuesLabels[3]).bottom -15);
        [_calculationsLabel setYOrigin:yOrigin];
    } completion:^(BOOL finished) {
        
    }];
    [_currentlyEditedTextField setDefaultTextColor];
    if ([_delegate respondsToSelector:@selector(proportionCalculatorViewRequestsKeyboard:)]) {
        [_delegate proportionCalculatorViewRequestsKeyboard:self];
    }
    return NO;
}

@end
