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
                        "text": "0%",
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
	    axios.get('https://localhost:8085/water-pressure')
    		.then(response => {
    		    var fuelVolume = response.data.percent;
    		    var consVolume = response.data.percent;
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
                "text": Math.floor(dataVal) + "%"
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


export default { WaterLevelCylinder, Temperature }



if (document.getElementById('water-level-cylinder')) {
    ReactDOM.render(<WaterLevelCylinder/>, document.getElementById('water-level-cylinder'));
}

if (document.getElementById('outside-temp')) {
    ReactDOM.render(<Temperature/>, document.getElementById('outside-temp'));
}



$(function() {

    // slider type
    let $t = "slide"; // opitions are fade and slide
    //
    //     //variables
    let $f = 1000,  // fade in/out speed
        $s = 1000,  // slide transition speed (for sliding carousel)
        $d = 15000;  // duration per slide

    let $n = $('.slide').length; //number of slides
    let $w = $('.slide').width(); // slide width
    let $c = $('.container').width(); // container width
    let $ss = $n * $w; // slideshow width


    function timer() {
        $('.timer').animate({"width":$w}, $d);
        $('.timer').animate({"width":0}, 0);
    }


    // fading function
    function fadeInOut() {
        timer();
        let $i = 0;
        var setCSS = {
            'position' : 'absolute',
            'top' : '0',
            'left' : '0'
        }

        $('.slide').css(setCSS);

        //show first item
        $('.slide').eq($i).show();


        setInterval(function() {
            timer();
            $('.slide').eq($i).fadeOut($f);
            if ($i == $n - 1) {
                $i = 0;
            } else {
                $i++;
            }
            $('.slide').eq($i).fadeIn($f, function() {
                $('.timer').css({'width' : '0'});
            });

        }, $d);

    }

    function slide() {
        timer();
        var setSlideCSS = {
            'float' : 'left',
            'display' : 'inline-block',
            'width' : $c
        }
        var setSlideShowCSS = {
            'width' : $ss // set width of slideshow container
        }
        $('.slide').css(setSlideCSS);
        $('.slideshow').css(setSlideShowCSS);


        setInterval(function() {
            timer();
            $('.slideshow').animate({"left": -$w}, $s, function(){
                // to create infinite loop
                $('.slideshow').css('left',0).append( $('.slide:first'));
            });
        }, $d);

    }

    if ($t == "fade") {
        fadeInOut();

    } if ($t == "slide") {
        slide();

    } else {

    }
});

