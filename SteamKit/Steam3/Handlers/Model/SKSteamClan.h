//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "SteamLanguage.h"

@interface SKSteamClan : NSObject

@property (nonatomic, readonly) uint64_t steamId;

@property (nonatomic) NSString * name;
@property (nonatomic) EClanRelationship relationship;
@property (nonatomic) NSString * avatarHash;

- (id) initWithSteamID:(uint64_t)steamId;

@end
