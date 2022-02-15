//
//  InfoView.h
//  ModMenuTemplate
//
//  Created by Justin on 5/2/17.
//  Copyright © 2017 Justin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoView : UIView

- (id)init:(NSString *)title_ description:(NSString *)description_ font:(NSString *)font_ theme:(UIColor *)theme_;

+ (void)showInfoView:(InfoView *)iv;
- (void)closeInfoView;

@end
