//
//  Player.m
//  OnePixel
//
//  Created by Roman on 12/15/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import "Player.h"


@implementation Player
@synthesize isMove;
@synthesize direction;
@synthesize isShoot;
@synthesize myRotation = _myRotation;
@synthesize hp = _hp;
@synthesize delegate;
@synthesize place;
@synthesize animationTexture;

+ (Player*) player
{
    Player *player = [Player spriteWithFile:@"player_00.png"];
    player.anchorPoint = ccp(0.5, 0.2);
    player.isMove = NO;
    player.isShoot = NO;
    player.hp = 3;
    
    player.place = [CCSprite spriteWithFile:@"place.png"];
    player.place.position = ccp(player.boundingBox.size.width * player.anchorPoint.x,
                               player.boundingBox.size.height * player.anchorPoint.y);
    [player addChild:player.place z:-1];
    
    player.animationTexture = [NSMutableArray new];
    for (int i = 0; i < 37; i++)
    {
        NSString *name = [NSString stringWithFormat:@"player_%02d.png",i];
        CCSprite *sprite = [CCSprite spriteWithFile:name];
        [player.animationTexture addObject:sprite.texture];
    }

    
    return player;
}

- (void) dealloc
{
    [self.animationTexture removeAllObjects];
    [self.animationTexture release];
    [super dealloc];
}

-(void) setMyRotation:(CGFloat)myRotation
{
    _myRotation = myRotation;
    
    myRotation = fabsf(myRotation);
    myRotation  = (int) myRotation % 360;
    
    NSInteger i = roundf(myRotation / 10);
    
    [self setDisplayFrame:[CCSpriteFrame frameWithTexture:[animationTexture objectAtIndex:i] rect:CGRectMake(0, 0, 35, 50)]];
    [self setBlendFunc:(ccBlendFunc) { GL_ONE, GL_ONE_MINUS_SRC_ALPHA }];
}

- (void) setOpacity:(GLubyte)opacity
{
    [super setOpacity:opacity];
    self.place.opacity = opacity;
}
- (CGRect) coolisionRect
{
    return CGRectMake(self.position.x - self.anchorPoint.x * self.boundingBox.size.width,
                      self.position.y - self.anchorPoint.y * self.boundingBox.size.height,
                      self.place.boundingBox.size.width, self.place.boundingBox.size.height);
}

- (void) setHp:(CGFloat)hp
{
    if (hp > 3)
    {
        hp = 3;
    }
    _hp = hp;
    [delegate updateHp:hp];
}

- (void) updateVertexZ:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
{
	float lowestZ = -(tileMap.mapSize.width + tileMap.mapSize.height);
	float currentZ = tilePos.x + tilePos.y;
	self.vertexZ = lowestZ + currentZ - 0.5;//0.5
    [self.parent reorderChild:self z:self.vertexZ];
    
}


@end
