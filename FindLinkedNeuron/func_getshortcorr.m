function [shortcorr] = func_getshortcorr(PSTH,i,UnitLen,TrialLen)
shortbin = 5;
SpikePoint = find(PSTH(i,:) == 1);
LenSpike = length(SpikePoint);
shortcorr = zeros(UnitLen,shortbin*LenSpike);
xNeuron = PSTH;
CountS = 1;
if SpikePoint(LenSpike) + shortbin > TrialLen
    SpikePoint = SpikePoint(1:LenSpike-shortbin);
end
for j = SpikePoint
    shortcorr(:,CountS:CountS+shortbin) = xNeuron(:,j:j+shortbin); %5ms of spike prob
    CountS = CountS + shortbin + 1;
end

return