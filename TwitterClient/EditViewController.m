//
//  EditViewController.m
//  TwitterClient
//
//  Created by Thomas Ezan on 3/30/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "EditViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"


@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextView *editText;

@end

@implementation EditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Add cancel button
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(hideEditView)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    // Add Tweet button
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(sendTweet)];
    self.navigationItem.leftBarButtonItem = tweetButton;
    
    // Display
    self.userName.text = [User currentUser].name;
    self.screenName.text = [User currentUser].screenName;
    [self.profileImage setImageWithURL:[NSURL URLWithString:[User currentUser].profileUrl] placeholderImage:[UIImage imageNamed:@"profilePlaceHolder"]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void) hideEditView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendTweet{
    [[TwitterClient instance] POST:@"1.1/statuses/update.json"
    parameters:@{@"status": self.editText.text }
                           success:^(AFHTTPRequestOperation *operation, id responseObject){
                               NSLog(@"Tweet sent with success");
                               [self hideEditView];
                           }failure:^(AFHTTPRequestOperation *operation, id responseObject){
                               NSLog(@"failure sending tweet:%@", responseObject);
     }];
    
    
    Tweet *newTweet  = [[Tweet alloc] init];
    newTweet.text = self.editText.text;
    newTweet.user = [User currentUser];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    newTweet.creationDate = [dateFormatter stringFromDate:[NSDate date]];
    
    
    if (self.delegate!=nil) {
        [self.delegate addTweetOnTop:newTweet];
    }

}

@end
