//
//  IpAddressValidator.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 28.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import "IpAddressValidator.h"

@implementation IpAddressValidator

- (BOOL)isValid:(NSString *)ipAddress {
    BOOL result = false;
    
    if ([ipAddress length] == 0 ) {
        result = false;
    } else {
        NSPredicate *regExpPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(\\d{1,3}).(\\d{1,3}).(\\d{1,3}).(\\d{1,3})"];
        result = [regExpPredicate evaluateWithObject:ipAddress];
    }
    
    return result;
}

@end
