//
//  ALPGuidUtility.m
//
//  Created by Seb Martin on 2012-08-16.
//  Copyright (c) 2012 Seb Martin. All rights reserved.
//

#import "ALPGuidUtility.h"

@implementation ALPGuidUtility

+ (NSString*)generateGuid
{
    return [[NSUUID UUID] UUIDString];
}

@end
