//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamLoggedOffInfo.h"
#import "Steammessages_clientserver.pb.h"

NSString * const SKSteamLoggedOffNotification = @"SKSteamLoggedOffNotification";

@implementation SKSteamLoggedOffInfo

- (id) initWithMessage:(CMsgClientLoggedOff *)message
{
	self = [super init];
	if (self)
	{
		_result = message.eresult;
	}
	return self;
}

@end
