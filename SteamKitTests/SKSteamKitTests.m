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
			
			[steamClient.steamFriends enterChatRoomForClanID:steamClanSteamID];
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

- (void) notAtestKeyValueParser
{
	NSString * hex = /*@"070000005472616E736C61746F722773204C6F756E676500*/@"004D6573736167654F626A6563740007737465616D69640023E5510101001001025065726D697373696F6E73001A0000000244657461696C7300080000000808004D6573736167654F626A6563740007737465616D6964007AAFE20101001001025065726D697373696F6E73001A0300000244657461696C7300020000000808004D6573736167654F626A6563740007737465616D696400870C2C0201001001025065726D697373696F6E73000A0000000244657461696C7300040000000808004D6573736167654F626A6563740007737465616D696400AC04350201001001025065726D697373696F6E73000A0000000244657461696C7300040000000808004D6573736167654F626A6563740007737465616D6964008CF2050301001001025065726D697373696F6E73000A0000000244657461696C7300040000000808004D6573736167654F626A6563740007737465616D6964007758E90301001001025065726D697373696F6E73000A0000000244657461696C7300040000000808004D6573736167654F626A6563740007737465616D696400A775CC0601001001025065726D697373696F6E7300080000000244657461696C7300000000000808";
	
	NSData *kvData= [self decodeFromHexidecimal:hex];
	
	CRDataReader * reader = [[CRDataReader alloc] initWithData:kvData];
	NSMutableArray * array = [@[] mutableCopy];
	for (int i = 0; i < 7; i++)
	{
		[array addObject:[_SKKeyValueParser readKeyValues:reader]];
	}
	
	
	// Manual inspection
	NSNumber * bob = @([array count]);
}



unsigned char strToChar (char a, char b)
{
    char encoder[3] = {'\0','\0','\0'};
    encoder[0] = a;
    encoder[1] = b;
    return (char) strtol(encoder,NULL,16);
}

- (NSData *) decodeFromHexidecimal:(NSString *)slf
{
    const char * bytes = [slf UTF8String];
    NSUInteger length = strlen(bytes);
    unsigned char * r = (unsigned char *) malloc(length / 2 + 1);
    unsigned char * index = r;
	
    while ((*bytes) && (*(bytes +1))) {
        *index = strToChar(*bytes, *(bytes +1));
        index++;
        bytes+=2;
    }
    *index = '\0';
	
    NSData * result = [NSData dataWithBytes: r length: length / 2];
    free(r);
	
    return result;
}


@end
