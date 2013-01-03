//
//  ReachabilityChecker.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 03.01.13.
//  Copyright (c) 2013 Thomas Mohaupt. All rights reserved.
//

#import "ReachabilityChecker.h"

#import <netinet/in.h>

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation ReachabilityChecker {
    SCNetworkReachabilityRef reachabilityRef;
}

-(id)init {
    if (self = [super init]) {
       [self startNofifier];
    }
    return self;
}

- (void)startNofifier {

    struct sockaddr_in dummyAddress;
    bzero(&dummyAddress, sizeof(dummyAddress));
    dummyAddress.sin_len = sizeof(dummyAddress);
    dummyAddress.sin_family = AF_INET;
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};

    reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (struct sockaddr *) &dummyAddress);
    if(SCNetworkReachabilitySetCallback(reachabilityRef, ReachabilityCallback, &context))
    {
        SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}

- (void) stopNotifier {
	if(reachabilityRef!= NULL) {
		SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	}
}

- (void)dealloc {
    [self stopNotifier];

	if(reachabilityRef!= NULL)
	{
		CFRelease(reachabilityRef);
	}
}

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) {
	[[NSNotificationCenter defaultCenter] postNotificationName:ReachabilityCheckerChangedNotification object:nil];
}

- (BOOL)isReachable
{
    if (reachabilityRef) {
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
        {
            if((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect))
            {
                return YES;
            }

            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }

            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }

            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs

                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }

            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
        return NO;
    }
    return NO;
}

@end
