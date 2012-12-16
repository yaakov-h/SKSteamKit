//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKPICSRequest.h"

@implementation SKPICSRequest

- (id) initWithId:(uint32_t)appOrPackageId
{
	self = [self initWithId:appOrPackageId accessToken:0 publicInfoOnly:YES];
	if (self)
	{
	}
	return self;
}

- (id) initWithId:(uint32_t)appOrPackageId accessToken:(uint64_t)accessToken publicInfoOnly:(BOOL)publicInfoOnly
{
	self = [super init];
	if (self)
	{
		_appOrPackageId = appOrPackageId;
		_accessToken = accessToken;
		_publicInfoOnly = publicInfoOnly;
	}
	return self;
}

@end
