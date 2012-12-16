//
//  HUDLayer.h
//  OnePixel
//
//  Created by Roman on 12/15/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakyJoystick.h"
#import "HUDDelegate.h"

@interface HUDLayer : CCLayer <HUDDelegate>
{
    SneakyJoystick *leftJoystick;
    SneakyJoystick *rigthJoystick;
    CCLabelBMFont *countLabel;
    NSInteger _coinsCoint;
}
@property (nonatomic, retain) SneakyJoystick *leftJoystick;
@property (nonatomic, retain) SneakyJoystick *rigthJoystick;
@property (nonatomic, assign) NSInteger coinsCoint;
@end
