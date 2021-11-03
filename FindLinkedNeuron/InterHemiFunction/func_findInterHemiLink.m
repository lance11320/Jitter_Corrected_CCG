function [LinkedLoc, TransEffe] = func_findInterHemiLink(ANATL,ANATR,CountTimeS)
% Input: Left and right hemisphere neuron x time spike train (All trial
% combined); CountTimeS: jitter times;
% Output: Neuronlabel and Transmission efficiency; the right hemi label
% need to be examined afterwards and minus left unit length;
% Calculate for a single session, to combine all session, add more outside this func; 
%%
TransEffe = [];%Transmission efficiency
ANAT = [ANATL;ANATR];
UnitLenL = size(ANATL,1);
UnitLen = size(ANAT,1);
TrialLen = size(ANAT,2);

CorrMat = cell(UnitLen , UnitLen);
CorrMatj = cell(CountTimeS , UnitLen , UnitLen);
JitteredCorrMat = [];
JCell = cell(UnitLen, UnitLen);
BarConfidence= cell(UnitLen, UnitLen);
Bardown= cell(UnitLen, UnitLen);
BarGlobal= cell(UnitLen, UnitLen);
BarMax = cell(UnitLen, UnitLen);
MeanCell = cell(UnitLen, UnitLen);
SDCell = cell(UnitLen, UnitLen);
JCoCorrMat = zeros(UnitLen,UnitLen);
JCorrMatDown = zeros(UnitLen,UnitLen);
LinkStrMat = zeros(UnitLen,UnitLen);

Waitbar = ['/']; 

for i = 1:UnitLen
    PercentCharLen = length([num2str(100*i/UnitLen),'/']);
    WaitBar = repmat(Waitbar,1,UnitLen+PercentCharLen);
    WaitBar(i:i+PercentCharLen-1) = [num2str(100*i/UnitLen),'%'];
    disp(WaitBar)
    tic
    parfor Count = 1:CountTimeS
        %Jitter PSTH
        ANATj = func_jitterPSTH(ANAT,i,TrialLen);
        %Short bin to corr(shorter calculation time)(this can be deleted if
        %being asked for full matrix and that will allow direct change of lag)
        shortcorr = func_getshortcorr(ANATj,i,UnitLen,TrialLen);
        ANATj = shortcorr;

        %Calculating correlogram
        for j = 1:UnitLen
            SpikePoint1 = find(ANATj(i,:) == 1);
            LenSpike1 = length(SpikePoint1);
            SpikePoint2 = find(ANATj(j,:) == 1);
            LenSpike2 = length(SpikePoint2);
            [Corrvec1,lag] = xcorr(ANATj(i,:),ANATj(j,:),5);
            CorrMatj{Count,i,j} = Corrvec1;%/sqrt(LenSpike1*LenSpike2);
        end


    end
    toc
end

for i = 1:UnitLen
    parfor j = 1:UnitLen
        JitteredCorrMat = zeros(CountTimeS,11);
        for Count = 1:CountTimeS
            JitteredCorrMat(Count,:) = CorrMatj{Count,i,j};
            JCell{i,j} = JitteredCorrMat;%CountS Times Jitter i-j correlogram; Jitter x TimeLag;
        end
        JcorrmatE = JCell{i,j};
        MeanSum = nanmean(JCell{i,j});
        Barsmax = max(JCell{i,j});
        MeanCell{i,j} = MeanSum;
        SD = nanstd(JCell{i,j});
        SDCell{i,j} = SD;
        BarsUp = MeanSum + 7*SD;
        
        Ones = ones(size(BarsUp));
        Allbars = mean(BarsUp) + 2*std(BarsUp);
        
        Barglobal = Allbars*Ones;
        BarsDown = MeanSum - 2*SD;
        BarConfidence{i,j} = BarsUp;
        Bardown{i,j} = BarsDown;
        BarGlobal{i,j} = Barglobal;
        BarMax{i,j} = Barsmax;
    end
end

%% Get Correlogram

for i = 1:UnitLen
    xNeuron = ANAT;
    %Short bin to corr(shorter calculation time)(can be deleted if
    %asking for full matrix)
    shortcorr = func_getshortcorr(xNeuron,i,UnitLen,TrialLen);
    xNeuron = shortcorr;

    for j = 1:UnitLen
        SpikePointi = find(xNeuron(i,:) == 1);
        LenSpikei = length(SpikePointi);
        SpikePointj = find(xNeuron(j,:) == 1);
        LenSpikej = length(SpikePointj);
        [Corr,lag] = xcorr(xNeuron(i,:),xNeuron(j,:),5);
        CorrMat{i,j} = Corr;%/sqrt(LenSpikei*LenSpikej);
    end
end
for i = 1:UnitLen
    for j = 1:UnitLen
        %JCoCorr = CorrMat{i,j} - BarConfidence{i,j};
        JCoCorr = CorrMat{i,j} - BarGlobal{i,j};
        loc = find(JCoCorr == max(JCoCorr));
        if lag(loc) == 0
            JCoCorr(loc) = 0;
            JCoCorrMat(i,j) = max(JCoCorr);
        else
            JCoCorrMat(i,j) = max(JCoCorr);
        end

        LinkStrength = (CorrMat{i,j} - MeanCell{i,j})./SDCell{i,j};
        locL = find(LinkStrength == max(LinkStrength));
        if lag(locL) == 0
            LinkStrength(locL) = 0;
            LinkStrMat(i,j) = max(LinkStrength);
        else
            LinkStrMat(i,j) = max(LinkStrength);
        end

        DownLim = CorrMat{i,j} - Bardown{i,j};
        JCorrMatDown(i,j) = min(DownLim);%to detect negative connection
    end
end

PlotMat = JCoCorrMat;
% figure
% imagesc(PlotMat)
% colormap(jet)
% %caxis([-1 1])
% colorbar

figure
imagesc(LinkStrMat)
colormap(jet)
colorbar

%% plot PSTH to identify
[loci,locj] = find(PlotMat > 0);
NeuroLoc = [loci locj];
Sizeloc = size(NeuroLoc,1);
LinkedLoc = [];
for ii = 1:Sizeloc
    Neuroni = loci(ii);
    Neuronj = locj(ii);
    if Neuroni ~= Neuronj
        shortcorr = func_getshortcorr(ANAT, Neuroni, UnitLen, TrialLen);
        ispikes = shortcorr(Neuroni,:);
        jspikes = shortcorr(Neuronj,:);
        PairPSTH = [ispikes
            jspikes];
        SumSpike = sum(PairPSTH,2);
        TransProb = SumSpike(2)/SumSpike(1);
        if length(PairPSTH) > TrialLen/1000 && TransProb > 0.08%firing rate > 5Hz approximately
            CorrelogramPlot = CorrMat{Neuroni,Neuronj};
            BandPlot = BarConfidence{Neuroni,Neuronj};
            GlobalPlot = BarGlobal{Neuroni,Neuronj};
            MaxPlot = BarMax{Neuroni,Neuronj};
            figure
            bar(CorrelogramPlot,1,'k')
            hold on
            plot(BandPlot,'linewidth',2)
            hold on
            plot(GlobalPlot,'--')
            hold on
            plot(MaxPlot)
            %saveas(gcf,['D:\OneDrive\GuoLab\SaveResultsFolder\PostSynapticSpikeProb\Correlogram',ana.Animals{Ani},'Sess',num2str(Sess),'_',num2str(Neuroni),'-',num2str(Neuronj)]);
            figure
            imagesc(PairPSTH)
            colormap(jet);
            caxis([0 2]);
            colorbar
            %saveas(gcf,['D:\OneDrive\GuoLab\SaveResultsFolder\PostSynapticSpikeProb\PairPSTH',ana.Animals{Ani},'Sess',num2str(Sess),'_',num2str(Neuroni),'-',num2str(Neuronj),'-',num2str(TransProb)]);
            LinkedLoc = [LinkedLoc ; Neuroni Neuronj];
            TransEffe = [TransEffe TransProb];
        else
            disp('No enough spikes')
        end
    end
end



%%
% [loci,locj] = find(DownLim < 0);
% NeuroLoc = [loci locj];
% Sizeloc = size(NeuroLoc,1);
% for ii = 1:Sizeloc
%     if isempty(loci)
%         disp('No Negative Connection found')
%     else
%         Neuroni = loci(ii);
%         Neuronj = locj(ii);
%         if Neuroni ~= Neuronj
%             shortcorr = func_getshortcorr(ANAT, Neuroni, UnitLen, TrialLen);
%             ispikes = shortcorr(Neuroni,:);
%             jspikes = shortcorr(Neuronj,:);
%             PairPSTH = [ispikes
%                 jspikes];
%
%
%             %if sum(PairPSTH,2) > 1
%             if length(PairPSTH) > 600
%                 figure
%                 imagesc(PairPSTH)
%                 colormap(jet);
%                 caxis([0 2]);
%                 colorbar
%             else
%                 disp('No enough spikes')
%             end
%
%         end
%     end
% end





