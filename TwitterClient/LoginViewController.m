//
//  LoginViewController.m
//  TwitterClient
//
//  Created by Thomas Ezan on 3/27/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickLoginWithTwitter:(id)sender {
    NSLog(@"Did click login with Twitter");
    
    [[TwitterClient instance] authorize];
}


@end
