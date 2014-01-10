//
//  TestDataObject.h
//
//  Created by Seb Martin on 12-07-10.
//  Copyright (c) 2012 Seb Martin. All rights reserved.
//

#import "ALPBaseDataObject.h"

struct test_struct {
    int aNumber;
    double aDouble;
    int anArray[20];
};


@interface TestNonNSCoding: NSObject

@property (weak, nonatomic) NSString *string;

@end;


@interface TestDataObject : ALPBaseDataObject

@property (strong, nonatomic) NSString* string;
@property (strong, nonatomic) NSDictionary* dictionary;
@property (strong, nonatomic) NSDate* distantFuture;
@property (strong, nonatomic) NSDate* distantPast;
@property (assign) BOOL yes;
@property (assign) BOOL no;
@property (assign) float maxfloat;
@property (assign) float minfloat;
@property (assign) double maxdouble;
@property (assign) double mindouble;
@property (assign) long maxlong;
@property (assign) long minlong;
@property (assign) long long maxlonglong;
@property (assign) long long minlonglong;
@property (assign) unsigned long maxulong;
@property (assign) unsigned long minulong;
@property (assign) unsigned long long maxulonglong;
@property (assign) unsigned long long minulonglong;
@property (assign) struct test_struct aStruct;
@property (strong, readonly) NSString *readOnlyString;
@property (assign, readonly) int readOnlyInt;
@property (readonly) int readOnlyProp;
@property (strong, nonatomic) TestDataObject *nestedObject;
@property (strong, nonatomic) TestNonNSCoding *nonNSCoding;

-(void)setReadOnlyInitValues;

@end
