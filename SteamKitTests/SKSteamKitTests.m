//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamKitTests.h"
#import "SKSteamClient.h"
#import "SKSteamUser.h"
#import <CRBoilerplate/CRBoilerplate.h>
#import "SKSteamFriends.h"
#import "SKSteamChatMessageInfo.h"
#import "SKNSNotificationExtensions.h"
#import "SKSteamFriend.h"

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
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveChatMessage:) name:SKSteamChatMessageInfoNotification object:steamClient];
    
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
			steamClient.steamFriends.personaState = EPersonaStateOnline;
        }];
    }];
    
    for(int i = 0; i < (60 * 3); i++)
    {
        @autoreleasepool
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        }
    }
}

- (void) didRecieveChatMessage:(NSNotification *)notification
{
	SKSteamChatMessageInfo * info = [notification steamInfo];
	
	SKSteamFriend * friend = info.steamFriendFrom;
	NSString * message = info.message;
	
	if (info.chatEntryType == EChatEntryTypeChatMsg && info.chatRoomClan == nil)
	{
		SKSteamClient * client = notification.object;
		NSString * reply = [NSString stringWithFormat:@"Echo: %@", message];
		[client.steamFriends sendChatMessageToFriend:friend type:EChatEntryTypeChatMsg text:reply];
		
		NSLog(@"All messages from %@ so far: %@", friend.personaName, [[client.steamFriends chatMessageHistoryForFriendWithSteamID:friend.steamId] valueForKey:@"message"]);
	}
}

@end
