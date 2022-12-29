#ifndef FILEDATAREADER_H
#define FILEDATAREADER_H

#include "IPlotterDataReader.h"

#include <QPointF>
#include <QList>

class FileDataReader : public IPlotterDataReader
{
    const double frequency = 333;

public:
    QList<QPointF> read(std::string fileName, double& minY, double& maxY, double& maxX);
};

#endif // FILEDATAREADER_H
