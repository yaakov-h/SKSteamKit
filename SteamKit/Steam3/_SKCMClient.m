//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package, 
//

#import "_SKCMClient.h"
#import "_SKConnection.h"
#import "_SKTCPConnection.h"
#import <CRBoilerplate/CRBoilerplate.h>
#import "SteamLanguage.h"
#import "_SKMsgUtil.h"
#import "_SKPacketMsg.h"
#import "_SKPlainPacketMsg.h"
#import "_SKProtobufPacketMsg.h"
#import "_SKClientPacketMsg.h"
#import "SteamLanguageInternal.h"
#import "_SKMsg.h"
#import "_SKKeyDictionary.h"
#import "NSData+RSA.h"
#import "_SKNetFilterEncryption.h"
#import "_SKClientMsgProtobuf.h"
#import "NSData+Multi.h"

typedef enum
{
    _SKCMClientPortPublic = 27014,
    _SKCMClientPortPublicEncrypted = 27017,
    
    _SKCMClientPortDefault = _SKCMClientPortPublicEncrypted,
    //_SKCMClientPortDefault = _SKCMClientPortPublic,
} _SKCMClientPort;

@implementation _SKCMClient
{
    _SKConnection * _connection;
    NSNumber * _sessionId;
    NSNumber * _steamId;
    
    NSData * _temporarySessionKey;
    BOOL _encrypted;
    
    NSTimer * _heartbeatTimer;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        _connection = [[_SKTCPConnection alloc] init];
        _connection.delegate = self;
    }
    return self;
}

- (uint32_t) localIPAddress
{
    return [_connection localIPAddress];
}

- (BOOL) connectToServer:(NSNumber *)server error:(NSError *__autoreleasing *)error
{
    return [_connection connectToAddress:[server unsignedIntegerValue] port:_SKCMClientPortDefault error:error];
}

- (void) disconnect
{
    [_connection disconnect];
}

- (uint64_t) steamID
{
	return [_steamId unsignedLongLongValue];
}

#pragma mark -
#pragma mark Hardcoded Server List

+ (NSArray *) serverList
{
    NSMutableArray * list = [NSMutableArray array];
    
#define _SK_IPADDR(a, b, c, d) [list addObject:@((a << 24 | b << 16 | c << 8 | d))]
    
    // Limelight, New York
    _SK_IPADDR( 68, 142, 91, 34 );
    // _SK_IPADDR( 68, 142, 91, 35 );
    _SK_IPADDR( 68, 142, 91, 36 );
    
    // Limelight, San Jose
    _SK_IPADDR( 68, 142, 116, 178 );
    _SK_IPADDR( 68, 142, 116, 179 );
    
    // Limelight, Los Angeles
    _SK_IPADDR( 69, 28, 145, 170 );
    _SK_IPADDR( 69, 28, 145, 171 );
    _SK_IPADDR( 69, 28, 145, 172 );
    
    // CenturyLink/Qwest, Seattle
    _SK_IPADDR( 72, 165, 61, 174 );
    _SK_IPADDR( 72, 165, 61, 175 );
    _SK_IPADDR( 72, 165, 61, 176 );
    _SK_IPADDR( 72, 165, 61, 185 );
    // _SK_IPADDR( 72, 165, 61, 186 );
    _SK_IPADDR( 72, 165, 61, 187 );
    _SK_IPADDR( 72, 165, 61, 188 );
    
    // Eweka, Netherlands
    // _SK_IPADDR( 81, 171, 115, 5 );
    // _SK_IPADDR( 81, 171, 115, 6 );
    // _SK_IPADDR( 81, 171, 115, 7 );
    // _SK_IPADDR( 81, 171, 115, 8 );
    
    // Limelight, Japan
    _SK_IPADDR( 203, 77, 185, 4 );
    _SK_IPADDR( 203, 77, 185, 5 );
    
    // Limelight, Seattle
    _SK_IPADDR( 208, 111, 133, 84 );
    _SK_IPADDR( 208, 111, 133, 85 );
    
    // Limelight, Chicago
    // _SK_IPADDR( 208, 111, 158, 52 );
    // _SK_IPADDR( 208, 111, 158, 53 );
    _SK_IPADDR( 208, 111, 171, 82 );
    // _SK_IPADDR( 208, 111, 171, 83 );
    
#undef _SK_IPADDR
    
    return [list copy];
}

#pragma mark -
#pragma mark _SKConnectionDelegate

- (void) connectionDidConnect:(_SKConnection *)connection
{
    CRLog(@"%@ connected", NSStringFromClass([self class]));

    BOOL isUnencryptedChannel = (_SKCMClientPortDefault == _SKCMClientPortPublic);
    if (isUnencryptedChannel && [self.delegate respondsToSelector:@selector(clientDidConnect:)])
    {
        [self.delegate clientDidConnect:self];
    }
}

- (void) connection:(_SKConnection *)connection didDisconnectWithError:(NSError *)error
{
    CRLog(@"%@ disconnected", NSStringFromClass([self class]));
    
    if ([self.delegate respondsToSelector:@selector(client:didDisconnectWithError:)])
    {
        [self.delegate client:self didDisconnectWithError:error];
    }
}

- (void) connection:(_SKConnection *)connection didReceiveMessageData:(NSData *)data
{
    _SKPacketMsg * packetMessage = [self packetMessageFromData:data];
    [self handleClientMessageRecieved:packetMessage];
}

- (_SKPacketMsg *) packetMessageFromData:(NSData *)data
{
    CRDataReader * reader = [[CRDataReader alloc] initWithData:data];
    uint32_t rawMessageType = [reader readUInt32];
    EMsg msg = [_SKMsgUtil getMsg:rawMessageType];
    
    switch (msg)
    {
        case EMsgChannelEncryptRequest:
        case EMsgChannelEncryptResponse:
        case EMsgChannelEncryptResult:
            return [[_SKPlainPacketMsg alloc] initWithEMsg:msg data:data];
            
        default:
            break;
    }
    
    BOOL isProtobuf = [_SKMsgUtil isProtobuf:rawMessageType];
    
    if (isProtobuf)
    {
        return [[_SKProtobufPacketMsg alloc] initWithEMsg:msg data:data];
    }
    else
    {
        return [[_SKClientPacketMsg alloc] initWithEMsg:msg data:data];
    }
}

- (void) sendMessage:(_SKMsgBase *)message
{
    if (_sessionId != nil)
    {
        message.sessionID = [_sessionId integerValue];
    }
    
    if (_steamId != nil)
    {
        message.steamID = [_steamId unsignedLongLongValue];
    }

    CRLog(@"CMClient Send -> EMsg: %u (Proto: %@)", message.messageType, message.isProtobuf ? @"YES" : @"NO");
    [_connection sendMessage:message];
}

- (void) beatHeart
{
	_SKClientMsgProtobuf * heartbeatMessage = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientHeartBeat class] messageType:EMsgClientHeartBeat];
	[self sendMessage:heartbeatMessage];
}

#pragma mark -
#pragma mark Handle Incoming Messages

- (void) handleClientMessageRecieved:(_SKPacketMsg *)packetMessage
{
    CRLog(@"%@ <- Recv'd EMsg: %u (proto: %@)", NSStringFromClass([self class]), packetMessage.messageType, packetMessage.isProtobuf ? @"YES" : @"NO");
    
    switch (packetMessage.messageType)
    {
        case EMsgChannelEncryptRequest:
            [self handleEncryptRequest:packetMessage];
            break;
        
        case EMsgChannelEncryptResult:
            [self handleEncryptResult:packetMessage];
            break;
            
        case EMsgMulti:
            [self handleMulti:packetMessage];
            break;
            
        case EMsgClientLogOnResponse:
            [self handleLogOnResponse:packetMessage];
            break;
            
        case EMsgClientLoggedOff:
            [self handleClientLoggedOff:packetMessage];
            break;
            
        case EMsgClientServerList:
            break;
            
        default: break;
    }
    
    if ([self.delegate respondsToSelector:@selector(client:didRecieveMessage:)])
    {
        [self.delegate client:self didRecieveMessage:packetMessage];
    }
}

- (void) handleEncryptRequest:(_SKPacketMsg *)packetMessage
{
    _SKMsg * msg = [[_SKMsg alloc] initWithBodyClass:[_SKMsgChannelEncryptRequest class] data:packetMessage.data];
    
    EUniverse universe = [msg.body universe];
    uint32_t protocolVersion = [msg.body protocolVersion];
    
    CRLog(@"CMClient -- Got encryption request. Universe: %u Protocol ver: %u", universe, protocolVersion);
    
    NSData * publicKey = [_SKKeyDictionary publicKeyForUniverse:universe];
    if (publicKey == nil)
    {
        CRLog(@"CMClient -- handleEncryptRequest got request for invalid universe! Universe: %u Protocol ver: %u", universe, protocolVersion);
    }
    
    _connectedUniverse = universe;
    
    _SKMsg * response = [[_SKMsg alloc] initWithBodyClass:[_SKMsgChannelEncryptResponse class]];
    
    _temporarySessionKey = [NSData cr_randomDataOfLength:32];
    NSData * rsaEncryptedSessionKey = [_temporarySessionKey sk_asymmetricEncryptWithSteamUniversePublicKey:publicKey];
    
    [response.payload appendData:rsaEncryptedSessionKey];
    [response.payload cr_appendUInt32:[rsaEncryptedSessionKey cr_CRC32Hash]];
    [response.payload cr_appendUInt32:0];
    
    [self sendMessage:response];
}

- (void) handleEncryptResult:(_SKPacketMsg *)packetMessage
{
    _SKMsg * msg = [[_SKMsg alloc] initWithBodyClass:[_SKMsgChannelEncryptResult class] data:packetMessage.data];
    
    EResult encryptResult = [(_SKMsgChannelEncryptResult *)msg.body result];
    
    if (encryptResult == EResultOK)
    {
        _connection.netFilter = [[_SKNetFilterEncryption alloc] initWithSessionKey:_temporarySessionKey];
        _temporarySessionKey = nil;
        
        
        if ([self.delegate respondsToSelector:@selector(clientDidConnect:)])
        {
            [self.delegate clientDidConnect:self];
        }
    }
}

- (void) handleLogOnResponse:(_SKPacketMsg *)packetMessage
{
    if (!packetMessage.isProtobuf)
    {
        CRLog(@"CMClient -- handleLogOnResponse recieve non-protobuf MsgClientLogOnResponse!!");
        return;
    }
    
    _SKClientMsgProtobuf * logonResponse = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgClientLogonResponse class] packetMessage:packetMessage];
    
    if ([logonResponse.body eresult] == EResultOK)
    {
        _sessionId = @(logonResponse.protoHeader.clientSessionid);
        _steamId = @(logonResponse.protoHeader.steamid);
        
        int heartbeatDelay = [logonResponse.body outOfGameHeartbeatSeconds];
        
		_heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:heartbeatDelay target:self selector:@selector(beatHeart) userInfo:nil repeats:YES];
    }
}

- (void) handleClientLoggedOff:(_SKPacketMsg *)packetMessage
{
    _sessionId = nil;
    _steamId = nil;
    
	[_heartbeatTimer invalidate];
	_heartbeatTimer = nil;
}

- (void) handleMulti:(_SKPacketMsg *)packetMessage
{
    if (!packetMessage.isProtobuf)
    {
        CRLog(@"CMClient -- handleMulti got non-protobuf MsgMulti!!");
        return;
    }
    
    _SKClientMsgProtobuf * msgMulti = [[_SKClientMsgProtobuf alloc] initWithBodyClass:[CMsgMulti class] packetMessage:packetMessage];
    
    NSData * payload = [msgMulti.body messageBody];
    
    if ([msgMulti.body sizeUnzipped] > 0)
    {
        payload = [payload sk_decompressedPayload];
    }
    
    CRDataReader * reader = [[CRDataReader alloc] initWithData:payload];
    while ([reader.remainingData length] > 0)
    {
        uint32_t messageSize = [reader readUInt32];
        NSData * messageData = [reader readDataOfLength:messageSize];
        
        [self connection:nil didReceiveMessageData:messageData];
    }
}

@end
