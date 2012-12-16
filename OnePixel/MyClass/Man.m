//
//  Man.m
//  OnePixel
//
//  Created by Roman on 12/15/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import "Man.h"
#import "CCLabelBMFont+AnimatedUpdate.h"

@implementation Man
@synthesize needManey = _needManey;
+ (Man*) man
{
    Man *man = [Man spriteWithFile:@"man.png"];
    man.needManey = 0;
    [man addLabel];
    return man;
}

- (void) setOpacity:(GLubyte)opacity
{
    [super setOpacity:opacity];

    maneyLabel.opacity = 0;
    
}
-  (void) addLabel
{
    maneyLabel = [CCLabelBMFont labelWithString:@"0000" fntFile:@"needMoney.fnt"];
    maneyLabel.position = ccp(45, 52);
    [self updateManeyLabel:1000];
    [self addChild:maneyLabel];
}

- (void) updateManeyLabel:(NSInteger) money
{
    [maneyLabel animateValueFrom:_needManey to:money interval:2];
    _needManey = money;
}

- (void) setNeedManey:(NSInteger)needManey
{
    //_needManey = needManey;
    [self updateManeyLabel:needManey];
}
@end
