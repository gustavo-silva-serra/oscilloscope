#ifndef UIDATAPLOTTER_H
#define UIDATAPLOTTER_H

#include "IPlotterDataReader.h"
#include "FileDataReader.h"

#include <QObject>
#include <QtCharts/QLineSeries>
#include <QtCharts/QChartView>

/**
 * @brief The UiDataPlotter Handles the UI business logic
 * This class is the glue between the readers and the UI. In this way we
 * keep all the data readers as pure as possible.
 */
class UiDataPlotter : public QObject
{
    Q_OBJECT

public:
    explicit UiDataPlotter(QObject *parent = nullptr) : QObject{parent}
    {
        // This will eventually transform into a factory
        // or dependecy injection for more flexibility
        data_reader = new FileDataReader();
    }

    /**
     * @brief setGraphData Populates the graph view with data
     * @param object A QLineSeries object
     */
    Q_INVOKABLE void setGraphData(QObject* object)
    {
        QLineSeries* series = dynamic_cast<QLineSeries*>(object);
        double minY = 0, maxY = 0, maxX = 0;

        // We should add asynchronous capability for the sake of responsiveness
        // and also so we can handle continuous data streams
        QList<QPointF> data = data_reader->read(minY, maxY, maxX);

        // I had to set the UI data in this manner because getting the data in the QML
        // was painfully slow, practically impossible to use
        series->replace(data);

        // Setting the UI attributes here is not optimal, but for now I am keeping the
        // implementation as simple as possible. A better approach is to emit a signal
        // every time these values change so the UI can react properly, using getters
        // to update the values
        series->attachedAxes().at(0)->setMin(0);
        series->attachedAxes().at(0)->setMax(maxX);
        series->attachedAxes().at(1)->setMin(minY + -1);
        series->attachedAxes().at(1)->setMax(maxY + 1);
    }

private:
    IPlotterDataReader* data_reader;
};

#endif // UIDATAPLOTTER_H
