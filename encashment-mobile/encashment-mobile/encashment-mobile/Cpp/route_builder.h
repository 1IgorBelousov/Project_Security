#ifndef ROUTE_BUILDER_H
#define ROUTE_BUILDER_H

#include <vector>
#include <string>
#include "point.h"

namespace encashment
{
// Keeps data about single ATM
struct AtmData
{
    std::string address; // street address
    Point coords;        // coords
    float cashLevel;     // cash level rate (from 0 to 1)
    
    AtmData(const std::string& addr, Point c, float cl): address(addr), coords(c), cashLevel(cl) {}
    AtmData(): address(""), coords(Point{0,0}), cashLevel(0) {}
};

// Interface for route builder.
class RouteBuilder
{
public:
    // builds route using specified ATMs data and start point
    virtual std::vector<AtmData> buildRoute(const std::vector<AtmData>& sourceData, const Point& startPoint) = 0;
};

} // namespace encashment
#endif // ROUTE_BUILDER_H
