//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamUser.h"
#import "_SKPacketMsg.h"
#import "_SKClientMsgProtobuf.h"
#import "SKSteamClient.h"
#import "SteamLanguageInternal.h"
#import "_SKCMClient.h"
#import <CRBoilerplate/CRBoilerplate.h>

NSString * const SKLogonDetailUsername = @"SKLogonDetailUsername";
NSString * const SKLogonDetailPassword = @"SKLogonDetailPassword";
NSString * const SKLogonDetailSteamGuardCode = @"SKLogonDetailSteamGuardCode";

@implementation SKSteamUser
{
    CRDeferred * _loginDeferred;
}

- (void) handleMessage:(_SKPacketMsg *)packetMessage
{
    switch (packetMessage.messageType)
    {
        case EMsgClientLogOnResponse:
            [self handleClientLogOnResponse:packetMessage];
            break;
            
		case EMsgClientUpdateMachineAuth:
			[self handleClientUpdateMachineAuth:packetMessage];
			break;
            
        default: break;
    }
}

- (uint64_t) steamID
{
    return self.steamClient.client.steamID;
}

- (CRPromise *) logOnWithDetails:(NSDictionary *)logonDetails
{
    NSString * username = logonDetails[SKLogonDetailUsername];
    NSString * password = logonDetails[SKLogonDetailPassword];
    NSString * steamGuardCode = logonDetails[SKLogonDetailSteamGuardCode];
    
    _SKClientMsgProtobuf * loginMessage = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientLogon class] messageType:EMsgClientLogon];
    
    loginMessage.sessionID = 0;
    loginMessage.steamID = 76561197960265728LU; // Public universe, Individual, 1 instance, 0 account
    
    CMsgClientLogon_Builder * builder = [[CMsgClientLogon_Builder alloc] init];
    
    [builder setAccountName:username];
    [builder setPassword:password];
    [builder setProtocolVersion:[_SKMsgClientLogon CurrentProtocol]];
    [builder setClientOsType:EOSTypeMacOSUnknown];
    [builder setClientPackageVersion:1771];
    [builder setClientLanguage:@"english"];
    
    if (steamGuardCode != nil)
    {
        [builder setAuthCode:steamGuardCode];
    }
	
	NSData * sentryFileData = [self readSentryFile];
	if (sentryFileData != nil)
	{
		NSData * sentryFileHash = [sentryFileData cr_sha1HashValue];
		[builder setShaSentryfile:sentryFileHash];
		[builder setEresultSentryfile:EResultOK];
	} else {
		[builder setEresultSentryfile:EResultFileNotFound];
	}
	
	NSUUID * uniqueId = [[UIDevice currentDevice] identifierForVendor];
	NSString * uniqueIdString = [uniqueId UUIDString];
	NSData * uniqueIdData = [uniqueIdString dataUsingEncoding:NSUTF8StringEncoding];
	NSData * uniqueIdHash = [uniqueIdData cr_sha1HashValue];
	[builder setMachineId:uniqueIdHash];
    
    loginMessage.body = [builder build];
    
    _loginDeferred = [[CRDeferred alloc] init];
    
    [self.steamClient sendMessage:loginMessage];
    
    return [_loginDeferred promise];
}

#pragma mark -
#pragma mark Steam Guard

- (void) writeData:(NSData *)data toSentryFile:(NSString *)sentryFileName
{
	NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:sentryFileName forKey:@"SKSteamSentryFileName"];
	[userDefaults synchronize];
	
	NSURL * sentryFileUrl = [self sentryFileURLForFileName:sentryFileName];
	[data writeToURL:sentryFileUrl atomically:YES];
}

- (NSURL *) sentryFileURLForFileName:(NSString *)fileName
{	NSArray * cacheDirectories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString * cacheDir = cacheDirectories[0];
	NSURL * cacheDirUrl = [[NSURL fileURLWithPath:cacheDir] URLByAppendingPathComponent:@"com.opensteamworks.steamchat"];
	NSURL * sentryFileUrl = [cacheDirUrl URLByAppendingPathComponent:fileName];
	
	NSFileManager * fileManager = [NSFileManager defaultManager];
	BOOL isDirectory = NO;
	BOOL exists = [fileManager fileExistsAtPath:[cacheDirUrl path] isDirectory:&isDirectory];
	
	if (!exists)
	{
		[fileManager createDirectoryAtURL:cacheDirUrl withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	return sentryFileUrl;
}

- (NSData *) readSentryFile
{
	NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
	NSString * sentryFileName = [userDefaults objectForKey:@"SKSteamSentryFileName"];
	
	NSURL * sentryFileUrl = [self sentryFileURLForFileName:sentryFileName];
	return [NSData dataWithContentsOfURL:sentryFileUrl];
}

#pragma mark -
#pragma mark Handlers

- (void) handleClientLogOnResponse:(_SKPacketMsg *)packetMessage
{
    if (!packetMessage.isProtobuf)
    {
        // Not our business
        return;
    }
    
    _SKClientMsgProtobuf * logonResponse = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientLogonResponse class] packetMessage:packetMessage];
    
    EResult result = [logonResponse.body eresult];
    if (result == EResultOK)
    {
        [_loginDeferred resolveWithResult:logonResponse.body];
    }
    else
    {
        NSError * error = [[NSError alloc] initWithDomain:@"SteamKit" code:result userInfo:@{@"Response": logonResponse.body}];
        [_loginDeferred rejectWithError:error];
    }
    
    _loginDeferred = nil;
}

- (void) handleClientUpdateMachineAuth:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * machineAuthMessage = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientUpdateMachineAuth class] packetMessage:packetMessage];
	CMsgClientUpdateMachineAuth * machineAuth = machineAuthMessage.body;
	
    _SKClientMsgProtobuf * response = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientUpdateMachineAuthResponse class] messageType:EMsgClientUpdateMachineAuthResponse sourceJobMessage:machineAuthMessage];
	
	CMsgClientUpdateMachineAuthResponse_Builder * builder = [[CMsgClientUpdateMachineAuthResponse_Builder alloc] init];
	
	NSData * dataToWrite = machineAuth.data;
	[self writeData:dataToWrite toSentryFile:machineAuth.filename];
	
	[builder setCubwrote:machineAuth.cubtowrite];
	[builder setOffset:machineAuth.offset];
	[builder setOtpIdentifier:machineAuth.otpIdentifier];
	[builder setOtpType:machineAuth.otpType];
	[builder setFilename:machineAuth.filename];
	[builder setFilesize:machineAuth.cubtowrite];
	[builder setShaFile:[dataToWrite cr_sha1HashValue]];
	[builder setEresult:EResultOK];
	
	response.body = [builder build];
	[self.steamClient sendMessage:response];
}

@end
