classdef test_Utility_LS336 < handle
    properties
        Timer
        N_Counter
        CtrlGUI
        
        
        Heater_Percentage_Plot = [];
        Heater_Percentage_Buffer = [];
        Temp_Plot = [];
        Temp_Buffer = [];
        Time_Plot = [];
        Time_Buffer = [];
        
        Clear_Plot = 0;
    end
    methods
        function obj = test_Utility_LS336(In_CtrlGUI)
            obj.CtrlGUI = In_CtrlGUI;
            if obj.CtrlGUI.N_Heater == 1
                obj.CtrlGUI.Heater2LevelDropDown.Visible = 'off';
                obj.CtrlGUI.Heater2LevelDropDownLabel.Visible = 'off';
                obj.CtrlGUI.Heater2Lamp.Visible = 'off';
                obj.CtrlGUI.Heater2LampLabel.Visible = 'off';
            end
            %%%
            % Hide extra heater settings if there is only one heater
            % connected.
            
            obj.Timer = timer( ...
                    'Period', obj.CtrlGUI.RefreshIntervalsSpinner.Value, ...
                    'ExecutionMode', 'fixedRate');
            obj.Timer.TimerFcn = @obj.timerFunc;
            obj.Timer.ErrorFcn = @obj.timerErrFunc;
                
            obj.disable_Controls();
            %%%
            % Disable controls before connection.
        end
        
        function delete(obj)
            if isfield(obj, 'Timer')
                obj.disconnect_Controller();
            end
            delete(obj.Timer);
        end
        
        %% Enable *All* App Controls
        % This function enables all app controls.
        
        function enable_Controls(obj)
            control_names = fieldnames(obj.CtrlGUI);
            for n = 1 : length(control_names)
                if isprop(obj.CtrlGUI.(control_names{n}), 'Enable')
                    obj.CtrlGUI.(control_names{n}).Enable = 'on';
                end
            end
        end
        
        
        %% Disable *All* App Controls
        % This function disables all app controls when there is nothing
        % connected to the computer.
        
        function disable_Controls(obj)
            control_names = fieldnames(obj.CtrlGUI);
            for n = 1 : length(control_names)
                if isprop(obj.CtrlGUI.(control_names{n}), 'Enable')
                    obj.CtrlGUI.(control_names{n}).Enable = 'off';
                end
            end
                      
            obj.CtrlGUI.LeftPanel.Enable = 'on';
            obj.CtrlGUI.UserInputsPanel.Enable = 'on';            
            
            obj.CtrlGUI.SerialPortEditField.Enable = 'on';
            obj.CtrlGUI.SerialPortEditFieldLabel.Enable = 'on';
            obj.CtrlGUI.ConnectionOnOffSwitch.Enable = 'on';
            obj.CtrlGUI.ConnectionOnOffSwitchLabel.Enable = 'on';
            
            obj.CtrlGUI.ConnectionOnOffSwitch.Value = 'Off';
            obj.CtrlGUI.LoggingOnOffSwitch.Value = 'Off';
            %%%
            % Re-enable the pannels, swtiches and edit fields for 
            % connections.
            %
            % Set both Connection ON/OFF and Logging ON/OFF buttons to 
            % 'Off' state ('Off''s first letter must be capitalized --- I 
            % know it is dumb, but one has to match exactly.)
            % 
            
        end
        function timerErrFunc(obj, ~, ~)
            obj.Timer.stop();
        end
        %% Timer Function
        
        function timerFunc(obj, ~, ~)
            %%%
            % There has to be two inputs for timer function.
            
            plot_Length = obj.CtrlGUI.MaxPlottingPointsSpinner.Value;
            heater_Percentage = rand(1, obj.CtrlGUI.N_Heater) * 100;
            temp = 270 + rand(1, obj.CtrlGUI.N_TempSensor) * 60;
            
            obj.CtrlGUI.HeaterPercentageEditField.Value ...
                = mean(heater_Percentage);
            obj.CtrlGUI.HeaterPercentageGauge.Value ...
                = mean(heater_Percentage);
            
            obj.CtrlGUI.TempCurrentEditField.Value = mean(temp);
            obj.CtrlGUI.CurrentTempGauge.Value = mean(temp);
            
            obj.Time_Plot = [obj.Time_Plot; now];
            obj.Heater_Percentage_Plot ...
                = [obj.Heater_Percentage_Plot; heater_Percentage];
            obj.Temp_Plot = [obj.Temp_Plot; temp];
            
            if length(obj.Time_Plot) > plot_Length
                obj.Time_Plot = obj.Time_Plot(end + 1 - plot_Length : end);
                obj.Heater_Percentage_Plot ...
                    = obj.Heater_Percentage_Plot( ...
                    end + 1 - plot_Length : end, :);
                obj.Temp_Plot ...
                    = obj.Temp_Plot(end + 1 - plot_Length : end, :);
            end
            
            if obj.Clear_Plot == 1
                obj.Time_Plot = [];
                obj.Heater_Percentage_Plot = [];
                obj.Temp_Plot = [];
                obj.Clear_Plot = 0;
            end
            %%%
            % Clear the plot if the flag Clear_Plot is set.
            
            if length(obj.Time_Plot) > 1
                obj.plot_Format(obj.CtrlGUI.HeaterPercentageUIAxes, ...
                    obj.Time_Plot, obj.Heater_Percentage_Plot, ...
                    'HeaterPercentage');
                obj.plot_Format(obj.CtrlGUI.TempCurrentUIAxes, ...
                    obj.Time_Plot, obj.Temp_Plot, ...
                    'Temp');
            end
        end
        
        %% Change Refresh Inteval
        
        function change_RefreshInteval(obj, In_Event)
            obj.Timer.stop();
            obj.Timer.Period = In_Event.Value;
            obj.Timer.start();
        end
        
        %% Clear Plots
        % Clear the plots when Clear Plot button is pushed.
        
        function clear_Plot(obj)
            obj.Clear_Plot = 1;
            %%%
            % Set the flag.
            
            cla(obj.CtrlGUI.HeaterPercentageUIAxes);
            cla(obj.CtrlGUI.TempCurrentUIAxes);
            %%%
            % Clear the axes.
        end
        
        %% Connect Heater Controller
        % This function connects the heater controller by creating an
        % instance of class_Driver_LS336 class.
        
        function connect_Controller(obj)
            obj.Timer.start();
            obj.enable_Controls();
        end
        
        %% Disonnect Heater Controller
        % This function disconnects the heater controller by first
        % terminating the serial connection, then delete the Driver class
        % all together.
        
        function disconnect_Controller(obj)
            obj.Timer.stop();
            obj.disable_Controls();
        end
        
        function send_Settings(~, ~)
        end
        
        %% Format Plots
        % Format the plots such that the ticks and labels are always
        % suitable for current data.
        
        function plot_Format(~, In_Axes, In_Time, In_Data, In_Type)
            plot(In_Axes, In_Time, In_Data, 'LineWidth', 1.5)
            switch In_Type
                case 'Temp'
                    labels = cellstr( ...
                        char(64 + transpose(1 : size(In_Data, 2))))';
                case 'HeaterPercentage'
                    labels = cellstr(string(1 : size(In_Data, 2)));
            end
            plot_Legend = legend(In_Axes, labels);
            
            plot_Legend.Box = 'off';
            plot_Legend.FontSize = 9;
            
            In_Axes.XLim = [min(In_Time), max(In_Time)];
            In_Axes.YLim = [min(In_Data, [], 'all'), ...
                max(In_Data, [], 'all')];
            In_Axes.XTickMode = 'auto';
            In_Axes.YTickMode = 'auto';
            In_Axes.XAxis.TickLabelRotation = 60;
            if range(In_Time) < 1 / 24 % Hour
                datetick(In_Axes, 'x', 'MM:SS')
                In_Axes.XLabel.String = "Time (MM:SS)";
            elseif range(In_Time) < 1 % Day
                datetick(In_Axes, 'x', 'HH:MM')
                In_Axes.XLabel.String = "Time (HH:MM)";
            else
                datetick(In_Axes, 'x', 'mm/dd')
                In_Axes.XLabel.String = "Date (mm/dd)";
            end
        end
    end
end