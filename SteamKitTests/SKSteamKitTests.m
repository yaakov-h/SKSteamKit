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
#import "_SKClientGCMsgProtobuf.h"
#import "dota_gcmessages.pb.h"
#import "SKSteamGameCoordinator.h"
#import "Base_gcmessages.pb.h"
#import "SKSteamUserStats.h"

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
        
        NSDictionary * details = @{SKLogonDetailUsername: @"USERNAME", SKLogonDetailPassword:@"PASSWORD", SKLogonDetailRememberMe: @YES};
		CRPromise * loginPromise = [steamClient.steamUser logOnWithDetails:details];
		
		//CRPromise * loginPromise = [steamClient.steamUser logOnAnonymously];
		
		/*if (![steamClient.steamUser hasRememberedPassword])
		{
			STAssertFalse(true, @"Fail.");
			return;
		}
		
		CRPromise * loginPromise = [steamClient.steamUser logOnWithStoredDetails];
		*/
		
        [[loginPromise addFailureHandler:^(NSError *error)
        {
            NSLog(@"Failed to log in: %@", error);
            
        }] addSuccessHandler:^(id data)
        {
            NSLog(@"Logged in to Steam: %@", data);
//			steamClient.steamFriends.personaState = EPersonaStateOnline;
			
//			[steamClient.steamApps setGameBeingPlayed:570];
//			[steamClient.steamGameCoordinator sendClientHelloWithVersion:212 forApp:570];
//			
//			_SKClientGCMsgProtobuf * msg = [[_SKClientGCMsgProtobuf alloc] initWithBodyClass:[CMsgInitialQuestionnaireResponse class] messageType:EDOTAGCMsgk_EMsgGCInitialQuestionnaireResponse];
//			CMsgInitialQuestionnaireResponse_Builder * qb = [[CMsgInitialQuestionnaireResponse_Builder alloc] init];
//			[qb setInitialSkill:CMsgDOTARequestMatches_SkillLevelNormal];
//			msg.body = [qb build];
//			[steamClient.steamGameCoordinator sendGCMessage:msg forApp:570];
			
			
//			if (steamClanSteamID > 0)
//			{
//				[steamClient.steamFriends enterChatRoomForClanID:steamClanSteamID];
//			}
			
			//CRPromise * tokensPromise = [steamClient.steamApps PICSGetAccessTokensForApps:@[ @740 ] packages:nil];
			CRPromise * pr = [steamClient.steamUserStats getNumberOfCurrentPlayersForGame:570];
			[pr addSuccessHandler:^(id data) {
				NSLog(@">>> %@ users playing Dota 2", data);
			}];
			
			[[steamClient.steamApps requestPackageInfoForPackagesWithIDs:@[ @0 ]] addSuccessHandler:^(id data) {
				NSLog(@"packages: %@", data);
			}];
			
			CRPromise * promise = [steamClient.steamApps PICSGetProductInfoForApp:740];
			[[promise addSuccessHandler:^(id data) {
				NSLog(@"got tokens: %@", data);
			}] addFailureHandler:^(NSError *error) {
				NSLog(@"failed to get tokens: %@", error);
			}];
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
