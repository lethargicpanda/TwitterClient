//
//  MenuViewController.m
//  TwitterClient
//
//  Created by Thomas Ezan on 4/7/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "MenuViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"


@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(userDidInit)
												 name:UserDidInit object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)userDidInit{
    NSLog(@"%@ - %@", [User currentUser].name, [User currentUser].screenName);
    
    // Display
    self.userLabel.text = [[NSString alloc] initWithFormat:@"%@", [User currentUser].name];
    self.screenNameLabel.text = [[NSString alloc] initWithFormat:@"%@", [User currentUser].screenName];
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:[User currentUser].profileUrl] placeholderImage:[UIImage imageNamed:@"profilePlaceHolder"]];
}
- (IBAction)onTouchTimeline:(id)sender {
    // Send notification for HomeViewController
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidTapTimeline object:nil];
}

- (IBAction)onTouchMention:(id)sender {
    // Send notification for HomeViewController
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidTapMention object:nil];
}

- (IBAction)onTouchProfile:(id)sender {
    // Open Web view with user profile page
    NSString *authURL = [NSString stringWithFormat:@"https://twitter.com/%@", [User currentUser].screenName];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
}





@end
