//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@class _SKCMClient;
@class _SKPacketMsg;

@protocol _SKCMClientDelegate <NSObject>

@optional
- (void) clientDidConnect:(_SKCMClient *)client;
- (void) client:(_SKCMClient *)client didDisconnectWithError:(NSError *)error;
- (void) client:(_SKCMClient *)client didRecieveMessage:(_SKPacketMsg *)packetMessage;

@end
