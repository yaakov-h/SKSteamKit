//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//
// This file was automatically generated. Do not edit it.
//

#import "SteamLanguage.h"
#import <CRBoilerplate/CRBoilerplate.h>

#ifndef _SK_EGCMSG
#define _SK_EGCMSG
typedef uint32_t EGCMsg; // Temp hack, not yet defined
#endif
@class CRDataReader; // Temp hack, not yet defined

@protocol _SKSteamSerializable <NSObject>

- (void) serialize:(NSMutableData *)data;
- (void) deserializeWithReader:(CRDataReader *)reader;

@end

@protocol _SKSteamSerializableHeader <_SKSteamSerializable>

- (void) setEMsg:(EMsg)msg;

@end

@protocol _SKSteamSerializableMessage <_SKSteamSerializable>

- (EMsg) eMsg;

@end

@protocol _SKGCSerializableHeader <_SKSteamSerializable>

- (void) setEMsg:(EGCMsg)msg;

@end

@protocol _SKGCSerializableMessage <_SKSteamSerializable>

- (EGCMsg) eMsg;

@end

@interface _SKUdpHeader : NSObject <_SKSteamSerializable>

	+ (uint32_t) MAGIC;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t magic;
	// Static size: 2
	@property (nonatomic, readwrite) uint16_t payloadSize;
	// Static size: 1
	@property (nonatomic, readwrite) EUdpPacketType packetType;
	// Static size: 1
	@property (nonatomic, readwrite) uint8_t flags;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t sourceConnID;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t destConnID;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t seqThis;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t seqAck;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t packetsInMsg;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t msgStartSeq;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t msgSize;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKChallengeData : NSObject <_SKSteamSerializable>

	+ (uint32_t) CHALLENGE_MASK;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t challengeValue;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t serverLoad;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKConnectData : NSObject <_SKSteamSerializable>

	+ (uint32_t) CHALLENGE_MASK;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t challengeValue;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKAccept : NSObject <_SKSteamSerializable>


	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKDatagram : NSObject <_SKSteamSerializable>


	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKDisconnect : NSObject <_SKSteamSerializable>


	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

//[StructLayout( LayoutKind.Sequential )]
@interface _SKMsgHdr : NSObject <_SKSteamSerializableHeader>

	- (void) setEMsg:(EMsg)msg;

	// Static size: 4
	@property (nonatomic, readwrite) EMsg msg;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t targetJobID;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t sourceJobID;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

//[StructLayout( LayoutKind.Sequential )]
@interface _SKExtendedClientMsgHdr : NSObject <_SKSteamSerializableHeader>

	- (void) setEMsg:(EMsg)msg;

	// Static size: 4
	@property (nonatomic, readwrite) EMsg msg;
	// Static size: 1
	@property (nonatomic, readwrite) uint8_t headerSize;
	// Static size: 2
	@property (nonatomic, readwrite) uint16_t headerVersion;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t targetJobID;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t sourceJobID;
	// Static size: 1
	@property (nonatomic, readwrite) uint8_t headerCanary;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamID;
	// Static size: 4
	@property (nonatomic, readwrite) int32_t sessionID;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

//[StructLayout( LayoutKind.Sequential )]
@interface _SKMsgHdrProtoBuf : NSObject <_SKSteamSerializableHeader>

	- (void) setEMsg:(EMsg)msg;

	// Static size: 4
	@property (nonatomic, readwrite) EMsg msg;
	// Static size: 4
	@property (nonatomic, readwrite) int32_t headerLength;
	// Static size: 0
	@property (nonatomic, strong, readwrite) CMsgProtoBufHeader * proto;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

//[StructLayout( LayoutKind.Sequential )]
@interface _SKMsgGCHdrProtoBuf : NSObject <_SKGCSerializableHeader>

	- (void) setEMsg:(EGCMsg)msg;

	// Static size: 4
	@property (nonatomic, readwrite) uint32_t msg;
	// Static size: 4
	@property (nonatomic, readwrite) int32_t headerLength;
	// Static size: 0
	@property (nonatomic, strong, readwrite) CMsgProtoBufHeader * proto;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

//[StructLayout( LayoutKind.Sequential )]
@interface _SKMsgGCHdr : NSObject <_SKGCSerializableHeader>

	- (void) setEMsg:(EGCMsg)msg;

	// Static size: 2
	@property (nonatomic, readwrite) uint16_t headerVersion;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t targetJobID;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t sourceJobID;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientJustStrings : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;


	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientGenericResponse : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) EResult result;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgChannelEncryptRequest : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	+ (uint32_t) PROTOCOL_VERSION;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t protocolVersion;
	// Static size: 4
	@property (nonatomic, readwrite) EUniverse universe;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgChannelEncryptResponse : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) uint32_t protocolVersion;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t keySize;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgChannelEncryptResult : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) EResult result;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientNewLoginKey : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) uint32_t uniqueID;
	// Static size: 20
	@property (nonatomic, strong, readwrite) NSData * loginKey;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientNewLoginKeyAccepted : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) uint32_t uniqueID;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientLogon : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	+ (uint32_t) ObfuscationMask;
	+ (uint32_t) CurrentProtocol;
	+ (uint32_t) ProtocolVerMajorMask;
	+ (uint32_t) ProtocolVerMinorMask;
	+ (uint16_t) ProtocolVerMinorMinGameServers;
	+ (uint16_t) ProtocolVerMinorMinForSupportingEMsgMulti;
	+ (uint16_t) ProtocolVerMinorMinForSupportingEMsgClientEncryptPct;
	+ (uint16_t) ProtocolVerMinorMinForExtendedMsgHdr;
	+ (uint16_t) ProtocolVerMinorMinForCellId;
	+ (uint16_t) ProtocolVerMinorMinForSessionIDLast;
	+ (uint16_t) ProtocolVerMinorMinForServerAvailablityMsgs;
	+ (uint16_t) ProtocolVerMinorMinClients;
	+ (uint16_t) ProtocolVerMinorMinForOSType;
	+ (uint16_t) ProtocolVerMinorMinForCegApplyPESig;
	+ (uint16_t) ProtocolVerMinorMinForMarketingMessages2;
	+ (uint16_t) ProtocolVerMinorMinForAnyProtoBufMessages;
	+ (uint16_t) ProtocolVerMinorMinForProtoBufLoggedOffMessage;
	+ (uint16_t) ProtocolVerMinorMinForProtoBufMultiMessages;
	+ (uint16_t) ProtocolVerMinorMinForSendingProtocolToUFS;
	+ (uint16_t) ProtocolVerMinorMinForMachineAuth;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientVACBanStatus : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) uint32_t numBans;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientAppUsageEvent : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) EAppUsageEvent appUsageEvent;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t gameID;
	// Static size: 2
	@property (nonatomic, readwrite) uint16_t offline;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientEmailAddrInfo : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) uint32_t passwordStrength;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t flagsAccountSecurityPolicy;
	// Static size: 1
	@property (nonatomic, readwrite) uint8_t validated;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientUpdateGuestPassesList : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) EResult result;
	// Static size: 4
	@property (nonatomic, readwrite) int32_t countGuestPassesToGive;
	// Static size: 4
	@property (nonatomic, readwrite) int32_t countGuestPassesToRedeem;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientRequestedClientStats : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) int32_t countStats;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientP2PIntroducerMessage : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamID;
	// Static size: 4
	@property (nonatomic, readwrite) EIntroducerRouting routingType;
	// Static size: 1450
	@property (nonatomic, strong, readwrite) NSData * data;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t dataLen;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientOGSBeginSession : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 1
	@property (nonatomic, readwrite) uint8_t accountType;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t accountId;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t appId;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t timeStarted;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientOGSBeginSessionResponse : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) EResult result;
	// Static size: 1
	@property (nonatomic, readwrite) uint8_t collectingAny;
	// Static size: 1
	@property (nonatomic, readwrite) uint8_t collectingDetails;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t sessionId;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientOGSEndSession : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t sessionId;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t timeEnded;
	// Static size: 4
	@property (nonatomic, readwrite) int32_t reasonCode;
	// Static size: 4
	@property (nonatomic, readwrite) int32_t countAttributes;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientOGSEndSessionResponse : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) EResult result;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientOGSWriteRow : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t sessionId;
	// Static size: 4
	@property (nonatomic, readwrite) int32_t countAttributes;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientGetFriendsWhoPlayGame : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t gameId;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientGetFriendsWhoPlayGameResponse : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) EResult result;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t gameId;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t countFriends;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgGSPerformHardwareSurvey : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) uint32_t flags;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgGSGetPlayStatsResponse : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) EResult result;
	// Static size: 4
	@property (nonatomic, readwrite) int32_t rank;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t lifetimeConnects;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t lifetimeMinutesPlayed;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgGSGetReputationResponse : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) EResult result;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t reputationScore;
	// Static size: 1
	@property (nonatomic, readwrite) uint8_t banned;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t bannedIp;
	// Static size: 2
	@property (nonatomic, readwrite) uint16_t bannedPort;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t bannedGameId;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t timeBanExpires;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgGSDeny : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamId;
	// Static size: 4
	@property (nonatomic, readwrite) EDenyReason denyReason;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgGSApprove : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamId;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgGSKick : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamId;
	// Static size: 4
	@property (nonatomic, readwrite) EDenyReason denyReason;
	// Static size: 4
	@property (nonatomic, readwrite) int32_t waitTilMapChange;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgGSGetUserGroupStatus : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdUser;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdGroup;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgGSGetUserGroupStatusResponse : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdUser;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdGroup;
	// Static size: 4
	@property (nonatomic, readwrite) EClanRelationship clanRelationship;
	// Static size: 4
	@property (nonatomic, readwrite) EClanRank clanRank;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientJoinChat : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdChat;
	// Static size: 1
	@property (nonatomic, readwrite) uint8_t isVoiceSpeaker;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientChatEnter : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdChat;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdFriend;
	// Static size: 4
	@property (nonatomic, readwrite) EChatRoomType chatRoomType;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdOwner;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdClan;
	// Static size: 1
	@property (nonatomic, readwrite) uint8_t chatFlags;
	// Static size: 4
	@property (nonatomic, readwrite) EChatRoomEnterResponse enterResponse;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientChatMsg : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdChatter;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdChatRoom;
	// Static size: 4
	@property (nonatomic, readwrite) EChatEntryType chatMsgType;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientChatMemberInfo : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdChat;
	// Static size: 4
	@property (nonatomic, readwrite) EChatInfoType type;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientChatAction : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdChat;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdUserToActOn;
	// Static size: 4
	@property (nonatomic, readwrite) EChatAction chatAction;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientChatActionResult : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdChat;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdUserActedOn;
	// Static size: 4
	@property (nonatomic, readwrite) EChatAction chatAction;
	// Static size: 4
	@property (nonatomic, readwrite) EChatActionResult actionResult;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientGetNumberOfCurrentPlayers : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t gameID;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientGetNumberOfCurrentPlayersResponse : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 4
	@property (nonatomic, readwrite) EResult result;
	// Static size: 4
	@property (nonatomic, readwrite) uint32_t numPlayers;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientSetIgnoreFriend : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t mySteamId;
	// Static size: 8
	@property (nonatomic, readwrite) uint64_t steamIdFriend;
	// Static size: 1
	@property (nonatomic, readwrite) uint8_t ignore;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

@interface _SKMsgClientSetIgnoreFriendResponse : NSObject <_SKSteamSerializableMessage>

	- (EMsg) eMsg;

	// Static size: 8
	@property (nonatomic, readwrite) uint64_t unknown;
	// Static size: 4
	@property (nonatomic, readwrite) EResult result;

	- (id) init;

	- (void) serialize:(NSMutableData *)data;

	- (void) deserializeWithReader:(CRDataReader *)reader;
@end

