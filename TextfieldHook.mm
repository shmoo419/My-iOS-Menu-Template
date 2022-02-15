//
//  TextfieldHook.mm
//  ModMenuTemplate
//
//  Created by Justin on 4/30/17.
//  Copyright © 2017 Justin. All rights reserved.
//

#import "TextfieldHook.h"

@implementation TextfieldHook {
    CAShapeLayer *triangle;
    UITextField *textfield;
    
    bool textfieldShowing;
}

- (id)initWithTextfieldHookName:(NSString *)name info:(NSString *)info_ fontName:(NSString *)fontName_ theme:(UIColor *)theme_ offset:(uint64_t)offset_ {
    triangle = [self getTriangle];
    
    self = [super initWithHookName:name info:info_ fontName:fontName_ theme:theme_ offset:offset_];
    
    textfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 3, 265, 20)];
    textfield.font = [UIFont fontWithName:fontName_ size:14];
    textfield.backgroundColor = [UIColor clearColor];
    textfield.layer.borderColor = [UIColor blackColor].CGColor;
    textfield.layer.borderWidth = 1;
    textfield.layer.cornerRadius = 8;
    textfield.alpha = 0;
    textfield.delegate = self;
    [self addSubview:textfield];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:[super getPrefKey]] != nil){
        textfield.text = [[NSUserDefaults standardUserDefaults] objectForKey:[super getPrefKey]];
    }
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 105, 10)];
    [textfield setLeftViewMode:UITextFieldViewModeAlways];
    [textfield setLeftView:spacerView];
    
    [self.layer addSublayer:triangle];
    
    return self;
}

- (void)setTextfieldHookFrame:(CGRect)frame {
    self.frame = frame;
    
    CGColorRef color = [[super getThemeColor] CGColor];
    
    const CGFloat *components = CGColorGetComponents(color);
    
    //get the inverse of whatever color is the theme for a cool drop down effect
    self.backgroundColor = [[UIColor alloc] initWithRed:(1-components[0]) green:(1-components[1]) blue:(1-components[2]) alpha:1];
}

- (void)setTextfieldObjectFrame:(CGRect)frame {
    textfield.frame = frame;
}

- (void)setTextfieldAlpha:(float)alpha {
    textfield.alpha = alpha;
}

- (void)setTriangleTransform:(CATransform3D)transform {
    triangle.transform = transform;
}

- (CATransform3D)getTriangleTransform {
    return triangle.transform;
}

- (CGRect)getTextfieldHookFrame {
    return self.frame;
}

- (CGRect)getTextfieldObjectFrame {
    return textfield.frame;
}

- (void)setTextfieldShowing:(bool)textfieldShowing_ {
    if(!textfieldShowing_){
        [textfield resignFirstResponder];
    }
    
    textfieldShowing = textfieldShowing_;
}

- (bool)getIsTextfieldShowing {
    return textfieldShowing;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:[super getPrefKey]];
    
    [textField resignFirstResponder];
    
    return true;
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

+ (NSString *)getTextfieldValueForHook:(NSString *)name {
    return [[NSUserDefaults standardUserDefaults] objectForKey:name];
}

@end
