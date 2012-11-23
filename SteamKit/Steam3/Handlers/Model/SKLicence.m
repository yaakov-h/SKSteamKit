//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKLicence.h"
#import "Steammessages_clientserver.pb.h"

@implementation SKLicence

- (id) initWithLicence:(CMsgClientLicenseList_License *)licence
{
	self = [super init];
	if (self)
	{
		_packageId = licence.packageId;
		_lastChangeNumber = licence.changeNumber;
		_timeCreated = [NSDate dateWithTimeIntervalSince1970:licence.timeCreated];
		_timeNextProcess = [NSDate dateWithTimeIntervalSince1970:licence.timeNextProcess];
		_minuteLimit = licence.minuteLimit;
		_minutesUsed = licence.minutesUsed;
		_paymentMethod = licence.paymentMethod;
		_flags = licence.flags;
		_purchaseCountryCode = licence.purchaseCountryCode;
		_type = licence.licenseType;
		_territoryCode = licence.territoryCode;
	}
	return self;
}

@end
