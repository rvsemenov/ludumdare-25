//
//  GameOver.m
//  OnePixel
//
//  Created by Roman on 12/16/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import "GameOver.h"
#import "GameScene.h"

@implementation GameOver

+ (CCScene *) scene
{
    CCScene *scene = [CCScene node];
    GameOver *layer = [GameOver node];
    [scene addChild:layer];
    return scene;
}

-(id) init
{
	if((self = [super init]))
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *bkg = [CCSprite spriteWithFile:@"loseBkg.jpg"];
        bkg.position = ccp(screenSize.width / 2, screenSize.height/2);
        [self addChild:bkg];
        
     
        
        
        
        CCSprite *play = [CCSprite spriteWithFile:@"tryButton.png"];
        CCSprite *playSel = [CCSprite spriteWithFile:@"tryButton.png"];
        CCMenuItemSprite *playItem = [CCMenuItemSprite itemWithNormalSprite:play
                                                             selectedSprite:playSel
                                                                     target:self
                                                                   selector:@selector(onPlay)];
        playItem.position = ccp(screenSize.width * 0.5, screenSize.height * 0.5);
        CCMenu *menu = [CCMenu menuWithItems:playItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
    }
    return self;
}

- (void) onPlay
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameScene scene] ]];
}
@end
