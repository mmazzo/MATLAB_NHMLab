% Comparisons between Pre & Post ramp contractions

% Change based on which force level you want to look at:

    ramp = 'ramp30';


%% Plotting some comparisons between contractions

% Checking RMS EMG amplitude - A good indicator of the general level
% of activation of a muscle. Any time we do repeated contractions and
% compare them, there's a chance that the muscle of interest and it's 
% synergist muscles have changes in their relative amounts of activation

tiledlayout(1,2)
nexttile
    plot(MUdata.pre.(ramp).cst,'blue');
    hold on;
    plot(MUdata.post.(ramp).cst,'red');
nexttile
    plot(MUdata.pre.(ramp).diffEMG.double_RMS_sum,'blue');
    hold on;
    plot(MUdata.post.(ramp).diffEMG.double_RMS_sum,'red')

% Is the number of MUs identified during the decomposition (and their 
% resultant cumulative spike train (cst) representative of the EMG
% amplitude difference?
%                               I would say yes!

%% Let's quickly check the force data:
plot(Forcedata.pre.(ramp),'blue');
hold on;
plot(Forcedata.post.(ramp),'red')

% Good, the plateau force was definitely the same, but looks more variable post
% fatiguing contraction (see Forcedata.pre/post.steady.CV)


%% Let's see where the MUs identified during each contraction were identified
p = tiledlayout(2,1);
nexttile
set(gcf,'units','normalized','outerposition',[0.05 0.05, 0.9 0.9]);
    title('Pre Fatiguing Contraction - Ramp 10% MVC');
    yyaxis left
        plot(Forcedata.pre.(ramp),'LineWidth',2,'Color','blue')
        ax = gca;
        set(ax,'XTick',[], 'YTick', []);
        hold on;
        for j = 1:length(MUdata.pre.(ramp).RTs.ind)
            xpt = MUdata.pre.(ramp).RTs.ind(j,1);
            xline(xpt,'Color','blue','Linewidth',0.5);
        end
        % scatter(MUdata.pre.(ramp).RTs.ind,[MUdata.pre.(ramp).RTs.force_only{:}],...
         %   'MarkerEdgeColor','blue','LineWidth',1);
    yyaxis right
       plotSpikeRaster(logical(MUdata.pre.(ramp).binary_ordered),'PlotType','vertline', 'VertSpikeHeight',0.5);
    
nexttile
    title('Post Fatiguing Contraction - Ramp 10% MVC');
    yyaxis left
        plot(Forcedata.post.(ramp),'LineWidth',2,'Color','blue')
        ax = gca;
        set(ax,'XTick',[], 'YTick', []);
        hold on;
        for j = 1:length(MUdata.post.(ramp).RTs.ind)
            xpt = MUdata.post.(ramp).RTs.ind(j,1);
            xline(xpt,'Color','blue','Linewidth',0.5);
        end
        % scatter(MUdata.pre.(ramp).RTs.ind,[MUdata.pre.(ramp).RTs.force_only{:}],...
         %   'MarkerEdgeColor','blue','LineWidth',1);
    yyaxis right
       plotSpikeRaster(logical(MUdata.post.(ramp).binary_ordered),'PlotType','vertline', 'VertSpikeHeight',0.5);
    
%% Can we match any of the MUs bewteen the two contractions?
    % We can try to match the MUs by cross-correlation, but it reuires some user
    % input because sometimes the correlation coefficient isn't reliable

    % This script will show you all pairs of MUs with fairly high correlations
    % (>0.85) between MUAP shapes, and will ask you if you think they match.

    % Keep in mind that the red Post MUAP shapes are expected to be lower in amplitude
    % than the pre shapes, but timing/order of the negative/positive phases
    % should be nearly the same across all channels
    matched = MUmatch(MUdata.pre.(ramp).MUAPs_diff_double,MUdata.post.(ramp).MUAPs_diff_double);

    % For those that are matches or might be matches, we could shift the MUAPs so
    % that their timing within the spike-triggered averaging window is
    % consistent, and see if it helps to clarify whether they match

%% Now that we're looking at the higher %MVC contractions, we should see if any 
%  of the Ramp contraction motor units match the ones we identified during
%  the fatiguing contraction. We can use the same script for that.

    % You can compare any ramp contraction with either the "early" or "late"
    % MUAP shapes from the fatiguing contraction. For example 30% MVC Pre vs. Early:

    matched_with_FC = MUmatch(MUdata.pre.ramp30.MUAPs_diff_double,MUdata.fatiguing.early.MUAPs_diff_double);

    % or 40% MVC pre vs 30% MVC post
    
    matched_pre40_post30 = MUmatch(MUdata.pre.ramp40.MUAPs_diff_double,MUdata.post.ramp30.MUAPs_diff_double);
    

%% Comparing discharge rates between pre & post:

% We know the Ramp 10% MVC contraction had weird imbalances of which quads
% were used to produce force for thr Pre vs Post

% But lets try looking at the mean discharge rates for before and after for all
% of the motor units identified at each time point:

ramp = 'ramp30';

pre1 = repelem(1,length(MUdata.pre.(ramp).Mean_DR))';
post2 = repelem(2,length(MUdata.post.(ramp).Mean_DR))';
time = vertcat(pre1,post2);
plotdata = vertcat(MUdata.pre.(ramp).Mean_DR',MUdata.post.(ramp).Mean_DR');
boxplot(plotdata,time)

% Based on lower discharge rates during the after task (time point 2), what do you think
% must have happened in order for the same amount of force to be produced?

% This is why matching the same motor units across contractions can be
% really helpful!

%% Since lots of larger MUs (with lower DRs) seem to have been used for all of the 
% Post ramp tasks... we should try to check that out!

% Larger MUAP shapes in the EMG can help to support our theory...

% What kind of a plot do you think coukld help illustrate this? I'll help
% you create one, LMK what your idea is!