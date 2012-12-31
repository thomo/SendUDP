//
//  Configuration.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 26.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import "Configuration.h"

NSString* const ConfigurationHasChangedNotification = @"ConfigurationHasChangedNotification";

@implementation Configuration

- (void)notifyObservers {
    [[NSNotificationCenter defaultCenter] postNotificationName:ConfigurationHasChangedNotification object:nil];
}

- (void)setIpAddress:(NSString *)ipAddress {
    if (![ipAddress isEqualToString:_ipAddress]) {
        _ipAddress = ipAddress;
        [self notifyObservers];
    }
}

- (void)setPort:(NSString *)port {
    if (![port isEqualToString:_port]) {
        _port = port;
        [self notifyObservers];
    }
}

@end
