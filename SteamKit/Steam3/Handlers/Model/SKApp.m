//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKApp.h"
#import "Steammessages_base.pb.h"
#import "Steammessages_clientserver.pb.h"
#import <CRBoilerplate/CRBoilerplate.h>
#import "SKCRDataReaderExtensions.h"
#import "SteamLanguage.h"

@implementation SKApp

- (id) initWithAppInfo:(CMsgClientAppInfoResponse_App *)info status:(SKAppInfoStatus)status
{
	self = [super init];
	if (self)
	{
		_status = status;
		_appId = info.appId;
		_changeNumber = info.changeNumber;
		
		NSMutableDictionary * sections = [@{} mutableCopy];
		
		for(CMsgClientAppInfoResponse_App_Section * section in info.sections)
		{
			CRDataReader * reader = [[CRDataReader alloc] initWithData:section.sectionKv];
			NSDictionary * sectionKV = [reader sk_readKeyValues];
			
			EAppInfoSection sectionID = section.sectionId;
			
			sections[@(sectionID)] = [sectionKV allValues][0];
		}
		
		_sections = [sections copy];
	}
	return self;
}

- (NSString *) name
{
	return _sections[@(EAppInfoSectionCommon)][@"name"];
}

@end
