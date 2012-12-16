//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@class CMsgPICSProductInfoResponse;

@interface SKPICSProductInfo : NSObject

@property (nonatomic, readonly) BOOL metadataOnly;
@property (nonatomic, readonly) BOOL responsePending;
@property (nonatomic, readonly) NSArray * unknownPackages;
@property (nonatomic, readonly) NSArray * unknownApps;
@property (nonatomic, readonly) NSDictionary * apps;
@property (nonatomic, readonly) NSDictionary * packages;

- (id) initWithMessage:(CMsgPICSProductInfoResponse *)msg;

@end
