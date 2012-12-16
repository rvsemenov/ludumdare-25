//
//  Home.h
//  OnePixel
//
//  Created by Roman on 12/16/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Home : CCSprite {
    
}
@property (nonatomic, assign) NSInteger coins;
+ (Home*) homeWithType:(NSInteger)type;
@end
