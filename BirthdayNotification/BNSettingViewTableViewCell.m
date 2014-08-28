//
//  BNSettingViewTableViewCell.m
//  BirthdayNotification
//
//  Created by Liu Weilong on 28/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "BNSettingViewTableViewCell.h"

@implementation BNSettingViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureForIndex:(NSIndexPath *)index login:(BOOL)login{
    switch (index.row) {
        case 0:
            if (login) {
                self.backgroundColor = [BNUtilities colorWithHexString:@"95a5a6"];
                self.textLabel.text = @"解除人人链接";
            }
            else {
                self.backgroundColor = [BNUtilities colorWithHexString:@"16a085"];
                self.textLabel.text = @"链接到人人";
            }
            break;
            
        case 1:
            self.textLabel.text = @"同步人人数据";
            self.backgroundColor = [BNUtilities colorWithHexString:@"27ae60"];
            break;
            
        default:
            break;
    }
}

@end
