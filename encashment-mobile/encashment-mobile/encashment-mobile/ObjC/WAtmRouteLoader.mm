#import "WAtmRouteLoader.h"

#include "file_addresses_provider.h"
#include "random_cash_level_provider.h"
#include "greedy_route_builder.h"

// Wrapped ATM route loader private interface
@interface WAtmRouteLoader()
{
    // no private members
}

@property (strong, nonatomic) WAtmDataProvider* _provider; // access to ATM data

@end

// Wrapped ATM route loader implementation
@implementation WAtmRouteLoader

@synthesize _provider;

-(id)initWithDataProvider:(WAtmDataProvider *)provider
{
    self = [super init];
    
    _provider = provider;
    
    return self;
}

-(NSArray<WAtmData*>*)getAtmRouteForPoint:(WCoord*)startPoint;
{
    @autoreleasepool
    {
        // get initial points from provider
        NSArray<WAtmData*>* atms = [_provider getAtmData];
        
        // convert to cpp-representation
        std::vector<encashment::AtmData> cppAtms;
        cppAtms.reserve(atms.count);
        // remove this part to avoid excessive output
        const std::string commonPath = "Ростовская область, Таганрог ";
        for (uint32_t i = 0; i < atms.count; i++)
        {
            std::string cppAddr = [atms[i].address cStringUsingEncoding:NSUTF8StringEncoding];
            
            cppAddr.erase(cppAddr.begin(), cppAddr.begin() + commonPath.length());
            encashment::Point cppPoint = encashment::Point {atms[i].coords.x, atms[i].coords.y};
            cppAtms.push_back(encashment::AtmData{cppAddr, cppPoint, static_cast<float>(atms[i].cashLevel)});
        }
        
        // make route
        encashment::GreedyRouteBuilder rb;
        std::vector<encashment::AtmData> result = rb.buildRoute(cppAtms, encashment::Point{startPoint.x, startPoint.y});
        
        // convert to obj-c representation
        NSMutableArray<WAtmData*>* objcResult = [NSMutableArray arrayWithCapacity:result.size()];
        
        // for each cpp object create obj-c one
        for (uint32_t i = 0; i < result.size(); i++)
        {
            objcResult[i] = [[WAtmData alloc] initWithAddress:[[NSString alloc] initWithUTF8String:result[i].address.c_str()] withCashLevel:result[i].cashLevel withCoords:[[WCoord alloc] initWithX:result[i].coords.x() withY:result[i].coords.y()]];
        }
        
        return [objcResult copy];
    }
}

@end
