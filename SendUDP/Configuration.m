//
//  Configuration.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 26.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import "Configuration.h"

@implementation Configuration

-(BOOL)isValid {
    return [self ipAddress] != NULL && [self port] != NULL;
}

@end
