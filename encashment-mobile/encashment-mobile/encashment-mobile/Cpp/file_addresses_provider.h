#ifndef FILE_ADDRESSES_PROVIDER_H
#define FILE_ADDRESSES_PROVIDER_H

#include "addresses_provider.h"

#include <string>
#include <vector>

namespace encashment
{

// Access atms data via file.
class FileAddressesProvider: public AddressesProvider
{
public:
    FileAddressesProvider(const std::string& fileName): _fileName(fileName) {}

    virtual const std::vector<std::string>& getAddresses(void);
private:
    void _loadAddresses(void);
private:
    std::string _fileName;
    std::vector<std::string> _addresses;
};

} // namespace encashment
#endif // FILE_ADDRESSES_PROVIDER_H
