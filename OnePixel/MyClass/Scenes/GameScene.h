//
//  GameScene.h
//  OnePixel
//
//  Created by Roman on 12/15/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakJoystickDelegate.h"
#import "EnemyDelegate.h"

@class Player, HUDLayer, Man;
@interface GameScene : CCLayer <SneakJoystickDelegate, EnemyDelegate>{
    CGPoint playableAreaMin, playableAreaMax;
    
    CCTMXTiledMap *map;
    CCLayer *worldLayer;
    HUDLayer *hudLayer;
    Player *player;
    CCSprite *car;
    Man *man;
    NSMutableArray *enemyes;
    NSMutableArray *projectiles;
    NSMutableArray *projectilesInGame;
    NSArray *spawmEnemyPoints;
    NSMutableArray *homes;
    NSMutableArray *projectileToPlayer;
}

+ (CCScene *) scene;
@end
