// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import <ProtocolBuffers/ProtocolBuffers.h>

#ifndef __has_feature
  #define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif // __has_feature

#ifndef NS_RETURNS_NOT_RETAINED
  #if __has_feature(attribute_ns_returns_not_retained)
    #define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
  #else
    #define NS_RETURNS_NOT_RETAINED
  #endif
#endif

typedef enum {
  EGCSystemMsgk_EGCMsgInvalid = 0,
  EGCSystemMsgk_EGCMsgMulti = 1,
  EGCSystemMsgk_EGCMsgGenericReply = 10,
  EGCSystemMsgk_EGCMsgSystemBase = 50,
  EGCSystemMsgk_EGCMsgAchievementAwarded = 51,
  EGCSystemMsgk_EGCMsgConCommand = 52,
  EGCSystemMsgk_EGCMsgStartPlaying = 53,
  EGCSystemMsgk_EGCMsgStopPlaying = 54,
  EGCSystemMsgk_EGCMsgStartGameserver = 55,
  EGCSystemMsgk_EGCMsgStopGameserver = 56,
  EGCSystemMsgk_EGCMsgWGRequest = 57,
  EGCSystemMsgk_EGCMsgWGResponse = 58,
  EGCSystemMsgk_EGCMsgGetUserGameStatsSchema = 59,
  EGCSystemMsgk_EGCMsgGetUserGameStatsSchemaResponse = 60,
  EGCSystemMsgk_EGCMsgGetUserStatsDEPRECATED = 61,
  EGCSystemMsgk_EGCMsgGetUserStatsResponse = 62,
  EGCSystemMsgk_EGCMsgAppInfoUpdated = 63,
  EGCSystemMsgk_EGCMsgValidateSession = 64,
  EGCSystemMsgk_EGCMsgValidateSessionResponse = 65,
  EGCSystemMsgk_EGCMsgLookupAccountFromInput = 66,
  EGCSystemMsgk_EGCMsgSendHTTPRequest = 67,
  EGCSystemMsgk_EGCMsgSendHTTPRequestResponse = 68,
  EGCSystemMsgk_EGCMsgPreTestSetup = 69,
  EGCSystemMsgk_EGCMsgRecordSupportAction = 70,
  EGCSystemMsgk_EGCMsgGetAccountDetails_DEPRECATED = 71,
  EGCSystemMsgk_EGCMsgSendInterAppMessage = 72,
  EGCSystemMsgk_EGCMsgReceiveInterAppMessage = 73,
  EGCSystemMsgk_EGCMsgFindAccounts = 74,
  EGCSystemMsgk_EGCMsgPostAlert = 75,
  EGCSystemMsgk_EGCMsgGetLicenses = 76,
  EGCSystemMsgk_EGCMsgGetUserStats = 77,
  EGCSystemMsgk_EGCMsgGetCommands = 78,
  EGCSystemMsgk_EGCMsgGetCommandsResponse = 79,
  EGCSystemMsgk_EGCMsgAddFreeLicense = 80,
  EGCSystemMsgk_EGCMsgAddFreeLicenseResponse = 81,
  EGCSystemMsgk_EGCMsgGetIPLocation = 82,
  EGCSystemMsgk_EGCMsgGetIPLocationResponse = 83,
  EGCSystemMsgk_EGCMsgSystemStatsSchema = 84,
  EGCSystemMsgk_EGCMsgGetSystemStats = 85,
  EGCSystemMsgk_EGCMsgGetSystemStatsResponse = 86,
  EGCSystemMsgk_EGCMsgSendEmail = 87,
  EGCSystemMsgk_EGCMsgSendEmailResponse = 88,
  EGCSystemMsgk_EGCMsgGetEmailTemplate = 89,
  EGCSystemMsgk_EGCMsgGetEmailTemplateResponse = 90,
  EGCSystemMsgk_EGCMsgGrantGuestPass = 91,
  EGCSystemMsgk_EGCMsgGrantGuestPassResponse = 92,
  EGCSystemMsgk_EGCMsgGetAccountDetails = 93,
  EGCSystemMsgk_EGCMsgGetAccountDetailsResponse = 94,
  EGCSystemMsgk_EGCMsgGetPersonaNames = 95,
  EGCSystemMsgk_EGCMsgGetPersonaNamesResponse = 96,
  EGCSystemMsgk_EGCMsgMultiplexMsg = 97,
  EGCSystemMsgk_EGCMsgWebAPIRegisterInterfaces = 101,
  EGCSystemMsgk_EGCMsgWebAPIJobRequest = 102,
  EGCSystemMsgk_EGCMsgWebAPIRegistrationRequested = 103,
  EGCSystemMsgk_EGCMsgMemCachedGet = 200,
  EGCSystemMsgk_EGCMsgMemCachedGetResponse = 201,
  EGCSystemMsgk_EGCMsgMemCachedSet = 202,
  EGCSystemMsgk_EGCMsgMemCachedDelete = 203,
} EGCSystemMsg;

BOOL EGCSystemMsgIsValidValue(EGCSystemMsg value);

typedef enum {
  ESOMsgk_ESOMsg_Create = 21,
  ESOMsgk_ESOMsg_Update = 22,
  ESOMsgk_ESOMsg_Destroy = 23,
  ESOMsgk_ESOMsg_CacheSubscribed = 24,
  ESOMsgk_ESOMsg_CacheUnsubscribed = 25,
  ESOMsgk_ESOMsg_UpdateMultiple = 26,
  ESOMsgk_ESOMsg_CacheSubscriptionCheck = 27,
  ESOMsgk_ESOMsg_CacheSubscriptionRefresh = 28,
} ESOMsg;

BOOL ESOMsgIsValidValue(ESOMsg value);


@interface GcsystemmsgsRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end
