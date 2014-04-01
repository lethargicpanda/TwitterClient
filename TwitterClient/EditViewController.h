//
//  EditViewController.h
//  TwitterClient
//
//  Created by Thomas Ezan on 3/30/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol EditTweetDelegate <NSObject>

- (void) addTweetOnTop:(Tweet *)tweet;

@end

@interface EditViewController : UIViewController

@property (nonatomic, strong) id <EditTweetDelegate> delegate;

@end
