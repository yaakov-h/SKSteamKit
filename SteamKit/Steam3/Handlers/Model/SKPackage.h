//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int32_t, SKPackageStatus)
{
	SKPackageStatusOK,
	SKPackageStatusUnknown,
};

@class CMsgClientPackageInfoResponse_Package;

@interface SKPackage : NSObject

@property (nonatomic, readonly) SKPackageStatus status;
@property (nonatomic, readonly) uint32_t packageId;
@property (nonatomic, readonly) uint32_t changeNumber;
@property (nonatomic, readonly) NSData * hash;
@property (nonatomic, readonly) NSDictionary * data;

@property (nonatomic, readonly) NSArray * appIds;
@property (nonatomic, readonly) NSString * name;

- (id) initWithPackageDetails:(CMsgClientPackageInfoResponse_Package *)details status:(SKPackageStatus)status;

@end
