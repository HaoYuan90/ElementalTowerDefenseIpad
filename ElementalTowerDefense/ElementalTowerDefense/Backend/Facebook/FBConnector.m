//
//  FBConnector.m
//  FacebookSDKdoozTest
//
//  Created by Leon Qiao on 19/3/12.
//  Copyright (c) 2012 dooZ. All rights reserved.
//

#import "FBConnector.h"

@implementation FBConnector 
@synthesize facebook;
@synthesize userId;


- (id)init 
{
    
    if (self = [super init])
    {      
        facebook = [[Facebook alloc] initWithAppId:@"247043705386756" andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) 
        {
            facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
   
    }
    return self;
}

- (BOOL)login {
    
    //EFFECT: if session is valid --> get friends id
    //        if session is invalid --> login
    //        after which, fbDidLogin will send notification, then-->get friends id
    if (![self.facebook isSessionValid]) {
        [self.facebook authorize:[[NSArray alloc] initWithObjects:@"offline_access", nil]];
        return FALSE;
    } else {
        //request
        return TRUE;
    }
}

- (void) fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidLogout" object:self];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void) fbDidNotLogin:(BOOL)cancelled{
    if (cancelled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FBLoginCancelled" object:self];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FBLoginFailed" object:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidNotLogin" object:self];
}

- (void) fbSessionInvalidated{
    
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

-(void)fbDidLogin{
    [self storeAuthData: [self.facebook accessToken] expiresAt:[self.facebook expirationDate]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidLogin" object:self];
    // retrieve userId after authentication
    [self.facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    // When we ask for user infor this will happen.
    if ([result isKindOfClass:[NSDictionary class]]){
        //NSDictionary *hash = result;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[result objectForKey:@"id"] forKey:@"userId"];
        [defaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivedUserId" object:self];

    }
}


#pragma mark - Singleton

+ (FBConnector *)sharedFaceBookConnector
{
    static FBConnector *controller = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] init];
    });
    
    return controller;   
}


@end
