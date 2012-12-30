//
//  ConfigurationViewController.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 25.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "IpAddressValidator.h"

@interface ConfigurationViewController ()
@end

@implementation ConfigurationViewController

static NSString *EditableCellIdentifier = @"EditableCellIdentifier";

#define EDITABLECELLTAG_TITLE      10
#define EDITABLECELLTAG_TEXTFIELD  20

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setIpAddress:nil];
    [self setPort:nil];
    [self setConfiguration:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSString *ipAddress = [self.ipAddress.textField text];
    IpAddressValidator *ipValidator = [IpAddressValidator alloc];
    if ([ipValidator isValid:ipAddress]) {
        [self.configuration setIpAddress:ipAddress];
    }
    NSString *port = [self.port.textField text];
    [self.configuration setPort:port];
    [super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (EditableTableViewCell *)configureCell:(EditableTableViewCell *)cell withTitle:(NSString *)title text:(NSString *)text andPlaceholder:(NSString *)placeholder {
    cell.title = (UILabel *)[cell viewWithTag:EDITABLECELLTAG_TITLE];
    cell.textField = (UITextField *)[cell viewWithTag:EDITABLECELLTAG_TEXTFIELD];
    cell.title.text = title;
    cell.textField.text = text;
    cell.textField.placeholder = placeholder;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditableTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:EditableCellIdentifier];
    
    if (indexPath.row == 0) {
        self.ipAddress = [self configureCell:cell withTitle:@"IP Address" text:[self.configuration ipAddress] andPlaceholder:@"0.0.0.0"];
    } else {
        self.port = [self configureCell:cell withTitle:@"Port" text:[self.configuration port] andPlaceholder:@"0"];;
    }
    
    return cell;
}

@end
