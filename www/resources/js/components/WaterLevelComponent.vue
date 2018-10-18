<template>
    <div class="container">
	Water Level

	   <fusioncharts 
		:type="type"
                :width="width"
                :height="height"
                :dataFormat="dataFormat"
                :dataSource="dataSource"></fusioncharts>
    </div>
</template>

<script>
import FusionCharts from 'fusioncharts';
import Charts from 'fusioncharts/fusioncharts.charts';
//import { FCComponent } from 'vue-fusioncharts';
const FCComponent = require('vue-fusioncharts').FCComponent;


//Vue.component('fusioncharts', require('vue-fusioncharts').FCComponent);
Vue.component('fusioncharts', FCComponent);

// Resolves charts dependancy
Charts(FusionCharts);

	    const dataSource = {
	        "chart": {
	        "caption": "LPG Level Indicator",
	        "lowerlimit": "0",
	        "upperlimit": "25",
	        "lowerlimitdisplay": "Empty",
	        "upperlimitdisplay": "Full",
	        "numbersuffix": " ltrs",
	        "cylfillcolor": "#5D62B5",
	        "plottooltext": "LPG Consumption: <b>20 ltrs</b>",
	        "cylfillhoveralpha": "85",
	        "theme": "fusion"	
	    },
	      "value": "20"
	    };
    export default {
        //name: "fusioncharts",
        mounted() {
            console.log('Component mounted.')
        },
	components: {
	    //fusioncharts: FCComponent,
	    fsioncharts: FCComponent,
	},
	data: () => ({
	   type: "cylinder",
	   width: '100%',
	   height: '100%',
	   dataFormat: 'json',
	   dataSource,
	}),
    }
</script>
