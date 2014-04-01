//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Thomas Ezan on 3/27/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "TwitterClient.h"
#import "User.h"


#define TWITTER_API_STRING @"https://api.twitter.com/"
#define TWITTER_CONSUMER_KEY @"cjzQ29tJiNAm1gf6JTIpTA"
#define TWITTER_CONSUMER_SECRET @"JznLMoW3itxqWGDJYBF2t82OrTno9I79v6zHhCQBF0"
#define THOMAS_EZAN_URL_SCHEME @"thomasezan-twitter-client"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@implementation TwitterClient


+(TwitterClient *)instance{
    static TwitterClient *instance = nil;
    static dispatch_once_t pred;
    
    dispatch_once (&pred, ^ {
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:TWITTER_API_STRING] consumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
    });

    
    return instance;
}


-(void)authorize{
    
    [self deauthorize];
    
    [self fetchRequestTokenWithPath:@"/oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@", THOMAS_EZAN_URL_SCHEME, @"://request"]] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got request token!! %@", requestToken);
        
        // Open Web view to login with twitter and retrieve the oauth_token
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
        
        
    } failure:^(NSError *error) {
        NSLog(@"failure: %@", [error description]);
    }];

}





-(BOOL)comebackFromTwitterAuthWithUrl:(NSURL *)url{
    
    if ([url.scheme isEqualToString:THOMAS_EZAN_URL_SCHEME]){
    
        [self fetchAccessTokenWithPath:@"/oauth/access_token"
        method:@"POST"
        requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
        success:^(BDBOAuthToken *accessToken) {
            NSLog(@"access token %@", accessToken.description);
            [User initCurrentUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
        }
        failure:^(NSError *error) {
            NSLog(@"failure: %@", error.description);
        }];
            
        return YES;
    } else {
        return NO; // TODO
    }
}

-(BOOL)isClientAuthorized{
    return [self isAuthorized];
}


-(void)logout{
    [self deauthorize];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}


@end
