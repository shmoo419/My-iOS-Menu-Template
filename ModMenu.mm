//
//  ModMenu.mm
//  ModMenuTemplate
//
//  Created by Justin on 4/22/17.
//  Copyright © 2017 Justin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModMenu.h"
#import "SliderHook.h"
#import "TextfieldHook.h"
#import "writeData.h"

@implementation ModMenu {
    NSString *titleString;
    NSString *creditsString;
    NSString *font;
    
    UIColor *theme;

    CGPoint lastLocation;
}

float scrollViewHeight = 0;

NSUserDefaults *defaults;

UILabel *credits;
UILabel *title;

UIScrollView *hacksScrollView;

UIView *dragCheckView;

- (id)initWithTitle:(NSString *)title_ credits:(NSString *)credits_ fontName:(NSString *)fontName_ theme:(UIColor *)theme_ {
    titleString = title_;
    creditsString = credits_;
    font = fontName_;
    theme = theme_;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    UIView *mainView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    CGFloat width = mainView.frame.size.width;
    CGFloat height = mainView.frame.size.height;
    
    self = [super initWithFrame:CGRectMake(0, -18, 300, height+18)];
    self.center = mainView.center;
    self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = 8;
    self.layer.borderColor = theme.CGColor;
    self.layer.borderWidth = 2;
    self.alpha = 0;
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 286, 50)];
    title.text = titleString;
    title.font = [UIFont fontWithName:font size:17];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.adjustsFontSizeToFitWidth = true;
    title.minimumScaleFactor = 0.1;
    [self addSubview:title];
    
    credits = [[UILabel alloc] initWithFrame:CGRectMake(8, 40, 286, 37)];
    credits.text = creditsString;
    credits.font = [UIFont fontWithName:font size:17];
    credits.textColor = [UIColor whiteColor];
    credits.textAlignment = NSTextAlignmentCenter;
    credits.adjustsFontSizeToFitWidth = true;
    credits.minimumScaleFactor = 0.1;
    [self addSubview:credits];

    hacksScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height-(-85+height), 300, height-125)];
    hacksScrollView.backgroundColor = [UIColor clearColor];
    hacksScrollView.layer.borderWidth = 0;
    [self addSubview:hacksScrollView];

    dragCheckView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 95)];
    dragCheckView.backgroundColor = [UIColor clearColor];
    [self addSubview:dragCheckView];
     
    UIPanGestureRecognizer *dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [dragCheckView addGestureRecognizer:dragRecognizer];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(110, height-30, 79, 30);
    closeButton.backgroundColor = [UIColor clearColor];
    closeButton.layer.cornerRadius = 8;
    closeButton.layer.borderWidth = 2;
    closeButton.layer.borderColor = theme.CGColor;
    closeButton.font = [UIFont fontWithName:font size:15];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchDown];
    [self addSubview:closeButton];
    
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-10);
    verticalMotionEffect.maximumRelativeValue = @(10);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-10);
    horizontalMotionEffect.maximumRelativeValue = @(10);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [self addMotionEffect:group];
    
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.8;
    }];
    
    for(Hack *h in hacksScrollView.subviews){
        if([h isKindOfClass:[Hack class]]){
            std::vector<uint64_t> offsets = [h getOffsets];
            std::vector<uint64_t> hexes = [h getHackedHexes];
            std::vector<uint64_t> origHexes = [h getOriginalHexes];
            
            if([defaults boolForKey:[h getPrefKey]]){
                h.backgroundColor = theme;
                
                for(int i=0; i<offsets.size(); i++){
                    writeData(offsets[i], hexes[i]);
                }
            }
            else{
                h.backgroundColor = [UIColor blackColor];
                
                for(int i=0; i<offsets.size(); i++){
                    writeData(offsets[i], origHexes[i]);
                }
            }
        }
    }
    
    for(Hook *h in hacksScrollView.subviews){
        if(![h isKindOfClass:[SliderHook class]] && ![h isKindOfClass:[TextfieldHook class]] && [h isKindOfClass:[Hook class]]){
            if([defaults boolForKey:[h getPrefKey]]){
                h.backgroundColor = theme;
            }
            else{
                h.backgroundColor = [UIColor blackColor];
            }
        }
    }
    
    hacksScrollView.contentSize = CGSizeMake(0, scrollViewHeight);
}

- (void)hackToggled:(Hack *)hack {
    std::vector<uint64_t> offsets = [hack getOffsets];
    std::vector<uint64_t> hexes = [hack getHackedHexes];
    std::vector<uint64_t> origHexes = [hack getOriginalHexes];
    
    bool newHackOnFlag = ![hack getHackOn];
    
    [hack setHackOn:newHackOnFlag];
    
    if(newHackOnFlag){
        for(int i=0; i<offsets.size(); i++){
            writeData(offsets[i], hexes[i]);
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            hack.backgroundColor = theme;
        }];
    }
    else{
        for(int i=0; i<offsets.size(); i++){
            writeData(offsets[i], origHexes[i]);
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            hack.backgroundColor = [UIColor blackColor];
        }];
    }
    
    [defaults setBool:newHackOnFlag forKey:[hack getPrefKey]];
}

- (void)hookToggled:(Hook *)hook {
    bool newHookOnFlag = ![hook getHookOn];
    
    [hook setHookOn:newHookOnFlag];
    
    if(newHookOnFlag){
        [UIView animateWithDuration:0.2 animations:^{
            hook.backgroundColor = theme;
        }];
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            hook.backgroundColor = [UIColor blackColor];
        }];
    }
    
    [defaults setBool:newHookOnFlag forKey:[hook getPrefKey]];
}

- (void)showSlider:(SliderHook *)sliderHook {
    bool isSliderShowing = ![sliderHook getIsSliderShowing];
    
    if(isSliderShowing){
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveLinear) animations:^{
            CGRect expandedFrame = [sliderHook getSliderHookFrame];
            CGRect expandedSliderFrame = [sliderHook getSliderObjectFrame];
            CGRect expandedLabelFrame = [sliderHook getSliderLabelFrame];
            
            expandedFrame.size.height+=50;
            expandedSliderFrame.origin.y+=28;
            expandedLabelFrame.origin.y+=52;
            
            CATransform3D triangleTransform = [sliderHook getTriangleTransform];
            CATransform3D newTransform = CATransform3DRotate(triangleTransform, 180 * M_PI/180, 0, 0, 1);
            
            [sliderHook setTriangleTransform:newTransform];
            [sliderHook setSliderHookFrame:expandedFrame];
            [sliderHook setSliderObjectFrame:expandedSliderFrame];
            [sliderHook setSliderLabelFrame:expandedLabelFrame];
            [sliderHook setSliderAlpha:1];
            [sliderHook setSliderLabelAlpha:1];
            
            sliderHook.backgroundColor = theme;
            
            [hacksScrollView addSubview:sliderHook];
        }completion:^(BOOL finished){
            
        }];
    }
    else{
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveLinear) animations:^{
            CGRect originalFrame = [sliderHook getSliderHookFrame];
            CGRect expandedSliderFrame = [sliderHook getSliderObjectFrame];
            CGRect expandedLabelFrame = [sliderHook getSliderLabelFrame];
            
            originalFrame.size.height-=50;
            expandedSliderFrame.origin.y-=28;
            expandedLabelFrame.origin.y-=52;
            
            CATransform3D triangleTransform = [sliderHook getTriangleTransform];
            CATransform3D newTransform = CATransform3DRotate(triangleTransform, 180 * M_PI/180, 0, 0, 1);
            
            [sliderHook setTriangleTransform:newTransform];
            [sliderHook setSliderHookFrame:originalFrame];
            [sliderHook setSliderObjectFrame:expandedSliderFrame];
            [sliderHook setSliderLabelFrame:expandedLabelFrame];
            [sliderHook setSliderAlpha:0];
            [sliderHook setSliderLabelAlpha:0];
            
            sliderHook.backgroundColor = [UIColor blackColor];
            
            [hacksScrollView addSubview:sliderHook];
        }completion:^(BOOL finished){
            
        }];
    }
    
    [sliderHook setIsSliderShowing:isSliderShowing];
}

- (void)showTextfield:(TextfieldHook *)textfieldHook {
    bool isTextfieldShowing = ![textfieldHook getIsTextfieldShowing];
    
    if(isTextfieldShowing){
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveLinear) animations:^{
            CGRect expandedFrame = [textfieldHook getTextfieldHookFrame];
            CGRect expandedSliderFrame = [textfieldHook getTextfieldObjectFrame];
            
            expandedFrame.size.height+=40;
            expandedSliderFrame.origin.y+=28;
            
            CATransform3D triangleTransform = [textfieldHook getTriangleTransform];
            CATransform3D newTransform = CATransform3DRotate(triangleTransform, 180 * M_PI/180, 0, 0, 1);
            
            [textfieldHook setTriangleTransform:newTransform];
            [textfieldHook setTextfieldHookFrame:expandedFrame];
            [textfieldHook setTextfieldObjectFrame:expandedSliderFrame];
            [textfieldHook setTextfieldAlpha:1];
            
            textfieldHook.backgroundColor = theme;
            
            [hacksScrollView addSubview:textfieldHook];
        }completion:^(BOOL finished){
            
        }];
    }
    else{
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveLinear) animations:^{
            CGRect originalFrame = [textfieldHook getTextfieldHookFrame];
            CGRect expandedSliderFrame = [textfieldHook getTextfieldObjectFrame];
            
            originalFrame.size.height-=40;
            expandedSliderFrame.origin.y-=28;
            
            CATransform3D triangleTransform = [textfieldHook getTriangleTransform];
            CATransform3D newTransform = CATransform3DRotate(triangleTransform, 180 * M_PI/180, 0, 0, 1);
            
            [textfieldHook setTriangleTransform:newTransform];
            [textfieldHook setTextfieldHookFrame:originalFrame];
            [textfieldHook setTextfieldObjectFrame:expandedSliderFrame];
            [textfieldHook setTextfieldAlpha:0];
            
            textfieldHook.backgroundColor = [UIColor blackColor];
            
            [hacksScrollView addSubview:textfieldHook];
        }completion:^(BOOL finished){
            
        }];
    }
    
    [textfieldHook setTextfieldShowing:isTextfieldShowing];
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:0];
    }];
}

- (void)addHack:(Hack *)hack {
    [hack addTarget:self action:@selector(hackToggled:) forControlEvents:UIControlEventTouchDown];
    
    scrollViewHeight+=20;

    std::vector<uint64_t> offsets = [hack getOffsets];
    std::vector<uint64_t> hexes = [hack getHackedHexes];
    std::vector<uint64_t> origHexes = [hack getOriginalHexes];

    if([defaults boolForKey:[hack getPrefKey]]){
        for(int i=0; i<offsets.size(); i++){
            writeData(offsets[i], hexes[i]);
        }
    }
    else{
        for(int i=0; i<offsets.size(); i++){
            writeData(offsets[i], origHexes[i]);
        }
    }

    [hacksScrollView addSubview:hack];
}

- (void)addHook:(Hook *)hook {
    if([hook isKindOfClass:[SliderHook class]]){
        [hook addTarget:self action:@selector(showSlider:) forControlEvents:UIControlEventTouchDown];
    }
    else if([hook isKindOfClass:[TextfieldHook class]]){
        [hook addTarget:self action:@selector(showTextfield:) forControlEvents:UIControlEventTouchDown];
    }
    else{
        [hook addTarget:self action:@selector(hookToggled:) forControlEvents:UIControlEventTouchDown];
    }
    
    scrollViewHeight+=20;
    
    [hacksScrollView addSubview:hook];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    lastLocation = CGPointMake(self.frame.origin.x, self.frame.origin.y);

    [super touchesBegan:touches withEvent:event];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint newPoint = [pan translationInView:self];
    
    self.frame = CGRectMake(lastLocation.x + newPoint.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

+ (void)setSpacing:(float)spacing_ {
    [Hack setSpacing:spacing_];
}

+ (float)getSpacing {
    return [Hack getSpacing];
}
@end