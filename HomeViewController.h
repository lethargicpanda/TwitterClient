//
//  HomeViewController.h
//  TwitterClient
//
//  Created by Thomas Ezan on 3/29/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"

@interface HomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, EditTweetDelegate, UIGestureRecognizerDelegate>


@end
