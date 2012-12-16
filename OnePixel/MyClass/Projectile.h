//
//  Projectile.h
//  OnePixel
//
//  Created by Roman on 12/15/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Projectile : CCSprite {
    
}
@property (nonatomic, assign) CGPoint speedVec;
+ (Projectile*) projectile;
@end
