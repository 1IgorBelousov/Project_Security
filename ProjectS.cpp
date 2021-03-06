// ProjectS.cpp : Defines the entry point for the console application.
//
#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using std::string;
using std::vector;
using std::ifstream;
struct Point
{
	int x;
	int y;
};

vector<Point> readPointsFromFile(const string& filename)
{
	ifstream inputFile(filename);

	int recordsCount = 0;
	inputFile >> recordsCount;

	vector<Point> points;
	points.resize(recordsCount);

	for (int i = 0; i < recordsCount; i++)
	{
		inputFile >> points[i].x >> points[i].y;
	}

	inputFile.close();

	return points;
}

int main()
{
	vector<Point> points = readPointsFromFile("input.bin");
    return 0;
}

