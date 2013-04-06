//
//  FTCalculatorKeyboardView.h
//  ProportionCalculator
//
//  Created by Ondrej Rafaj on 03/04/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    FTCalculatorKeyboardViewSpecialKeyTypeClear,
    FTCalculatorKeyboardViewSpecialKeyTypeErase,
    FTCalculatorKeyboardViewSpecialKeyTypePlusMinus,
    FTCalculatorKeyboardViewSpecialKeyTypeDot
}FTCalculatorKeyboardViewSpecialKeyType;


@class FTCalculatorKeyboardView;

@protocol FTCalculatorKeyboardViewDelegate <NSObject>

- (void)calculatorKeyboardView:(FTCalculatorKeyboardView *)view didClickNumberKeyWithValue:(NSInteger)value;
- (void)calculatorKeyboardView:(FTCalculatorKeyboardView *)view didClickSpecialKey:(FTCalculatorKeyboardViewSpecialKeyType)key;

@end

@interface FTCalculatorKeyboardView : UIView

@property (nonatomic, weak) id<FTCalculatorKeyboardViewDelegate> delegate;

- (void)show;
- (void)hide;


@end
