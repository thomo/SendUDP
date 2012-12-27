//
//  EditableTableViewCell.h
//  SendUDP
//
//  Created by Thomas Mohaupt on 26.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditableTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
