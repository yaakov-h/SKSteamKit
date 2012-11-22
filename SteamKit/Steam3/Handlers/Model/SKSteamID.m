//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "SKSteamID.h"

typedef union {
    struct {
		// This struct is one way around for iOS, and the other way around for OS X.
		// This is the iOS version.
        uint32_t        m_unAccountID : 32;
        uint32_t        m_unAccountInstance : 20;
        EAccountType    m_EAccountType : 4;
        EUniverse       m_EUniverse : 8;
    } m_comp;
    uint64_t m_unAll64Bits;
} _SKSteamIDInternal;

@implementation SKSteamID
{
	_SKSteamIDInternal _internal;
}

- (id) initWithUnsignedLongLong:(uint64_t)steamID
{
	self = [super init];
	if (self)
	{
		_internal.m_unAll64Bits = steamID;
	}
	return self;
}

- (id) initWithUniverse:(EUniverse)universe accountType:(EAccountType)accountType instance:(uint32_t)instance accountID:(uint32_t)accountID
{
	self = [super init];
	if (self)
	{
		_internal.m_comp.m_EUniverse = universe;
		_internal.m_comp.m_EAccountType = accountType;
		_internal.m_comp.m_unAccountInstance = instance;
		_internal.m_comp.m_unAccountID = accountID;
	}
	return self;
}

+ (instancetype) steamIDWithUnsignedLongLong:(uint64_t)steamID
{
	return [[[self class] alloc] initWithUnsignedLongLong:steamID];
}

- (EUniverse) universe
{
	return _internal.m_comp.m_EUniverse;
}

- (EAccountType) accountType
{
	return _internal.m_comp.m_EAccountType;
}

- (uint32_t) instance
{
	return _internal.m_comp.m_unAccountInstance;
}

- (uint32_t) accountID
{
	return _internal.m_comp.m_unAccountID;
}

- (uint64_t) unsignedLongLongValue
{
	return _internal.m_unAll64Bits;
}

- (BOOL) isIndividualAccount
{
	return self.accountType == EAccountTypeIndividual || self.accountType == EAccountTypeConsoleUser;
}

- (BOOL) isClanAccount
{
	return self.accountType == EAccountTypeClan;
}

@end
