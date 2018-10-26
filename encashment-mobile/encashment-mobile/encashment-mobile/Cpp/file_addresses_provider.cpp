#include "file_addresses_provider.h"

#include <iostream>
#include <fstream>
#include <set>

namespace encashment
{

const std::vector<std::string>& FileAddressesProvider::getAddresses(void)
{
    // load addresses if necessary
    if (_addresses.size() == 0)
    {
        _loadAddresses();
    }
    return _addresses;
}

void FileAddressesProvider::_loadAddresses() // exception
{
    std::ifstream inputFile(_fileName);

    if (inputFile.bad() || !inputFile.is_open())
        throw std::runtime_error("Can't open data file for reading!"); // exception

    // use set to obtain unique addresses only
    std::set<std::string> addresses;
    std::string currentAddress;
    // read file line by line
    while(std::getline(inputFile, currentAddress))
    {
        addresses.insert(currentAddress);
    };

    _addresses = std::vector<std::string>(addresses.begin(), addresses.end());
}

} // namespace encashment
