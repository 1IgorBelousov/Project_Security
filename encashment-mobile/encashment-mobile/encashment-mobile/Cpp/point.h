#ifndef POINT_H
#define POINT_H

#include <vector>

namespace encashment
{
// custom Point class
class Point
{
public:
    Point(void): _x(0.0), _y(0.0) {}
    Point(double x, double y): _x(x), _y(y) {}
    
    inline double x(void) const { return _x; }
    inline double y(void) const { return _y; }
    
    inline void setX(double x) { _x = x; }
    inline void setY(double y) { _y = y; }
private:
    double _x;
    double _y;
};
    
// type alias for vector of points
using Points = std::vector<Point>;

} // namespace encashment

#endif // POINT_H
