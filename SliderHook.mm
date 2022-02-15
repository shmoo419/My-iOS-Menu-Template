//
//  SliderHook.mm
//  ModMenuTemplate
//
//  Created by Justin on 4/29/17.
//  Copyright © 2017 Justin. All rights reserved.
//

#import "SliderHook.h"

@implementation SliderHook {
    CAShapeLayer *triangle;
    UILabel *sliderValueLabel;
    UISlider *slider;

    float sliderValue;
    bool sliderShowing;
}

NSUserDefaults *prefs;

- (id)initWithSliderHookName:(NSString *)name info:(NSString *)info_ fontName:(NSString *)fontName_ theme:(UIColor *)theme_ offset:(uint64_t)offset_ minValue:(float)minValue_ maxValue:(float)maxValue_ {
    prefs = [NSUserDefaults standardUserDefaults];
    triangle = [self getTriangle];
    
    self = [super initWithHookName:name info:info_ fontName:fontName_ theme:theme_ offset:offset_];
    self.backgroundColor = [UIColor blackColor];
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 3, 265, 20)];
    slider.minimumValue = minValue_;
    slider.maximumValue = maxValue_;
    slider.minimumTrackTintColor = [UIColor blackColor];
    slider.maximumTrackTintColor = [UIColor blackColor];
    slider.alpha = 0;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:slider];
    
    slider.value = [prefs floatForKey:[super getPrefKey]];
    
    sliderValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 265, 20)];
    sliderValueLabel.text = [NSString stringWithFormat:@"%.2f", [prefs floatForKey:[super getPrefKey]]];
    sliderValueLabel.font = [UIFont fontWithName:fontName_ size:16];
    sliderValueLabel.textAlignment = NSTextAlignmentLeft;
    sliderValueLabel.textColor = [UIColor blackColor];
    sliderValueLabel.alpha = 0;
    [self addSubview:sliderValueLabel];
    
    [self.layer addSublayer:triangle];
    
    return self;
}

- (void)sliderValueChanged:(UISlider *)slider_ {
    sliderValue = slider_.value;
    
    sliderValueLabel.text = [NSString stringWithFormat:@"%.2f", sliderValue];
    
    [prefs setFloat:sliderValue forKey:[super getPrefKey]];
}

- (void)setSliderHookFrame:(CGRect)frame {
    self.frame = frame;
    
    CGColorRef color = [[super getThemeColor] CGColor];
    
    const CGFloat *components = CGColorGetComponents(color);
    
    //get the inverse of whatever color is the theme for a cool drop down effect
    self.backgroundColor = [[UIColor alloc] initWithRed:(1-components[0]) green:(1-components[1]) blue:(1-components[2]) alpha:1];
}

- (void)setIsSliderShowing:(bool)sliderShowing_ {
    sliderShowing = sliderShowing_;
}

- (void)setSliderObjectFrame:(CGRect)frame {
    slider.frame = frame;
}

- (void)setSliderAlpha:(float)alpha {
    slider.alpha = alpha;
}

- (void)setSliderLabelFrame:(CGRect)frame {
    sliderValueLabel.frame = frame;
}

- (void)setSliderLabelAlpha:(float)alpha {
    sliderValueLabel.alpha = alpha;
}

- (void)setTriangleTransform:(CATransform3D)transform {
    triangle.transform = transform;
}

- (CATransform3D)getTriangleTransform {
    return triangle.transform;
}

- (CGRect)getSliderLabelFrame {
    return sliderValueLabel.frame;
}

- (CGRect)getSliderHookFrame {
    return self.frame;
}

- (CGRect)getSliderObjectFrame {
    return slider.frame;
}

- (bool)getIsSliderShowing {
    return sliderShowing;
}

- (float)getSliderValue {
    return sliderValue;
}

- (CAShapeLayer *)getTriangle {
    CAShapeLayer *triangleShapeLayer = [CAShapeLayer layer];
    UIBezierPath *triangleBezierPath = [UIBezierPath bezierPath];
    CGRect bounds = CGRectMake(255, 5.5, 20, 20);
    CGFloat radius = (bounds.size.width - 12) / 2;
    CGFloat a = radius * sqrt((CGFloat)3.0) / 2;
    CGFloat b = radius / 2;
    [triangleBezierPath moveToPoint:CGPointMake(0, radius)];
    [triangleBezierPath addLineToPoint:CGPointMake(-a, -b)];
    [triangleBezierPath addLineToPoint:CGPointMake(a, -b)];
    
    [triangleBezierPath closePath];
    [triangleBezierPath applyTransform:CGAffineTransformMakeTranslation(CGRectGetMidX(bounds), CGRectGetMidY(bounds)-2.75)];
    triangleShapeLayer.path = triangleBezierPath.CGPath;
    
    triangleShapeLayer.bounds = bounds;
    triangleShapeLayer.frame = CGRectMake(255, 5.5, 20, 20);
    triangleShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    triangleShapeLayer.fillColor = [UIColor whiteColor].CGColor;
    
    return triangleShapeLayer;
}

+ (float)getSliderValueForHook:(NSString *)name {
    return [prefs floatForKey:name];
}

@end
