import QtQuick 2.15
import QtQuick.Window 2.15
import QtQml 2.0
import QtCharts 2.0
import UiDataPlotter 1.0
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.13


ApplicationWindow {
    id: mainwindow
    width: 640
    height: 480
    visible: true
    title: qsTr("Voltage Plotter")

    Material.theme: Material.Dark

    ColumnLayout {
        anchors.fill: parent

        // The resizing is too slow when the chart view is added
        // this needs a solution
        ChartView {
            id: chartview
            x: -hbar.position * width
            width: mainwindow.width * 10
            height: mainwindow.height / 2
            Layout.fillHeight: true

            legend.visible: false
            antialiasing: true
            theme: ChartView.ChartThemeDark

            LineSeries {
                objectName: "lineSeries"
                axisX: ValueAxis {
                    tickCount: 1
                    labelFormat: "%.0f"
                }

                UiDataPlotter {
                    id: uidataplotter;
                }

                Component.onCompleted: {
                    uidataplotter.setGraphData(this)
                }
            }
        }

        ScrollBar {
            id: hbar
            hoverEnabled: true
            active: hovered || pressed
            orientation: Qt.Horizontal
            size: mainwindow.width / chartview.width
            Layout.maximumWidth: mainwindow.width
            Layout.fillWidth: true
        }

        Flow {
            CheckBox {
                checked: true
                text: "Dark theme"
                onCheckStateChanged: {
                    chartview.theme = checked ? ChartView.ChartThemeDark : ChartView.ChartThemeLight
                }
            }
        }
    }
}
