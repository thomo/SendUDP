//
//  SendUdpViewController.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 25.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import "SendUdpViewController.h"
#import "ConfigurationViewController.h"
#import "Configuration.h"

@interface SendUdpViewController ()
@property (nonatomic, retain) Configuration *configuration;
@end

@implementation SendUdpViewController

NSString *segueToConfigurationView = @"configure";

-(Configuration *) configuration
{
    if (! _configuration)
    {
        [self setConfiguration:[Configuration alloc]];
    }
    return _configuration;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    [self initConfigButton];
}

- (void)initConfigButton
{
	self.configButton.title = @"\u2699";
	UIFont *font = [UIFont fontWithName:@"Helvetica" size:24.0];
	NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:font, UITextAttributeFont, nil];
	[self.configButton setTitleTextAttributes:dict forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
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
