//
//  UserDataFetcher.m
//  GameTest
//
//  Created by Leon Qiao on 11/3/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import "UserDataFetcher.h"
#import "SBJson.h"
#import "JSON.h"

@implementation UserDataFetcher

+ (NSDictionary*) fetchMapWithUserId: (NSString*)userId{
    //REQUIRE: a valid user_id
    //EFFECT: create and return a dictionary corresponding to the input user_id
    // with keys USER_ID, STAGE, WAVE, TOWERS
    // while the object matching TOWERS is a 2-d array for tower data. eg. [[1,2,3],[1,1,1]]
    
    
    NSString *strURL = [NSString stringWithFormat:@"http://ec2-50-17-97-233.compute-1.amazonaws.com/backend/index.php/map/%@?key=rEsTlEr2",userId];
    
    // to execute php code
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSError *error = nil;
   
    // Json ---> foundation object (NSDictionary)
    NSDictionary *results = dataURL ? [NSJSONSerialization JSONObjectWithData:dataURL options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
//      NSLog(@"!!!%@???", [results JSONRepresentation]);
    // NSLog(@"!!!%@!!!", [[[results objectForKey:TOWERS] objectAtIndex:0] objectAtIndex:1]);
    
    return results;
}


+ (BOOL) putMapWithUserId:(NSString*)userId 
                    stage:(NSString*)st
                     wave:(NSString*)wa
                   towers: (NSArray*)t{
    //REQUIRE: the towers array should be a 2-d array, with child being arrays containing 3 integers
    //EFFECT: if user_id already exist in the db, update the record. otherwise create a new record
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] 
                                    initWithURL:[NSURL 
                                                 URLWithString:@"http://ec2-50-17-97-233.compute-1.amazonaws.com/backend/index.php/map?key=rEsTlEr2"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/json" 
    forHTTPHeaderField:@"Content-type"];
    NSDictionary *requestData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 userId, USER_ID,
                                 st, STAGE,
                                 wa, WAVE,
                                 t, TOWERS,
                                 nil];

   NSString* jsonString = [requestData JSONRepresentation];
//	NSString *jsonString = @""; // LINE REPLACED
    /*
    NSString* towerString = @"[";
    for (int i = 0; i < [t count]; i++) {
        towerString = [towerString stringByAppendingFormat:
                             @"[%d,%d,%d]", [[t objectAtIndex:i] objectAtIndex:0], [[t objectAtIndex:i] objectAtIndex:0],[[t objectAtIndex:i] objectAtIndex:0]];
        if(i!=[t count]-1)
            towerString = [towerString stringByAppendingFormat:
                           @","];
        else
            towerString = [towerString stringByAppendingFormat:
                           @"]"];
    }
    */
   
    
    [request setValue:[NSString stringWithFormat:@"%d",
                       [jsonString length]] 
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[jsonString 
                          dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",jsonString);
    if([[NSURLConnection alloc] 
     initWithRequest:request 
     delegate:self])
        return TRUE;
    else 
        return FALSE;
}






@end
