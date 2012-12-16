//
//  Player.h
//  OnePixel
//
//  Created by Roman on 12/15/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HUDDelegate.h"

@interface Player : CCSprite
{
    CGFloat _hp;
    CGFloat _myRotation;
}
@property (nonatomic, retain) NSMutableArray *animationTexture;
@property (nonatomic, assign) id <HUDDelegate> delegate;
@property (nonatomic, assign) CGFloat hp;
@property (nonatomic, assign) BOOL isMove;
@property (nonatomic, assign) BOOL isShoot;
@property (nonatomic, assign) CGFloat direction;
@property (nonatomic, assign) CGFloat myRotation;
@property (nonatomic, retain) CCSprite *place;
+ (Player*) player;
- (CGRect) coolisionRect;
- (void) updateVertexZ:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
@end
