%
% ZG, 3/12.
%


classdef delayedResponseTask < handle  %YX 2017/1/16 "The handle class is the superclass for all classes that follow handle semantics. A handle is a reference to an object. If you copy an object's handle variable, MATLAB? copies only the handle. Both the original and copy refer to the same object. For example, if a function modifies a handle object passed as an input argument, the modification affects the original input object."
    
    properties
        mouseName = '';     % e.g. THU00001
        sessionName = '';   % e.g. 'D:\users\...\data_@delayedResponseTask_THU00001_20141108a.mat'
        sessionType = ''; % e.g. 'Discrim_Delay'
        sessionNameTag = '';    %e.g. 'TwoPolewithDelay_leftALMRecording_leftALM_multiplePower_Delay_cosine_Guo'
        weightBeforeExp = 0;
        weightAfterExp = 0;
        notes = '';
        %%%%%%%%%%%%%%%%%%%% general stuff
        laser='';
        path='';
        mainFig=[];
        analysisFig=[];
        start=0;
        objBreak=0;
        analysis='';
        realTimeStates=[];
        %%%%%%%%%%%%%%%%%%%%%%%%
        stimType;       % sample, delay or mixted et al
        stimProb;       % 0.25 0.5 0.75 or any other number
        stimProtocol;   % which stim protocol used;
        leftTrialProb;  % 0.5
        autoLearn;
        maxSame;        % typically 3
        
        leftValveTime;  % 0.1
        rightValveTime; %
        
        samplePeriod;   % 1s
        delayPeriod;    % 1s
        responsePeriod; % 1s
        extraITI;       % 0.01s
        
        eventsHistory;  % state matrix history, 1 x n cell array
        locomotionHistory; %2016/7/16 added by CH @ Glab,Tsinghua. locomotion history, 1 x n cell array
        locomotiontypes; % 2016/12/?
        sides;          % left or right, 1x n array, for convenience left == 0, right == 1;
        types;           % 1: stim; 0: no-stim, 1x n array
        aomPowerHistory;% in unit V, can be translated into real laser power, 1x n array
        xGalvoHistory;  % in unit V, can be translated into real coordinates, 1x n array
        yGalvoHistory;  % in unit V, 1x n array
        stimTypes;      % a cell array contains stimulation types;
        stimStateHistory;   % a single number indicating which stim type was chosen, 0: no stim on whikser contact; 1: stim on trigger, reserved; 3: sample period; 4: delay period; 5: response period
        trim;               % indicate which trial to trim, 1 x n array, 0 trials not included in analysis, 1 trials are good.
        stim_Galvo_pos_sequence;  % a variable to store the sequence of galvo parameters executued
        stimProtocolHistory;
        
        trials;         % structure contains basic statistics of that trial type, trials.hitHistory, trials.missHistory, trials.noResponseHistory
        trialsR;        % right trials
        trialsL;        % left trials
        trialsRNoStim;        % R no stim
        trialsLNoStim;        % L no stim
        trialsRStim;    % right trials with stim
        trialsLStim;    % left trials with stim
        
        aom;    % 4xnx2 matrix; right: 4xnx1; left: 4xnx2; (1,:,:) hit rate; (2,:,:) correct number; (3,:,:) totoal number; (4,:,:) aom voltage;
        
        xGalvoPos;
        yGalvoPos;
        galvoHitR;
        galvoHitL;
        galvoNumR;
        galvoNumL;
        
        galvoHitRSample;
        galvoHitLSample;
        galvoNumRSample;
        galvoNumLSample;
        
        galvoHitRDelay;
        galvoHitLDelay;
        galvoNumRDelay;
        galvoNumLDelay;
        
        galvoHitRResponse;
        galvoHitLResponse;
        galvoNumRResponse;
        galvoNumLResponse;
        
        GalvoHistoryUnique;
        
        licking;    % structure has licking.time, and licking.side et al
        sampleTime;   % sample period begin time;
        delayTime;    % delay period begin time;
        cueTime;    % state 56
        stateTransition = [ ];  % to fill in numbers
        
        soloTrialIndex; % This variable only becomes relevant when the arrays were built from multiple solo files
        % i.e. sessions w/ 2 solo files
        % [col1: which file the trial were from, e.g. 1 or 2 to indicate file1 or file2
        %  col2: what is the trial number of this trial in its original solo file]
        
        ephus;   % laser trace, lick trace, bit code, frame trigger, frame gate
        
        units;
        
        user_var;
        
    end
    
    properties (Dependent = true)
        
        
    end
    
    methods (Access = public)
        
        function obj = delayedResponseTask(fileName, trimData, deletePrelicking)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if(nargin==0)
                return;
            end
            
            %%%   read raw solo file
            load(fileName);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.sessionName = fileName;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%% history: hit, miss, no response for total trials, right trials, left trials, right stim trials, left stim trials
            obj.types=obj.types(1:length(obj.trialsR.hitHistory)); %% yinxin
            obj.trialsRNoStim.hitHistory=obj.trialsR.hitHistory & obj.types==0;         %%%% types == 0; no stim
            obj.trialsRNoStim.missHistory=obj.trialsR.missHistory & obj.types==0;
            obj.trialsRNoStim.noResponseHistory=obj.trialsR.noResponseHistory &  obj.types==0;
            
            obj.trialsRStim.hitHistory=obj.trialsR.hitHistory & obj.types==1;         %%%% types == 1; stim
            obj.trialsRStim.missHistory=obj.trialsR.missHistory & obj.types==1;
            obj.trialsRStim.noResponseHistory=obj.trialsR.noResponseHistory & obj.types==1;
            
            obj.trialsLNoStim.hitHistory=obj.trialsL.hitHistory & obj.types==0;         %%%% types == 0; no stim
            obj.trialsLNoStim.missHistory=obj.trialsL.missHistory & obj.types==0;
            obj.trialsLNoStim.noResponseHistory=obj.trialsL.noResponseHistory &  obj.types==0;
            
            obj.trialsLStim.hitHistory=obj.trialsL.hitHistory & obj.types==1;         %%%% types == 1; stim
            obj.trialsLStim.missHistory=obj.trialsL.missHistory & obj.types==1;
            obj.trialsLStim.noResponseHistory=obj.trialsL.noResponseHistory & obj.types==1;
            
            
   
            % 20170806 add sample and delay period stim effects
            Samples=strcmp(obj.stimTypes,'sample_period');
            Delays=strcmp(obj.stimTypes,'delay_period');
            Samples=Samples(1:length(obj.trialsR.hitHistory));
            Delays=Delays(1:length(obj.trialsR.hitHistory));
            
            obj.trialsRStim.hitHistorySample=obj.trialsR.hitHistory & obj.types==1 & Samples;         %%%% types == 1; stim
            obj.trialsRStim.missHistorySample=obj.trialsR.missHistory & obj.types==1 & Samples;
            obj.trialsRStim.noResponseHistorySample=obj.trialsR.noResponseHistory & obj.types==1 & Samples;
            
            obj.trialsRStim.hitHistoryDelay=obj.trialsR.hitHistory & obj.types==1 & Delays;         %%%% types == 1; stim
            obj.trialsRStim.missHistoryDelay=obj.trialsR.missHistory & obj.types==1 & Delays;
            obj.trialsRStim.noResponseHistoryDelay=obj.trialsR.noResponseHistory & obj.types==1 & Delays;
            
            obj.trialsLStim.hitHistorySample=obj.trialsL.hitHistory & obj.types==1 & Samples;         %%%% types == 1; stim
            obj.trialsLStim.missHistorySample=obj.trialsL.missHistory & obj.types==1 & Samples;
            obj.trialsLStim.noResponseHistorySample=obj.trialsL.noResponseHistory & obj.types==1 & Samples;
            
            obj.trialsLStim.hitHistoryDelay=obj.trialsL.hitHistory & obj.types==1 & Delays;         %%%% types == 1; stim
            obj.trialsLStim.missHistoryDelay=obj.trialsL.missHistory & obj.types==1 & Delays;
            obj.trialsLStim.noResponseHistoryDelay=obj.trialsL.noResponseHistory & obj.types==1 & Delays;
            
           
             % 20181027 add response period stim effects
             Response=strcmp(obj.stimTypes,'response_period');
             Response=Response(1:length(obj.trialsR.hitHistory));
             obj.trialsRStim.hitHistoryResponse=obj.trialsR.hitHistory & obj.types==1 & Response;         %%%% types == 1; stim
             obj.trialsRStim.missHistoryResponse=obj.trialsR.missHistory & obj.types==1 & Response;
             obj.trialsRStim.noResponseHistoryResponse=obj.trialsR.noResponseHistory & obj.types==1 & Response;
             obj.trialsLStim.hitHistoryResponse=obj.trialsL.hitHistory & obj.types==1 & Response;         %%%% types == 1; stim
             obj.trialsLStim.missHistoryResponse=obj.trialsL.missHistory & obj.types==1 & Response;
             obj.trialsLStim.noResponseHistoryResponse=obj.trialsL.noResponseHistory & obj.types==1 & Response;
            
             
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%% trim history: trim the beginning, the end trials or any given trials
            
            if(exist('trimData')) 
                if(length(trimData)==2)
                    trimTrials=[1:trimData(1) length(obj.sides)-trimData(2)+1:length(obj.sides)];
                elseif(length(trimData)>2)
                    trimTrials=[1:trimData(1) length(obj.sides)-trimData(end)+1:length(obj.sides) trimData(2:end-1)];
                else
                    trimTrials=[];
                end
            else
                trimTrials=[];
            end
            obj.trim = trimTrials;
            % trims trials (hit miss no response), trialsRNoStim, trialsLNoStim, trialsRStim, trialsLStim, aomPowerHistory, xGalvoHistory, yGalvoHistory
            if (exist('deletePrelicking')) 
                if deletePrelicking==1
                    obj.LickingAnalysis;
                    trimTrials=obj.licking.PreLickingTrials;
                    obj.trim = unique([obj.trim trimTrials]);
                end
            end            
            obj.Trim_Trials(obj.trim);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%% process trial statistics: hit, miss, no response trial nums, rate, length
            
            which_trials='';         exp=obj.Trial_Nums(which_trials);   eval( exp);
            which_trials='RNoStim';        exp=obj.Trial_Nums(which_trials);   eval( exp);
            which_trials='LNoStim';        exp=obj.Trial_Nums(which_trials);   eval( exp);
            which_trials='RStim';    exp=obj.Trial_Nums(which_trials);   eval( exp);
            which_trials='LStim';    exp=obj.Trial_Nums(which_trials);   eval( exp);
        end
        function Session_Name_Tag( obj, nameTag );
            % nameTag is a string with contains a lot of attributes describing the session, here are some examples. You can permuate the key words to
            % account for complex situations
            %             % default stimualtion protocol, 'cosine', if no 'pulse' or 'continuous'
            %
            %             TASK_AREA_STIMCONDITION
            %
            %             TASK:
            %
            %             TwoPoleNoMemory
            %             TwoPoleNoDelay
            %             TwoPoleWithDelay
            %             MultiPoleNoMemory
            %             ReversePoleNoDelay
            %             ReversePoleWithDelay
            %             ReversePoleRecordingWithDelay
            %             ReversePoleRecordingNoDelay
            %             TwoPoleRecordingWithDelay
            %             PassiveRecording
            %
            %             AREA:
            %
            %             S1
            %             leftALM
            %             rightALM
            %             MappingS1
            %             MappingWholeBrain
            %             bilateralALM
            %
            %             STIMCONDITION
            %
            %             singlePower_SampleDelay
            %             singlePower_Sample
            %             singlePower_Delay
            %             singlePower_Reward
            %             multiplePower_SampleDelay
            %             multiplePower_Sample
            %             multiplePower_Delay
            %             multiplePower_Reward
            %
            %             STIMPROTOCOL
            %             cosine
            %             continuous
            %             pulse
            %             protocolComparison for passive recording and behavior sessions comparing effects of silencing
            %             spatialMapping for passive recoring in mapping the spatial extent of stimulation
            %
            %             RESEARCHER
            %             research last name, to facilitate comparison of data from different people
            
            %
            %             e.g.:
            %             TwoPoleWithDelay_MappingWholeBrain_singlePower_Sample  -- whole brain mapping session
            %             TwoPoleWithDelay_leftALM_multiplePower_SampleDelay  -- left ALM dose response curve for sample and delay
            
            % 'S1noMemory';                     s1 stimulation, animals were free to lick
            % 'S1noDelaySample';                s1 stimulation, no delay (delay period 0), stimulate only during sample period
            % 'S1withDelaySampleDelay';         s1 stimulation, with delay, stimulate only during either sample period or delay period
            
            % 'ALMnoMemory';                    alm stimulation, animals were free to lick
            % 'ALMnoDelaySample';               alm stimulation, no delay (delay period 0), stimulate only during sample period
            % 'ALMwithDelaySampleDelay';        alm stimulation, with delay, stimulate only during either sample period or delay period
            % 'ALMwithDelayReward';             alm stmulation, with dealy, during cue and reward period.
            % 'bilateralALMwithDelayReward';    bilateral alm stimulation, with dealy, during cue and reward period.
            
            obj.sessionNameTag=nameTag;
            
        end
        
        function AOM_Nums(obj)
            % this function calculate the hit rate of stim trials at each stimulation power
            % no Response trials are excluded
            Aom_vol=unique(obj.aomPowerHistory); Aom_vol=Aom_vol(Aom_vol~=0);
            
            for jpower=1:length(Aom_vol)
                laserpower=Aom_vol(jpower);
                
                trialsRStim_trialNums=obj.trialsRStim.trialNums;
                trialsLStim_trialNums=obj.trialsLStim.trialNums;
                
                for i=1:length(obj.trialsRStim.noResponseTrialNums)
                    trialsRStim_trialNums(find(trialsRStim_trialNums==obj.trialsRStim.noResponseTrialNums(i)))=[];
                end
                
                for i=1:length(obj.trialsLStim.noResponseTrialNums)
                    trialsLStim_trialNums(find(trialsLStim_trialNums==obj.trialsLStim.noResponseTrialNums(i)))=[];
                end
                
                rstim_correct(jpower)=sum(ismember(obj.aomPowerHistory(obj.trialsRStim.hitTrialNums),laserpower));
%                 rstim_numb(jpower)=sum(ismember(obj.aomPowerHistory(obj.trialsRStim.trialNums), laserpower));
                rstim_numb(jpower)=sum(ismember(obj.aomPowerHistory(trialsRStim_trialNums), laserpower));
                lstim_correct(jpower)=sum(ismember(obj.aomPowerHistory(obj.trialsLStim.hitTrialNums),laserpower));
%                 lstim_numb(jpower)=sum(ismember(obj.aomPowerHistory(obj.trialsLStim.trialNums), laserpower));
                lstim_numb(jpower)=sum(ismember(obj.aomPowerHistory(trialsLStim_trialNums), laserpower));
                
                rhit(jpower)=rstim_correct(jpower)/ rstim_numb(jpower);
                lhit(jpower)=lstim_correct(jpower)/ lstim_numb(jpower);
            end
            
            %rhit
            %rstim_correct
            %rstim_numb
            %aom_voltage
            
            if( ~isempty(Aom_vol) )
                obj.aom(1,:,1)=rhit;
                obj.aom(2,:,1)=rstim_correct;
                obj.aom(3,:,1)=rstim_numb;
                obj.aom(4,:,1)=Aom_vol;
                
                obj.aom(1,:,2)=lhit;
                obj.aom(2,:,2)=lstim_correct;
                obj.aom(3,:,2)=lstim_numb;
                obj.aom(4,:,2)=Aom_vol;
            else
                obj.aom(1,:,1)=0;
                obj.aom(2,:,1)=0;
                obj.aom(3,:,1)=0;
                obj.aom(4,:,1)=0;
                
                obj.aom(1,:,2)=0;
                obj.aom(2,:,2)=0;
                obj.aom(3,:,2)=0;
                obj.aom(4,:,2)=0;
            end
            
        end
        
        function Galvo_Nums(obj)
            % this function calculate the hit rate of stim trials at each stimulation power
            % no Response trials are excluded
            % galvoHitR, galvoHitL, matrix shows hit rate at each galvo position grids, data from different stim power (if there are) are combined.
            

            
            xgalvo_pos_history=obj.xGalvoHistory;
            ygalvo_pos_history=obj.yGalvoHistory;
            
            % 20171105 YX
            coef_xgalvo = 1/4.576031;        % rig 1,V/mm     
            coef_ygalvo = 1/4.745801;
            
%             coef_xgalvo = 1/4.8695;        % rig 2,V/mm
%             coef_ygalvo = 1/5.0935;
            
            ao_chan_scale_Galvo = 20/4096;  
            
            % there are two possible x galvo positions. 20180107
            xgalvo_pos_history=(xgalvo_pos_history*ao_chan_scale_Galvo)/coef_xgalvo;
%             if ~any((xgalvo_pos_history==1.5) | (xgalvo_pos_history==-1.5)  | (xgalvo_pos_history==3.5) | (xgalvo_pos_history==-3.5) )
%                 xgalvo_pos_history=obj.xGalvoHistory;
%                 xgalvo_pos_history=(xgalvo_pos_history*ao_chan_scale_Galvo-0.6)/coef_xgalvo;
%             end
            ygalvo_pos_history=ygalvo_pos_history*ao_chan_scale_Galvo/coef_ygalvo;
            
%             if ~any((xgalvo_pos_history==1.5) | (xgalvo_pos_history==-1.5)  | (xgalvo_pos_history==2.6) | (xgalvo_pos_history==-2.6) )
%                 coef_xgalvo = 1/4.8695;        % rig 2,V/mm
%                 coef_ygalvo = 1/5.0935;
%                 xgalvo_pos_history=obj.xGalvoHistory;
%                 ygalvo_pos_history=obj.yGalvoHistory;
%                 xgalvo_pos_history=(xgalvo_pos_history*ao_chan_scale_Galvo)/coef_xgalvo;
%                 ygalvo_pos_history=ygalvo_pos_history*ao_chan_scale_Galvo/coef_ygalvo;
%             end
            
            
            xgalvo_pos_history(obj.xGalvoHistory==0)=0;
            
            
            xgalvo_unique=unique(xgalvo_pos_history(obj.trials.trialNums));
            ygalvo_unique=unique(ygalvo_pos_history(obj.trials.trialNums));
            
            GalvoHistory(:,1)=xgalvo_pos_history;
            GalvoHistory(:,2)=ygalvo_pos_history;
            obj.GalvoHistoryUnique=unique(GalvoHistory,'rows');
            
            
            for ix=1:length(xgalvo_unique)
                for iy=1:length(ygalvo_unique)
                    
                    % (0,0£© represents control trials. No stim
                    if xgalvo_unique(ix)==0 & ygalvo_unique(iy)==0
                        galvoHitRSample(iy, ix)=sum(xgalvo_pos_history(obj.trialsRNoStim.hitTrialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsRNoStim.hitTrialNums)==ygalvo_unique(iy) );
                        galvoTotalRSample(iy, ix)=(sum(xgalvo_pos_history(obj.trialsRNoStim.trialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsRNoStim.trialNums)==ygalvo_unique(iy) ))-(sum(xgalvo_pos_history(obj.trialsRNoStim.noResponseTrialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsRNoStim.noResponseTrialNums)==ygalvo_unique(iy) ));
                        galvoHitLSample(iy, ix)= sum(xgalvo_pos_history(obj.trialsLNoStim.hitTrialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsLNoStim.hitTrialNums)==ygalvo_unique(iy) );
                        galvoTotalLSample(iy, ix)=(sum(xgalvo_pos_history(obj.trialsLNoStim.trialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsLNoStim.trialNums)==ygalvo_unique(iy) ))-(sum(xgalvo_pos_history(obj.trialsLNoStim.noResponseTrialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsLNoStim.noResponseTrialNums)==ygalvo_unique(iy) ));                    ;
                        
                        galvoHitRDelay(iy, ix)=sum(xgalvo_pos_history(obj.trialsRNoStim.hitTrialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsRNoStim.hitTrialNums)==ygalvo_unique(iy) );
                        galvoTotalRDelay(iy, ix)=(sum(xgalvo_pos_history(obj.trialsRNoStim.trialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsRNoStim.trialNums)==ygalvo_unique(iy) ))-(sum(xgalvo_pos_history(obj.trialsRNoStim.noResponseTrialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsRNoStim.noResponseTrialNums)==ygalvo_unique(iy) ));
                        galvoHitLDelay(iy, ix)= sum(xgalvo_pos_history(obj.trialsLNoStim.hitTrialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsLNoStim.hitTrialNums)==ygalvo_unique(iy) );
                        galvoTotalLDelay(iy, ix)=(sum(xgalvo_pos_history(obj.trialsLNoStim.trialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsLNoStim.trialNums)==ygalvo_unique(iy) ))-(sum(xgalvo_pos_history(obj.trialsLNoStim.noResponseTrialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsLNoStim.noResponseTrialNums)==ygalvo_unique(iy) ));                    ;
                        
                        galvoHitRResponse(iy, ix)=sum(xgalvo_pos_history(obj.trialsRNoStim.hitTrialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsRNoStim.hitTrialNums)==ygalvo_unique(iy) );
                        galvoTotalRResponse(iy, ix)=(sum(xgalvo_pos_history(obj.trialsRNoStim.trialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsRNoStim.trialNums)==ygalvo_unique(iy) ))-(sum(xgalvo_pos_history(obj.trialsRNoStim.noResponseTrialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsRNoStim.noResponseTrialNums)==ygalvo_unique(iy) ));
                        galvoHitLResponse(iy, ix)= sum(xgalvo_pos_history(obj.trialsLNoStim.hitTrialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsLNoStim.hitTrialNums)==ygalvo_unique(iy) );
                        galvoTotalLResponse(iy, ix)=(sum(xgalvo_pos_history(obj.trialsLNoStim.trialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsLNoStim.trialNums)==ygalvo_unique(iy) ))-(sum(xgalvo_pos_history(obj.trialsLNoStim.noResponseTrialNums)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsLNoStim.noResponseTrialNums)==ygalvo_unique(iy) ));                    ;
                        continue
                    end
                    galvoHitRSample(iy, ix)=sum(xgalvo_pos_history(obj.trialsRStim.hitTrialNumsSample)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsRStim.hitTrialNumsSample)==ygalvo_unique(iy) );
                    galvoTotalRSample(iy, ix)=sum(xgalvo_pos_history(obj.trialsRStim.trialNumsSample)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsRStim.trialNumsSample)==ygalvo_unique(iy) );
                    galvoHitLSample(iy, ix)= sum(xgalvo_pos_history(obj.trialsLStim.hitTrialNumsSample)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsLStim.hitTrialNumsSample)==ygalvo_unique(iy) );
                    galvoTotalLSample(iy, ix)=sum(xgalvo_pos_history(obj.trialsLStim.trialNumsSample)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsLStim.trialNumsSample)==ygalvo_unique(iy) );                    ;
                    
                    galvoHitRDelay(iy, ix)=sum(xgalvo_pos_history(obj.trialsRStim.hitTrialNumsDelay)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsRStim.hitTrialNumsDelay)==ygalvo_unique(iy) );
                    galvoTotalRDelay(iy, ix)=sum(xgalvo_pos_history(obj.trialsRStim.trialNumsDelay)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsRStim.trialNumsDelay)==ygalvo_unique(iy) );
                    galvoHitLDelay(iy, ix)= sum(xgalvo_pos_history(obj.trialsLStim.hitTrialNumsDelay)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsLStim.hitTrialNumsDelay)==ygalvo_unique(iy) );
                    galvoTotalLDelay(iy, ix)=sum(xgalvo_pos_history(obj.trialsLStim.trialNumsDelay)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsLStim.trialNumsDelay)==ygalvo_unique(iy) );                    ;
   
                    galvoHitRResponse(iy, ix)=sum(xgalvo_pos_history(obj.trialsRStim.hitTrialNumsResponse)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsRStim.hitTrialNumsResponse)==ygalvo_unique(iy) );
                    galvoTotalRResponse(iy, ix)=sum(xgalvo_pos_history(obj.trialsRStim.trialNumsResponse)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsRStim.trialNumsResponse)==ygalvo_unique(iy) );
                    galvoHitLResponse(iy, ix)= sum(xgalvo_pos_history(obj.trialsLStim.hitTrialNumsResponse)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsLStim.hitTrialNumsResponse)==ygalvo_unique(iy) );
                    galvoTotalLResponse(iy, ix)=sum(xgalvo_pos_history(obj.trialsLStim.trialNumsResponse)==xgalvo_unique(ix) & ygalvo_pos_history(obj.trialsLStim.trialNumsResponse)==ygalvo_unique(iy) );                    ;
   
                end
            end
            obj.xGalvoPos=xgalvo_unique;
            obj.yGalvoPos=ygalvo_unique;
            
            obj.galvoHitRSample=galvoHitRSample./galvoTotalRSample;
            obj.galvoHitLSample=galvoHitLSample./galvoTotalLSample;
        
            obj.galvoNumRSample=[galvoHitRSample; galvoTotalRSample;];
            obj.galvoNumLSample=[galvoHitLSample; galvoTotalLSample;];
            
            obj.galvoHitRDelay=galvoHitRDelay./galvoTotalRDelay;
            obj.galvoHitLDelay=galvoHitLDelay./galvoTotalLDelay;
        
            obj.galvoNumRDelay=[galvoHitRDelay; galvoTotalRDelay;];
            obj.galvoNumLDelay=[galvoHitLDelay; galvoTotalLDelay;];
            
            obj.galvoHitRResponse=galvoHitRResponse./galvoTotalRResponse;
            obj.galvoHitLResponse=galvoHitLResponse./galvoTotalLResponse;
        
            obj.galvoNumRResponse=[galvoHitRResponse; galvoTotalRResponse;];
            obj.galvoNumLResponse=[galvoHitLResponse; galvoTotalLResponse;];
            
        end
        
        function Alarm_Nums(obj) % change state alarm, alarm history
            
            which_trials='';         obj.Alarm_Which_Trials(which_trials);
            which_trials='RNoStim';        obj.Alarm_Which_Trials(which_trials);
            which_trials='LNoStim';        obj.Alarm_Which_Trials(which_trials);
            which_trials='RStim';    obj.Alarm_Which_Trials(which_trials);
            which_trials='LStim';    obj.Alarm_Which_Trials(which_trials);
        end
        
        
        function Pole_Time(obj)
            
            obj.poleTime=zeros(length(obj.eventsHistory),2);
            for ntrial=2:length(obj.eventsHistory)   %%%%%%%%% NL 9/28/12 %%%%%%%%%
                State_Matrix=obj.eventsHistory{ntrial};
                State40_Time=State_Matrix( State_Matrix(:,1)==40, 3 );
                State41_Time=State_Matrix( State_Matrix(:,1)==41, 3 )-State40_Time(1);
                if(length(State41_Time))
                    if ~isempty(find(State_Matrix(:,1)==58))  %%%%%%%%% NL 9/28/12 %%%%%%%%%
                        State58_Time=State_Matrix( State_Matrix(:,1)==58, 3 )-State40_Time(1);
                        obj.poleTime(ntrial,:)=[State41_Time(1); State58_Time(1) ];  % state 41 58: pole starts to move
                    end
                end
            end
            
        end
        
        function Cue_Time(obj)
            
            obj.cueTime=zeros(length(obj.eventsHistory),1);
            for ntrial=2:length(obj.eventsHistory)
                State_Matrix=obj.eventsHistory{ntrial};
                State40_Time=State_Matrix( State_Matrix(:,1)==40, 3 );
                State56_Time=State_Matrix( State_Matrix(:,1)==obj.stateCue, 3 )-State40_Time(1);
                if(length(State56_Time))
                    obj.cueTime(ntrial,:)=[State56_Time(1) ];  % state 56 cue signal
                end
            end
            
        end
        
        
        %% modified by   (v120921), added Response_Time, modified Licking Timing
        function  [Licking_Side, Licking_Timing, State_CueTime, Response_Time]=Lick_SideTime( obj );
            
            %   the function identifies licking events from every trial during a behavior session
            %
            %   Input: State_TrialEvents
            %          State_TrialEvents records states transition during each trial, it's saved in saved_history.RewardsSection_LastTrialEvents
            %
            %   Output: LickingR_Time, the time of licking right lickport
            %           LickingL_Time, the time of licking left lickport
            %           Licking_Time, the time of licking either right or left lickport
            %           Licking_Side, indicate which side the animal first licks (determined by looking at the first 5 licks)
            %           LickingR_State, indicate at which state the animal licks right
            %           LickingL_State, indicate at which state the animal licks left
            %           State_CueTime, onset of cue
            %
            % 10/3/2011 by Zengcai Guo
            
            if( length(obj.eventsHistory) ==0)
                disp( 'must present a state matrix trial events' )
                return;
            end
            
            
            
            %Licking_Timing=zeros(length(obj.eventsHistory),1);     % 
            Licking_Timing=cell(length(obj.eventsHistory),1);       % 
            Licking_Side(1: length(obj.eventsHistory))='n';
            State_CueTime=zeros(length(obj.eventsHistory),1);
            Response_Time = zeros(length(obj.eventsHistory),1);     % 
            for i=1:length(obj.trials.trialNums)
                ntrial=obj.trials.trialNums(i);
                State_Matrix=obj.eventsHistory{ntrial};
                State40_Time=State_Matrix( State_Matrix(:,1)==40, 3 );
                if(~isempty(State40_Time))
                    temp=State_Matrix( State_Matrix(:,1)==obj.stateCue, 3 )-State40_Time(1);
                    if( ~isempty(temp) )
                        State_CueTime(ntrial)=temp(1); % time onset of cue signal
                    end
                    Licking_Index=find( (State_Matrix(:,2)==1 | State_Matrix(:,2)==3) & State_Matrix(:,3)> State40_Time(1) );    %index when animal licks either right or left lickport
                    if(  length(Licking_Index)>0 )
                        %Licking_Timing(ntrial,1)=State_Matrix(Licking_Index(1),3)- State40_Time(1);
                        Licking_Timing{ntrial,1}=State_Matrix(Licking_Index,3)- State40_Time(1);
                        if ( State_Matrix(Licking_Index(1), 2)==1 )
                            Licking_Side(ntrial)='r';
                        elseif( State_Matrix(Licking_Index(1), 2)==3 )
                            Licking_Side(ntrial)='l';
                        end
                        
                        i_answer_lick = find(Licking_Timing{ntrial,1} > State_CueTime(ntrial));
                        if ~isempty(i_answer_lick)
                            Response_Time(ntrial,1) = Licking_Timing{ntrial,1}(i_answer_lick(1));
                        end
                    end
                end
            end
            
            obj.licking.time=Licking_Timing;    obj.licking.side=Licking_Side;
            obj.licking.response_time = Response_Time;
        end
        
        function Unit( obj, single_unit_dir, depth)
          %% new 2016/12/4 by CH
            viTime_all =[]; viSite_all=[];obj.units={};
            if isstr(single_unit_dir)% only one directory
                for i_shank =[1 2 3 4]%1:4%yinxin 
                    % used for jrclust  versions which sepreate shanks __________________________________________________
                    disp(['--------------------------------------------']);
                    PossibleProbe={ '_N' '_NN' '' '_NNN' '_RN'};
                    FindFile=0;
                    for ProbeT=1:length(PossibleProbe)
                        Probe=PossibleProbe{ProbeT};
                        if strcmp(Probe,'_RN')
                            filename=[single_unit_dir,'\data_all_CNT_4x16probe_LeftRig_shank' num2str(i_shank) Probe,'_clu.mat'];
                        else
                            filename=[single_unit_dir,'\openephys_CNT_4x16probe_LeftRig_shank' num2str(i_shank) Probe,'_clu.mat'];
                        end
                        if exist(filename)==2
                            FindFile=1;
                            break;
                        end
                    end
                    
                    if FindFile==0
                        if strcmp(Probe,'_RN')
                            filename=[single_unit_dir,'\data_all_LeftRig_Lower_32Channels_A4x8_Shank'  num2str(i_shank) ,'_clu.mat'];
                        else
                            filename=[single_unit_dir,'\openephys_LeftRig_Lower_32Channels_A4x8_Shank'  num2str(i_shank) ,'_clu.mat'];
                        end
                        if (exist(filename)==2)
                            FindFile=1;
                        end
                    end
                    if FindFile==0
                        warning('Could not find clu file');
                    end

                    disp(['processing file ',filename]);
                    
                    % load cluster data, no waveform
                    if( single_unit_dir(end)~='\' )
                         if strcmp(Probe,'_RN')
                            filename=[single_unit_dir,'\data_all_CNT_4x16probe_LeftRig_shank' num2str(i_shank) Probe,'_clu.mat'];
                         else
                            filename=[single_unit_dir,'\openephys_CNT_4x16probe_LeftRig_shank' num2str(i_shank) Probe,'_clu.mat']                           
                         end
                    else
                        if strcmp(Probe,'_RN')
                            filename=[single_unit_dir,'data_all_CNT_4x16probe_LeftRig_shank' num2str(i_shank) Probe,'_clu.mat'];
                        else
                            filename=[single_unit_dir,'openephys_CNT_4x16probe_LeftRig_shank' num2str(i_shank) Probe,'_clu.mat'];
                        end
                    end
                    
                    if ~(exist(filename)==2)
                        filename=[single_unit_dir,'\openephys_LeftRig_Lower_32Channels_A4x8_Shank' num2str(i_shank),'_clu.mat'];
                    end
                    
                    
                    if exist(filename,'file') == 2
                        
                        load(filename);
                        
                        % load waveforms
                        if( single_unit_dir(end)~='\' )
                            if strcmp(Probe,'_RN')
                                filename=[single_unit_dir,'\data_all_CNT_4x16probe_LeftRig_shank' num2str(i_shank) Probe '_spkwav.mat'];
                            else
                                 filename=[single_unit_dir,'\openephys_CNT_4x16probe_LeftRig_shank' num2str(i_shank) Probe '_spkwav.mat'];
                            end
                        else
                            if strcmp(Probe,'_RN')
                                filename=[single_unit_dir,'data_all_CNT_4x16probe_LeftRig_shank' num2str(i_shank) Probe '_spkwav.mat'];
                            else
                                filename=[single_unit_dir,'openephys_CNT_4x16probe_LeftRig_shank' num2str(i_shank) Probe '_spkwav.mat'];
                            end
                        end
                        if ~(exist(filename)==2)
                            if strcmp(Probe,'_RN')
                                filename=[single_unit_dir,'\data_all_LeftRig_Lower_32Channels_A4x8_Shank' num2str(i_shank)  '_spkwav.mat'];
                            else
                                filename=[single_unit_dir,'\openephys_LeftRig_Lower_32Channels_A4x8_Shank' num2str(i_shank)  '_spkwav.mat'];
                            end
                        end
                        
                        if ~(exist(filename,'file') == 2)
                            dispaly('No WaveForm!')
                            continue;
                        end
                        load(filename);
                        
                        viTime_all = cat(1, viTime_all, viTime);
                        viSite_i = viSite+int32(repmat((i_shank-1)*16,size(viSite))); viSite_all = cat(1, viSite_all,viSite_i);
                        
                        for i_unit=1:Sclu.nClu
                            unit.manual_quality_score=[];
                            unit.miss_est=[];
%                             unit.false_alarm_est=[];
                            unit.cell_type=[];
                            unit.trials=[];
                            unit.channel=Sclu.viSite_clu(i_unit)+(i_shank-1)*16; % channel here means site NO. in jrc
                            
                            %                   unit.spike_times=Sclu.cviTime_clu{i_unit};
                            unit.spike_times= viTime(Sclu.cviSpk_clu{i_unit}); %2106/10/26 % 2017/1/16 spike time of this unit
                            
                            unit.waveforms=squeeze(trSpkWav(:,Sclu.viSite_clu(i_unit),Sclu.cviSpk_clu{i_unit}))';
                            unit.depth=[Sclu.vrPosX_clu(i_unit)+(i_shank-1)*250, Sclu.vrPosY_clu(i_unit), 0];
                            
                            % used for jrclust early versions which did not sepreate shanks ______________________________________________________________
                            %                 disp(['--------------------------------------------']);
                            %                 disp(['processing file ',[single_unit_dir,'data_all_clu.mat']]);
                            %
                            %                 % load cluster data, no waveform
                            %                 if( single_unit_dir(end)~='\' )
                            %                     filename=[single_unit_dir,'\data_all_clu.mat'];
                            %                 else
                            %                     filename=[single_unit_dir,'data_all_clu.mat'];
                            %                 end
                            %                 load(filename);
                            
                            %                 % load waveforms
                            %                 if( single_unit_dir(end)~='\' )
                            %                     filename=[single_unit_dir,'\data_all_spkwav.mat'];
                            %                 else
                            %                     filename=[single_unit_dir,'data_all_spkwav.mat'];
                            %                 end
                            %                 load(filename);
                            %
                            %                 obj.ephus.viTime=viTime;
                            %                 obj.ephus.viSite=viSite;
                            %
                            %                 for i_unit=1:Sclu.nClu
                            %                     unit.manual_quality_score=[];
                            %                     unit.miss_est=[];
                            %                     unit.false_alarm_est=[];
                            %                     unit.cell_type=[];
                            %                     unit.trials=[];
                            % %                   unit.channel=Sclu.viSite_clu(i_unit);
                            %
                            %                     Waveform_clu = squeeze(Sclu.tmrWav_clu(:,:,i_unit)); %2016/10/30 used for correcting max site of jrclust v20160817
                            %                     [sample_i viSite_cor_temp] = find(Waveform_clu == min(min(Waveform_clu)));
                            %                     viSite_clu_cor=viSite_cor_temp(1);
                            %                     unit.channel=viSite_clu_cor; % correct max site. 2016/10/30
                            %
                            % %                   unit.spike_times=Sclu.cviTime_clu{i_unit};
                            %                     unit.spike_times= viTime(Sclu.cviSpk_clu{i_unit}); %2106/10/26
                            %
                            %                     unit.waveforms=squeeze(trSpkWav(:,viSite_clu_cor,Sclu.cviSpk_clu{i_unit}))';
                            %                     unit.depth=[Sclu.vrPosX_clu(i_unit), Sclu.vrPosY_clu(i_unit) 0]; % Note: not be corrected using corrected viSite
                            % ----------------------------------------------------------------------------------------------------------------------------------------
                            %%%%%%%%%%%%%%%%%%%%%%%%%%% time, trial# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %figure; hold on
                            wave_amp_tmp = 10*double(range(unit.waveforms,2))/2^16*200; % ? YX 2017/1/16
                            if size(wave_amp_tmp,1)>100
                                %plot(wave_amp_tmp);
                                mean_wave_amp = conv(wave_amp_tmp,ones(1,100)/100,'same');
                                mean_wave_amp(1:50) = mean_wave_amp(51);
                                mean_wave_amp(end-49:end) = mean_wave_amp(end-50);
                                %plot(mean_wave_amp,'r');
                                wave_amp_tmp = wave_amp_tmp-mean_wave_amp;   % only look at the residues
                                %keyboard
                            end
                            
                            mu_est = mean(wave_amp_tmp);
                            sigma_est = std(wave_amp_tmp);
                            
                            X_min = (mu_est-sigma_est*5);
                            X_max = (mu_est+sigma_est*5);
                            X = X_min:(X_max-X_min)/100:X_max;
                            Y_fit = normpdf(X,mu_est,sigma_est);
                            Y = histc(wave_amp_tmp,X);
                            Y = Y/sum(Y)/((X_max-X_min)/100);
                            r = corr(Y,Y_fit');
                            
                            unit.miss_est = r^2;
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            obj.units=cat(2,obj.units,unit);
                        end
                    else
                        disp(['NOTE: ',filename,' does not exist, skip this shank']);
                    end
                end
                obj.ephus.viTime=viTime_all'; % new,2016/12/4
                obj.ephus.viSite=viSite_all; % new,2016/14/4
            end
        end
    end
    methods( Hidden = true )
        function newSaved=Change_Saved_Field_Names(obj, saved)
            
            fieldNames = fieldnames(saved);
            protocolName=[];
            for i=1:size(fieldNames, 1)
                if( strfind(fieldNames{i}, '_hit_history') )
                    index=strfind(fieldNames{i}, '_hit_history');
                    protocolName=fieldNames{i}(1:index-1);
                end
            end
            
            if( isempty(protocolName) )
                error('didn\''t find protocol name')
            else
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   add new fields
                newSaved=saved;
                for i=1:size(fieldNames, 1)
                    if( strfind(fieldNames{i}, protocolName) )
                        index=strfind(fieldNames{i}, protocolName);
                        eval(['newSaved.' fieldNames{i}(1:index-1) 'stim_timing2AFCobj' fieldNames{i}(index+length(protocolName):end) '= saved.' fieldNames{i},';']);
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  remove old fields
                fieldNames = fieldnames(newSaved);
                index_to_remove=[];
                for i=1:size(fieldNames, 1)
                    
                    if( strfind(fieldNames{i}, protocolName) )
                        index_to_remove=[index_to_remove i];
                    end
                    
                end
                newSaved=rmfield(newSaved, {fieldNames{index_to_remove}});
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  remove old fields
            end
        end
        
        function Trim_Trials(obj, trimTrials)
            % tris function trim unnecessary trials
            if length(trimTrials)==0
                return;
            end

            %%%%%% history: hit, miss, no response for total trials, right trials, left trials, right stim trials, left stim trials
            obj.types=obj.types(1:length(obj.trialsR.hitHistory)); %% yinxin
            obj.trialsRNoStim.hitHistory=obj.trialsR.hitHistory & obj.types==0;         %%%% types == 0; no stim
            obj.trialsRNoStim.missHistory=obj.trialsR.missHistory & obj.types==0;
            obj.trialsRNoStim.noResponseHistory=obj.trialsR.noResponseHistory &  obj.types==0;
            
            obj.trialsRStim.hitHistory=obj.trialsR.hitHistory & obj.types==1;         %%%% types == 1; stim
            obj.trialsRStim.missHistory=obj.trialsR.missHistory & obj.types==1;
            obj.trialsRStim.noResponseHistory=obj.trialsR.noResponseHistory & obj.types==1;
            
            obj.trialsLNoStim.hitHistory=obj.trialsL.hitHistory & obj.types==0;         %%%% types == 0; no stim
            obj.trialsLNoStim.missHistory=obj.trialsL.missHistory & obj.types==0;
            obj.trialsLNoStim.noResponseHistory=obj.trialsL.noResponseHistory &  obj.types==0;
            
            obj.trialsLStim.hitHistory=obj.trialsL.hitHistory & obj.types==1;         %%%% types == 1; stim
            obj.trialsLStim.missHistory=obj.trialsL.missHistory & obj.types==1;
            obj.trialsLStim.noResponseHistory=obj.trialsL.noResponseHistory & obj.types==1;
               
            % 20170806 add sample and delay period stim effects
            Samples=strcmp(obj.stimTypes,'sample_period');
            Delays=strcmp(obj.stimTypes,'delay_period');
            Responses=strcmp(obj.stimTypes,'response_period');
            Samples=Samples(1:length(obj.trialsR.hitHistory));
            Delays=Delays(1:length(obj.trialsR.hitHistory));
            Responses=Responses(1:length(obj.trialsR.hitHistory));
            
            obj.trialsRStim.hitHistorySample=obj.trialsR.hitHistory & obj.types==1 & Samples;         %%%% types == 1; stim
            obj.trialsRStim.missHistorySample=obj.trialsR.missHistory & obj.types==1 & Samples;
            obj.trialsRStim.noResponseHistorySample=obj.trialsR.noResponseHistory & obj.types==1 & Samples;
            
            obj.trialsRStim.hitHistoryDelay=obj.trialsR.hitHistory & obj.types==1 & Delays;         %%%% types == 1; stim
            obj.trialsRStim.missHistoryDelay=obj.trialsR.missHistory & obj.types==1 & Delays;
            obj.trialsRStim.noResponseHistoryDelay=obj.trialsR.noResponseHistory & obj.types==1 & Delays;
            
            obj.trialsRStim.hitHistoryResponse=obj.trialsR.hitHistory & obj.types==1 & Responses;         %%%% types == 1; stim
            obj.trialsRStim.missHistoryResponse=obj.trialsR.missHistory & obj.types==1 & Responses;
            obj.trialsRStim.noResponseHistoryResponse=obj.trialsR.noResponseHistory & obj.types==1 & Responses;
    
            
            obj.trialsLStim.hitHistorySample=obj.trialsL.hitHistory & obj.types==1 & Samples;         %%%% types == 1; stim
            obj.trialsLStim.missHistorySample=obj.trialsL.missHistory & obj.types==1 & Samples;
            obj.trialsLStim.noResponseHistorySample=obj.trialsL.noResponseHistory & obj.types==1 & Samples;
            
            obj.trialsLStim.hitHistoryDelay=obj.trialsL.hitHistory & obj.types==1 & Delays;         %%%% types == 1; stim
            obj.trialsLStim.missHistoryDelay=obj.trialsL.missHistory & obj.types==1 & Delays;
            obj.trialsLStim.noResponseHistoryDelay=obj.trialsL.noResponseHistory & obj.types==1 & Delays;
           
            obj.trialsLStim.hitHistoryResponse=obj.trialsL.hitHistory & obj.types==1 & Responses;         %%%% types == 1; stim
            obj.trialsLStim.missHistoryResponse=obj.trialsL.missHistory & obj.types==1 & Responses;
            obj.trialsLStim.noResponseHistoryResponse=obj.trialsL.noResponseHistory & obj.types==1 & Responses;

            % trim trials
            obj.trials.hitHistory(trimTrials)=0;
            obj.trials.missHistory(trimTrials)=0;
            obj.trials.noResponseHistory(trimTrials)=0;
            
            obj.trialsL.hitHistory(trimTrials)=0;
            obj.trialsL.missHistory(trimTrials)=0;
            obj.trialsL.noResponseHistory(trimTrials)=0;

            obj.trialsR.hitHistory(trimTrials)=0;
            obj.trialsR.missHistory(trimTrials)=0;
            obj.trialsR.noResponseHistory(trimTrials)=0;
            
            obj.trialsRNoStim.hitHistory(trimTrials)=0;
            obj.trialsRNoStim.missHistory(trimTrials)=0;
            obj.trialsRNoStim.noResponseHistory(trimTrials)=0;
            
            obj.trialsLNoStim.hitHistory(trimTrials)=0;
            obj.trialsLNoStim.missHistory(trimTrials)=0;
            obj.trialsLNoStim.noResponseHistory(trimTrials)=0;
            
            obj.trialsRStim.hitHistory(trimTrials)=0;
            obj.trialsRStim.missHistory(trimTrials)=0;
            obj.trialsRStim.noResponseHistory(trimTrials)=0;
            
            obj.trialsLStim.hitHistory(trimTrials)=0;
            obj.trialsLStim.missHistory(trimTrials)=0;
            obj.trialsLStim.noResponseHistory(trimTrials)=0;
            
            obj.aomPowerHistory(trimTrials)=0;
            obj.xGalvoHistory(trimTrials)=0;
            obj.yGalvoHistory(trimTrials)=0;
            
            obj.user_var.DiscrimDelay.rewardOmission(trimTrials)=0;
            obj.user_var.DiscrimDelay.unexpectedReward(trimTrials)=0;
            obj.user_var.DiscrimDelay.normalTrials(trimTrials)=0;

       
            % compute hit rate again
            which_trials='';         exp=obj.Trial_Nums(which_trials);   eval( exp);
            which_trials='RNoStim';        exp=obj.Trial_Nums(which_trials);   eval( exp);
            which_trials='LNoStim';        exp=obj.Trial_Nums(which_trials);   eval( exp);
            which_trials='RStim';    exp=obj.Trial_Nums(which_trials);   eval( exp);
            which_trials='LStim';    exp=obj.Trial_Nums(which_trials);   eval( exp);
                      
            for i=trimTrials
                obj.stimTypes{i}=0;
            end
        end
        
        function Eval_Expression=Trial_Nums(obj, which_trials)
            
            %%%%%%%%%%% NL change (v120912) %%%%%%%%%%%%%%%
            %Eval_Expression=['obj.trials' which_trials '.hitHistory(trimTrials)=0;'];
            %Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.missHistory(trimTrials)=0;'];
            %Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.noResponseHistory(trimTrials)=0;'];
            %%%%%%%%%%% NL change (v120912) %%%%%%%%%%%%%%%
            
            Eval_Expression=['obj.trials' which_trials '.hitTrialNums = find(obj.trials' which_trials '.hitHistory==1);'];
            Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.missTrialNums = find(obj.trials' which_trials '.missHistory==1);'];
            Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.noResponseTrialNums = find(obj.trials' which_trials '.noResponseHistory==1);'];
            Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.trialNums =union( union(obj.trials' which_trials '.hitTrialNums, obj.trials' which_trials '.missTrialNums),'...
                'obj.trials' which_trials '.noResponseTrialNums);'];
            % length
            Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.length =length(obj.trials' which_trials '.trialNums);'];
            % calculate rate within each category
            Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.hitRate =length(obj.trials' which_trials '.hitTrialNums)/obj.trials' which_trials '.length;'];
            Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.missRate =length(obj.trials' which_trials '.missTrialNums)/obj.trials' which_trials '.length;'];
            Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.noResponseRate =length(obj.trials' which_trials '.noResponseTrialNums)/obj.trials' which_trials '.length;'];
            
            Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.hitRate2 =length(obj.trials' which_trials '.hitTrialNums)/(obj.trials' which_trials '.length' '-length(obj.trials' which_trials '.noResponseTrialNums));'];
            Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.missRate2 =length(obj.trials' which_trials '.missTrialNums)/(obj.trials' which_trials '.length' '-length(obj.trials' which_trials '.noResponseTrialNums));'];
       
            % add sample and delay period stim effects
            
            if strcmp(which_trials,'RStim') | strcmp(which_trials,'LStim')
                %%sample
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.hitTrialNumsSample = find(obj.trials' which_trials '.hitHistorySample==1);'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.missTrialNumsSample = find(obj.trials' which_trials '.missHistorySample==1);'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.noResponseTrialNumsSample = find(obj.trials' which_trials '.noResponseHistorySample==1);'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.trialNumsSample =union( union(obj.trials' which_trials '.hitTrialNumsSample, obj.trials' which_trials '.missTrialNumsSample),'...
                    'obj.trials' which_trials '.noResponseTrialNumsSample);'];
                % length
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.Samplelength =length(obj.trials' which_trials '.trialNumsSample);'];
                % calculate rate within each category
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.hitRateSample =length(obj.trials' which_trials '.hitTrialNumsSample)/obj.trials' which_trials '.Samplelength;'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.missRateSample =length(obj.trials' which_trials '.missTrialNumsSample)/obj.trials' which_trials '.Samplelength;'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.noResponseRateSample =length(obj.trials' which_trials '.noResponseTrialNumsSample)/obj.trials' which_trials '.Samplelength;'];

                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.hitRate2Sample =length(obj.trials' which_trials '.hitTrialNumsSample)/(obj.trials' which_trials '.Samplelength' '-length(obj.trials' which_trials '.noResponseTrialNumsSample));'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.missRate2Sample =length(obj.trials' which_trials '.missTrialNumsSample)/(obj.trials' which_trials '.Samplelength' '-length(obj.trials' which_trials '.noResponseTrialNumsSample));'];
                
                %%Delay
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.hitTrialNumsDelay = find(obj.trials' which_trials '.hitHistoryDelay==1);'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.missTrialNumsDelay = find(obj.trials' which_trials '.missHistoryDelay==1);'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.noResponseTrialNumsDelay = find(obj.trials' which_trials '.noResponseHistoryDelay==1);'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.trialNumsDelay =union( union(obj.trials' which_trials '.hitTrialNumsDelay, obj.trials' which_trials '.missTrialNumsDelay),'...
                    'obj.trials' which_trials '.noResponseTrialNumsDelay);'];
                % length
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.Delaylength =length(obj.trials' which_trials '.trialNumsDelay);'];
                % calculate rate within each category
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.hitRateDelay =length(obj.trials' which_trials '.hitTrialNumsDelay)/obj.trials' which_trials '.Delaylength;'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.missRateDelay =length(obj.trials' which_trials '.missTrialNumsDelay)/obj.trials' which_trials '.Delaylength;'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.noResponseRateDelay =length(obj.trials' which_trials '.noResponseTrialNumsDelay)/obj.trials' which_trials '.Delaylength;'];

                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.hitRate2Delay =length(obj.trials' which_trials '.hitTrialNumsDelay)/(obj.trials' which_trials '.Delaylength' '-length(obj.trials' which_trials '.noResponseTrialNumsDelay));'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.missRate2Delay =length(obj.trials' which_trials '.missTrialNumsDelay)/(obj.trials' which_trials '.Delaylength' '-length(obj.trials' which_trials '.noResponseTrialNumsDelay));'];
            
                %%Response   
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.hitTrialNumsResponse = find(obj.trials' which_trials '.hitHistoryResponse==1);'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.missTrialNumsResponse = find(obj.trials' which_trials '.missHistoryResponse==1);'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.noResponseTrialNumsResponse = find(obj.trials' which_trials '.noResponseHistoryResponse==1);'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.trialNumsResponse =union( union(obj.trials' which_trials '.hitTrialNumsResponse, obj.trials' which_trials '.missTrialNumsResponse),'...
                    'obj.trials' which_trials '.noResponseTrialNumsResponse);'];
                % length
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.Responselength =length(obj.trials' which_trials '.trialNumsResponse);'];
                % calculate rate within each category
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.hitRateResponse =length(obj.trials' which_trials '.hitTrialNumsResponse)/obj.trials' which_trials '.Responselength;'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.missRateResponse =length(obj.trials' which_trials '.missTrialNumsResponse)/obj.trials' which_trials '.Responselength;'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.noResponseRateResponse =length(obj.trials' which_trials '.noResponseTrialNumsResponse)/obj.trials' which_trials '.Responselength;'];

                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.hitRate2Response =length(obj.trials' which_trials '.hitTrialNumsResponse)/(obj.trials' which_trials '.Responselength' '-length(obj.trials' which_trials '.noResponseTrialNumsResponse));'];
                Eval_Expression=[Eval_Expression 'obj.trials' which_trials '.missRate2Response =length(obj.trials' which_trials '.missTrialNumsResponse)/(obj.trials' which_trials '.Responselength' '-length(obj.trials' which_trials '.noResponseTrialNumsResponse));'];

            end
            
            
            
            
            %             obj.trialsL.hitHistory(trimTrials)=0;
            %             obj.trialsL.missHistory(trimTrials)=0;
            %             obj.trialsL.noResponseHistory(trimTrials)=0;
            %             obj.trialsL.hitTrialNums = find(obj.trialsL.hitHistory==1);
            %             obj.trialsL.missTrialNums = find(obj.trialsL.missHistory==1);
            %             obj.trialsL.noResponseTrialNums=find(obj.trialsL.noResponseHistory==1);
            %             obj.trialsL.trialNums=union( union(obj.trialsL.hitTrialNums, obj.trialsL.missTrialNums), obj.trialsL.noResponseTrialNums);
        end
        
        function Alarm_Which_Trials(obj, which_trials)
            
            eval( ['hitTrialNums=obj.trials' which_trials '.hitTrialNums;'] );
            eval( ['missTrialNums=obj.trials' which_trials '.missTrialNums;'] );
            eval( ['noResponseTrialNums=obj.trials' which_trials '.noResponseTrialNums;'] );
            eval( ['len=obj.trials' which_trials '.length;'] );     %the length of total trial nums with each category, including hit,miss, no response
            
            %%% calculate alarm nums in hit, miss or no response trials
            [hitAlarmNums ~]=obj.Alarm_Analysis(hitTrialNums);
            [missAlarmNums ~]=obj.Alarm_Analysis( missTrialNums );
            [noResponseAlarmNums ~]=obj.Alarm_Analysis( noResponseTrialNums );
            
            hitAlarmRate=length(hitAlarmNums)/length(hitTrialNums);
            missAlarmRate=length(missAlarmNums)/length(missTrialNums);
            noResponseAlarmRate=length(noResponseAlarmNums)/length(noResponseTrialNums);
            alarmNums=union( union(hitAlarmNums, missAlarmNums), noResponseAlarmNums);
            alarmLen=length(alarmNums);
            alarmRate=alarmLen/len;
            
            %%% calculate in which state the alarm was triggered
            [~, alarmState]=obj.Alarm_Analysis( alarmNums );
            alarmNumsSample=alarmState.state53;
            alarmNumsDelay=setdiff(alarmState.state55, union(union(alarmState.state53,alarmState.state59), alarmState.state61) );
            alarmNumsPoleUp=setdiff(union(alarmState.state59, alarmState.state61), alarmState.state53 );
            
            eval( ['obj.trials' which_trials '.hitAlarmNums=hitAlarmNums;' ] );
            eval( ['obj.trials' which_trials '.missAlarmNums=missAlarmNums;' ] );
            eval( ['obj.trials' which_trials '.noResponseAlarmNums=noResponseAlarmNums;' ] );
            eval( ['obj.trials' which_trials '.alarmNums=alarmNums;' ] );
            eval( ['obj.trials' which_trials '.hitAlarmRate=hitAlarmRate;' ] );
            eval( ['obj.trials' which_trials '.missAlarmRate=missAlarmRate;' ] );
            eval( ['obj.trials' which_trials '.noResponseAlarmRate=noResponseAlarmRate;' ] );
            eval( ['obj.trials' which_trials '.alarmLen=alarmLen;' ] );
            eval( ['obj.trials' which_trials '.alarmRate=alarmRate;' ] );
            eval( ['obj.trials' which_trials '.alarmNumsSample=alarmNumsSample;' ] );
            eval( ['obj.trials' which_trials '.alarmNumsDelay=alarmNumsDelay;' ] );
            eval( ['obj.trials' which_trials '.alarmNumsPoleUp=alarmNumsPoleUp;' ] );
            
        end
        
        function [AlarmTrials, AlarmStateTrials]=Alarm_Analysis(obj, trialNums )
            
            % the function identifies in which trials alarm was triggered by animal's licking during either sample, delay period or pole up period
            % AlarmTrials: all the alarm trials within TrialNums
            % AlarmStateTrials: alarm trials within which a specific state is visited
            % TrialNums: a vector contains trial numbers, i.e. trialsRNoStim.HitTrialNums, LHitTrialNums
            % StateMatrixTrialEvents: record of state visited
            % StateAlarm: vector contains states within which alarm is triggered.
            % 9/23/2011 by Zengcai Guo
            
            if( length(obj.stateAlarm) ==0)
                disp( 'must present an alarm state' )
                return;
            end
            
            if ( length(trialNums) ==0 )
                AlarmTrials=[];
                for nstate=1:length(obj.stateAlarm)
                    eval(['AlarmStateTrials.state' num2str(obj.stateAlarm(nstate)) ' = [];']);
                end
                return;
            end
            
            
            AlarmTrials=[];     AlarmStateTrials=[];
            SM_States=obj.eventsHistory;
            for nstate=1:length(obj.stateAlarm)
                nhit=0;
                eval( ['AlarmStateTrials.state' num2str(obj.stateAlarm(nstate)) '=[];'] );
                for j=1:length(trialNums)
                    if( length( find( SM_States{ trialNums(j) } (:,1)==obj.stateAlarm(nstate ) )) )
                        nhit=nhit+1;
                        eval(['AlarmStateTrials.state' num2str(obj.stateAlarm(nstate)) '(nhit) = trialNums(j);']);
                    end
                end
                eval(['AlarmTrials=union(AlarmTrials, AlarmStateTrials.state' num2str(obj.stateAlarm(nstate)) ');'] );
            end
        end
        
        
        %%%%%%%%%%% NL change (v120912) %%%%%%%%%%%%%%%
        function addYesNoDiscriminationObject(obj, obj_tmp)
            
            obj.mouseName        = cat(1, obj.mouseName, obj_tmp.mouseName);
            obj.sessionName      = cat(1, obj.sessionName, obj_tmp.sessionName);
            obj.sessionType      = cat(1, obj.sessionType, obj_tmp.sessionType);
            obj.sessionNameTag   = cat(1, obj.sessionNameTag, obj_tmp.sessionNameTag);
            obj.weight           = cat(1, obj.weight, obj_tmp.weight);
            obj.weightAfterExp   = cat(1, obj.weightAfterExp, obj_tmp.weightAfterExp);
            obj.eventsHistory    = cat(1, obj.eventsHistory, obj_tmp.eventsHistory);
            obj.stimType         = cat(1, obj.stimType, obj_tmp.stimType);
            obj.stimProb         = cat(1, obj.stimProb, obj_tmp.stimProb);
            obj.sides            = cat(1, obj.sides, obj_tmp.sides);
            obj.types            = cat(1, obj.types, obj_tmp.types);
            obj.sidesTypes       = cat(2, obj.sidesTypes, obj_tmp.sidesTypes);
            obj.aomPowerHistory  = cat(1, obj.aomPowerHistory, obj_tmp.aomPowerHistory);
            obj.xGalvoHistory    = cat(1, obj.xGalvoHistory, obj_tmp.xGalvoHistory);
            obj.yGalvoHistory    = cat(1, obj.yGalvoHistory, obj_tmp.yGalvoHistory);
            obj.stimStateHistory = cat(1, obj.stimStateHistory, obj_tmp.stimStateHistory);
            
            
            obj.trials.hitHistory = cat(1, obj.trials.hitHistory, obj_tmp.trials.hitHistory);
            obj.trials.missHistory = cat(1, obj.trials.missHistory, obj_tmp.trials.missHistory);
            obj.trials.noResponseHistory = cat(1, obj.trials.noResponseHistory, obj_tmp.trials.noResponseHistory);
            
            obj.trialsRNoStim.hitHistory = cat(1, obj.trialsRNoStim.hitHistory, obj_tmp.trialsRNoStim.hitHistory);
            obj.trialsRNoStim.missHistory = cat(1, obj.trialsRNoStim.missHistory, obj_tmp.trialsRNoStim.missHistory);
            obj.trialsRNoStim.noResponseHistory = cat(1, obj.trialsRNoStim.noResponseHistory, obj_tmp.trialsRNoStim.noResponseHistory);
            
            obj.trialsRStim.hitHistory = cat(1, obj.trialsRStim.hitHistory, obj_tmp.trialsRStim.hitHistory);
            obj.trialsRStim.missHistory = cat(1, obj.trialsRStim.missHistory, obj_tmp.trialsRStim.missHistory);
            obj.trialsRStim.noResponseHistory = cat(1, obj.trialsRStim.noResponseHistory, obj_tmp.trialsRStim.noResponseHistory);
            
            obj.trialsLNoStim.hitHistory = cat(1, obj.trialsLNoStim.hitHistory, obj_tmp.trialsLNoStim.hitHistory);
            obj.trialsLNoStim.missHistory = cat(1, obj.trialsLNoStim.missHistory, obj_tmp.trialsLNoStim.missHistory);
            obj.trialsLNoStim.noResponseHistory = cat(1, obj.trialsLNoStim.noResponseHistory, obj_tmp.trialsLNoStim.noResponseHistory);
            
            obj.trialsLStim.hitHistory = cat(1, obj.trialsLStim.hitHistory, obj_tmp.trialsLStim.hitHistory);
            obj.trialsLStim.missHistory = cat(1, obj.trialsLStim.missHistory, obj_tmp.trialsLStim.missHistory);
            obj.trialsLStim.noResponseHistory = cat(1, obj.trialsLStim.noResponseHistory, obj_tmp.trialsLStim.noResponseHistory);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%% handle trim numbers
            obj.trim=[obj.trim obj_tmp.trim+length(obj.soloTrialIndex)];
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%  calculate hit, miss, no response numbers
            which_trials='';         exp=obj.Trial_Nums(which_trials);   eval( exp);
            which_trials='RNoStim';        exp=obj.Trial_Nums(which_trials);   eval( exp);
            which_trials='LNoStim';        exp=obj.Trial_Nums(which_trials);   eval( exp);
            which_trials='RStim';    exp=obj.Trial_Nums(which_trials);   eval( exp);
            which_trials='LStim';    exp=obj.Trial_Nums(which_trials);   eval( exp);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%% process trial statistics: hit, miss, no response trial nums, rate, length
            
            
            obj_tmp.soloTrialIndex(:,1) = obj.soloTrialIndex(end,1)+1;
            obj.soloTrialIndex = cat(1, obj.soloTrialIndex, obj_tmp.soloTrialIndex);
            
            
        end
        
        
        
        %%%%%%%%%%%%%% 2017/6/15 licking analysis  YX %%%%%%%%%%%%%%%
        function LickingAnalysis(obj)
               % The function was used to compute licks per trial and
               % licking initiation time. 
               for i=1:length(obj.eventsHistory)
                    EventHistory=obj.eventsHistory{i};
                    LicksLIndex=(EventHistory(:,2)==0);
                    LicksRIndex=(EventHistory(:,2)==2);
                    LicksIndex=(EventHistory(:,2)==0 | EventHistory(:,2)==2);
                    
                    LicksL(i)=sum(LicksLIndex);
                    LicksR(i)=sum(LicksRIndex);
                    Licks(i)=sum(LicksIndex);
                    
                    LicksLTime{i}=EventHistory(LicksLIndex,3);
                    LicksRTime{i}=EventHistory(LicksRIndex,3);
                    LicksTime{i}=EventHistory(LicksIndex,3);
                    
                    if strcmp(obj.sessionType, 'Discrim_Delay') | strcmp(obj.sessionType, 'Discrim') | strcmp(obj.sessionType, 'DiscrimDelayFrequency') | strcmp(obj.sessionType, 'DiscrimFrequency') | strcmp(obj.sessionType, 'Discrim_Delay_multiSensory') | strcmp(obj.sessionType, 'DiscrimDelaySpatial')   | strcmp(obj.sessionType, 'Discrim_Delay_Auo')   | strcmp(obj.sessionType, 'LeftAndRightWhisker_Delay')  | strcmp(obj.sessionType, 'LeftOrRightWhisker_Delay')   
                         IndexLicking=find(LicksIndex==1);
                         IndexLickingL=find(LicksLIndex==1);
                         IndexLickingR=find(LicksRIndex==1);
                         if strcmp(obj.sessionType, 'Discrim')
                              GoCueStartIndex=find(EventHistory(:,1)==53);
                         else
                              GoCueStartIndex=find(EventHistory(:,1)==56);
                         end
                         TrialCueStartIndex=find(EventHistory(:,1)==41);
                         try 
                             TrialCueStartIndex=TrialCueStartIndex(1);
                             GoCueStartIndex=GoCueStartIndex(1);
                             LicksIndexAfterGoCue=IndexLicking(IndexLicking>GoCueStartIndex);
                             TrialCueStartTime(i)=EventHistory(TrialCueStartIndex,3);
                             GoCueStartTime(i)=EventHistory(GoCueStartIndex,3);
                         catch
                             warning('Unrecognize error!')
                             continue;
                         end
                             
                         %prelicks
                         PreLicks(i)=sum(IndexLicking>TrialCueStartIndex & IndexLicking<GoCueStartIndex);
                         PreLicksL(i)=sum(IndexLickingL>TrialCueStartIndex & IndexLickingL<GoCueStartIndex);
                         PreLicksR(i)=sum(IndexLickingR>TrialCueStartIndex & IndexLickingR<GoCueStartIndex);
                         
                         if length(LicksIndexAfterGoCue)>0
                               LickingInitiationIndex=LicksIndexAfterGoCue(1);
                               LickingInitiationTime(i)=EventHistory(LickingInitiationIndex,3)-EventHistory(GoCueStartIndex,3);
                         else
                               LickingInitiationTime(i)=0; % 0 means no licking
                         end
                          
                         if sum(IndexLicking>TrialCueStartIndex & IndexLicking<GoCueStartIndex)
                               PreLicking(i)=1;
                         else
                               PreLicking(i)=0;
                         end
                    elseif strcmp(obj.sessionType, 'Classical_Conditioning')
                         
                         ResponseStartIndex=find(EventHistory(:,1)==50);
                         ResponseStartIndex=ResponseStartIndex(1);
                         ResponseStartTime(i)=EventHistory(ResponseStartIndex,3);
                         if obj.user_var.classical_conditioning.UnexpectedReward(i)==0
                             SampleStartIndex=find(EventHistory(:,1)==41);
                             SampleStartIndex=SampleStartIndex(1);
                             SampleStartTime(i)=EventHistory(SampleStartIndex,3);
                             LicksLTimeAlignToSample{i}=LicksLTime{i}-SampleStartTime(i);
                             LicksRTimeAlignToSample{i}=LicksRTime{i}-SampleStartTime(i);
                             LicksTimeAlignToSample{i}=LicksTime{i}-SampleStartTime(i);
                         else
                             SampleStartIndex=[];
                             SampleStartTime(i)=-1;
                             LicksLTimeAlignToSample{i}=[];
                             LicksRTimeAlignToSample{i}=[];
                             LicksTimeAlignToSample{i}=[];
                         end
                         LicksLTimeAlignToResponse{i}=LicksLTime{i}-ResponseStartTime(i);
                         LicksRTimeAlignToResponse{i}=LicksLTime{i}-ResponseStartTime(i);
                         LicksTimeAlignToResponse{i}=LicksLTime{i}-ResponseStartTime(i);
                         
                    end
                    
               end
               
               % save data
               obj.licking.LicksL=LicksL;
               obj.licking.LicksR=LicksR;
               obj.licking.Licks=Licks;
               obj.licking.LicksLTime=LicksLTime;
               obj.licking.LicksRTime=LicksRTime;
               obj.licking.LicksTime=LicksTime;
               if strcmp(obj.sessionType, 'Discrim_Delay') | strcmp(obj.sessionType, 'Discrim') | strcmp(obj.sessionType, 'DiscrimDelayFrequency') | strcmp(obj.sessionType, 'DiscrimFrequency') | strcmp(obj.sessionType, 'Discrim_Delay_multiSensory')   | strcmp(obj.sessionType, 'DiscrimDelaySpatial') | strcmp(obj.sessionType, 'Discrim_Delay_Auo')   | strcmp(obj.sessionType, 'LeftAndRightWhisker_Delay')  | strcmp(obj.sessionType, 'LeftOrRightWhisker_Delay')   
                   LickingInitiationTime(obj.trials.noResponseHistory)=0; % in case initiation time >1.1
                   obj.licking.TrialCueStartTime=TrialCueStartTime;
                   obj.licking.GoCueStartTime=GoCueStartTime;
                   obj.licking.LickingInitiationTime=LickingInitiationTime;
                   obj.licking.PreLicking=PreLicking;
                   obj.licking.PreLickingTrials=find(PreLicking==1);
                   obj.licking.PreLickingRate=sum(PreLicking)/length(PreLicking);
                   obj.licking.LickingInitiationTimeMean=mean(LickingInitiationTime(LickingInitiationTime>0));
                   obj.licking.LickingInitiationTimeCorrectMean=mean(LickingInitiationTime(obj.trials.hitHistory));
                   obj.licking.LickingInitiationTimeErrorMean=mean(LickingInitiationTime(obj.trials.missHistory));
                   obj.licking.PreLicks=PreLicks;
                   obj.licking.PreLicksL=PreLicksL;
                   obj.licking.PreLicksR=PreLicksR;
               elseif strcmp(obj.sessionType, 'Classical_Conditioning')
                   obj.licking.LicksLTimeAlignToSample=LicksLTimeAlignToSample;
                   obj.licking.LicksRTimeAlignToSample=LicksRTimeAlignToSample;
                   obj.licking.LicksTimeAlignToSample=LicksTimeAlignToSample;
                   obj.licking.LicksLTimeAlignToResponse=LicksLTimeAlignToResponse;
                   obj.licking.LicksRTimeAlignToResponse=LicksRTimeAlignToResponse;
                   obj.licking.LicksTimeAlignToResponse=LicksTimeAlignToResponse;
                   
                   obj.licking.SampleStartTime=SampleStartTime;
                   obj.licking.ResponseStartTime=ResponseStartTime;
               end
        end
        
        
    end
    
end
