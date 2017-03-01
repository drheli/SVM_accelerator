% *******************************************************************************
% Advanced Digital System Design
% CORDIC Coprocessor
% Authors: He Li
% *******************************************************************************

% Clear the workspace
clear all;
close all;

% Import data
load('trace_gold','-mat');
load('trace_sw','-mat');

% Constants declation
N = length(trace_gold); % Number of input vectors to classify

% Number of detected E letters
eletters = 0;
for n = 1:N
    if (trace_gold(n) < 0)
       eletters = eletters + 1; 
    end
end

% Absolute relative error for the SW
relative_error_trace_sw = zeros(N,1);
for n = 1:N
    relative_error_trace_sw(n) = abs((trace_sw(n)-trace_gold(n))/trace_gold(n)); 
end

% Graph x axis
x = ones(N,1);
for n = 2:N
    x(n) = x(n) + x(n - 1);
end;
% Plot
figure('name',strjoin({'SVM Implementations Precision Comparison: ',num2str(eletters),'detected E letters'}));
plot(x,relative_error_trace_sw,'g+');
title('Comparison of the SVM implementations relative error on the accumulator');
str1 = strjoin({'SW using floats','( Maximum error:',num2str(100*max(relative_error_trace_sw),'%.2f'),'% )'});
legend(str1,'Location','northwest');
xlabel('Input vector') % x-axis label
ylabel('Relative error on the accumulator') % y-axis label

