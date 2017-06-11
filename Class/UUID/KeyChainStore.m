//
//  KeyChainStore.m
//  UUID
//
//  Created by ThomasYang on 16/6/28.
//  Copyright © 2016年 yunzujia. All rights reserved.
//

#import "KeyChainStore.h"
#define  KEY_USERNAME_PASSWORD @"com.company.app.usernamepassword"

#define  KEY_USERNAME @"com.company.app.username"

#define  KEY_PASSWORD @"com.company.app.password"

@implementation KeyChainStore
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
            (id)kSecClassGenericPassword,(id)kSecClass,
            
            service, (id)kSecAttrService,
            
            service, (id)kSecAttrAccount,
            
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            
            nil];
    
}


+ (void)save:(NSString *)service data:(id)data {
    
    //Get search dictionary
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    //Delete old item before add new item
    
    SecItemDelete((CFDictionaryRef)keychainQuery);
    
    //Add new object to search dictionary(Attention:the data format)
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    
    //Add item to keychain with the search dictionary
    
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    
}


+ (id)load:(NSString *)service {
    
    id ret = nil;
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    //Configure the search setting
    
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        
        @try {
            
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
            
        } @catch (NSException *e) {
            
            NSLog(@"Unarchive of %@ failed: %@", service, e);
            
        } @finally {
            
        }
        
    }
    
    if (keyData)
        
        CFRelease(keyData);
    
    return ret;
    
}


+ (void)deleteKeyData:(NSString *)service {
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    SecItemDelete((CFDictionaryRef)keychainQuery);
    
}

@end
