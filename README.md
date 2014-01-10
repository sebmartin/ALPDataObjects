# ALPDataObjects

Data Objects is a model base class that makes using NSCoding easy and boilerplate free.  This allows you to turn any of your data objects into NSData and then back again.  There is also almost no restrictions on how you define your data objects since ALPDataObjects can support almost any property type.

## Example

### The model definition

Consider the following ridiculous model:

```objc
struct test_struct {
    int aNumber;
    double aDouble;
    int anArray[20];
};

@interface TestNonNSCoding: NSObject
@property (weak, nonatomic) NSString *string;
@end;

@interface MyDataObject : ALPBaseDataObject

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
@property (strong, nonatomic) TestDataObject *nestedObject;
@property (strong, nonatomic) TestNonNSCoding *nonNSCoding;

@end
```

### Serializing

Saving this object to disk using NSCoding would be extremely painful given that most of its properties are of types that are not supported by NSCoding out of the box.  However, since this model inherits from ALPBaseDataObjects, saving it to disk is as easy as:

```objc
TestDataObject *model = [[TestDataObject alloc] init];
NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
[data writeToFile:pathToFile atomically:NO]
```

### Deserializing

Restoring that object is just as easy:

```objc
NSData *data = [NSData dataWithContentsOfURL:fileURL];
TestDataObject *unarchived = (TestDataObject*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
```

## How does it work?

The NSALPBaseDataObject implements the NSCoding and uses the Objective-C runtime to decipher type information from the object and serializes every defined _property_ in the object.  IVars are ignored so they will not be serialized/deserialized.  

Almost all types data types are supported without any additional effort.  The example above is taken from the unit test suite.  Take a look at the unit tests and see for yourself.

## Sound Familiar?

Yeah, it is.  Github did something similar with [Mantle](https://github.com/MantleFramework/Mantle) and pushed it a little further even with JSON features.  Mantle was made public _maybe_ one month after I completed this.
