function [ChoseUnitsA, ChoseTrialsA, CLeftTrials, CRightTrials, obj] = func_getChoseUnitTrials(Probe,ana,Ani,Sess)
%Probe is 0/1 deciding which probe data to load
NowAnalysing = Probe;
LoadingFileOrigin;

CellType=[1];
AuditoryWhiskerSelective=0;
SelectiveSampleOnly=[0];% 0: plot all.  1: plot left selective , -1: plot right selective, 4 nonselective
SelectiveDelayOnly=[0];
SelectiveResponseOnly=[0];
SpikesLength=1000;
DeletePrelicking=1;
LowerNeuronNumbers=6; %only reserve sessions with more than LowerNeuronNumbers neurons.
InhibitionPeriod=1; % 0 sample, 1 delay; for stim trials
DidNotDiscriminateCorrectWrong=1; % 0 contain only correct trials, 1 contain correct and error trials
LeastCoverage=0.6; % according to the least coverage to choose neurons.
MinTrialLengthPermitted=200;
StimTrialLength=8;
UnitsTypeA=[];
for i=1:100
    PSTHALLA{i}=[];
end

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
else
    UnitsAll=obj.units;
    ChoseCells;
    UA=find(CellsPlot);
    ChoseUnitsA=intersect(ChoseUnitsA,UA);
    UnitsLengthThisType=length(ChoseUnitsA);

    display(['ChoseUnitsA' num2str(length(ChoseUnitsA))  '   ChoseTrialsA' num2str(length(ChoseTrialsA))])
    if UnitsLengthThisType<LowerNeuronNumbers
        disp(['Session' num2str(Sess) '  '  base, 'has neurons less than', num2str(LowerNeuronNumbers)])
        CLeftTrials = 0; CRightTrials = 0;
    else
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
    end
end


return