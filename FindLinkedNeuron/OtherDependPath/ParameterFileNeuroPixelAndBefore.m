%%%  Parameter file, for Process_Recordings_NeuroPixelProbe.m  %%%
%%% 2020/9/28 yinxin %%%

RecordingRig='Left'; 
ProjectTag='S';
SessionsA={{{}}};
Behavior={{{}}};
RunName='myRun';
Purpose='';

if ProjectTag=='S'
    ProjectFolderO='E:\results\SortResultsMJH';
    ProjectFolder1='';
    ProjectFolder2='';
    ProjectFolder3='';
    ProjectFolder4='';
    ProjectFolders={''};
    
elseif ProjectTag=='D'
    ProjectFolder='\\DISKSATION\Data\DopamineRelated\';
else
    DISP(['Unrecognized Project. Please confirm the project folder.']);
    return
end

% folder path
EphyFolder={};
ResultsFolder={};
BehaviorFolder={};
for i=1:length(Animals)
    AnimalNameFolderTmp=dir([ProjectFolderO,'\',Animals{i},'_*']);
    ProjectFolder=ProjectFolderO;
   
    if isempty(AnimalNameFolderTmp)
        AnimalNameFolderTmp=dir([ProjectFolder1,'\',Animals{i},'_*']);
        ProjectFolder=ProjectFolder1;
    else
        AnimalName=AnimalNameFolderTmp.name;
    end
    if isempty(AnimalNameFolderTmp)
        try
            AnimalNameFolderTmp=dir([ProjectFolder2,'\',Animals{i},'_*']);
            %         AnimalNameFolderTmp=dir([ProjectFolder1,'\',Animals{i}]);
            ProjectFolder=ProjectFolder2;
            AnimalName=AnimalNameFolderTmp.name;
        catch
        end
%         AnimalName=Animals{i};
    end
    if isempty(AnimalNameFolderTmp)
        try
            AnimalNameFolderTmp=dir([ProjectFolder2,'\',Animals{i},'_*']);
            ProjectFolder=ProjectFolder2;
            AnimalName=AnimalNameFolderTmp.name;
        catch
        end
    end
    if isempty(AnimalNameFolderTmp)
        AnimalNameFolderTmp=dir([ProjectFolder3,'\',Animals{i},'_*']);
        ProjectFolder=ProjectFolder3;
    end
    
    if isempty(AnimalNameFolderTmp)
        clear AnimalNameFolderTmp
        AnimalNameFolderTmp.name=Animals{i};
        ProjectFolder=ProjectFolder4;
    end

%     AnimalName=AnimalNameFolderTmp.name;
%     if ~isempty(AnimalNameFolderTmp)
%         ProjectFolder=ProjectFolder1;
%         AnimalName=Animals{i};
%     else
%         if length(AnimalNameFolderTmp)>1
%             error(['Found Repeat Animal Name! Please Check The Project Folder: ',ProjectFolderO])
%         end
%         AnimalName=AnimalNameFolderTmp.name;
%     end
AnimalName=AnimalNameFolderTmp.name;
    EphyFolder{i}=[ProjectFolder,'\',AnimalName,'\Ephy\'];
    ResultsFolder{i}=[EphyFolder{i},'Results\'];
    BehaviorFolder{i}=[ProjectFolder,'\',AnimalName,'\Ephy\Behavior\'];
    SessionNameTmp=dir([EphyFolder{i},'*_*']); % suppose that all of the names of session folder start with 20
    for j=1:length(SessionNameTmp)
        SessionsA{i}{j}=[EphyFolder{i},SessionNameTmp(j).name,'\OutPut\'];
    end
    BehaviorNameTmp=dir([BehaviorFolder{i},'*mat']);
    for j=1:length(BehaviorNameTmp)
        Behavior{i}{j}=[BehaviorFolder{i},BehaviorNameTmp(j).name];
    end
end


ana.project=ProjectTag;
ana.purpose=Purpose;
ana.Animals=Animals;
ana.path.EphyFolder=EphyFolder;
ana.path.BehaviorFolder=BehaviorFolder;
ana.path.Sessions=SessionsA;
ana.path.Behavior=Behavior;
ana.path.ResultsFolder=ResultsFolder;
ana.RunName='myRun';


