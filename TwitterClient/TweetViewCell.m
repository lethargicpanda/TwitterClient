//
//  TweetViewCell.m
//  TwitterClient
//
//  Created by Thomas Ezan on 3/29/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "TweetViewCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetViewCell

@synthesize profilePicture = _profilePicture;
@synthesize nameLabel = _nameLabel;
@synthesize displayNameLabel = _displayNameLabel;
@synthesize dateLabel = _dateLabel;
@synthesize textLabel = _textLabel;
@synthesize retweeter = _retweeter;



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
