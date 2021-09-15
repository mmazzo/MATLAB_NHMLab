% Quads Data Processing: RAMP CONTRACTIONS
%
% Motor unit activity characteristics
% EMG filtering
% Spike-triggered averaging
% --------------------------------

% If not already loaded:
%   load('Quads_data.mat');


% Run script for each FORCE LEVEL...

    ramp = 'ramp40'; % change this to ramp20, ramp30, ramp40 (but do pre & post for each)

% ... once for each TIMEPOINT:

    %time = 'pre';    % change this to post once you've done with pre
    time = 'post';
    
        %% -------------------------------- EMG amplitudes -------------------------------------

        % EMG filtering
        band = [20 500]/(1000);
        [B,A] = butter(2,band,'Bandpass'); % Band-pass filter
        wlen = 2000*0.5; % 0.5s window length
        for r = 1:8
            for c = 1:8
            MUdata.(time).(ramp).SIG{r,c} = MUdata.(time).(ramp).SIG{r,c}(1:length(MUdata.(time).(ramp).ref_signal));
            MUdata.(time).(ramp).SIG_filt{r,c} = filtfilt(B,A, MUdata.(time).(ramp).SIG{r,c});
            end
        end

        % Calculate monopolar RMS amplitude
        for r = 1:8
            for c = 1:8
                MUdata.(time).(ramp).RMS{r,c} = sqrt(movmean(MUdata.(time).(ramp).SIG_filt{r,c} .^ 2, wlen));
            end
        end

        % Single differential by column 
        for r = 1:8 % for each row
            MUdata.(time).(ramp).diffEMG.bycolumn{r,1} = MUdata.(time).(ramp).SIG_filt{r,1} - MUdata.(time).(ramp).SIG_filt{r,2};
            MUdata.(time).(ramp).diffEMG.bycolumn{r,2} = MUdata.(time).(ramp).SIG_filt{r,2} - MUdata.(time).(ramp).SIG_filt{r,3};
            MUdata.(time).(ramp).diffEMG.bycolumn{r,3} = MUdata.(time).(ramp).SIG_filt{r,3} - MUdata.(time).(ramp).SIG_filt{r,4};
            MUdata.(time).(ramp).diffEMG.bycolumn{r,4} = MUdata.(time).(ramp).SIG_filt{r,4} - MUdata.(time).(ramp).SIG_filt{r,5};
            MUdata.(time).(ramp).diffEMG.bycolumn{r,5} = MUdata.(time).(ramp).SIG_filt{r,5} - MUdata.(time).(ramp).SIG_filt{r,6};
            MUdata.(time).(ramp).diffEMG.bycolumn{r,6} = MUdata.(time).(ramp).SIG_filt{r,6} - MUdata.(time).(ramp).SIG_filt{r,7};
            MUdata.(time).(ramp).diffEMG.bycolumn{r,7} = MUdata.(time).(ramp).SIG_filt{r,7} - MUdata.(time).(ramp).SIG_filt{r,8};
            % RMS
            for c = 1:7
                MUdata.(time).(ramp).diffEMG.bycolumn_RMS{r,c} = sqrt(movmean(MUdata.(time).(ramp).diffEMG.bycolumn{r,c} .^ 2, wlen));
            end
        end

        % Double differential
        for c = 1:7 % for each column
            MUdata.(time).(ramp).diffEMG.double{1,c} = MUdata.(time).(ramp).diffEMG.bycolumn{1,c} - MUdata.(time).(ramp).diffEMG.bycolumn{2,c};
            MUdata.(time).(ramp).diffEMG.double{2,c} = MUdata.(time).(ramp).diffEMG.bycolumn{2,c} - MUdata.(time).(ramp).diffEMG.bycolumn{3,c};
            MUdata.(time).(ramp).diffEMG.double{3,c} = MUdata.(time).(ramp).diffEMG.bycolumn{3,c} - MUdata.(time).(ramp).diffEMG.bycolumn{4,c};
            MUdata.(time).(ramp).diffEMG.double{4,c} = MUdata.(time).(ramp).diffEMG.bycolumn{4,c} - MUdata.(time).(ramp).diffEMG.bycolumn{5,c};
            MUdata.(time).(ramp).diffEMG.double{5,c} = MUdata.(time).(ramp).diffEMG.bycolumn{5,c} - MUdata.(time).(ramp).diffEMG.bycolumn{6,c};
            MUdata.(time).(ramp).diffEMG.double{6,c} = MUdata.(time).(ramp).diffEMG.bycolumn{6,c} - MUdata.(time).(ramp).diffEMG.bycolumn{7,c};
            MUdata.(time).(ramp).diffEMG.double{7,c} = MUdata.(time).(ramp).diffEMG.bycolumn{7,c} - MUdata.(time).(ramp).diffEMG.bycolumn{8,c};
            % RMS amplitude calculation
            for r = 1:7
               MUdata.(time).(ramp).diffEMG.double_RMS{r,c} = sqrt(movmean(MUdata.(time).(ramp).diffEMG.double{r,c} .^ 2, wlen));
            end
        end

        %% Sum RMS amplitudes from all channels
        % monopolar
        count = 1;
        for r = 1:8
            for c = 1:8
                mono(count,:) = MUdata.(time).(ramp).RMS{r,c};
                count = count + 1;
            end
        end
        MUdata.(time).(ramp).RMS_sum = sum(mono);

        % single differential by column
        count = 1;
        for r = 1:8
            for c = 1:7
                sd(count,:) = MUdata.(time).(ramp).diffEMG.bycolumn_RMS{r,c};
                count = count + 1;
            end
        end
        MUdata.(time).(ramp).diffEMG.double_RMS_sum = sum(sd);

        % double differential
        count = 1;
        for r = 1:7
            for c = 1:7
                dd(count,:) = MUdata.(time).(ramp).diffEMG.double_RMS{r,c};
                count = count + 1;
            end
        end
        MUdata.(time).(ramp).diffEMG.double_RMS_sum = sum(dd);

        clear('sd','dd','mono','A','B','C','band','r','c','wlen');
        %% Plot EMG amplitude and force
        yyaxis left
        plot(Forcedata.(time).(ramp));
        set(gcf,'Position',[100 700 1300 400]);
        yyaxis right
        plot(MUdata.(time).(ramp).diffEMG.double_RMS_sum)

        %% -------------------------------- MU characteristics -------------------------------------

        % Calculate MU activity characteristics for every motor unit
        MUdata.(time).(ramp) = MUchars(MUdata.(time).(ramp));
            % Visualize example motor unit
            mu = 1;
            scatter(MUdata.(time).(ramp).MUPulses{mu},[NaN,MUdata.(time).(ramp).orig_IDR{mu}]);
            set(gcf,'Position',[100 700 1300 400]);
            title('Example Motor Unit');
            hold on;
            plot(MUdata.(time).(ramp).MUPulses{mu},[NaN,MUdata.(time).(ramp).orig_IDR{mu}],'red')

        %% Visualize a "raster" plot of all the active MUs
        plotSpikeRaster(logical(MUdata.(time).(ramp).binary),'PlotType','vertline', 'VertSpikeHeight',0.5);
        set(gcf,'Position',[100 700 1300 400]);

        
        %% Calculate mean DR and other metrics across steady portion of contraction
        plot(Forcedata.(time).(ramp));
        title('Select steady portion of contraction');
        [times,vals] = ginput(2);
        for mu = 1:length(MUdata.(time).(ramp).MUPulses)
            % Get indices of data within window
            temp = MUdata.(time).(ramp).MUPulses{mu};
            if isempty(temp)
            else
                ind2 = temp(times(2) < temp); 
                if isempty(ind2)
                    ind2 = length(temp)-1;
                else
                    ind2 = ind2(1);
                    ind2 = round(find(temp == ind2));
                end
                ind1 = temp(temp < times(1));
                if isempty(ind1)
                    ind1 = temp(1);
                else
                    ind1 = ind1(end);
                end 
                
                ind1 = round(find(temp == ind1));
            % Save indices and data points
            MUdata.(time).(ramp).steady.start = times(1);
            MUdata.(time).(ramp).steady.endd = times(2);
            MUdata.(time).(ramp).steady.pulseind = ind1;
            MUdata.(time).(ramp).steady.pulseind = ind2;
            % MU characterictics
            if length(MUdata.(time).(ramp).IDR{1,mu}) < ind2
                ind3 = length(MUdata.(time).(ramp).IDR{1,mu});
            MUdata.(time).(ramp).steady.Mean_DR(1,mu) = mean(MUdata.(time).(ramp).IDR{1,mu}(ind1:ind3));
            MUdata.(time).(ramp).steady.Mean_ISI(1,mu) = mean(MUdata.(time).(ramp).ISI{1,mu}(ind1:ind3));
            else
            MUdata.(time).(ramp).steady.Mean_DR(1,mu) = mean(MUdata.(time).(ramp).IDR{1,mu}(ind1:ind2));
            MUdata.(time).(ramp).steady.Mean_ISI(1,mu) = mean(MUdata.(time).(ramp).ISI{1,mu}(ind1:ind2));
            end
            end
        end
            % EMG
            MUdata.(time).(ramp).steady.Mean_RMS = mean(MUdata.(time).(ramp).RMS_sum(times(1):times(2)));
            MUdata.(time).(ramp).steady.diffEMG.double_Mean_RMS = mean(MUdata.(time).(ramp).diffEMG.double_RMS_sum(times(1):times(2)));
            % Force
            Forcedata.(time).steady.(ramp).Mean = mean(Forcedata.(time).(ramp)(times(1):times(2)));
            Forcedata.(time).steady.(ramp).CV = (std(Forcedata.(time).(ramp)(times(1):times(2)))/Forcedata.(time).steady.(ramp).Mean)*100;
            
        clear('ind1','ind2','mu','temp','times','vals','ans');
        %% Spike triggered averaging for MUAP shapes
        MUdata.(time).(ramp) = SpikeTrigAv(MUdata.(time).(ramp));

            %% Visualize example motor unit 
            mu = 1;
            %  * * * Plot only one version at a time! * * *
                % Monopolar plot
                MUAPs_Plot(MUdata.(time).(ramp).MUAPs_mono{mu})
                % Single differential plot
                MUAPs_Plot(MUdata.(time).(ramp).MUAPs_diff_bycolumn{mu})
                % Double-differential plot
                MUAPs_Plot(MUdata.(time).(ramp).MUAPs_diff_double{mu})


        %% Smoothed Instantaneous discahrge rate (IDR) lines
        MUdata.(time).(ramp) = IDRlines(MUdata.(time).(ramp));

        for l = 1:length(MUdata.(time).(ramp).lines)
            plot(MUdata.(time).(ramp).lines{l});
            set(gcf,'Position',[100 700 1300 400]);
            ylim([0 15]);
            hold on;
        end

        %% Fit each of the IDR lines with a trendline
        for l = 1:length(MUdata.(time).(ramp).lines)
            % Exclude rising and falling edges at beginning and end of DR lines
            % Remove 1s on each end
            muline = MUdata.(time).(ramp).lines{l};
            if isempty(muline)
            else
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
                MUdata.(time).(ramp).fitline{l} = fitline;
                MUdata.(time).(ramp).plotlines{l} = plotlines;
                MUdata.(time).(ramp).res{l} = res;
            end
            end
        end

        %% Plot polynomial order options over top of original smoothed IDR line
            % Example MU 1
            mu = 1;
            plot(MUdata.(time).(ramp).lines{mu},'Color',[0.8 0.8 0.8],'LineWidth',2.5);
            hold on;
            for pl = 1:8 % Plot all polynomial options
                plot(MUdata.(time).(ramp).plotlines{mu}{pl},'LineWidth',1);
                set(gcf,'Position',[100 700 1300 400]);
                hold on;
                legend('IDR','2','3','4','5','6','7','8','9','Location','southwest','NumColumns',3);
            end
        %% Plot specific order polynomial for all MUs on same plot
        order = 3;
        for mu = 1:length(MUdata.(time).(ramp).plotlines)
            if isempty(MUdata.(time).(ramp).plotlines{mu})
            else
            plot(MUdata.(time).(ramp).plotlines{mu}{order},'LineWidth',1);
            set(gcf,'Position',[300 700 1000 1000]);
            hold on;
            end
        end
        
       %% Determine recruitment thresholds for identified MUs 
        
       % Find RT
% Window parameters
win = 0.5;      % Number of seconds desired for window (10s)
window = win*2000; % Convert time to # data points
jump = 2000/1000;   % Steps between each 0.5s window (1ms)
len = length(MUdata.(time).(ramp).IPTs);  % # of seconds to analyze CV for ISI after the first discharge

% For each MU
for l = 1:length(MUdata.(time).(ramp).MUPulses)
    if isempty(MUdata.(time).(ramp).MUPulses{l})
    else
        tempMU = MUdata.(time).(ramp).binary_ISI(l,:);
        tempMU(isnan(tempMU)) = 0;
        sweeps1 = floor((len-window)/jump); % Number of loops needed
        start = MUdata.(time).(ramp).MUPulses{1,l}(1,1);
        % For loop to calculate < 50% CV for ISI
        for i = 1:sweeps1
          % Get rid of zeros
                s1 = round(start+(jump*i));
                s2 = round((start+(jump*i))+window)-1;
                if s2 > length(MUdata.(time).(ramp).IPTs)
                else
                    sec = tempMU(1,s1:s2);
                    tempISIs = nonzeros(sec);
                    if isempty(tempISIs) == 1
                    else
                    % Calculate CV for ISI based on ISIs in this window
                    tempmean = mean(tempISIs);
                    mean1(i,1) = tempmean;
                    tempsd = std(tempISIs);
                    sd1(i,1) = tempsd;
                    cv1(i,1) = (tempsd/tempmean)*100;
                    end
                end
        end

        % Recruitment
            % Find first location of CV < 50% for this MU
            cv1(cv1==0) = NaN;
            [sweepnum] = find(cv1 < 50,1,'first');

            % Find first discharge within that window
            RT_loc = ((sweepnum*jump)+start)-jump;
            MUdata.(time).(ramp).RTs.ind(l,1) = RT_loc;

        % Derecruitment
            % Find last location of CV < 50% for this MU
            [sweepnumDe] = find(cv1 < 50,1,'last');
            % Find last discharge within that window
            DRT_loc = ((sweepnumDe*jump)+start)-jump;
            MUdata.(time).(ramp).DRTs.ind(l,1) = DRT_loc;

        clear('mean1','sd1','cv1','tempMU');
    end
end


clear('i','l','cv1','sweepnum','RT_loc','tempMU','sweeps1','sec',...
    'tempISIs','mean1','tempsd','sd1','jump','len','s1','s2',...
    'start','tempmean','win','window','sweepnumDe','ans');
 
        
%% Reorder Mus based on recruitment
% Reorder all MUs (based on binary matrices)
% All
    order = zeros(size(MUdata.(time).(ramp).binary,1),1);
    for j = 1:size(MUdata.(time).(ramp).binary,1)
        if nnz(MUdata.(time).(ramp).binary(j,:)) == 0
            order(j,1) = 0;  
        else
            order(j,1) = find(MUdata.(time).(ramp).binary(j,:),1,'first');
        end
    end
        % MU_order:  i.e. "15, 4..." = 1st row is original MU15, 2n row is old MU4...
        [~,MUdata.(time).(ramp).order] = sortrows(order,'descend');
        MUdata.(time).(ramp).binary_ordered = MUdata.(time).(ramp).binary(MUdata.(time).(ramp).order,:);

        %% Clean up workspace
        clear('muline','ans','count','fitline','inds','o','p','pl','plotlines',...
            'res','residuals','tempMU','x','l','order','mu','times','j','DRT_loc');


%% Save (then re-run for other force levels/timepoints)
save('Quads_Data.mat');
