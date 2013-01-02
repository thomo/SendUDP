//
//  UdpTransmitter.h
//  SendUDP
//
//  Created by Thomas Mohaupt on 02.01.13.
//  Copyright (c) 2013 Thomas Mohaupt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UdpTransmitter : NSObject

@property (nonatomic, retain) NSString *statusMessage;

- (id)initWithIp:(NSString *)ipAddress port:(NSString *)port;

- (BOOL)transmit:(NSString *)message;

- (BOOL)readyToTransmit;


@end
