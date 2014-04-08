//
//  TweetViewController.m
//  TwitterClient
//
//  Created by Thomas Ezan on 3/30/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "TweetViewController.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface TweetViewController ()

@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTweet:(Tweet *)tweet{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tweet = tweet;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.tweet.profilePictureUrl] placeholderImage:[UIImage imageNamed:@"profilePlaceHolder"]];
    
    [self.profileImage setUserInteractionEnabled:YES];
    [self.profileImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImage)]];
    
    
    if (self.tweet.retweeter.screenName == nil){
        self.retweetLabel.hidden = YES;
    } else {
        self.retweetLabel.text = [[NSString alloc] initWithFormat:@"retweet @%@", self.tweet.retweeter.screenName];
    }
    

    self.nameLabel.text = self.tweet.user.name;
    self.screenName.text = [[NSString alloc] initWithFormat:@"@%@", self.tweet.user.screenName ];
    self.textLabel.text = self.tweet.text;
    self.dateLabel.text = [self.tweet formattedDate];
    self.retweetCountLabel.text = [@(self.tweet.retweetCount) stringValue];
    self.favoriteCountLabel.text = [@(self.tweet.favCount) stringValue];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)didClickRetweetButton:(id)sender {
    [self retweet];
}

- (IBAction)didClickFavoriteButton:(id)sender {
    [self addFavorite];
}




- (void)retweet{
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", self.tweet.tweetId];
    [[TwitterClient instance] POST:url
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSLog(@"retweeted!!");
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"retweet error: %@", error.localizedDescription);
                     }];
}

- (void)addFavorite{
    [[TwitterClient instance] POST:@"1.1/favorites/create.json"
                            parameters:@{@"id": self.tweet.tweetId}
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               NSLog(@"Added to favorites!!");
                           }
                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               NSLog(@"error adding to favorites: %@", error.localizedDescription);
                           }];
}

-(void)didTapImage  {
    // Open Web view with user profile page
    NSString *authURL = [NSString stringWithFormat:@"https://twitter.com/%@", self.tweet.user.screenName];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
}

@end
