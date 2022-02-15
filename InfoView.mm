//
//  InfoView.mm
//  ModMenuTemplate
//
//  Created by Justin on 5/2/17.
//  Copyright © 2017 Justin. All rights reserved.
//

#import "InfoView.h"

@implementation InfoView {
    NSString *description;
}

- (id)init:(NSString *)title_ description:(NSString *)description_ font:(NSString *)font_ theme:(UIColor *)theme_ {
    description = description_;

    UIView *mainView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    self = [super initWithFrame:CGRectMake(199, 105, 269, 280)];
    self.center = mainView.center;
    self.alpha = 0.8;
    self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = 8;
    self.layer.borderWidth = 2;
    self.layer.borderColor = theme_.CGColor;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 253, 21)];
    title.text = title_;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:font_ size:14];
    title.adjustsFontSizeToFitWidth = true;
    title.minimumScaleFactor = 0.1;
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 30, 253, 112)];
    descriptionLabel.text = description;
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.font = [UIFont fontWithName:font_ size:14];
    descriptionLabel.adjustsFontSizeToFitWidth = true;
    descriptionLabel.minimumScaleFactor = 0.1;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.textAlignment = NSTextAlignmentLeft;
    [descriptionLabel sizeToFit];
    [self addSubview:descriptionLabel];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(95, 245, 79, 30);
    closeButton.backgroundColor = [UIColor clearColor];
    closeButton.layer.cornerRadius = 8;
    closeButton.layer.borderWidth = 2;
    closeButton.layer.borderColor = theme_.CGColor;
    closeButton.font = [UIFont fontWithName:font_ size:15];
    [closeButton setTitle:@"Done" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeInfoView) forControlEvents:UIControlEventTouchDown];
    [self addSubview:closeButton];
    
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-20);
    verticalMotionEffect.maximumRelativeValue = @(20);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [self addMotionEffect:group];
    
    return self;
}

+ (void)showInfoView:(InfoView *)iv {
    [[UIApplication sharedApplication].keyWindow addSubview:iv];
    
    iv.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:1.8 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveLinear) animations:^{
        iv.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished){
        
    }];
}

- (void)closeInfoView {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1.5 initialSpringVelocity:5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

@end
