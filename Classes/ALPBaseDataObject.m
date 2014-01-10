//
//  ALPBaseDataObject.m
//
//  Created by Seb Martin on 12-06-08.
//  Copyright (c) 2012 Seb Martin. All rights reserved.
//

#import "ALPBaseDataObject.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import "ALPGuidUtility.h"

@interface ALPBaseDataObject (private)
-(void) setGUID:(NSString*)guid; // This is only declared to silence a warning in the init method below
@end

@implementation ALPBaseDataObject

-(id)init {
    self = [super init];
    if (self) {
        if ([self respondsToSelector:@selector(setGUID:)]) {
            [(id)self performSelector:@selector(setGUID:) withObject:[ALPGuidUtility generateGuid]];
        }
    }
    return self;
}
#pragma mark - Support accessing keys like properties

- (SEL)getterSelectorForPropertyName:(NSString*)name
{
    return NSSelectorFromString(name);
}

- (SEL)setterSelectorForPropertyName:(NSString*)name
{
    // Uppercase the first charactor
    NSRange firstCharRange = NSMakeRange(0, 1);
    NSString *firstChar = [name substringWithRange:firstCharRange];
    name = [name stringByReplacingCharactersInRange:firstCharRange withString:[firstChar uppercaseString]];
    
    // Add the 'set' prefix
    name = [NSString stringWithFormat:@"set%@:", name];
    
    return NSSelectorFromString(name);
}

- (void)executeForEachProperty:(void(^)(NSString* name, const char* attributes))block {
    unsigned int propertyCount = 0;
    objc_property_t* properties = class_copyPropertyList([self class], &propertyCount);
    
    for (int i=0; i < propertyCount; i++) {
        NSString *name = [NSString stringWithCString:property_getName(properties[i])
                                            encoding:NSUTF8StringEncoding];
        const char *attr = property_getAttributes(properties[i]);
        block(name, attr);
    }
}

#pragma mark - Default encode/decode implementations

- (void)encodeProperty:(NSString*)name attributes:(const char*)attributes coder:(NSCoder*)coder
{
    SEL getter = [self getterSelectorForPropertyName:name];
    
    // Call the getter
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:getter];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:methodSignature];
    inv.selector = getter;
    inv.target = self;
    [inv invoke];
    
    // Encode the resulting value
    if ([methodSignature methodReturnType][0] == '@') {
        // Fetch the pointer
        id __autoreleasing object = nil;
        [inv getReturnValue:&object];
        
        // Encode it!
        [coder encodeObject:object forKey:name];
    }
    else {
        // Fetch the value which can be of varying length
        void* value = malloc([methodSignature methodReturnLength]);
        [inv getReturnValue:value];
        
        // Wrap it in an NSData object and encode it
        NSData *valueData = [NSData dataWithBytes:value length:[methodSignature methodReturnLength]];
        [coder encodeObject:valueData forKey:name];
        free(value);
    }
}

- (void)decodeProperty:(NSString*)name attributes:(const char*)attributes coder:(NSCoder*)decoder
{
    // Assume an NSCoding compliant object
    id value = [decoder decodeObjectForKey:name];
    
    if ([value isKindOfClass:[NSData class]] && attributes[1] != '@') {
        // Call the setter
        SEL setter = [self setterSelectorForPropertyName:name];
        if ([self respondsToSelector:setter]) {
            NSMethodSignature *methodSignature = [self methodSignatureForSelector:setter];
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:methodSignature];
            inv.selector = setter;
            inv.target = self;
            [inv setArgument:(void*)[value bytes] atIndex:2];
            [inv invoke];
        }
        /**
        We are currently ignoring properties that do not have a setter.  We might add fancier support for this such
        as looking for ivars and setting them directly, but we don't have a need for that yet.
         
        else {
            NSLog(@"WARNING! Could not decode property '%@' in class '%@'.  The setter method was not found.",
                  name, NSStringFromClass([self class]));
        }
        */
    }
    else if(value != nil) {
        SEL setter = [self setterSelectorForPropertyName:name];
        if ([self respondsToSelector:setter]) {
            [self setValue:value forKey:name];
        }
        else {
            NSLog(@"Did not deserialize property %@ from class %@.  There is no setter defined.  "
                  "You can safely ignore this if this is a read-only property.",
                  name, NSStringFromClass([self class]));
        }
    }
}

#pragma mark - NSCoding methods
                          
- (void)encodeWithCoder:(NSCoder *)coder {
    [self executeForEachProperty:^(NSString* name, const char* attributes) {
        [self encodeProperty:name attributes:attributes coder:coder];
    }];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [[self class] alloc];
    
    [self executeForEachProperty:^(NSString* name, const char* attributes) {
        [self decodeProperty:name attributes:attributes coder:decoder];
    }];
    
    return self;
}

@end
