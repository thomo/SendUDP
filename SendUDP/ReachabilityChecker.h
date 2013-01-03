//
//  ReachabilityChecker.h
//  SendUDP
//
//  Created by Thomas Mohaupt on 03.01.13.
//  Copyright (c) 2013 Thomas Mohaupt. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ReachabilityCheckerChangedNotification @"ReachabilityCheckerChangedNotification"

@interface ReachabilityChecker : NSObject
- (BOOL)isReachable;
@end
