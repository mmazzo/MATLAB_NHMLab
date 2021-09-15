function [output]=ReadOTB(FILENAME, PATHNAME)
%% READOTBPLUSFILERAWDATAVALUES reads .otb+ files to a Matlab structure
%
% It is a little edited version of OpenOTBfilesNew from the OTBio website.
%
% It requires xml2struct.m to be on the Matlab search path:
% https://www.mathworks.com/matlabcentral/fileexchange/28518-xml2struct
%
%  INPUT
%   - FILENAME: *.otb+, *.otb, or, *.zip filename
%   - PATHNAME: path to the files
%   
%  OUTPUT
%   - output: structure with the following fields:
%     x analog: nChannel x m matix, not emg analog recordings [uV]
%     x device: char, hardware used for recording [-]
%     x emg: n x m matix, n channels of EMG recordings [uV, micorvolt]
%     x EMG_description: char, description on the EMG data recorded  [-]
%     x info: structure, OTBio geneal info (analog channels are last) [-]
%     x nChannel: integer , overall number of recorded channels [-]
%     x nEMGChannels: integer, number of EMG channels recorded [-]
%     x SR: integer, sampling rate [Hz]
%     x time: 1 x m vector, m time stamps relative to acquisition start [s]
%
%  Original OTBio description:
%
%    Reads files of type OTB+, extrapolating the information on the signal, 
%    in turn uses the xml2struct function to read file.xml and allocate
%    them in an easily readable Matlab structure.
%    Isn't possible to read OTB files because the internal structure of
%    these files is different.
%
%  changes in the original code are indicated with "edit HP":
%    - figure output suppressed
%    - one error exception using try/except due to inconsintent brackets
%    - new output structure
%  edited by H Penasso (HP) Dec/03/2019

%%
%edit HP (deleted things)
%FILTERSPEC = {'*.otb+','OTB+ files'; '*.otb','OTB file'; '*.zip', 'zip file'}; %edit HP 
%[FILENAME, PATHNAME] = uigetfile(FILTERSPEC,'titolo'); %edit HP

mkdir('tempopen');
cd('tempopen');

untar([PATHNAME FILENAME]);
% unzip([PATHNAME FILENAME]);
signals=dir('*.sig');
for nSig=1:length(signals)
    PowerSupply{nSig}=5;
    abstracts{nSig}=[signals(nSig).name(1:end-4) '.xml'];
    abs = xml2struct(abstracts{nSig});
    for nAtt=1:length(abs.Device.Attributes)
%         if strcmp(abs.Device.Attributes(nAtt).Name,'SampleFrequency')
            Fsample{nSig}=str2num(abs.Device.Attributes(nAtt).SampleFrequency);
%         end
%         if strcmp(abs.Device.Attributes(nAtt).Name,'Name')
%             if (strcmp(abs.Device.Attributes(nAtt).Name,'EMG-USB'))
%                 PowerSupply{nSig}=5;
%             end    
%         end
%         if strcmp(abs.Device.Attributes(nAtt).DeviceTotalChannels,'DeviceTotalChannels')
            nChannel{nSig}=str2num(abs.Device.Attributes(nAtt).DeviceTotalChannels);
%         end
%         if strcmp(abs.Device.Attributes(nAtt).ad_bits,'ad_bits')
            nADBit{nSig}=str2num(abs.Device.Attributes(nAtt).ad_bits);
%         end
    end
    vett=zeros(1,nChannel{nSig});
    Gains{nSig}=vett;
    for nChild=1:length(abs.Device.Channels)
%         if strcmp(abs.Children(nChild).Name,'Channels')
            Channels=abs.Device.Channels(nChild);
            for nChild2=1:length(Channels.Adapter)
%                 if strcmp(Channels.Children(nChild2).Name,'Adapter')
%                     Adapter=Channels.Adapter{nChild2};
                    for nAtt2=1:length(Channels.Adapter{nChild2}.Attributes)
%                        if strcmp(Adapter.Device.Attributes(nAtt2).Name,'Gain')
                           localGain{nSig}=str2num(Channels.Adapter{nChild2}.Attributes(nAtt2).Gain);
%                        end
%                        if strcmp(Adapter.Device.Attributes(nAtt2).Name,'ChannelStartIndex')
                           startIndex{nSig}=str2num(Channels.Adapter{nChild2}.Attributes(nAtt2).ChannelStartIndex);
%                        end
                    end
                if nChild2<=3
                     for nChild3=1:length(Channels.Adapter{nChild2}.Channel)
%                         if strcmp(Adapter.Children(nChild3).Name,'Channel')
%                             for nAtt3=1:length(Adapter.Channel{nChild3}.Attributes)
%                                 if strcmp(Adapter.Children(nChild3).Device.Attributes(nAtt3).Name,'Index')
                                try % edit HP
                                  idx=str2num(Channels.Adapter{nChild2}.Channel{nChild3}.Attributes.Index);
                                catch  % edit HP
                                  idx=str2num(Channels.Adapter{nChild2}.Channel(nChild3).Attributes.Index); % edit HP (different brackets at "Channel(nChild3)")
                                end  % edit HP
                                    Gains{nSig}(startIndex{nSig}+idx+1)=localGain{nSig};
                     end 
                else 
                     idx=str2num(Channels.Adapter{nChild2}.Channel.Attributes.Index);
                                    Gains{nSig}(startIndex{nSig}+idx+1)=localGain{nSig};
                end
                            end 
%                                 end
%                             end
    end

    h=fopen(signals(nSig).name,'r');
    data=fread(h,[nChannel{nSig} Inf],'short');
    fclose(h);
    Data{nSig}=data;
    %figs{nSig}=figure; % edit HP (commented out)
    for nCh=1:nChannel{nSig}
        data(nCh,:)=data(nCh,:)*PowerSupply{nSig}/(2^nADBit{nSig})*1000/Gains{nSig}(nCh);
    end
    %MyPlotNormalized(figs{nSig},[1:length(data(1,:))]/Fsample{nSig},data); % edit HP (commented out)
    %MyPlot(figure,[1:length(data(1,:))]/Fsample{nSig},data,0.5); % edit HP (commented out)

end

% ( edit HP (new Outpit structure)
output.nChannel = str2double(abs.Device.Attributes.DeviceTotalChannels);
output.nEMGChannels = length(abs.Device.Channels.Adapter{1, 1}.Channel);
output.EMG_description = abs.Device.Channels.Adapter{1}.Attributes.Description;
output.time = 0:1/Fsample{1}:length(data)/Fsample{1}-1/Fsample{1};
output.emg = data(1:output.nEMGChannels,:)*1000;
output.analog = data(output.nEMGChannels+1:end,:)*1000;
output.SR   = str2double(abs.Device.Attributes.SampleFrequency);
output.device = abs.Device.Attributes.Name;
output.info = abs;
% ) edit HP

theFiles = dir;
for k = 1 : length(theFiles)
  baseFileName = theFiles(k).name;
  %fprintf(1, 'Now deleting %s\n', baseFileName);
  delete(baseFileName);
end

fprintf('OTB Files Loaded \n');
cd ..;
rmdir('tempopen');

end
% 
% function []=MyPlotNormalized(fig,x,y)
%     figure(fig);
%     maximus=max(max(abs(y)));
%     for ii=1:size(y,1)
%         plot(x,y(ii,:)/2/maximus-ii);
%         hold on
%     end
% 
% end
% 
% 
% function []=MyPlot(fig,x,y,shift)
%     figure(fig);
%     maximus=max(max(abs(y)));
%     for ii=1:size(y,1)
%         plot(x,y(ii,:)-ii*shift);
%         hold on
%     end
% 
% end