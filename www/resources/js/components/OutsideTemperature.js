import React, { Component } from 'react';
import ReactDOM from 'react-dom';

// Step 2 - Including the react-fusioncharts component
import ReactFC from 'react-fusioncharts';

// Step 3 - Including the fusioncharts library
import FusionCharts from 'fusioncharts';

// Step 4 - Including the chart type
import Widgets from 'fusioncharts/fusioncharts.widgets';

// Step 5 - Including the theme as fusion
import FusionTheme from 'fusioncharts/themes/fusioncharts.theme.candy';

import axios from 'axios';

// Step 6 - Adding the chart as dependency to the core fusioncharts
ReactFC.fcRoot(FusionCharts, Widgets, FusionTheme);

// Outside Temperature
const dataSourceOutsideTemp = {
    "chart": {
        "caption": "",
        "subcaption": "",
        "lowerlimit": "-5",
        "upperlimit": "50",
        "numbersuffix": "°C",
        "thmfillcolor": "#008ee4",
        "showgaugeborder": "1",
        "gaugebordercolor": "#008ee4",
        "gaugeborderthickness": "2",
        "plottooltext": "",
        "theme": "candy",
        "showvalue": "1",
        "thmBulbRadius": "55",
        "thmHeight": "350",
        "adjustTM": "1",
        "ticksOnRight": "0",
        "tickMarkDistance": "5",
        "tickValueDistance": "2",
        "majorTMNumber": "10",
        "majorTMHeight": "12",
        "minorTMNumber": "4",
        "minorTMHeight": "7",
        "tickValueStep": "1"
    },
    "value": "23",
    "annotations": {
        "showbelow": "0",
        "groups": [
            {
                "id": "indicator",
                "items": [
                    {

                        "id": "rangeText",
                        "type": "Text",
                        "fontSize": "45",
                        "fillcolor": "#ffffff",
                        "text": "0 °C",
                        "x": "$chartCenterX+160",
                        "y": "$chartEndY-300"
                    }
                ]
            }
        ]
    }
};


const eventsOutsideTemp= {
    "rendered": function(evtObj, argObj) {
        var gaugeRef = evtObj.sender;
        gaugeRef.chartInterval = setInterval(function() {
            // Get the water pressure from the server
            axios.get('https://localhost:8085/outside-temperature')
                .then(response => {
                    var fuelVolume = response.data.temperature;
                    var consVolume = response.data.temperature;
                    gaugeRef.feedData("&value=" + consVolume);
                    fuelVolume = consVolume;
                });
        }, 3000);
    },
    //Using real time update event to update the annotation
    "realTimeUpdateComplete": function(evt, arg) {
        let annotations = evt.sender.annotations,
            dataVal = evt.sender.getData(),
            colorVal = (dataVal >= 70) ? "#6caa03" : ((dataVal <= 25) ? "#e44b02" : "#f8bd1b");
        //Updating value
        annotations && annotations.update('rangeText', {
            "text": Math.floor(dataVal) + "°C"
        });
    },
    "disposed": function(evt, arg) {
        clearInterval(evt.sender.chartInterval);
    }
};


// Step 8 - Creating the DOM element to pass the react-fusioncharts component
class Temperature extends React.Component {
    render() {
        return (
            <ReactFC
                type = "thermometer"
                width = '100%'
                height = '500'
                dataFormat = "JSON"
                dataSource = {dataSourceOutsideTemp}
                events =  {eventsOutsideTemp}/>
        );
    }
}


export default Temperature

