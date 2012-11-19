//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKClientMsgHandler.h"

@class CRPromise;

extern NSString * const SKLogonDetailUsername;
extern NSString * const SKLogonDetailPassword;
extern NSString * const SKLogonDetailSteamGuardCode;

@interface SKSteamUser : SKClientMsgHandler

@property (nonatomic, readonly) uint64_t steamID;

- (CRPromise *) logOnWithDetails:(NSDictionary *)logonDetails;

@end
