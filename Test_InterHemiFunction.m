% To find interhemispheric linked neurons
clear
clc
close all

%% Initialization
Animals = {'wScx1'};
SEssions = {[2]};
%Animals={'TArPray1','TArPray3','TArPray6','wScx2' ,'wScx1','SNr_R02' 'TRN_01','TRN_02' 'ChR2_01' 'ChR2_03' 'ChR2_04' 'ChR2_06' 'mPFC_01' 'mPFC_03' 'mPFC_05' 'mPFC_06' 'mPFC_07'};
%SEssions={[1 2 3 4 5] [1 2 3 4 5] [1 2 3 4 5] [3 4 6 7]  [1 2] [1 2 3] [1 2 3 4] [1 2 3 4] [1 2 3 ] [1 2 3 4 5 ] [1 2 3 4] [1 2 3 4] [1 2 3] [1 2 3 4] [1] [1 2 ] [1 2 3]};

SessN = 0;
ParameterFileNeuroPixelAndBefore;
EP = [];%Estimated pairs/ output as 'ttal'


%% set parameters
CountTimeS = 5; %set jitter iterations 1000times recommended
direction = 3; % set trial direction used to calculate; 1-left 2-right 3-all
Phase = 1; %set compute phase 0 sample 1 delay
LowerNeuronNumbers = 6;
VisPairs = 0;%Pair information statistics 0 No vis/ 1 visualize
%%
for Ani=1:length(ana.Animals)
    for Sess=SEssions{Ani}
        Probe = 0;
        [ChoseUnitsAL, ChoseTrialsAL, CLeftTrialsL, CRightTrialsL, objL] = func_getChoseUnitTrials(Probe,ana,Ani,Sess);
        if length(ChoseUnitsAL)<LowerNeuronNumbers
            disp([Animals{Ani} 'Probe' num2str(NowAnalysing) ':Session' num2str(Sess) '  '  base, 'has neurons less than', num2str(LowerNeuronNumbers)])
            continue
        end
        UnitobjL = objL.units;
        
        Probe = 1;
        [ChoseUnitsAR, ChoseTrialsAR, CLeftTrialsR, CRightTrialsR, objR] = func_getChoseUnitTrials(Probe,ana,Ani,Sess);
        if length(ChoseUnitsAR)<LowerNeuronNumbers
            disp([Animals{Ani} 'Probe' num2str(NowAnalysing) ':Session' num2str(Sess) '  '  base, 'has neurons less than', num2str(LowerNeuronNumbers)])
            continue
        end
        UnitobjR = objR.units;
        ANATL = func_getSpikeTrain(ChoseUnitsAL,direction,ChoseTrialsAL, CLeftTrialsL,CRightTrialsL,UnitobjL,Phase);
        ANATR = func_getSpikeTrain(ChoseUnitsAR,direction,ChoseTrialsAR, CLeftTrialsR,CRightTrialsR,UnitobjR,Phase);
        
        [LinkedLoc, TransEffe] = func_findInterHemiLink(ANATL,ANATR,CountTimeS);

        SessN = SessN + 1;
        UnitLen = length(ChoseUnitsAL) + length(ChoseUnitsAR);
        EstimatedPairs = UnitLen^2/2;
        EP = [EP EstimatedPairs];
        ttal = sum(EP)
    end
end

%%
if VisPairs == 1
    LenLL = length(find(NeuPairId == 0.1));
    LenRR = length(find(NeuPairId == 0.2));
    LenLR = length(find(NeuPairId == 1.1));
    LenRL = length(find(NeuPairId == 1.2));
    lenlen = [LenLL LenRR LenLR LenRL];
    figure
    bar(lenlen)
    set(gca,'XTicklabel',{'L-L','R-R','L-R','R-L'})
    figure
    boxplot(TransEffe)
end