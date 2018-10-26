#ifndef CASH_LEVEL_PROVIDER_H
#define CASH_LEVEL_PROVIDER_H

#include <string>
#include <vector>

namespace encashment
{
// Interface for classes providing cash levels info.
class CashLevelsProvider
{
public:
    virtual const std::vector<float>& getCashLevels(void) = 0;
};

} // encashment
#endif // CASH_LEVEL_PROVIDER_H
