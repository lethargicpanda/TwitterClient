//
//  TwitterClient.h
//  TwitterClient
//
//  Created by Thomas Ezan on 3/27/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;
extern NSString * const UserDidInit;
extern NSString * const UserDidTapTimeline;
extern NSString * const UserDidTapMention;

@interface TwitterClient : BDBOAuth1RequestOperationManager


+(TwitterClient *)instance;

-(void)authorize;
-(BOOL)comebackFromTwitterAuthWithUrl:(NSURL *)url;
-(BOOL)isClientAuthorized;
-(void)logout;

@end
