#import "SteamLanguageInternal.h"
#import "_SKMsgUtil.h"
#import <CRBoilerplate/CRBoilerplate.h>

@implementation _SKUdpHeader

	+ (uint32_t) MAGIC
	{
		 return 0x31305356;
	}
	// Static size: 4
	@synthesize magic;
	// Static size: 2
	@synthesize payloadSize;
	// Static size: 1
	@synthesize packetType;
	// Static size: 1
	@synthesize flags;
	// Static size: 4
	@synthesize sourceConnID;
	// Static size: 4
	@synthesize destConnID;
	// Static size: 4
	@synthesize seqThis;
	// Static size: 4
	@synthesize seqAck;
	// Static size: 4
	@synthesize packetsInMsg;
	// Static size: 4
	@synthesize msgStartSeq;
	// Static size: 4
	@synthesize msgSize;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.magic = [_SKUdpHeader MAGIC];
			self.payloadSize = 0;
			self.packetType = EUdpPacketTypeInvalid;
			self.flags = 0;
			self.sourceConnID = 512;
			self.destConnID = 0;
			self.seqThis = 0;
			self.seqAck = 0;
			self.packetsInMsg = 0;
			self.msgStartSeq = 0;
			self.msgSize = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:magic];
		[_data cr_appendInt16:payloadSize];
		[_data cr_appendUInt8:packetType];
		[_data cr_appendUInt8:flags];
		[_data cr_appendInt32:sourceConnID];
		[_data cr_appendInt32:destConnID];
		[_data cr_appendInt32:seqThis];
		[_data cr_appendInt32:seqAck];
		[_data cr_appendInt32:packetsInMsg];
		[_data cr_appendInt32:msgStartSeq];
		[_data cr_appendInt32:msgSize];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.magic = [reader readUInt32];
		self.payloadSize = [reader readUInt16];
		self.packetType = (EUdpPacketType)[reader readUInt8];
		self.flags = [reader readUInt8];
		self.sourceConnID = [reader readUInt32];
		self.destConnID = [reader readUInt32];
		self.seqThis = [reader readUInt32];
		self.seqAck = [reader readUInt32];
		self.packetsInMsg = [reader readUInt32];
		self.msgStartSeq = [reader readUInt32];
		self.msgSize = [reader readUInt32];
	}
@end

@implementation _SKChallengeData

	+ (uint32_t) CHALLENGE_MASK
	{
		 return 0xA426DF2B;
	}
	// Static size: 4
	@synthesize challengeValue;
	// Static size: 4
	@synthesize serverLoad;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.challengeValue = 0;
			self.serverLoad = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:challengeValue];
		[_data cr_appendInt32:serverLoad];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.challengeValue = [reader readUInt32];
		self.serverLoad = [reader readUInt32];
	}
@end

@implementation _SKConnectData

	+ (uint32_t) CHALLENGE_MASK
	{
		 return [_SKChallengeData CHALLENGE_MASK];
	}
	// Static size: 4
	@synthesize challengeValue;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.challengeValue = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:challengeValue];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.challengeValue = [reader readUInt32];
	}
@end

@implementation _SKAccept


	- (id) init
	{
		self = [super init];
		if (self) {
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{


	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
	}
@end

@implementation _SKDatagram


	- (id) init
	{
		self = [super init];
		if (self) {
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{


	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
	}
@end

@implementation _SKDisconnect


	- (id) init
	{
		self = [super init];
		if (self) {
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{


	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
	}
@end

//[StructLayout( LayoutKind.Sequential )]
@implementation _SKMsgHdr

	- (void) setEMsg:(EMsg)_msg
	{
		self.msg = _msg;
	}

	// Static size: 4
	@synthesize msg;
	// Static size: 8
	@synthesize targetJobID;
	// Static size: 8
	@synthesize sourceJobID;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.msg = EMsgInvalid;
			self.targetJobID = ULLONG_MAX;
			self.sourceJobID = ULLONG_MAX;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:msg];
		[_data cr_appendInt64:targetJobID];
		[_data cr_appendInt64:sourceJobID];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.msg = (EMsg)[reader readInt32];
		self.targetJobID = [reader readUInt64];
		self.sourceJobID = [reader readUInt64];
	}
@end

//[StructLayout( LayoutKind.Sequential )]
@implementation _SKExtendedClientMsgHdr

	- (void) setEMsg:(EMsg)_msg
	{
		self.msg = _msg;
	}

	// Static size: 4
	@synthesize msg;
	// Static size: 1
	@synthesize headerSize;
	// Static size: 2
	@synthesize headerVersion;
	// Static size: 8
	@synthesize targetJobID;
	// Static size: 8
	@synthesize sourceJobID;
	// Static size: 1
	@synthesize headerCanary;
	// Static size: 8
	@synthesize steamID;
	// Static size: 4
	@synthesize sessionID;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.msg = EMsgInvalid;
			self.headerSize = 36;
			self.headerVersion = 2;
			self.targetJobID = ULLONG_MAX;
			self.sourceJobID = ULLONG_MAX;
			self.headerCanary = 239;
			self.steamID = 0;
			self.sessionID = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:msg];
		[_data cr_appendUInt8:headerSize];
		[_data cr_appendInt16:headerVersion];
		[_data cr_appendInt64:targetJobID];
		[_data cr_appendInt64:sourceJobID];
		[_data cr_appendUInt8:headerCanary];
		[_data cr_appendInt64:steamID];
		[_data cr_appendInt32:sessionID];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.msg = (EMsg)[reader readInt32];
		self.headerSize = [reader readUInt8];
		self.headerVersion = [reader readUInt16];
		self.targetJobID = [reader readUInt64];
		self.sourceJobID = [reader readUInt64];
		self.headerCanary = [reader readUInt8];
		self.steamID = [reader readUInt64];
		self.sessionID = [reader readInt32];
	}
@end

//[StructLayout( LayoutKind.Sequential )]
@implementation _SKMsgHdrProtoBuf

	- (void) setEMsg:(EMsg)_msg
	{
		self.msg = _msg;
	}

	// Static size: 4
	@synthesize msg;
	// Static size: 4
	@synthesize headerLength;
	// Static size: 0
	@synthesize proto;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.msg = EMsgInvalid;
			self.headerLength = 0;
			self.proto = nil;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:[_SKMsgUtil makeMsg:msg isProtobuf:YES]];
		[_data cr_appendInt32:headerLength];
		[_data appendData:[proto data]];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.msg = (EMsg)[_SKMsgUtil getMsg:(uint32_t)[reader readInt32]];
		self.headerLength = [reader readInt32];
		NSData * protoData = [reader readDataOfLength:headerLength];
		self.proto = [CMsgProtoBufHeader parseFromData:protoData];
	}
@end

//[StructLayout( LayoutKind.Sequential )]
@implementation _SKMsgGCHdrProtoBuf

	- (void) setEMsg:(EGCMsg)_msg
	{
		self.msg = _msg;
	}

	// Static size: 4
	@synthesize msg;
	// Static size: 4
	@synthesize headerLength;
	// Static size: 0
	@synthesize proto;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.msg = 0;
			self.headerLength = 0;
			self.proto = nil;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:msg];
		[_data cr_appendInt32:headerLength];
		[_data appendData:[proto data]];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.msg = [reader readUInt32];
		self.headerLength = [reader readInt32];
		NSData * protoData = [reader readDataOfLength:headerLength];
		self.proto = [CMsgProtoBufHeader parseFromData:protoData];
	}
@end

//[StructLayout( LayoutKind.Sequential )]
@implementation _SKMsgGCHdr

	- (void) setEMsg:(EGCMsg)msg { }

	// Static size: 2
	@synthesize headerVersion;
	// Static size: 8
	@synthesize targetJobID;
	// Static size: 8
	@synthesize sourceJobID;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.headerVersion = 1;
			self.targetJobID = ULLONG_MAX;
			self.sourceJobID = ULLONG_MAX;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt16:headerVersion];
		[_data cr_appendInt64:targetJobID];
		[_data cr_appendInt64:sourceJobID];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.headerVersion = [reader readUInt16];
		self.targetJobID = [reader readUInt64];
		self.sourceJobID = [reader readUInt64];
	}
@end

@implementation _SKMsgClientJustStrings

	- (EMsg) eMsg
	{
		return EMsgInvalid;
	}


	- (id) init
	{
		self = [super init];
		if (self) {
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{


	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
	}
@end

@implementation _SKMsgClientGenericResponse

	- (EMsg) eMsg
	{
		return EMsgInvalid;
	}

	// Static size: 4
	@synthesize result;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.result = (EResult) 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:result];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.result = (EResult)[reader readInt32];
	}
@end

@implementation _SKMsgChannelEncryptRequest

	- (EMsg) eMsg
	{
		return EMsgChannelEncryptRequest;
	}

	+ (uint32_t) PROTOCOL_VERSION
	{
		 return 1;
	}
	// Static size: 4
	@synthesize protocolVersion;
	// Static size: 4
	@synthesize universe;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.protocolVersion = [_SKMsgChannelEncryptRequest PROTOCOL_VERSION];
			self.universe = EUniverseInvalid;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:protocolVersion];
		[_data cr_appendInt32:universe];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.protocolVersion = [reader readUInt32];
		self.universe = (EUniverse)[reader readInt32];
	}
@end

@implementation _SKMsgChannelEncryptResponse

	- (EMsg) eMsg
	{
		return EMsgChannelEncryptResponse;
	}

	// Static size: 4
	@synthesize protocolVersion;
	// Static size: 4
	@synthesize keySize;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.protocolVersion = [_SKMsgChannelEncryptRequest PROTOCOL_VERSION];
			self.keySize = 128;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:protocolVersion];
		[_data cr_appendInt32:keySize];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.protocolVersion = [reader readUInt32];
		self.keySize = [reader readUInt32];
	}
@end

@implementation _SKMsgChannelEncryptResult

	- (EMsg) eMsg
	{
		return EMsgChannelEncryptResult;
	}

	// Static size: 4
	@synthesize result;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.result = EResultInvalid;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:result];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.result = (EResult)[reader readInt32];
	}
@end

@implementation _SKMsgClientNewLoginKey

	- (EMsg) eMsg
	{
		return EMsgClientNewLoginKey;
	}

	// Static size: 4
	@synthesize uniqueID;
	// Static size: 20
	@synthesize loginKey;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.uniqueID = 0;
			self.loginKey = nil;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:uniqueID];
		[_data appendData:loginKey];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.uniqueID = [reader readUInt32];
		self.loginKey = [reader readDataOfLength:20];
	}
@end

@implementation _SKMsgClientNewLoginKeyAccepted

	- (EMsg) eMsg
	{
		return EMsgClientNewLoginKeyAccepted;
	}

	// Static size: 4
	@synthesize uniqueID;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.uniqueID = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:uniqueID];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.uniqueID = [reader readUInt32];
	}
@end

@implementation _SKMsgClientLogon

	- (EMsg) eMsg
	{
		return EMsgClientLogon;
	}

	+ (uint32_t) ObfuscationMask
	{
		 return 0xBAADF00D;
	}
	+ (uint32_t) CurrentProtocol
	{
		 return 65575;
	}
	+ (uint32_t) ProtocolVerMajorMask
	{
		 return 0xFFFF0000;
	}
	+ (uint32_t) ProtocolVerMinorMask
	{
		 return 0xFFFF;
	}
	+ (uint16_t) ProtocolVerMinorMinGameServers
	{
		 return 4;
	}
	+ (uint16_t) ProtocolVerMinorMinForSupportingEMsgMulti
	{
		 return 12;
	}
	+ (uint16_t) ProtocolVerMinorMinForSupportingEMsgClientEncryptPct
	{
		 return 14;
	}
	+ (uint16_t) ProtocolVerMinorMinForExtendedMsgHdr
	{
		 return 17;
	}
	+ (uint16_t) ProtocolVerMinorMinForCellId
	{
		 return 18;
	}
	+ (uint16_t) ProtocolVerMinorMinForSessionIDLast
	{
		 return 19;
	}
	+ (uint16_t) ProtocolVerMinorMinForServerAvailablityMsgs
	{
		 return 24;
	}
	+ (uint16_t) ProtocolVerMinorMinClients
	{
		 return 25;
	}
	+ (uint16_t) ProtocolVerMinorMinForOSType
	{
		 return 26;
	}
	+ (uint16_t) ProtocolVerMinorMinForCegApplyPESig
	{
		 return 27;
	}
	+ (uint16_t) ProtocolVerMinorMinForMarketingMessages2
	{
		 return 27;
	}
	+ (uint16_t) ProtocolVerMinorMinForAnyProtoBufMessages
	{
		 return 28;
	}
	+ (uint16_t) ProtocolVerMinorMinForProtoBufLoggedOffMessage
	{
		 return 28;
	}
	+ (uint16_t) ProtocolVerMinorMinForProtoBufMultiMessages
	{
		 return 28;
	}
	+ (uint16_t) ProtocolVerMinorMinForSendingProtocolToUFS
	{
		 return 30;
	}
	+ (uint16_t) ProtocolVerMinorMinForMachineAuth
	{
		 return 33;
	}

	- (id) init
	{
		self = [super init];
		if (self) {
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{


	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
	}
@end

@implementation _SKMsgClientVACBanStatus

	- (EMsg) eMsg
	{
		return EMsgClientVACBanStatus;
	}

	// Static size: 4
	@synthesize numBans;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.numBans = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:numBans];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.numBans = [reader readUInt32];
	}
@end

@implementation _SKMsgClientAppUsageEvent

	- (EMsg) eMsg
	{
		return EMsgClientAppUsageEvent;
	}

	// Static size: 4
	@synthesize appUsageEvent;
	// Static size: 8
	@synthesize gameID;
	// Static size: 2
	@synthesize offline;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.appUsageEvent = (EAppUsageEvent) 0;
			self.gameID = 0;
			self.offline = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:appUsageEvent];
		[_data cr_appendInt64:gameID];
		[_data cr_appendInt16:offline];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.appUsageEvent = (EAppUsageEvent)[reader readInt32];
		self.gameID = [reader readUInt64];
		self.offline = [reader readUInt16];
	}
@end

@implementation _SKMsgClientEmailAddrInfo

	- (EMsg) eMsg
	{
		return EMsgClientEmailAddrInfo;
	}

	// Static size: 4
	@synthesize passwordStrength;
	// Static size: 4
	@synthesize flagsAccountSecurityPolicy;
	// Static size: 1
	@synthesize validated;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.passwordStrength = 0;
			self.flagsAccountSecurityPolicy = 0;
			self.validated = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:passwordStrength];
		[_data cr_appendInt32:flagsAccountSecurityPolicy];
		[_data cr_appendUInt8:validated];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.passwordStrength = [reader readUInt32];
		self.flagsAccountSecurityPolicy = [reader readUInt32];
		self.validated = [reader readUInt8];
	}
@end

@implementation _SKMsgClientUpdateGuestPassesList

	- (EMsg) eMsg
	{
		return EMsgClientUpdateGuestPassesList;
	}

	// Static size: 4
	@synthesize result;
	// Static size: 4
	@synthesize countGuestPassesToGive;
	// Static size: 4
	@synthesize countGuestPassesToRedeem;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.result = (EResult) 0;
			self.countGuestPassesToGive = 0;
			self.countGuestPassesToRedeem = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:result];
		[_data cr_appendInt32:countGuestPassesToGive];
		[_data cr_appendInt32:countGuestPassesToRedeem];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.result = (EResult)[reader readInt32];
		self.countGuestPassesToGive = [reader readInt32];
		self.countGuestPassesToRedeem = [reader readInt32];
	}
@end

@implementation _SKMsgClientRequestedClientStats

	- (EMsg) eMsg
	{
		return EMsgClientRequestedClientStats;
	}

	// Static size: 4
	@synthesize countStats;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.countStats = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:countStats];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.countStats = [reader readInt32];
	}
@end

@implementation _SKMsgClientP2PIntroducerMessage

	- (EMsg) eMsg
	{
		return EMsgClientP2PIntroducerMessage;
	}

	// Static size: 8
	@synthesize steamID;
	// Static size: 4
	@synthesize routingType;
	// Static size: 1450
	@synthesize data;
	// Static size: 4
	@synthesize dataLen;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.steamID = 0;
			self.routingType = (EIntroducerRouting) 0;
			self.data = nil;
			self.dataLen = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:steamID];
		[_data cr_appendInt32:routingType];
		[_data appendData:data];
		[_data cr_appendInt32:dataLen];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.steamID = [reader readUInt64];
		self.routingType = (EIntroducerRouting)[reader readInt32];
		self.data = [reader readDataOfLength:1450];
		self.dataLen = [reader readUInt32];
	}
@end

@implementation _SKMsgClientOGSBeginSession

	- (EMsg) eMsg
	{
		return EMsgClientOGSBeginSession;
	}

	// Static size: 1
	@synthesize accountType;
	// Static size: 8
	@synthesize accountId;
	// Static size: 4
	@synthesize appId;
	// Static size: 4
	@synthesize timeStarted;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.accountType = 0;
			self.accountId = 0;
			self.appId = 0;
			self.timeStarted = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendUInt8:accountType];
		[_data cr_appendInt64:accountId];
		[_data cr_appendInt32:appId];
		[_data cr_appendInt32:timeStarted];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.accountType = [reader readUInt8];
		self.accountId = [reader readUInt64];
		self.appId = [reader readUInt32];
		self.timeStarted = [reader readUInt32];
	}
@end

@implementation _SKMsgClientOGSBeginSessionResponse

	- (EMsg) eMsg
	{
		return EMsgClientOGSBeginSessionResponse;
	}

	// Static size: 4
	@synthesize result;
	// Static size: 1
	@synthesize collectingAny;
	// Static size: 1
	@synthesize collectingDetails;
	// Static size: 8
	@synthesize sessionId;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.result = (EResult) 0;
			self.collectingAny = 0;
			self.collectingDetails = 0;
			self.sessionId = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:result];
		[_data cr_appendUInt8:collectingAny];
		[_data cr_appendUInt8:collectingDetails];
		[_data cr_appendInt64:sessionId];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.result = (EResult)[reader readInt32];
		self.collectingAny = [reader readUInt8];
		self.collectingDetails = [reader readUInt8];
		self.sessionId = [reader readUInt64];
	}
@end

@implementation _SKMsgClientOGSEndSession

	- (EMsg) eMsg
	{
		return EMsgClientOGSEndSession;
	}

	// Static size: 8
	@synthesize sessionId;
	// Static size: 4
	@synthesize timeEnded;
	// Static size: 4
	@synthesize reasonCode;
	// Static size: 4
	@synthesize countAttributes;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.sessionId = 0;
			self.timeEnded = 0;
			self.reasonCode = 0;
			self.countAttributes = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:sessionId];
		[_data cr_appendInt32:timeEnded];
		[_data cr_appendInt32:reasonCode];
		[_data cr_appendInt32:countAttributes];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.sessionId = [reader readUInt64];
		self.timeEnded = [reader readUInt32];
		self.reasonCode = [reader readInt32];
		self.countAttributes = [reader readInt32];
	}
@end

@implementation _SKMsgClientOGSEndSessionResponse

	- (EMsg) eMsg
	{
		return EMsgClientOGSEndSessionResponse;
	}

	// Static size: 4
	@synthesize result;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.result = (EResult) 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:result];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.result = (EResult)[reader readInt32];
	}
@end

@implementation _SKMsgClientOGSWriteRow

	- (EMsg) eMsg
	{
		return EMsgClientOGSWriteRow;
	}

	// Static size: 8
	@synthesize sessionId;
	// Static size: 4
	@synthesize countAttributes;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.sessionId = 0;
			self.countAttributes = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:sessionId];
		[_data cr_appendInt32:countAttributes];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.sessionId = [reader readUInt64];
		self.countAttributes = [reader readInt32];
	}
@end

@implementation _SKMsgClientGetFriendsWhoPlayGame

	- (EMsg) eMsg
	{
		return EMsgClientGetFriendsWhoPlayGame;
	}

	// Static size: 8
	@synthesize gameId;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.gameId = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:gameId];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.gameId = [reader readUInt64];
	}
@end

@implementation _SKMsgClientGetFriendsWhoPlayGameResponse

	- (EMsg) eMsg
	{
		return EMsgClientGetFriendsWhoPlayGameResponse;
	}

	// Static size: 4
	@synthesize result;
	// Static size: 8
	@synthesize gameId;
	// Static size: 4
	@synthesize countFriends;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.result = (EResult) 0;
			self.gameId = 0;
			self.countFriends = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:result];
		[_data cr_appendInt64:gameId];
		[_data cr_appendInt32:countFriends];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.result = (EResult)[reader readInt32];
		self.gameId = [reader readUInt64];
		self.countFriends = [reader readUInt32];
	}
@end

@implementation _SKMsgGSPerformHardwareSurvey

	- (EMsg) eMsg
	{
		return EMsgGSPerformHardwareSurvey;
	}

	// Static size: 4
	@synthesize flags;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.flags = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:flags];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.flags = [reader readUInt32];
	}
@end

@implementation _SKMsgGSGetPlayStatsResponse

	- (EMsg) eMsg
	{
		return EMsgGSGetPlayStatsResponse;
	}

	// Static size: 4
	@synthesize result;
	// Static size: 4
	@synthesize rank;
	// Static size: 4
	@synthesize lifetimeConnects;
	// Static size: 4
	@synthesize lifetimeMinutesPlayed;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.result = (EResult) 0;
			self.rank = 0;
			self.lifetimeConnects = 0;
			self.lifetimeMinutesPlayed = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:result];
		[_data cr_appendInt32:rank];
		[_data cr_appendInt32:lifetimeConnects];
		[_data cr_appendInt32:lifetimeMinutesPlayed];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.result = (EResult)[reader readInt32];
		self.rank = [reader readInt32];
		self.lifetimeConnects = [reader readUInt32];
		self.lifetimeMinutesPlayed = [reader readUInt32];
	}
@end

@implementation _SKMsgGSGetReputationResponse

	- (EMsg) eMsg
	{
		return EMsgGSGetReputationResponse;
	}

	// Static size: 4
	@synthesize result;
	// Static size: 4
	@synthesize reputationScore;
	// Static size: 1
	@synthesize banned;
	// Static size: 4
	@synthesize bannedIp;
	// Static size: 2
	@synthesize bannedPort;
	// Static size: 8
	@synthesize bannedGameId;
	// Static size: 4
	@synthesize timeBanExpires;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.result = (EResult) 0;
			self.reputationScore = 0;
			self.banned = 0;
			self.bannedIp = 0;
			self.bannedPort = 0;
			self.bannedGameId = 0;
			self.timeBanExpires = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:result];
		[_data cr_appendInt32:reputationScore];
		[_data cr_appendUInt8:banned];
		[_data cr_appendInt32:bannedIp];
		[_data cr_appendInt16:bannedPort];
		[_data cr_appendInt64:bannedGameId];
		[_data cr_appendInt32:timeBanExpires];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.result = (EResult)[reader readInt32];
		self.reputationScore = [reader readUInt32];
		self.banned = [reader readUInt8];
		self.bannedIp = [reader readUInt32];
		self.bannedPort = [reader readUInt16];
		self.bannedGameId = [reader readUInt64];
		self.timeBanExpires = [reader readUInt32];
	}
@end

@implementation _SKMsgGSDeny

	- (EMsg) eMsg
	{
		return EMsgGSDeny;
	}

	// Static size: 8
	@synthesize steamId;
	// Static size: 4
	@synthesize denyReason;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.steamId = 0;
			self.denyReason = (EDenyReason) 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:steamId];
		[_data cr_appendInt32:denyReason];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.steamId = [reader readUInt64];
		self.denyReason = (EDenyReason)[reader readInt32];
	}
@end

@implementation _SKMsgGSApprove

	- (EMsg) eMsg
	{
		return EMsgGSApprove;
	}

	// Static size: 8
	@synthesize steamId;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.steamId = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:steamId];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.steamId = [reader readUInt64];
	}
@end

@implementation _SKMsgGSKick

	- (EMsg) eMsg
	{
		return EMsgGSKick;
	}

	// Static size: 8
	@synthesize steamId;
	// Static size: 4
	@synthesize denyReason;
	// Static size: 4
	@synthesize waitTilMapChange;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.steamId = 0;
			self.denyReason = (EDenyReason) 0;
			self.waitTilMapChange = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:steamId];
		[_data cr_appendInt32:denyReason];
		[_data cr_appendInt32:waitTilMapChange];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.steamId = [reader readUInt64];
		self.denyReason = (EDenyReason)[reader readInt32];
		self.waitTilMapChange = [reader readInt32];
	}
@end

@implementation _SKMsgGSGetUserGroupStatus

	- (EMsg) eMsg
	{
		return EMsgGSGetUserGroupStatus;
	}

	// Static size: 8
	@synthesize steamIdUser;
	// Static size: 8
	@synthesize steamIdGroup;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.steamIdUser = 0;
			self.steamIdGroup = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:steamIdUser];
		[_data cr_appendInt64:steamIdGroup];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.steamIdUser = [reader readUInt64];
		self.steamIdGroup = [reader readUInt64];
	}
@end

@implementation _SKMsgGSGetUserGroupStatusResponse

	- (EMsg) eMsg
	{
		return EMsgGSGetUserGroupStatusResponse;
	}

	// Static size: 8
	@synthesize steamIdUser;
	// Static size: 8
	@synthesize steamIdGroup;
	// Static size: 4
	@synthesize clanRelationship;
	// Static size: 4
	@synthesize clanRank;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.steamIdUser = 0;
			self.steamIdGroup = 0;
			self.clanRelationship = (EClanRelationship) 0;
			self.clanRank = (EClanRank) 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:steamIdUser];
		[_data cr_appendInt64:steamIdGroup];
		[_data cr_appendInt32:clanRelationship];
		[_data cr_appendInt32:clanRank];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.steamIdUser = [reader readUInt64];
		self.steamIdGroup = [reader readUInt64];
		self.clanRelationship = (EClanRelationship)[reader readInt32];
		self.clanRank = (EClanRank)[reader readInt32];
	}
@end

@implementation _SKMsgClientJoinChat

	- (EMsg) eMsg
	{
		return EMsgClientJoinChat;
	}

	// Static size: 8
	@synthesize steamIdChat;
	// Static size: 1
	@synthesize isVoiceSpeaker;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.steamIdChat = 0;
			self.isVoiceSpeaker = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:steamIdChat];
		[_data cr_appendUInt8:isVoiceSpeaker];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.steamIdChat = [reader readUInt64];
		self.isVoiceSpeaker = [reader readUInt8];
	}
@end

@implementation _SKMsgClientChatEnter

	- (EMsg) eMsg
	{
		return EMsgClientChatEnter;
	}

	// Static size: 8
	@synthesize steamIdChat;
	// Static size: 8
	@synthesize steamIdFriend;
	// Static size: 4
	@synthesize chatRoomType;
	// Static size: 8
	@synthesize steamIdOwner;
	// Static size: 8
	@synthesize steamIdClan;
	// Static size: 1
	@synthesize chatFlags;
	// Static size: 4
	@synthesize enterResponse;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.steamIdChat = 0;
			self.steamIdFriend = 0;
			self.chatRoomType = (EChatRoomType) 0;
			self.steamIdOwner = 0;
			self.steamIdClan = 0;
			self.chatFlags = 0;
			self.enterResponse = (EChatRoomEnterResponse) 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:steamIdChat];
		[_data cr_appendInt64:steamIdFriend];
		[_data cr_appendInt32:chatRoomType];
		[_data cr_appendInt64:steamIdOwner];
		[_data cr_appendInt64:steamIdClan];
		[_data cr_appendUInt8:chatFlags];
		[_data cr_appendInt32:enterResponse];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.steamIdChat = [reader readUInt64];
		self.steamIdFriend = [reader readUInt64];
		self.chatRoomType = (EChatRoomType)[reader readInt32];
		self.steamIdOwner = [reader readUInt64];
		self.steamIdClan = [reader readUInt64];
		self.chatFlags = [reader readUInt8];
		self.enterResponse = (EChatRoomEnterResponse)[reader readInt32];
	}
@end

@implementation _SKMsgClientChatMsg

	- (EMsg) eMsg
	{
		return EMsgClientChatMsg;
	}

	// Static size: 8
	@synthesize steamIdChatter;
	// Static size: 8
	@synthesize steamIdChatRoom;
	// Static size: 4
	@synthesize chatMsgType;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.steamIdChatter = 0;
			self.steamIdChatRoom = 0;
			self.chatMsgType = (EChatEntryType) 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:steamIdChatter];
		[_data cr_appendInt64:steamIdChatRoom];
		[_data cr_appendInt32:chatMsgType];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.steamIdChatter = [reader readUInt64];
		self.steamIdChatRoom = [reader readUInt64];
		self.chatMsgType = (EChatEntryType)[reader readInt32];
	}
@end

@implementation _SKMsgClientChatMemberInfo

	- (EMsg) eMsg
	{
		return EMsgClientChatMemberInfo;
	}

	// Static size: 8
	@synthesize steamIdChat;
	// Static size: 4
	@synthesize type;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.steamIdChat = 0;
			self.type = (EChatInfoType) 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:steamIdChat];
		[_data cr_appendInt32:type];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.steamIdChat = [reader readUInt64];
		self.type = (EChatInfoType)[reader readInt32];
	}
@end

@implementation _SKMsgClientChatAction

	- (EMsg) eMsg
	{
		return EMsgClientChatAction;
	}

	// Static size: 8
	@synthesize steamIdChat;
	// Static size: 8
	@synthesize steamIdUserToActOn;
	// Static size: 4
	@synthesize chatAction;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.steamIdChat = 0;
			self.steamIdUserToActOn = 0;
			self.chatAction = (EChatAction) 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:steamIdChat];
		[_data cr_appendInt64:steamIdUserToActOn];
		[_data cr_appendInt32:chatAction];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.steamIdChat = [reader readUInt64];
		self.steamIdUserToActOn = [reader readUInt64];
		self.chatAction = (EChatAction)[reader readInt32];
	}
@end

@implementation _SKMsgClientChatActionResult

	- (EMsg) eMsg
	{
		return EMsgClientChatActionResult;
	}

	// Static size: 8
	@synthesize steamIdChat;
	// Static size: 8
	@synthesize steamIdUserActedOn;
	// Static size: 4
	@synthesize chatAction;
	// Static size: 4
	@synthesize actionResult;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.steamIdChat = 0;
			self.steamIdUserActedOn = 0;
			self.chatAction = (EChatAction) 0;
			self.actionResult = (EChatActionResult) 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:steamIdChat];
		[_data cr_appendInt64:steamIdUserActedOn];
		[_data cr_appendInt32:chatAction];
		[_data cr_appendInt32:actionResult];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.steamIdChat = [reader readUInt64];
		self.steamIdUserActedOn = [reader readUInt64];
		self.chatAction = (EChatAction)[reader readInt32];
		self.actionResult = (EChatActionResult)[reader readInt32];
	}
@end

@implementation _SKMsgClientGetNumberOfCurrentPlayers

	- (EMsg) eMsg
	{
		return EMsgClientGetNumberOfCurrentPlayers;
	}

	// Static size: 8
	@synthesize gameID;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.gameID = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:gameID];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.gameID = [reader readUInt64];
	}
@end

@implementation _SKMsgClientGetNumberOfCurrentPlayersResponse

	- (EMsg) eMsg
	{
		return EMsgClientGetNumberOfCurrentPlayersResponse;
	}

	// Static size: 4
	@synthesize result;
	// Static size: 4
	@synthesize numPlayers;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.result = (EResult) 0;
			self.numPlayers = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt32:result];
		[_data cr_appendInt32:numPlayers];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.result = (EResult)[reader readInt32];
		self.numPlayers = [reader readUInt32];
	}
@end

@implementation _SKMsgClientSetIgnoreFriend

	- (EMsg) eMsg
	{
		return EMsgClientSetIgnoreFriend;
	}

	// Static size: 8
	@synthesize mySteamId;
	// Static size: 8
	@synthesize steamIdFriend;
	// Static size: 1
	@synthesize ignore;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.mySteamId = 0;
			self.steamIdFriend = 0;
			self.ignore = 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:mySteamId];
		[_data cr_appendInt64:steamIdFriend];
		[_data cr_appendUInt8:ignore];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.mySteamId = [reader readUInt64];
		self.steamIdFriend = [reader readUInt64];
		self.ignore = [reader readUInt8];
	}
@end

@implementation _SKMsgClientSetIgnoreFriendResponse

	- (EMsg) eMsg
	{
		return EMsgClientSetIgnoreFriendResponse;
	}

	// Static size: 8
	@synthesize unknown;
	// Static size: 4
	@synthesize result;

	- (id) init
	{
		self = [super init];
		if (self) {
			self.unknown = 0;
			self.result = (EResult) 0;
		}
		return self;
	}
	- (void) dealloc
	{
	}

	- (void) serialize:(NSMutableData *)_data
	{

		[_data cr_appendInt64:unknown];
		[_data cr_appendInt32:result];

	}

	- (void) deserializeWithReader:(CRDataReader *)reader
	{
		self.unknown = [reader readUInt64];
		self.result = (EResult)[reader readInt32];
	}
@end
