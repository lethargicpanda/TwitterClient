    //
//  User.m
//  TwitterClient
//
//  Created by Thomas Ezan on 3/30/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

@implementation User

static User *currentUser;

+(User *)initWithData:(NSDictionary *)data{
	User *resUser = [[User alloc] init];
    
    resUser.description = data[@"description"];
	resUser.userId = [data[@"id"] integerValue];
	resUser.name = data[@"name"];
	resUser.screenName = data[@"screen_name"];
	resUser.profileUrl = data[@"profile_image_url"];
    
    return resUser;
}

+ (User *)initCurrentUser{
    static User *user;
    
    if (!user.userId) {
        [[TwitterClient instance] GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"init user");
            NSLog(@"Init user:%@", responseObject);
            currentUser = [User  userWithData:responseObject];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UserDidInit object:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"failed to get user: %@", error.localizedDescription);
        }];
    }
    
    return user;
}

+(User *)currentUser{
    return currentUser;
}

+(User *)userWithData:(NSDictionary *)data{
    NSLog(@"Init user:%@", data);
    
    User *resUser = [[User alloc]init];
    
    [resUser setUserId:(int)data[@"id"]];
    [resUser setProfileUrl:data[@"profile_image_url"]];
    [resUser setScreenName:[NSString stringWithFormat:@"@%@", data[@"screen_name"]]];
    [resUser setName:data[@"name"]];
    
    return resUser;
}


@end
