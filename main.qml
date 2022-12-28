import QtQuick 2.15
import QtQuick.Window 2.15
import QtQml 2.0
import QtCharts 2.0
import PlotterDataReader 1.0
import QtQuick.Controls 2.1

Window {
    id: mainwindow
    width: 640
    height: 480
    visible: true
    title: qsTr("Voltage Plotter")

    PlotterDataReader {
        id: dataReader;
    }

    ChartView {
        id: chartview

        x: -hbar.position * width
        width: parent.width * 10
        height: parent.height

        legend.visible: false
        antialiasing: true
        theme: ChartView.ChartThemeDark

        PlotterDataReader {
            id: plotterDataReader
        }

        LineSeries {
            objectName: "lineSeries"
            axisX: ValueAxis {
                tickCount: 1
                labelFormat: "%.0f"
            }

            Component.onCompleted: {
                plotterDataReader.read(this)
                console.log(chartview.width, chartview.height)
            }
        }
    }

    ScrollBar {
        id: hbar
        hoverEnabled: true
        active: hovered || pressed
        orientation: Qt.Horizontal
        size: mainwindow.width / chartview.width
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}
