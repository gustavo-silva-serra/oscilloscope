#include "FileDataReader.h"

#include <QPointF>

#include <fstream>
#include <iostream>
#include <filesystem>

using namespace std;

QList<QPointF> FileDataReader::read(double& minY, double& maxY, double& maxX)
{
    QList<QPointF> data;
    std::string str;
    double counter = 0; // number of reads

    minY = std::numeric_limits<double>::infinity();
    maxY = std::numeric_limits<double>::lowest();

    std::ifstream in("signal.txt");
    if (!in)
    {
        throw new std::runtime_error("File not found");
    }

    while (getline(in, str, ','))
    {
        double v = stod(str);
        minY = fmin(minY, v);
        maxY = maxY < v ? v : maxY;
        data << QPointF(counter++/frequency, v);
    }

    maxX = (counter - 1) / frequency;

    return data;
}
