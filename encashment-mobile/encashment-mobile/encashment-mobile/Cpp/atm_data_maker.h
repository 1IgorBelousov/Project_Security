#ifndef ATM_DATA_MAKER_H
#define ATM_DATA_MAKER_H

#include <string>

#include "addresses_provider.h"
#include "cash_level_provider.h"

namespace encashment
{
class AtmDataMaker
{
public:
    AtmDataMaker(const std::shared_ptr<AddressesProvider>& ap, const std::shared_ptr<CashLevelsProvider>& cp);

    void createAtmData(const std::string& fileName);
private:
    std::shared_ptr<AddressesProvider> _addressesProvider;
    std::shared_ptr<CashLevelsProvider> _cashLevelsProvider;
};
}
#endif // ATMDATAMAKER_H
