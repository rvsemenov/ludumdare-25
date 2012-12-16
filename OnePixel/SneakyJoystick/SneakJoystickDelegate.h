//
//  SneakJoystickDelegate.h
//  Kangaroo
//
//  Created by Роман Семенов on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SneakJoystickDelegate <NSObject>
-(void) updateJoystikDegrees:(CGFloat) degrees;
-(void) stopUpdate;
-(void) startUpdate;

-(void) updateRotationDegrees:(CGFloat) degrees;
-(void) stopUpdateWithDegrees:(CGFloat) degrees;
-(void) startUpdateDegrees:(CGFloat) degrees;
@end
