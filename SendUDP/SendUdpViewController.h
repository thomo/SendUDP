//
//  SendUdpViewController.h
//  SendUDP
//
//  Created by Thomas Mohaupt on 25.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configuration.h"

@interface SendUdpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *configButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *networkStatusLabel;

@property (nonatomic, retain) Configuration *configuration;

- (IBAction)sendText:(id)sender;

@end
