//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "SteamLanguage.h"

#define SKSteamIDAccountInstanceMask 0x000FFFFF

typedef enum
{
	SKSteamIDChatInstanceFlagClan = (SKSteamIDAccountInstanceMask + 1) >> 1,
	SKSteamIDChatInstanceFlagLobby = (SKSteamIDAccountInstanceMask + 1) >> 2,
	SKSteamIDChatInstanceFlagMatchmakingLobby = (SKSteamIDAccountInstanceMask + 1) >> 3
} SKSteamIDChatInstanceFlag;

@interface SKSteamID : NSObject

@property (nonatomic, readonly) EUniverse universe;
@property (nonatomic, readonly) EAccountType accountType;
@property (nonatomic, readonly) uint32_t instance;
@property (nonatomic, readonly) uint32_t accountID;
@property (nonatomic, readonly) uint64_t unsignedLongLongValue;

@property (nonatomic, readonly) BOOL isIndividualAccount;
@property (nonatomic, readonly) BOOL isClanAccount;

- (id) initWithUnsignedLongLong:(uint64_t)steamID;
- (id) initWithUniverse:(EUniverse)universe accountType:(EAccountType)accountType instance:(uint32_t)instance accountID:(uint32_t)accountID;

+ (instancetype) steamIDWithUnsignedLongLong:(uint64_t)steamID;

@end
