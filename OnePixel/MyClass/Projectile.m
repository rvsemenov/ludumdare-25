//
//  Projectile.m
//  OnePixel
//
//  Created by Roman on 12/15/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import "Projectile.h"


@implementation Projectile
@synthesize speedVec;

+ (Projectile*) projectile
{
    Projectile *projectile = [Projectile spriteWithFile:@"projectile.png"];
    return projectile;
}
@end
