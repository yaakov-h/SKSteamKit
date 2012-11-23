//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKLicenceListInfo.h"
#import "Steammessages_clientserver.pb.h"
#import "SKLicence.h"
#import <CRBoilerplate/CRBoilerplate.h>

NSString * const SKSteamLicenceListInfoUpdateNotification = @"SKSteamLicenceListInfoUpdateNotification";

@implementation SKLicenceListInfo

- (id) initWithMessage:(CMsgClientLicenseList *)message
{
	self = [super init];
	if (self)
	{
		NSMutableArray * licences = [@[] mutableCopy];
		for (CMsgClientLicenseList_License * licence in message.licenses)
		{
			[licences addObject:[[SKLicence alloc] initWithLicence:licence]];
		}
		
		_licences = [licences copy];
	}
	return self;
}

@end
