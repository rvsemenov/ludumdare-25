//
//  MainMenu.m
//  OnePixel
//
//  Created by Roman on 12/16/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import "MainMenu.h"
#import "GameScene.h"

@implementation MainMenu
+ (CCScene *) scene
{
    CCScene *scene = [CCScene node];
    MainMenu *layer = [MainMenu node];
    [scene addChild:layer];
    return scene;
}

-(id) init
{
	if((self = [super init]))
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCSprite *bkg = [CCSprite spriteWithFile:@"mainMenuBkg.jpg"];
        bkg.position = ccp(screenSize.width / 2, screenSize.height/2);
        [self addChild:bkg];
        
    
        CCSprite *play = [CCSprite spriteWithFile:@"playButton.png"];
        CCSprite *playSel = [CCSprite spriteWithFile:@"playButtonSel.png"];
        CCMenuItemSprite *playItem = [CCMenuItemSprite itemWithNormalSprite:play
                                                             selectedSprite:playSel
                                                                     target:self
                                                                   selector:@selector(onPlay)];
        playItem.position = ccp(screenSize.width * 0.3, screenSize.height * 0.5);
        CCMenu *menu = [CCMenu menuWithItems:playItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bigMan.plist"];
        CCSprite *man = [CCSprite spriteWithSpriteFrameName:@"mainPlayer_00.png"];
        man.position = ccp(screenSize.width * 0.7, screenSize.height* 0.5);
        [self addChild:man z:10];
        
        NSMutableArray *animationStandFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease] ;
        for (NSUInteger i = 0; i < 37; i++)
        {
            NSString* file = [NSString stringWithFormat:@"mainPlayer_%02d.png",i];
            CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
            [animationStandFrames addObject:frame];
        }
        
        CCAnimation *animationStand = [CCAnimation animationWithSpriteFrames:animationStandFrames delay:1.0 / 10.0];
        CCAnimate *animateStand = [CCAnimate actionWithAnimation:animationStand];
        [man runAction: [CCRepeatForever actionWithAction:animateStand]];
    }
    return self;
}

- (void) onPlay
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameScene scene] ]];
}
@end
