//
//  Hook.h
//  ModMenuTemplate
//
//  Created by Justin on 4/29/17.
//  Copyright © 2017 Justin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModMenu.h"

@interface Hook : UIButton

- (id)initWithHookName:(NSString *)hookName_ info:(NSString *)info_ fontName:(NSString *)fontName_ theme:(UIColor *)theme_ offset:(uint64_t)offset_;

- (void)setHookOn:(bool)hookOn_;
- (void)showInfo;

- (NSString *)getPrefKey;
- (bool)getHookOn;
- (UIColor *)getThemeColor;

+ (bool)getHookOnForHook:(NSString *)name;

@end
