//
//  PCProportionCalculatorView.h
//  ProportionCalculator
//
//  Created by Ondrej Rafaj on 24/03/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "PCView.h"


typedef enum {
    PCProportionCalculatorViewPropTypeProportional,
    PCProportionCalculatorViewPropTypeDisproportional
} PCProportionCalculatorViewPropType;


@interface PCProportionCalculatorView : PCView

@property (nonatomic, readonly) PCProportionCalculatorViewPropType propType;


@end
