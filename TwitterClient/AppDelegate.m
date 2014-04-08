//
//  AppDelegate.m
//  TwitterClient
//
//  Created by Thomas Ezan on 3/27/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "TwitterClient.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Init login view controller
    [self initViewControllers];

    
    // Init NSNotification center
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(displayAppropriateViewController)
												 name:UserDidLoginNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(displayAppropriateViewController)
												 name:UserDidLogoutNotification object:nil];
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSLog(@"Application openUrl %@|%@", url, sourceApplication);
    
    return [[TwitterClient instance] comebackFromTwitterAuthWithUrl:url];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)displayAppropriateViewController{
    [self initViewControllers];

}


#pragma - 
- (void)didPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer{
    double xTrans = [panGestureRecognizer translationInView:self.window].x;
    NSLog(@"Translation: %f", xTrans);
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
    
        CGRect frame = self.homeViewController.view.frame;
    
        if (!self.isMenuOpen && xTrans > 100 ) {
            frame.origin.x = [[UIScreen mainScreen] bounds].size.width - 60;
            self.isMenuOpen = YES;
        } else if(xTrans < -100) {
            frame.origin.x = 0.0;
            self.isMenuOpen = NO;
        }
    
        [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:1.3 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		self.homeViewController.view.frame = frame;
        } completion:nil];
    }
}


- (void)didSwipeGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer{
//    double xTrans = [swipeGestureRecognizer  translationInView:self.window].x;
//    NSLog(@"Translation: %f", xTrans);
    
    if (swipeGestureRecognizer.state == UIGestureRecognizerStateEnded) {

        CGRect frame = self.homeViewController.view.frame;
        
        NSLog(@"Direction %d", swipeGestureRecognizer.direction);
        
        if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
            frame.origin.x = [[UIScreen mainScreen] bounds].size.width - 60;
            self.isMenuOpen = YES;
        } else if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
            frame.origin.x = 0.0;
            self.isMenuOpen = NO;
        }
        
        [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:1.3 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.homeViewController.view.frame = frame;
        } completion:nil];
    
        }
    
    
    
}


-(void)initViewControllers{
    // Init login view controller
    if([[TwitterClient instance] isClientAuthorized]){
        
        self.homeViewController = [[HomeViewController alloc]init];
        self.menuViewController = [[MenuViewController alloc] init];
        
        self.navigationViewController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
        self.containerViewController = [[UIViewController alloc] init];
        [self.containerViewController.view addSubview:self.menuViewController.view];
        [self.containerViewController.view addSubview:self.navigationViewController.view];
        
        self.isMenuOpen = NO;
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanGesture:)];
//        self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeGesture:)];
//        self.swipe    GestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;

        [self.containerViewController.view addGestureRecognizer:self.panGestureRecognizer];
        
        self.window.rootViewController = self.containerViewController;
        
        
    } else {
        LoginViewController *vc = [[LoginViewController alloc]init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nvc;
        
    }
}


@end
