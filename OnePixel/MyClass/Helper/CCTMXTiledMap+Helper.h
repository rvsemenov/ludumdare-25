//
//  CCTMXTiledMap+Helper.h
//  Kangaroo
//
//  Created by Roman Semenov on 11/28/12.
//
//


#import "CCTMXTiledMap.h"
#import "Player.h"

@interface CCTMXTiledMap (Helper)
- (CGPoint) spawnPosition:(CGPoint) mapSpawnPoint;
- (CGPoint) convertSpawn:(CGPoint)oldSpawnPoint;

- (CGPoint) floatingTilePosFromLocation:(CGPoint)location;

//only for cube map
- (CGPoint) positionFocusObjectName:(NSString*)name;

- (BOOL)isProp:(NSString*)prop atTileCoord:(CGPoint)tileCoord forLayer:(CCTMXLayer *)layer;
- (BOOL)isProp:(NSString*)prop atTileCoord:(CGPoint)tileCoord forLayerName:(NSString *)layerName;

@end
