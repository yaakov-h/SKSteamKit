//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "SteamLanguage.h"

@interface _SKMsgUtil : NSObject

+ (int32_t) makeMsg:(EMsg)msg isProtobuf:(BOOL)isProtobuf;
+ (EMsg) getMsg:(uint32_t)msg;
+ (BOOL) isProtobuf:(uint32_t)msg;

@end
