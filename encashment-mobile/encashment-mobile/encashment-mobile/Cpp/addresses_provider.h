#ifndef ADDRESSES_PROVIDER_H
#define ADDRESSES_PROVIDER_H

#include <vector>
#include <string>

namespace encashment
{
// Interface for classes providing addresses info.
class AddressesProvider
{
public:
    AddressesProvider(void) {}
    virtual const std::vector<std::string>& getAddresses(void) = 0;
};

} // namespace encashment
#endif // ADDRESSES_PROVIDER_H
