//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamLoggedOnInfo.h"

@implementation SKSteamLoggedOnInfo

- (id) initWithMessage:(CMsgClientLogonResponse *)message username:(NSString *)username
{
	self = [super init];
	if (self)
	{
		uint32_t publicIp = message.publicIp;
		uint8_t * ipOctets = (uint8_t*)&publicIp;
		_publicIPAddress = [NSString stringWithFormat:@"%d.%d.%d.%d", ipOctets[3], ipOctets[2], ipOctets[1], ipOctets[0]];
		
		_accountFlags = message.accountFlags;
		_webAPIAuthenticationNonce = [message.webapiAuthenticateUserNonce copy];
		_shouldUsePICS = message.usePics;
		_IPCountryCode = [message.ipCountryCode copy];
	}
	return self;
}

@end
