# MATLAB&reg; GUI for Lake Shore Cryogenic Temperature Controller

Developed by *Yuanqi Lyu* ([yuanqilyu@berkeley.edu](mailto:yuanqilyu@berkeley.edu)) at UC Berkeley.

This is a simple GUI for Lake Shore temperature (heater) controllers using serial connection.

### Compatibility
* Tested on MATLAB&reg; 2020b.
* Tested on [Lake Shore&reg; Model 336 Cryogenic Temperature Controller](https://www.lakeshore.com/products/categories/overview/temperature-products/cryogenic-temperature-controllers/model-336-cryogenic-temperature-controller); should also work for other Lake Shore&reg; cryogenic temperature controllers with similar serial interface commands.

### Basic Starting Guide
* Open `CtrlGUI_LS336.mlapp` in MATLAB&reg; App Designer.
* In App Designer's *Code View* change app/class properties `N_Heater` and `N_TempSensor` to numbers of heaters and temperature sensors connected respectively. For instance, if you have 2 heater outputs and 4 temperature sensor inputs,
    
      properties (Access = public)
        N_Heater = 2;
        N_TempSensor = 4;
        ...
      end
    
* Run!
* In GUI, input correct serial port name (e.g. "COM1") and start the connection by turn on the switch.
* Enjoy!
