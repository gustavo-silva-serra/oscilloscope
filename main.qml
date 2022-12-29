import QtQuick 2.15
import QtQuick.Window 2.15
import QtQml 2.0
import QtCharts 2.0
import UiDataPlotter 1.0
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
// Material auto-hides the scrollbar, it confuses the user
// it is necessary to fix this
// import QtQuick.Controls.Material 2.13


ApplicationWindow {
    id: mainwindow
    width: 640
    height: 480
    visible: true
    title: qsTr("Voltage Plotter")

    ColumnLayout {
        anchors.fill: parent

        // The resizing is too slow when the chart view is added
        // this needs a solution
        ChartView {
            id: chartview
            Layout.fillHeight: true
            Layout.fillWidth: true

            legend.visible: false
            antialiasing: true
            theme: ChartView.ChartThemeDark

            LineSeries {
                id: lineseries
                objectName: "lineSeries"
                property double startingPoint: 0
                property double horizontalZoomFactor: (100 - zoomSlider.value) / 100
                property double totalPoints: 0

                axisX: ValueAxis {
                    tickCount: 1
                    labelFormat: "%.1f(s)"
                    max: (lineseries.totalPoints * hbar.position) + (lineseries.totalPoints * lineseries.horizontalZoomFactor)
                    min: lineseries.totalPoints * hbar.position
                }

                UiDataPlotter {
                    id: uidataplotter;
                }

                Component.onCompleted: {
                    lineseries.totalPoints = uidataplotter.setGraphData(this)
                }
            }
        }

        ScrollBar {
            id: hbar
            active: true
            orientation: Qt.Horizontal
            size: lineseries.horizontalZoomFactor
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

            ColumnLayout {
                Label {
                    text: "Zoom "
                    Layout.alignment: Qt.AlignHCenter
                }
                RowLayout {
                    id: zoomControls
                    Slider {
                        id: zoomSlider
                        from: 0
                        value: 0
                        to: 99.9
                    }
                    TextInput {
                        text: parseInt(zoomSlider.value) + "%"
                    }
                }
                Button {
                    Layout.alignment: Qt.AlignHCenter
                    padding: 0
                    text: "Reset"
                    onClicked: {
                        zoomSlider.value = 0
                        chartview.zoomReset()
                        zoomControls.enabled = true
                    }
                }
            }
        }
    }
}
