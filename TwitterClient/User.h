//
//  User.h
//  TwitterClient
//
//  Created by Thomas Ezan on 3/30/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *description;
@property int userId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *profileUrl;
@property (strong, nonatomic) NSString *screenName;


+(User *)initWithData:(NSDictionary *)data;
+(User *)currentUser;
+ (User *)initCurrentUser;


@end
