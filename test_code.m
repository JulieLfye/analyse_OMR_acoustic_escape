% save angle_to_OMR

% save(fullfile(a,'angle_to_OMR.mat'),angle_to_OMR)

clc

F = Focus();

F.dpf = 5;
F.OMR = 1000;
F.V = 1;

Data = F.load('data.m')
    