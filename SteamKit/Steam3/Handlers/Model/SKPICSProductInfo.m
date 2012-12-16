//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKPICSProductInfo.h"
#import "SteamLanguageInternal.h"
#import "SKPICSProductData.h"

@implementation SKPICSProductInfo

- (id) initWithMessage:(CMsgPICSProductInfoResponse *)msg
{
	self = [super init];
	if (self)
	{
		_metadataOnly = msg.metaDataOnly;
		_responsePending = msg.responsePending;
		_unknownPackages = [msg valueForKey:@"unknownPackageids"];
		_unknownApps = [msg valueForKey:@"unknownAppids"];
		
		NSMutableDictionary * packages = [@{} mutableCopy];
		NSMutableDictionary * apps = [@{} mutableCopy];
		
		for(CMsgPICSProductInfoResponse_PackageInfo * package in msg.packages)
		{
			packages[@(package.packageid)] = [[SKPICSProductData alloc] initWithPackageInfoMessage:package];
		}
		
		for(CMsgPICSProductInfoResponse_AppInfo * app in msg.apps)
		{
			apps[@(app.appid)] = [[SKPICSProductData alloc] initWithAppInfoMessage:app];
		}
		
		_packages = [packages copy];
		_apps = [apps copy];
	}
	return self;
}

@end
