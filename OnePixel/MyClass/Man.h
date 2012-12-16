//
//  Man.h
//  OnePixel
//
//  Created by Roman on 12/15/12.
//  Copyright 2012 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Man : CCSprite {
    CCLabelBMFont *maneyLabel;
    NSInteger _needManey;
}
@property (nonatomic, assign) NSInteger needManey;
+ (Man*) man;
@end
