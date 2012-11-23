//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@class CMsgClientLicenseList;

extern NSString * const SKSteamLicenceListInfoUpdateNotification;

@interface SKLicenceListInfo : NSObject

@property (nonatomic, readonly) NSArray * licences;

- (id) initWithMessage:(CMsgClientLicenseList *)message;

@end
