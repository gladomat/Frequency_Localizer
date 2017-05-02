% Transform wav files into auditory spectrograms.
% Here we want a [sound x feature] matrix representation. This means we
% have 84 sounds and 9 features (bins). The features are stroed into one
% matrix and then saved to a file together with sound file names.
% Paul Glad Mihai, CC-BY-04 2017

soundDir = '/nobackup/alster2/Glad/Projects/Top-down_mod_MGB/Experiments/TdMGB_fMRI/Presentation_scripts/TdMGB_localiser/stimuli/';
soundFiles = {
's3_animal_10_ramp10.wav'
's3_animal_11_ramp10.wav'
's3_animal_12_ramp10.wav'
's3_animal_13_ramp10.wav'
's3_animal_14_ramp10.wav'
's3_animal_15_ramp10.wav'
's3_animal_16_ramp10.wav'
's3_animal_17_ramp10.wav'
's3_animal_18_ramp10.wav'
's3_animal_19_ramp10.wav'
's3_animal_1_ramp10.wav'
's3_animal_20_ramp10.wav'
's3_animal_21_ramp10.wav'
's3_animal_2_ramp10.wav'
's3_animal_3_ramp10.wav'
's3_animal_4_ramp10.wav'
's3_animal_5_ramp10.wav'
's3_animal_6_ramp10.wav'
's3_animal_7_ramp10.wav'
's3_animal_8_ramp10.wav'
's3_animal_9_ramp10.wav'
's3_speech_10_ramp10.wav'
's3_speech_11_ramp10.wav'
's3_speech_12_ramp10.wav'
's3_speech_13_ramp10.wav'
's3_speech_14_ramp10.wav'
's3_speech_15_ramp10.wav'
's3_speech_16_ramp10.wav'
's3_speech_17_ramp10.wav'
's3_speech_18_ramp10.wav'
's3_speech_19_ramp10.wav'
's3_speech_1_ramp10.wav'
's3_speech_20_ramp10.wav'
's3_speech_21_ramp10.wav'
's3_speech_2_ramp10.wav'
's3_speech_3_ramp10.wav'
's3_speech_4_ramp10.wav'
's3_speech_5_ramp10.wav'
's3_speech_6_ramp10.wav'
's3_speech_7_ramp10.wav'
's3_speech_8_ramp10.wav'
's3_speech_9_ramp10.wav'
's3_tools_10_ramp10.wav'
's3_tools_11_ramp10.wav'
's3_tools_12_ramp10.wav'
's3_tools_13_ramp10.wav'
's3_tools_14_ramp10.wav'
's3_tools_15_ramp10.wav'
's3_tools_16_ramp10.wav'
's3_tools_17_ramp10.wav'
's3_tools_18_ramp10.wav'
's3_tools_19_ramp10.wav'
's3_tools_1_ramp10.wav'
's3_tools_20_ramp10.wav'
's3_tools_21_ramp10.wav'
's3_tools_2_ramp10.wav'
's3_tools_3_ramp10.wav'
's3_tools_4_ramp10.wav'
's3_tools_5_ramp10.wav'
's3_tools_6_ramp10.wav'
's3_tools_7_ramp10.wav'
's3_tools_8_ramp10.wav'
's3_tools_9_ramp10.wav'
's3_voice_10_ramp10.wav'
's3_voice_11_ramp10.wav'
's3_voice_12_ramp10.wav'
's3_voice_13_ramp10.wav'
's3_voice_14_ramp10.wav'
's3_voice_15_ramp10.wav'
's3_voice_16_ramp10.wav'
's3_voice_17_ramp10.wav'
's3_voice_18_ramp10.wav'
's3_voice_19_ramp10.wav'
's3_voice_1_ramp10.wav'
's3_voice_20_ramp10.wav'
's3_voice_21_ramp10.wav'
's3_voice_2_ramp10.wav'
's3_voice_3_ramp10.wav'
's3_voice_4_ramp10.wav'
's3_voice_5_ramp10.wav'
's3_voice_6_ramp10.wav'
's3_voice_7_ramp10.wav'
's3_voice_8_ramp10.wav'
's3_voice_9_ramp10.wav'
    };

% Preallocate feature matrix.
soundFeature = zeros(length(soundFiles), 9);
soundFeatureFull = zeros(length(soundFiles), 128);

% load colormap, filterbank and parameters
addpath /nobackup/alster2/Glad/Matlab_scripts/nsltools
loadload;
% Parameters are as follows:
% frame jump in ms: 8
% time constant in ms: 8
% nonlinear factor: 0.1
% octave shift: 0 for 16 kHz sampling rate
paras = [8, 8, 0.1, 0];
tic;
% Calculate mean center frequencies
CF = 440 * 2 .^ (linspace(-31,96,128)/24);
cf = 440 * 2 .^ (linspace(-31,96,10)/24);
for iSound = 1:numel(soundFiles)    
    % load wave file
    [y, fs] = audioread(sprintf('%s%s', soundDir, soundFiles{iSound}));
    % Schematic plot
    % figure
    % xh = schematc(y);
    x = unitseq(y);
    % soundsc(x, fs);  % play sound
    % Calculate spectrum
    y = wav2aud(x, paras);    
    % plot the auditory spectrogram
    % figure
    % aud_plot(y, paras);
    
    % Average over time
    yAve = mean(y, 1);
       
    % Divide in 10 equal bandwidth bins
    freqInd = [1, 15, 30, 44, 58, 70, 86, 100, 113, 128];
    binscf = length(cf)-1;
    for iBin = 1:binscf
        yAveRes(iBin) = mean(yAve(freqInd(iBin):freqInd(iBin)+1));
    end
    soundFeatureFull(iSound,:) = yAve;
    soundFeature(iSound,:) = yAveRes;
end

save('sound_feature_matrix_84_sounds.mat', 'soundFiles', 'soundFeature');

% Calculate mean center frequencies, the NSL way.
% CF = 440 * 2 .^ ((-31:97)/24);
% cf = 440 * 2 .^ ((-31:15:97)/24);

fprintf('Calculation time %f s.\n', toc)
figure
subplot(2, 2, 1)
plot(cf(1:end-1),soundFeature(1,:))
subplot(2,2,2)
plot(cf(1:end-1),soundFeature(4,:))
subplot(2,2,3)
plot(cf(1:end-1),soundFeature(15,:))
subplot(2,2,4)
plot(cf(1:end-1),soundFeature(34,:))
figure
subplot(2, 2, 1)
plot(CF,soundFeatureFull(1,:))
subplot(2,2,2)
plot(CF,soundFeatureFull(4,:))
subplot(2,2,3)
plot(CF,soundFeatureFull(15,:))
subplot(2,2,4)
plot(CF,soundFeatureFull(34,:))