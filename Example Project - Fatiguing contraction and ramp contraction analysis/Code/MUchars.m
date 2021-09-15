function dat = MUchars(dat)
% MUchars
% Calculates discharge characteristics across whole file
% Calculates recruitment threshold & derecruitment threshold for each MU
% ------------------------------------------------------------------------

dat = dat;
fsamp = 2000;
% Calculate MU characteristics across entire time that MU is active

for mu = 1:length(dat.MUPulses)
    tempMU = dat.MUPulses{1,mu};
    diffs = diff(tempMU);
    % ISI in ms
       dat.orig_ISI{1,mu} = (diffs/fsamp)*1000;
       dat.orig_IDR{1,mu} = (1./dat.orig_ISI{1,mu})*1000;
            % Exclusion of non-physiological ISI values
            vec_ISI =dat.orig_ISI{1,mu};
            dat.ISI{1,mu} = vec_ISI(vec_ISI < 250 & vec_ISI > 50);
       dat.Mean_ISI(mu) = mean(dat.ISI{1,mu});
       dat.SD_ISI(mu) = std(dat.ISI{1,mu});
       dat.CV_ISI(mu) = (dat.SD_ISI(mu)/dat.Mean_ISI(mu))*100;
       % DR
       dat.IDR{1,mu} = (1./dat.ISI{1,mu})*1000;
       dat.Mean_DR(1,mu) = mean(dat.IDR{1,mu}); 
end

clear('tempMU','tempMU_sec','diffs','vec_ISI','mu');

%% Create binary matrices and calculate CST

% Make binary and calculate Cumulative Spike Train (CST)
hann_window = hann(800);

pulses = dat.MUPulses'; 
    len = length(dat.IPTs);
    dat.binary = zeros(length(pulses),(len));  
    % Loop through each MU
    for p = 1:length(pulses)                               
        for p2 = 1:length(pulses{p,1})                
            dat.binary(p,(pulses{p,1})) = 1;           
        end
    end  
    % Sum and smooth for each muscle
    dat.cst_unfilt = sum(dat.binary);
    dat.cst = conv(dat.cst_unfilt,hann_window,'same');
    clear('p','p2','m') 

%% Create Binary matrix with ISIs & DRs inserted at discharges (NaN for first)
    num = length(dat.MUPulses);
    dat.binary_ISI = zeros(num,size(dat.IPTs,2));
    % For each MU
    for i = 1:num
        dtimes = dat.MUPulses{1,i}';
        tempISI = dat.orig_ISI{1,i};
        % Don't use first ISI value! Insert NaN there instead.
        tempISI = [NaN,tempISI];
        % For each discharge
        for d = 1:length(dtimes)       
            ind = dtimes(d,1); 
            % Insert ISI at time of discharge (ind)
            dat.binary_ISI(i,ind) = tempISI(1,d);
            dat.binary_IDRs(i,ind) = (1./tempISI(1,d))*1000;
        end
    end
end
