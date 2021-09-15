% Quads Data Processing: FATIGUING CONTRACTION
%
% Motor unit activity characteristics
% EMG filtering
% Spike-triggered averaging
% --------------------------------

% If not already loaded:
%   load('Quads_data.mat');

%% -------------------------------- EMG amplitudes -------------------------------------

% EMG filtering
band = [20 500]/(1000);
[B,A] = butter(2,band,'Bandpass'); % Band-pass filter
wlen = 2000*0.5; % 0.5s window length
for r = 1:8
    for c = 1:8
    MUdata.fatiguing.SIG_filt{r,c} = filtfilt(B,A, MUdata.fatiguing.SIG{r,c});
    end
end

% Calculate monopolar RMS amplitude
for r = 1:8
    for c = 1:8
        MUdata.fatiguing.RMS{r,c} = sqrt(movmean(MUdata.fatiguing.SIG_filt{r,c} .^ 2, wlen));
    end
end

% Single differential by column
for r = 1:8 % for each row
    MUdata.fatiguing.diffEMG.bycolumn{r,1} = MUdata.fatiguing.SIG_filt{r,1} - MUdata.fatiguing.SIG_filt{r,2};
    MUdata.fatiguing.diffEMG.bycolumn{r,2} = MUdata.fatiguing.SIG_filt{r,2} - MUdata.fatiguing.SIG_filt{r,3};
    MUdata.fatiguing.diffEMG.bycolumn{r,3} = MUdata.fatiguing.SIG_filt{r,3} - MUdata.fatiguing.SIG_filt{r,4};
    MUdata.fatiguing.diffEMG.bycolumn{r,4} = MUdata.fatiguing.SIG_filt{r,4} - MUdata.fatiguing.SIG_filt{r,5};
    MUdata.fatiguing.diffEMG.bycolumn{r,5} = MUdata.fatiguing.SIG_filt{r,5} - MUdata.fatiguing.SIG_filt{r,6};
    MUdata.fatiguing.diffEMG.bycolumn{r,6} = MUdata.fatiguing.SIG_filt{r,6} - MUdata.fatiguing.SIG_filt{r,7};
    MUdata.fatiguing.diffEMG.bycolumn{r,7} = MUdata.fatiguing.SIG_filt{r,7} - MUdata.fatiguing.SIG_filt{r,8};
    % RMS
    for c = 1:7
        MUdata.fatiguing.diffEMG.bycolumn_RMS{r,c} = sqrt(movmean(MUdata.fatiguing.diffEMG.bycolumn{r,c} .^ 2, wlen));
    end
end

% Double differential
for c = 1:7 % for each column
    MUdata.fatiguing.diffEMG.double{1,c} = MUdata.fatiguing.diffEMG.bycolumn{1,c} - MUdata.fatiguing.diffEMG.bycolumn{2,c};
    MUdata.fatiguing.diffEMG.double{2,c} = MUdata.fatiguing.diffEMG.bycolumn{2,c} - MUdata.fatiguing.diffEMG.bycolumn{3,c};
    MUdata.fatiguing.diffEMG.double{3,c} = MUdata.fatiguing.diffEMG.bycolumn{3,c} - MUdata.fatiguing.diffEMG.bycolumn{4,c};
    MUdata.fatiguing.diffEMG.double{4,c} = MUdata.fatiguing.diffEMG.bycolumn{4,c} - MUdata.fatiguing.diffEMG.bycolumn{5,c};
    MUdata.fatiguing.diffEMG.double{5,c} = MUdata.fatiguing.diffEMG.bycolumn{5,c} - MUdata.fatiguing.diffEMG.bycolumn{6,c};
    MUdata.fatiguing.diffEMG.double{6,c} = MUdata.fatiguing.diffEMG.bycolumn{6,c} - MUdata.fatiguing.diffEMG.bycolumn{7,c};
    MUdata.fatiguing.diffEMG.double{7,c} = MUdata.fatiguing.diffEMG.bycolumn{7,c} - MUdata.fatiguing.diffEMG.bycolumn{8,c};
    % RMS amplitude calculation
    for r = 1:7
       MUdata.fatiguing.diffEMG.double_RMS{r,c} = sqrt(movmean(MUdata.fatiguing.diffEMG.double{r,c} .^ 2, wlen));
    end
end

%% Sum RMS amplitudes from all channels
% monopolar
count = 1;
for r = 1:8
    for c = 1:8
        mono(count,:) = MUdata.fatiguing.RMS{r,c};
        count = count + 1;
    end
end
MUdata.fatiguing.RMS_sum = sum(mono);

% single differential by column
count = 1;
for r = 1:8
    for c = 1:7
        sd(count,:) = MUdata.fatiguing.diffEMG.bycolumn_RMS{r,c};
        count = count + 1;
    end
end
MUdata.fatiguing.diffEMG.double_RMS_sum = sum(sd);

% double differential
count = 1;
for r = 1:7
    for c = 1:7
        dd(count,:) = MUdata.fatiguing.diffEMG.double_RMS{r,c};
        count = count + 1;
    end
end
MUdata.fatiguing.diffEMG.double_RMS_sum = sum(dd);

clear('sd','dd','mono','A','B','C','band','r','c','wlen');
%% Plot EMG amplitude and force
yyaxis left
plot(Forcedata.fatiguing);
set(gcf,'Position',[100 700 1300 400]);
yyaxis right
plot(MUdata.fatiguing.RMS_sum)

%% -------------------------------- MU characteristics -------------------------------------

% Calculate MU activity characteristics for every motor unit
MUdata.fatiguing = MUchars(MUdata.fatiguing);
    %% Visualize example motor unit
    mu = 2;
    scatter(MUdata.fatiguing.MUPulses{mu},[NaN,MUdata.fatiguing.IDR{mu}]);
    set(gcf,'Position',[100 700 1300 400]);
    title('Example Motor Unit');
    hold on;
    plot(MUdata.fatiguing.MUPulses{mu},[NaN,MUdata.fatiguing.IDR{mu}],'red')

%% Visualize a "raster" plot of all the active MUs
plotSpikeRaster(logical(MUdata.fatiguing.binary),'PlotType','vertline', 'VertSpikeHeight',0.5);
set(gcf,'Position',[100 700 1300 400]);

%% Spike triggered averaging for MUAP shapes
MUdata.fatiguing = SpikeTrigAv(MUdata.fatiguing);

    %% Visualize example motor unit 
    mu = 1;
    %  * * * Plot only one version at a time! * * *
        % Monopolar plot
        MUAPs_Plot(MUdata.fatiguing.MUAPs_mono{mu})
        % Single differential plot
        MUAPs_Plot(MUdata.fatiguing.MUAPs_diff_bycolumn{mu})
        % Double-differential plot
        MUAPs_Plot(MUdata.fatiguing.MUAPs_diff_double{mu})
        
%% Compare MUAPs from beginning and end of fatiguing contraction
% Using first 100 APs and last 100 APs from each MU to
%   investigate change in MUAP shape as the muscle "fatigues"
for mu = 1:length(MUdata.fatiguing.MUPulses)
    tempMU = MUdata.fatiguing.MUPulses{mu};
    if length(tempMU) < 200
        MUdata.fatiguing.early.MUPulses{mu} = NaN;
    else
        MUdata.fatiguing.early.MUPulses{mu} = tempMU(1:100);
        MUdata.fatiguing.late.MUPulses{mu} = tempMU(end-100:end);
    end
end

% Insert copies of filtered EMG signal
MUdata.fatiguing.early.SIG_filt = MUdata.fatiguing.SIG_filt;
MUdata.fatiguing.late.SIG_filt = MUdata.fatiguing.SIG_filt;
MUdata.fatiguing.early.diffEMG.bycolumn = MUdata.fatiguing.diffEMG.bycolumn;
MUdata.fatiguing.late.diffEMG.bycolumn = MUdata.fatiguing.diffEMG.bycolumn;
MUdata.fatiguing.early.diffEMG.double = MUdata.fatiguing.diffEMG.double;
MUdata.fatiguing.late.diffEMG.double = MUdata.fatiguing.diffEMG.double;

MUdata.fatiguing.early = SpikeTrigAv(MUdata.fatiguing.early);
MUdata.fatiguing.late = SpikeTrigAv(MUdata.fatiguing.late);

    %% Example comparison of MUAP shapes early and late in the fatiguing contr
    mu = 1;
    MUAPsComparePlot(MUdata.fatiguing.early.MUAPs_diff_double{mu},MUdata.fatiguing.late.MUAPs_diff_double{mu})

%% Smoothed Instantaneous discahrge rate (IDR) lines
MUdata.fatiguing = IDRlines(MUdata.fatiguing);

for l = 1:length(MUdata.fatiguing.lines)
    plot(MUdata.fatiguing.lines{l});
    set(gcf,'Position',[100 700 1300 400]);
    ylim([0 15]);
    hold on;
end

%% Fit each of the IDR lines with a trendline
for l = 1:length(MUdata.fatiguing.lines)
    % Exclude rising and falling edges at beginning and end of DR lines
    % Remove 1s on each end
    muline = MUdata.fatiguing.lines{l};
    inds = find(~isnan(muline));
    muline(inds(1):inds(1)+2000) = NaN;
    muline(inds(end)-2000:inds(end)) = NaN;
    % poly fit
    muline = muline(~isnan(muline));
    x = 1:length(muline);
    % Try out Polynomials of different orders:
    % 2nd through 9th order
    for o = 1:8
        p = polyfit(x,muline,(o+1));
        fitline{o} = polyval(p,x);
        residuals{o} = muline - fitline{o};
        res(o) = sum(abs(residuals{o}));
        plotlines{o} = horzcat(zeros(1,inds(1)),fitline{o});
        plotlines{o}(plotlines{o} == 0) = NaN ;
        % Save into data structure
        MUdata.fatiguing.fitline{l} = fitline;
        MUdata.fatiguing.plotlines{l} = plotlines;
        MUdata.fatiguing.res{l} = res;
    end
end

%% Plot polynomial order options over top of original smoothed IDR line
    % Example MU 1
    mu = 1;
    plot(MUdata.fatiguing.lines{mu},'Color',[0.8 0.8 0.8],'LineWidth',2.5);
    hold on;
    for pl = 1:8 % Plot all polynomial options
        plot(MUdata.fatiguing.plotlines{mu}{pl},'LineWidth',1);
        set(gcf,'Position',[100 700 1300 400]);
        hold on;
        legend('IDR','2','3','4','5','6','7','8','9','Location','southwest','NumColumns',3);
    end
%% Plot specific order polynomial for all MUs on same plot
order = 3;
for mu = 1:length(MUdata.fatiguing.plotlines)
    plot(MUdata.fatiguing.plotlines{mu}{order},'LineWidth',1);
    set(gcf,'Position',[300 700 1000 1000]);
    hold on;
end
%% Clean up workspace
clear('muline','ans','count','fitline','inds','o','p','pl','plotlines',...
    'res','residuals','tempMU','x','l','order','mu','times','j','ax','ind3');

%%
save('Quads_Data.mat');
