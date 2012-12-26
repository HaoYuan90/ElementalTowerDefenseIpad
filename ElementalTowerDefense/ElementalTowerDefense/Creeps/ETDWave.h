#import <Foundation/Foundation.h>
#import "ETDCreep.h"

@interface ETDWave : NSObject 

@property (nonatomic, readonly) int genRate;
@property (nonatomic, readonly) int bufferTime; // the remain time before generating next creep

@property (nonatomic, strong) NSArray *creeps;
@property (nonatomic, readonly) int totalCreeps;
@property (nonatomic, readonly) int nextCreep;

- (id)initWithCreep:(NSArray *)creeps genRate:(int)rate;
// EFFECTS: constructs ETDWave with array of creeps and generating rate.

- (BOOL)hasCreep;
// EFFECTS: returns true if there are creeps to generate.

- (void)updateStatus;
// EFFECTS: updates the time to generate creeps.

- (BOOL)isAvailableToGen;
// EFFECTS: returns true if there is avaialble creep to be generated.

- (ETDCreep *)genCreep;
// REQUIRES: there is a creep to generate.
// EFFECTS: returns the creep and reset the buffer time if the buffer time is smaller or 
//  equal to 0. Otherwise, return false.

+ (ETDWave *)loadCreepWaveFromDictionary:(NSDictionary *)dic withDelegate:(id<ETDCreepDelegate>)del;
// EFFECTS: loads a single creepwave from a dictioanry;

+ (NSArray *)loadCreepWavesFromFile:(NSString *)fileName withDelegate:(id<ETDCreepDelegate>)del;
// EFFECTS: loads creepwaves for an entire level from info stored in a file

// -----------------social mode----------------------
/*
 + (ETDWave*)loadCreepWaveFromDictionary:(NSDictionary*)dic withSequence:(NSArray*)seq withDelegate:(id<ETDCreepDelegate>)del;
 // EFFECTS: load a single creepwave from a dictioanry with "customised sequence"
 + (NSArray*)loadCreepWavesFromFile:(NSString*)fileName withSequence:(NSArray*)seq withDelegate:(id<ETDCreepDelegate>)del;
 // EFFECTS: load creepwaves for an entire level from info stored in a file with "customised sequence"*/

+ (NSArray *)loadCustomCreepWaveFromFile:(NSString *)creepInfoFileName withSequence:(NSArray *)seq 
						   withDelegate:(id<ETDCreepDelegate>)del;
// EFFECTS: loads custom created creep wave for social mode

@end
