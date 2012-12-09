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
  MatchTypeMATCH_TYPE_RANKED = 0,
  MatchTypeMATCH_TYPE_COOP_BOTS = 1,
  MatchTypeMATCH_TYPE_TEAM_RANKED = 2,
} MatchType;

BOOL MatchTypeIsValidValue(MatchType value);

typedef enum {
  DOTABotDifficultyBOT_DIFFICULTY_PASSIVE = 0,
  DOTABotDifficultyBOT_DIFFICULTY_EASY = 1,
  DOTABotDifficultyBOT_DIFFICULTY_MEDIUM = 2,
  DOTABotDifficultyBOT_DIFFICULTY_HARD = 3,
  DOTABotDifficultyBOT_DIFFICULTY_UNFAIR = 4,
  DOTABotDifficultyBOT_DIFFICULTY_INVALID = 5,
} DOTABotDifficulty;

BOOL DOTABotDifficultyIsValidValue(DOTABotDifficulty value);


@interface MatchmakerCommonRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

