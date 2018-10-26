#ifndef ROUTE_MAKER_H
#define ROUTE_MAKER_H

#include <string>

#include "route_builder.h"

namespace encashment
{
class RouteMaker
{
public:  
    RouteMaker(const std::shared_ptr<RouteBuilder>& rb): _routeBuilder(rb) {}

    void makeRoute(const std::string& inputFileName, const std::string& outputFileName);
private:
    void _loadJsonData(const std::string& fileName);
    void _buildRoute(void);
    void _writeJsonRoute(const std::string& fileName);
    void _reportError(const std::string&& errorMessage);
private:
    std::shared_ptr<RouteBuilder> _routeBuilder;
    std::vector<AtmData> _atmData;
    Point _startPoint;
};
}
#endif // ROUTE_MAKER_H
