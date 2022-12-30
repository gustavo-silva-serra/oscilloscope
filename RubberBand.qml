import QtQuick 2.15
import QtCharts 2.15

// Rubber band, copied from
// https://stackoverflow.com/questions/12284151/invalid-write-to-global-property-qml


MouseArea {

    property int xScaleZoom: 0
    property int yScaleZoom: 0
    property var chartView: null

    Rectangle{
        id: recZoom
        border.color: "steelblue"
        border.width: 1
        color: "steelblue"
        opacity: 0.3
        visible: false
        transform: Scale { origin.x: 0; origin.y: 0; xScale: xScaleZoom; yScale: yScaleZoom}
    }

    anchors.fill: chartview
    hoverEnabled: true
    onPressed: {
        recZoom.x = mouseX;
        recZoom.y = mouseY;
        recZoom.visible = true;
    }
    onMouseXChanged: {
        if (mouseX - recZoom.x >= 0) {
            xScaleZoom = 1;
            recZoom.width = mouseX - recZoom.x;
        } else {
            xScaleZoom = -1;
            recZoom.width = recZoom.x - mouseX;
        }
    }
    onMouseYChanged: {
        if (mouseY - recZoom.y >= 0) {
            yScaleZoom = 1;
            recZoom.height = mouseY - recZoom.y;
        } else {
            yScaleZoom = -1;
            recZoom.height = recZoom.y - mouseY;
        }
    }
    onReleased: {
        var x = (mouseX >= recZoom.x) ? recZoom.x : mouseX
        var y = (mouseY >= recZoom.y) ? recZoom.y : mouseY
        chartview.zoomIn(Qt.rect(x, y, recZoom.width, recZoom.height));
        recZoom.visible = false;
    }
}

