//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamFriend.h"

@implementation SKSteamFriend

- (id) initWithSteamID:(uint64_t)steamId
{
	self = [super init];
	if (self)
	{
		_steamId = steamId;
	}
	return self;
}

- (void) setSteamId:(uint64_t)steamId
{
	_steamId = steamId;
}

@end
