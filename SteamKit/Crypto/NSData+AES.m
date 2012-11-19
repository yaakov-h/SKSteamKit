//
// This file is subject to the software licence as defined in
// the file 'LICENCE.txt' included in this source code package.
//

#import "NSData+AES.h"
#import <CRBoilerplate/CRBoilerplate.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (AES)

- (NSData *) sk_symmetricDecryptWithSteamSessionKey:(NSData *)sessionKey
{
    NSData * cryptedIv = [self subdataWithRange:NSMakeRange(0, 16)];
    NSData * cryptedPayload = [self subdataWithRange:NSMakeRange([cryptedIv length], [self length] - [cryptedIv length])];
    
    NSData * iv = [cryptedIv sk_decryptAESECBWithKey:sessionKey];
    NSData * payload = [cryptedPayload sk_decryptAESPKCS7WithKey:sessionKey iv:iv];
    
    return payload;
}

- (NSData *) sk_symmetricEncryptWithSteamSessionKey:(NSData *)sessionKey
{
    NSData * iv = [NSData cr_randomDataOfLength:16];
    
    NSData * cryptedIv = [iv sk_encryptAESECBWithKey:sessionKey];
    NSData * cryptedData = [self sk_encryptAESPKCS7WithKey:sessionKey iv:iv];
    
    NSMutableData * payload = [NSMutableData data];
    [payload appendData:cryptedIv];
    [payload appendData:cryptedData];
    
    return [payload copy];
}

#pragma mark -
#pragma mark Encryption

- (NSData *) sk_encryptAESECBWithKey:(NSData *)key
{
    return [self sk_encryptAESWithOption:kCCOptionECBMode key:key iv:nil];
}

- (NSData *) sk_encryptAESPKCS7WithKey:(NSData *)key iv:(NSData *)iv
{
    return [self sk_encryptAESWithOption:kCCOptionPKCS7Padding key:key iv:iv];
}

- (NSData *) sk_encryptAESWithOption:(CCOptions)option key:(NSData *)key iv:(NSData *)iv
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    memcpy(keyPtr, [key bytes], MIN([key length], kCCKeySizeAES256));
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, option,
                                          keyPtr, kCCKeySizeAES256,
                                          [iv bytes] /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

#pragma mark -
#pragma mark Decryption

- (NSData *) sk_decryptAESECBWithKey:(NSData *)key
{
    return [self sk_decryptAESWithOption:kCCOptionECBMode key:key iv:nil];
}

- (NSData *) sk_decryptAESPKCS7WithKey:(NSData *)key iv:(NSData *)iv
{
    return [self sk_decryptAESWithOption:kCCOptionPKCS7Padding key:key iv:iv];
}

- (NSData*) sk_decryptAESWithOption:(CCOptions)option key:(NSData *)key iv:(NSData *)iv
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    memcpy(keyPtr, [key bytes], MIN([key length], kCCKeySizeAES256));
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesDecrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, option,
                                          keyPtr, kCCKeySizeAES256,
                                          [iv bytes] /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

@end
