# Lake Shore Temperature Controller

Developed by *Yuanqi Lyu* <yuanqilyu@berkeley.edu> at UC Berkeley.

This is a simple GUI for Lake Shore temperature (heater) controllers using serial connection.

### Compatibility
* Tested on MATLAB&reg; 2020b.
* Tested on Lake Shore 336 and Lake Shore 335; should also work for other Lake Shore controllers with similar serial interface commands.

### Basic Start Guide
* Open `CtrlGUI_LS336.mlapp` in MATLAB&reg; App Designer.
* In App Designer's *Code View* change app/class properties `N_Heater` and `N_TempSensor` to numbers of heaters and temperature sensors connected respectively.
* Run!
* In GUI, input correct serial port name (e.g. "COM1") and start the connection by turn on the switch.
* Enjoy!
