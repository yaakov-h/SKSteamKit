//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@class CMsgPICSChangesSinceResponse_AppChange;
@class CMsgPICSChangesSinceResponse_PackageChange;

@interface SKPICSChange : NSObject

@property (nonatomic, readonly) uint32_t appOrPackageId;
@property (nonatomic, readonly) uint32_t changeNumber;
@property (nonatomic, readonly) BOOL requiresAccessToken;

- (id) initWithAppChangeMessage:(CMsgPICSChangesSinceResponse_AppChange *)msg;
- (id) initWithPackageChangeMessage:(CMsgPICSChangesSinceResponse_PackageChange *)msg;

@end
