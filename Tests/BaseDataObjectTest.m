//
//  BaseDataObjectTest.m
//
//  Created by Seb Martin on 12-07-09.
//  Copyright (c) 2012 Seb Martin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestDataObject.h"

@interface BaseDataObjectTest : XCTestCase

@end

@implementation BaseDataObjectTest

-(void) testEncodeDecodeString {
    // Encode
    TestDataObject *ob = [[TestDataObject alloc] init];
    ob.string = @"String, yo!";
    
    // Decode
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:ob];
    TestDataObject *unarchived = (TestDataObject*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    XCTAssertEqualObjects([unarchived string], [ob string], @"String property was not encoded/decoded correctly");
}

-(void) testEncodeDecodeDate {
    // Encode
    TestDataObject *ob = [[TestDataObject alloc] init];
    ob.distantFuture = [NSDate distantFuture];
    ob.distantPast = [NSDate distantPast];
    
    // Decode
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:ob];
    TestDataObject *unarchived = (TestDataObject*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    XCTAssertEqualObjects([unarchived distantFuture], [ob distantFuture], @"Distant future date property was not encoded/decoded correctly");
    XCTAssertEqualObjects([unarchived distantPast], [ob distantPast], @"Distant past date property was not encoded/decoded correctly");
}

-(void) testEncodeDecodeFloat {
    // Encode
    TestDataObject *ob = [[TestDataObject alloc] init];
    ob.maxfloat = 3.40282346638528860e+38;
    ob.minfloat = 1.40129846432481707e-45;
    
    // Decode
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:ob];
    TestDataObject *unarchived = (TestDataObject*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertEqual([unarchived minfloat], [ob minfloat], @"Float (min) property was not encoded/decoded correctly");
    XCTAssertEqual([unarchived maxfloat], [ob maxfloat], @"Float (max) property was not encoded/decoded correctly");
}

-(void) testEncodeDecodeDouble {
    // Encode
    TestDataObject *ob = [[TestDataObject alloc] init];
    ob.maxdouble = 1.7976931348623157e+308;
    ob.mindouble = 2.2250738585072009e-308;
    
    // Decode
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:ob];
    TestDataObject *unarchived = (TestDataObject*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    XCTAssertEqual([unarchived mindouble], [ob mindouble], @"Float (min) property was not encoded/decoded correctly");
    XCTAssertEqual([unarchived maxdouble], [ob maxdouble], @"Float (max) property was not encoded/decoded correctly");
}

-(void) testEncodeDecodeLong {
    // Encode
    TestDataObject *ob = [[TestDataObject alloc] init];
    ob.maxlong = 0x7FFFFFFF;
    ob.minlong = 0x80000000;
    
    // Decode
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:ob];
    TestDataObject *unarchived = (TestDataObject*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    XCTAssertEqual([unarchived maxlong], [ob maxlong], @"Signed long (max) property was not encoded/decoded correctly");
    XCTAssertEqual([unarchived minlong], [ob minlong], @"Signed long (min) property was not encoded/decoded correctly");
}

-(void) testEncodeDecodeUnsignedLong {
    // Encode
    TestDataObject *ob = [[TestDataObject alloc] init];
    ob.maxulong = 0xFFFFFFFF;
    ob.minulong = 0;
    
    // Decode
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:ob];
    TestDataObject *unarchived = (TestDataObject*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    XCTAssertEqual([unarchived maxulong], [ob maxulong], @"Unsigned long (max) property was not encoded/decoded correctly");
    XCTAssertEqual([unarchived minulong], [ob minulong], @"Unsigned long (min) property was not encoded/decoded correctly");
}

-(void) testEncodeDecodeLongLong {
    // Encode
    TestDataObject *ob = [[TestDataObject alloc] init];
    ob.maxlonglong = 0x7FFFFFFFFFFFFFFF;
    ob.minlonglong = 0x8000000000000000;
    
    // Decode
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:ob];
    TestDataObject *unarchived = (TestDataObject*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    XCTAssertEqual([unarchived maxlonglong], [ob maxlonglong], @"Signed long long (max) property was not encoded/decoded correctly");
    XCTAssertEqual([unarchived minlonglong], [ob minlonglong], @"Signed long long (min) property was not encoded/decoded correctly");
}

-(void) testEncodeDecodeUnsignedLongLong {
    // Encode
    TestDataObject *ob = [[TestDataObject alloc] init];
    ob.maxulonglong = 0xFFFFFFFFFFFFFFFF;
    ob.minulonglong = 0;
    
    // Decode
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:ob];
    TestDataObject *unarchived = (TestDataObject*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    XCTAssertEqual([unarchived maxulonglong], [ob maxulonglong], @"Unsigned long long (max) property was not encoded/decoded correctly");
    XCTAssertEqual([unarchived minulonglong], [ob minulonglong], @"Unsigned long long (min) property was not encoded/decoded correctly");
}

-(void) testEncodeDecodeStruct {
    // Encode
    TestDataObject *ob = [[TestDataObject alloc] init];
    struct test_struct aStruct;
    aStruct.aDouble = 12.345;
    aStruct.aNumber = 12345;
    for (int i=0; i < 20; i++) {
        aStruct.anArray[i] = i * 11;
    }
    ob.aStruct = aStruct;
    
    // Decode
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:ob];
    TestDataObject *unarchived = (TestDataObject*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    struct test_struct unarchivedStruct = unarchived.aStruct;
    
    XCTAssertEqual(unarchivedStruct.aDouble, aStruct.aDouble, @"Struct property was not encoded/decoded correctly (double value failed)");
    XCTAssertEqual(unarchivedStruct.aNumber, aStruct.aNumber, @"Struct property was not encoded/decoded correctly (int value failed)");
    for (int i=0; i < 20; i++) {
        XCTAssertEqual(unarchivedStruct.anArray[i], aStruct.anArray[i], @"Struct property was not encoded/decoded correctly (array[%d] value failed)", i);
    }
}

/*
-- This test is disabled for the time being.  We do not decode properties that do not have a setter.  We might implement this
   in the future, but for now we don't need it.  We assume it's a calculated field.
 
-(void) testEncodeDecodeReadOnlyValues {
    // Encode
    TestDataObject *ob = [[TestDataObject alloc] init];
    [ob setReadOnlyInitValues];
    
    // Decode
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:ob];
    TestDataObject *unarchived = (TestDataObject*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    XCTAssertEqualObjects([unarchived readOnlyString], [ob readOnlyString], @"Read-Only NSString property was not encoded/decoded correctly");
    XCTAssertEqual([unarchived readOnlyInt], 0, @"Read-Only NSString property was not encoded/decoded correctly");
}
*/

-(void) testEncodeDecodeNestedObject {
    // Encode
    TestDataObject *ob1 = [[TestDataObject alloc] init];
    TestDataObject *ob2 = [[TestDataObject alloc] init];
    ob1.string = @"ob1";
    ob1.nestedObject = ob2;
    ob2.string = @"ob2";
    
    // Decode
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:ob1];
    TestDataObject *unarchived = (TestDataObject*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    XCTAssertEqualObjects(unarchived.nestedObject.string, ob1.nestedObject.string, @"Nested NSCoding compliant property was not encoded/decoded correctly");

}

-(void) testEncodeDecodeNonNSCoding {
    // Encode
    TestDataObject *ob = [[TestDataObject alloc] init];
    ob.nonNSCoding = [[TestNonNSCoding alloc] init];
    ob.nonNSCoding.string = @"test";
    
    // Try to encode, should throw an exception
    XCTAssertThrowsSpecificNamed([NSKeyedArchiver archivedDataWithRootObject:ob],
                                NSException, NSInvalidArgumentException, @"Non-NSCoding properties did not throw an exception.");
    
}

@end
