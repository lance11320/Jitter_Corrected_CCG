% xlimS=-0.2;xlimB=3.2;
CellsPlot=[];
for u=1:length(UnitsAll)
       unit=UnitsAll{u};
       if isfield(unit, 'BadUnit') % manually set it to 0 (TimePeriodToAnalyze)
           if unit.BadUnit==1
               CellsPlot(u)=0;
               continue
           end
       end
%        if isfield(unit, 'TrialLengthSatisfied') % the correct normal trial length is smaller than a value
%            if unit.TrialLengthSatisfied==0
%                CellsPlot(u)=0;
%                continue;
%            end
%        end
       
       if ~any(unit.cell_type==CellType) 
           CellsPlot(u)=0;
           continue;
       end
       
       
       if AuditoryWhiskerSelective~=0
           continuetag=0;
           AuditoryWhiskerChoseSelectiveNeurons;
%            continuetag
           if continuetag==1
               continue;
           end
       
       else
           if any(SelectiveDelayOnly) 
               if SelectiveDelayOnly==4
                   if abs(unit.SelectiveDelayW)==1
                        CellsPlot(u)=0;
                        continue;     
                   end
               elseif ~any(unit.SelectiveDelayW==SelectiveDelayOnly)
                   CellsPlot(u)=0;
                   continue;
               end
           end
           if any(SelectiveSampleOnly)
               if SelectiveSampleOnly==4
                   if abs(unit.SelectiveSampleW)==1
                       CellsPlot(u)=0;
                       continue;
                   end
               elseif ~any(unit.SelectiveSampleW==SelectiveSampleOnly)
                   CellsPlot(u)=0;
                   continue;
               end
           end
           if any(SelectiveResponseOnly)

               if SelectiveResponseOnly==4
                   if abs(unit.SelectiveResponseW)==1
                       CellsPlot(u)=0;
                       continue;
                   end
               elseif ~any(unit.SelectiveResponseW==SelectiveResponseOnly)
                   CellsPlot(u)=0;
                   continue;
               end
           end
       end
       
       
       
       if length(unit.trials)<SpikesLength
           CellsPlot(u)=0;
           continue
       end

       
       
       
%        if exist('YPSTH')
%            TLength=0;
%            for s=1:length(plotString)
%                 if plotMatrix(s)==1 
%                     try
%                         if YPSTH.TrialsAll{s}(u)<MinTrialLength
%                             TLength=[TLength 1];
%                         end
%                     catch
%                     end
%                 end
%            end
%            if any(TLength)
%                CellsPlot(u)=0;
%                continue;
%            end
%        end
       
       
%        if exist('UnitsRecordingLocationName')
%            if ~isempty(UnitsRecordingLocationName)
%                if isfield(unit,'RecordingSiteName')
% %                    if strcmp(unit.RecordingSiteName,UnitsRecordingLocationName)
%                    if (strcmp(unit.RecordingSiteName,'Substantia nigra, reticular part') | strcmp(unit.RecordingSiteName,'Substantia nigra, reticular part,'))
% %                    if     strcmp(unit.RecordingSiteName, 'Substantia nigra, compact part,') | strcmp(unit.RecordingSiteName, 'Substantia nigra, compact part')
% %                    if strcmp(unit.RecordingSiteName,  'Midbrain')         
%                     % if (strcmp(unit.RecordingSiteName,'Subthalamic nucleus,') ) 
%                         
%                    else
%                        CellsPlot(u)=0;
%                        continue;
%                    end
%                else
%                     CellsPlot(u)=0;
%                     continue;
%                end
%            end
%        end
       
       
       if exist('DepthRange')
           if isfield(unit,'RecordingDepthY')
                if unit.RecordingDepthY<DepthRange(2) & unit.RecordingDepthY>DepthRange(1)
                 
                else
                    CellsPlot(u)=0;
                    continue;
                end
           else
               CellsPlot(u)=0;
               continue;
           end
       end

       if exist('ChoseAccordingLocations')
           if ChoseAccordingLocations==1
               if isfield(unit,'RecordingSite')
                   CuLocation=fix(unit.RecordingSite);
                   CuLocation(2)=456-CuLocation(2)+1;
%                    CuLocation
                   in = inpolygon(CuLocation(1),CuLocation(2),Loops{CuLocation(3)}(:,1),Loops{CuLocation(3)}(:,2)) ;
                   if in==1
                   else
                       continue;
                   end
               end
               
           end
       end
       
       
       CellsPlot(u)=1;

end



a=strcmp(ClusterGroupA.group,'good') & strcmp(Cluster_KSLabelA.KSLabel,'good') &  MetricsA.firing_rate>1 & MetricsA.presence_ratio>0.8 & MetricsA.isi_viol<0.5  & MetricsA.amplitude_cutoff<0.1 & MetricsA.amplitude>0;

CellsPlot=CellsPlot & a';

% CellsPlot(1068)=0;
% CellsPlot(4477)=0;
% CellsPlot(4461)=0;

% CT=TroughToPeak>0.4;
% % CT=TroughToPeak<0.3;
% CellsPlot=CellsPlot & CT;

% CT=MetricsA.duration<0.3;%inhibitory neurons
% 
CT=MetricsA.duration>0.3 & MetricsA.duration<0.6;%excitatory neurons
CellsPlot=CellsPlot & CT';

% only contain one animal, in ALM, reversed contingency
% AnimalS=[1 ]; % only contain these animals
% SessS={ [1 2 3 4 6 ] }; % SessS={[1 2 3 4 6], [1 2 3 4 6 8], [1 2 3 4 5] };
% ContainTag=FindIn(SessionsTag,AnimalS,SessS);
% CellsPlot=CellsPlot & ContainTag';


% only contain one animal, in VM
% AnimalS=[1 2 4 5 6]; % only contain these animals
% SessS={[1 2 3 4 5 7],[1 2 3 4],[1],[6], [ 3 4 5 6 7 8 9]};
% ContainTag=FindIn(SessionsTag,AnimalS,SessS);
% CellsPlot=CellsPlot & ContainTag';
% 

% 
% % only contain one animal, in VM/VAL
% AnimalS=[1 2 4 5 6]; % only contain these animals
% SessS={[1 2 3 4 5 7],[1 2 3 4],[1],[1 2 3 4 5 6], [ 2 3 4 5 6 7 8 9]};
% ContainTag=FindIn(SessionsTag,AnimalS,SessS);
% CellsPlot=CellsPlot & ContainTag';
% 


% for whisker auditory task,left ALM, 20190920
% AnimalS=[1 2 3]; % only contain these animals
% SessS={[1 2 3 4 5 6],[2 3],[7 8]};
% ContainTag=FindIn(SessionsTag,AnimalS,SessS);
% CellsPlot=CellsPlot & ContainTag';

% for whisker auditory task,right ALM, 20190920
% AnimalS=[ 2 3]; % only contain these animals
% SessS={[5 6 7 8 9],[1 3 4 5]};
% ContainTag=FindIn(SessionsTag,AnimalS,SessS);
% CellsPlot=CellsPlot & ContainTag';


% % 
% 

% CellsPlot=ones(1,43);
Cells=find(CellsPlot);
length(Cells)


