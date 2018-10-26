#include "random_cash_level_provider.h"

#include <random>

namespace encashment
{

RandomCashLevelsProvider::RandomCashLevelsProvider(const std::vector<std::string>& atmAddresses)
{
    // resize and fill cashes
    _cashLevels.resize(atmAddresses.size());
    _makeCashLevels();
}

const std::vector<float>& RandomCashLevelsProvider::getCashLevels(void)
{
    // make cashes if necessary
    if (_cashLevels.size() == 0)
    {
        _makeCashLevels();
    }
    return _cashLevels;
}

void RandomCashLevelsProvider::_makeCashLevels()
{
    // random generator initialization
    std::random_device rd;  //Will be used to obtain a seed for the random number engine
    std::mt19937 gen(rd()); //Standard mersenne_twister_engine seeded with rd()
    std::uniform_real_distribution<> dis(0.0, 1.0);

    for (size_t i = 0; i < _cashLevels.size(); i++)
    {
        _cashLevels[i] = dis(gen);
    }
}

} // namespace encashment
