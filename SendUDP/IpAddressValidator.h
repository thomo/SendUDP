//
//  IpAddressValidator.h
//  SendUDP
//
//  Created by Thomas Mohaupt on 28.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IpAddressValidator : NSObject 

- (BOOL) isValid:(NSString *)ipAddress;

@end
