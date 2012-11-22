//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamAccountInfo.h"
#import "Steammessages_clientserver.pb.h"

NSString * const SKSteamAccountInfoUpdateNotification = @"SKSteamAccountInfoUpdateNotification";

@implementation SKSteamAccountInfo

- (id) initWithMessage:(CMsgClientAccountInfo *)accountInfo
{
	self = [super init];
	if (self)
	{
		_personaName = accountInfo.personaName;
		_ipCountry = accountInfo.ipCountry;
		_numAuthorizedComputers = accountInfo.countAuthedComputers;
		_isLockedWithIPT = accountInfo.lockedWithIpt;
		_flags = accountInfo.accountFlags;
	}
	return self;
}

- (BOOL) hasFlag:(EAccountFlags)flag
{
	return (self.flags & flag) != 0;
}

@end
