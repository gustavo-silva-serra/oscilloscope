#ifndef FILEDATAREADER_H
#define FILEDATAREADER_H

#include "IPlotterDataReader.h"

#include <QPointF>
#include <QList>

class FileDataReader : public IPlotterDataReader
{
public:
    QList<QPointF> read(std::string fileName, int frequency, double& minY, double& maxY, double& maxX);
};

#endif // FILEDATAREADER_H
