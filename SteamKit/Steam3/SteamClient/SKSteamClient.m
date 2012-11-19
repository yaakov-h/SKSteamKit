//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamClient.h"
#import "SKClientMsgHandler.h"
#import "_SKCMClientDelegate.h"
#import "_SKCMCLient.h"
#import "SKSteamUser.h"
#import <CRBoilerplate/CRBoilerplate.h>

@interface SKSteamClient () <_SKCMClientDelegate>
@end

@implementation SKSteamClient
{
    NSMutableArray * _handlers;
    CRDeferred * _connectDeferred;
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
    }
    return self;
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

- (SKSteamUser *) steamUser
{
    for (id handler in _handlers)
    {
        if ([handler isKindOfClass:[SKSteamUser class]])
        {
            return handler;
        }
    }
    
    return nil;
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
    
//    [self.handlers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
//     {
//         if ([obj respondsToSelector:@selector(clientDidConnect:)])
//         {
//             [obj clientDidConnect:client];
//         }
//     }];
}

- (void) client:(_SKCMClient *)client didDisconnectWithError:(NSError *)error
{
//    [self.handlers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
//    {
//        if ([obj respondsToSelector:@selector(client:didDisconnectWithError:)])
//        {
//            [obj client:client didDisconnectWithError:error];
//        }
//    }];
}

- (void) client:(_SKCMClient *)client didRecieveMessage:(_SKPacketMsg *)packetMessage
{
    [self.handlers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         [obj handleMessage:packetMessage];
     }];
}

@end
