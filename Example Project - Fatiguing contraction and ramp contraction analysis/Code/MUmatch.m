function dat = MUmatch(dat1,dat2)
% Same MUs or not?
% Check to see if any motor units from one compartment of the soleus
% match one recorded inthe other compartment

dat1 = dat1;
dat2 = dat2;

count = 1;
for mu1 = 1:length(dat1)
    muaps1 = dat1{mu1};
    for a = 1:7
        for b = 1:7
            max1(a,b) = max(muaps1{a,b});
        end
    end
    max1max = max(max1);
    for mu2 = 1:length(dat2)
        muaps2 = dat2{mu2};
        for f = 1:7
            for g = 1:7
                max2(f,g) = max(muaps1{f,g});
            end
        end
        max2max = max(max2);
        for r = 1:7
            for c = 1:7
                % if the amplitude of the MUAP is at least 0.33 of the max
                % value for MU#1
                if max(r,c) > (0.33*max1max)
                    % find the cross correlation
                    if iscell(muaps1) == 0 || iscell(muaps2) == 0
                        cors(r,c) = NaN;
                        lags(r,c) = NaN; 
                    else
                        [cor,~] = xcorr(muaps1{r,c},muaps2{r,c},'normalized');
                        [pk,pt] = max(cor);
                        cors(r,c) = pk;
                        lags(r,c) = 100-pt;
                        % otherwise don't bother
                    end
                else
                    cors(r,c) = NaN;
                    lags(r,c) = NaN; 
                end
            end
        end
        MUmatches.pairs(count,1) = mu1;
        MUmatches.pairs(count,2) = mu2;
        MUmatches.pairs(count,3) = max(max(cors));
        MUmatches.pairs(count,4) = nanmean(nanmean(lags));
        MUmatches.cors{count,4} = cors;
    count = count + 1;
    end
end
vals = MUmatches.pairs(:,3);
highinds = vals > 0.85;
highcors = vals(highinds);

maybe = MUmatches.pairs(highinds,:);

%% User verification
for i = 1:length(maybe)
    muind1 = maybe(i,1);
    muind2 = maybe(i,2);
    MUAPsComparePlot(dat1{muind1},dat2{muind2})
    match = menu('Did the MUs match?','Yes','No','Maybe?');
    if match == 1
        matched.data(i,1:4) = maybe(i,1:4);
        matched.userinput{i} = 'Y';
    elseif match == 2
        matched.data(i,1:4) = 0;
        matched.userinput{i} = 'N';
    else
        matched.data(i,1:4) = maybe(i,1:4);
        matched.userinput{i} = 'M';
    end
    
dat = matched;    
end