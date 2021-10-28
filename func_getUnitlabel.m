% to label left or right preference neuron
function [labeli,labelj] = func_getUnitlabel(ChoseUnitsA,ChoseTrialsA, CLeftTrials,CRightTrials,unitobj,Neuroni,Neuronj,Phase)
Len = length(ChoseUnitsA);
Div = zeros(Len,20);
for Count = 1:15    
    direction = 1;
    CLeftTrialsC = randsample(CLeftTrials,60);
    ANATL = func_getSpikeTrain(ChoseUnitsA,direction,ChoseTrialsA, CLeftTrialsC,CRightTrials,unitobj,Phase);

    direction = 2;
    CRightTrialsC = randsample(CRightTrials,60);
    ANATR = func_getSpikeTrain(ChoseUnitsA,direction,ChoseTrialsA, CLeftTrials,CRightTrialsC,unitobj,Phase);

    dive = sum(ANATL,2) - sum(ANATR,2);
    Div(:,Count) = dive; 
end

MeanDiv = mean(Div,2);  
if MeanDiv(Neuroni,:) > 0
    labeli = 'L';
else
    labeli = 'R';
end

if MeanDiv(Neuronj) > 0
    labelj = 'L';
else
    labelj = 'R';
end

return
