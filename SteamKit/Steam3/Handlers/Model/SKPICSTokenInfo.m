//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKPICSTokenInfo.h"
#import "SteamLanguageInternal.h"

@implementation SKPICSTokenInfo

- (id) initWithMessage:(CMsgPICSAccessTokenResponse *)msg
{
	self = [super init];
	if (self)
	{
		_packageTokens = [msg valueForKey:@"packageDeniedTokens"];
		_appTokensDenied = [msg valueForKey:@"appDeniedTokens"];
		
		NSMutableDictionary * packageTokens = [@{} mutableCopy];
		NSMutableDictionary * appTokens = [@{} mutableCopy];
		
		for(CMsgPICSAccessTokenResponse_PackageToken * token in msg.packageAccessTokens)
		{
			packageTokens[@(token.packageid)] = @(token.accessToken);
		}
		
		for(CMsgPICSAccessTokenResponse_AppToken * token in msg.appAccessTokens)
		{
			appTokens[@(token.appid)] = @(token.accessToken);
		}
		
		_packageTokens = [packageTokens copy];
		_appTokens = [appTokens copy];
	}
	return self;
}

@end
