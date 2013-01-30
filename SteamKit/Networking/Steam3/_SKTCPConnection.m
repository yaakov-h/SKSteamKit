//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "_SKTCPConnection.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import <CRBoilerplate/CRBoilerplate.h>
#import <netinet/in.h>
#import "_SKNetFilterEncryption.h"

typedef enum
{
    _SKTCPConnectionTagWriteOutgoingMessage,
    _SKTCPConnectionTagReadHeaderAndMagic,
    _SKTCPConnectionTagReadBody,
} _SKTCPConnectionTag;

static const uint32_t _SKTCPMagic = 0x31305456; // "VT01"
static const uint32_t _SKTCPHeaderAndMagicSize = 2 * sizeof(uint32_t);

@implementation _SKTCPConnection
{
    GCDAsyncSocket * _socket;
    dispatch_queue_t _queue;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        _queue = dispatch_queue_create("org.opensteamworks.steamkit.tcpqueue", 0);
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue() socketQueue:_queue];
		
		// 'VOIP' backgrounding
		[_socket performBlock:^{
			[_socket enableBackgroundingOnSocket];
		}];
    }
    return self;
}

- (void) dealloc
{
    //dispatch_release(_queue);
}

- (BOOL) connectToAddress:(uint32_t)address port:(uint16_t)port error:(NSError *__autoreleasing*)error
{
    struct sockaddr_in params;
    params.sin_addr.s_addr = htonl(address);
    params.sin_family = AF_INET;
    params.sin_port = htons(port);
    
    NSData * addressData = [NSData dataWithBytes:&params length:sizeof(struct sockaddr_in)];
    return [_socket connectToAddress:addressData error:error];
}

- (void) disconnect
{
    [_socket disconnect];
}

- (void) sendMessage:(_SKMsgBase *) message
{
    NSData * data = [message serialize];
    
    if (self.netFilter != nil)
    {
        data = [self.netFilter dataByEncryptingOutgoingData:data];
    }
    
    NSMutableData * packetData = [NSMutableData data];
    [packetData cr_appendUInt32:[data length]];
    [packetData cr_appendUInt32:_SKTCPMagic];
    [packetData appendData:data];
    
    [_socket writeData:packetData withTimeout:-1 tag:_SKTCPConnectionTagWriteOutgoingMessage];
}

#pragma mark -
#pragma mark GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [self.delegate connectionDidConnect:self];
    
    [sock readDataToLength:_SKTCPHeaderAndMagicSize withTimeout:-1 tag:_SKTCPConnectionTagReadHeaderAndMagic];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    [self.delegate connection:self didDisconnectWithError:err];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    switch ((_SKTCPConnectionTag)tag)
    {
        case _SKTCPConnectionTagReadHeaderAndMagic:
        {
            CRDataReader * dataReader = [[CRDataReader alloc] initWithData:data];
            uint32_t packetLength = [dataReader readUInt32];
            uint32_t magic = [dataReader readUInt32];
            if (magic != _SKTCPMagic)
            {
                CRLog(@"ERROR: \"There's no such thing as magic\" - Vernon Dursley");
                CRLog(@"Received magic: %u", magic);
                [self disconnect];
                return;
            }
            [sock readDataToLength:packetLength withTimeout:-1 tag:_SKTCPConnectionTagReadBody];
            
            // Start reading next
            [sock readDataToLength:_SKTCPHeaderAndMagicSize withTimeout:-1 tag:_SKTCPConnectionTagReadHeaderAndMagic];
            break;
        }
            
        case _SKTCPConnectionTagReadBody:
        {
            if (self.netFilter != nil)
            {
                data = [self.netFilter dataByDecryptingIncomingData:data];
            }
            
            [self.delegate connection:self didReceiveMessageData:data];
            
            break;
        }
            
        case _SKTCPConnectionTagWriteOutgoingMessage:
        {
            CRLog(@"ERROR: Recieved an outgoing message. WTF?");
        }
    }
}

- (uint32_t) localIPAddress
{
    struct sockaddr_in * localSocket;
    NSData * localSocketData = [_socket localAddress];
    localSocket = (struct sockaddr_in *)[localSocketData bytes];
    
    return ntohl(localSocket->sin_addr.s_addr);
}

@end
