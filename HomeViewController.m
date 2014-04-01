//
//  HomeViewController.m
//  TwitterClient
//
//  Created by Thomas Ezan on 3/29/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "HomeViewController.h"
#import "TwitterClient.h"
#import "TweetViewCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "TweetViewController.h"
#import "EditViewController.h"
#import "User.h"


@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;
@property (strong, nonatomic) NSMutableArray *tweetArray;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self timeline];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Init the Tweet tableView
    self.tweetTableView.dataSource = self;
    self.tweetTableView.delegate = self;
    
    
    // Init custom UITableCell
    UINib *nib = [UINib nibWithNibName:@"TweetViewCell" bundle:nil];
    [self.tweetTableView registerNib:nib forCellReuseIdentifier:@"TweetViewCell"];
    
    
    // Init pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.refreshControl addTarget:self action:@selector(timeline) forControlEvents:UIControlEventValueChanged];
    [self.tweetTableView addSubview:self.refreshControl];
    

    // Add Tweet button
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(showEditView)];
    self.navigationItem.rightBarButtonItem = tweetButton;
    
    
    // Add Logout button
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    
    
    [User initCurrentUser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Get the font for the Restaurant name label
    UIFont *tweetLabelFont = [UIFont systemFontOfSize:12.0];
    
    Tweet *currentTweet = self.tweetArray[indexPath.row];

    
    // Compute the size of the label
    CGRect rectForTweet = [currentTweet.text boundingRectWithSize:CGSizeMake(213, CGFLOAT_MAX)
                                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                                    attributes:@{NSFontAttributeName:tweetLabelFont}
                                                                       context:nil];
    return 56 + rectForTweet.size.height + 10;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweetArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Get cell
    TweetViewCell *cell = [self.tweetTableView dequeueReusableCellWithIdentifier:@"TweetViewCell" forIndexPath:indexPath];

    
    Tweet *currentTweet = self.tweetArray[indexPath.row];
    
    [cell.profilePicture setImageWithURL:[NSURL URLWithString:currentTweet.profilePictureUrl] placeholderImage:[UIImage imageNamed:@"profilePlaceHolder"]];
    cell.nameLabel.text = currentTweet.user.name;
    cell.displayNameLabel.text = currentTweet.user.screenName;
    cell.dateLabel.text = [currentTweet formattedDate];
    cell.textLabel.text = currentTweet.text;
    
    if (currentTweet.retweeter.screenName == nil){
        cell.retweeter.hidden = YES;
    } else {
        cell.retweeter.text = [[NSString alloc] initWithFormat:@"retweeting @%@", currentTweet.retweeter.screenName];
        cell.retweeter.hidden = NO;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetViewController *tweetView = [[TweetViewController alloc] initWithNibName:@"TweetViewController" bundle:nil];
    
    tweetView.tweet = self.tweetArray[indexPath.row];
    [self.navigationController pushViewController:tweetView animated:YES];
}


#pragma - Network communication
-(void)timeline{
    NSLog(@"fetch timeline");
    self.tweetArray = [[NSMutableArray alloc] init];
    
    [User initCurrentUser];
    
    
    [[TwitterClient instance] GET:@"1.1/statuses/home_timeline.json" parameters:@{@"count": @"30", @"include_my_retweet": @YES} success:^(AFHTTPRequestOperation *operation, id responseObject){
        

        for (NSDictionary *tweet in responseObject) {
            Tweet *currTweet = [Tweet createFromDictionary:tweet];
            [self.tweetArray addObject:currTweet];
        }
        
        [self.refreshControl endRefreshing];
        [self.tweetTableView reloadData];
        NSLog(@"%d", self.tweetArray.count);
        
    }failure:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"error: %@", responseObject);
        [self.refreshControl endRefreshing];
    }];
}

-(void)showEditView{
    NSLog(@"ShowEditView");
    
    EditViewController *editViewController = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
    editViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editViewController];

    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    
}

-(void)logout{
    [[TwitterClient instance] logout];
}


#pragma - EditTweet Delegate
- (void) addTweetOnTop:(Tweet *)tweet
{
    NSLog(@"Add tweet on top");
    [self.tweetArray insertObject:tweet atIndex:0];
    [self.tweetTableView reloadData];
}

@end
