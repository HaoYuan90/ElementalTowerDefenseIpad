//
//  FBConnector.h
//  FacebookSDKdoozTest
//
//  Created by Leon Qiao on 19/3/12.
//  Copyright (c) 2012 dooZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface FBConnector : NSObject <FBSessionDelegate, FBRequestDelegate>
@property (nonatomic, strong) Facebook* facebook;
@property (nonatomic, strong) NSString* userId;

+ (FBConnector *)sharedFaceBookConnector;
- (BOOL) login;


@end
