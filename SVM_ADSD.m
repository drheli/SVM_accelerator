% *******************************************************************************
% Advanced Digital System Design
% CORDIC Coprocessor
% Authors: He Li
% *******************************************************************************

% Clear the workspace
clear all;
close all;

% Import data
load('SVM_alpha1','-mat');
load('SV1','-mat');
load('bias','-mat');
load('TestDataLabels1','-mat'); % TestData Label
load('TestData1','-mat');

% Constants declation
DIM = 16; % Dimension of the vectors
NSV = length(SVM_alpha); % No.support vectors:98656
N = length(TestDataLabels); % N0.TestData vectors to classify:32000

% Variable declaration
results = zeros(N,1); % TestDataLabels computed by Matlab
SVM_gold = zeros(N,1); % Gold trace computed by Matlab

% Classification
w = waitbar(0,'Progress Bar');
LOG_file = fopen('SVM_LOG.txt','wt');
donotmatch = 0;
for index_in = 1:N % Loop on the TestData vectors to classify
    acc_sv = 0;
    for index_sv = 1:NSV
        acc_dp = 0;
        for index_dp = 1:DIM % Loop on the dimension ie scalar product
            acc_dp = acc_dp + SV(16*(index_sv-1)+index_dp,1)*TestData(16*(index_in-1)+index_dp,1);
        end
        acc_sv = acc_sv + SVM_alpha(index_sv,1)*tanh(2*acc_dp); % K(u,v) = tanh(2*u*v’) in the .rtf
    end
    acc_sv = acc_sv+bias;
    SVM_gold(index_in,1) = acc_sv; % Gold trace
    if acc_sv < 0 % no else case since results was initialized to zeros
        results(index_in,1) = 1;
    end
    if results(index_in,1) == TestDataLabels(index_in,1)
        sprintf('Computed label %0.5e matches.\n',index_in)
    else
        sprintf('Computed label %0.5e doesnt match.\n',index_in)
        fprintf(LOG_file,'Test Data %d, Initial label %d, Extimated label %d.\n\r',index_in,TestDataLabels(index_in,1),results(index_in,1));
        donotmatch = donotmatch + 1;
    end
    waitbar(index_in/N,w,['Vector: ',num2str(index_in)]);
end
donotmatch = donotmatch / N;
sprintf('Error percentage: %0.5e\n',donotmatch)
fprintf(LOG_file,'Error percentage: %0.5e\n\r',donotmatch);
fclose(LOG_file);
close(w);

% Exporting the results to a .h file ready to be used in the SDK
LOG_file = fopen('gold.h','wt');
fprintf(LOG_file,'const float gold[%d] = {',N);
for index=1:N-1
    fprintf(LOG_file,'%d,\n',results(index));
end
fprintf(LOG_file,'%d};',results(index));
fclose(LOG_file);

% Exporting the results to a .mat file
save('SVM_gold.mat','SVM_gold')

