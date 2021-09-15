% Comparisons between Pre & Post ramp contractions

% Big difference = # of MUs identified during the post contraction was less

% Let's try to figure out what might have contributed to this difference!

%% Plotting some comparisons between contractions

% What bout RMS EMG amplitude? It is a good indicator of the general level
% of activation of a muscle. Any time we do repeated contractions and
% compare them, there's a chance that the muscle of interest and it's 
% synergist muscles have changes in their relative amounts of activation
plot(MUdata.pre.ramp10.diffEMG.double_RMS_sum,'blue');
hold on;
plot(MUdata.post.ramp10.diffEMG.double_RMS_sum,'red')

% Ok, so it looks like maybe the other synergists must have picked up some
% of the slack to produce 10% MVC post fatiguing contraction, because the
% VL EMG amplitude is way lower than before

% One thing we can do is get the EMG amplitude from the VM and RF (even
% though the MU decomposition didn't work for them) and look at the sum of
% of EMG for the three quadriceps muscles before and after

%% Is the number of MUs identified during the decomposition (and their 
%  resultant cumulative spike train (cst) representative of the EMG
%  amplitude difference?

plot(MUdata.pre.ramp10.cst,'blue');
hold on;
plot(MUdata.post.ramp10.cst,'red');

% I would say yes!

%% Out of curiosity, let's look at the force data too:
plot(Forcedata.pre.ramp10,'blue');
hold on;
plot(Forcedata.post.ramp10,'red')

% Good, the plateau force was definitely the same, but more variable post
% fatiguing contraction (see Forcedata.pre/post.steady.CV)


%% Let's see where the MUs identified during each contraction were identified
p = tiledlayout(2,1);
nexttile
set(gcf,'units','normalized','outerposition',[0.05 0.05, 0.9 0.9]);
    title('Pre Fatiguing Contraction - Ramp 10% MVC');
    yyaxis left
        plot(Forcedata.pre.ramp10,'LineWidth',2,'Color','blue')
        ax = gca;
        set(ax,'XTick',[], 'YTick', []);
        hold on;
        for j = 1:length(MUdata.pre.ramp10.RTs.ind)
            xpt = MUdata.pre.ramp10.RTs.ind(j,1);
            xline(xpt,'Color','blue','Linewidth',0.5);
        end
        % scatter(MUdata.pre.ramp10.RTs.ind,[MUdata.pre.ramp10.RTs.force_only{:}],...
         %   'MarkerEdgeColor','blue','LineWidth',1);
    yyaxis right
       plotSpikeRaster(logical(MUdata.pre.ramp10.binary_ordered),'PlotType','vertline', 'VertSpikeHeight',0.5);
    
nexttile
    title('Post Fatiguing Contraction - Ramp 10% MVC');
    yyaxis left
        plot(Forcedata.post.ramp10,'LineWidth',2,'Color','blue')
        ax = gca;
        set(ax,'XTick',[], 'YTick', []);
        hold on;
        for j = 1:length(MUdata.post.ramp10.RTs.ind)
            xpt = MUdata.post.ramp10.RTs.ind(j,1);
            xline(xpt,'Color','blue','Linewidth',0.5);
        end
        % scatter(MUdata.pre.ramp10.RTs.ind,[MUdata.pre.ramp10.RTs.force_only{:}],...
         %   'MarkerEdgeColor','blue','LineWidth',1);
    yyaxis right
       plotSpikeRaster(logical(MUdata.post.ramp10.binary_ordered),'PlotType','vertline', 'VertSpikeHeight',0.5);
    
%% Can we match any of the MUs bewteen the two contractions?
% We can try to match the MUs by cross-correlation, but it reuires some user
% input because sometimes the correlation coefficient isn't reliable

% This script will show you all pairs of MUs with fairly high correlations
% (>0.85) between MUAP shapes, and will ask you if you think they match.

% Keep in mind that the red Post MUAP shapes are expected to be lower in amplitude
% than the pre shapes, but timing/order of the negative/positive phases
% should be nearly the same across all channels
matched = MUmatch(MUdata.pre.ramp10.MUAPs_diff_double,MUdata.post.ramp10.MUAPs_diff_double);

% For those that are matches or might be matches, we could shift the MUAPs so
% that their timing within the spike-triggered averaging window is
% consistent, and see if it helps to clarify whether they match

% Comparing discharge rates between matched pairs isn't really possible, 
% since we know other synergists must be contributing to the force output
% after, and so the contribution of the VL is not consistent