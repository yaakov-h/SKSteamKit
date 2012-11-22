//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "SteamLanguage.h"

@interface SKSteamFriend : NSObject

@property (nonatomic, readonly) uint64_t steamId;

@property (nonatomic) NSString * personaName;
@property (nonatomic) EPersonaState personaState;
@property (nonatomic) NSString * avatarHash;

@property (nonatomic) NSString * gameName;
@property (nonatomic) uint64_t gameId;
@property (nonatomic) uint32_t gameAppId;

@property (nonatomic) EFriendRelationship relationship;

- (id) initWithSteamID:(uint64_t)steamId;

@end
