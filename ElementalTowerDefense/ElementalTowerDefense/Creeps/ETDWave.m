#import "ETDWave.h"

@implementation ETDWave 

@synthesize genRate;
@synthesize bufferTime;
@synthesize creeps;
@synthesize totalCreeps;
@synthesize nextCreep;

- (id)initWithCreep:(NSArray *)arrayCreeps genRate:(int)rate{
    // EFFECTS: constructs ETDWave with array of creeps and generating rate.
    
    self = [super init];
    if (self == nil){
        NSLog(@"malloc error");
        return nil;
    }
    creeps = arrayCreeps;
    genRate = rate;
    bufferTime = genRate;
    nextCreep = 0;
    return self;
}

- (BOOL)hasCreep {
    // EFFECTS: returns true if there are creeps to generate.
    
    if (nextCreep < creeps.count) {
        return YES;
    }
    return NO;
}

- (void)updateStatus {
    // EFFECTS: updates the time to generate creeps.
    
    bufferTime--;
}

- (BOOL)isAvailableToGen {
    // EFFECTS: returns true if there is avaialble creep to be generated.
    
    if ([self hasCreep] && bufferTime <=0) {
        return YES;
    }
    return NO;
}

- (ETDCreep *)genCreep {
    // REQUIRES: there is a creep to generate.
    // EFFECTS: return the creep and reset the bufere time if the buffer time is smaller or 
    //  equal to 0. Otherwise, return false.
    
    if ([self isAvailableToGen]) {
        nextCreep++;
        bufferTime = genRate;
        return [creeps objectAtIndex:(nextCreep - 1)];
        ;
    }
    return nil;
}

#pragma mark - Methods related to loading

+ (ETDWave *)loadCreepWaveFromDictionary:(NSDictionary *)dic withDelegate:(id<ETDCreepDelegate>)del {
    // EFFECTS: loads a single creepwave from a dictioanry.
    
    int genRate = [[dic valueForKey:genRateTag] intValue];
    NSMutableArray *creeps = [NSMutableArray array];
    NSDictionary *creepInfos = [dic valueForKey:creepInfoTag];
    NSArray *sequence = [dic valueForKey:creepSequenceTag];
    for (NSNumber *num in sequence) {
        NSString* key = [num stringValue];
        ETDCreep *temp = [[ETDCreep alloc] initFromDictionary:[creepInfos valueForKey:key] WithDelegate:del];
        [creeps addObject: temp];
    }
    return [[ETDWave alloc] initWithCreep:creeps genRate:genRate];
}

+ (NSArray *)loadCreepWavesFromFile:(NSString *)fileName withDelegate:(id<ETDCreepDelegate>)del {
    // EFFECTS: loads creepwaves for an entire level from info stored in a file
    
    //load data from file
    NSString *bundle = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]; 
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:bundle];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSDictionary *wavesInfo = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!wavesInfo) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        return nil;
    }
    
    int waveCount = [[wavesInfo objectForKey:waveCountTag] intValue];
    NSMutableArray* waves = [NSMutableArray array];
    for (int i = 1; i <= waveCount; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [waves addObject:[ETDWave loadCreepWaveFromDictionary:[wavesInfo objectForKey:key] withDelegate:del]];
    }
	
    return [NSArray arrayWithArray:waves];
}

#pragma mark - Social Mode Loading

+(NSArray *)loadCustomCreepWaveFromFile:(NSString *)creepInfoFileName withSequence:(NSArray *)seq 
                          withDelegate:(id<ETDCreepDelegate>)del {
    // EFFECTS: loads custom created creep wave for social mode
    //          and return the generated creep wave
    
    //load creep info from file
    NSString *bundle = [[NSBundle mainBundle] pathForResource:creepInfoFileName ofType:@"plist"]; 
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:bundle];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSDictionary *wavesInfo = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!wavesInfo) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        return nil;
    }
    
    NSMutableArray *creeps = [NSMutableArray array];
    int lastWave = [[wavesInfo valueForKey:waveCountTag] intValue];
    NSString *key = [NSString stringWithFormat:@"%d",lastWave];
    NSDictionary *waveInfo = [wavesInfo valueForKey:key];
    int genRate = [[waveInfo valueForKey:genRateTag] intValue];
    NSDictionary *creepInfos = [waveInfo valueForKey:creepInfoTag];
	
    //create creep wave using loaded creep info and customized sequence
    for (NSNumber *num in seq) {
        NSString* key = [num stringValue];
        ETDCreep *temp = [[ETDCreep alloc] initFromDictionary:[creepInfos valueForKey:key] WithDelegate:del];
        [creeps addObject: temp];
    }
    
    ETDWave* customWave = [[ETDWave alloc] initWithCreep:creeps genRate:genRate];
    return [NSArray arrayWithObject:customWave];
}

/*
 + (ETDWave*)loadCreepWaveFromDictionary:(NSDictionary*)dic withSequence:(NSArray*)seq withDelegate:(id<ETDCreepDelegate>)del
 {
 int genRate = [[dic valueForKey:genRateTag] intValue];
 NSMutableArray *creeps = [NSMutableArray array];
 NSDictionary *creepInfos = [dic valueForKey:creepInfoTag];
 // DO SOMETHING ABOUT SEQUENCE
 //!!!!!!!!!!!!!!!!
 
 // NSArray *sequence = [dic valueForKey:creepSequenceTag];
 for (NSNumber *num in seq){
 NSString* key = [num stringValue];
 ETDCreep *temp = [[ETDCreep alloc] initFromDictionary:[creepInfos valueForKey:key] WithDelegate:del];
 [creeps addObject: temp];
 }
 return [[ETDWave alloc] initWithCreep:creeps genRate:genRate];
 }*/

/*
 + (NSArray*)loadCreepWavesFromFile:(NSString*)fileName withSequence:(NSArray*)seq withDelegate:(id<ETDCreepDelegate>)del
 {
 //load data from file
 NSString *bundle = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]; 
 NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:bundle];
 NSString *errorDesc = nil;
 NSPropertyListFormat format;
 NSDictionary *wavesInfo = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
 if (!wavesInfo)
 NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
 
 //    int waveCount = [[wavesInfo objectForKey:waveCountTag] intValue];
 NSMutableArray* waves = [NSMutableArray array];
 
 //    for (int i = 1; i<=waveCount; i++)
 //    {
 NSString *key = [NSString stringWithFormat:@"%d",1];
 [waves addObject:[ETDWave loadCreepWaveFromDictionary:[wavesInfo objectForKey:key] withSequence:seq withDelegate:del]];
 //    }
 
 return [NSArray arrayWithArray:waves];
 }
 */

@end
