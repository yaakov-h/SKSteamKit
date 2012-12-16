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
#import "SKPICSTokenInfo.h"
#import "SKPICSChangesInfo.h"
#import "SKPICSProductInfo.h"
#import "SKPICSRequest.h"

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
			
		case EMsgPICSAccessTokenResponse:
			[self handlePICSAccessTokenResponse:packetMessage];
			break;
			
		case EMsgPICSChangesSinceResponse:
			[self handlePICSChangesSinceResponse:packetMessage];
			break;
			
		case EMsgPICSProductInfoResponse:
			[self handlePICSProductInfoResponse:packetMessage];
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

#pragma mark PICS

- (CRPromise *) PICSGetAccessTokensForApps:(NSArray *)appIDs packages:(NSArray *)packageIDs
{
	_SKClientMsgProtobuf * message = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgPICSAccessTokenRequest class] messageType:EMsgPICSAccessTokenRequest];
	
	CMsgPICSAccessTokenRequest_Builder * builder = [[CMsgPICSAccessTokenRequest_Builder alloc] init];
	
	for(NSNumber * appID in appIDs)
	{
		[builder addAppids:[appID unsignedIntegerValue]];
	}
	
	for(NSNumber * packageID in packageIDs)
	{
		[builder addPackageids:[packageID unsignedIntegerValue]];
	}
	
	message.body = [builder build];
	
	return [self.steamClient sendJobMessage:message];
}

- (CRPromise *) PICSGetProductInfoForApp:(uint32_t)app
{
	return [self PICSGetProductInfoForApps:@[ @(app) ]];
}

- (CRPromise *) PICSGetProductInfoForApps:(NSArray *)apps
{
	return [self PICSGetProductInfoForApps:apps packages:nil onlyPublicInfo:YES onlyMetadata:NO];
}

- (CRPromise *) PICSGetProductInfoForPackage:(uint32_t)package
{
	return [self PICSGetProductInfoForPackages:@[ @(package) ]];
}

- (CRPromise *) PICSGetProductInfoForPackages:(NSArray *)packages
{
	return [self PICSGetProductInfoForApps:nil packages:packages onlyPublicInfo:YES onlyMetadata:NO];
}

- (CRPromise *) PICSGetProductInfoForApps:(NSArray *)apps packages:(NSArray *)packages metadataOnly:(BOOL)metadataOnly
{
	_SKClientMsgProtobuf * message = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgPICSProductInfoRequest class] messageType:EMsgPICSProductInfoRequest];
	
	CMsgPICSProductInfoRequest_Builder * builder = [[CMsgPICSProductInfoRequest_Builder alloc] init];
	
	for (SKPICSRequest * app in apps)
	{
		CMsgPICSProductInfoRequest_AppInfo_Builder * appBuilder = [[CMsgPICSProductInfoRequest_AppInfo_Builder alloc] init];
		[appBuilder setAppid:app.appOrPackageId];
		[appBuilder setAccessToken:app.accessToken];
		[appBuilder setOnlyPublic:app.publicInfoOnly];
		
		[builder addApps:[appBuilder build]];
	}
	
	for (SKPICSRequest * package in packages)
	{
		CMsgPICSProductInfoRequest_PackageInfo_Builder * packageBuilder = [[CMsgPICSProductInfoRequest_PackageInfo_Builder alloc] init];
		[packageBuilder setAccessToken:package.accessToken];
		[packageBuilder setPackageid:package.appOrPackageId];
		
		[builder addPackages:[packageBuilder build]];
	}
	
	[builder setMetaDataOnly:metadataOnly];
	message.body = [builder build];
	
	return [self.steamClient sendJobMessage:message];
}

- (CRPromise *) PICSGetProductInfoForApps:(NSArray *)apps packages:(NSArray *)packages onlyPublicInfo:(BOOL)onlyPublicInfo onlyMetadata:(BOOL)onlyMetadata
{
	NSMutableArray * appRequests = [@[] mutableCopy];
	for (NSNumber * appID in apps)
	{
		SKPICSRequest * request = [[SKPICSRequest alloc] initWithId:[appID unsignedIntegerValue] accessToken:0 publicInfoOnly:onlyPublicInfo];
		[appRequests addObject:request];
	}
	
	NSMutableArray * packageRequest = [@[] mutableCopy];
	for (NSNumber * packageID in packages)
	{
		SKPICSRequest * request = [[SKPICSRequest alloc] initWithId:[packageID unsignedIntegerValue]];
		[packageRequest addObject:request];
	}
	
	return [self PICSGetProductInfoForApps:[appRequests copy] packages:[packageRequest copy] metadataOnly:NO];
}

- (CRPromise *) PICSGetChangesSinceChangeNumber:(uint32_t)changeNumber sendAppChangeList:(BOOL)sendAppChangeList sendPackageChangeList:(BOOL)sendPackageChangeList
{
	_SKClientMsgProtobuf * message = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgPICSChangesSinceRequest class] messageType:EMsgPICSChangesSinceRequest];
	CMsgPICSChangesSinceRequest_Builder * builder = [[CMsgPICSChangesSinceRequest_Builder alloc] init];
	
	[builder setSinceChangeNumber:changeNumber];
	[builder setSendAppInfoChanges:sendAppChangeList];
	[builder setSendPackageInfoChanges:sendPackageChangeList];
	
	return [self.steamClient sendJobMessage:message];
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

#pragma mark PICS

- (void) handlePICSAccessTokenResponse:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * message = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgPICSAccessTokenResponse class] packetMessage:packetMessage];
	CMsgPICSAccessTokenResponse * response = message.body;
	
	SKPICSTokenInfo * info = [[SKPICSTokenInfo alloc] initWithMessage:response];
	[self.steamClient resolveJobMessageWithJobId:packetMessage.targetJobID result:info];
}

- (void) handlePICSChangesSinceResponse:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * message = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgPICSChangesSinceResponse class] packetMessage:packetMessage];
	CMsgPICSChangesSinceResponse * response = message.body;
	
	SKPICSChangesInfo * info = [[SKPICSChangesInfo alloc] initWithMessage:response];
	[self.steamClient resolveJobMessageWithJobId:packetMessage.targetJobID result:info];
}

- (void) handlePICSProductInfoResponse:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * message = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgPICSProductInfoResponse class] packetMessage:packetMessage];
	CMsgPICSProductInfoResponse * response = message.body;
	
	SKPICSProductInfo * info = [[SKPICSProductInfo alloc] initWithMessage:response];
	[self.steamClient resolveJobMessageWithJobId:packetMessage.targetJobID result:info];
}

@end
