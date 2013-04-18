//
//  PCProportionCalculatorView.h
//  ProportionCalculator
//
//  Created by Ondrej Rafaj on 24/03/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "PCView.h"
#import "PCValueTextField.h"


typedef enum {
    PCProportionCalculatorViewPropTypeProportional,
    PCProportionCalculatorViewPropTypeDisproportional
} PCProportionCalculatorViewPropType;

typedef enum {
    PCProportionCalculatorViewDirectionMoveUp,
    PCProportionCalculatorViewDirectionMoveDown
} PCProportionCalculatorViewDirectionMove;


@class PCProportionCalculatorView;

@protocol PCProportionCalculatorViewDelegate <NSObject>

- (void)proportionCalculatorView:(PCProportionCalculatorView *)view requiresToMoveInDirection:(PCProportionCalculatorViewDirectionMove)direction;
- (void)proportionCalculatorViewRequestsKeyboard:(PCProportionCalculatorView *)view;
- (void)proportionCalculatorViewRequestsKeyboardToBeDismissed:(PCProportionCalculatorView *)view;

@end


@interface PCProportionCalculatorView : PCView <UITextFieldDelegate>

@property (nonatomic, readonly) PCProportionCalculatorViewPropType propType;
@property (nonatomic, weak) id <PCProportionCalculatorViewDelegate> delegate;

@property (nonatomic, strong) PCValueTextField *currentlyEditedTextField;

- (void)recalculate;


@end
