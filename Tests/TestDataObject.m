//
//  TestDataObject.m
//  lighthouse
//
//  Created by Seb Martin on 12-07-10.
//  Copyright (c) 2012 Seb Martin. All rights reserved.
//

#import "TestDataObject.h"


@implementation TestNonNSCoding

@synthesize string;

@end


@implementation TestDataObject

@synthesize string;
@synthesize dictionary;
@synthesize distantFuture, distantPast;
@synthesize yes;
@synthesize no;
@synthesize maxdouble, maxfloat, maxlong, maxulong, maxlonglong, maxulonglong;
@synthesize mindouble, minfloat, minlong, minulong, minlonglong, minulonglong;
@synthesize aStruct;
@synthesize readOnlyString = _readOnlyString;
@synthesize readOnlyInt = _readOnlyInt;
@synthesize nestedObject;
@synthesize nonNSCoding;

-(void)setReadOnlyInitValues {
    _readOnlyString = @"This string is read-only!";
    _readOnlyInt = 987654321;
}

-(int)readOnlyProp {
    return 1;
}

@end
