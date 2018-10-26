#ifndef GREEDY_ROUTE_BUILDER_H
#define GREEDY_ROUTE_BUILDER_H

#include "route_builder.h"

namespace encashment
{

// Class using greedy algorithm to build route.
class GreedyRouteBuilder : public RouteBuilder
{
public:
    GreedyRouteBuilder(void);

    virtual std::vector<AtmData> buildRoute(const std::vector<AtmData>& sourceData, const Point& startPoint);
private:
    // calculates distance between two points
    double _calcPointsDistance(const Point& p1, const Point& p2);
};

} // namespace encashment
#endif // GREEDY_ROUTE_BUILDER_H
