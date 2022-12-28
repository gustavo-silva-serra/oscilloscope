#include "plotterdatareader.h"

#include <fstream>
#include <iostream>
#include <filesystem>

#include <QtCharts/QLineSeries>
#include <QtCharts/QChartView>

using namespace std;

PlotterDataReader::PlotterDataReader(QObject *parent)
    : QObject{parent}
{
}

void PlotterDataReader::read(QObject* object)
{
    QList<QPointF> data;

    std::ifstream in("signal.txt");
    if (!in) {
        throw new std::runtime_error("File signal.txt not found");
    }
    std::string str;
    double counter = 0;
    double minY = std::numeric_limits<double>::infinity();
    double maxY = std::numeric_limits<double>::lowest();
    while (getline(in, str, ','))
    {
        double v = stod(str);
        minY = fmin(minY, v);
        maxY = maxY < v ? v : maxY;
        data << QPointF(counter++/frequency, v);
    }

    QLineSeries* series = dynamic_cast<QLineSeries*>(object);
    series->replace(data);
    series->attachedAxes().at(0)->setMin(0);
    series->attachedAxes().at(0)->setMax((counter-1)/frequency);
    series->attachedAxes().at(1)->setMin(minY + -1);
    series->attachedAxes().at(1)->setMax(maxY + 1);
}
