//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "_SKMsgBase.h"

@interface _SKMsg : _SKMsgBase

@property (nonatomic, strong, readonly) id body;

- (id) initWithBodyClass:(Class)bodyClass;
- (id) initWithBodyClass:(Class)bodyClass sourceJobMessage:(_SKMsgBase *)sourceJobMsg;
- (id) initWithBodyClass:(Class)bodyClass data:(NSData *)data;

@end
