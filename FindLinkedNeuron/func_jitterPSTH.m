function [jitter_data] = func_jitterPSTH(PSTH,i,TrialLen)
% jitter spike train in 5ms
% i_label of neuron whose spike should be preserved while others jittered
iNeuron = PSTH(i,:);
[loci,locj] = find(PSTH == 1);
TargetLocj = find(locj > 6 & locj < TrialLen - 6);
loci = loci(TargetLocj);
locj = locj(TargetLocj);
Randshift = randi(11,length(locj),1)-6*ones(size(locj));
Newlocj = Randshift + locj;
for ii = 1:length(loci)
    PSTH(loci(ii),locj(ii)) = 0;
    PSTH(loci(ii),Newlocj(ii)) = 1;
end
jitter_data = PSTH;
jitter_data(i,:) = iNeuron;


return