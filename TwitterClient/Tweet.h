//
//  Tweet.h
//  TwitterClient
//
//  Created by Thomas Ezan on 3/29/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, retain) NSString *tweetId;
@property (nonatomic, retain) NSString *text;
@property (strong, nonatomic) User *retweeter;
@property (strong, nonatomic) User *user;
@property (nonatomic, assign) BOOL isRetweet;
@property (nonatomic, retain) NSString *profilePictureUrl;
@property (nonatomic, retain) NSString *creationDate;
@property (nonatomic, assign) int favCount;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) int retweetCount;
@property (nonatomic, assign) BOOL isRetweeted;

+(Tweet*)createFromDictionary:(NSDictionary *)data;
-(NSString *)formattedDate;

@end
