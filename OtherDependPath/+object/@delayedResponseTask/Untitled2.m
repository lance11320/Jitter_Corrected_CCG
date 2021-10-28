

file='\\DISKSATION\Data\DopamineRelated\BehaviorData\EphyRig1\D9\data_@D9_20170327_02.mat';
obj = object.delayedResponseTask(file, trim);
obj.LickingAnalysis


Folder='\\DISKSATION\Data\DopamineRelated\Data\D11_20170530\Ephy\Behavior\';
List=dir([Folder, '*mat'])
for i=1:length(List)
    file=[Folder,List(i).name]
    obj = object.delayedResponseTask(file, trim);
    obj.LickingAnalysis;
    obj.licking.PreLickingRate
end