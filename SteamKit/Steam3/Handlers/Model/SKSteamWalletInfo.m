//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamWalletInfo.h"
#import "Steammessages_clientserver.pb.h"

NSString * const SKSteamWalletInfoUpdateNotification = @"SKSteamWalletInfoUpdateNotification";

@implementation SKSteamWalletInfo

- (id) initWithMessage:(CMsgClientWalletInfoUpdate *)walletInfo
{
	self = [super init];
	if (self)
	{
		_balance = walletInfo.balance;
		_currency = walletInfo.currency;
	}
	return self;
}

@end
