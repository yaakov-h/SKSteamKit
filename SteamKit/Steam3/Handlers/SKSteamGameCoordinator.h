//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKClientMsgHandler.h"

@class _SKGCMsgBase;

@interface SKSteamGameCoordinator : SKClientMsgHandler

- (id) init;
- (void) sendGCMessage:(_SKGCMsgBase *)message forApp:(uint32_t) appID;

- (void) sendClientHelloWithVersion:(uint32_t)version forApp:(uint32_t) appID;

@end
