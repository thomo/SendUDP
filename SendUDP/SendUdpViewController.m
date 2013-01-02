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

@interface SendUdpViewController ()
@property (nonatomic, retain) UdpTransmitter *udpTransmitter;
@end

@implementation SendUdpViewController 

NSString* const segueToConfigurationView = @"configure";

#pragma mark -
#pragma mark communication
- (void)configUdpTransmitter {
    if ([[self configuration] isValid]) {
        [self setUdpTransmitter: [[UdpTransmitter alloc] initWithIp:[[self configuration] ipAddress] port:[[self configuration] port]]];
    }
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
        [self configUdpTransmitter];
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
    [self registerObserver];

    [self initConfigButton];

    [self configUdpTransmitter];
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

    [self setUdpTransmitter:nil];
    [self setConfigButton:nil];
    [self setTextField:nil];
    [self setSendButton:nil];
    [self setStatusLabel:nil];
    [super viewDidUnload];
}

- (void)updateStatus {
    if ([[self configuration] isValid]) {
        if ([self udpTransmitter] && [[self udpTransmitter] readyToTransmit]) {
            [[self sendButton] setEnabled:true];
            [self setStatusMessage:@"" withColor:[UIColor blackColor]];
        } else {
            [self setStatusMessage:@"Please check network setup and receiver configuration." withColor:[UIColor blackColor]];
        }
    } else {
        [[self sendButton] setEnabled:false];
        [self setStatusMessage:@"Please enter a valid receiver configuration." withColor:[UIColor blackColor]];
    }
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
        ConfigurationViewController *configViewController = [segue destinationViewController];
        
        configViewController.configuration = [self configuration];
    }
}

- (IBAction)sendText:(id)sender {
    BOOL success = [[self udpTransmitter] transmit:[[self textField] text]];
    NSString *msg = [[self udpTransmitter] statusMessage];
    if (success) {
        [self setSuccessMessage:msg];
    } else {
        [self setErrorMessage:msg];
    }
}
@end
