//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKClientMsgHandler.h"

@implementation SKClientMsgHandler

- (void) setUpWithSteamClient:(SKSteamClient *)steamClient
{
    _steamClient = steamClient;
}

- (void) handleMessage:(_SKPacketMsg *)packetMessage
{
}

@end
