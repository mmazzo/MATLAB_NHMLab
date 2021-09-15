% In a separate file, load all OTBio files and calculate EMG amps

% Load Quads_Data.mat but only keep force data
load('Quads_Data.mat');
clear MUdata OTBdata file time sync

%% Select folder containing VL OTBio files
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
        VL.(time).(contr).emg = file.emg;
        VL.(time).(contr).sync = file.analog(2,:);
end

% Rename fatiguing contraction
VL.fatiguing = VL.fatiguing.ramp30;

clear('f','dname','contr','files','name','time');


%% Select folder containing VM/RF OTBio files
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
        VM.(time).(contr).emg = file.emg(1:32,:);
        RF.(time).(contr).emg = file.emg(33:64,:);
        VM.(time).(contr).sync = file.analog(2,:);
        RF.(time).(contr).sync = file.analog(2,:);
end

% Rename fatiguing contraction
VM.fatiguing = VM.fatiguing.ramp30;
RF.fatiguing = RF.fatiguing.ramp30;

clear('f','dname','contr','files','name','time');

%% ------------------ Apply EMG calculations to VL data again -------------------
% FATIGUING CONTRACTION - VL 8x8 GRID
% Turn matrix into 8x8 cell array with channels in correct location
Ind = [1:8; 9:16; 17:24; 25:32; 33:40; 41:48; 49:56; 57:64]';
VL.fatiguing.SIG = {};

for r=1:size(Ind,1)
    for c=1:size(Ind,2)
        VL.fatiguing.SIG{r,c} = VL.fatiguing.emg(Ind(r,c),:);
    end
end

        % EMG filtering
        band = [20 500]/(1000);
        [B,A] = butter(2,band,'Bandpass'); % Band-pass filter
        wlen = 2000*0.5; % 0.5s window length
        for r = 1:8
            for c = 1:8
            VL.fatiguing.SIG_filt{r,c} = filtfilt(B,A, VL.fatiguing.SIG{r,c});
            end
        end

        % Calculate monopolar RMS amplitude
        for r = 1:8
            for c = 1:8
                VL.fatiguing.RMS{r,c} = sqrt(movmean(VL.fatiguing.SIG_filt{r,c} .^ 2, wlen));
            end
        end

        % Single differential by column
        for r = 1:8 % for each row
            VL.fatiguing.diffEMG.bycolumn{r,1} = VL.fatiguing.SIG_filt{r,1} - VL.fatiguing.SIG_filt{r,2};
            VL.fatiguing.diffEMG.bycolumn{r,2} = VL.fatiguing.SIG_filt{r,2} - VL.fatiguing.SIG_filt{r,3};
            VL.fatiguing.diffEMG.bycolumn{r,3} = VL.fatiguing.SIG_filt{r,3} - VL.fatiguing.SIG_filt{r,4};
            VL.fatiguing.diffEMG.bycolumn{r,4} = VL.fatiguing.SIG_filt{r,4} - VL.fatiguing.SIG_filt{r,5};
            VL.fatiguing.diffEMG.bycolumn{r,5} = VL.fatiguing.SIG_filt{r,5} - VL.fatiguing.SIG_filt{r,6};
            VL.fatiguing.diffEMG.bycolumn{r,6} = VL.fatiguing.SIG_filt{r,6} - VL.fatiguing.SIG_filt{r,7};
            VL.fatiguing.diffEMG.bycolumn{r,7} = VL.fatiguing.SIG_filt{r,7} - VL.fatiguing.SIG_filt{r,8};
            % RMS
            for c = 1:7
                VL.fatiguing.diffEMG.bycolumn_RMS{r,c} = sqrt(movmean(VL.fatiguing.diffEMG.bycolumn{r,c} .^ 2, wlen));
            end
        end

        % Double differential
        for c = 1:7 % for each column
            VL.fatiguing.diffEMG.double{1,c} = VL.fatiguing.diffEMG.bycolumn{1,c} - VL.fatiguing.diffEMG.bycolumn{2,c};
            VL.fatiguing.diffEMG.double{2,c} = VL.fatiguing.diffEMG.bycolumn{2,c} - VL.fatiguing.diffEMG.bycolumn{3,c};
            VL.fatiguing.diffEMG.double{3,c} = VL.fatiguing.diffEMG.bycolumn{3,c} - VL.fatiguing.diffEMG.bycolumn{4,c};
            VL.fatiguing.diffEMG.double{4,c} = VL.fatiguing.diffEMG.bycolumn{4,c} - VL.fatiguing.diffEMG.bycolumn{5,c};
            VL.fatiguing.diffEMG.double{5,c} = VL.fatiguing.diffEMG.bycolumn{5,c} - VL.fatiguing.diffEMG.bycolumn{6,c};
            VL.fatiguing.diffEMG.double{6,c} = VL.fatiguing.diffEMG.bycolumn{6,c} - VL.fatiguing.diffEMG.bycolumn{7,c};
            VL.fatiguing.diffEMG.double{7,c} = VL.fatiguing.diffEMG.bycolumn{7,c} - VL.fatiguing.diffEMG.bycolumn{8,c};
            % RMS amplitude calculation
            for r = 1:7
               VL.fatiguing.diffEMG.double_RMS{r,c} = sqrt(movmean(VL.fatiguing.diffEMG.double{r,c} .^ 2, wlen));
            end
        end

        %% Sum RMS amplitudes from all channels
        % monopolar
        count = 1;
        for r = 1:8
            for c = 1:8
                mono(count,:) = VL.fatiguing.RMS{r,c};
                count = count + 1;
            end
        end
        VL.fatiguing.RMS_sum = sum(mono);

        % single differential by column
        count = 1;
        for r = 1:8
            for c = 1:7
                sd(count,:) = VL.fatiguing.diffEMG.bycolumn_RMS{r,c};
                count = count + 1;
            end
        end
        VL.fatiguing.diffEMG.double_RMS_sum = sum(sd);

        % double differential
        count = 1;
        for r = 1:7
            for c = 1:7
                dd(count,:) = VL.fatiguing.diffEMG.double_RMS{r,c};
                count = count + 1;
            end
        end
        VL.fatiguing.diffEMG.double_RMS_sum = sum(dd);

        clear('sd','dd','mono','A','B','C','band','r','c','wlen');

%% FATIGUING CONTRACTIOSN VM & RF
VM = fatigueEMGcalcs8x4(VM);
RF = fatigueEMGcalcs8x4(RF);     

%% RAMP CONTRACTIONS
VL = rampEMGcalcs8x8(VL);
VM = rampEMGcalcs8x4(VM);
RF = rampEMGcalcs8x4(RF);

%% Visualize EMG from all muscles

% Fatiguing contraction
plot(VL.fatiguing.RMS_sum,'blue');
set(gcf,'Position',[100 700 1300 400]);
hold on;
plot(VM.fatiguing.RMS_sum,'red');
plot(RF.fatiguing.RMS_sum,'green');

%% Ramps
tiledlayout(4,2)
set(gcf,'Position',[100 700 1300 1300]);
nexttile
    plot(VL.pre.ramp10.RMS_sum,'blue');
    title('Pre - 10% MVC');
    hold on;
    plot(VM.pre.ramp10.RMS_sum,'red');
    plot(RF.pre.ramp10.RMS_sum,'green');
nexttile
    plot(VL.post.ramp10.RMS_sum,'blue');
    title('Post - 10% MVC');
    hold on;
    plot(VM.post.ramp10.RMS_sum,'red');
    plot(RF.post.ramp10.RMS_sum,'green');
nexttile
    plot(VL.pre.ramp20.RMS_sum,'blue');
    title('Pre - 20% MVC');
    hold on;
    plot(VM.pre.ramp20.RMS_sum,'red');
    plot(RF.pre.ramp20.RMS_sum,'green');
nexttile
    plot(VL.post.ramp20.RMS_sum,'blue');
    title('Post - 20% MVC');
    hold on;
    plot(VM.post.ramp20.RMS_sum,'red');
    plot(RF.post.ramp20.RMS_sum,'green');
nexttile
    plot(VL.pre.ramp30.RMS_sum,'blue');
    title('Pre - 30% MVC');
    hold on;
    plot(VM.pre.ramp30.RMS_sum,'red');
    plot(RF.pre.ramp30.RMS_sum,'green');
nexttile
    plot(VL.post.ramp30.RMS_sum,'blue');
    title('Post - 30% MVC');
    hold on;
    plot(VM.post.ramp30.RMS_sum,'red');
    plot(RF.post.ramp30.RMS_sum,'green');
nexttile
    plot(VL.pre.ramp40.RMS_sum,'blue');
    title('Pre - 40% MVC');
    hold on;
    plot(VM.pre.ramp40.RMS_sum,'red');
    plot(RF.pre.ramp40.RMS_sum,'green');
nexttile
    plot(VL.post.ramp40.RMS_sum,'blue');
    title('Post - 40% MVC');
    hold on;
    plot(VM.post.ramp40.RMS_sum,'red');
    plot(RF.post.ramp40.RMS_sum,'green');

% So it looks like the 10% contraction is the only one where the relative
% contributions from the three muscles is very different during Post

