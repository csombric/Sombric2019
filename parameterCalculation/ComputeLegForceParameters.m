function [SB, SBsum, SP, SPsum, SY_FTO, SBmax, SBmax_ABS, SBmaxQS, SPmax, SYZMag, SPmaxQS, ImpactMagS, SPmaxNoNaN, SBmaxNoNaN] = ComputeLegForceParameters(striderS,  LevelofInterest, FlipB, titleTXT)
%This function computes kinetic descriptors of individual strides

if nargin<4 || isempty(titleTXT)
    titleTXT='';
end

% Identify the postitive (propulsion) and negative (breaking) data points within a stride
ns=find((striderS-LevelofInterest)<0);
ps=find((striderS-LevelofInterest)>0);

% We dont' want to consider the impact magnitures so we need to identify
% when these transient behaviors have peaked.
[ImpactMagS, ImpactSWhere]=nanmax(striderS(1:0.15*length(striderS)));%-LevelofInterest

if isempty(ImpactSWhere)~=1
    if striderS(ImpactSWhere)>0 && sum((striderS(ps)-LevelofInterest)<0)>0
        postImpactS=ns(find(ns>ImpactSWhere(end), 1, 'first'));
    else% If the impact peak is negative I am just going to ignore everything that happened before this peak behavior
        postImpactS=ImpactSWhere;
    end
    if isempty(postImpactS)~=1
        ps(find(ps<postImpactS))=[];
        ns(find(ns<postImpactS))=[];
    end
end

if isempty(ns)
    SB=NaN;
    SBsum=NaN;
else
    SB=FlipB.*(nanmean(striderS(ns)-LevelofInterest));
    SBsum=FlipB.*nansum(striderS(ns)-LevelofInterest);
end

if isempty(ps)
    SP=NaN;
    SPsum=NaN;
else
    SP=nanmean(striderS(ps)-LevelofInterest);
    SPsum=nansum(striderS(ps)-LevelofInterest);
end

ns_ALL=ns;
ps_ALL=ps;

ns(find(ns>=0.9*length(striderS)))=[]; % 2/14/2018 -- This is to prevent us from identifiying the tail end of the trace as teh braking force 4/11/2017 CJS
ps(find(ps<=0.1*length(striderS)))=[]; % 2/14/2018 -- This is to prevent the impulse from being identified.

SY_FTO=NaN; % Remove this, it doesn't make sence to compute

if isempty(ns)
    SBmax=NaN;
    SBmax_ABS=NaN;
    SBmaxQS=NaN;
    SBmaxNoNaN=nanmin(striderS(ps));
else
    [SBmax MinWhereS]=nanmin(striderS(ns));%-LevelofInterest
    SBmax=FlipB.*SBmax;
    SBmaxNoNaN=SBmax;
    SBmaxQS=SBmax-2.*FlipB.*(LevelofInterest);
    SBmax_ABS=FlipB.*(nanmin(striderS-LevelofInterest));
end
 
if isempty(ps)
    SPmax=NaN;
   SPmaxQS=NaN;
   SPmaxNoNaN=nanmax(striderS(ns));
else
    [SPmax MaxWhereS]=nanmax(striderS(ps));%-LevelofInterest
    SPmaxQS=SPmax-2.*LevelofInterest;
    SPmaxNoNaN=SPmax;
end

% if isempty(ps) || ps(MaxWhereS)<=0.1*length(striderS)
%     figure
%     plot(striderS, 'k'); hold on
%     line([0.1*length(striderS) 0.1*length(striderS)], [-.2 .2])
%     line([0.9*length(striderS) 0.9*length(striderS)], [-.2 .2])
%     if isempty(ps)~=1
%         plot(ps(MaxWhereS), striderS(ps(MaxWhereS)), 'r*')
%         plot(ns(MinWhereS), striderS(ns(MinWhereS)), 'b*')
%     end
%     title(titleTXT)
% end

 SYZMag=NaN;% New
end