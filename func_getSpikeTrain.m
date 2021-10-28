function [ANAT] = func_getSpikeTrain(ChoseUnitsA,direction,ChoseTrialsA, CLeftTrials,CRightTrials,unitobj,Phase)
if Phase == 0 %Sample
    TimeZone = [0 1];
elseif Phase == 1 %Delay
    TimeZone = [1 2];
end
binsize = 0.001;

if direction == 1
    ntrial = CLeftTrials;
elseif direction == 2
    ntrial = CRightTrials;
else
    ntrial = ChoseTrialsA;
end
LenTrial = length(ChoseTrialsA);
ANAT = zeros(length(ChoseUnitsA),1001*length(ntrial));
parfor locu = 1:length(ChoseUnitsA)
    u = ChoseUnitsA(locu);
    Alltrialcount = [];
    unit=unitobj{u};
    SpikeTimes=unit.spike_times_timeAlignToSample;
    SpikeTimes_AllTrials=cell(LenTrial,1);
    for i_trial=ChoseTrialsA
        loci = find(ChoseTrialsA == i_trial);
        SpikeTimes_AllTrials{loci,1} = SpikeTimes(unit.trials==i_trial);
    end
    for itrial = ntrial
        [counts] = hist(SpikeTimes_AllTrials{itrial,1},TimeZone(1):binsize:TimeZone(2));%0-1 sample 1-2 delay
        Alltrialcount = [Alltrialcount  counts];
    end
    ANAT(locu,:) = Alltrialcount;%Neuron x trial spike PSTH
    
    %ProbSpikeA = mean(ANAT,2); %average spike prob of neurons
    
end
ANAT(ANAT>1) = 0;
return