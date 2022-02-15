/**************/
HERE YOU'LL FIND AN EXAMPLE OF WORKING MOD MENU CODE. YOU CAN REFER TO THIS IF YOU NEED HELP.
/**************/

#import "Macros.h"
#import "ModMenu.h"
#import "Hack.h"
#import "Hook.h"
#import "SliderHook.h"
#import "TextfieldHook.h"
#import <substrate.h>
#import <initializer_list>
#import <vector>
#import <mach-o/dyld.h>

/*****************************/
static NSString *const title = @"Bullet Force Mod Menu"; //title of your menu
static NSString *const credits = @"Hacked by shmoo"; //who made the hack?
static NSString *const font = @"Copperplate-Bold"; //what font do you want the text to be? don't put anything for the default font
static UIColor *const themeColor = rgb(0x3a539b); //the overall color for the menu and the button

//replace the ? with anything from this list:
//https://ghostbin.com/paste/mbkfb
//or you could specify a custom color with
//rgb(0xCOLORCODE) ex: rgb(0x738282)

//a complete list of fonts can be found here:
//http://iosfonts.com/
/******************************/

uint64_t getRealOffset(uint64_t);

void addHack(NSString *, NSString *, NSString *, std::initializer_list<uint64_t>, std::initializer_list<uint64_t>, std::initializer_list<uint64_t>);
void addHook(NSString *, NSString *, NSString *, uint64_t, void *, void *);
void addSliderHook(NSString *, NSString *, NSString *, float, float, uint64_t, void *, void *);
void addTextfieldHook(NSString *, NSString *, NSString *, uint64_t, void *, void *);

static ModMenu *menu;

bool buttonAdded;

float (*getFov)(void *_this);

/*here is the way you use a textfield hook*/
float _getFov(void *_this){
//this if statement is vital. You MUST include it.
if([TextfieldHook getTextfieldValueForHook:@"Field of View Adjuster"] != nil){
return [[TextfieldHook getTextfieldValueForHook:@"Field of View Textfield"] floatValue];
}

return getFov(_this);
}

/*here is the way you use a slider hook*/
float _getFov(void *_this){
return [SliderHook getSliderValueForHook:@"Field of View Slider"];
}

/*here is the way you use a normal hook*/
float _getFov(void *_this){
if([Hook getHookOnForHook:@"80 FOV"]){
return 80.0f;
}
else{
return getFov(_this);
}
}

%hook UnityAppController

- (void)applicationDidBecomeActive:(id)arg0 {
UIWindow *main = [UIApplication sharedApplication].keyWindow.rootViewController.view;

UIButton *openButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
openButton.frame = CGRectMake((main.frame.size.width/2)-15, (main.frame.size.height/2)+75, 30, 30);
openButton.backgroundColor = [UIColor clearColor];
openButton.layer.cornerRadius = 16;
openButton.layer.borderWidth = 2;
openButton.layer.borderColor = themeColor.CGColor;
[openButton addTarget:self action:@selector(wasDragged:withEvent:) 
forControlEvents:UIControlEventTouchDragInside];
[openButton addTarget:self action:@selector(showMenu) 
forControlEvents:UIControlEventTouchDownRepeat];

if(!buttonAdded){
timer((int64_t)1){
UIWindow *main = [UIApplication sharedApplication].keyWindow.rootViewController.view;

menu = [[ModMenu alloc] initWithTitle:title credits:credits fontName:font theme:themeColor];

/***********************
add your features below this multi line comment. they show in the order you have added them.
for example:
addHack(@"God Mode", @"Description of the hack", font, {0x252e1a}, {0x7047}, {0xf0b5});
multi offset hacks can be added like this (there is no limit to the number of offsets you can have!):
addHack(@"No Recoil", @"No recoil prevents any recoil from being applied when you shoot.", font, {0x356a7c, 0x110f0a}, {0x7047, 0x7047}, {0xf0b5, 0xf0b5});
parameters: addHack(hack name, description, font, offset(s), hacked hex(es), original hex(es));

to add a slider hook:
for example:
addSliderHook(@"Field of View Slider", @"Adjust the game's field of view with this slider.", font, 40, 120, 0xd4ea48, (void *)_getFov, (void *)getFov);
parameters:
addSliderHook(hack name, description, font, minimum slider value, maximum slider value, function to hook, hooked function name, original function name);

to retrieve the value of the slider, use:
float val = [SliderHook getSliderValueForHook:@"hack name here"];

to add a textfield hook:
for example:
addTextfieldHook(@"Field of View Textfield", @"Adjust the game's field of view with this textfield.", font, 0xd4ea48, (void *)_getFov, (void *)getFov);
parameters:
addSliderHook(hack name, description, font, function to hook, hooked function name, original function name);

to retrieve the value of the textfield:
int val = [[TextfieldHook getTextfieldValueForHook:@"hack name here"] intValue];
float val = [[TextfieldHook getTextfieldValueForHook:@"hack name here"] floatValue];

to add a normal hook:
for example:
addHook(@"80 FOV", @"When on, your FOV will be changed to 80.", font, 0xc48ea6, (void *)_getFov, (void *)getFov);
parameters:
addHook(hack name, description, font, function to hook, hooked function name, original function name);
to see if the the user turned on the hook or not:
bool isOn = [Hook getHookOnForHook:@"hack name here"]
************************/
//add features here!

addTextfieldHook(@"Field of View Textfield", @"Adjust the game's field of view with this textfield.", font, 0xc2ea48, (void *)_getFov, (void *)getFov);

addSliderHook(@"Field of View Slider", @"Adjust the game's field of view with this slider.", font, 40, 120, 0xc2ea48, (void *)_getFov, (void *)getFov);

addHook(@"80 FOV", @"When on, your FOV will be changed to 80.", font, 0xc2ea48, (void *)_getFov, (void *)getFov);

addHack(@"Prevent Unloading Assets", @"Keep the game from unloading unused assets.", font, {0x242636}, {0x7047}, {0xf0b5});

addHack(@"M60", @"Force the game to switch your weapon to the M60", font, {0x263830}, {0x1620c046}, {0x00f06e84});

addHack(@"AK 47", @"Force the game to switch your weapon to the AK 47.", font, {0x263830}, {0x1420c046}, {0x00f06e84});

addHack(@"No Recoil", @"Prevent any recoil from being applied when you shoot.", font, {0x243150, 0x134260}, {0x7047, 0x7047}, {0xf0b5, 0xf0b5});

[main addSubview:openButton];
[main addSubview:menu];

buttonAdded = true;
});
}

%orig;
}

%new
- (void)showMenu {
[menu show];
}

%new
- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{
        UITouch *touch = [[event touchesForView:button] anyObject];

        CGPoint previousLocation = [touch previousLocationInView:button];
        CGPoint location = [touch locationInView:button];
        CGFloat delta_x = location.x - previousLocation.x;
        CGFloat delta_y = location.y - previousLocation.y;

        button.center = CGPointMake(button.center.x + delta_x, button.center.y + delta_y);
}
%end

void addHack(NSString *name, NSString *description, NSString *fontName, std::initializer_list<uint64_t> offsets, std::initializer_list<uint64_t> hackedHexes, std::initializer_list<uint64_t> originalHexes){
    std::vector<uint64_t> offsetVector;
    std::vector<uint64_t> hackedHexVector;
    std::vector<uint64_t> originalHexVector;
    
    offsetVector.insert(offsetVector.begin(), offsets.begin(), offsets.end());
    hackedHexVector.insert(hackedHexVector.begin(), hackedHexes.begin(), hackedHexes.end());
    originalHexVector.insert(originalHexVector.begin(), originalHexes.begin(), originalHexes.end());
    
    Hack *h = [[Hack alloc] initWithHackName:name info:description fontName:fontName theme:themeColor offset:offsetVector hackedHex:hackedHexVector originalHex:originalHexVector];
    [menu addHack:h];
}

void addHook(NSString *name, NSString *description, NSString *fontName, uint64_t offset, void *hooked, void *orig){
    MSHookFunction(((void*)getRealOffset(offset + 1)), hooked, &orig);

    Hook *h = [[Hook alloc] initWithHookName:name info:description fontName:fontName theme:themeColor offset:0x251832];
    [menu addHook:h];
}

void addSliderHook(NSString *name, NSString *description, NSString *fontName, float minValue, float maxValue, uint64_t offset, void *hooked, void *orig){
    MSHookFunction(((void*)getRealOffset(offset + 1)), hooked, &orig);

    SliderHook *sh = [[SliderHook alloc] initWithSliderHookName:name info:description fontName:fontName theme:themeColor offset:offset minValue:minValue maxValue:maxValue];
    [menu addHook:sh];
}

void addTextfieldHook(NSString *name, NSString *description, NSString *fontName, uint64_t offset, void *hooked, void *orig){
    MSHookFunction(((void*)getRealOffset(offset + 1)), hooked, &orig);

    TextfieldHook *th = [[TextfieldHook alloc] initWithTextfieldHookName:name info:description fontName:fontName theme:themeColor offset:offset];
    [menu addHook:th];
}

uint64_t getRealOffset(uint64_t offset){
    return _dyld_get_image_vmaddr_slide(0)+offset;
}