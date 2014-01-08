//
//  ALPGuidUtility.m
//  lighthouse
//
//  Created by Seb Martin on 2012-08-16.
//  Copyright (c) 2012 Seb Martin. All rights reserved.
//

#import "ALPGuidUtility.h"

@implementation ALPGuidUtility

+ (NSString*)generateGuid
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}

@end
