//
//  BNFriendDetailTableViewCell.m
//  BirthdayNotification
//
//  Created by Liu Weilong on 24/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "BNFriendDetailTableViewCell.h"
#import "BNUtilities.h"
#import "UIImageView+WebCache.h"

@implementation BNFriendDetailTableViewCell

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
}

- (void)setupWithFriendDetail:(FriendInfo *)info colorHex:(NSString *)colorHex{
    self.nameTitle.text = info.name;
    NSString *string = [BNUtilities formatDateToString:info.birthday withDateFormat:@"MM-dd"];
    self.birthdayTitle.text = string;
    
    //Load avatar
    NSString *avatarURL = [(NSDictionary *)[(NSArray *)info.avatar objectAtIndex:2] objectForKey:@"url"];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:avatarURL]];
    
    self.backgroundColor = [BNUtilities colorWithHexString:colorHex];
}

- (void)layoutSubviews {
    self.nameTitle.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:23.0];
    self.birthdayTitle.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0];
    self.nameTitle.textColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.birthdayTitle.textColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.avatarView.layer.cornerRadius = self.avatarView.frame.size.width/2.0;
    self.avatarView.clipsToBounds = YES;
    self.avatarView.layer.borderWidth = 1.5f;
    self.avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
}
@end
