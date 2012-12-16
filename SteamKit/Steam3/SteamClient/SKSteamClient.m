//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamClient.h"
#import "SKClientMsgHandler.h"
#import "_SKCMClientDelegate.h"
#import "_SKCMCLient.h"
#import "SKSteamUser.h"
#import "SKSteamFriends.h"
#import "SKSteamApps.h"
#import "SKSteamGameCoordinator.h"
#import <CRBoilerplate/CRBoilerplate.h>

NSString * SKSteamClientDisconnectedNotification = @"SKSteamClientDisconnectedNotification";

@interface SKSteamClient () <_SKCMClientDelegate>
@end

@implementation SKSteamClient
{
    NSMutableArray * _handlers;
    CRDeferred * _connectDeferred;
	NSNotificationCenter * _notificationCenter;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        _handlers = [[NSMutableArray alloc] init];
        _client = [[_SKCMClient alloc] init];
        _client.delegate = self;
        
        [self addHandler:[[SKSteamUser alloc] init]];
        [self addHandler:[[SKSteamFriends alloc] init]];
        [self addHandler:[[SKSteamApps alloc] init]];
		[self addHandler:[[SKSteamGameCoordinator alloc] init]];
		
		_notificationCenter = [NSNotificationCenter defaultCenter];
    }
    return self;
}

- (uint64_t) steamID
{
	return _client.steamID;
}

- (EUniverse) connectedUniverse
{
	return _client.connectedUniverse;
}

- (void) addHandler:(SKClientMsgHandler *)handler
{
    [_handlers addObject:handler];
    [handler setUpWithSteamClient:self];
}

- (void) removeHandler:(SKClientMsgHandler *)handler
{
    [_handlers removeObject:handler];
}

- (id) handlerOfClass:(Class)class
{
    for (id handler in _handlers)
    {
        if ([handler isKindOfClass:class])
        {
            return handler;
        }
    }
    
    return nil;
}

- (SKSteamUser *) steamUser
{
    return [self handlerOfClass:[SKSteamUser class]];
}

- (SKSteamFriends *) steamFriends
{
    return [self handlerOfClass:[SKSteamFriends class]];
}

- (SKSteamApps *) steamApps
{
    return [self handlerOfClass:[SKSteamApps class]];
}

- (SKSteamGameCoordinator *) steamGameCoordinator
{
    return [self handlerOfClass:[SKSteamGameCoordinator class]];
}

- (NSArray *) handlers
{
    return _handlers;
}

- (void) sendMessage:(_SKMsgBase *)message
{
    [self.client sendMessage:message];
}

- (CRPromise *) connect
{
    _connectDeferred = [[CRDeferred alloc] init];
    
    NSArray * serverList = [_SKCMClient serverList];
    NSNumber * firstServer = serverList[0];
    
    NSError * error;
    if (![self.client connectToServer:firstServer error:&error])
    {
        [_connectDeferred rejectWithError:error];
    }
    
    return [_connectDeferred promise];
}

- (void) disconnect
{
    [self.client disconnect];
}

#pragma mark -
#pragma mark SKCMClientDelegate

- (void) clientDidConnect:(_SKCMClient *)client
{
    [_connectDeferred resolveWithResult:self];
    _connectDeferred = nil;
}

- (void) client:(_SKCMClient *)client didDisconnectWithError:(NSError *)error
{
	[self postNotification:SKSteamClientDisconnectedNotification withInfo:error];
}

- (void) client:(_SKCMClient *)client didRecieveMessage:(_SKPacketMsg *)packetMessage
{
    [self.handlers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         [obj handleMessage:packetMessage];
     }];
}

- (void) postNotification:(NSString *)notificationName withInfo:(NSObject *)info
{
	NSDictionary * infoDict = info == nil ? nil : @{@"SKNotificationInfo":info};
	[_notificationCenter postNotificationName:notificationName object:self userInfo:infoDict];
}

@end
