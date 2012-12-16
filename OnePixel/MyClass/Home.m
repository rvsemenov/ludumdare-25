//
//  Home.m
//  OnePixel
//
//  Created by Roman on 12/16/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import "Home.h"


@implementation Home
@synthesize coins;
+ (Home*) homeWithType:(NSInteger)type
{
    
    Home *home = [Home spriteWithFile:[NSString stringWithFormat:@"home_%02d.png",type - 1]];
    if (type == 1)
    {
        home.coins = 200;
    }
    else if (type == 2)
    {
        home.coins = 250;
    }
    else if (type == 3)
    {
        home.coins = 300;
    }
    else if (type == 4)
    {
        home.coins = 350;
    }
    return home;
}
@end
