//
//  SendUdpViewController.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 25.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import "SendUdpViewController.h"
#import "ConfigurationViewController.h"
#import "UdpTransmitter.h"
#import "ReachabilityChecker.h"

#import <SystemConfiguration/SystemConfiguration.h>

@interface SendUdpViewController ()
@property (nonatomic, retain) UdpTransmitter *udpTransmitter;
@property (nonatomic, retain) ReachabilityChecker *reachabilityChecker;
@end

@implementation SendUdpViewController 

NSString* const segueToConfigurationView = @"configure";

#pragma mark -
#pragma mark communication
- (void)configUdpTransmitter {
    [self setUdpTransmitter: [[UdpTransmitter alloc] initWithIp:[[self configuration] ipAddress] port:[[self configuration] port]]];
}

#pragma mark -
#pragma mark Key-Value-Observer

- (void)registerObserver {
    [[self configuration] addObserver:self forKeyPath:@"ipAddress" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    [[self configuration] addObserver:self forKeyPath:@"port" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:ReachabilityCheckerChangedNotification object: nil];
}

- (void)deregisterObserver {
    [[self configuration] removeObserver:self forKeyPath:@"port"];
    [[self configuration] removeObserver:self forKeyPath:@"ipAddress"];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [self configuration]) {
        if ([[self configuration]isValid]) {
            [self configUdpTransmitter];
            [self updateView];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)reachabilityChanged:(NSNotification* )note {
	[self updateView];
}

#pragma mark -
#pragma mark managing the view

- (void)viewDidLoad {
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    [self registerObserver];

    [self initConfigButton];

    [self setReachabilityChecker:[[ReachabilityChecker alloc] init]];

    [self configUdpTransmitter];

    [self updateView];
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

    [self setReachabilityChecker:nil];
    [self setUdpTransmitter:nil];

    [self setConfigButton:nil];
    [self setTextField:nil];
    [self setSendButton:nil];
    [self setStatusLabel:nil];
    [self setNetworkStatusLabel:nil];
    
    [super viewDidUnload];
}

- (void)updateView {
    if ([[self configuration] isValid]) {
        [[self udpTransmitter] readyToTransmit]; // also update the statusMessage

        [self setStatusMessage:[[self udpTransmitter] statusMessage] withColor:[UIColor blackColor]];
        [[self sendButton] setEnabled:[[self reachabilityChecker] isReachable] && [[self udpTransmitter] readyToTransmit]];
    } else {
        [self setStatusMessage:@"Please enter a valid receiver configuration." withColor:[UIColor blackColor]];
        [[self sendButton] setEnabled:FALSE];
    }

    [[self networkStatusLabel] setText:[[self reachabilityChecker] isReachable] ? @"" : @"no network connection available"];
}

- (void)setSuccessMessage:(NSString *)message {
    NSString *msg = [NSString stringWithFormat:@"%@ - %@", [self timeStamp], message];
    [self setStatusMessage:msg withColor:[UIColor blackColor]];
}

- (void)setErrorMessage:(NSString *)message {
    NSString *msg = [NSString stringWithFormat:@"%@ - %@", [self timeStamp], message];
    [self setStatusMessage:msg withColor:[UIColor redColor]];
}

- (NSString *)timeStamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];

    return [formatter stringFromDate:[NSDate date]];
}

- (void)setStatusMessage:(NSString *)message withColor:(UIColor *)color {
    [[self statusLabel] setText:message];
    [[self statusLabel] setTextColor:color];
}

#pragma mark -
#pragma mark event processing

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:segueToConfigurationView]) {
        [[self view] endEditing:YES];

        ConfigurationViewController *configViewController = [segue destinationViewController];
        configViewController.configuration = [self configuration];
    }
}

- (IBAction)sendText:(id)sender {
    [[self view] endEditing:YES];

    BOOL success = [[self udpTransmitter] transmit:[[self textField] text]];
    NSString *msg = [[self udpTransmitter] statusMessage];
    if (success) {
        [self setSuccessMessage:msg];
    } else {
        [self setErrorMessage:msg];
    }
}
@end
