//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKClientMsgHandler.h"
#import <CRBoilerplate/CRBoilerplate.h>

@interface SKSteamUserStats : SKClientMsgHandler

- (id) init;

- (CRPromise *) getNumberOfCurrentPlayersForGame:(uint64_t)gameId;

@end
