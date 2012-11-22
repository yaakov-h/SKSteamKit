//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKNSNotificationExtensions.h"

@implementation NSNotification (SKNSNotificationExtensions)

- (id) steamInfo
{
	return [self userInfo][@"SKNotificationInfo"];
}

@end
