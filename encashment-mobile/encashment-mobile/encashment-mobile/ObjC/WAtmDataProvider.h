#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/// Coordinate data type wrapper.
@interface WCoord: NSObject

@property double x;
@property double y;

-(id)initWithX:(double)x withY:(double)y;

@end

// ATM data type wrapper
@interface WAtmData: NSObject

@property (strong, nonatomic) NSString* address; // exact string address
@property double cashLevel;                      // ATM's cash level rate (from 0 to 1)
@property (strong, nonatomic) WCoord* coords;    // coordinates

-(id)initWithAddress:(NSString*)address withCashLevel:(double)cashLevel withCoords:(WCoord*)coords;

@end

/// Wrapper for atm data provider.
@interface WAtmDataProvider: NSObject

-(id)initWithDataFile:(NSString*)fileName;

-(void)setDataFile:(NSString*)fileName;

-(NSArray<WAtmData*>*)getAtmData;

@end
