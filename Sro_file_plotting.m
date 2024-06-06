clear all; clc; close all;
file_path = 'C:/Mohid Simulations - 3/res/Run1/OilOutput-1.sro';

file_id = fopen(file_path, 'r');

header_lines = textscan(file_id, '%s', 1, 'Delimiter', '\n');
header_line = header_lines{1}{1};

format_str = repmat('%f', 1, 36);
data = textscan(file_id, format_str);

fclose(file_id);


data_table = table(data{:}, 'VariableNames', {'Seconds', 'YY', 'MM', 'DD', 'hh', 'mm', 'ss', 'MassOil', 'VolOilBeached', 'VolumeBeached', 'VolumeOil', 'Volume', 'Area', 'TheoricalArea', 'Thickness', 'MEvaporated', 'VEvaporated', 'FMEvaporated', 'MDispersed', 'VDispersed', 'FMDispersed', 'MSedimented', 'VSedimented', 'FMSedimented', 'MDissolved', 'VDissolved', 'FMDissolved', 'MChemDisp', 'VChemDisp', 'FMChemDisp', 'MOilRecovered', 'VOilRecovered', 'FMOilRecovered', 'MWaterContent', 'VWaterContent', 'Density', 'Viscosity'});
disp(data_table(1:5, :));

figure;
hold on;
for i = 1:height(data_table)
  if ~any(isnan([data_table.VolOilBeached(i), data_table.VolumeOil(i), data_table.MEvaporated(i), data_table.Var21(i)]))
    
    minSeconds = min(data_table.DD(i));
    maxSeconds = max(data_table.DD(i));

    xlim([minSeconds, maxSeconds]); 
    
    plot(data_table.DD(i), data_table.VolOilBeached(i), 'o', 'DisplayName', 'VolOilBeached');
    
    hold on
    plot(data_table.DD(i), data_table.VolumeBeached(i), 's', 'DisplayName', 'VolumeBeached');
    
    hold on
    plot(data_table.DD(i), data_table.VEvaporated(i), '^', 'DisplayName', 'VEvaporated');
    
    hold on
    plot(data_table.DD(i), data_table.VDispersed(i), 'd', 'DisplayName', 'VDispersed');
    
    hold on
  end
end