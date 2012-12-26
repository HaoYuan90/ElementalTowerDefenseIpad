#import <Foundation/Foundation.h>

@interface ETDResistanceManager : NSObject

@property (nonatomic, readonly, strong) NSDictionary* resistance;

- (id)initWithDictionary:(NSDictionary *)res;
// EFFECTS: constructs ETDResistanceManager with the dictionary.

- (float)resistanceFor:(ElementalType)type;
// EFFECTS: returns the resistance for the elemental type.
@end
