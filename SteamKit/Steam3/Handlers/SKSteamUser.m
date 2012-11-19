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
    
    loginMessage.body = [builder build];
    
    _loginDeferred = [[CRDeferred alloc] init];
    
    [self.steamClient sendMessage:loginMessage];
    
    return [_loginDeferred promise];
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

@end
