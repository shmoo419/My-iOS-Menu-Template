//
//  Hack.mm
//  ModMenuTemplate
//
//  Created by Justin on 4/22/17.
//  Copyright © 2017 Justin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <vector>
#import "ModMenu.h"
#import "Hack.h"
#import "InfoView.h"

@implementation Hack {
    NSString *hackName;
    NSString *info;
    NSString *fontName;
    NSString *prefKey;
    
    UIColor *theme;
    
    std::vector<uint64_t> offsets;
    std::vector<uint64_t> hackedHexes;
    std::vector<uint64_t> originalHexes;
    
    bool hackOn;
}

static float spacing = [ModMenu getSpacing];

UILabel *hackNameLabel;

- (id)initWithHackName:(NSString *)hackName_ info:(NSString *)info_ fontName:(NSString *)fontName_ theme:(UIColor *)theme_ offset:(std::vector<uint64_t>)offsets_ hackedHex:(std::vector<uint64_t>)hackedHexes_ originalHex:(std::vector<uint64_t>)originalHexes_ {
    hackName = hackName_;
    info = info_;
    fontName = fontName_;
    theme = theme_;
    offsets = offsets_;
    hackedHexes = hackedHexes_;
    originalHexes = originalHexes_;
    
    prefKey = hackName;
    
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:[NSString stringWithFormat:@"%@_info", hackName]];
    
    self = [super initWithFrame:CGRectMake(0, spacing, 358, 28)];
    self.backgroundColor = [UIColor blackColor];
    self.layer.borderWidth = 2;
    
    [ModMenu setSpacing:[ModMenu getSpacing]+28];
    
    hackNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 265, 28)];
    hackNameLabel.text = hackName;
    hackNameLabel.textColor = [UIColor whiteColor];
    hackNameLabel.font = [UIFont fontWithName:fontName size:16];
    hackNameLabel.adjustsFontSizeToFitWidth = true;
    hackNameLabel.minimumScaleFactor = 0.1;
    [self addSubview:hackNameLabel];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake(275, 5, 18, 18);
    infoButton.tintColor = [UIColor whiteColor];
    [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchDown];
    [self addSubview:infoButton];
    
    return self;
}

- (void)showInfo {
    InfoView *iv = [[InfoView alloc] init:hackName description:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_info", hackName]] font:fontName theme:theme];
    [InfoView showInfoView:iv];
}

- (NSString *)getPrefKey {
    return prefKey;
}

- (UIColor *)getThemeColor {
    return theme;
}

- (std::vector<uint64_t>)getOffsets {
    return offsets;
}

- (std::vector<uint64_t>)getHackedHexes {
    return hackedHexes;
}

- (std::vector<uint64_t>)getOriginalHexes {
    return originalHexes;
}

- (void)setHackOn:(bool)hackOn_ {
    hackOn = hackOn_;
}

- (bool)getHackOn {
    return hackOn;
}

+ (void)setSpacing:(float)spacing_ {
    spacing = spacing_;
}

+ (float)getSpacing {
    return spacing;
}

@end
