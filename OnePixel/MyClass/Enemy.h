//
//  Enemy.h
//  OnePixel
//
//  Created by Roman on 12/15/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "EnemyDelegate.h"
#import "CCClippingNode.h"
@class Projectile;

typedef enum
{
	EnemyTypeHuman = 0,
	EnemyTypeMilitia,
    EnemyTypeMax,
} EnemyType;

@class Projectile;
@interface Enemy : CCClippingNode {
    
}
@property (nonatomic, assign) CGFloat hp;
@property (nonatomic, assign) id <EnemyDelegate>  delegate;
@property (nonatomic, retain) CCNode *holes_;
@property (nonatomic, retain) CCNode *holesStencil_;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat cooldownAttack;
@property (nonatomic, assign) BOOL canAttack;
@property (nonatomic, retain) CCSprite *place;
//@property (nonatomic, retain) Projectile *projectile;
+ (Enemy*) enemy;
- (CGRect) coolisionRect;
- (void) updateVertexZ:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
- (void) goToPlayer;
- (void) update:(ccTime)delta;
- (BOOL) killWithHit:(Projectile*) projectile;
@end