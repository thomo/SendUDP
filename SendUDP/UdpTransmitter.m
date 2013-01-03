//
//  UdpTransmitter.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 02.01.13.
//  Copyright (c) 2013 Thomas Mohaupt. All rights reserved.
//

#import "UdpTransmitter.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface UdpTransmitter ()
    @property (nonatomic, retain) NSString *serverInfo;
@end

@implementation UdpTransmitter{
	CFDataRef srvAddr;
    CFSocketRef socket;
    SCNetworkReachabilityRef reachabilityRef;
}

#define MAX_SENDBUF_SIZE 220

- (id)initWithIp:(NSString *)ipAddress port:(NSString *)port {
    if (self = [super init]) {
        socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_DGRAM, IPPROTO_UDP, 0, NULL, NULL);

        struct sockaddr_in addr;
        memset(&addr, 0, sizeof(addr));
        addr.sin_len = sizeof(addr);
        addr.sin_family = AF_INET;
        addr.sin_port = htons([port intValue]);
        addr.sin_addr.s_addr = inet_addr([ipAddress UTF8String]);
        srvAddr = addr.sin_addr.s_addr != INADDR_NONE ? CFDataCreate(NULL, (const UInt8*)&addr, sizeof(addr)) : NULL;

        [self setServerInfo:[NSString stringWithFormat:@"ip=%@, port=%@", ipAddress, port]];

        [self startNofifier: &addr];
    }
    return self;
}

- (void)startNofifier:(struct sockaddr_in *)addr{
    SCNetworkReachabilityContext	context = {0, (__bridge void *)(self), NULL, NULL, NULL};

    reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (struct sockaddr *) addr);
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

    if (socket) {
        CFRelease(socket); socket = NULL;
    }
	if (srvAddr) {
        CFRelease(srvAddr); srvAddr = NULL;
    }
	if(reachabilityRef!= NULL)
	{
		CFRelease(reachabilityRef);
	}
}

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) {
	[[NSNotificationCenter defaultCenter] postNotificationName:UdpTransmitterReachabilityChangedNotification object:nil];
}

- (BOOL)transmit:(NSString *)message {
    BOOL success = NO;
    CFDataRef dataRef = [self createSendData:message];
    if (dataRef != NULL) {
        if (CFSocketSendData(socket, srvAddr, dataRef, 0) == 0) {
            [self setStatusMessage: [NSString stringWithFormat:@"SEND:\n#bytes=%li, %@", CFDataGetLength(dataRef), [self serverInfo]]];
            success = YES;
        } else {
            [self setStatusMessage: [NSString stringWithFormat:@"ERROR:\n%s", strerror(errno)]];
            success = NO;
        }

        CFRelease(dataRef);
    } else {
        [self setStatusMessage:@"no data to send"];
        success = YES;
    }
    return success;
}

- (CFDataRef)createSendData:(NSString *)text {
    if ([text length] == 0) {
        return NULL;
    }

    char data [MAX_SENDBUF_SIZE];
	[text getCString:data maxLength:MAX_SENDBUF_SIZE encoding:NSUTF8StringEncoding];
	return CFDataCreate(NULL, (const UInt8*)data, MIN(MAX_SENDBUF_SIZE,[text lengthOfBytesUsingEncoding:NSUTF8StringEncoding]));
}

- (BOOL)readyToTransmit {
    if (! (socket != NULL && srvAddr != NULL)) {
        [self setStatusMessage:@"no valid configuration"];
        return NO;
    }
    [self setStatusMessage:@""];
    return YES;
}

- (BOOL)isReachable
{
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

@end
