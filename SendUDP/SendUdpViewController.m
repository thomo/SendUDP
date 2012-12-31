//
//  SendUdpViewController.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 25.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import "SendUdpViewController.h"
#import "ConfigurationViewController.h"

@interface SendUdpViewController ()
@end

@implementation SendUdpViewController

NSString* const segueToConfigurationView = @"configure";

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
    [self setConfigButton:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:segueToConfigurationView]) {
        ConfigurationViewController *configViewController = [segue destinationViewController];
        
        configViewController.configuration = [self configuration];
    }
}

@end
