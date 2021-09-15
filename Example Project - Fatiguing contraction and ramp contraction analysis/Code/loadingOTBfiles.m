% Load force and OTB files
% ---------------------------------------------

load('Force_Quads_Data.mat')

% Select folder containing OTBio files
dname = uigetdir();
cd(dname)
% Get files
files = dir('*.otb+');
files = {files.name};
filepath = strcat(dname,'/');
% Load each file

for f = 1:length(files)
    file = ReadOTB(files{f},filepath);
    name = files{f};
    % Which contraction level?
        if contains(name,'10')
            contr = 'ramp10';
        elseif contains(name,'20')
            contr = 'ramp20';
        elseif contains(name,'30')
            contr = 'ramp30';
        elseif contains(name,'30')
            contr = 'ramp30';
            if contains(name,'3min')
                contr = 'fatiguing';
            end
        elseif contains(name,'40')
            contr = 'ramp40';
        end
     % Which contraction time?
        if contains(name,'post')
            time = 'post';
        elseif contains(name,'3min')
            time = 'fatiguing';
        else
            time = 'pre';
        end
% Create structure of sync and EMG data
        OTBdata.(time).(contr).emg = file.emg;
        OTBdata.(time).(contr).sync = file.analog(2,:);
end

% Rename fatiguing contraction
OTBdata.fatiguing = OTBdata.fatiguing.ramp30;

%% Change your current folder back to the main "Quads Data Processing" folder
% Save this file there:
save('Quads_Data.mat','OTBdata','force','sync');

clear
