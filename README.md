# ALPDataObjects

Data Objects is a base class that makes using NSCoding easy and boilerplate free.  This allows you to turn any of your data objects into NSData and then back again.  There is also almost no restrictions on how you define your data objects since ALPDataObjects can support almost any property type.

## Example

### The model definition

Consider the following ridiculous model:

```objc
// Define a struct to embed into our model
struct test_struct {
    int aNumber;
    double aDouble;
    int anArray[20];
};

// Define an NSObject that doesn't implement NSCoding
@interface TestNonNSCoding: NSObject
@property (weak, nonatomic) NSString *string;
@end;

// This is our model class
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

Saving this object to disk using NSCoding would be extremely painful given that most of its properties are of types that are not supported by NSCoder out of the box.  However, since this model inherits from ALPBaseDataObjects, saving it to disk is as easy as:

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

That's it, no additional NSCoding boilerplate required.

## How does it work?

The NSALPBaseDataObject implements the NSCoding protocol and uses the Objective-C runtime to decipher type information from the object and (de)serializes every defined _property_ in the object.  IVars that are not backed by a property are ignored so they will not be serialized/deserialized.  This is by design.

Pretty much all data types are supported without any additional effort.  The example above is taken from the unit test suite so take a look at the unit tests and see for yourself.

## Sound Familiar?

Uhm Yeah, it is...  Github did something similar with [Mantle](https://github.com/MantleFramework/Mantle) and pushed it a little further even with builtin JSON support and other features that make transferring objects over the wire extremely easy.  As luck would have it, Mantle was made public _maybe_ one month after I completed this.  Oh well, if anything this was a fun opportunity for me to dig deeper into the Objective-C runtime.

## License
Licensed under MIT.  See license file for details.
