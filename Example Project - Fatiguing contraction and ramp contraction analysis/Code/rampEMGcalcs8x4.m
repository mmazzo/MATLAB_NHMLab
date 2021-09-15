function dat = rampEMGcalcs8x4(dat)
dat = dat;

times = {'pre','post'};
contrs = {'ramp10','ramp20','ramp30','ramp40'};

for t = 1:2
    time = times{t};
    for con = 1:4
        contr = contrs{con};
        % Turn matrix into 8x4 cell array with channels in correct location
        Ind = [1:8; 9:16; 17:24; 25:32]';
        dat.(time).(contr).SIG = {};

        for r=1:size(Ind,1)
            for c=1:size(Ind,2)
                dat.(time).(contr).SIG{r,c} = dat.(time).(contr).emg(Ind(r,c),:);
            end
        end
                % EMG filtering
                band = [20 500]/(1000);
                [B,A] = butter(2,band,'Bandpass'); % Band-pass filter
                wlen = 2000*0.5; % 0.5s window length
                for r = 1:8
                    for c = 1:4
                    dat.(time).(contr).SIG_filt{r,c} = filtfilt(B,A, dat.(time).(contr).SIG{r,c});
                    end
                end

                % Calculate monopolar RMS amplitude
                for r = 1:8
                    for c = 1:4
                        dat.(time).(contr).RMS{r,c} = sqrt(movmean(dat.(time).(contr).SIG_filt{r,c} .^ 2, wlen));
                    end
                end

                % Single differential by column
                for r = 1:8 % for each row
                    dat.(time).(contr).diffEMG.bycolumn{r,1} = dat.(time).(contr).SIG_filt{r,1} - dat.(time).(contr).SIG_filt{r,2};
                    dat.(time).(contr).diffEMG.bycolumn{r,2} = dat.(time).(contr).SIG_filt{r,2} - dat.(time).(contr).SIG_filt{r,3};
                    dat.(time).(contr).diffEMG.bycolumn{r,3} = dat.(time).(contr).SIG_filt{r,3} - dat.(time).(contr).SIG_filt{r,4};
                    % RMS
                    for c = 1:3
                        dat.(time).(contr).diffEMG.bycolumn_RMS{r,c} = sqrt(movmean(dat.(time).(contr).diffEMG.bycolumn{r,c} .^ 2, wlen));
                    end
                end

                % Double differential
                for c = 1:3 % for each column
                    dat.(time).(contr).diffEMG.double{1,c} = dat.(time).(contr).diffEMG.bycolumn{1,c} - dat.(time).(contr).diffEMG.bycolumn{2,c};
                    dat.(time).(contr).diffEMG.double{2,c} = dat.(time).(contr).diffEMG.bycolumn{2,c} - dat.(time).(contr).diffEMG.bycolumn{3,c};
                    dat.(time).(contr).diffEMG.double{3,c} = dat.(time).(contr).diffEMG.bycolumn{3,c} - dat.(time).(contr).diffEMG.bycolumn{4,c};
                    dat.(time).(contr).diffEMG.double{4,c} = dat.(time).(contr).diffEMG.bycolumn{4,c} - dat.(time).(contr).diffEMG.bycolumn{5,c};
                    dat.(time).(contr).diffEMG.double{5,c} = dat.(time).(contr).diffEMG.bycolumn{5,c} - dat.(time).(contr).diffEMG.bycolumn{6,c};
                    dat.(time).(contr).diffEMG.double{6,c} = dat.(time).(contr).diffEMG.bycolumn{6,c} - dat.(time).(contr).diffEMG.bycolumn{7,c};
                    dat.(time).(contr).diffEMG.double{7,c} = dat.(time).(contr).diffEMG.bycolumn{7,c} - dat.(time).(contr).diffEMG.bycolumn{8,c};
                    % RMS amplitude calculation
                    for r = 1:7
                       dat.(time).(contr).diffEMG.double_RMS{r,c} = sqrt(movmean(dat.(time).(contr).diffEMG.double{r,c} .^ 2, wlen));
                    end
                end

                %% Sum RMS amplitudes from all channels
                % monopolar
                count = 1;
                for r = 1:8
                    for c = 1:4
                        mono(count,:) = dat.(time).(contr).RMS{r,c};
                        count = count + 1;
                    end
                end
                dat.(time).(contr).RMS_sum = sum(mono);

                % single differential by column
                count = 1;
                for r = 1:8
                    for c = 1:3
                        sd(count,:) = dat.(time).(contr).diffEMG.bycolumn_RMS{r,c};
                        count = count + 1;
                    end
                end
                dat.(time).(contr).diffEMG.double_RMS_sum = sum(sd);

                % double differential
                count = 1;
                for r = 1:7
                    for c = 1:3
                        dd(count,:) = dat.(time).(contr).diffEMG.double_RMS{r,c};
                        count = count + 1;
                    end
                end
                dat.(time).(contr).diffEMG.double_RMS_sum = sum(dd);

                clear('sd','dd','mono','A','B','C','band','r','c','wlen');
    end
end
end