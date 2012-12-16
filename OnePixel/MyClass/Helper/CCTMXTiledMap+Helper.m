//
//  CCTMXTiledMap+Helper.m
//  Kangaroo
//
//  Created by Roman Semenov on 11/28/12.
//
//

#import "CCTMXTiledMap+Helper.h"
#import "cocos2d.h"
#import "Player.h"

@implementation CCTMXTiledMap (Helper)

//-(void)setViewpointCenter:(CGPoint) position {
//    
//    CGSize winSize = [[CCDirector sharedDirector] winSize];
//    
//    int x = MAX(position.x, winSize.width / 2);
//    int y = MAX(position.y, winSize.height / 2);
//    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width) - winSize.width / 2);
//    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height) - winSize.height/2);
//    CGPoint actualPosition = ccp(x, y);
//    
//    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
//    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
//    self.position = viewPoint;
//    
//}

- (CGPoint) floatingTilePosFromLocation:(CGPoint)location
{
    CCDirector *director = [CCDirector sharedDirector];
	CGPoint pos = ccpSub(location , self.position);
    
    float halfMapWidth = self.mapSize.width * 0.5f;
	float mapHeight = self.mapSize.height;
    
	float tileWidth = self.tileSize.width / [director contentScaleFactor];
	float tileHeight = self.tileSize.height / [director contentScaleFactor];
    
	CGPoint tilePosDiv = CGPointMake(pos.x / tileWidth, pos.y / tileHeight);
	float mapHeightDiff = mapHeight - tilePosDiv.y;
	
	float posX = (mapHeightDiff + tilePosDiv.x - halfMapWidth);
	float posY = (mapHeightDiff - tilePosDiv.x + halfMapWidth);
    
	return CGPointMake(posX, posY);
}


- (CGPoint) positionFocusObjectName:(NSString*)name;
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CCTMXObjectGroup *objects = [self objectGroupNamed:@"Objects"];
    NSMutableDictionary *spawnPlayer = [objects objectNamed:name];
    NSAssert(spawnPlayer.count > 0, @"SpawnPoint object missing");
    
    CCDirector *director = [CCDirector sharedDirector];
    
    CGFloat x = [[spawnPlayer valueForKey:@"x"] floatValue] ;
    CGFloat y = [[spawnPlayer valueForKey:@"y"] floatValue];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        x = x * 2;
        y = y * 2 - (self.mapSize.height * self.tileSize.height);
    }
    
    if ([director contentScaleFactor] == 2)//werwer
    {
        y = y - (self.tileSize.height / 2) * self.mapSize.height;
    }
    
    CGFloat mapTileOffsetX = (self.tileSize.width /  [director contentScaleFactor]) / 2;
    CGFloat mapTileOffsetY = (self.tileSize.height /  [director contentScaleFactor])  / 2;
    
    x = (x / (self.tileSize.height /  [director contentScaleFactor]));
    y = (y / (self.tileSize.height /  [director contentScaleFactor]));
    
    x = roundf(x);
    y = roundf(y);
    
    CGFloat halfHeightMap = (self.tileSize.height /  [director contentScaleFactor]) * (-self.mapSize.height / 2);
    
    CGPoint point = CGPointMake(screenSize.width / 2 - (y + x) * mapTileOffsetX,
                                (screenSize.height / 2 + halfHeightMap  - (y - x) * mapTileOffsetY) - mapTileOffsetY);
    return  point;
}

- (CGPoint) spawnPosition:(CGPoint) mapSpawnPoint
{
    CGPoint spawnPosition = mapSpawnPoint;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        spawnPosition.x = spawnPosition.x * 2;
        spawnPosition.y = spawnPosition.y * 2 - (self.mapSize.height * self.tileSize.height);
    }
    if ([[CCDirector sharedDirector] contentScaleFactor] == 2)
    {
        spawnPosition.y = spawnPosition.y - (self.tileSize.height / 2) * self.mapSize.height;
    }
    
    return [self convertSpawn:spawnPosition];
}

- (CGPoint) convertSpawn:(CGPoint)oldSpawnPoint
{
    CCDirector *director = [CCDirector sharedDirector];
    
    CGPoint spawnPosition;
    
    spawnPosition.x = oldSpawnPoint.x /(self.tileSize.height / [director contentScaleFactor]);
    spawnPosition.y = oldSpawnPoint.y /(self.tileSize.height / [director contentScaleFactor]);
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGPoint newPoint;
    newPoint.x = (spawnPosition.y + spawnPosition.x ) * ((self.tileSize.width/2) / [director contentScaleFactor]) + (screenSize.width / 2 ) - (self.tileSize.width/2) / [director contentScaleFactor];
    newPoint.y = (spawnPosition.y - spawnPosition.x) * ((self.tileSize.height/2) / [director contentScaleFactor]) + (screenSize.height / 2);
    
    return newPoint;
}

- (BOOL)isValidTileCoord:(CGPoint)tileCoord
{
    if (tileCoord.x < 0 || tileCoord.y < 0 ||
        tileCoord.x >= self.mapSize.width ||
        tileCoord.y >= self.mapSize.height)
    {
        return FALSE;
    } else
    {
        return TRUE;
    }
}

- (BOOL)isProp:(NSString*)prop atTileCoord:(CGPoint)tileCoord forLayerName:(NSString *)layerName
{
    CCTMXLayer* layer = [self layerNamed:layerName];
	NSAssert(layer != nil, @"layer not found!");
    return [self isProp:prop atTileCoord:tileCoord forLayer:layer];
}

- (BOOL)isProp:(NSString*)prop atTileCoord:(CGPoint)tileCoord forLayer:(CCTMXLayer *)layer
{
    if (![self isValidTileCoord:tileCoord]) return NO;
    int gid = [layer tileGIDAt:tileCoord];
    NSDictionary * properties = [self propertiesForGID:gid];
    if (properties == nil) return NO;
    return [properties objectForKey:prop] != nil;
}

@end
