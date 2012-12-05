//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int32_t, SKAppInfoStatus)
{
	SKAppInfoStatusOK,
	SKAppInfoStatusUnknown,
};

@class CMsgClientAppInfoResponse_App;

@interface SKApp : NSObject

@property (nonatomic, readonly) SKAppInfoStatus status;
@property (nonatomic, readonly) uint32_t appId;
@property (nonatomic, readonly) uint32_t changeNumber;
@property (nonatomic, readonly) NSDictionary * sections;

@property (nonatomic, readonly) NSString * name;

- (id) initWithAppInfo:(CMsgClientAppInfoResponse_App *)info status:(SKAppInfoStatus)status;

@end
