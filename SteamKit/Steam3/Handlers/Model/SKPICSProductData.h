//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@class CMsgPICSProductInfoResponse_AppInfo;
@class CMsgPICSProductInfoResponse_PackageInfo;

@interface SKPICSProductData : NSObject

@property (nonatomic, readonly) uint32_t appOrPackageId;
@property (nonatomic, readonly) uint32_t changeNumber;
@property (nonatomic, readonly) BOOL isMissingToken;
@property (nonatomic, readonly) NSData * shaHash;
@property (nonatomic, readonly) NSDictionary * keyValues;
@property (nonatomic, readonly) BOOL onlyPublic;

- (id) initWithAppInfoMessage:(CMsgPICSProductInfoResponse_AppInfo *)msg;
- (id) initWithPackageInfoMessage:(CMsgPICSProductInfoResponse_PackageInfo *)msg;

@end
