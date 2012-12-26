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
#import "SKSteamWalletInfo.h"
#import "SKSteamAccountInfo.h"
#import "SKSteamLoggedOnInfo.h"
#import "SKSteamLoggedOffInfo.h"
#import "SKSteamID.h"

NSString * const SKLogonDetailUsername = @"SKLogonDetailUsername";
NSString * const SKLogonDetailPassword = @"SKLogonDetailPassword";
NSString * const SKLogonDetailSteamGuardCode = @"SKLogonDetailSteamGuardCode";
NSString * const SKLogonDetailRememberMe = @"SKLogonDetailRememberMe";
NSString * const SKLogonDetailLoginKey = @"SKLogonDetailLoginKey";

@implementation SKSteamUser
{
    CRDeferred * _loginDeferred;
	NSString * _userName;
}

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
        case EMsgClientLogOnResponse:
            [self handleClientLogOnResponse:packetMessage];
            break;
            
		case EMsgClientUpdateMachineAuth:
			[self handleClientUpdateMachineAuth:packetMessage];
			break;
			
		case EMsgClientAccountInfo:
			[self handleClientAccountInfo:packetMessage];
			break;
			
		case EMsgClientLoggedOff:
			[self handleClientLoggedOff:packetMessage];
			break;
			
		case EMsgClientWalletInfoUpdate:
			[self handleClientWalletInfo:packetMessage];
			break;
			
		case EMsgClientNewLoginKey:
			[self handleClientNewLoginKey:packetMessage];
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
	NSString * loginKey = logonDetails[SKLogonDetailLoginKey];
	NSNumber * rememberMe = logonDetails[SKLogonDetailRememberMe];
    
    _SKClientMsgProtobuf * loginMessage = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientLogon class] messageType:EMsgClientLogon];
    
    loginMessage.sessionID = 0;
    loginMessage.steamID = [[[SKSteamID alloc] initWithUniverse:self.steamClient.connectedUniverse accountType:EAccountTypeIndividual instance:1 accountID:0] unsignedLongLongValue];
    
    CMsgClientLogon_Builder * builder = [[CMsgClientLogon_Builder alloc] init];
    
    [builder setAccountName:username];
	
	if (password != nil)
	{
		[builder setPassword:password];
	}
	
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
	
	if (rememberMe != nil)
	{
		[builder setShouldRememberPassword:[rememberMe boolValue]];
	}
	
	if (loginKey != nil)
	{
		[builder setLoginKey:loginKey];
	}
    
    loginMessage.body = [builder build];
    
    _loginDeferred = [[CRDeferred alloc] init];
	
	_userName = username;
    
    [self.steamClient sendMessage:loginMessage];
    
    return [_loginDeferred promise];
}

- (CRPromise *) logOnAnonymously
{
    _SKClientMsgProtobuf * loginMessage = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientLogon class] messageType:EMsgClientLogon];
    
    loginMessage.sessionID = 0;
    loginMessage.steamID = [[[SKSteamID alloc] initWithUniverse:self.steamClient.connectedUniverse accountType:EAccountTypeAnonUser instance:0 accountID:0] unsignedLongLongValue];
    
    CMsgClientLogon_Builder * builder = [[CMsgClientLogon_Builder alloc] init];
	
    [builder setProtocolVersion:[_SKMsgClientLogon CurrentProtocol]];
    [builder setClientOsType:EOSTypeMacOSUnknown];
	
    [builder setClientPackageVersion:1771];
    [builder setClientLanguage:@"english"];
    
	NSUUID * uniqueId = [[UIDevice currentDevice] identifierForVendor];
	NSString * uniqueIdString = [uniqueId UUIDString];
	NSData * uniqueIdData = [uniqueIdString dataUsingEncoding:NSUTF8StringEncoding];
	NSData * uniqueIdHash = [uniqueIdData cr_sha1HashValue];
	[builder setMachineId:uniqueIdHash];
	
    loginMessage.body = [builder build];
    
    _loginDeferred = [[CRDeferred alloc] init];
	_userName = nil;
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
{
	NSArray * cacheDirectories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString * cacheDir = cacheDirectories[0];
	NSURL * cacheDirUrl = [[NSURL fileURLWithPath:cacheDir] URLByAppendingPathComponent:@"org.opensteamworks.steamkit"];
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
	
	if (sentryFileName == nil)
	{
		return nil;
	}
	
	NSURL * sentryFileUrl = [self sentryFileURLForFileName:sentryFileName];
	return [NSData dataWithContentsOfURL:sentryFileUrl];
}

#pragma mark -
#pragma 'Remember Me' login
// Storage for this should probably be moved to the Keychain

static NSString * const _SKLastLoginUserNameKey = @"SKSteamLastLoginUserName";
static NSString * const _SKSteamLoginKeyKey = @"SKSteamLoginKey";

- (NSString *) lastLoginUserName
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:_SKLastLoginUserNameKey];
}

- (void) setLastLoginUserName:(NSString*)lastLoginUserName
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:lastLoginUserName forKey:_SKLastLoginUserNameKey];
	[defaults removeObjectForKey:_SKSteamLoginKeyKey];
	[defaults synchronize];
}

- (NSString *) lastLoginKey
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:_SKSteamLoginKeyKey];
}

- (void) setLoginKey:(NSString *)loginKey
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:loginKey forKey:_SKSteamLoginKeyKey];
	[defaults synchronize];
}

- (BOOL) hasRememberedPassword
{
	return [self lastLoginUserName] != nil && [self lastLoginKey].length > 0;
}

- (CRPromise *) logOnWithStoredDetails
{
	NSDictionary * details = @{
		SKLogonDetailUsername : [self lastLoginUserName],
		SKLogonDetailLoginKey: [self lastLoginKey]
	};
	
	return [self logOnWithDetails:details];
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
		[self setLastLoginUserName:_userName];
		SKSteamLoggedOnInfo * info = [[SKSteamLoggedOnInfo alloc] initWithMessage:logonResponse.body username:_userName];
        [_loginDeferred resolveWithResult:info];
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
	[builder setFilename:machineAuth.filename];
	[builder setFilesize:machineAuth.cubtowrite];
	[builder setShaFile:[dataToWrite cr_sha1HashValue]];
	[builder setEresult:EResultOK];
	
	response.body = [builder build];
	[self.steamClient sendMessage:response];
}

- (void) handleClientWalletInfo:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * walletInfoMessage = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientWalletInfoUpdate class] packetMessage:packetMessage];
	CMsgClientWalletInfoUpdate * walletInfo = walletInfoMessage.body;
	
	SKSteamWalletInfo * info = [[SKSteamWalletInfo alloc] initWithMessage:walletInfo];
	_walletInfo = info;
	[self.steamClient postNotification:SKSteamWalletInfoUpdateNotification withInfo:info];
}

- (void) handleClientAccountInfo:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * accountInfoMessage = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientAccountInfo class] packetMessage:packetMessage];
	CMsgClientAccountInfo * accountInfo = accountInfoMessage.body;
	
	SKSteamAccountInfo * info = [[SKSteamAccountInfo alloc] initWithMessage:accountInfo];
	_accountInfo = info;
	[self.steamClient postNotification:SKSteamAccountInfoUpdateNotification withInfo:info];
}

- (void) handleClientLoggedOff:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * loggedOffMessage = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientLoggedOff class] packetMessage:packetMessage];
	CMsgClientLoggedOff * loggedOff = loggedOffMessage.body;
	
	SKSteamLoggedOffInfo * info = [[SKSteamLoggedOffInfo alloc] initWithMessage:loggedOff];
	[self.steamClient postNotification:SKSteamLoggedOffNotification withInfo:info];
}

- (void) handleClientNewLoginKey:(_SKPacketMsg *)packetMessage
{
	_SKClientMsgProtobuf * newLoginKeyMessage = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientNewLoginKey class] packetMessage:packetMessage];
	CMsgClientNewLoginKey * newLoginKey = newLoginKeyMessage.body;
	
	NSString * loginKey = newLoginKey.loginKey;
	[self setLoginKey:loginKey];
	
	_SKClientMsgProtobuf * response = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientNewLoginKeyAccepted class] messageType:EMsgClientNewLoginKeyAccepted];
	
	CMsgClientNewLoginKeyAccepted_Builder * builder = [[CMsgClientNewLoginKeyAccepted_Builder alloc] init];
	[builder setUniqueId:newLoginKey.uniqueId];
	
	response.body = [builder build];
	[self.steamClient sendMessage:response];
}

@end
