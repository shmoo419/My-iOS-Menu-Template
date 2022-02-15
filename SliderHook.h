//
//  SliderHook.h
//  ModMenuTemplate
//
//  Created by Justin on 4/29/17.
//  Copyright © 2017 Justin. All rights reserved.
//

#import "Hook.h"

@interface SliderHook : Hook

- (id)initWithSliderHookName:(NSString *)name info:(NSString *)info_ fontName:(NSString *)fontName_ theme:(UIColor *)theme_ offset:(uint64_t)offset_ minValue:(float)minValue_ maxValue:(float)maxValue_;

- (void)setSliderHookFrame:(CGRect)frame;
- (void)setSliderObjectFrame:(CGRect)frame;
- (void)setSliderLabelFrame:(CGRect)frame;
- (void)setTriangleTransform:(CATransform3D)transform;
- (void)setSliderLabelAlpha:(float)alpha;
- (void)setSliderAlpha:(float)alpha;
- (void)setIsSliderShowing:(bool)sliderShowing_;

- (CGRect)getSliderHookFrame;
- (CGRect)getSliderObjectFrame;
- (CGRect)getSliderLabelFrame;
- (CATransform3D)getTriangleTransform;

- (CAShapeLayer *)getTriangle;

- (bool)getIsSliderShowing;
- (float)getSliderValue;

+ (float)getSliderValueForHook:(NSString *)name;

@end
