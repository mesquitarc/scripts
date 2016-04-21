function [dcs,nint] = AvgDCS(det,corrs,Adcs);
% This function averages different APDs for better SNR in the DCS data.
%
% Created by RM, 11/14/2010
%

% Averaging over same positions
for i=1:size(det,1)
    lst = find(~isnan(det(i,:)));
    detavg = det(i,lst);
    dcs(:,:,i) = nanmean(corrs(:,:,detavg),3);
    nint(:,i) = nanmean(Adcs(:,detavg),2);
end