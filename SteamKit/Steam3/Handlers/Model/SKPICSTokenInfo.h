//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@class CMsgPICSAccessTokenResponse;

@interface SKPICSTokenInfo : NSObject

@property (nonatomic, readonly) NSArray * packageTokensDenied;
@property (nonatomic, readonly) NSArray * appTokensDenied;
@property (nonatomic, readonly) NSDictionary * packageTokens;
@property (nonatomic, readonly) NSDictionary * appTokens;

- (id) initWithMessage:(CMsgPICSAccessTokenResponse *)msg;

@end
