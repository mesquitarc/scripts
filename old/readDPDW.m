function [A,phi,In,Qu,varargout] = readDPDW(fname,numdets,numlambda,numsources)

% This function reads the filename with directory, the total number of detectors, 
% wavelengths and sources, respectively. As output, it gives
% amplitude,phase,in-phase,quadrature data in a 4-D matrix, reshaped as
% [dets wavelength sources frames]
% If available, one can get also src and Marks as output
%
% Example: [A,p,I,Q,src,marks] = readDPDW('/mnt/d/rickson/test_',4,3,4) 
%     for 4 detectors, 3 lambdas, 4 sources
%
% Created by: R. Mesquita ( 2009/03/11 )
%


measnum=0;
numfiles=0;
morefiles=1; % 1:more files to read, 0:quit

% Read all files
while (morefiles)
    fnametmp=[fname sprintf('%01d',numfiles) '.dat'];
    if exist(fnametmp)==2 %file exists
        fi=fopen(fnametmp,'rt');
        % s# c# d1a d1p d1i d1q d1at d2a d2p d2i d2q d2at d3a d3p d3i d3q d3at d4a d4p d4i d4q d4at mm/dd/yy hh:mm:ss am/pm 
        tmp=fscanf(fi,['%g %g %g %g %g %g %g  %g %g %g %g %g  %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g  %d/%d/%d %d:%d:%d %*s %g\n'],[45 inf]);
        fg(:,measnum+1:(measnum+size(tmp,2)))=tmp;
        measnum=measnum+size(tmp,2);
        numfiles=numfiles+1;
    elseif exist(fname)==0 %file does not exist
        morefiles=0;
    end
end

% Separate different data
fga=fg(3:5:22,:);
%get rid of half-frame stops
fga=fga(:,1:(size(fga,2)-rem(size(fga,2),numlambda.*(numsources))));
%reshape it as [dets wavelength sources frames]
A=reshape(fga,[numdets numlambda (numsources) prod(size(fga))./(numdets.*(numsources).*numlambda)]);

fgp=fg(4:5:23,:);
fgp=fgp(:,1:(size(fgp,2)-rem(size(fgp,2),numlambda.*(numsources))));
phi=reshape(fgp,[numdets numlambda (numsources) prod(size(fgp))./(numdets.*(numsources).*numlambda)]);

fgI=fg(5:5:22,:);
fgI=fgI(:,1:(size(fgI,2)-rem(size(fgI,2),numlambda.*(numsources))));
In=reshape(fgI,[numdets numlambda (numsources) prod(size(fgI))./(numdets.*(numsources).*numlambda)]);

fgQ=fg(6:5:22,:);
fgQ=fgQ(:,1:(size(fgQ,2)-rem(size(fgQ,2),numlambda.*(numsources))));
Qu=reshape(fgQ,[numdets numlambda (numsources) prod(size(fgQ))./(numdets.*(numsources).*numlambda)]);

if nargout >=1
    sources=fg(1,:);
    sources=sources(:,1:(size(sources,2)-rem(size(sources,2),numlambda.*(numsources))));
    varargout{1}=reshape(sources,[1 numlambda (numsources) prod(size(sources))./(1.*(numsources).*numlambda)]);
    
    if nargout >=2
        Marks=ceil((find(fg(end,:)>0))./numlambda./(numsources));
        varargout{2}=Marks;
    end
end


return
