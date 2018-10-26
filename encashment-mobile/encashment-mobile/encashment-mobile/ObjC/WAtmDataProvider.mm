#import "WAtmDataProvider.h"

#import <CoreLocation/CoreLocation.h>

#include <string>

#include "file_addresses_provider.h"
#include "random_cash_level_provider.h"

// Coordinates wrapper implementation
@implementation WCoord

@synthesize x, y;

-(id)initWithX:(double)x withY:(double)y
{
    self = [super init];
    
    self.x = x;
    self.y = y;
    
    return self;
}

@end

// Atm data wrapper implementation
@implementation WAtmData

@synthesize address, cashLevel, coords;

-(id)initWithAddress:(NSString *)address withCashLevel:(double)cashLevel withCoords:(WCoord*)coords
{
    self = [[WAtmData alloc] init];
    
    self.address = address;
    self.cashLevel = cashLevel;
    self.coords = coords;
    
    return self;
}

@end

// private WAtmDataProvider interface
@interface WAtmDataProvider()
{
    std::string _sourceFileName; // resource file with ATMs addresses
}

@property (strong, nonatomic) NSMutableArray<WAtmData*>* _atmData;

-(void)_initAtmData;
-(void)_setDataFileFullPath:(NSString*)fileName;
@end

// Wrapped ATM data provider implementation
@implementation WAtmDataProvider

@synthesize _atmData;

-(id)initWithDataFile:(NSString *)fileName
{
    self = [super init];
    
    [self _setDataFileFullPath:fileName];
    [self _initAtmData];
    return self;
}

-(void)setDataFile:(NSString *)fileName
{
    [self _setDataFileFullPath:fileName];
}

-(NSArray<WAtmData*>*)getAtmData
{
    return [_atmData copy];
}

-(void)_setDataFileFullPath:(NSString *)fileName
{
    // get path to app root dir
    NSString* appDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
    // convert to cpp string
    std::string cppAppDir = [appDir cStringUsingEncoding:NSUTF8StringEncoding];
    
    // append source file name to path
    _sourceFileName = [fileName cStringUsingEncoding:NSUTF8StringEncoding];
    _sourceFileName = cppAppDir + "/" + _sourceFileName;
}

-(void)_initAtmData
{
    // obtain atm data from cpp objects
    
    // get addresses
    std::shared_ptr<encashment::AddressesProvider> ap = std::make_shared<encashment::FileAddressesProvider>(_sourceFileName);
    const std::vector<std::string> addresses = ap->getAddresses();
    
    // get cash levels
    std::shared_ptr<encashment::RandomCashLevelsProvider> clp = std::make_shared<encashment::RandomCashLevelsProvider>(addresses);
    const std::vector<float> cashLevels = clp->getCashLevels();
    
    // need this block to deal with memory allocations and releases
    @autoreleasepool
    {
        _atmData = [NSMutableArray arrayWithCapacity:addresses.size()];
        
        for (uint32_t i = 0; i < addresses.size(); i++)
        {
            // one geocoder for one request
            CLGeocoder *geocoder = [[CLGeocoder alloc] init]; // CLGeocoder* geocoder = new CLGeocoder;
            // convert to obj-c string
            NSString* objcAddr = [[NSString alloc] initWithCString:addresses[i].c_str() encoding:NSUTF8StringEncoding];
            
            // async geocoding
            // ATM addresses geocoded to latitude:longitude pairs here
            [geocoder geocodeAddressString: objcAddr
                         completionHandler:^(NSArray* placemarks, NSError* error)
                        {
                             if (placemarks && placemarks.count > 0)
                             {
                                 // add obj-c record with geocoded data
                                 CLPlacemark *topResult = [placemarks objectAtIndex:0];
                                 [self->_atmData addObject:[[WAtmData alloc] initWithAddress:objcAddr withCashLevel:cashLevels[i] withCoords:[[WCoord alloc] initWithX:topResult.location.coordinate.latitude withY:topResult.location.coordinate.longitude]]];
                             }
                             else
                             {
                                 // some error occurred, do nothing
                             }
                         }
             ];
        }
    }
}

@end
