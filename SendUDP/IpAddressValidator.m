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
    NSPredicate *regExpPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.){3}([01]?\\d\\d?|2[0-4]\\d|25[0-5])"];
    return [regExpPredicate evaluateWithObject:ipAddress];
}

@end
