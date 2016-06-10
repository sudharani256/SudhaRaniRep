({
    isUIControlDisplayed : false,
    isDataRetrieved : false,
        
    //flags to check if the control is displayed and data is retrieved
    initializeDisplayFlags : function() {
        this.isUIControlDisplayed = false;
        this.isDataRetrieved = false;
    },
    
    //helper method invoked during the component rendering lifecycle
    //used to retrieve data from the server side and initialize requirejs
    //to load apporpriate scripts
    initScripts: function(component) {        
		//fetch the data from server side only if it is not already fetched        
        if (this.isDataRetrieved === false) {   
            this.isDataRetrieved = true;            
      		this.fetchDataFromSource(component);
        }
  	},

    fetchDataFromSource: function(component) {
        //based on the datasource fetch information from the appropriate source
        //datasources supported are "APEX PROVIDER", "REST SERVICE", "CLIENT"
        var dataSourceType = component.get("v.dataSourceType");

	    //This attribute needs to be populated if APEX Provider is selected as the data source Type
        var apexProviderClass = component.get("v.apexProviderClass");

    	//This attribute needs to be populated if REST Service is selected as the data source Type
        var restEndPoint = component.get("v.restEndPoint");
        var restEndPointMethod = component.get("v.restEndPointMethod");
        var accessToken = component.get("v.accessToken");

        
       	//call the server side APEX Controller Method to retrieve the values
        var action = component.get("c.getChartData");
        action.setParams({'dataSourceType': dataSourceType, 'apexProviderClass': apexProviderClass, 'restEndPoint': restEndPoint, 'restEndPointMethod': restEndPointMethod, 'authorizationToken': accessToken});   
        action.setCallback(this, function(a) {
        	//populate the values retrieved from the server side using the callback method
            var jsonData = a.getReturnValue();    
            
            if (dataSourceType == "CLIENT") {
	        	jsonData = component.get("v.data");
                if ((typeof jsonData == "undefined") || (jsonData == "")) {
                    jsonData = '[{"category": "","value": 100}]';
                }                
 		   	}
            this.initRequireJS(component, jsonData, dataSourceType);
     	});      
        $A.enqueueAction(action);
    },
    
    initRequireJS : function(component, jsonData, dataSourceType) {
       if (typeof requirejs !== "undefined") {
	    	var self = this;
           	//load the required js libraries using require js
            requirejs.config({
            	baseUrl: "/resource/",
            	paths: {
                	jquery: "/resource/docmCharts__DocM_JQuery/jquery",
	                chartjs: "/resource/docmCharts__DocM_ChartJS/Chart",
                	kendo: "/resource/docmCharts__DocM_Kendo/js/kendo",
                	jqueryui: "/resource/docmCharts__DocM_JQueryTouch/jquery-ui",
                	jquerytouch: "/resource/docmCharts__DocM_JQueryTouch/jquery.ui.touch-punch.min"
            	}
        	});
        	requirejs(["jquery", "chartjs", "kendo", "jqueryui", "jquerytouch"], function(_jq, _cj, _kn, _ju, _jt) {
                if (!component._scriptsInitialized) {
                    // Initialization semaphore
                    component._scriptsInitialized = true;
                    
                    // Use $j rather than $ to avoid jQuery conflicts
                    if (typeof jQuery !== "undefined" && typeof $j === "undefined") {
                        $j = jQuery.noConflict(true);
                    }
                    
                    if (typeof $j != "undefined") {
            			//self.validateAttributes(component);
            			//call the method to convert the regular HTML Input element into
            			//a Kendo UI Control and pass the relevant data for initialization
        				self.createChart(jsonData, component, dataSourceType);
       				}   
                }
        	});
        }                
    },
    
    validateAttributes: function(component) {
        //helper method to validate all required attributes for the Component
        //are passed and valid
        var cLocalId = component.getLocalId();
        if ((typeof cLocalId === "undefined") || (cLocalId == "")) {
            var errorMessage = "Pick List Component cannot be loaded without a valid value for the aura:id attribute";
			var errorTitle = "Invalid Component Configuration";
            //helper.displayErrorMessage(component, errorTitle, errorMessage);
            $A.error(errorMessage);
        }
    },

    createChart : function(jsonData, component, dataSourceType) {
	    console.log("DonutChart: createChart: enter component id " + component.get("v.docmId"));
        //method to convert the HTML Control into a Kendo UI Control
		var isFieldVisible =  "none";
        var wrapperDivElementId = this.getWrapperElementId(component);
	    console.log("DonutChart: createChart: component id " + component.get("v.docmId") + " wrapperDivElementId " + wrapperDivElementId);
        //don't display the Control until all the data is populated. This is controlled
        //by setting the display flag on the container div
        isFieldVisible = $j("#" + wrapperDivElementId).css('display');
	    console.log("DonutChart: createChart: component id " + component.get("v.docmId") + " isFieldVisible " + isFieldVisible);
        if (isFieldVisible === "none"){
            this.isUIControlDisplayed = false;
        }
        
        if (this.isUIControlDisplayed === false) {   
            this.isUIControlDisplayed = true;
            var self = this;
	        console.log("DonutChart: createChart: component id " + component.get("v.docmId") + " " + jsonData);
			var jsData = self.parseDataFromDataSource(component, dataSourceType, jsonData);
			//convert the Div element into a Chart            
	        console.log("DonutChart: createChart: display chart " + component.get("v.docmId") + " " + jsonData);
            self.displayChart(component, jsData);
          	console.log("DonutChart: createChart: make wrapper visible" + component.get("v.docmId"));

            //display the DIV element containing the Kendo UI Control
            $j("#" + wrapperDivElementId).show();  
      	}
   	},
    
    parseDataFromDataSource: function(component, dataSourceType, jsonData) {
        var jsData = "";
        //parse the JSON data passed to this function and populate
        if (dataSourceType != "CLIENT") {
        	var dataResult = $j.parseJSON(jsonData);
            //if there are any errors in data retrieval throw 
            if (dataResult.status == false) {
            	var errorMessage = dataResult.message;
                $A.error(errorMessage);
            }
            if (dataResult.status == true) {  
            	jsData = dataResult.data;
            }
      	}
        else {
        	jsData = jsonData;         
      	}
        return jsData;
    },
    
   	displayChart: function(component, jsData) {
        console.log("DonutChart: displayChart: component id " + component.get("v.docmId") + " " + jsData);
    	if (jsData != "") {
        	var chartData = "[";
            //loop through all the data passed    
            $j.each($j.parseJSON(jsData), function() {
            	var chartDataItem = "{";    
                chartDataItem += "\"category\": \"" + this.category + "\",";
                chartDataItem += "\"value\": " + this.value;
                chartDataItem += "}";
                if (chartData != "[") {
                	chartData += ",";
                }
                chartData += chartDataItem;
         	});
    		chartData += "]";
                
            var chartTitle = component.get("v.chartTitle");
            var uiControlId = this.getUIControlId(component);
            
            $j("#" + uiControlId).kendoChart({
            	title: {
                	text: chartTitle
               	},
                legend: {
                	position: "top"
               	},
                seriesDefaults: {
                	labels: {
                    	template: "#= category # - #= kendo.format('{0:P}', percentage)#",
                        position: "outsideEnd",
                        visible: true,
                        background: "transparent"
                    }
                },
                series: [{
                	type: "donut",
                    data: $j.parseJSON(chartData)
                }],
                tooltip: {
                	visible: true,
                    template: "#= category # - #= kendo.format('{0:P}', percentage) #"
                }
            });    
        }
    },
            
    //helper method to retrieve the unique control id
    getDocMId: function(component) {
		return component.get("v.docmId");        
    },
   
    //helper method to retrieve the unique control id
    getUIControlId: function(component) {
		return component.get("v.uiElement") + component.get("v.docmId");        
    },

    //helper method to retrieve the unique control id
    getWrapperElementId: function(component) {
		return component.get("v.wrapperDivElement") + component.get("v.docmId");        
    },

    //helper method to retrieve the unique control id
    getMessageElementId: function(component) {
		return component.get("v.messageDivElement") + component.get("v.docmId");        
    },

	//helper method to Refresh the Pick List values pulled
	//from the server side    
  	refreshUI : function(component) {
        console.log("DonutChart: refreshUI: enter");
       	var controlId = this.getUIControlId(component);
        //this.enableComponent(component);
        //var uiControl = $j("#" + controlId).data("kendoChart");
        //uiControl.refresh();
    },
    
    generateUniqueId: function(component) {
        var globalId = component.getGlobalId();
        globalId = globalId.replace(";", "X");
        globalId = globalId.replace(".", "A");
        globalId = globalId.replace(":", "B");
        globalId = "dm" + globalId;
		return globalId;
    },
    
})