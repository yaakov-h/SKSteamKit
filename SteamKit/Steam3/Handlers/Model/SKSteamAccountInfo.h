//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "SteamLanguage.h"

@class CMsgClientAccountInfo;

extern NSString * const SKSteamAccountInfoUpdateNotification;

@interface SKSteamAccountInfo : NSObject

@property (nonatomic, readonly) NSString * personaName;
@property (nonatomic, readonly) NSString * ipCountry;
@property (nonatomic, readonly) uint32_t numAuthorizedComputers;
@property (nonatomic, readonly) BOOL isLockedWithIPT;
@property (nonatomic, readonly) EAccountFlags flags;

- (id) initWithMessage:(CMsgClientAccountInfo *)accountInfo;

- (BOOL) hasFlag:(EAccountFlags)flag;

@end
