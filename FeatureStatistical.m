function [F]=FeatureStatistical(img4)
% Summary of this function goes here
img4=double(img4);%symbolic data convert to numeric values
m=mean(mean(img4));
s=std(std(img4));
F=[m s];
end

