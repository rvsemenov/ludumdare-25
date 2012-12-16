//
//  HUDLayer.m
//  OnePixel
//
//  Created by Roman on 12/15/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import "HUDLayer.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "GameScene.h"
#import "CCLabelBMFont+AnimatedUpdate.h"
#import "SimpleAudioEngine.h"
@implementation HUDLayer
@synthesize leftJoystick;
@synthesize rigthJoystick;
@synthesize coinsCoint = _coinsCoint;
- (id) init
{
    if (self = [super init])
    {
        _coinsCoint = 0;
        [self addJoysticks];
        [self addHerds];
        [self addCoinCount];
        
    }
    return self;
}

         

- (void) addCoinCount
{    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    countLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"coinCount.fnt"];
    countLabel.position = ccp(screenSize.width * 0.87, screenSize.height * 0.92);
    [self addChild:countLabel];
    [self updateCoinCount:_coinsCoint];
}

- (void) updateCoinCount:(NSInteger) coin
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"Pickup_Coin.wav"];
    
    [countLabel animateValueFrom:_coinsCoint to:coin interval:2];
    countLabel.string = [NSString stringWithFormat:@"$-%03d",_coinsCoint];
    _coinsCoint = coin;
}

- (void) setCoinsCoint:(NSInteger)coinsCoint
{
    
    [self updateCoinCount:coinsCoint];
}
- (void) addHerds
{
    for (int i = 0 ; i < 3; i ++)
    {
        CCSprite *heart = [CCSprite spriteWithFile:@"heard.png"];
        heart.position = ccp(30 + i * 40 , 300);
        heart.tag = i;
        [self addChild:heart];
    }
}

- (void) updateHp:(CGFloat) hp
{
    for (int i = 0 ; i < 3; i ++)
    {
     
       CCSprite *heart = (CCSprite*)[self getChildByTag:i];
        if (i < hp) {
            heart.color = ccWHITE;
        }
        else
        {
            heart.color = ccGRAY;
        }
        
    }
}
- (void) addJoysticks
{
    SneakyJoystickSkinnedBase *leftJoy = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    leftJoy.position = ccp(64,64);
    leftJoy.backgroundSprite = [CCSprite spriteWithFile:@"Joystick_bkg.png"];
    leftJoy.thumbSprite = [CCSprite spriteWithFile:@"Joystick_move.png"];
    leftJoy.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,150,150)];
    leftJoystick = [leftJoy.joystick retain];
    leftJoystick.isLeft = YES;
    [self addChild:leftJoy];
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    SneakyJoystickSkinnedBase *rigthJoy = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    rigthJoy.position = ccp(screenSize.width - 64,64);
    rigthJoy.backgroundSprite = [CCSprite spriteWithFile:@"Joystick_bkg.png"];
    rigthJoy.thumbSprite = [CCSprite spriteWithFile:@"Joystick_shot.png"];
    rigthJoy.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,128,128)];
    rigthJoystick = [rigthJoy.joystick retain];
    rigthJoystick.isLeft = NO;
    [self addChild:rigthJoy];
}
@end
