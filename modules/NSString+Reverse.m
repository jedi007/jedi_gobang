//
//  NSString+Reverse.m
//  jedi_gobang
//
//  Created by dev on 2019/6/13.
//  Copyright © 2019 李杰. All rights reserved.
//

#import "NSString+Reverse.h"


@implementation NSString (Reverse)
- (NSString *)stringByReversed
{
    NSMutableString *s = [NSMutableString string];
    for (NSUInteger i=self.length-1; i>0; i--) {
        [s appendString:[self substringWithRange:NSMakeRange(i, 1)]];
    }
    return s;
}
@end
