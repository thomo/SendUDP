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
@property (nonatomic, retain) Configuration *configuration;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIWebView *statusField;

- (IBAction)sendText:(id)sender;

@end
