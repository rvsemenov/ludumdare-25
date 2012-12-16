//
//  GameScene.m
//  OnePixel
//
//  Created by Roman on 12/15/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import "GameScene.h"
#import "CCTMXTiledMap+Helper.h"
#import "HUDLayer.h"
#import "Enemy.h"
#import "Projectile.h"
#import "Man.h"
#import "Home.h"
#import "WinScene.h"
#import "GameOver.h"
#import "SimpleAudioEngine.h"

@implementation GameScene
+ (CCScene *) scene
{
    CCScene *scene = [CCScene node];
    GameScene *layer = [GameScene node];
    [scene addChild:layer];
    return scene;
}

-(id) init
{
	if((self = [super init]))
    {
        self.touchEnabled = YES;

        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Hit.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Pickup_Coin.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Explosion.wav"];
        [CCParticleSystemQuad particleWithFile:@"blood.plist"];
        [CCParticleSystemQuad particleWithFile:@"blood.plist"];
        const int borderSize = 1;
        playableAreaMin = CGPointMake(borderSize, borderSize);
        playableAreaMax = CGPointMake(map.mapSize.width - 1 - borderSize, map.mapSize.height - 1 - borderSize);
        
        projectiles = [[NSMutableArray alloc] init];
        projectilesInGame = [[NSMutableArray alloc] init];
        enemyes = [[NSMutableArray alloc] init];
        projectileToPlayer = [[NSMutableArray alloc] init];
        homes = [[NSMutableArray alloc] init];
        [self addMap];
        worldLayer = [CCLayer node];
        [self addChild:worldLayer z:0];
        
        [self addHUDLayer];
        [self addPlayer];
        [self addProjectile];
        [self addCar];
        [self addMan];
        [self schedule:@selector(update:)];
        [self schedule:@selector(shoot) interval:0.3];
        [self addObjects];
        [self schedule:@selector(addEnemy) interval:1.0];
        
        
    }
    return self;
}

- (void) dealloc
{
    [projectiles removeAllObjects];
    [projectiles release];
    [projectileToPlayer removeAllObjects];
    [projectileToPlayer release];
    [projectilesInGame removeAllObjects];
    [projectilesInGame release];
    [homes removeAllObjects];
    [homes release];
    [spawmEnemyPoints release];
    [enemyes removeAllObjects];
    [enemyes release];
    [super dealloc];
}
#pragma mark -
#pragma mark Add Object
- (void) addCar
{
    car = [CCSprite spriteWithFile:@"car.png"];
    car.position = ccpSub(player.position, ccp(car.boundingBox.size.width/2, car.boundingBox.size.height/2));
    [worldLayer addChild:car];
}

- (void) addMan
{
    man = [Man man];
    man.position = ccpSub(player.position, ccp(man.boundingBox.size.width * 1.4, 0));
    [worldLayer addChild:man];
}
- (void) addProjectile
{
    for (int i = 0; i < 10; i++)
    {
        Projectile *projectile = [Projectile projectile];
        projectile.opacity = 0;
        [projectiles addObject:projectile];
        [worldLayer addChild:projectile];
    }
}

- (void) addMap
{
    map = [CCTMXTiledMap tiledMapWithTMXFile:@"level_2.tmx"];
    map.position = [map positionFocusObjectName:@"SpawnPlayer"];
    CCTMXLayer* layer = [map layerNamed:@"Meta"];
    layer.visible = NO;
    [self addChild:map z:-1];
}

- (void) addPlayer
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    player = [Player player];
    player.delegate = hudLayer;
    player.position = ccp(screenSize.width/2, screenSize.height/2);
    [worldLayer addChild:player];
}

- (void) addHUDLayer
{
    hudLayer = [HUDLayer node];
    hudLayer.leftJoystick.gameDelegate = self;
    hudLayer.rigthJoystick.gameDelegate = self;
    [self addChild:hudLayer z:100];
}

- (void) addEnemy
{
    if ([enemyes count] < 5)
    {
        int rand = arc4random() % spawmEnemyPoints.count;
        CGPoint spawnPoint = CGPointFromString([spawmEnemyPoints objectAtIndex:rand]);
        
        Enemy *enemy = [Enemy enemy];
        enemy.delegate = self;
        enemy.position = spawnPoint;
        
        [worldLayer addChild:enemy];
        [enemyes addObject:enemy];
    }
}
- (void) addObjects
{
    NSMutableDictionary * spawnPoint;
    
    
    CCTMXObjectGroup *objects = [map objectGroupNamed:@"Objects"];
    NSMutableDictionary *spawnPlayer = [objects objectNamed:@"SpawnPlayer"];
    NSAssert(spawnPlayer.count > 0, @"SpawnPoint object missing");
    CGPoint centerPoint;
    CCDirector *director = [CCDirector sharedDirector];
    
    centerPoint.x = [[spawnPlayer valueForKey:@"x"] floatValue]  ;
    centerPoint.y = [[spawnPlayer valueForKey:@"y"] floatValue] ;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        centerPoint.x = centerPoint.x * 2;
        centerPoint.y = centerPoint.y * 2 - (map.mapSize.height * map.tileSize.height);
    }
    
    if ([director contentScaleFactor] == 2)
    {
        centerPoint.y = centerPoint.y - (map.tileSize.height / 2) * map.mapSize.height;
    }
    
    centerPoint.x = centerPoint.x / (map.tileSize.height / [director contentScaleFactor]);
    centerPoint.y = centerPoint.y / (map.tileSize.height / [director contentScaleFactor]);
    
    CGPoint newCenterPoint;
    newCenterPoint.x = (centerPoint.y + centerPoint.x ) * ((map.tileSize.width/2) / [director contentScaleFactor]) - ((map.tileSize.width/2) / [director contentScaleFactor]);
    newCenterPoint.y = (centerPoint.y - centerPoint.x) * ((map.tileSize.height/2) / [director contentScaleFactor]) + ((map.tileSize.height/2) / [director contentScaleFactor]);
    
    NSMutableArray *enemyPoints = [NSMutableArray arrayWithCapacity:1];
    for (spawnPoint in [objects objects])
    {
        if ([[spawnPoint valueForKey:@"Enemy"] intValue] != 0)
        {
            CGFloat property = 0;
            if ([[spawnPoint valueForKey:@"Property"] floatValue] != 0)
            {
                property = [[spawnPoint valueForKey:@"Property"] floatValue];
            }
            CGPoint spawnPosition;
            spawnPosition.x = [[spawnPoint valueForKey:@"x"] floatValue];
            spawnPosition.y = [[spawnPoint valueForKey:@"y"] floatValue];
            spawnPosition = [map spawnPosition:spawnPosition];
            
            CGPoint pos = ccpSub(spawnPosition, newCenterPoint);
            [enemyPoints addObject:NSStringFromCGPoint(pos)];
            
        }
        else if ([[spawnPoint valueForKey:@"Home"] intValue] != 0)
        {
            CGFloat property = 0;
            if ([[spawnPoint valueForKey:@"Property"] floatValue] != 0)
            {
                property = [[spawnPoint valueForKey:@"Property"] floatValue];
            }
            CGPoint spawnPosition;
            spawnPosition.x = [[spawnPoint valueForKey:@"x"] floatValue];
            spawnPosition.y = [[spawnPoint valueForKey:@"y"] floatValue];
            spawnPosition = [map spawnPosition:spawnPosition];
            
            CGPoint pos = ccpSub(spawnPosition, newCenterPoint);
            
            Home *home = [Home homeWithType:[[spawnPoint valueForKey:@"Home"] intValue]];
            home.position = pos;
            [worldLayer addChild:home];
            [homes addObject:home];
            
            CGPoint projPos = [self tilePosFromLocation:ccpAdd([self convertToWorldSpace:home.position], worldLayer.position) tileMap:map];
            
            float lowestZ = -(map.mapSize.width + map.mapSize.height);
            float currentZ = projPos.x + projPos.y;
            home.vertexZ = lowestZ + currentZ + 1.5f;//0.5
            [home.parent reorderChild:home z:home.vertexZ];
        }
    }
    spawmEnemyPoints = [[NSArray alloc] initWithArray:enemyPoints];
}
#pragma mark -
#pragma mark tick metod
- (void) update:(ccTime)delta
{
    [self coolisionWithEnemy];
    [self coolisionWithPlayer];
    
    if (player.isMove)
    {
        CGPoint speedVec = ccp(100, 0);
        speedVec = ccpRotateByAngle(speedVec, CGPointZero, -CC_DEGREES_TO_RADIANS(player.direction));
        speedVec = ccpMult(speedVec, delta);
        
        
        CGPoint tilePos = [self tilePosFromLocation:ccpAdd([self convertToWorldSpace:ccpAdd(player.position, speedVec)], worldLayer.position) tileMap:map];
        //if (![map isProp:@"blocks_movement" atTileCoord:tilePos forLayerName:@"Meta"])
        //{
            player.position = ccpAdd(player.position, speedVec);
            worldLayer.position = ccpSub(worldLayer.position,speedVec);
            map.position = ccpSub(map.position, speedVec);
            
            [player updateVertexZ:tilePos tileMap:map];
        //}
        
        for (Home *home in homes)
        {
            if (home.coins != 0)
            {
                if (CGRectContainsPoint(player.boundingBox, home.position))
                {
                    hudLayer.coinsCoint += home.coins;
                    home.coins = 0;
                    
                    if ((arc4random() % 2) == 0)
                    {
                        [[SimpleAudioEngine sharedEngine] playEffect:@"Explosion.wav"];
                        CCParticleSystemQuad *explore = [CCParticleSystemQuad particleWithFile:@"explore.plist"];
                        explore.position = home.position;
                        CCCallBlock *remove = [CCCallBlock actionWithBlock:^{
                            [explore removeFromParentAndCleanup:YES];
                        }];
                        [explore runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:1.0] two:remove]];
                        
                        [worldLayer addChild:explore];
                        [homes removeObject:home];
                        [home removeFromParentAndCleanup:YES];
                    }

                    return;
                }
            }
        }
        if (CGRectContainsPoint(player.boundingBox, man.position)) {
            man.needManey -= hudLayer.coinsCoint;
            hudLayer.coinsCoint = 0;
            if (man.needManey <= 0)
            {
                [self unscheduleAllSelectors];
                [player setOpacity:0];
                [man setOpacity:0];
                
                CCCallBlock *end = [CCCallBlock actionWithBlock:^{
                    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[WinScene scene] ]];
                }];
                CCMoveBy *move = [CCMoveBy actionWithDuration:4.0 position:ccp(1000, -500)];
                CCSequence *sequence = [CCSequence actionOne:move two:end];
                [car runAction:sequence];
                
            }
        }
    }
    for (Enemy *enemy in enemyes)
    {
        CGPoint enemyPos = [self tilePosFromLocation:ccpAdd([self convertToWorldSpace:enemy.position], worldLayer.position) tileMap:map];
        [enemy updateVertexZ:enemyPos tileMap:map];
        
        [enemy update:delta];
    }
    for (CCNode *proj in projectilesInGame)
    {
        CGPoint projPos = [self tilePosFromLocation:ccpAdd([self convertToWorldSpace:proj.position], worldLayer.position) tileMap:map];
        
        float lowestZ = -(map.mapSize.width + map.mapSize.height);
        float currentZ = projPos.x + projPos.y;
        proj.vertexZ = lowestZ + currentZ - 1.5f;//0.5
        [proj.parent reorderChild:proj z:proj.vertexZ];
    }
}

- (void) coolisionWithPlayer
{
    for (Projectile *projectile in projectileToPlayer)
    {
        if (CGRectContainsPoint([player  coolisionRect], projectile.position)) {
            player.hp--;
            if (player.hp <= 0)
            {
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameOver scene] ]];
            }
            [projectileToPlayer removeObject:projectile];
            projectile.opacity = 0;
            return;
        }
    }
    
}
- (void) coolisionWithEnemy
{
    for (Projectile *projectile in projectilesInGame)
    {
        for (Enemy *enemy in enemyes)
        {
            if (CGRectContainsPoint([enemy  coolisionRect], projectile.position)) {
                if ([enemy killWithHit:projectile])
                {
                    [enemyes removeObject:enemy];
                }
                [projectilesInGame removeObject:projectile];
                projectile.opacity = 0;
                return;
            }
        }

    }
}

#pragma mark -
#pragma mark other
- (CGPoint) tilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap*)tileMap
{
	CGPoint pos = [map floatingTilePosFromLocation:location];
    
	// make sure coordinates are within bounds of the playable area, and cast to int
	//pos = [self ensureTilePosIsWithinBounds:CGPointMake((int)pos.x, (int)pos.y)];
	//CCLOG(@"touch at (%.0f, %.0f) is at tileCoord (%i, %i)", location.x, location.y, (int)pos.x, (int)pos.y);
	return pos;
}

- (CGPoint) ensureTilePosIsWithinBounds:(CGPoint)tilePos
{
	tilePos.x = MAX(playableAreaMin.x, tilePos.x);
	tilePos.x = MIN(playableAreaMax.x, tilePos.x);
	tilePos.y = MAX(playableAreaMin.y, tilePos.y);
	tilePos.y = MIN(playableAreaMax.y, tilePos.y);
    
	return tilePos;
}

#pragma mark -
#pragma mark SneakJoystickDelegate
//for left
-(void) updateJoystikDegrees:(CGFloat) degrees
{
    player.direction = -degrees;
    if (!player.isShoot)
    {
        player.myRotation = -degrees;
    }
}

-(void) stopUpdate
{
    player.isMove = NO;
}

-(void) startUpdate
{
    player.isMove = YES;
}

//for rigth
-(void) updateRotationDegrees:(CGFloat) degrees
{
    player.myRotation = -degrees;
}

-(void) stopUpdateWithDegrees:(CGFloat) degrees
{
    player.isShoot = NO;
}
-(void) startUpdateDegrees:(CGFloat) degrees;
{
    player.isShoot = YES;
}
#pragma mark -
#pragma mark Player
- (void) shoot
{
    if (player.isShoot)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"Hit.wav"];
        Projectile *projectile = [projectiles objectAtIndex:0];
        
        [projectilesInGame addObject:projectile];
        projectile.opacity = 255;
        projectile.position = player.position;
        
        CGPoint speedVec = ccp(200, 0);
        speedVec = ccpRotateByAngle(speedVec, CGPointZero, -CC_DEGREES_TO_RADIANS(player.myRotation));
        projectile.speedVec = speedVec;
        CCMoveBy *move = [CCMoveBy actionWithDuration:0.5 position:speedVec];
        
        CCCallBlock *remove = [CCCallBlock actionWithBlock:^{
            projectile.opacity = 0;
            [projectilesInGame removeObject:projectile];
        }];
        CCSequence *actions = [CCSequence actionOne:move two:remove];
        [projectile runAction:actions];
        [projectiles removeObjectAtIndex:0];
        [projectiles addObject:projectile];
        // [projectiles exchangeObjectAtIndex:0 withObjectAtIndex:[projectiles count]-1];
    }
}

#pragma mark -
#pragma mark EnemyDelegate metod
- (CGPoint) playerPosition
{
    return player.position;
}
- (CGFloat) playerVertexZ
{
    return player.vertexZ;
}

- (Player*) player
{
    return player;
}

- (void) enemyShoot:(CGPoint) pos;
{
    Projectile *projectile = [projectiles objectAtIndex:0];
    
    [projectileToPlayer addObject:projectile];
    projectile.opacity = 255;
    projectile.position = pos;
    
    CGPoint deltaPos = ccpMult(ccpNormalize(ccpSub(player.position, pos)), 280);
    projectile.speedVec = deltaPos;
    
    CCMoveBy *move = [CCMoveBy actionWithDuration:1.0 position:deltaPos];
    
    CCCallBlock *remove = [CCCallBlock actionWithBlock:^{
        projectile.opacity = 0;
        [projectileToPlayer removeObject:projectile];
    }];
    CCSequence *actions = [CCSequence actionOne:move two:remove];
    [projectile runAction:actions];
    [projectiles removeObjectAtIndex:0];
    [projectiles addObject:projectile];
}
@end
