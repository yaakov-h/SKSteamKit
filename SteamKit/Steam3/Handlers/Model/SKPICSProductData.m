//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKPICSProductData.h"
#import "SteamLanguageInternal.h"
#import <CRBoilerplate/CRBoilerplate.h>
#import "SKCRDataReaderExtensions.h"

@implementation SKPICSProductData

- (id) initWithAppInfoMessage:(CMsgPICSProductInfoResponse_AppInfo *)msg
{
	self = [super init];
	if (self)
	{
		_appOrPackageId = msg.appid;
		_changeNumber = msg.changeNumber;
		_isMissingToken = msg.missingToken;
		_shaHash = msg.sha;
		_onlyPublic = msg.onlyPublic;
		
		// TODO: KeyValues from text (not binary)
		// CRDataReader * kvReader = [[CRDataReader alloc] initWithData:msg.buffer];
		// _keyValues = [kvReader sk_readKeyValues];
	}
	return self;
}

- (id) initWithPackageInfoMessage:(CMsgPICSProductInfoResponse_PackageInfo *)msg
{
	self = [super init];
	if (self)
	{
		_appOrPackageId = msg.packageid;
		_changeNumber = msg.changeNumber;
		_isMissingToken = msg.missingToken;
		_shaHash = msg.sha;
		
		// TODO: KeyValues from text (not binary)
		// CRDataReader * kvReader = [[CRDataReader alloc] initWithData:msg.buffer];
		// _keyValues = [kvReader sk_readKeyValues];
	}
	return self;
}

@end
