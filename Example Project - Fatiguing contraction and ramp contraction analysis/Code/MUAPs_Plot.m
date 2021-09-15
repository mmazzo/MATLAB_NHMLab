function [varargout] = MUAPs_plot(dat)
% Plot and calculate correlation between MUAP shapes across grids
% dat = One MU from MUAPs variable (i.e. ".MUAPs_mono{1}"
% ------------------------------------------------------

dat = dat;

if sum(size(dat)) == (8+7)
   % Differential by column
   % Find limits for y axes
        for r = 1:8
            for c = 1:7
            temp = dat{r,c};
            uplim(r,c) = max(temp);
            lowlim(r,c) = min(temp);    
            end
        end
            ymax = ceil(max(uplim(:))+1);
            ymin = floor(min(lowlim(:))-1);

        % Plot
        t = tiledlayout(8,7);
        title(t,'Example Motor Unit');
        set(gcf,'units','normalized','outerposition',[0.2 0.2 0.7 0.7]);
        t.TileSpacing = 'compact';
        t.Padding = 'compact';
        for r = 1:8
            for c = 1:7
                nexttile
                plot(dat{r,c},'Color','red','LineWidth',1)
                ylim([ymin ymax]);
                set(gca,'xtick',[]);
                set(gca,'xticklabel',[]);
                set(gca,'ytick',[]);
                set(gca,'yticklabel',[]);
            end
        end
elseif sum(size(dat)) == (7+7)
   % Double differential
   % Find limits for y axes
        for r = 1:7
            for c = 1:7
            temp = dat{r,c};
            uplim(r,c) = max(temp);
            lowlim(r,c) = min(temp);    
            end
        end
            ymax = ceil(max(uplim(:))+1);
            ymin = floor(min(lowlim(:))-1);

        % Plot
        t = tiledlayout(7,7);
        title(t,'Example Motor Unit');
        set(gcf,'units','normalized','outerposition',[0.2 0.2 0.7 0.7]);
        t.TileSpacing = 'compact';
        t.Padding = 'compact';
        for r = 1:7
            for c = 1:7
                nexttile
                plot(dat{r,c},'Color','red','LineWidth',1)
                ylim([ymin ymax]);
                set(gca,'xtick',[]);
                set(gca,'xticklabel',[]);
                set(gca,'ytick',[]);
                set(gca,'yticklabel',[]);
            end
        end
        
else
    % Monopolar
    % Find limits for y axes
        for r = 1:8
            for c = 1:8
            temp = dat{r,c};
            uplim(r,c) = max(temp);
            lowlim(r,c) = min(temp);    
            end
        end
            ymax = ceil(max(uplim(:))+1);
            ymin = floor(min(lowlim(:))-1);
            
        % Plot
        t = tiledlayout(8,8);
        title(t,'Example Motor Unit');
        t.TileSpacing = 'compact';
        t.Padding = 'compact';
        for r = 1:8
            for c = 1:8
                nexttile
                plot(dat{r,c},'Color','red','LineWidth',1)
                ylim([ymin ymax]);
                set(gca,'xtick',[]);
                set(gca,'xticklabel',[]);
                set(gca,'ytick',[]);
                set(gca,'yticklabel',[]);
            end
        end
end

waitfor(t);
end
