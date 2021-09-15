% Aligning Quads Data
% --------------------------------
% Divide Force signal into different sections
% Use Sync signal from Force and original OTBio files to align all data
% Save

%% Load .mat file with quads + force data if not already loaded
load('Quads_Data.mat');

%% Use rising edge of sync squarewave, convert to 2000 Hz
sync.times = sync.times(4:2:end)*2000;

% Select sections of force data to use for each contraction
plot(force)
title('Click before and after each contraction, including the red Sync line:')
set(gcf,'Position',[100 700 1300 400])
for l = 1:length(sync.times)
    xline(sync.times(l),'red');
end
[times,~] = ginput(18);
times = round(times);
Forcedata.pre.ramp10 = force(times(1):times(2));
Forcedata.pre.ramp20 = force(times(3):times(4));
Forcedata.pre.ramp30 = force(times(5):times(6));
Forcedata.pre.ramp40 = force(times(7):times(8));
Forcedata.fatiguing = force(times(9):times(10));
Forcedata.post.ramp10 = force(times(11):times(12));
Forcedata.post.ramp20 = force(times(13):times(14));
Forcedata.post.ramp30 = force(times(15):times(16));
Forcedata.post.ramp40 = force(times(17):times(18));

%% Adjust Sync times for each contraction
Forcedata.sync.pre.ramp10 = sync.times(1)-times(1);
Forcedata.sync.pre.ramp20 = sync.times(2)-times(3);
Forcedata.sync.pre.ramp30 = sync.times(3)-times(5);
Forcedata.sync.pre.ramp40 = sync.times(4)-times(7);
Forcedata.sync.fatiguing = sync.times(5)-times(9);
Forcedata.sync.post.ramp10 = sync.times(6)-times(11);
Forcedata.sync.post.ramp20 = sync.times(7)-times(13);
Forcedata.sync.post.ramp30 = sync.times(8)-times(15);
Forcedata.sync.post.ramp40 = sync.times(9)-times(17);

%% Find OTB sync times
OTBdata.pre.ramp10.synctime = find(OTBdata.pre.ramp10.sync < 3300000,1,'last');
OTBdata.pre.ramp20.synctime = find(OTBdata.pre.ramp20.sync < 3300000,1,'last');
OTBdata.pre.ramp30.synctime = find(OTBdata.pre.ramp30.sync < 3300000,1,'last');
OTBdata.pre.ramp40.synctime = find(OTBdata.pre.ramp40.sync < 3300000,1,'last');
OTBdata.fatiguing.synctime = find(OTBdata.fatiguing.sync < 3300000,1,'last');
OTBdata.post.ramp10.synctime = find(OTBdata.post.ramp10.sync < 3300000,1,'last');
OTBdata.post.ramp20.synctime = find(OTBdata.post.ramp20.sync < 3300000,1,'last');
OTBdata.post.ramp30.synctime = find(OTBdata.post.ramp30.sync < 3300000,1,'last');
OTBdata.post.ramp40.synctime = find(OTBdata.post.ramp40.sync < 3300000,1,'last');

%% Load DEMUSE output file & match OTB sync & DEMUSE files to force sync times

% FATIGUING CONTR
    % Load DEMUSE file
    file = uigetfile('*.mat');
    DEMUSEoutput = load(file);
        MUdata.fatiguing.MUPulses = DEMUSEoutput.MUPulses;
        MUdata.fatiguing.IPTs = DEMUSEoutput.IPTs;
        MUdata.fatiguing.SIG = DEMUSEoutput.SIG;
        MUdata.fatiguing.ref_signal = DEMUSEoutput.ref_signal;
    % OTBdata and MUdata are same length    
    dif = round(Forcedata.sync.fatiguing - OTBdata.fatiguing.synctime);
    if dif > 0 % force is longer at front of file
        Forcedata.fatiguing = Forcedata.fatiguing(dif:end);
    else % OTBio data is longer at front of file
        buffer = zeros(dif,1);
        Forcedata.fatiguing = vertcat(buffer,Forcedata.fatiguing);
    end
    clear('dif','DEMUSEoutput','l','ans');

%% -------- 10% MVC --------
% 10 RAMP PRE
    % Load DEMUSE file
    file = uigetfile('*.mat');
    DEMUSEoutput = load(file);
        MUdata.pre.ramp10.MUPulses = DEMUSEoutput.MUPulses;
        MUdata.pre.ramp10.IPTs = DEMUSEoutput.IPTs;
        MUdata.pre.ramp10.SIG = DEMUSEoutput.SIG;
        MUdata.pre.ramp10.ref_signal = DEMUSEoutput.ref_signal;
    dif = round(Forcedata.sync.pre.ramp10 - OTBdata.pre.ramp10.synctime);
    if dif > 0 % force is longer at front of file
        Forcedata.pre.ramp10 = Forcedata.pre.ramp10(dif:end);
    else % OTBio data is longer at front of file
        buffer = zeros(dif,1);
        Forcedata.pre.ramp10 = vertcat(buffer,Forcedata.pre.ramp10);
    end
    clear('dif','DEMUSEoutput');

%% 10 RAMP POST
    % Load DEMUSE file
    file = uigetfile('*.mat');
    DEMUSEoutput = load(file);
        MUdata.post.ramp10.MUPulses = DEMUSEoutput.MUPulses;
        MUdata.post.ramp10.IPTs = DEMUSEoutput.IPTs;
        MUdata.post.ramp10.SIG = DEMUSEoutput.SIG;
        MUdata.post.ramp10.ref_signal = DEMUSEoutput.ref_signal;
    dif = round(Forcedata.sync.post.ramp10 - OTBdata.post.ramp10.synctime);
    if dif > 0 % force is longer at front of file
        Forcedata.post.ramp10 = Forcedata.post.ramp10(dif:end);
    else % OTBio data is longer at front of file
        buffer = zeros(dif,1);
        Forcedata.post.ramp10 = vertcat(buffer,Forcedata.post.ramp10);
    end
clear('dif','DEMUSEoutput');

%% ----------- 20% MVC -----------
% 20 RAMP PRE
    % Load DEMUSE file for 20% MVC Pre
    file = uigetfile('*.mat');
    DEMUSEoutput = load(file);
        MUdata.pre.ramp20.MUPulses = DEMUSEoutput.MUPulses;
        MUdata.pre.ramp20.IPTs = DEMUSEoutput.IPTs;
        MUdata.pre.ramp20.SIG = DEMUSEoutput.SIG;
        MUdata.pre.ramp20.ref_signal = DEMUSEoutput.ref_signal;
    dif = round(Forcedata.sync.pre.ramp20 - OTBdata.pre.ramp20.synctime);
    if dif > 0 % force is longer at front of file
        Forcedata.pre.ramp20 = Forcedata.pre.ramp20(dif:end);
    else % OTBio data is longer at front of file
        buffer = zeros(dif,1);
        Forcedata.pre.ramp20 = vertcat(buffer,Forcedata.pre.ramp20);
    end
    clear('dif','DEMUSEoutput');

%% 20 RAMP POST
    % Load DEMUSE file for 20% MVC Pre
    file = uigetfile('*.mat');
    DEMUSEoutput = load(file);
        MUdata.post.ramp20.MUPulses = DEMUSEoutput.MUPulses;
        MUdata.post.ramp20.IPTs = DEMUSEoutput.IPTs;
        MUdata.post.ramp20.SIG = DEMUSEoutput.SIG;
        MUdata.post.ramp20.ref_signal = DEMUSEoutput.ref_signal;
    dif = round(Forcedata.sync.post.ramp20 - OTBdata.post.ramp20.synctime);
    if dif > 0 % force is longer at front of file
        Forcedata.post.ramp20 = Forcedata.post.ramp20(dif:end);
    else % OTBio data is longer at front of file
        buffer = zeros(dif,1);
        Forcedata.post.ramp20 = vertcat(buffer,Forcedata.post.ramp20);
    end
clear('dif','DEMUSEoutput');

%%   ----------- 30% MVC -----------
% 30 RAMP PRE
    % Load DEMUSE file for 30% MVC Pre
    file = uigetfile('*.mat');
    DEMUSEoutput = load(file);
        MUdata.pre.ramp30.MUPulses = DEMUSEoutput.MUPulses;
        MUdata.pre.ramp30.IPTs = DEMUSEoutput.IPTs;
        MUdata.pre.ramp30.SIG = DEMUSEoutput.SIG;
        MUdata.pre.ramp30.ref_signal = DEMUSEoutput.ref_signal;
    dif = round(Forcedata.sync.pre.ramp30 - OTBdata.pre.ramp30.synctime);
    if dif > 0 % force is longer at front of file
        Forcedata.pre.ramp30 = Forcedata.pre.ramp30(dif:end);
    else % OTBio data is longer at front of file
        buffer = zeros(dif,1);
        Forcedata.pre.ramp30 = vertcat(buffer,Forcedata.pre.ramp30);
    end
    clear('dif','DEMUSEoutput');

%% 30 RAMP POST
    % Load DEMUSE file for 30% MVC Pre
    file = uigetfile('*.mat');
    DEMUSEoutput = load(file);
        MUdata.post.ramp30.MUPulses = DEMUSEoutput.MUPulses;
        MUdata.post.ramp30.IPTs = DEMUSEoutput.IPTs;
        MUdata.post.ramp30.SIG = DEMUSEoutput.SIG;
        MUdata.post.ramp30.ref_signal = DEMUSEoutput.ref_signal;
    dif = round(Forcedata.sync.post.ramp30 - OTBdata.post.ramp30.synctime);
    if dif > 0 % force is longer at front of file
        Forcedata.post.ramp30 = Forcedata.post.ramp30(dif:end);
    else % OTBio data is longer at front of file
        buffer = zeros(dif,1);
        Forcedata.post.ramp30 = vertcat(buffer,Forcedata.post.ramp30);
    end
clear('dif','DEMUSEoutput');


%%   ----------- 40% MVC -----------
% 40 RAMP PRE
    % Load DEMUSE file for 40% MVC Pre
    file = uigetfile('*.mat');
    DEMUSEoutput = load(file);
        MUdata.pre.ramp40.MUPulses = DEMUSEoutput.MUPulses;
        MUdata.pre.ramp40.IPTs = DEMUSEoutput.IPTs;
        MUdata.pre.ramp40.SIG = DEMUSEoutput.SIG;
        MUdata.pre.ramp40.ref_signal = DEMUSEoutput.ref_signal;
    dif = round(Forcedata.sync.pre.ramp40 - OTBdata.pre.ramp40.synctime);
    if dif > 0 % force is longer at front of file
        Forcedata.pre.ramp40 = Forcedata.pre.ramp40(dif:end);
    else % OTBio data is longer at front of file
        buffer = zeros(dif,1);
        Forcedata.pre.ramp40 = vertcat(buffer,Forcedata.pre.ramp40);
    end
    clear('dif','DEMUSEoutput');

%% 40 RAMP POST
    % Load DEMUSE file for 40% MVC Pre
    file = uigetfile('*.mat');
    DEMUSEoutput = load(file);
        MUdata.post.ramp40.MUPulses = DEMUSEoutput.MUPulses;
        MUdata.post.ramp40.IPTs = DEMUSEoutput.IPTs;
        MUdata.post.ramp40.SIG = DEMUSEoutput.SIG;
        MUdata.post.ramp40.ref_signal = DEMUSEoutput.ref_signal;
    dif = round(Forcedata.sync.post.ramp40 - OTBdata.post.ramp40.synctime);
    if dif > 0 % force is longer at front of file
        Forcedata.post.ramp40 = Forcedata.post.ramp40(dif:end);
    else % OTBio data is longer at front of file
        buffer = zeros(dif,1);
        Forcedata.post.ramp40 = vertcat(buffer,Forcedata.post.ramp40);
    end
clear('dif','DEMUSEoutput');


%% Check alignment with raw EMG signals
figure(1)
tiledlayout(2,2)
nexttile
    yyaxis right
    title('Ramp 10 Pre');
    plot(Forcedata.pre.ramp10);
    yyaxis left
    plot(OTBdata.pre.ramp10.emg(1,:));
nexttile
    yyaxis right
    title('Ramp 20 Pre');
    plot(Forcedata.pre.ramp20);
    yyaxis left
    plot(OTBdata.pre.ramp20.emg(1,:));
nexttile
    yyaxis right
    title('Ramp 30 Pre');
    plot(Forcedata.pre.ramp30);
    yyaxis left
    plot(OTBdata.pre.ramp30.emg(1,:));
nexttile
    yyaxis right
    title('Ramp 40 Pre');
    plot(Forcedata.pre.ramp40);
    yyaxis left
    plot(OTBdata.pre.ramp40.emg(1,:));
    

figure(2)

tiledlayout(2,2)
nexttile
    yyaxis right
    title('Ramp 10 Post');
    plot(Forcedata.post.ramp10);
    yyaxis left
    plot(OTBdata.post.ramp10.emg(1,:));
nexttile
    yyaxis right
    title('Ramp 20 Post');
    plot(Forcedata.post.ramp20);
    yyaxis left
    plot(OTBdata.post.ramp20.emg(1,:));
nexttile
    yyaxis right
    title('Ramp 30 Post');
    plot(Forcedata.post.ramp30);
    yyaxis left
    plot(OTBdata.post.ramp30.emg(1,:));
nexttile
    yyaxis right
    title('Ramp 40 Post');
    plot(Forcedata.post.ramp40);
    yyaxis left
    plot(OTBdata.post.ramp40.emg(1,:));
    
figure(3)
yyaxis right
plot(Forcedata.fatiguing);
yyaxis left
plot(OTBdata.fatiguing.emg(1,:));


%%
save('Quads_Data.mat','sync','OTBdata','MUdata','Forcedata','force')
