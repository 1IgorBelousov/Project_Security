#ifndef RANDOM_CASH_LEVEL_PROVIDER_H
#define RANDOM_CASH_LEVEL_PROVIDER_H

#include "cash_level_provider.h"

namespace encashment
{

// Provides cash levels based on uniform distribution
class RandomCashLevelsProvider: public CashLevelsProvider
{
public:
    RandomCashLevelsProvider(const std::vector<std::string>& atmAddresses);

    virtual const std::vector<float>& getCashLevels(void);
private:
    void _makeCashLevels();
private:
    std::vector<float> _cashLevels; 
};
}
#endif // RANDOM_CASH_LEVEL_PROVIDER_H
