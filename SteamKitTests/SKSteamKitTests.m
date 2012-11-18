//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamKitTests.h"
#import "_SKCMClient.h"

@implementation SKSteamKitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
//    STFail(@"Unit tests are not implemented yet in SteamKitTests");
    
    NSArray * servers = [_SKCMClient serverList];
    _SKCMClient * client = [[_SKCMClient alloc] init];
    NSError * error = nil;
    BOOL result = [client connectToServer:servers[0] error:&error];
    STAssertTrue(result, @"Should have started connecting");
    
    for(int i = 0; i < (60 * 2); i++)
    {
        @autoreleasepool
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        }
    }
}

@end
