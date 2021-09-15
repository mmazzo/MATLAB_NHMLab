% MU Data Processing - PROBLEM SET 1

%% Load DEMUSE file

load('Soleus_10_20_Ramps_Medial.mat')

%% ---------- Get to know the variables! ---------------------------------
% Variables that just refer to DEMUSE stuff don't really matter:
%       Cost, DecompRuns, DecompStat, ProcTime, discardChannelsVec, 
%       startSIGInt, stopSIGInt

% Variables that refer to electrode/recording characteristics:
%       description, IED (inter-electroide distance, mm), origRecMode, 
%       fsamp (sampling frequency, Hz)

% Variables that are rarely useful, but good to have as part of the
% original output:
%       MUIDs, PNR (pulse-to-noise ratio)

% Variables that are useful: Click on each one and view it in the Variables window:
%   - SIG : A copy of the original EMG signal
%   - MUPulses : The discharge times of each of the identified motor units,
%                in data point # (based on the sampling frequency, 2000 Hz)
%   - IPTs : Extracted Pulse Trains - A visual representation of the extracted pulse train (the
%            final version of the bottom blue panel of the DEMUSE CKC
%            editor), not actually that useful but nice to visualize. I
%            don't actually know what the I stands for...
%   - ref_signal : This signal gives you an indication of whether data was
%                  "dropped" during the WIFI transfer from the EMG device
%                  to the laptop (aka missing data)
%   - SIGFileName, SIGFilePath :     Useful for naming files when batch processing and
%                                   specifying where to save files
%   - SIGlength :   Length of the signal in seconds (not data points!)

clearvars -except vars fsamp SIG MUPulses IPTs ref_signal SIGlength

%% ---------- Basic Motor Unit Characteristics ---------------------------------

% First, let's visualize the IPTs of all of the motor units collected:
nMUs = size(IPTs,1);
t = tiledlayout(nMUs,1); % tiledlayout is a really useful function to plot a ton of things together in the same window
t.TileSpacing = 'none';
t.Padding = 'none';

cm = jet(nMUs); % this creates a matrix of color values to plot each MU as a different color

for  i = 1:nMUs % sometimes you have to use a for loop to plot a bunch of things!
    nexttile % this goes with the tiledlyout command, and moves to the next "tile" to plot
    plot(IPTs(i,:), 'color',cm(i,:))
    ax = gca;
    set(ax,'XTick',[], 'YTick', []);
end

%% The motor units look pretty good! Next, try some calculations:

% In MUPulses, each cell contains the action potential (pulse) times for one motor unit
% Let's start by doing calculations for motor unit #1:

%   ???     Subset/select MU #1 from MUPulses

%   ???     Calculate the inter-spike interval between each "pulse"

%   ???     Change those ISIs into milliseconds (using fsamp)

%   ???     How can you get from ISI to instantaneous discharge rate (IDR; in seconds)?

%   ???     Plot what you get for the IDRs to check out your calculations

%   ???     What is on the x-axis of that plot?

%   ???     Now try using scatter() and specifying the IDRs as the Y data
%           and the original MUPulses times (for MU 1) as the x data

%% Ok, so if we want to do those same calculations for all of the motor units we identified,
%  we need to write a for loop to do everything for each one, and store the
%  data in a way that stays organized. Use the basic for loop structure
%  below, and fill in the details:

nMUs = length(MUPulses); % number of MUs

for mu = 1:nMUs
    % Subset for each MU # from MUPulses
    
    % Calculate ISIs
    
    % Calculate IDRs
    
end
