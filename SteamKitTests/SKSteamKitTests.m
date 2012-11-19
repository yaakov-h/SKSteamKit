//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamKitTests.h"
#import "SKSteamClient.h"
#import "SKSteamUser.h"
#import <CRBoilerplate/CRBoilerplate.h>

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
    
    SKSteamClient * steamClient = [[SKSteamClient alloc] init];
    
    [[[steamClient connect] addFailureHandler:^(NSError *error)
    {
        NSLog(@"Error: %@", error);
        
    }] addSuccessHandler:^(id data)
    {
        NSLog(@"Connected to Steam3: %@", data);
        
        NSDictionary * details = @{SKLogonDetailUsername: @"[REDACTED]", SKLogonDetailPassword:@"[REDACTED]"};
        
        [[[steamClient.steamUser logOnWithDetails:details] addFailureHandler:^(NSError *error)
        {
            NSLog(@"Failed to log in: %@", error);
            
        }] addSuccessHandler:^(id data)
        {
            NSLog(@"Logged in to Steam: %@", data);
        }];
    }];
    
    for(int i = 0; i < (60 * 2); i++)
    {
        @autoreleasepool
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        }
    }
}

@end
