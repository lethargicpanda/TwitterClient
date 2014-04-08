//
//  AppDelegate.h
//  TwitterClient
//
//  Created by Thomas Ezan on 3/27/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "MenuViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) UINavigationController *navigationViewController;
@property (strong, nonatomic) MenuViewController *menuViewController;
@property (strong, nonatomic) UIViewController *containerViewController;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (assign, nonatomic) BOOL isMenuOpen;

@end
