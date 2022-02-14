% Measuring How long it's Crowded-Behaviors' Influence 

%Version 1:
V1_Collins_output=readmatrix('version-1 Experiment Collins-spreadsheet');
V1_Collins_num_times_crowded=V1_Collins_output(5,3:3:end);
Mean_V1_Collins_num_times_crowded=mean(V1_Collins_num_times_crowded)

FT_output=readmatrix('version-1 Experiment Food Truck-spreadsheet');
FT_num_times_crowded=FT_output(5,3:3:end);
Mean_V1_FT_num_times_crowded=mean(FT_num_times_crowded)

%import data Version 2:
V2_Collins_ouput=readmatrix('version-2 Experiment Collins-spreadsheet')
V2_Collins_num_times_crowded=V2_Collins_ouput(5,3:3:end);
Mean_V2_Collins_num_times_crowded=mean(V2_Collins_num_times_crowded)

V2_Collins_ouput=readmatrix('version-2 Experiment Food Truck-spreadsheet')
V2_Collins_num_times_crowded=V2_Collins_ouput(5,3:3:end);
Mean_V2_FT_num_times_crowded=mean(V2_Collins_num_times_crowded)


%Import Version 3:
V3_Collins_ouput=readmatrix('version-3 Experiment Collins-spreadsheet')
V3_Collins_num_times_crowded=V3_Collins_ouput(5,3:3:end);
Mean_V3_Collins_num_times_crowded=mean(V3_Collins_num_times_crowded)

V3_FT_ouput=readmatrix('version-3 Experiment Food Truck-spreadsheet')
V3_FT_num_times_crowded=V3_FT_ouput(5,3:3:end);
Mean_V3_FT_num_times_crowded=mean(V3_FT_num_times_crowded)


%Import Base Model:
BM_Collins_ouput=readmatrix('base-model Experiment - Collins-spreadsheet.csv')
BM_Collins_num_times_crowded=BM_Collins_ouput(5,3:3:end);
Mean_BM_Collins_num_times_crowded=mean(BM_Collins_num_times_crowded)

BM_FT_ouput=readmatrix('base-model Experiment - Food Truck-spreadsheet.csv')
BM_FT_num_times_crowded=BM_FT_ouput(5,3:3:end);
Mean_BM_FT_num_times_crowded=mean(BM_FT_num_times_crowded)

figure
name = {'Version 1';'Version 2';'Version 3';'Base'};
y=[Mean_V1_Collins_num_times_crowded Mean_V1_FT_num_times_crowded; 
    Mean_V2_Collins_num_times_crowded Mean_V2_FT_num_times_crowded;
    Mean_V3_Collins_num_times_crowded Mean_V3_FT_num_times_crowded;
    Mean_BM_Collins_num_times_crowded Mean_BM_FT_num_times_crowded]

Food_Sources={'Collins','Food Truck'}
hb=bar(y)
hold on
hb(1).FaceColor = '#A2142F';
hb(2).FaceColor = '#77AC30';
set(gca,'xticklabel',name)
title('Duration of Crowding-Behavior Models')
xlabel('Models')
ylabel('Ticks')
legend(Food_Sources)
%Control Measures: 

%Import Base Model:
BM_Collins_ouput=readmatrix('base-model Experiment - Collins-spreadsheet.csv')
BM_Collins_num_times_crowded=BM_Collins_ouput(5,3:3:end);
Mean_BM_Collins_num_times_crowded=mean(BM_Collins_num_times_crowded)

BM_FT_ouput=readmatrix('base-model Experiment - Food Truck-spreadsheet.csv')
BM_FT_num_times_crowded=BM_FT_ouput(5,3:3:end);
Mean_BM_FT_num_times_crowded=mean(BM_FT_num_times_crowded)

%Import New Food:
NF_Collins_ouput=readmatrix('foodtrucks-controlmeasure Experiment Collins-spreadsheet')
NF_Collins_num_times_crowded=NF_Collins_ouput(5,3:3:end);
Mean_NF_Collins_num_times_crowded=mean(NF_Collins_num_times_crowded)

NF_FT_ouput=readmatrix('foodtrucks-controlmeasure Experiment Food Truck-spreadsheet')
NF_FT_num_times_crowded=NF_FT_ouput(5,3:3:end);
Mean_NF_FT_num_times_crowded=mean(NF_FT_num_times_crowded)

%New Food numbers:
NF_NF_ouput=readmatrix('foodtrucks-controlmeasure Experiment New Food Source-spreadsheet.csv')
NF_NF_num_times_crowded=NF_FT_ouput(5,3:3:end);
Mean_NF_NF_num_times_crowded=mean(NF_NF_num_times_crowded)
% 
figure
name = {'New Food Model-New Food Source'};
y=[Mean_NF_NF_num_times_crowded]
hb=bar(y)
hold on
hb(1).FaceColor = '#7E2F8E';
set(gca,'xticklabel',name)
title('Duration of Crowding-New Food Source Model')
ylabel('Ticks')

%Import Duration of Eat:
DE_Collins_ouput=readmatrix('eating-duration-controlmeasure Experiments Collins-spreadsheet')
DE_Collins_num_times_crowded=DE_Collins_ouput(5,3:3:end);
Mean_DE_Collins_num_times_crowded=mean(DE_Collins_num_times_crowded)

DE_FT_ouput=readmatrix('eating-duration-controlmeasure Experiments Food Truck-spreadsheet')
DE_FT_num_times_crowded=DE_FT_ouput(5,3:3:end);
Mean_DE_FT_num_times_crowded=mean(DE_FT_num_times_crowded)

%All-Control Measures + Base Model:
figure
name = {'Base';'New Food';'Eating Duration'};
y=[Mean_BM_Collins_num_times_crowded Mean_BM_FT_num_times_crowded; 
    Mean_NF_Collins_num_times_crowded Mean_NF_FT_num_times_crowded;
    Mean_DE_Collins_num_times_crowded Mean_DE_FT_num_times_crowded;
    ]
Food_Sources={'Collins','Food Truck'}
hb=bar(y)
hold on
hb(1).FaceColor = '#A2142F';
hb(2).FaceColor = '#77AC30';
set(gca,'xticklabel',name)
title('Duration of Crowding-Control Measures')
xlabel('Models')
ylabel('Ticks')
legend(Food_Sources)