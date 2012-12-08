//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKClientMsgHandler.h"

@class _SKClientGCMsg;

@interface SKSteamGameCoordinator : SKClientMsgHandler

- (id) init;
- (void) sendGCMessage:(_SKClientGCMsg *)message forApp:(uint32_t) appID;

@end
