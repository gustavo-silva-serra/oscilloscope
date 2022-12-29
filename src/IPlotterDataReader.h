#ifndef IPLOTTERDATAREADER_H
#define IPLOTTERDATAREADER_H

#include <QPointF>
#include <QList>

/**
 * @brief Defines a common interface for classes that read the graph data
 *
 * By implementing this interface one can read different data sources like TCP/IP, USB, file, etc.
 */
class IPlotterDataReader
{
public:
    /**
     * @brief read Returns the graph data
     * @param minY the minimal value for the Y axis
     * @param maxY the maximum value for the Y axis
     * @param maxX the minimal value for the X axis
     * @return The graph data
     *
     * The output parameters are a convenience for the caller, so it doesn't
     * need to traverse the list to find these values.
     */
    virtual QList<QPointF> read(double& minY, double& maxY, double& maxX) = 0;

    virtual ~IPlotterDataReader() {}
};

#endif // IPLOTTERDATAREADER_H
