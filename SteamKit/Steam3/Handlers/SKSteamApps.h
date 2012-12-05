//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKClientMsgHandler.h"

@interface SKSteamApps : SKClientMsgHandler

- (id) init;

- (void) requestPackageInfoForPackagesWithIDs:(NSArray *)packageIDs;
- (void) requestAppInfoForAppsWithIDs:(NSArray *)appIDs;

@end
