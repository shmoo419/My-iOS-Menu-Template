//
//  Hack.h
//  ModMenuTemplate
//
//  Created by Justin on 4/22/17.
//  Copyright © 2017 Justin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <vector>

#define rgb(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

@class Hook;

@interface Hack : UIButton

- (id)initWithHackName:(NSString *)hackName_ info:(NSString *)info fontName:(NSString *)fontName_ theme:(UIColor *)theme_ offset:(std::vector<uint64_t>)offsets_ hackedHex:(std::vector<uint64_t>)hackedHexes_ originalHex:(std::vector<uint64_t>)originalHexes_;

- (void)setHackOn:(bool)hackOn_;

- (NSString *)getPrefKey;
- (bool)getHackOn;
- (std::vector<uint64_t>)getOffsets;
- (std::vector<uint64_t>)getHackedHexes;
- (std::vector<uint64_t>)getOriginalHexes;
- (UIColor *)getThemeColor;

- (void)showInfo;

+ (void)setSpacing:(float)spacing_;
+ (float)getSpacing;

@end
