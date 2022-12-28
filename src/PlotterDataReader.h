#ifndef PLOTTERDATAREADER_H
#define PLOTTERDATAREADER_H

#include <QObject>
#include <QChartView>

typedef QPair<qreal, qreal> RealPair;

class PlotterDataReader : public QObject
{
    Q_OBJECT

    const qreal frequency = 333;

public:
    explicit PlotterDataReader(QObject *parent = nullptr);
    Q_INVOKABLE void read(QObject* object);

signals:

};

#endif // PLOTTERDATAREADER_H
