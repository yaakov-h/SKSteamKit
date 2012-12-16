//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKPackage.h"
#import "SKCRDataReaderExtensions.h"
#import "Steammessages_base.pb.h"
#import "Steammessages_clientserver.pb.h"

@implementation SKPackage

- (id) initWithPackageDetails:(CMsgClientPackageInfoResponse_Package *)details status:(SKPackageStatus)status
{
	self = [super init];
	if (self)
	{
		_status = status;
		_packageId = details.packageId;
		_changeNumber = details.changeNumber;
		_hash = details.sha;
		
		CRDataReader * reader = [[CRDataReader alloc] initWithData:details.buffer];
		[reader readUInt32]; // Unknown
		_data = [reader sk_readBinaryKeyValues][[NSString stringWithFormat:@"%u", _packageId]];
	}
	return self;
}
- (NSArray *) appIds
{
	return _data[@"appids"];
}

- (NSString *) name
{
	return _data[@"name"];
}

@end
