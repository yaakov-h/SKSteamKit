//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@interface SKPICSRequest : NSObject

@property (nonatomic, readwrite) uint32_t appOrPackageId;
@property (nonatomic, readwrite) uint64_t accessToken;
@property (nonatomic, readwrite) BOOL publicInfoOnly;

- (id) initWithId:(uint32_t)appOrPackageId;
- (id) initWithId:(uint32_t)appOrPackageId accessToken:(uint64_t)accessToken publicInfoOnly:(BOOL)publicInfoOnly;

@end
