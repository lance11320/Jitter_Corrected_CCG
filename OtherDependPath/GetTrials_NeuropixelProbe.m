
if DeletePrelicking==1
    trimTrials=[trimTrials obj.licking.PreLickingTrials];
    trimTrials=unique(trimTrials);

end
%BadTrials=BadTrialsA{Ani}{Sess};
BadTrials=[];
if length(BadTrials>1)
    obj.trim=unique([trimTrials BadTrialsA{Ani}{Sess}]);
end
% obj.trim=unique([trimTrials BadTrialsA{Ani}{Sess}  find(obj.aomPowerHistory ~=3 & obj.types==1)]); % only contain stim trials with specific laser power
% obj.Trim_Trials(obj.trim);
obj.Trim_Trials(obj.trim);




Len=length(obj.trials.hitHistory);
obj.sides=obj.sides(1:Len);
obj.aomPowerHistory=obj.aomPowerHistory(1:Len);


if strcmp(obj.sessionType,'DiscrimDelayFrequency')
    obj.user_var.DiscrimDelay.normalTrials(1:Len)=1;
    obj.user_var.DiscrimDelay.unexpectedReward(1:Len)=0;
    obj.user_var.DiscrimDelay.rewardOmission(1:Len)=0;
end
%     STrials.CorretAllNum=find(obj.trials.hitHistory & obj.user_var.DiscrimDelay.normalTrials(1:Len)==1 & ~obj.types) ;
%     STrials.ErrorAllNum=find(obj.trials.missHistory & obj.user_var.DiscrimDelay.normalTrials(1:Len)==1 & ~obj.types) ;
%     STrials.NoResponseAllNum=find(obj.trials.noResponseHistory & obj.user_var.DiscrimDelay.normalTrials(1:Len)==1 & ~obj.types) ;
%     STrials.CorrectLeftNum=find(obj.trialsL.hitHistory==1 & obj.user_var.DiscrimDelay.normalTrials(1:Len)==1 & ~obj.types) ;
%     STrials.ErrorLeftNum=find(obj.trialsL.missHistory==1 & obj.user_var.DiscrimDelay.normalTrials(1:Len)==1 & ~obj.types) ;
%     STrials.NoResponseLeftNum=find(obj.trialsL.noResponseHistory==1 & obj.user_var.DiscrimDelay.normalTrials(1:Len)==1 & ~obj.types) ;
%     STrials.CorrectRightNum=find(obj.trialsR.hitHistory==1 & obj.user_var.DiscrimDelay.normalTrials(1:Len)==1 & ~obj.types) ;
%     STrials.ErrorRightNum=find(obj.trialsR.missHistory==1 & obj.user_var.DiscrimDelay.normalTrials(1:Len)==1 & ~obj.types) ;
%     STrials.NoResponseRightNum=find(obj.trialsR.noResponseHistory==1 & obj.user_var.DiscrimDelay.normalTrials(1:Len)==1 &~obj.types) ;
%
%     %unexpected reward and reward omission trials
%     STrials.UnexpectedRewardAllNum=find(obj.user_var.DiscrimDelay.unexpectedReward(1:Len));
%     STrials.RewardOmissionAllNum=find(obj.user_var.DiscrimDelay.rewardOmission(1:Len));
%     STrials.UnexpectedRewardLeftNum=find(obj.user_var.DiscrimDelay.unexpectedReward(1:Len)& obj.sides==0);
%     STrials.RewardOmissionLeftNum=find(obj.user_var.DiscrimDelay.rewardOmission(1:Len) & obj.sides==0);
%     STrials.UnexpectedRewardRightNum=find(obj.user_var.DiscrimDelay.unexpectedReward(1:Len) & obj.sides==1);
%     STrials.RewardOmissionRightNum=find(obj.user_var.DiscrimDelay.rewardOmission(1:Len) & obj.sides==1);
%     STrials.RewardOmissionRightErrorNum=find(obj.user_var.DiscrimDelay.rewardOmission(1:Len) & obj.sides==1 & obj.trials.missHistory==1);
%     STrials.RewardOmissionRightCorrectNum=find(obj.user_var.DiscrimDelay.rewardOmission(1:Len) & obj.sides==1 & obj.trials.hitHistory==1);
%     STrials.RewardOmissionLeftErrorNum=find(obj.user_var.DiscrimDelay.rewardOmission(1:Len) & obj.sides==0 & obj.trials.missHistory==1);
%     STrials.RewardOmissionLeftCorrectNum=find(obj.user_var.DiscrimDelay.rewardOmission(1:Len) & obj.sides==0 & obj.trials.hitHistory==1);
%
STrials.CorretAllNum=find(obj.trials.hitHistory  & ~obj.types) ;
STrials.ErrorAllNum=find(obj.trials.missHistory  & ~obj.types) ;
STrials.NoResponseAllNum=find(obj.trials.noResponseHistory  & ~obj.types) ;
STrials.CorrectLeftNum=find(obj.trialsL.hitHistory==1 & ~obj.types) ;
STrials.ErrorLeftNum=find(obj.trialsL.missHistory==1  & ~obj.types) ;
STrials.NoResponseLeftNum=find(obj.trialsL.noResponseHistory==1  & ~obj.types) ;
STrials.CorrectRightNum=find(obj.trialsR.hitHistory==1  & ~obj.types) ;
STrials.ErrorRightNum=find(obj.trialsR.missHistory==1  & ~obj.types) ;
STrials.NoResponseRightNum=find(obj.trialsR.noResponseHistory==1 &~obj.types) ;

%unexpected reward and reward omission trials
STrials.UnexpectedRewardAllNum=[];
STrials.RewardOmissionAllNum=[];
STrials.UnexpectedRewardLeftNum=[];
STrials.RewardOmissionLeftNum=[];
STrials.UnexpectedRewardRightNum=[];
STrials.RewardOmissionRightNum=[];
STrials.RewardOmissionRightErrorNum=[];
STrials.RewardOmissionRightCorrectNum=[];
STrials.RewardOmissionLeftErrorNum=[];
STrials.RewardOmissionLeftCorrectNum=[];

%photostimulation trials
STrials.PhotoStimLeftAllNum=obj.trialsLStim.trialNums;
STrials.PhotoStimRightAllNum=obj.trialsRStim.trialNums;
STrials.PhotoStimCorrectLeftNum=obj.trialsLStim.hitTrialNums;
STrials.PhotoStimErrorLeftNum=obj.trialsLStim.missTrialNums;
STrials.PhotoStimNoresponseLeftNum=obj.trialsLStim.noResponseTrialNums;
STrials.PhotoStimCorrectRightNum=obj.trialsRStim.hitTrialNums;
STrials.PhotoStimErrorRightNum=obj.trialsRStim.missTrialNums;
STrials.PhotoStimNoresponseRightNum=obj.trialsRStim.noResponseTrialNums;


STrials.PhotoStimSampleLeftAllNum=obj.trialsLStim.trialNumsSample;
STrials.PhotoStimSampleCorrectLeftNum=obj.trialsLStim.hitTrialNumsSample;
STrials.PhotoStimSampleErrorLeftNum=obj.trialsLStim.missTrialNumsSample;
STrials.PhotoStimSampleNoresponseLeftNum=obj.trialsLStim.noResponseTrialNumsSample;

STrials.PhotoStimSampleRightAllNum=obj.trialsRStim.trialNumsSample;
STrials.PhotoStimSampleCorrectRightNum=obj.trialsRStim.hitTrialNumsSample;
STrials.PhotoStimSampleErrorRightNum=obj.trialsRStim.missTrialNumsSample;
STrials.PhotoStimSampleNoresponseRightNum=obj.trialsRStim.noResponseTrialNumsSample;

STrials.PhotoStimDelayLeftAllNum=obj.trialsLStim.trialNumsDelay;
STrials.PhotoStimDelayCorrectLeftNum=obj.trialsLStim.hitTrialNumsDelay;
STrials.PhotoStimDelayErrorLeftNum=obj.trialsLStim.missTrialNumsDelay;
STrials.PhotoStimDelayNoresponseLeftNum=obj.trialsLStim.noResponseTrialNumsDelay;

STrials.PhotoStimDelayRightAllNum=obj.trialsRStim.trialNumsDelay;
STrials.PhotoStimDelayCorrectRightNum=obj.trialsRStim.hitTrialNumsDelay;
STrials.PhotoStimDelayErrorRightNum=obj.trialsRStim.missTrialNumsDelay;
STrials.PhotoStimDelayNoresponseRightNum=obj.trialsRStim.noResponseTrialNumsDelay;


STrials.NoStimLeftNum=[obj.trialsLNoStim.hitTrialNums  obj.trialsLNoStim.missTrialNums];
STrials.NoStimRightNum=[obj.trialsRNoStim.hitTrialNums  obj.trialsRNoStim.missTrialNums];


% multisense
try
    if WhiskerAuditoryTask==1
        obj.user_var.vibration_amp(1:length(obj.types))=0.2;
    end
    obj.user_var.vibration_amp=obj.user_var.vibration_amp(1:length(obj.types));
    STrials.Weak1Num=find(obj.user_var.vibration_amp'==0.2 & obj.types==0);
    STrials.Weak2Num=find(obj.user_var.vibration_amp'==0.4 & obj.types==0);
    STrials.Strong1Num=find(obj.user_var.vibration_amp'==0.6 & obj.types==0);
    STrials.Strong2Num=find(obj.user_var.vibration_amp'==0.9 & obj.types==0);
    
    STrials.Weak1CorrectNum=find(obj.user_var.vibration_amp'==0.2 & obj.types==0 & obj.trials.hitHistory==1);
    STrials.Weak2CorrectNum=find(obj.user_var.vibration_amp'==0.4 & obj.types==0 & obj.trials.hitHistory==1);
    STrials.Strong1CorrectNum=find(obj.user_var.vibration_amp'==0.6 & obj.types==0 & obj.trials.hitHistory==1);
    STrials.Strong2CorrectNum=find(obj.user_var.vibration_amp'==0.9 & obj.types==0 & obj.trials.hitHistory==1);
    
    
    STrials.Weak1WrongNum=find(obj.user_var.vibration_amp'==0.2 & obj.types==0 & obj.trials.hitHistory==0);
    STrials.Weak2WrongNum=find(obj.user_var.vibration_amp'==0.4 & obj.types==0 & obj.trials.hitHistory==0);
    STrials.Strong1WrongNum=find(obj.user_var.vibration_amp'==0.6 & obj.types==0 & obj.trials.hitHistory==0);
    STrials.Strong2WrongNum=find(obj.user_var.vibration_amp'==0.9 & obj.types==0 & obj.trials.hitHistory==0);
    % multisense inhibition
    STrials.Weak1DelayInhibitionNum=find(obj.user_var.vibration_amp'==0.2 & obj.types==1);
    STrials.Weak2DelayInhibitionNum=find(obj.user_var.vibration_amp'==0.4 & obj.types==1);
    STrials.Strong1DelayInhibitionNum=find(obj.user_var.vibration_amp'==0.6 & obj.types==1);
    STrials.Strong2DelayInhibitionNum=find(obj.user_var.vibration_amp'==0.9 & obj.types==1);
    
    STrials.Weak1CorrectDelayInhibitionNum=find(obj.user_var.vibration_amp'==0.2 & obj.types==1 & obj.trials.hitHistory==1);
    STrials.Weak2CorrectDelayInhibitionNum=find(obj.user_var.vibration_amp'==0.4 & obj.types==1 & obj.trials.hitHistory==1);
    STrials.Strong1CorrectDelayInhibitionNum=find(obj.user_var.vibration_amp'==0.6 & obj.types==1 & obj.trials.hitHistory==1);
    STrials.Strong2CorrectDelayInhibitionNum=find(obj.user_var.vibration_amp'==0.9 & obj.types==1 & obj.trials.hitHistory==1);
    
    
    STrials.Weak1WrongDelayInhibitionNum=find(obj.user_var.vibration_amp'==0.2 & obj.types==1 & obj.trials.hitHistory==0);
    STrials.Weak2WrongDelayInhibitionNum=find(obj.user_var.vibration_amp'==0.4 & obj.types==1 & obj.trials.hitHistory==0);
    STrials.Strong1WrongDelayInhibitionNum=find(obj.user_var.vibration_amp'==0.6 & obj.types==1 & obj.trials.hitHistory==0);
    STrials.Strong2WrongDelayInhibitionNum=find(obj.user_var.vibration_amp'==0.9 & obj.types==1 & obj.trials.hitHistory==0);
catch
end
% whisker and audirory task
if isfield(obj.user_var,'sessionType')
    WhiskerBehavior=find(strcmp(obj.user_var.sessionType,'Discrim_Delay'));
    AudiBehavior=find(strcmp(obj.user_var.sessionType,'Discrim_Delay_Auo'));
else
    WhiskerBehavior=[];
    AudiBehavior=[];
end


STrials.WhiskerLeftAllNum=intersect(STrials.NoStimLeftNum,WhiskerBehavior);
STrials.WhiskerRightAllNum=intersect(STrials.NoStimRightNum,WhiskerBehavior);
STrials.AuditoryLeftAllNum=intersect(STrials.NoStimLeftNum,AudiBehavior);
STrials.AuditoryRightAllNum=intersect(STrials.NoStimRightNum,AudiBehavior);
STrials.WhiskerCorrectLeftAllNum=intersect(STrials.CorrectLeftNum,WhiskerBehavior);
STrials.WhiskerCorrectRightAllNum=intersect(STrials.CorrectRightNum,WhiskerBehavior);
STrials.AuditoryCorrectLeftAllNum=intersect(STrials.CorrectLeftNum,AudiBehavior);
STrials.AuditoryCorrectRightAllNum=intersect(STrials.CorrectRightNum,AudiBehavior);
STrials.WhiskerErrorLeftAllNum=intersect(STrials.ErrorLeftNum,WhiskerBehavior);
STrials.WhiskerErrorRightAllNum=intersect(STrials.ErrorRightNum,WhiskerBehavior);
STrials.AuditoryErrorLeftAllNum=intersect(STrials.ErrorLeftNum,AudiBehavior);
STrials.AuditoryErrorRightAllNum=intersect(STrials.ErrorRightNum,AudiBehavior);

STrials.PhotoStimSampleWhiskerLeftAllNum=intersect(STrials.PhotoStimSampleLeftAllNum,WhiskerBehavior);
STrials.PhotoStimSampleWhiskerRightAllNum=intersect(STrials.PhotoStimSampleRightAllNum,WhiskerBehavior);
STrials.PhotoStimSampleAuditoryLeftAllNum=intersect(STrials.PhotoStimSampleLeftAllNum,AudiBehavior);
STrials.PhotoStimSampleAuditoryRightAllNum=intersect(STrials.PhotoStimSampleRightAllNum,AudiBehavior);
STrials.PhotoStimSampleWhiskerCorrectLeftAllNum=intersect(STrials.PhotoStimSampleCorrectLeftNum,WhiskerBehavior);
STrials.PhotoStimSampleWhiskerCorrectRightAllNum=intersect(STrials.PhotoStimSampleCorrectRightNum,WhiskerBehavior);
STrials.PhotoStimSampleAuditoryCorrectLeftAllNum=intersect(STrials.PhotoStimSampleCorrectLeftNum,AudiBehavior);
STrials.PhotoStimSampleAuditoryCorrectRightAllNum=intersect(STrials.PhotoStimSampleCorrectRightNum,AudiBehavior);
STrials.PhotoStimSampleWhiskerErrorLeftAllNum=intersect(STrials.PhotoStimSampleErrorLeftNum,WhiskerBehavior);
STrials.PhotoStimSampleWhiskerErrorRightAllNum=intersect(STrials.PhotoStimSampleErrorRightNum,WhiskerBehavior);
STrials.PhotoStimSampleAuditoryErrorLeftAllNum=intersect(STrials.PhotoStimSampleErrorLeftNum,AudiBehavior);
STrials.PhotoStimSampleAuditoryErrorRightAllNum=intersect(STrials.PhotoStimSampleErrorRightNum,AudiBehavior);

STrials.PhotoStimDelayWhiskerLeftAllNum=intersect(STrials.PhotoStimDelayLeftAllNum,WhiskerBehavior);
STrials.PhotoStimDelayWhiskerRightAllNum=intersect(STrials.PhotoStimDelayRightAllNum,WhiskerBehavior);
STrials.PhotoStimDelayAuditoryLeftAllNum=intersect(STrials.PhotoStimDelayLeftAllNum,AudiBehavior);
STrials.PhotoStimDelayAuditoryRightAllNum=intersect(STrials.PhotoStimDelayRightAllNum,AudiBehavior);
STrials.PhotoStimDelayWhiskerCorrectLeftAllNum=intersect(STrials.PhotoStimDelayCorrectLeftNum,WhiskerBehavior);
STrials.PhotoStimDelayWhiskerCorrectRightAllNum=intersect(STrials.PhotoStimDelayCorrectRightNum,WhiskerBehavior);
STrials.PhotoStimDelayAuditoryCorrectLeftAllNum=intersect(STrials.PhotoStimDelayCorrectLeftNum,AudiBehavior);
STrials.PhotoStimDelayAuditoryCorrectRightAllNum=intersect(STrials.PhotoStimDelayCorrectRightNum,AudiBehavior);
STrials.PhotoStimDelayWhiskerErrorLeftAllNum=intersect(STrials.PhotoStimDelayErrorLeftNum,WhiskerBehavior);
STrials.PhotoStimDelayWhiskerErrorRightAllNum=intersect(STrials.PhotoStimDelayErrorRightNum,WhiskerBehavior);
STrials.PhotoStimDelayAuditoryErrorLeftAllNum=intersect(STrials.PhotoStimDelayErrorLeftNum,AudiBehavior);
STrials.PhotoStimDelayAuditoryErrorRightAllNum=intersect(STrials.PhotoStimDelayErrorRightNum,AudiBehavior);







% add response inhibition
try
    STrials.PhotoStimResponseLeftAllNum=obj.trialsLStim.trialNumsResponse;
    STrials.PhotoStimResponseCorrectLeftNum=obj.trialsLStim.hitTrialNumsResponse;
    STrials.PhotoStimResponseErrorLeftNum=obj.trialsLStim.missTrialNumsResponse;
    STrials.PhotoStimResponseNoresponseLeftNum=obj.trialsLStim.noResponseTrialNumsResponse;
    
    STrials.PhotoStimResponseRightAllNum=obj.trialsRStim.trialNumsResponse;
    STrials.PhotoStimResponseCorrectRightNum=obj.trialsRStim.hitTrialNumsResponse;
    STrials.PhotoStimResponseErrorRightNum=obj.trialsRStim.missTrialNumsResponse;
    STrials.PhotoStimResponseNoresponseRightNum=obj.trialsRStim.noResponseTrialNumsResponse;
catch
    STrials.PhotoStimResponseLeftAllNum=[];
    STrials.PhotoStimResponseCorrectLeftNum=[];
    STrials.PhotoStimResponseErrorLeftNum=[];
    STrials.PhotoStimResponseNoresponseLeftNum=[];
    
    STrials.PhotoStimResponseRightAllNum=[];
    STrials.PhotoStimResponseCorrectRightNum=[];
    STrials.PhotoStimResponseErrorRightNum=[];
    STrials.PhotoStimResponseNoresponseRightNum=[];
end


HitTrials=find(obj.trials.hitHistory);
ErrorTrials=find(obj.trials.missHistory);
% left ALM or right ALM inhibition
STrials.DelayLeftALMInhibition_LeftTrialNum=intersect(obj.trialsLStim.trialNumsDelay,find(obj.xGalvoHistory<0));
STrials.DelayLeftALMInhibition_RightTrialNum=intersect(obj.trialsRStim.trialNumsDelay,find(obj.xGalvoHistory<0));
STrials.DelayRightALMInhibition_LeftTrialNum=intersect(obj.trialsLStim.trialNumsDelay,find(obj.xGalvoHistory>0));
STrials.DelayRightALMInhibition_RightTrialNum=intersect(obj.trialsRStim.trialNumsDelay,find(obj.xGalvoHistory>0));
STrials.DelayLeftALMInhibition_LeftTrial_CNum=intersect(STrials.DelayLeftALMInhibition_LeftTrialNum,HitTrials);
STrials.DelayLeftALMInhibition_RightTrial_CNum=intersect(STrials.DelayLeftALMInhibition_RightTrialNum,HitTrials);
STrials.DelayRightALMInhibition_LeftTrial_CNum=intersect(STrials.DelayRightALMInhibition_LeftTrialNum,HitTrials);
STrials.DelayRightALMInhibition_RightTrial_CNum=intersect(STrials.DelayRightALMInhibition_RightTrialNum,HitTrials);
STrials.DelayLeftALMInhibition_LeftTrial_ENum=intersect(STrials.DelayLeftALMInhibition_LeftTrialNum,ErrorTrials);
STrials.DelayLeftALMInhibition_RightTrial_ENum=intersect(STrials.DelayLeftALMInhibition_RightTrialNum,ErrorTrials);
STrials.DelayRightALMInhibition_LeftTrial_ENum=intersect(STrials.DelayRightALMInhibition_LeftTrialNum,ErrorTrials);
STrials.DelayRightALMInhibition_RightTrial_ENum=intersect(STrials.DelayRightALMInhibition_RightTrialNum,ErrorTrials);


STrials.SampleLeftALMInhibition_LeftTrialNum=intersect(obj.trialsLStim.trialNumsSample,find(obj.xGalvoHistory<0));
STrials.SampleLeftALMInhibition_RightTrialNum=intersect(obj.trialsRStim.trialNumsSample,find(obj.xGalvoHistory<0));
STrials.SampleRightALMInhibition_LeftTrialNum=intersect(obj.trialsLStim.trialNumsSample,find(obj.xGalvoHistory>0));
STrials.SampleRightALMInhibition_RightTrialNum=intersect(obj.trialsRStim.trialNumsSample,find(obj.xGalvoHistory>0));
STrials.SampleLeftALMInhibition_LeftTrial_CNum=intersect(STrials.SampleLeftALMInhibition_LeftTrialNum,HitTrials);
STrials.SampleLeftALMInhibition_RightTrial_CNum=intersect(STrials.SampleLeftALMInhibition_RightTrialNum,HitTrials);
STrials.SampleRightALMInhibition_LeftTrial_CNum=intersect(STrials.SampleRightALMInhibition_LeftTrialNum,HitTrials);
STrials.SampleRightALMInhibition_RightTrial_CNum=intersect(STrials.SampleRightALMInhibition_RightTrialNum,HitTrials);
STrials.SampleLeftALMInhibition_LeftTrial_ENum=intersect(STrials.SampleLeftALMInhibition_LeftTrialNum,ErrorTrials);
STrials.SampleLeftALMInhibition_RightTrial_ENum=intersect(STrials.SampleLeftALMInhibition_RightTrialNum,ErrorTrials);
STrials.SampleRightALMInhibition_LeftTrial_ENum=intersect(STrials.SampleRightALMInhibition_LeftTrialNum,ErrorTrials);
STrials.SampleRightALMInhibition_RightTrial_ENum=intersect(STrials.SampleRightALMInhibition_RightTrialNum,ErrorTrials);
% LJ inhibition
STrials.LJNormalNum=[obj.trialsLNoStim.trialNums obj.trialsRNoStim.trialNums];
STrials.LJInhibition1Num=find(obj.aomPowerHistory==0.75 & obj.types );
STrials.LJInhibition2Num=find(obj.aomPowerHistory==1.15 & obj.types );
STrials.LJInhibition3Num=find(obj.aomPowerHistory==1.6 & obj.types );

if isfield(obj.ephus,'trial_NO')
    trial_NO=obj.ephus.trial_NO;
    STrials.CorretAllNum=intersect(STrials.CorretAllNum,trial_NO);
    STrials.ErrorAllNum=intersect(STrials.ErrorAllNum,trial_NO);
    STrials.NoResponseAllNum=intersect(STrials.NoResponseAllNum,trial_NO);
    STrials.CorrectLeftNum=intersect(STrials.CorrectLeftNum,trial_NO);
    STrials.ErrorLeftNum=intersect(STrials.ErrorLeftNum,trial_NO);
    STrials.NoResponseLeftNum=intersect(STrials.NoResponseLeftNum,trial_NO);
    STrials.CorrectRightNum=intersect(STrials.CorrectRightNum,trial_NO);
    STrials.ErrorRightNum=intersect(STrials.ErrorRightNum,trial_NO);
    STrials.NoResponseRightNum=intersect(STrials.NoResponseRightNum,trial_NO);
    %unexpected reward and reward omission trials
    STrials.UnexpectedRewardAllNum=intersect(STrials.UnexpectedRewardAllNum,trial_NO);
    STrials.RewardOmissionAllNum=intersect(STrials.RewardOmissionAllNum,trial_NO);
    STrials.UnexpectedRewardLeftNum=intersect(STrials.UnexpectedRewardLeftNum,trial_NO);
    STrials.RewardOmissionLeftNum=intersect(STrials.RewardOmissionLeftNum,trial_NO);
    STrials.UnexpectedRewardRightNum=intersect(STrials.UnexpectedRewardRightNum,trial_NO);
    STrials.RewardOmissionRightNum=intersect(STrials.RewardOmissionRightNum,trial_NO);
    STrials.RewardOmissionRightErrorNum=intersect(STrials.RewardOmissionRightErrorNum,trial_NO);
    STrials.RewardOmissionRightCorrectNum=intersect(STrials.RewardOmissionRightCorrectNum,trial_NO);
    STrials.RewardOmissionLeftErrorNum=intersect(STrials.RewardOmissionLeftErrorNum,trial_NO);
    STrials.RewardOmissionLeftCorrectNum=intersect(STrials.RewardOmissionLeftCorrectNum,trial_NO);
    %photostimulation trials
    STrials.PhotoStimLeftAllNum=intersect(STrials.PhotoStimLeftAllNum,trial_NO);
    STrials.PhotoStimRightAllNum=intersect(STrials.PhotoStimRightAllNum,trial_NO);
    STrials.PhotoStimCorrectLeftNum=intersect(STrials.PhotoStimCorrectLeftNum,trial_NO);
    STrials.PhotoStimErrorLeftNum=intersect(STrials.PhotoStimErrorLeftNum,trial_NO);
    STrials.PhotoStimNoresponseLeftNum=intersect(STrials.PhotoStimNoresponseLeftNum,trial_NO);
    STrials.PhotoStimCorrectRightNum=intersect(STrials.PhotoStimCorrectRightNum,trial_NO);
    STrials.PhotoStimErrorRightNum=intersect(STrials.PhotoStimErrorRightNum,trial_NO);
    STrials.PhotoStimNoresponseRightNum=intersect(STrials.PhotoStimNoresponseRightNum,trial_NO);
    
    
    STrials.PhotoStimSampleLeftAllNum=intersect(STrials.PhotoStimSampleLeftAllNum,trial_NO);
    STrials.PhotoStimSampleCorrectLeftNum=intersect(STrials.PhotoStimSampleCorrectLeftNum,trial_NO);
    STrials.PhotoStimSampleErrorLeftNum=intersect(STrials.PhotoStimSampleErrorLeftNum,trial_NO);
    STrials.PhotoStimSampleNoresponseLeftNum=intersect(STrials.PhotoStimSampleNoresponseLeftNum,trial_NO);
    
    STrials.PhotoStimSampleRightAllNum=intersect(STrials.PhotoStimSampleRightAllNum,trial_NO);
    STrials.PhotoStimSampleCorrectRightNum=intersect(STrials.PhotoStimSampleCorrectRightNum,trial_NO);
    STrials.PhotoStimSampleErrorRightNum=intersect(STrials.PhotoStimSampleErrorRightNum,trial_NO);
    STrials.PhotoStimSampleNoresponseRightNum=intersect(STrials.PhotoStimSampleNoresponseRightNum,trial_NO);
    
    STrials.PhotoStimDelayLeftAllNum=intersect(STrials.PhotoStimDelayLeftAllNum,trial_NO);
    STrials.PhotoStimDelayCorrectLeftNum=intersect(STrials.PhotoStimDelayCorrectLeftNum,trial_NO);
    STrials.PhotoStimDelayErrorLeftNum=intersect(STrials.PhotoStimDelayErrorLeftNum,trial_NO);
    STrials.PhotoStimDelayNoresponseLeftNum=intersect(STrials.PhotoStimDelayNoresponseLeftNum,trial_NO);
    
    STrials.PhotoStimDelayRightAllNum=intersect(STrials.PhotoStimDelayRightAllNum,trial_NO);
    STrials.PhotoStimDelayCorrectRightNum=intersect(STrials.PhotoStimDelayCorrectRightNum,trial_NO);
    STrials.PhotoStimDelayErrorRightNum=intersect(STrials.PhotoStimDelayErrorRightNum,trial_NO);
    STrials.PhotoStimDelayNoresponseRightNum=intersect(STrials.PhotoStimDelayNoresponseRightNum,trial_NO);
    
    STrials.NoStimLeftNum=intersect(STrials.NoStimLeftNum,trial_NO);
    STrials.NoStimRightNum=intersect(STrials.NoStimRightNum,trial_NO);
    
    % multisense
    try
        STrials.Weak1Num=intersect(STrials.Weak1Num,trial_NO);
        STrials.Weak2Num=intersect(STrials.Weak2Num,trial_NO);
        STrials.Strong1Num=intersect(STrials.Strong1Num,trial_NO);
        STrials.Strong2Num=intersect(STrials.Strong2Num,trial_NO);
        
        STrials.Weak1CorrectNum=intersect(STrials.Weak1CorrectNum,trial_NO);
        STrials.Weak2CorrectNum=intersect(STrials.Weak2CorrectNum,trial_NO);
        STrials.Strong1CorrectNum=intersect(STrials.Strong1CorrectNum,trial_NO);
        STrials.Strong2CorrectNum=intersect(STrials.Strong2CorrectNum,trial_NO);
        
        
        STrials.Weak1WrongNum=intersect(STrials.Weak1WrongNum,trial_NO);
        STrials.Weak2WrongNum=intersect(STrials.Weak2WrongNum,trial_NO);
        STrials.Strong1WrongNum=intersect(STrials.Strong1WrongNum,trial_NO);
        STrials.Strong2WrongNum=intersect(STrials.Strong2WrongNum,trial_NO);
        % multisense inhibition
        STrials.Weak1DelayInhibitionNum=intersect(STrials.Weak1DelayInhibitionNum,trial_NO);
        STrials.Weak2DelayInhibitionNum=intersect(STrials.Weak2DelayInhibitionNum,trial_NO);
        STrials.Strong1DelayInhibitionNum=intersect(STrials.Strong1DelayInhibitionNum,trial_NO);
        STrials.Strong2DelayInhibitionNum=intersect(STrials.Strong2DelayInhibitionNum,trial_NO);
        
        STrials.Weak1CorrectDelayInhibitionNum=intersect(STrials.Weak1CorrectDelayInhibitionNum,trial_NO);
        STrials.Weak2CorrectDelayInhibitionNum=intersect(STrials.Weak2CorrectDelayInhibitionNum,trial_NO);
        STrials.Strong1CorrectDelayInhibitionNum=intersect(STrials.Strong1CorrectDelayInhibitionNum,trial_NO);
        STrials.Strong2CorrectDelayInhibitionNum=intersect(STrials.Strong2CorrectDelayInhibitionNum,trial_NO);
        
        
        STrials.Weak1WrongDelayInhibitionNum=intersect(STrials.Weak1WrongDelayInhibitionNum,trial_NO);
        STrials.Weak2WrongDelayInhibitionNum=intersect(STrials.Weak2WrongDelayInhibitionNum,trial_NO);
        STrials.Strong1WrongDelayInhibitionNum=intersect(STrials.Strong1WrongDelayInhibitionNum,trial_NO);
        STrials.Strong2WrongDelayInhibitionNum=intersect(STrials.Strong2WrongDelayInhibitionNum,trial_NO);
        
        
        
        STrials.PhotoStimResponseLeftAllNum=intersect(STrials.PhotoStimResponseLeftAllNum,trial_NO);
        STrials.PhotoStimResponseCorrectLeftNum=intersect(STrials.PhotoStimResponseCorrectLeftNum,trial_NO);
        STrials.PhotoStimResponseErrorLeftNum=intersect(STrials.PhotoStimResponseErrorLeftNum,trial_NO);
        STrials.PhotoStimResponseNoresponseLeftNum=intersect(STrials.PhotoStimResponseNoresponseLeftNum,trial_NO);
        
        STrials.PhotoStimResponseRightAllNum=intersect(STrials.PhotoStimResponseRightAllNum,trial_NO);
        STrials.PhotoStimResponseCorrectRightNum=intersect(STrials.PhotoStimResponseCorrectRightNum,trial_NO);
        STrials.PhotoStimResponseErrorRightNum=intersect( STrials.PhotoStimResponseErrorRightNum,trial_NO);
        STrials.PhotoStimResponseNoresponseRightNum=intersect(STrials.PhotoStimResponseNoresponseRightNum,trial_NO);
    catch
        
    end
    
    
    % whisker and auditory task
    STrials.WhiskerLeftAllNum=intersect(STrials.WhiskerLeftAllNum,trial_NO);
    STrials.WhiskerRightAllNum=intersect(STrials.WhiskerRightAllNum,trial_NO);
    STrials.AuditoryLeftAllNum=intersect(STrials.AuditoryLeftAllNum,trial_NO);
    STrials.AuditoryRightAllNum=intersect(STrials.AuditoryRightAllNum,trial_NO);
    STrials.WhiskerCorrectLeftAllNum=intersect(STrials.WhiskerCorrectLeftAllNum,trial_NO);
    STrials.WhiskerCorrectRightAllNum=intersect(STrials.WhiskerCorrectRightAllNum,trial_NO);
    STrials.AuditoryCorrectLeftAllNum=intersect(STrials.AuditoryCorrectLeftAllNum,trial_NO);
    STrials.AuditoryCorrectRightAllNum=intersect(STrials.AuditoryCorrectRightAllNum,trial_NO);
    STrials.WhiskerErrorLeftAllNum=intersect(STrials.WhiskerErrorLeftAllNum,trial_NO);
    STrials.WhiskerErrorRightAllNum=intersect(STrials.WhiskerErrorRightAllNum,trial_NO);
    STrials.AuditoryErrorLeftAllNum=intersect(STrials.AuditoryErrorLeftAllNum,trial_NO);
    STrials.AuditoryErrorRightAllNum=intersect(STrials.AuditoryErrorRightAllNum,trial_NO);
    
    STrials.PhotoStimSampleWhiskerLeftAllNum=intersect(STrials.PhotoStimSampleWhiskerLeftAllNum,trial_NO);
    STrials.PhotoStimSampleWhiskerRightAllNum=intersect(STrials.PhotoStimSampleWhiskerRightAllNum,trial_NO);
    STrials.PhotoStimSampleAuditoryLeftAllNum=intersect(STrials.PhotoStimSampleAuditoryLeftAllNum,trial_NO);
    STrials.PhotoStimSampleAuditoryRightAllNum=intersect(STrials.PhotoStimSampleAuditoryRightAllNum,trial_NO);
    STrials.PhotoStimSampleWhiskerCorrectLeftAllNum=intersect(STrials.PhotoStimSampleWhiskerCorrectLeftAllNum,trial_NO);
    STrials.PhotoStimSampleWhiskerCorrectRightAllNum=intersect(STrials.PhotoStimSampleWhiskerCorrectRightAllNum,trial_NO);
    STrials.PhotoStimSampleAuditoryCorrectLeftAllNum=intersect(STrials.PhotoStimSampleAuditoryCorrectLeftAllNum,trial_NO);
    STrials.PhotoStimSampleAuditoryCorrectRightAllNum=intersect(STrials.PhotoStimSampleAuditoryCorrectRightAllNum,trial_NO);
    STrials.PhotoStimSampleWhiskerErrorLeftAllNum=intersect(STrials.PhotoStimSampleWhiskerErrorLeftAllNum,trial_NO);
    STrials.PhotoStimSampleWhiskerErrorRightAllNum=intersect(STrials.PhotoStimSampleWhiskerErrorRightAllNum,trial_NO);
    STrials.PhotoStimSampleAuditoryErrorLeftAllNum=intersect(STrials.PhotoStimSampleAuditoryErrorLeftAllNum,trial_NO);
    STrials.PhotoStimSampleAuditoryErrorRightAllNum=intersect(STrials.PhotoStimSampleAuditoryErrorRightAllNum,trial_NO);
    
    STrials.PhotoStimDelayWhiskerLeftAllNum=intersect(STrials.PhotoStimDelayWhiskerLeftAllNum,trial_NO);
    STrials.PhotoStimDelayWhiskerRightAllNum=intersect(STrials.PhotoStimDelayWhiskerRightAllNum,trial_NO);
    STrials.PhotoStimDelayAuditoryLeftAllNum=intersect(STrials.PhotoStimDelayAuditoryLeftAllNum,trial_NO);
    STrials.PhotoStimDelayAuditoryRightAllNum=intersect(STrials.PhotoStimDelayAuditoryRightAllNum,trial_NO);
    STrials.PhotoStimDelayWhiskerCorrectLeftAllNum=intersect(STrials.PhotoStimDelayWhiskerCorrectLeftAllNum,trial_NO);
    STrials.PhotoStimDelayWhiskerCorrectRightAllNum=intersect(STrials.PhotoStimDelayWhiskerCorrectRightAllNum,trial_NO);
    STrials.PhotoStimDelayAuditoryCorrectLeftAllNum=intersect(STrials.PhotoStimDelayAuditoryCorrectLeftAllNum,trial_NO);
    STrials.PhotoStimDelayAuditoryCorrectRightAllNum=intersect(STrials.PhotoStimDelayAuditoryCorrectRightAllNum,trial_NO);
    STrials.PhotoStimDelayWhiskerErrorLeftAllNum=intersect(STrials.PhotoStimDelayWhiskerErrorLeftAllNum,trial_NO);
    STrials.PhotoStimDelayWhiskerErrorRightAllNum=intersect(STrials.PhotoStimDelayWhiskerErrorRightAllNum,trial_NO);
    STrials.PhotoStimDelayAuditoryErrorLeftAllNum=intersect(STrials.PhotoStimDelayAuditoryErrorLeftAllNum,trial_NO);
    STrials.PhotoStimDelayAuditoryErrorRightAllNum=intersect(STrials.PhotoStimDelayAuditoryErrorRightAllNum,trial_NO);
    
    % left alm or right alm inhibition
    STrials.DelayLeftALMInhibition_LeftTrialNum=intersect(STrials.DelayLeftALMInhibition_LeftTrialNum,trial_NO);
    STrials.DelayLeftALMInhibition_RightTrialNum=intersect(STrials.DelayLeftALMInhibition_RightTrialNum,trial_NO);
    STrials.DelayRightALMInhibition_LeftTrialNum=intersect(STrials.DelayRightALMInhibition_LeftTrialNum,trial_NO);
    STrials.DelayRightALMInhibition_RightTrialNum=intersect(STrials.DelayRightALMInhibition_RightTrialNum,trial_NO);
    STrials.DelayLeftALMInhibition_LeftTrial_CNum=intersect(STrials.DelayLeftALMInhibition_LeftTrial_CNum,trial_NO);
    STrials.DelayLeftALMInhibition_RightTrial_CNum=intersect(STrials.DelayLeftALMInhibition_RightTrial_CNum,trial_NO);
    STrials.DelayRightALMInhibition_LeftTrial_CNum=intersect(STrials.DelayRightALMInhibition_LeftTrial_CNum,trial_NO);
    STrials.DelayRightALMInhibition_RightTrial_CNum=intersect(STrials.DelayRightALMInhibition_RightTrial_CNum,trial_NO);
    STrials.DelayLeftALMInhibition_LeftTrial_ENum=intersect(STrials.DelayLeftALMInhibition_LeftTrial_ENum,trial_NO);
    STrials.DelayLeftALMInhibition_RightTrial_ENum=intersect(STrials.DelayLeftALMInhibition_RightTrial_ENum,trial_NO);
    STrials.DelayRightALMInhibition_LeftTrial_ENum=intersect(STrials.DelayRightALMInhibition_LeftTrial_ENum,trial_NO);
    STrials.DelayRightALMInhibition_RightTrial_ENum=intersect(STrials.DelayRightALMInhibition_RightTrial_ENum,trial_NO);
    
    STrials.SampleLeftALMInhibition_LeftTrialNum=intersect(STrials.SampleLeftALMInhibition_LeftTrialNum,trial_NO);
    STrials.SampleLeftALMInhibition_RightTrialNum=intersect(STrials.SampleLeftALMInhibition_RightTrialNum,trial_NO);
    STrials.SampleRightALMInhibition_LeftTrialNum=intersect(STrials.SampleRightALMInhibition_LeftTrialNum,trial_NO);
    STrials.SampleRightALMInhibition_RightTrialNum=intersect(STrials.SampleRightALMInhibition_RightTrialNum,trial_NO);
    STrials.SampleLeftALMInhibition_LeftTrial_CNum=intersect(STrials.SampleLeftALMInhibition_LeftTrial_CNum,trial_NO);
    STrials.SampleLeftALMInhibition_RightTrial_CNum=intersect(STrials.SampleLeftALMInhibition_RightTrial_CNum,trial_NO);
    STrials.SampleRightALMInhibition_LeftTrial_CNum=intersect(STrials.SampleRightALMInhibition_LeftTrial_CNum,trial_NO);
    STrials.SampleRightALMInhibition_RightTrial_CNum=intersect(STrials.SampleRightALMInhibition_RightTrial_CNum,trial_NO);
    STrials.SampleLeftALMInhibition_LeftTrial_ENum=intersect(STrials.SampleLeftALMInhibition_LeftTrial_ENum,trial_NO);
    STrials.SampleLeftALMInhibition_RightTrial_ENum=intersect(STrials.SampleLeftALMInhibition_RightTrial_ENum,trial_NO);
    STrials.SampleRightALMInhibition_LeftTrial_ENum=intersect(STrials.SampleRightALMInhibition_LeftTrial_ENum,trial_NO);
    STrials.SampleRightALMInhibition_RightTrial_ENum=intersect(STrials.SampleRightALMInhibition_RightTrial_ENum,trial_NO);
 
    
    
    STrials.LJNormalNum=intersect(STrials.LJNormalNum,trial_NO);
    STrials.LJInhibition1Num=intersect(STrials.LJInhibition1Num,trial_NO);
    STrials.LJInhibition2Num=intersect(STrials.LJInhibition2Num,trial_NO);
    STrials.LJInhibition3Num=intersect(STrials.LJInhibition3Num,trial_NO);
end
%%
CorretAllNum=STrials.CorretAllNum;
ErrorAllNum=STrials.ErrorAllNum;
NoResponseAllNum=STrials.NoResponseAllNum;
CorrectLeftNum=STrials.CorrectLeftNum;
ErrorLeftNum=STrials.ErrorLeftNum;
NoResponseLeftNum=STrials.NoResponseLeftNum;
CorrectRightNum=STrials.CorrectRightNum;
ErrorRightNum=STrials.ErrorRightNum;
NoResponseRightNum=STrials.NoResponseRightNum;
%unexpected reward and reward omission trials
UnexpectedRewardAllNum=STrials.UnexpectedRewardAllNum;
RewardOmissionAllNum=STrials.RewardOmissionAllNum;
UnexpectedRewardLeftNum=STrials.UnexpectedRewardLeftNum;
RewardOmissionLeftNum=STrials.RewardOmissionLeftNum;
UnexpectedRewardRightNum=STrials.UnexpectedRewardRightNum;
RewardOmissionRightNum=STrials.RewardOmissionRightNum;
RewardOmissionRightErrorNum=STrials.RewardOmissionRightErrorNum;
RewardOmissionRightCorrectNum=STrials.RewardOmissionRightCorrectNum;
RewardOmissionLeftErrorNum=STrials.RewardOmissionLeftErrorNum;
RewardOmissionLeftCorrectNum=STrials.RewardOmissionLeftCorrectNum;
%photostimulation trials
PhotoStimLeftAllNum=STrials.PhotoStimLeftAllNum;
PhotoStimRightAllNum=STrials.PhotoStimRightAllNum;
PhotoStimCorrectLeftNum=STrials.PhotoStimCorrectLeftNum;
PhotoStimErrorLeftNum=STrials.PhotoStimErrorLeftNum;
PhotoStimNoresponseLeftNum=STrials.PhotoStimNoresponseLeftNum;
PhotoStimCorrectRightNum=STrials.PhotoStimCorrectRightNum;
PhotoStimErrorRightNum=STrials.PhotoStimErrorRightNum;
PhotoStimNoresponseRightNum=STrials.PhotoStimNoresponseRightNum;


PhotoStimSampleLeftAllNum=STrials.PhotoStimSampleLeftAllNum;
PhotoStimSampleCorrectLeftNum=STrials.PhotoStimSampleCorrectLeftNum;
PhotoStimSampleErrorLeftNum=STrials.PhotoStimSampleErrorLeftNum;
PhotoStimSampleNoresponseLeftNum=STrials.PhotoStimSampleNoresponseLeftNum;
%
PhotoStimSampleRightAllNum=STrials.PhotoStimSampleRightAllNum;
PhotoStimSampleCorrectRightNum=STrials.PhotoStimSampleCorrectRightNum;
PhotoStimSampleErrorRightNum=STrials.PhotoStimSampleErrorRightNum;
PhotoStimSampleNoresponseRightNum=STrials.PhotoStimSampleNoresponseRightNum;

PhotoStimDelayLeftAllNum=STrials.PhotoStimDelayLeftAllNum;
PhotoStimDelayCorrectLeftNum=STrials.PhotoStimDelayCorrectLeftNum;
PhotoStimDelayErrorLeftNum=STrials.PhotoStimDelayErrorLeftNum;
PhotoStimDelayNoresponseLeftNum=STrials.PhotoStimDelayNoresponseLeftNum;

PhotoStimDelayRightAllNum=STrials.PhotoStimDelayRightAllNum;
PhotoStimDelayCorrectRightNum=STrials.PhotoStimDelayCorrectRightNum;
PhotoStimDelayErrorRightNum=STrials.PhotoStimDelayErrorRightNum;
PhotoStimDelayNoresponseRightNum=STrials.PhotoStimDelayNoresponseRightNum;

NoStimLeftNum=STrials.NoStimLeftNum;
NoStimRightNum=STrials.NoStimRightNum;


try
    % multisense
    Weak1Num=STrials.Weak1Num;
    Weak2Num=STrials.Weak2Num;
    Strong1Num=STrials.Strong1Num;
    Strong2Num=STrials.Strong2Num;
    
    Weak1CorrectNum=STrials.Weak1CorrectNum;
    Weak2CorrectNum=STrials.Weak2CorrectNum;
    Strong1CorrectNum=STrials.Strong1CorrectNum;
    Strong2CorrectNum=STrials.Strong2CorrectNum;
    
    
    Weak1WrongNum=STrials.Weak1WrongNum;
    Weak2WrongNum=STrials.Weak2WrongNum;
    Strong1WrongNum=STrials.Strong1WrongNum;
    Strong2WrongNum=STrials.Strong2WrongNum;
    % multisense inhibition
    Weak1DelayInhibitionNum=STrials.Weak1DelayInhibitionNum;
    Weak2DelayInhibitionNum=STrials.Weak2DelayInhibitionNum;
    Strong1DelayInhibitionNum=STrials.Strong1DelayInhibitionNum;
    Strong2DelayInhibitionNum=STrials.Strong2DelayInhibitionNum;
    
    Weak1CorrectDelayInhibitionNum=STrials.Weak1CorrectDelayInhibitionNum;
    Weak2CorrectDelayInhibitionNum=STrials.Weak2CorrectDelayInhibitionNum;
    Strong1CorrectDelayInhibitionNum=STrials.Strong1CorrectDelayInhibitionNum;
    Strong2CorrectDelayInhibitionNum=STrials.Strong2CorrectDelayInhibitionNum;
    
    
    Weak1WrongDelayInhibitionNum=STrials.Weak1WrongDelayInhibitionNum;
    Weak2WrongDelayInhibitionNum=STrials.Weak2WrongDelayInhibitionNum;
    Strong1WrongDelayInhibitionNum=STrials.Strong1WrongDelayInhibitionNum;
    Strong2WrongDelayInhibitionNum=STrials.Strong2WrongDelayInhibitionNum;
catch
end

% add response inhibition
PhotoStimResponseLeftAllNum=STrials.PhotoStimResponseLeftAllNum;
PhotoStimResponseCorrectLeftNum=STrials.PhotoStimResponseCorrectLeftNum;
PhotoStimResponseErrorLeftNum=STrials.PhotoStimResponseErrorLeftNum;
PhotoStimResponseNoresponseLeftNum=STrials.PhotoStimResponseNoresponseLeftNum;

PhotoStimResponseRightAllNum=STrials.PhotoStimResponseRightAllNum;
PhotoStimResponseCorrectRightNum=STrials.PhotoStimResponseCorrectRightNum;
PhotoStimResponseErrorRightNum=STrials.PhotoStimResponseErrorRightNum;
PhotoStimResponseNoresponseRightNum=STrials.PhotoStimResponseNoresponseRightNum;



% whisker and auditory task
WhiskerLeftAllNum=STrials.WhiskerLeftAllNum;
WhiskerRightAllNum=STrials.WhiskerRightAllNum;
AuditoryLeftAllNum=STrials.AuditoryLeftAllNum;
AuditoryRightAllNum =STrials.AuditoryRightAllNum;
WhiskerCorrectLeftAllNum=STrials.WhiskerCorrectLeftAllNum;
WhiskerCorrectRightAllNum=STrials.WhiskerCorrectRightAllNum;
AuditoryCorrectLeftAllNum=STrials.AuditoryCorrectLeftAllNum;
AuditoryCorrectRightAllNum=STrials.AuditoryCorrectRightAllNum;
WhiskerErrorLeftAllNum=STrials.WhiskerErrorLeftAllNum;
WhiskerErrorRightAllNum=STrials.WhiskerErrorRightAllNum;
AuditoryErrorLeftAllNum=STrials.AuditoryErrorLeftAllNum;
AuditoryErrorRightAllNum=STrials.AuditoryErrorRightAllNum;

PhotoStimSampleWhiskerLeftAllNum=STrials.PhotoStimSampleWhiskerLeftAllNum;
PhotoStimSampleWhiskerRightAllNum=STrials.PhotoStimSampleWhiskerRightAllNum;
PhotoStimSampleAuditoryLeftAllNum=STrials.PhotoStimSampleAuditoryLeftAllNum;
PhotoStimSampleAuditoryRightAllNum=STrials.PhotoStimSampleAuditoryRightAllNum;
PhotoStimSampleWhiskerCorrectLeftAllNum=STrials.PhotoStimSampleWhiskerCorrectLeftAllNum;
PhotoStimSampleWhiskerCorrectRightAllNum=STrials.PhotoStimSampleWhiskerCorrectRightAllNum;
PhotoStimSampleAuditoryCorrectLeftAllNum=STrials.PhotoStimSampleAuditoryCorrectLeftAllNum;
PhotoStimSampleAuditoryCorrectRightAllNum=STrials.PhotoStimSampleAuditoryCorrectRightAllNum;
PhotoStimSampleWhiskerErrorLeftAllNum=STrials.PhotoStimSampleWhiskerErrorLeftAllNum;
PhotoStimSampleWhiskerErrorRightAllNum=STrials.PhotoStimSampleWhiskerErrorRightAllNum;
PhotoStimSampleAuditoryErrorLeftAllNum=STrials.PhotoStimSampleAuditoryErrorLeftAllNum;
PhotoStimSampleAuditoryErrorRightAllNum=STrials.PhotoStimSampleAuditoryErrorRightAllNum;

PhotoStimDelayWhiskerLeftAllNum=STrials.PhotoStimDelayWhiskerLeftAllNum;
PhotoStimDelayWhiskerRightAllNum=STrials.PhotoStimDelayWhiskerRightAllNum;
PhotoStimDelayAuditoryLeftAllNum=STrials.PhotoStimDelayAuditoryLeftAllNum;
PhotoStimDelayAuditoryRightAllNum =STrials.PhotoStimDelayAuditoryRightAllNum;
PhotoStimDelayWhiskerCorrectLeftAllNum=STrials.PhotoStimDelayWhiskerCorrectLeftAllNum;
PhotoStimDelayWhiskerCorrectRightAllNum=STrials.PhotoStimDelayWhiskerCorrectRightAllNum;
PhotoStimDelayAuditoryCorrectLeftAllNum=STrials.PhotoStimDelayAuditoryCorrectLeftAllNum;
PhotoStimDelayAuditoryCorrectRightAllNum=STrials.PhotoStimDelayAuditoryCorrectRightAllNum;
PhotoStimDelayWhiskerErrorLeftAllNum=STrials.PhotoStimDelayWhiskerErrorLeftAllNum;
PhotoStimDelayWhiskerErrorRightAllNum=STrials.PhotoStimDelayWhiskerErrorRightAllNum;
PhotoStimDelayAuditoryErrorLeftAllNum=STrials.PhotoStimDelayAuditoryErrorLeftAllNum;
PhotoStimDelayAuditoryErrorRightAllNum =STrials.PhotoStimDelayAuditoryErrorRightAllNum;

% leftOrRightALM inhibition
DelayLeftALMInhibition_LeftTrialNum=STrials.DelayLeftALMInhibition_LeftTrialNum;
DelayLeftALMInhibition_RightTrialNum=STrials.DelayLeftALMInhibition_RightTrialNum;
DelayRightALMInhibition_LeftTrialNum=STrials.DelayRightALMInhibition_LeftTrialNum;
DelayRightALMInhibition_RightTrialNum=STrials.DelayRightALMInhibition_RightTrialNum;
DelayLeftALMInhibition_LeftTrial_CNum=STrials.DelayLeftALMInhibition_LeftTrial_CNum;
DelayLeftALMInhibition_RightTrial_CNum=STrials.DelayLeftALMInhibition_RightTrial_CNum;
DelayRightALMInhibition_LeftTrial_CNum=STrials.DelayRightALMInhibition_LeftTrial_CNum;
DelayRightALMInhibition_RightTrial_CNum=STrials.DelayRightALMInhibition_RightTrial_CNum;
DelayLeftALMInhibition_LeftTrial_ENum=STrials.DelayLeftALMInhibition_LeftTrial_ENum;
DelayLeftALMInhibition_RightTrial_ENum=STrials.DelayLeftALMInhibition_RightTrial_ENum;
DelayRightALMInhibition_LeftTrial_ENum=STrials.DelayRightALMInhibition_LeftTrial_ENum;
DelayRightALMInhibition_RightTrial_ENum=STrials.DelayRightALMInhibition_RightTrial_ENum;

SampleLeftALMInhibition_LeftTrialNum=STrials.SampleLeftALMInhibition_LeftTrialNum;
SampleLeftALMInhibition_RightTrialNum=STrials.SampleLeftALMInhibition_RightTrialNum;
SampleRightALMInhibition_LeftTrialNum=STrials.SampleRightALMInhibition_LeftTrialNum;
SampleRightALMInhibition_RightTrialNum=STrials.SampleRightALMInhibition_RightTrialNum;
SampleLeftALMInhibition_LeftTrial_CNum=STrials.SampleLeftALMInhibition_LeftTrial_CNum;
SampleLeftALMInhibition_RightTrial_CNum=STrials.SampleLeftALMInhibition_RightTrial_CNum;
SampleRightALMInhibition_LeftTrial_CNum=STrials.SampleRightALMInhibition_LeftTrial_CNum;
SampleRightALMInhibition_RightTrial_CNum=STrials.SampleRightALMInhibition_RightTrial_CNum;
SampleLeftALMInhibition_LeftTrial_ENum=STrials.SampleLeftALMInhibition_LeftTrial_ENum;
SampleLeftALMInhibition_RightTrial_ENum=STrials.SampleLeftALMInhibition_RightTrial_ENum;
SampleRightALMInhibition_LeftTrial_ENum=STrials.SampleRightALMInhibition_LeftTrial_ENum;
SampleRightALMInhibition_RightTrial_ENum=STrials.SampleRightALMInhibition_RightTrial_ENum;

%% Trials length
CorretAllL=length(CorretAllNum);
ErrorAllL=length(ErrorAllNum);
NoResponseAllL=length(NoResponseAllNum);
CorrectLeftL=length(CorrectLeftNum);
ErrorLeftL=length(ErrorLeftNum);
NoResponseLeftL=length(NoResponseLeftNum);
CorrectRightL=length(CorrectRightNum);
ErrorRightL=length(ErrorRightNum);
NoResponseRightL=length(NoResponseRightNum);
%unexpected reward and reward omission trials
UnexpectedRewardAllL=length(UnexpectedRewardAllNum);
RewardOmissionAllL=length(RewardOmissionAllNum);
UnexpectedRewardLeftL=length(UnexpectedRewardLeftNum);
RewardOmissionLeftL=length(RewardOmissionLeftNum);
UnexpectedRewardRightL=length(UnexpectedRewardRightNum);
RewardOmissionRightL=length(RewardOmissionRightNum);
RewardOmissionRightErrorL=length(RewardOmissionRightErrorNum);
RewardOmissionRightCorrectL=length(RewardOmissionRightCorrectNum);
RewardOmissionLeftErrorL=length(RewardOmissionLeftErrorNum);
RewardOmissionLeftCorrectL=length(RewardOmissionLeftCorrectNum);
%photostimulation trials
PhotoStimLeftAllL=length(PhotoStimLeftAllNum);
PhotoStimRightAllL=length(PhotoStimRightAllNum);
PhotoStimCorrectLeftL=length(PhotoStimCorrectLeftNum);
PhotoStimErrorLeftL=length(PhotoStimErrorLeftNum);
PhotoStimNoresponseLeftL=length(PhotoStimNoresponseLeftNum);
PhotoStimCorrectRightL=length(PhotoStimCorrectRightNum);
PhotoStimErrorRightL=length(PhotoStimErrorRightNum);
PhotoStimNoresponseRightL=length(PhotoStimNoresponseRightNum);

% left alm or right alm inhibition

DelayLeftALMInhibition_LeftTrialL=length(STrials.DelayLeftALMInhibition_LeftTrialNum);
DelayLeftALMInhibition_RightTrialL=length(STrials.DelayLeftALMInhibition_RightTrialNum);
DelayRightALMInhibition_LeftTrialL=length(STrials.DelayRightALMInhibition_LeftTrialNum);
DelayRightALMInhibition_RightTrialL=length(STrials.DelayRightALMInhibition_RightTrialNum);
DelayLeftALMInhibition_LeftTrial_CL=length(STrials.DelayLeftALMInhibition_LeftTrial_CNum);
DelayLeftALMInhibition_RightTrial_CL=length(STrials.DelayLeftALMInhibition_RightTrial_CNum);
DelayRightALMInhibition_LeftTrial_CL=length(STrials.DelayRightALMInhibition_LeftTrial_CNum);
DelayRightALMInhibition_RightTrial_CL=length(STrials.DelayRightALMInhibition_RightTrial_CNum);
DelayLeftALMInhibition_LeftTrial_EL=length(STrials.DelayLeftALMInhibition_LeftTrial_ENum);
DelayLeftALMInhibition_RightTrial_EL=length(STrials.DelayLeftALMInhibition_RightTrial_ENum);
DelayRightALMInhibition_LeftTrial_EL=length(STrials.DelayRightALMInhibition_LeftTrial_ENum);
DelayRightALMInhibition_RightTrial_EL=length(STrials.DelayRightALMInhibition_RightTrial_ENum);


SampleLeftALMInhibition_LeftTrialL=length(STrials.SampleLeftALMInhibition_LeftTrialNum);
SampleLeftALMInhibition_RightTrialL=length(STrials.SampleLeftALMInhibition_RightTrialNum);
SampleRightALMInhibition_LeftTrialL=length(STrials.SampleRightALMInhibition_LeftTrialNum);
SampleRightALMInhibition_RightTrialL=length(STrials.SampleRightALMInhibition_RightTrialNum);
SampleLeftALMInhibition_LeftTrial_CL=length(STrials.SampleLeftALMInhibition_LeftTrial_CNum);
SampleLeftALMInhibition_RightTrial_CL=length(STrials.SampleLeftALMInhibition_RightTrial_CNum);
SampleRightALMInhibition_LeftTrial_CL=length(STrials.SampleRightALMInhibition_LeftTrial_CNum);
SampleRightALMInhibition_RightTrial_CL=length(STrials.SampleRightALMInhibition_RightTrial_CNum);
SampleLeftALMInhibition_LeftTrial_EL=length(STrials.SampleLeftALMInhibition_LeftTrial_ENum);
SampleLeftALMInhibition_RightTrial_EL=length(STrials.SampleLeftALMInhibition_RightTrial_ENum);
SampleRightALMInhibition_LeftTrial_EL=length(STrials.SampleRightALMInhibition_LeftTrial_ENum);
SampleRightALMInhibition_RightTrial_EL=length(STrials.SampleRightALMInhibition_RightTrial_ENum);
%%display length of each trial type
%normal trials
Display=0;
if Display==1
    display(['CorretAll:',num2str(CorretAllL)])
    display(['ErrorAll:',num2str(ErrorAllL)])
    display(['NoResponseAll:',num2str(NoResponseAllL)])
    display(['CorrectLeft:',num2str(CorrectLeftL)])
    display(['ErrorLeft:',num2str(ErrorLeftL)])
    display(['NoResponseLeft:',num2str(NoResponseLeftL)])
    display(['CorrectRight:',num2str(CorrectRightL)])
    display(['ErrorRight:',num2str(ErrorRightL)])
    display(['NoResponseRight:',num2str(NoResponseRightL)])
    %unexpected reward and reward omission trials
    display(['UnexpectedRewardAll:',num2str(UnexpectedRewardAllL)])
    display(['RewardOmissionAll:',num2str(RewardOmissionAllL)])
    display(['UnexpectedRewardLeft:',num2str(UnexpectedRewardLeftL)])
    display(['RewardOmissionLeft:',num2str(RewardOmissionLeftL)])
    display(['UnexpectedRewardRight:',num2str(UnexpectedRewardRightL)])
    display(['RewardOmissionRight:',num2str(RewardOmissionRightL)])
    display(['RewardOmissionRightError:',num2str(RewardOmissionRightErrorL)])
    display(['RewardOmissionRightCorrect:',num2str(RewardOmissionRightCorrectL)])
    display(['RewardOmissionLeftError:',num2str(RewardOmissionLeftErrorL)])
    display(['RewardOmissionLeftCorrect:',num2str(RewardOmissionLeftCorrectL)])
    %photostimulation trials)
    display(['PhotoStimLeftAll:',num2str(PhotoStimLeftAllL)])
    display(['PhotoStimRightAll:',num2str(PhotoStimRightAllL)])
    display(['PhotoStimCorrectLeft:',num2str(PhotoStimCorrectLeftL)])
    display(['PhotoStimErrorLeft:',num2str(PhotoStimErrorLeftL)])
    display(['PhotoStimNoresponseLeft:',num2str(PhotoStimNoresponseLeftL)])
    display(['PhotoStimCorrectRight:',num2str(PhotoStimCorrectRightL)])
    display(['PhotoStimErrorRight:',num2str(PhotoStimErrorRightL)])
    display(['PhotoStimNoresponseRight:',num2str(PhotoStimNoresponseRightL)])
end
