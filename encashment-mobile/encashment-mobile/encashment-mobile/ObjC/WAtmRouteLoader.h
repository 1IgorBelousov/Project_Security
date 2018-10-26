#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "WAtmDataProvider.h"

// Wrapper around atm route loader.
@interface WAtmRouteLoader: NSObject

-(id)initWithDataProvider:(WAtmDataProvider*)provider;

-(NSArray<WAtmData*>*)getAtmRouteForPoint:(WCoord*)startPoint;

@end
