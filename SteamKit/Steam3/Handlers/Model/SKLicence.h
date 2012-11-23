//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>
#import "SteamLanguage.h"

@class CMsgClientLicenseList_License;

@interface SKLicence : NSObject

@property (nonatomic, readonly) uint32_t packageId;
@property (nonatomic, readonly) int32_t lastChangeNumber;
@property (nonatomic, readonly) NSDate * timeCreated;
@property (nonatomic, readonly) NSDate * timeNextProcess;

@property (nonatomic, readonly) int32_t minuteLimit;
@property (nonatomic, readonly) int32_t minutesUsed;

@property (nonatomic, readonly) EPaymentMethod paymentMethod;
@property (nonatomic, readonly) ELicenseFlags flags;

@property (nonatomic, readonly) NSString * purchaseCountryCode;
@property (nonatomic, readonly) ELicenseType type;
@property (nonatomic, readonly) int32_t territoryCode;

- (id) initWithLicence:(CMsgClientLicenseList_License *)licence;

@end
