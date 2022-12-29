#ifndef UIDATAPLOTTER_H
#define UIDATAPLOTTER_H

#include "IPlotterDataReader.h"
#include "FileDataReader.h"

#include <QObject>
#include <QtCharts/QLineSeries>
#include <QtCharts/QChartView>

#include <iostream>

using namespace std;

/**
 * @brief The UiDataPlotter Handles the UI business logic
 * This class is the glue between the readers and the UI. In this way we
 * keep all the data readers as pure as possible.
 */
class UiDataPlotter : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double MaxX READ getMaxX WRITE setMaxX NOTIFY maxXChanged)
    Q_PROPERTY(double MaxY READ getMaxY WRITE setMaxY NOTIFY maxXChanged)
    Q_PROPERTY(double MinY READ getMinY WRITE setMinY NOTIFY minYChanged)

public:
    explicit UiDataPlotter(QObject *parent = nullptr) : QObject{parent}
    {
        // This will eventually transform into a factory
        // or dependecy injection for more flexibility
        data_reader = new FileDataReader();
    }

    ~UiDataPlotter()
    {
        delete data_reader;
    }

    double getMaxX() const { return maxX; }
    void setMaxX(double max) { maxX = max; emit maxXChanged(max); }

    double getMaxY() const { return maxY; }
    void setMaxY(double max) { maxY = max; emit maxYChanged(max); }

    double getMinY() const { return minY; }
    void setMinY(double min) { minY = min; emit minYChanged(min); }

    /**
     * @brief setGraphData Populates the graph view with data
     * @param object A QLineSeries object
     */
    Q_INVOKABLE void setGraphData(QObject* object)
    {
        QLineSeries* series = dynamic_cast<QLineSeries*>(object);

        // We should add asynchronous capability for the sake of responsiveness
        // and also so we can handle continuous data streams
        QList<QPointF> data = data_reader->read(minY, maxY, maxX);

        // I had to set the UI data in this manner because getting the data in the QML
        // was painfully slow, practically impossible to use
        series->replace(data);

        setMaxY(maxY); // so we emit signal
        setMaxX(maxX);
        setMinY(minY);
    }

signals:
    void maxXChanged(double);
    void maxYChanged(double);
    void minYChanged(double);

private:
    IPlotterDataReader* data_reader{NULL};
    double maxX = 0;
    double maxY = 0;
    double minY = 0;
};

#endif // UIDATAPLOTTER_H
