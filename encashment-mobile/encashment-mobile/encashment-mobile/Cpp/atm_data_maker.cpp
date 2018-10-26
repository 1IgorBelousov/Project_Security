#include "atm_data_maker.h"

#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/json_parser.hpp>
#include <boost/foreach.hpp>
#include <iostream>
#include <fstream>
#include <cstdint>

#include "route_data_keys.h"

namespace encashment
{
using boost::property_tree::ptree;
using boost::property_tree::json_parser_error;
using boost::property_tree::read_json;
using boost::property_tree::write_json;
using std::cout;
using std::endl;
using std::ofstream;
using std::vector;
using std::string;


AtmDataMaker::AtmDataMaker(const std::shared_ptr<AddressesProvider>& ap, const std::shared_ptr<CashLevelsProvider>& cp)
{
    vector<string> addresses = ap->getAddresses();
    if (addresses.size() != cp->getCashLevels().size())
        throw std::runtime_error("Providers are incorrect!"); // exception

    _addressesProvider = ap;
    _cashLevelsProvider = cp;
}

void AtmDataMaker::createAtmData(const std::string& fileName)
{
    ptree root;
    ptree atmsRoot;

    vector<string> addresses = _addressesProvider->getAddresses();
    vector<float> cashLevels = _cashLevelsProvider->getCashLevels();

    for (size_t i = 0; i < addresses.size(); i++)
    {
        ptree atmNode;
        atmNode.put(ATM_ADDRESS_KEY, addresses[i]);
        atmNode.put(ATM_CASH_LEVEL_KEY, cashLevels[i]);
        atmsRoot.push_back(std::make_pair("", atmNode));
    }

    root.add_child(ATMS_KEY, atmsRoot);
    ofstream output(fileName);
    write_json(output, root);
}

/*
namespace encashment
{
    void readJsonPoints(const string& fileName, Points& points)
    {
        ptree jsonTree;

        bool isTreeParsed = false;
        try
        {
            read_json(fileName, jsonTree);
            isTreeParsed = true;
        }
        catch (const json_parser_error& err)
        {
            cout << err.message() << endl;
        }

        if (!isTreeParsed)
        {
            cout << "Error in reading json file " << fileName << endl;
            return;
        }

        for (auto rootIt = jsonTree.begin(); rootIt != jsonTree.end(); rootIt++)
        {
            if (rootIt->first == POINTS_KEY)
            {
                ptree pointsRoot = rootIt->second;
                for (auto it = pointsRoot.begin(); it != pointsRoot.end(); it++)
                {
                    auto itemIterator = it->second.begin();
                    while (itemIterator->first != P_COORDS_KEY)
                    {
                        itemIterator++;
                    }
                    // extract point
                    points.push_back(Point(itemIterator->second.get<double>(COORDS_X_KEY), itemIterator->second.get<double>(COORDS_Y_KEY)));
                }
            }
            else if (rootIt->first == POSITION_KEY)
            {
                points.insert(points.begin(), Point(rootIt->second.get<double>(COORDS_X_KEY), rootIt->second.get<double>(COORDS_Y_KEY)));
            }
            else
            {
                cout << "Wrong JSON file format - unexpected key found!" << endl;
            }
        }
    }

    void writeJsonPoints(const string& fileName, const Points& points)
    {
        ptree root;
        ptree pointsRoot;
        for (int i = 0; i < points.size(); i++)
        {
            ptree pointNode;
            pointNode.put(COORDS_X_KEY, points[i].x);
            pointNode.put(COORDS_Y_KEY, points[i].y);
            pointsRoot.push_back(std::make_pair("",pointNode));
        }

        root.add_child(POINTS_KEY, pointsRoot);
        ofstream output(fileName);
        write_json(output, root);
    }
}
 */
}
