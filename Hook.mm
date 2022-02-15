//
//  Hook.mm
//  ModMenuTemplate
//
//  Created by Justin on 4/29/17.
//  Copyright © 2017 Justin. All rights reserved.
//

#import "Hook.h"
#import "SliderHook.h"
#import "TextfieldHook.h"
#import "InfoView.h"

@implementation Hook {
    NSString *hookName;
    NSString *info;
    NSString *fontName;
    NSString *prefKey;
    
    UIColor *theme;
    
    uint64_t offset;
    
    bool hookOn;
}

- (id)initWithHookName:(NSString *)hookName_ info:(NSString *)info_ fontName:(NSString *)fontName_ theme:(UIColor *)theme_ offset:(uint64_t)offset_ {
    hookName = hookName_;
    fontName = fontName_;
    theme = theme_;
    offset = offset_;
    info = info_;
    
    prefKey = hookName;
    
    NSLog(@"%@", info);
    
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:[NSString stringWithFormat:@"%@_info", hookName]];
    
    self = [super initWithFrame:CGRectMake(0, [ModMenu getSpacing], 358, 28)];
    self.backgroundColor = [UIColor blackColor];
    self.layer.borderWidth = 1;
    
    [ModMenu setSpacing:[ModMenu getSpacing]+28];
    
    UILabel *hookNameLabel;
    
    if([self isKindOfClass:[SliderHook class]] || [self isKindOfClass:[TextfieldHook class]]){
        hookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 265, 20)];
    }
    else{
        hookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 265, 20)];
    }
    
    hookNameLabel.text = hookName;
    hookNameLabel.textColor = [UIColor whiteColor];
    hookNameLabel.font = [UIFont fontWithName:fontName size:16];
    hookNameLabel.adjustsFontSizeToFitWidth = true;
    hookNameLabel.minimumScaleFactor = 0.1;
    [self addSubview:hookNameLabel];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake(275, 5, 18, 18);
    infoButton.tintColor = [UIColor whiteColor];
    [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchDown];
    [self addSubview:infoButton];
    
    return self;
}

- (void)showInfo {
    InfoView *iv = [[InfoView alloc] init:hookName description:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_info", hookName]] font:fontName theme:theme];
    [InfoView showInfoView:iv];
}

- (void)setHookOn:(bool)hookOn_ {
    hookOn = hookOn_;
}

- (bool)getHookOn {
    return hookOn;
}

- (NSString *)getPrefKey {
    return prefKey;
}

- (UIColor *)getThemeColor {
    return theme;
}

+ (bool)getHookOnForHook:(NSString *)name {
    return [[NSUserDefaults standardUserDefaults] boolForKey:name];
}

@end
