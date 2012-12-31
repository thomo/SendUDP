//
//  Configuration.h
//  SendUDP
//
//  Created by Thomas Mohaupt on 26.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject
@property (nonatomic, retain) NSString *ipAddress;
@property (nonatomic, retain) NSString *port;

@end
