//
//  Enemy.m
//  OnePixel
//
//  Created by Roman on 12/15/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import "Enemy.h"
#import "Projectile.h"
#import "GameOver.h"
#import "Projectile.h"

@implementation Enemy
@synthesize hp;
@synthesize delegate;
@synthesize holes_;
@synthesize holesStencil_;
@synthesize speed;
@synthesize cooldownAttack;
@synthesize canAttack;
@synthesize place;
//@synthesize projectile;

+ (Enemy*) enemy
{
    EnemyType type = arc4random() %EnemyTypeMax;
    NSString *name = [NSString stringWithFormat:@"enemy_%d_00.png",type+1];
    CCSprite *target = [CCSprite spriteWithFile:name];
    target.anchorPoint = CGPointZero;
    
    Enemy *enemy = [[Enemy clippingNode] retain];
    enemy.contentSize = CGSizeApplyAffineTransform(target.contentSize, CGAffineTransformMakeScale(target.scale, target.scale));
    enemy.anchorPoint = ccp(0.5, 0.2);
    enemy.tag = type;
    if (type == EnemyTypeHuman)
    {
        enemy.hp = 5;
        enemy.speed = 1.4;
        enemy.cooldownAttack = 2.0;
    }
    else if (type == EnemyTypeMilitia)
    {
        enemy.hp = 10;
        enemy.speed = 1.0;
        enemy.cooldownAttack = 3.0;
        
//        enemy.projectile = [Projectile projectile];
//        enemy.projectile.opacity = 0;
    }

    enemy.canAttack = YES;
    //outerClipper_.position = ccpMult(ccpFromSize(self.contentSize), 0.5);
    
    
    enemy.stencil = target;
    
    
    
    CCClippingNode *holesClipper = [CCClippingNode clippingNode];
    holesClipper.inverted = YES;
    holesClipper.alphaThreshold = 0.05;
    
    [holesClipper addChild:target];
    
    enemy.holes_ = [CCNode node];
    
    [holesClipper addChild:enemy.holes_];
    
    enemy.holesStencil_ = [CCNode node];
    
    holesClipper.stencil = enemy.holesStencil_;
    
    [enemy addChild:holesClipper];
    
    enemy.place = [CCSprite spriteWithFile:@"place.png"];
    enemy.place.position = [enemy anchorPointInPoints];
    //ccp(enemy.boundingBox.size.width * enemy.anchorPoint.x,
                       //  enemy.boundingBox.size.height * enemy.anchorPoint.y);
    [enemy addChild:enemy.place z:-1];
    return enemy;
}
//- (void) setParent:(CCNode *)parent
//{
//    [super setParent:parent];
//    self.projectile.position = self.position;
//    [parent addChild:self.projectile z:1];
//}
- (void) dealloc
{
    //[self.projectile removeFromParentAndCleanup:YES];
    [super dealloc];
}
- (CGRect) coolisionRect
{
    //TODO:dsfsdv
    return CGRectMake(self.position.x - self.boundingBox.size.width/2,
                      self.position.y - self.boundingBox.size.height * self.anchorPoint.y,
                      self.place.boundingBox.size.width, self.boundingBox.size.height);
}

- (void) updateVertexZ:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
{
	float lowestZ = -(tileMap.mapSize.width + tileMap.mapSize.height);
	float currentZ = tilePos.x + tilePos.y;
	self.vertexZ = lowestZ + currentZ - 0.5f;//0.5
    [self.parent reorderChild:self z:self.vertexZ];
    
}

- (void) update:(ccTime)delta;
{
    
    
    if (self.canAttack && CGRectContainsPoint([self coolisionRect], [delegate player].position))
    {
            self.canAttack = NO;
            CCCallBlock *block = [CCCallBlock actionWithBlock:^{
                self.canAttack = YES;
            }];
            [self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:self.cooldownAttack] two:block]];
            [delegate player].hp--;
            if ([delegate player].hp <= 0)
            {
                
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameOver scene] ]];
            }
        }
    else if(self.canAttack && self.tag == 1)
    {
        self.canAttack = NO;
        CCCallBlock *block = [CCCallBlock actionWithBlock:^{
            self.canAttack = YES;
        }];
        [self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:self.cooldownAttack] two:block]];
        
        
        
        [delegate enemyShoot:self.position];
    }

    
    CGPoint deltaPos = ccpMult(ccpNormalize(ccpSub([delegate player].position, self.position)), self.speed);
    self.position = ccpAdd(self.position, deltaPos);
}
- (BOOL) killWithHit:(Projectile*) projectile;
{
    self.hp--;
    if (self.hp < 0)
    {
        [self removeFromParentAndCleanup:YES];
        return YES;
    }
    else
    {
        self.position = ccpAdd(self.position, ccpMult(ccpNormalize(projectile.speedVec), 6));
        

        
        
        CGPoint randPoint = ccp(arc4random() % (int)self.boundingBox.size.width,arc4random() % ((int)self.boundingBox.size.height - 16) + 16) ;
        float scale = CCRANDOM_0_1() * 0.2 + 0.9;
        float rotation = CCRANDOM_0_1() * 360;
        
        
        CCParticleSystemQuad *blood = [CCParticleSystemQuad particleWithFile:@"blood.plist"];
        CGFloat rotatationAngle = CC_RADIANS_TO_DEGREES(ccpToAngle(ccpSub(projectile.speedVec, self.position)));
        blood.angle = rotatationAngle;

        //TODO:сделаь угол
        blood.position = ccpAdd(ccpSub(self.position, ccp(self.boundingBox.size.width * self.anchorPoint.x, self.boundingBox.size.height* self.anchorPoint.y)), randPoint);
 
        //NSLog(@"angle=%f",blood.angle );
        if (projectile.speedVec.y > 0)
        {
            [self.parent addChild:blood z:self.zOrder - 1];
            
        }
        else
        {
            [self.parent addChild:blood z:self.zOrder + 1];
        }
        blood.vertexZ = blood.zOrder;
        CCCallBlock *remove = [CCCallBlock actionWithBlock:^{
            [blood removeFromParentAndCleanup:YES];
        }];
        [blood runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:1.0] two:remove]];
        self.position = ccpAdd(self.position, ccpMult(ccpNormalize(projectile.speedVec), 6));
        
        
        CCSprite *hole = [CCSprite spriteWithFile:@"hole_effect.png"];
        hole.position = randPoint;
        hole.rotation = rotation;
        hole.scale = scale;
        
        [self.holes_ addChild:hole];
        
        CCSprite *holeStencil = [CCSprite spriteWithFile:@"projectile.png"];
        holeStencil.position = randPoint;
        holeStencil.rotation = rotation;
        holeStencil.scale = scale;
        
        [self.holesStencil_ addChild:holeStencil];
        
    }
    return NO;
}

- (void) goToPlayer
{
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        [delegate player].hp--;
    }];
    CCMoveTo *move = [CCMoveTo actionWithDuration:3.0 position:[delegate playerPosition]];
    [self runAction:[CCSequence actionOne:move two:block]];
}
@end
