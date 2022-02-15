//
//  ModMenu.h
//  ModMenuTemplate
//
//  Created by Justin on 4/22/17.
//  Copyright © 2017 Justin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hook.h"
#import "Hack.h"

@class SliderHook;

@interface ModMenu : UIView

- (id)initWithTitle:(NSString *)title_ credits:(NSString *)credits_ fontName:(NSString *)fontName_ theme:(UIColor *)theme_;

- (void)handlePan:(UIPanGestureRecognizer *)pan;

- (void)addHack:(Hack *)hack;
- (void)hackToggled:(Hack *)hack;
- (void)addHook:(Hook *)hook;
- (void)hookToggled:(Hook *)hook;
- (void)showSlider:(SliderHook *)sliderHook;
- (void)show;
- (void)hide;

+ (void)setSpacing:(float)spacing_;
+ (float)getSpacing;

@end
