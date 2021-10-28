%loading file
Gates{Ani}(Sess) = 0;
if NowAnalysing == 1
    Probes{Ani}{Sess} = 1;
    %Probes={{1,1,1,1,1,1,1}, {1,1,1,1,1,1} ,{1,1,1,1,1,1},{1,1,1,1,1},{1,1,1},{1,1,1},{1,1,1}};%0 left 1 right
else
    Probes{Ani}{Sess} = 0;
    %Probes={{0,0,0,0,0,0,0},{0,0,0,0,0,0},{0,0,0,0,0,0},{0,0,0,0},{0,0,0},{0,0,0,0}};
end

[~,base]=fileparts(ana.path.Sessions{Ani}{Sess});
[pathstr,SessionName,ext]=fileparts(fileparts(fileparts(ana.path.Sessions{Ani}{Sess})));
FullName=[ana.path.ResultsFolder{Ani}    ana.Animals{Ani} '_' SessionName '_probe_' num2str(Probes{Ani}{Sess}) '_data.mat'];
load(FullName);
CurrentGatePath=[ana.path.Sessions{Ani}{Sess} 'catgt_' ana.RunName '_g' num2str(Gates{Ani}(Sess))];
CurrentProbeFold=[CurrentGatePath '\' ana.RunName '_g' num2str(Gates{Ani}(Sess)) '_imec' num2str(Probes{Ani}{Sess})];
KS2Folder=[CurrentProbeFold '\' 'imec' num2str(Probes{Ani}{Sess}) '_ks2'];
MetricF=[KS2Folder '\metrics.csv'];
ClusterGroupF=[KS2Folder '\cluster_group.tsv'];
Cluster_KSLabelF=[KS2Folder '\cluster_KSLabel.tsv'];
% read the quality Metric file
MetricsA = readtable(MetricF);
ClusterGroupA = readtable(ClusterGroupF);
Cluster_KSLabelA = readtable(Cluster_KSLabelF);
Cluster_KSLabelA=Cluster_KSLabelA(ClusterGroupA{:,1}+1,:);