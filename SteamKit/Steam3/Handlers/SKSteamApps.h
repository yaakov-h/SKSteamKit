//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKClientMsgHandler.h"
#import <CRBoilerplate/CRBoilerplate.h>

@interface SKSteamApps : SKClientMsgHandler

- (id) init;

- (CRPromise *) requestPackageInfoForPackagesWithIDs:(NSArray *)packageIDs;
- (CRPromise *) requestAppInfoForAppsWithIDs:(NSArray *)appIDs;

- (void) setGameBeingPlayed:(uint32_t)gameID;
- (void) setGamesBeingPlayed:(NSArray *)gameIDs;

- (CRPromise *) PICSGetChangesSinceChangeNumber:(uint32_t)changeNumber sendAppChangeList:(BOOL)sendAppChangeList sendPackageChangeList:(BOOL)sendPackageChangeList;
- (CRPromise *) PICSGetProductInfoForApps:(NSArray *)apps packages:(NSArray *)packages onlyPublicInfo:(BOOL)onlyPublicInfo onlyMetadata:(BOOL)onlyMetadata;
- (CRPromise *) PICSGetAccessTokensForApps:(NSArray *)appIDs packages:(NSArray *)packageIDs;

// Helper methods
- (CRPromise *) PICSGetProductInfoForApp:(uint32_t)app;
- (CRPromise *) PICSGetProductInfoForApps:(NSArray *)apps;
- (CRPromise *) PICSGetProductInfoForPackage:(uint32_t)package;
- (CRPromise *) PICSGetProductInfoForPackages:(NSArray *)packages;

@end
