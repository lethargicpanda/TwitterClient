//
//  TimelineViewController.m
//  TwitterClient
//
//  Created by Thomas Ezan on 3/29/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "TimelineViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"

@interface TimelineViewController ()

@end

@implementation TimelineViewController

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
	self.navigationController.title = @"Home";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)timeline{
    NSLog(@"fetch timeline");
    
    NSMutableArray *currArray = [[NSMutableArray init] alloc];
    
    [[TwitterClient instance] GET:@"1.1/statuses/home_timeline.json" parameters:@{@"count": @"30", @"include_my_retweet": @YES} success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"success: %@", responseObject);
        
        for (NSDictionary *tweet in responseObject) {
            Tweet *currTweet = [Tweet createFromDictionary:tweet];
            [currArray addObject:currTweet];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"error: %@", responseObject);
    }];
}

@end
