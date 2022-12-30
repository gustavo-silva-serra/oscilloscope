import QtQuick 2.15
import QtQuick.Window 2.15
import QtQml 2.15
import QtCharts 2.15
import UiDataPlotter 1.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3
import QtQuick.Controls.Material 2.15

ApplicationWindow {
    id: mainwindow
    width: 640
    height: 480
    visible: true
    title: qsTr("Oscilloscope")

    UiDataPlotter {
        id: uidataplotter;
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        onAccepted: {
            uidataplotter.setGraphData(lineseries, fileDialog.fileUrl, frequencyInput.text)
        }
    }

    Dialog {
        id: frequencyDialog
        title: "Inform the frequency (KHz)"
        TextInput {
            id: frequencyInput
            maximumLength: 4
            inputMask: '0000'
            focus: true
            text: '333'
        }

        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: fileDialog.visible = true
    }

    ColumnLayout {
        id: maincolumn
        anchors.fill: parent

        // The resizing is too slow when the chart view is added
        // this needs a solution
        ChartView {
            id: chartview
            Layout.fillHeight: true
            Layout.fillWidth: true
            title: "Voltage"
            legend.visible: false
            antialiasing: true
            theme: ChartView.ChartThemeDark

            LineSeries {
                id: lineseries
                objectName: "lineSeries"
                property double horizontalZoomFactor: (100 - zoomSlider.value) / 100

                axisX: ValueAxis {
                    labelFormat: "%.1f(s)"
                    max: (uidataplotter.MaxX * hbar.position) + (uidataplotter.MaxX * lineseries.horizontalZoomFactor)
                    min: uidataplotter.MaxX * hbar.position
                }

                axisY: ValueAxis {
                    labelFormat: "%.2f(V)"
                    max: uidataplotter.MaxY + 1
                    min: uidataplotter.MinY - 1
                }
            }

            RubberBand{
                chartView: this
            }
        }

        ScrollBar {
            id: hbar
            active: true
            orientation: Qt.Horizontal
            size: lineseries.horizontalZoomFactor
            Layout.maximumWidth: mainwindow.width
            Layout.fillWidth: true
            policy: "AlwaysOn"
        }

        Flow {
            spacing: 20
            padding: 10
            GroupBox {
                title: "Options"
                ColumnLayout {
                    Button {
                        text: "Load new file"
                        onClicked: {
                            frequencyDialog.visible = true
                        }
                    }

                    CheckBox {
                        checked: true
                        text: "Dark theme"
                        onCheckStateChanged: {
                            chartview.theme = checked ? ChartView.ChartThemeDark : ChartView.ChartThemeLight
                        }
                    }
                }
            }

            GroupBox {
                title: "Zoom control"
                ColumnLayout {
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

            GroupBox {
                title: "Data info"
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
}
