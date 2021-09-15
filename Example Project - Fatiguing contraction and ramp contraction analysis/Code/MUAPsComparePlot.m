function [varargout] = MUAPsComparePlot(B,A)
% Plot and calculate correlation between MUAP shapes across grids
% ------------------------------------------------------

B = B;
A = A;

if sum(size(B)) == (8+7)
   % Differential by column
   % Find limits for y axes
        for r = 1:8
            for c = 1:7
            temp = B{r,c};
            uplim(r,c) = max(temp);
            lowlim(r,c) = min(temp);    
            end
        end
            ymaxB = ceil(max(uplim(:))+1);
            yminB = floor(min(lowlim(:))-1);

        for r = 1:8
            for c = 1:7
            temp = A{r,c};
            uplim(r,c) = max(temp);
            lowlim(r,c) = min(temp);    
            end
        end
            ymaxA = ceil(max(uplim(:))+1);
            yminA = floor(min(lowlim(:))-1);

        if ymaxB > ymaxA == 1
            ymax = ymaxB;
        else
            ymax = ymaxA;
        end

        if yminB < yminA == 1
            ymin = yminB;
        else
            ymin = yminA;
        end

        % Plot
        t = tiledlayout(8,7);
        title(t,'Example Motor Unit (Blue = Pre / Red = Post)');
        set(gcf,'units','normalized','outerposition',[0.2 0.2 0.5 0.7]);
        t.TileSpacing = 'compact';
        t.Padding = 'compact';
        for r = 1:8
            for c = 1:7
                nexttile
                plot(B{r,c},'Color','blue','LineWidth',1)
                hold on;
                plot(A{r,c},'Color','red','LineWidth',1)
                ylim([ymin ymax]);
                set(gca,'xtick',[]);
                set(gca,'xticklabel',[]);
                set(gca,'ytick',[]);
                set(gca,'yticklabel',[]);
            end
        end
        
elseif sum(size(B)) == (7+7)
   % Differential by column
   % Find limits for y axes
        for r = 1:7
            for c = 1:7
            temp = B{r,c};
            uplim(r,c) = max(temp);
            lowlim(r,c) = min(temp);    
            end
        end
            ymaxB = ceil(max(uplim(:))+1);
            yminB = floor(min(lowlim(:))-1);

        for r = 1:7
            for c = 1:7
            temp = A{r,c};
            uplim(r,c) = max(temp);
            lowlim(r,c) = min(temp);    
            end
        end
            ymaxA = ceil(max(uplim(:))+1);
            yminA = floor(min(lowlim(:))-1);

        if ymaxB > ymaxA == 1
            ymax = ymaxB;
        else
            ymax = ymaxA;
        end

        if yminB < yminA == 1
            ymin = yminB;
        else
            ymin = yminA;
        end

        % Plot
        t = tiledlayout(7,7);
        title(t,'Example Motor Unit (Blue = Pre / Red = Post)');
        set(gcf,'units','normalized','outerposition',[0.2 0.2 0.5 0.7]);
        t.TileSpacing = 'compact';
        t.Padding = 'compact';
        for r = 1:7
            for c = 1:7
                nexttile
                plot(B{r,c},'Color','blue','LineWidth',1)
                hold on;
                plot(A{r,c},'Color','red','LineWidth',1)
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
            temp = B{r,c};
            uplim(r,c) = max(temp);
            lowlim(r,c) = min(temp);    
            end
        end
            ymaxB = ceil(max(uplim(:))+1);
            yminB = floor(min(lowlim(:))-1);

        for r = 1:8
            for c = 1:8
            temp = A{r,c};
            uplim(r,c) = max(temp);
            lowlim(r,c) = min(temp);    
            end
        end
            ymaxA = ceil(max(uplim(:))+1);
            yminA = floor(min(lowlim(:))-1);

        if ymaxB > ymaxA == 1
            ymax = ymaxB;
        else
            ymax = ymaxA;
        end

        if yminB < yminA == 1
            ymin = yminB;
        else
            ymin = yminA;
        end

        % Plot
        t = tiledlayout(8,8);
        t.TileSpacing = 'compact';
        t.Padding = 'compact';
        title(t,'Example Motor Unit (Blue = Pre / Red = Post)');
        for r = 1:8
            for c = 1:8
                nexttile
                plot(B{r,c},'Color','blue','LineWidth',1)
                hold on;
                plot(A{r,c},'Color','red','LineWidth',1)
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
