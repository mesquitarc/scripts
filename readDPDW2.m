function [A,phi,In,Qu,t,varargout] = readDPDW2(fname,numdets,numlambda,numsources,wholecycle,plotint)

% This function reads the filename with directory, the total number of detectors, 
% wavelengths and sources, respectively. As output, it gives
% amplitude,phase,in-phase,quadrature and time (in seconds) data in a 4-D matrix, reshaped as
% [source wavelength dets frames]
% If available, one can get also src and Marks as output
% 
% It is called 2 because this is a 2nd version of readDPDW for homodyne
%
% Example: [A,p,I,Q,t,marks,src] = readDPDW2('/mnt/d/rickson/test_',4,3,4,21) 
%     for 4 detectors, 3 lambdas, 4 sources, with 21 total measurements for each cycle 
%
% Total # of measurements is counted by the number of lines of each file
% before it starts repeting the same pair src/wavelength (that will give
% you the right marks).
%
% Modified by: R. Mesquita ( 2009/09/02 )
%

% 2009/04/07:
% Major difference is how to get A,phi,I/Q... Im going with a loop that
% matches the sources, than the lambdas; for each one loop (i,j), we get
% all frames for all 4 detectors..
%
% 2009/05/04: 
% Marks are being obtained by a different way; maybe another point to check
% after running the code...
% 
% 2009/09/02:
% Marks are being obtained by the total number of different measurements
% that each file has, rather than dividing by (#lambdas * #srcs); for this,
% wholecycle must be a parameter for the function
%
% 2009/10/30:
% Removed frame as output; now, it outputs time, in seconds

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
fg = fg';
for i=1:numsources
    lst = find(fg(:,1)==i);
    fg2 = fg(lst,:);
    for j=1:numlambda
        lst2 = find(fg2(:,2)==j);
        fg3 = fg2(lst2,:);
        % Because flow generates 3 data points each cycle, divide fg3 by 3
        if j==4
            foo = fg3(1:3:end,:);
            clear fg3
            fg3 = foo;
        end
                
        if (exist('A') & size(fg3,1)~=size(A,4) )
            fg3(end+1:size(A,4),:) = NaN;
        end
        A(i,j,:,:) = fg3(:,3:5:22)';
        phi(i,j,:,:) = fg3(:,4:5:22)';
        In(i,j,:,:) = fg3(:,5:5:22)';
        Qu(i,j,:,:) = fg3(:,6:5:22)';
    end
end

fr = 1:size(A,4);
fr = fr';
time=fg(1:wholecycle:end,[41 39 40 42 43 44]);
% correct for 24hrs
rk = find(time(:,4)==1);
time(rk,4)=13;
rk = find(time(:,4)==2);
time(rk,4)=14;
rk = find(time(:,4)==3);
time(rk,4)=15;
rk = find(time(:,4)==4);
time(rk,4)=16;
rk = find(time(:,4)==5);
time(rk,4)=17;
rk = find(time(:,4)==6);
time(rk,4)=18;
rk = find(time(:,4)==7);
time(rk,4)=19;
rk = find(time(:,4)==8);
time(rk,4)=20;


t(1) = 0;
for i=2:size(time,1)
    t(i) = t(i-1) + etime(time(i,:),time(i-1,:));
end
t = t';

if nargout >=1
    
    if nargout >=2
        lst = find(fg(:,end)>0);
        nlst = lst(1);
        for i=2:length(lst)
            if lst(i)~=lst(i-1)+1
                nlst=[nlst lst(i)];
            end
        end
        Marks=ceil(nlst./wholecycle);
        varargout{1}=Marks;
    end
%     % Get marks
%     m0 = find(fg(:,45)>0);
%     m1 = ceil((m0./numlambda)./(numsources+1)); % +1 because there is the flow part of the code...
%     marks = zeros(size(A,4),1);
%     marks(m1)=1;
%     varargout{1}=marks;

    if nargout >=2
        sources=fg(1,:);
        sources=sources(:,1:(size(sources,2)-rem(size(sources,2),numlambda.*(numsources))));
        varargout{2}=reshape(sources,[1 numlambda (numsources) prod(size(sources))./(1.*(numsources).*numlambda)]);
    end
    
    if nargout >=2
        Aux = fg(1:wholecycle:end,23:27);
        varargout{3}=Aux;
    end
end

if plotint    
    for j=1:numsources
        figure;
        for i = 1:numdets
            subplot(2,2,i)
            plot(1:size(A,4),1000*squeeze(A(j,:,i,:)));
            title(['NIRS - Source ' num2str(j) ', Detector ' num2str(i)]);
            xlabel('Frame'); ylabel('Amplitude (mV)');
            legend('830','785','685');
            for k=1:length(Marks)
                line([Marks(k) Marks(k)],1000*[min(min(squeeze(A(j,:,i,:)))) max(max(squeeze(A(j,:,i,:))))],'Color',[0 0 0]);
                text(Marks(k), 1000*max(max(squeeze(A(j,:,i,:)))), num2str(k), 'Color', 'b');
            end
        end
    end
end

return
