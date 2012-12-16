//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKPICSChange.h"
#import "SteamLanguageInternal.h"

@implementation SKPICSChange

- (id) initWithAppChangeMessage:(CMsgPICSChangesSinceResponse_AppChange *)msg
{
	self = [super init];
	if (self)
	{
		_appOrPackageId = msg.appid;
		_changeNumber = msg.changeNumber;
		_requiresAccessToken = msg.needsToken;
	}
	return self;
}

- (id) initWithPackageChangeMessage:(CMsgPICSChangesSinceResponse_PackageChange *)msg
{
	self = [super init];
	if (self)
	{
		_appOrPackageId = msg.packageid;
		_changeNumber = msg.changeNumber;
		_requiresAccessToken = msg.needsToken;
	}
	return self;
}

@end
