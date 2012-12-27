//
//  EditableTableViewCell.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 26.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import "EditableTableViewCell.h"

@implementation EditableTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
