function dat = SpikeTrigAv(dat)
% Spike triggered averaging monopolar (original) EMG signals
% -----------------------------------------------------------------

% For each MU
for mu = 1:length(dat.MUPulses)
temp = dat.MUPulses{1,mu};
    if isnan(temp)
    dat.MUAPs_mono{1,mu} = NaN;
    else
    % For each discharge
    for d = 1:length(temp)
        MUtemp = temp(1,d);
        % Across the whole grid
        for r = 1:8
            for c = 1:8
               % 50ms surrounding discharge time
               snap{r,c}(d,1:100) = dat.SIG_filt{r,c}(1,MUtemp-49:MUtemp+50);
            end
        end
    end
    % Average each channel
    for r = 1:8
        for c = 1:8
            MUAPs{r,c} = mean(snap{r,c});
        end
    end
    dat.MUAPs_mono{1,mu} = MUAPs;
    end
    % clear
    clear('mono','diff','snapMono','snapDiff','MUtemp','MUAPs');
end

% Single differential
for mu = 1:length(dat.MUPulses)
temp = dat.MUPulses{1,mu};
    if isnan(temp)
    dat.MUAPs_diff_bycolumn{1,mu} = NaN;
    else
    % For each discharge
    for d = 1:length(temp)
        MUtemp = temp(1,d);
        % Across the whole grid
        for r = 1:8
            for c = 1:7
               % 50ms surrounding discharge time
               snap{r,c}(d,1:100) = dat.diffEMG.bycolumn{r,c}(1,MUtemp-49:MUtemp+50);
            end
        end
    end
    % Average each channel
    for r = 1:8
        for c = 1:7
            MUAPs{r,c} = mean(snap{r,c});
        end
    end
    dat.MUAPs_diff_bycolumn{1,mu} = MUAPs;
    end
    % clear
    clear('mono','diff','snapMono','snapDiff','MUtemp','MUAPs');
end
    
% Double differential
for mu = 1:length(dat.MUPulses)
temp = dat.MUPulses{1,mu};
    if isnan(temp)
    dat.MUAPs_diff_double{1,mu} = NaN;
    else
    % For each discharge
    for d = 1:length(temp)
        MUtemp = temp(1,d);
        % Across the whole grid
        for r = 1:7
            for c = 1:7
               % 50ms surrounding discharge time
               snap{r,c}(d,1:100) = dat.diffEMG.double{r,c}(1,MUtemp-49:MUtemp+50);
            end
        end
    end
    % Average each channel
    for r = 1:7
        for c = 1:7
            MUAPs{r,c} = mean(snap{r,c});
        end
    end
    dat.MUAPs_diff_double{1,mu} = MUAPs;
    end
    % clear
    clear('mono','diff','snapMono','snapDiff','MUtemp','MUAPs');
end