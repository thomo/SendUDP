//
//  IpPortValidator.h
//  SendUDP
//
//  Created by Thomas Mohaupt on 30.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IpPortValidator : NSObject
- (BOOL)isValid:(NSString *)port;
@end

