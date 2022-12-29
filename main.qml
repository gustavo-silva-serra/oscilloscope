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

    UiDataPlotter {
        id: uidataplotter;
    }

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
                property double totalSeconds: uidataplotter.MaxX

                axisX: ValueAxis {
                    tickCount: 1
                    labelFormat: "%.1f(s)"
                    max: (lineseries.totalSeconds * hbar.position) + (lineseries.totalSeconds * lineseries.horizontalZoomFactor)
                    min: lineseries.totalSeconds * hbar.position
                }

                axisY: ValueAxis {
                    tickCount: 1
                    labelFormat: "%.2f(V)"
                    max: uidataplotter.MaxY + 1
                    min: uidataplotter.MinY - 1
                }

                Component.onCompleted: {
                    uidataplotter.setGraphData(this)
                }
            }

            // Rubber band, copied from
            // https://stackoverflow.com/questions/12284151/invalid-write-to-global-property-qml
            property int xScaleZoom: 0
            property int yScaleZoom: 0

            Rectangle{
                id: recZoom
                border.color: "steelblue"
                border.width: 1
                color: "steelblue"
                opacity: 0.3
                visible: false
                transform: Scale { origin.x: 0; origin.y: 0; xScale: chartview.xScaleZoom; yScale: chartview.yScaleZoom}
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onPressed: {
                    recZoom.x = mouseX;
                    recZoom.y = mouseY;
                    recZoom.visible = true;
                }
                onMouseXChanged: {
                    if (mouseX - recZoom.x >= 0) {
                        chartview.xScaleZoom = 1;
                        recZoom.width = mouseX - recZoom.x;
                    } else {
                        chartview.xScaleZoom = -1;
                        recZoom.width = recZoom.x - mouseX;
                    }
                }
                onMouseYChanged: {
                    if (mouseY - recZoom.y >= 0) {
                        chartview.yScaleZoom = 1;
                        recZoom.height = mouseY - recZoom.y;
                    } else {
                        chartview.yScaleZoom = -1;
                        recZoom.height = recZoom.y - mouseY;
                    }
                }
                onReleased: {
                    var x = (mouseX >= recZoom.x) ? recZoom.x : mouseX
                    var y = (mouseY >= recZoom.y) ? recZoom.y : mouseY
                    chartview.zoomIn(Qt.rect(x, y, recZoom.width, recZoom.height));
                    recZoom.visible = false;
                    zoomControls.enabled = false;
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
            spacing: 20
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
            ColumnLayout {
                Label {
                    text: "Max.: " + uidataplotter.MaxY + "V"
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: "Min.: " + uidataplotter.MinY + "V"
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: "Secs: " + parseInt(uidataplotter.MaxX) + "s"
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
