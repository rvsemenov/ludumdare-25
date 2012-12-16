//
//  CCLabelBMFont+AnimatedUpdate.m
//  ShapeDrop
//
//  Created by Alexander on 9/11/12.
//  Copyright (c) 2012 Tap Company. All rights reserved.
//

#import "cocos2d.h"
#import "CCLabelBMFont+AnimatedUpdate.h"
//#import "NSString+NumbersWithCommas.h"

const int kCCLabelBMFontDefaultNumberOfAnimationSteps = 20;

@implementation CCLabelBMFont (AnimatedUpdate)

- (void) animateValueFrom:(int)from to:(int)to interval:(ccTime)interval
{
    BOOL increasing = (to > from);
    int steps = MIN(abs(to - from), kCCLabelBMFontDefaultNumberOfAnimationSteps);
    if (!steps)
        return;
    
    int stepValue = (to - from) / (float)steps;
    ccTime updatesInterval = interval / steps;
    __block int value = from;
    
    id animation = [CCRepeat actionWithAction:
                    [CCSequence actions:
                     [CCCallBlockN actionWithBlock:^(CCNode *node) {
                        value = (increasing) ? MIN(value + stepValue, to) : MAX(value + stepValue, to);
                        [(id<CCLabelProtocol>)node setString:[self intToString:value]];
                    }],
                     [CCDelayTime actionWithDuration:updatesInterval], nil]
                                        times:steps];
    
    id setFinalValue = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [(id<CCLabelProtocol>)node setString:[self intToString:value]];
    }];
    
    [self runAction:[CCSequence actions:animation, setFinalValue, nil]];
}

- (NSString *) intToString:(NSInteger) number
{
    return [NSString stringWithFormat:@"$-%03d",number];
}

- (void) animateValueFrom:(int)from to:(int)to interval:(ccTime)interval delay:(ccTime)delay
{
    [self runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:delay],
      [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [(CCLabelBMFont *)node animateValueFrom:from to:to interval:interval];
     }], nil]];
}

@end
