//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@class _SKConnection;

@protocol _SKConnectionDelegate <NSObject>

- (void) connectionDidConnect:(_SKConnection *)connection;
- (void) connection:(_SKConnection *)connection didDisconnectWithError:(NSError *)error;
- (void) connection:(_SKConnection *)connection didReceiveMessageData:(NSData *)data;

@end
