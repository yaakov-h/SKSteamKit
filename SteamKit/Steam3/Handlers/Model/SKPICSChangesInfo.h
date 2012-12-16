//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <Foundation/Foundation.h>

@class CMsgPICSChangesSinceResponse;

@interface SKPICSChangesInfo : NSObject

@property (nonatomic, readonly) uint32_t lastChangeNumber;
@property (nonatomic, readonly) uint32_t currentChangeNumber;
@property (nonatomic, readonly) BOOL requiresFullUpdate;
@property (nonatomic, readonly) NSDictionary * packageChanges;
@property (nonatomic, readonly) NSDictionary * appChanges;

- (id) initWithMessage:(CMsgPICSChangesSinceResponse *)msg;

@end
