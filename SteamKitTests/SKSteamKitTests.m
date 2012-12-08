//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import <stdio.h>
#import <stdlib.h>
#import <string.h>

#import "SKSteamKitTests.h"
#import "SKSteamClient.h"
#import "SKSteamUser.h"
#import <CRBoilerplate/CRBoilerplate.h>
#import "SKSteamFriends.h"
#import "SKSteamChatMessageInfo.h"
#import "SKNSNotificationExtensions.h"
#import "SKSteamFriend.h"
#import "SKSteamClan.h"
#import "SKSteamChatRoom.h"
#import "_SKKeyValueParser.h"
#import "SKSteamApps.h"

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

static uint64_t steamClanSteamID = 0LLU; // Replace with Steam Group SteamID

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
			
			[steamClient.steamApps setGameBeingPlayed:@570];
			
			if (steamClanSteamID > 0)
			{
				[steamClient.steamFriends enterChatRoomForClanID:steamClanSteamID];
			}
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
	
	if (info.chatEntryType == EChatEntryTypeChatMsg && info.chatRoomClan.steamId == steamClanSteamID)
	{
		SKSteamClient * client = notification.object;
		NSString * reply = [NSString stringWithFormat:@"Echo: %@", message];
		//[client.steamFriends sendChatMessageToFriend:friend type:EChatEntryTypeChatMsg text:reply];
		
		NSLog(@"All messages from %@ so far: %@", info.chatRoomClan.name, [[client.steamFriends chatMessageHistoryForClanWithSteamID:info.chatRoomClan.steamId] valueForKey:@"message"]);
		NSLog(@"Chat room members: %@", [info.chatRoom.members valueForKey:@"personaName"]);
		
		// Chat room echo bot
		[client.steamFriends sendChatMessageToChatRoom:info.chatRoom type:EChatEntryTypeChatMsg text:reply];
	}
}

@end
