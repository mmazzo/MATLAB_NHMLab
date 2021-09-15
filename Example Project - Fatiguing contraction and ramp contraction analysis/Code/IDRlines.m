function dat = IDRlines(dat)
% Interpolates and smooths discharge rate lines
dat = dat;
hann_window = hann(2000); 
% ---------------------------------------------
        % Insert NaN at beginning of IDR vector
        len = length(dat.IPTs);
%         for mu = 1:length(dat.MUPulses)
%             idrs = dat.orig_IDR{1,mu};
%             idrs = [NaN,idrs];
%             dat.orig_IDR{1,mu} = idrs;
%         end

     for mu = 1:length(dat.MUPulses)
         if isempty(dat.MUPulses{1,mu})
         else
            % linear interpolation
            dt = dat.MUPulses{1,mu}(3:end);
                dt_diff = diff(dt);
                first = dt(1,1);
                last = dt(1,end);
            len = length(dat.IPTs);
            line = zeros(1,len);

            idrs = dat.orig_IDR{1,mu}(3:end);
                idrs_diff = diff(idrs);

            for d = 1:(length(dt_diff)-1)
                xdiff = dt_diff(1,d)+1;
                ydiff = idrs_diff(1,d);
                slope = ydiff/xdiff;
                for pt = 1:xdiff
                    points(1,pt) = (slope*pt)+idrs(d);
                end
                start = dt(d);
                endd = dt(d+1);
                line(1,start:endd) = points;
                clear('points');
            end

            hanned = (conv(line,hann_window))/1000;

            % NaN version
            hanned_nans = hanned;
            hanned_nans(hanned_nans==0) = NaN;
            lines{1,mu} = hanned_nans;

            % Trim so line doesn't start at 0
                % start
                [out] = find(dat.orig_IDR{1,mu} > 2 & dat.orig_IDR{1,mu} < 10,1,'first');
                val = dat.orig_IDR{1,mu}(out);
                [out1] = find(lines{1,mu} > val,1,'first');
                nanpad = repelem(NaN,out1);
                new = lines{1,mu};
                new(1:out1) = nanpad;

                % end
                [out] = find(dat.orig_IDR{1,mu} > 2 & dat.orig_IDR{1,mu} < 10,1,'last');
                val = dat.orig_IDR{1,mu}(out);
                [out1] = find(lines{1,mu} > val,1,'last');
                nanpad = repelem(NaN,(length(lines{1,mu})-out1)+1);
                new2 = new;
                new2(out1:end) = nanpad;

                % Clean up sections where Mu becomes deactivated
                [inds] = find(new2 < 2);
                if isempty(inds)
                    new3 = new2;
                else
                    new3 = new2;
                    new3(inds) = NaN;
                end
                % Insert final line data
                lines{1,mu} = new3;
                clear('out','new','new2','new3','val','out1','nanpad');

         end    
     end
dat.lines = lines;
 end