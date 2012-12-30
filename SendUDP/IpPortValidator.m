//
//  IpPortValidator.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 30.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import "IpPortValidator.h"

@implementation IpPortValidator

- (BOOL)isValid:(NSString *)port {
    NSPredicate *regExpPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"\\d{1,5}"];
    if (![regExpPredicate evaluateWithObject:port]) {
        return false;
    }

    int number = [port intValue];
    return number > 0 && number < 65535;
}

@end

