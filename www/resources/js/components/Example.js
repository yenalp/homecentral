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

// Step 7 - Creating the JSON object to store the chart configurations
const dataSourceCylinder = {
  "chart": {
    "lowerlimit": "0",
    "upperlimit": "100",
    "lowerlimitdisplay": "Empty",
    "upperlimitdisplay": "Full",
    "numbersuffix": " %",
    "cylfillcolor": "#0099fd",
    "plottooltext": "Water Level: <b>100%</b>",
    "cylfillhoveralpha": "85",
    "theme": "candy",
    "cylradius": "300",
    "cylheight": "350",
    "showValue": "0",
    "majorTMNumber": "10",
    "adjustTM": "1",
  },
  "value": "0",
  "annotations": {
        "autoscale": "1",
        "groups": [
            {
                "id": "range",
                "items": [
                    {
                        "id": "rangeText",
                        "type": "Text",
                        "fontSize": "45",
                        "fillcolor": "#ffffff",
                        "text": "Total: 0%",
                        "x": "$chartCenterX-45",
                        "y": "$chartEndY-35"
                    }
                ]
            }
        ]
    }
};

const eventsCylinder = {
    "rendered": function(evtObj, argObj) {
        var gaugeRef = evtObj.sender;
        gaugeRef.chartInterval = setInterval(function() {
	    // Get the water pressure from the server
	    axios.get('https://192.168.2.153:8085/water-pressure')
    		.then(response => {
            		var fuelVolume = response.data.percent;
            		var consVolume = response.data.percent;
			gaugeRef.feedData("&value=" + consVolume);
            		fuelVolume = consVolume;
		});
        }, 3000);
    },
    //Using real time update event to update the annotation
    //showing available volume of Diesel
    "realTimeUpdateComplete": function(evt, arg) {
	    var annotations = evt.sender.annotations,
            dataVal = evt.sender.getData(),
            colorVal = (dataVal >= 70) ? "#6caa03" : ((dataVal <= 25) ? "#e44b02" : "#f8bd1b");
        //Updating value
        annotations && annotations.update('rangeText', {
            "text": "Total: " + Math.floor(dataVal) + "%"
        });
    },
    "disposed": function(evt, arg) {
        clearInterval(evt.sender.chartInterval);
    }
};


// Step 8 - Creating the DOM element to pass the react-fusioncharts component 
class WaterLevelCylinder extends React.Component {
  render() {
     return (
     <ReactFC
	 type = "cylinder"
         width = '100%'
         height = '500'
         dataFormat = "json"
         dataSource = {dataSourceCylinder} 
	 events =  {eventsCylinder}/>
     );
  }
}
export default WaterLevelCylinder

if (document.getElementById('water-level-cylinder')) {
    ReactDOM.render(<WaterLevelCylinder/>, document.getElementById('water-level-cylinder'));
}
