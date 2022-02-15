//
//  TextfieldHook.h
//  ModMenuTemplate
//
//  Created by Justin on 4/30/17.
//  Copyright © 2017 Justin. All rights reserved.
//

#import "Hook.h"

@interface TextfieldHook : Hook<UITextFieldDelegate>

- (id)initWithTextfieldHookName:(NSString *)name info:(NSString *)info_ fontName:(NSString *)fontName_ theme:(UIColor *)theme_ offset:(uint64_t)offset_;

- (void)setTextfieldHookFrame:(CGRect)frame;
- (void)setTextfieldObjectFrame:(CGRect)frame;
- (void)setTriangleTransform:(CATransform3D)transform;
- (void)setTextfieldAlpha:(float)alpha;
- (void)setTextfieldShowing:(bool)sliderShowing_;

- (CGRect)getTextfieldHookFrame;
- (CGRect)getTextfieldObjectFrame;
- (CATransform3D)getTriangleTransform;

- (CAShapeLayer *)getTriangle;

- (bool)getIsTextfieldShowing;

+ (NSString *)getTextfieldValueForHook:(NSString *)name;

@end
