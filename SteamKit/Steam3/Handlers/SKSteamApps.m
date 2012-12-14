//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamApps.h"
#import "_SKPacketMsg.h"
#import "_SKClientMsgProtobuf.h"
#import "Steammessages_clientserver.pb.h"
#import "SKLicenceListInfo.h"
#import "SKSteamClient.h"
#import "SKPackage.h"
#import "SKLicence.h"
#import "SKApp.h"
#import <CRBoilerplate/CRBoilerplate.h>

@implementation SKSteamApps

- (id) init
{
	self = [super init];
	if (self)
	{
	}
	return self;
}

- (void) handleMessage:(_SKPacketMsg *)packetMessage
{
	switch (packetMessage.messageType)
	{
		case EMsgClientLicenseList:
			[self handleLicenceList:packetMessage];
			break;
			
		case EMsgClientVACBanStatus:
			[self handleClientVACBanStatus:packetMessage];
			break;
			
		case EMsgClientAppInfoChanges:
			[self handleClientAppInfoChanges:packetMessage];
			break;
		
		case EMsgClientAppInfoResponse:
			[self handleClientAppInfoResponse:packetMessage];
			break;
			
		case EMsgClientPackageInfoResponse:
			[self handleClientPackageInfoResponse:packetMessage];
			break;
			
		default: break;
	}
}

- (void) requestPackageInfoForPackagesWithIDs:(NSArray *)packageIDs
{
	CMsgClientPackageInfoRequest_Builder * builder = [[CMsgClientPackageInfoRequest_Builder alloc] init];
	[builder setPackageIdsArray:packageIDs];
	_SKClientMsgProtobuf * msgOut = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientPackageInfoRequest class] messageType:EMsgClientPackageInfoRequest];
	msgOut.body = [builder build];
	[self.steamClient sendMessage:msgOut];
}

- (void) requestAppInfoForAppsWithIDs:(NSArray *)appIDs
{
	CMsgClientAppInfoRequest_Builder * builder = [[CMsgClientAppInfoRequest_Builder alloc] init];
	
	for (NSNumber * appID in appIDs)
	{
		CMsgClientAppInfoRequest_App_Builder * appBuilder = [[CMsgClientAppInfoRequest_App_Builder alloc] init];
		[appBuilder setAppId:[appID unsignedLongValue]];
		[appBuilder setSectionCrcArray:@[]];
		[appBuilder setSectionFlags:0xFFFF]; // All sections by default
		[builder addApps:[appBuilder build]];
	}
	
	_SKClientMsgProtobuf * msgOut = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientAppInfoRequest class] messageType:EMsgClientAppInfoRequest];
	msgOut.body = [builder build];
	[self.steamClient sendMessage:msgOut];
}

- (void) setGameBeingPlayed:(uint32_t)gameID
{
	if (gameID > 0)
	{
		[self setGamesBeingPlayed:@[ @(gameID) ]];
	} else {
		[self setGamesBeingPlayed:nil];
	}
}

- (void) setGamesBeingPlayed:(NSArray *)gameIDs
{
	_SKClientMsgProtobuf * message = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientGamesPlayed class] messageType:EMsgClientGamesPlayedWithDataBlob];
	
	CMsgClientGamesPlayed_Builder * builder = [[CMsgClientGamesPlayed_Builder alloc] init];
	
	for(NSNumber * gameID in gameIDs)
	{
		CMsgClientGamesPlayed_GamePlayed_Builder * gamebuilder = [[CMsgClientGamesPlayed_GamePlayed_Builder alloc] init];
		gamebuilder.gameId = [gameID unsignedLongLongValue];
		[builder addGamesPlayed:[gamebuilder build]];
	}
	
	message.body = [builder build];
	[self.steamClient sendMessage:message];
}

#pragma mark -
#pragma mark Handlers

- (void) handleLicenceList:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * message = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientLicenseList class] packetMessage:packetMessage];
	CMsgClientLicenseList * list = message.body;
	
	SKLicenceListInfo * info = [[SKLicenceListInfo alloc] initWithMessage:list];
	[self.steamClient postNotification:SKSteamLicenceListInfoUpdateNotification withInfo:info];
	
	[self requestPackageInfoForPackagesWithIDs:[info.licences valueForKey:@"packageId"]];
}

- (void) handleClientVACBanStatus:(_SKPacketMsg *)packetMessage
{
	// TODO
}

- (void) handleClientAppInfoChanges:(_SKPacketMsg *)packetMessage
{
}

- (void) handleClientAppInfoResponse:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * message = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientAppInfoResponse class] packetMessage:packetMessage];
	CMsgClientAppInfoResponse * response = message.body;
	
	NSMutableArray * mutApps = [@[] mutableCopy];
	
	for(CMsgClientAppInfoResponse_App * appInfo in response.apps)
	{
		SKApp * app = [[SKApp alloc] initWithAppInfo:appInfo status:SKAppInfoStatusOK];
		[mutApps addObject:app];
	}
	
	for(CMsgClientAppInfoResponse_App * appInfo in response.apps)
	{
		SKApp * app = [[SKApp alloc] initWithAppInfo:appInfo status:SKAppInfoStatusUnknown];
		[mutApps addObject:app];
	}
	
	// TODO: Do something with apps. Job callback / notifications
	NSArray * apps = [mutApps copy];
}

- (void) handleClientPackageInfoResponse:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * message = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientPackageInfoResponse class] packetMessage:packetMessage];
	CMsgClientPackageInfoResponse * response = message.body;
	
	NSMutableArray * mutItems = [@[] mutableCopy];
	
	for(CMsgClientPackageInfoResponse_Package * package in response.packages)
	{
		SKPackage * pkg = [[SKPackage alloc] initWithPackageDetails:package status:SKPackageStatusOK];
		[mutItems addObject:pkg];
	}
	
	for(CMsgClientPackageInfoResponse_Package * package in response.packagesUnknown)
	{
		SKPackage * pkg = [[SKPackage alloc] initWithPackageDetails:package status:SKPackageStatusUnknown];
		[mutItems addObject:pkg];
	}
	
	// TODO: Do something with items. Job callback / notifications
	NSArray * items = [mutItems copy];
	
	// In the meantime, just request app info for all apps in packages we just loaded
	NSArray * allAppIDs = [[[items valueForKeyPath:@"appIds"] cr_selectMany] allObjects];
	[self requestAppInfoForAppsWithIDs:allAppIDs];
}

@end
