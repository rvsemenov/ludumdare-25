//
//  EnemyDelegate.h
//  OnePixel
//
//  Created by Roman on 12/15/12.
//  Copyright (c) 2012 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Projectile.h"

@protocol EnemyDelegate <NSObject>
- (CGPoint) playerPosition;
- (CGFloat) playerVertexZ;
- (Player*) player;
- (void) enemyShoot:(CGPoint) pos;
@end
