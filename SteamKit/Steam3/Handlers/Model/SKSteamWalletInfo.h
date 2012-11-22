//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "SteamLanguage.h"

@class CMsgClientWalletInfoUpdate;

extern NSString * const SKSteamWalletInfoUpdateNotification;

@interface SKSteamWalletInfo : NSObject

@property (nonatomic, readonly) uint32_t balance;
@property (nonatomic, readonly) ECurrencyCode currency;

- (id) initWithMessage:(CMsgClientWalletInfoUpdate *)walletInfo;

@end
