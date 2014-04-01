//
//  Tweet.m
//  TwitterClient
//
//  Created by Thomas Ezan on 3/29/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "Tweet.h"
#import "TwitterClient.h"
#import "User.h"

@implementation Tweet


+(Tweet*)createFromDictionary:(NSDictionary *)data{
    Tweet *resTweet = [[Tweet alloc]init];
    resTweet.text = data[@"text"];
    resTweet.user = [data[@"user"] objectForKey:@"screen_name"];

    
    
    NSDictionary *retweet = data[@"retweeted_status"];
    
    if (retweet) {
        resTweet.retweeter = [User initWithData:retweet[@"user"]];
        resTweet.user = [User initWithData:data[@"user"]];
        resTweet.text = retweet[@"text"];
        resTweet.creationDate = retweet[@"created_at"];
    } else {
        resTweet.user = [User initWithData:data[@"user"]];
        resTweet.text = data[@"text"];
        resTweet.creationDate = data[@"created_at"];
    }
    
    
    resTweet.profilePictureUrl = resTweet.user.profileUrl;
    resTweet.favCount = [data[@"favorite_count"] integerValue];
    resTweet.isFavorite = [data[@"favorited"] boolValue];
    
    resTweet.retweetCount = [data[@"retweet_count"] integerValue];
    resTweet.isRetweeted = [data[@"retweeted"] boolValue];
    
    resTweet.tweetId = data[@"id_str"];
     
    return resTweet;
}

-(NSString *)formattedDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *date = [dateFormatter dateFromString:self.creationDate];
    
    NSDictionary *timeScale = @{@"sec":@1,
                                @"min":@60,
                                @"h":@3600,
                                @"d":@86400,
                                @"week":@605800,
                                @"month":@2629743,
                                @"year":@31556926};
    NSString *scale;
    int timeAgo = 0-(int)[date timeIntervalSinceNow];
    if (timeAgo < 60) {
        scale = @"sec";
    } else if (timeAgo < 3600) {
        scale = @"min";
    } else if (timeAgo < 86400) {
        scale = @"h";
    } else if (timeAgo < 605800) {
        scale = @"d";
    } else if (timeAgo < 2629743) {
        scale = @"week";
    } else if (timeAgo < 31556926) {
        scale = @"month";
    } else {
        scale = @"year";
    }
    
    timeAgo = timeAgo/[[timeScale objectForKey:scale] integerValue];
    NSString *s = @"";
    return [NSString stringWithFormat:@"%d%@%@", timeAgo, scale, s];
}

@end
