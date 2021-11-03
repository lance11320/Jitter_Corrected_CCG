% this is to test and find related units
clear
clc
close all
%% Initialization

Animals={'TArPray1','TArPray3','TArPray6','wScx2' ,'wScx1','SNr_R02' 'TRN_01','TRN_02' 'ChR2_01' 'ChR2_03' 'ChR2_04' 'ChR2_06' 'mPFC_01' 'mPFC_03' 'mPFC_05' 'mPFC_06' 'mPFC_07'};
SEssions={[1 2 3 4 5] [1 2 3 4 5] [1 2 3 4 5] [3 4 6 7]  [1 2] [1 2 3] [1 2 3 4] [1 2 3 4] [1 2 3 ] [1 2 3 4 5 ] [1 2 3 4] [1 2 3 4] [1 2 3] [1 2 3 4] [1] [1 2 ] [1 2 3]};
NowAnalysing = 1;

ParameterFileNeuroPixelAndBefore;
LowerNeuronNumbers=6; %only reserve sessions with more than LowerNeuronNumbers neurons.
DeletePrelicking=1;
SessN = 0;
smoothTime=10;
CellType=[1]; % cautions
SpikesLength=1000;
DidNotDiscriminateCorrectWrong=1; % 0 contain only correct trials, 1 contain correct and error trials
LeastCoverage=0.6; % according to the least coverage to choose neurons.
MinTrialLengthPermitted=200;
StimTrialLength=8;
UnitsTypeA=[];
for i=1:100
    PSTHALLA{i}=[];
end
AuditoryWhiskerSelective=0;
SelectiveSampleOnly=[0];% 0: plot all.  1: plot left selective , -1: plot right selective, 4 nonselective
SelectiveDelayOnly=[0];
SelectiveResponseOnly=[0];


EP = [];
NeuPairLabel = [];
NeuPairId = [];
TransEffe = [];
%% loading file and choose cell
for Ani=1:length(ana.Animals)
    for Sess=SEssions{Ani}
        LoadingFileOrigin;
        SessN = SessN + 1;
        if DeletePrelicking==1
            obj.LickingAnalysis;
            trimTrials=obj.licking.PreLickingTrials;
            obj.trim = unique([obj.trim trimTrials]);
            obj.Trim_Trials(trimTrials);
        end
        
        % delete bad trials
        %BadTrials=BadTrialsA{Ani}{Sess};
        BadTrials=[];
        if length(BadTrials)>1
            obj.trim = unique([obj.trim BadTrials]);
            obj.Trim_Trials(BadTrials);
        end
        ChoseUnitsA=1:length(obj.units);
        ChoseTrialsA=1:length(obj.sides);
        
        if length(ChoseTrialsA)<80
            disp('Chose Trial Not Satisfied! ')
            continue;
        end
        % units length
        UnitsAll=obj.units;
        ChoseCells;
        UA=find(CellsPlot);
        ChoseUnitsA=intersect(ChoseUnitsA,UA);
        UnitsLengthThisType=length(ChoseUnitsA);
        
        display(['ChoseUnitsAï¼?' num2str(length(ChoseUnitsA))  '   ChoseTrialsAï¼?' num2str(length(ChoseTrialsA))])
        if UnitsLengthThisType<LowerNeuronNumbers
            display([Animals{Ani} ':Session' num2str(Sess) '  '  base, 'has neurons less than', num2str(LowerNeuronNumbers)]);
            continue;
        end
        
        GetTrials_NeuropixelProbe;
        PlotStringPlotMatrixNormal;
        if DidNotDiscriminateCorrectWrong==0
            CLeftTrials=find(obj.trialsLNoStim.hitHistory ); % correct left trials
            CRightTrials=find(obj.trialsRNoStim.hitHistory );
            
        elseif DidNotDiscriminateCorrectWrong==1
            CLeftTrials=find((obj.trialsLNoStim.hitHistory | obj.trialsLNoStim.missHistory));
            CRightTrials=find((obj.trialsRNoStim.hitHistory | obj.trialsRNoStim.missHistory));
        end
        CLeftTrials=intersect(CLeftTrials,ChoseTrialsA);
        CRightTrials=intersect(CRightTrials,ChoseTrialsA);
        
        
        FindlinkedNeurons;

    end
end

