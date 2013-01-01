//
//  SendUdpViewController.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 25.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import "SendUdpViewController.h"
#import "ConfigurationViewController.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>


@interface SendUdpViewController ()
@end

@implementation SendUdpViewController {
	CFDataRef srvAddr;
    CFSocketRef socket;
}

NSString* const segueToConfigurationView = @"configure";

#define MAX_SENDBUF_SIZE 220

#pragma mark -
#pragma mark communication
- (void)setupSocketAndSrvAddr {
    [self releaseSocketAndSrvAddr];
    
    socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_DGRAM, IPPROTO_UDP, 0, NULL, NULL);
    
    struct sockaddr_in addr;
	memset(&addr, 0, sizeof(addr));
	addr.sin_len = sizeof(addr);
	addr.sin_family = AF_INET;
	addr.sin_port = htons([[[self configuration] port] intValue]);
	addr.sin_addr.s_addr = inet_addr([[[self configuration] ipAddress] UTF8String]);
	srvAddr = addr.sin_addr.s_addr != INADDR_NONE ? CFDataCreate(NULL, (const UInt8*)&addr, sizeof(addr)) : NULL;
}

- (void)releaseSocketAndSrvAddr {
    if (socket) CFRelease(socket);
	if (srvAddr) CFRelease(srvAddr);
}

#pragma mark -
#pragma mark Key-Value-Observer

- (void)registerObserver {
    [[self configuration] addObserver:self forKeyPath:@"ipAddress" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    [[self configuration] addObserver:self forKeyPath:@"port" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}

- (void)deregisterObserver {
    [[self configuration] removeObserver:self forKeyPath:@"port"];
    [[self configuration] removeObserver:self forKeyPath:@"ipAddress"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [self configuration]) {
        NSLog(@"configuration has changed");
        [self setupSocketAndSrvAddr];
        [self updateStatus];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

}

#pragma mark -
#pragma mark managing the view

- (void)viewDidLoad {
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    [self initConfigButton];
    [self registerObserver];

    [self setupSocketAndSrvAddr];

    [self updateStatus];
}

- (void)initConfigButton {
	self.configButton.title = @"\u2699";
	UIFont *font = [UIFont fontWithName:@"Helvetica" size:24.0];
	NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:font, UITextAttributeFont, nil];
	[self.configButton setTitleTextAttributes:dict forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self deregisterObserver];

    [self releaseSocketAndSrvAddr];

    [self setConfigButton:nil];
    [self setTextField:nil];
    [self setStatusField:nil];
    [self setSendButton:nil];
    [super viewDidUnload];
}

- (void)updateStatus {
    [[self sendButton] setEnabled:[self enableSendButton]];
}

- (BOOL)enableSendButton {
    return socket != NULL && srvAddr != NULL;
}

- (void)addSuccessMessage:(NSString *)message {

}

- (void)addErrorMessage:(NSString *)message {

}

#pragma mark -
#pragma mark event processing

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:segueToConfigurationView]) {
        ConfigurationViewController *configViewController = [segue destinationViewController];
        
        configViewController.configuration = [self configuration];
    }
}

- (CFDataRef)newSendData:(NSString *)text {
    char data [MAX_SENDBUF_SIZE];
	[text getCString:data maxLength:MAX_SENDBUF_SIZE encoding:NSUTF8StringEncoding];
	return CFDataCreate(NULL, (const UInt8*)data, [text lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
}

- (IBAction)sendText:(id)sender {
	CFDataRef dataRef = [self newSendData:[[self textField] text]];
    if (dataRef != NULL) {
        if (CFSocketSendData(socket, srvAddr, dataRef, 0) == 0) {
            [self addSuccessMessage: [NSString stringWithFormat:@"SEND: bytes=%li, ip=%@, port=%@", CFDataGetLength(dataRef), [[self configuration] ipAddress], [[self configuration] port]]];
        } else {
            NSLog(@"did not send, error=%s",strerror(errno));
            [self addErrorMessage: [NSString stringWithFormat:@"ERROR: %s", strerror(errno)]];
        }

        CFRelease(dataRef);
    } else {
        [self addErrorMessage: @""];
    }
}
@end
