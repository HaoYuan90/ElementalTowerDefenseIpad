//
//  UserDataFetcher.h
//  GameTest
//
//  Created by Leon Qiao on 11/3/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//
//  Over View
//  This class is used to fetch map data of other users, or synch map data of current user on a RESTful backend-server.
//  Use GET to fetch map data
//  Use Post to synch(create or update) map data


#import <Foundation/Foundation.h>
#define USER_ID @"user_id"
#define STAGE @"stage"
#define WAVE @"wave"
#define TOWERS @"towers"

@interface UserDataFetcher : NSObject

+ (NSDictionary*) fetchMapWithUserId: (NSString*)userId;
+ (BOOL) putMapWithUserId:(NSString*)userId 
                    stage:(NSString*)st
                     wave:(NSString*)wa
                   towers: (NSArray*)t;


@end

