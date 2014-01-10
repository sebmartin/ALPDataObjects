//
//  ALPBaseDataObject.h
//
//  Created by Seb Martin on 12-06-08.
//  Copyright (c) 2012 Seb Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALPBaseDataObject : NSObject<NSCoding>

// Override this method to treat exceptions manually
- (void)encodeProperty:(NSString*)name attributes:(const char*)attributes coder:(NSCoder*)coder;
- (void)decodeProperty:(NSString*)name attributes:(const char*)attributes coder:(NSCoder*)coder;


@end
