#include "greedy_route_builder.h"

#include <cmath>

namespace encashment
{

GreedyRouteBuilder::GreedyRouteBuilder()
{
}

std::vector<AtmData> GreedyRouteBuilder::buildRoute(const std::vector<AtmData>& sourceData, const Point& startPoint)
{
    // make a copy of input vector
    std::vector<AtmData> result{ sourceData };
    Point currentPoint = startPoint;

    // then sort it suppose route starts from 0-th point
    // each next point should be the closest to the previous one
    // calc distance for all points, remember min and set it after current point
    for (size_t i = 0; i < result.size(); i++)
    {
        // search from current points
        double min = _calcPointsDistance(currentPoint, result[i].coords);
        size_t minIndex = i;
        
        // check all other points to find closest of them
        for (size_t j = i + 1; j < result.size(); j++)
        {
            double currentDistance = _calcPointsDistance(currentPoint, result[j].coords);
            if (currentDistance < min)
            {
                min = currentDistance;
                minIndex = j;
            }
        }

        // set min item right after current point if necessary
        if (minIndex != i)
            std::swap(result[i], result[minIndex]);

        currentPoint = result[i].coords;
    }

    return result;
}

double GreedyRouteBuilder::_calcPointsDistance(const Point& p1, const Point& p2)
{
    // implements sqrt((x2 - x1)ˆ2 + (y2 - y1)ˆ2)
    return std::sqrt(std::pow(p2.x() - p1.x(), 2) + std::pow(p2.y() - p1.y(), 2));
}
    
} // namespace encashment
