#include "route_maker.h"

#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/json_parser.hpp>
#include <boost/foreach.hpp>
#include <iostream>
#include <fstream>
#include <algorithm>

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
using std::string;

const string JSON_FILE_READING_ERROR = "Couldn't parse JSON-file ";
const string JSON_FILE_PARSING_ERROR = "Wrong JSON file format - unexpected key found: ";

void RouteMaker::makeRoute(const std::string& inputFileName, const std::string& outputFileName)
{
    _loadJsonData(inputFileName);
    _buildRoute();
    _writeJsonRoute(outputFileName);
}

void RouteMaker::_loadJsonData(const std::string& fileName)
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
        _reportError(err.message());
    }

    if (!isTreeParsed)
    {
        _reportError(JSON_FILE_READING_ERROR + fileName);
        return;
    }

    for (auto rootIt = jsonTree.begin(); rootIt != jsonTree.end(); rootIt++)
    {
        if (rootIt->first == ATMS_KEY)
        {
            ptree atmsRoot = rootIt->second;
            AtmData atm;
            for (auto atmsIterator = atmsRoot.begin(); atmsIterator != atmsRoot.end(); atmsIterator++)
            {
                for (auto atmIterator = atmsIterator->second.begin(); atmIterator != atmsIterator->second.end(); atmIterator++)
                {
                    if (atmIterator->first == ATM_ADDRESS_KEY)
                    {
                        atm.address = atmIterator->second.data();
                    }
                    else if (atmIterator->first == ATM_CASH_LEVEL_KEY)
                    {
                        atm.cashLevel = atmIterator->second.get_value<float>();
                    }
                    else if (atmIterator->first == ATM_COORDS)
                    {
                        atm.coords.setX(atmIterator->second.get<double>(COORDS_X));
                        atm.coords.setY(atmIterator->second.get<double>(COORDS_Y));
                    }
                    else
                    {
                        _reportError(JSON_FILE_PARSING_ERROR + atmIterator->first);
                    }
                }
            }
        }
        else if (rootIt->first == POSITION_KEY)
        {
            _startPoint = Point(rootIt->second.get<double>(COORDS_X), rootIt->second.get<double>(COORDS_Y));
        }
        else
        {
            _reportError(JSON_FILE_PARSING_ERROR + rootIt->first);
        }
    }
}

void RouteMaker::_buildRoute(void)
{
    _atmData = _routeBuilder->buildRoute(_atmData, _startPoint);
}

void RouteMaker::_writeJsonRoute(const std::string& fileName)
{
    ptree root;
    ptree atmsRoot;

    for (size_t i = 0; i < _atmData.size(); i++)
    {
        ptree atmNode;
        atmNode.put(ATM_ADDRESS_KEY, _atmData[i].address);
        atmNode.put(ATM_CASH_LEVEL_KEY, _atmData[i].cashLevel);
        ptree atmCoordsNode;
        atmCoordsNode.put(COORDS_X, _atmData[i].coords.x());
        atmCoordsNode.put(COORDS_Y, _atmData[i].coords.y());
        atmNode.push_back(std::make_pair(ATM_COORDS, atmCoordsNode));
        atmsRoot.push_back(std::make_pair("", atmNode));
    }

    root.add_child(ATMS_KEY, atmsRoot);
    ptree positionRoot;
    positionRoot.put(COORDS_X, _startPoint.x());
    positionRoot.put(COORDS_Y, _startPoint.y());
    root.push_back(std::make_pair(POSITION_KEY, positionRoot));
    ofstream output(fileName);
    write_json(output, root);
}


void RouteMaker::_reportError(const std::string&& errorMessage)
{
    cout << endl << errorMessage;
}
}
