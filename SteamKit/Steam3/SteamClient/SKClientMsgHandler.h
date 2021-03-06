//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@class SKSteamClient;
@class _SKPacketMsg; // Internal only

@interface SKClientMsgHandler : NSObject

@property (nonatomic, readonly, strong) SKSteamClient * steamClient;

- (void) setUpWithSteamClient:(SKSteamClient *)steamClient;
- (void) handleMessage:(_SKPacketMsg *)packetMessage;

@end
