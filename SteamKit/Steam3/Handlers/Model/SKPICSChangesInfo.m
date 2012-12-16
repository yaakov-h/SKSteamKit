//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKPICSChangesInfo.h"
#import "SteamLanguageInternal.h"
#import "SKPICSChange.h"

@implementation SKPICSChangesInfo

- (id) initWithMessage:(CMsgPICSChangesSinceResponse *)msg
{
	self = [super init];
	if (self)
	{
		_lastChangeNumber = msg.sinceChangeNumber;
		_currentChangeNumber = msg.currentChangeNumber;
		_requiresFullUpdate = msg.forceFullUpdate;
		
		NSMutableDictionary * packageChanges = [@{} mutableCopy];
		NSMutableDictionary * appChanges = [@{} mutableCopy];
		
		for (CMsgPICSChangesSinceResponse_PackageChange * change in msg.packageChanges)
		{
			packageChanges[@(change.packageid)] = [[SKPICSChange alloc] initWithPackageChangeMessage:change];
		}
		
		for (CMsgPICSChangesSinceResponse_AppChange * change in msg.appChanges)
		{
			appChanges[@(change.appid)] = [[SKPICSChange alloc] initWithAppChangeMessage:change];
		}
		
		_packageChanges = [packageChanges copy];
		_appChanges = [appChanges copy];
	}
	return self;
}

@end
