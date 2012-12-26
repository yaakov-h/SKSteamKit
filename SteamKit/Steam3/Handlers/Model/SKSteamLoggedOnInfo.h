//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "SteamLanguage.h"

@class CMsgClientLogonResponse;

@interface SKSteamLoggedOnInfo : NSObject

@property (nonatomic, readonly) NSString * publicIPAddress;
@property (nonatomic, readonly) EAccountFlags accountFlags;
@property (nonatomic, readonly) NSString * webAPIAuthenticationNonce;
@property (nonatomic, readonly) BOOL shouldUsePICS;
@property (nonatomic, readonly) NSString * IPCountryCode;

- (id) initWithMessage:(CMsgClientLogonResponse *)message username:(NSString *)username;

@end
