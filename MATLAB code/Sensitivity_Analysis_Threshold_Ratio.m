%Sensitivity Analysis Code - Using Base Model

%import data
Output = readmatrix('base-model Sensitivity Analysis Experiment Varying Ratio-spreadsheet.csv');

%extract data for Collins:
%CD is crowding 
Collins_CD=Output(5,2:5:end);
%transpose the matrix
transposed_Collins_CD=(Collins_CD)'
%create a vector with each trial as a vector value
Collins_CD_v=reshape(transposed_Collins_CD, [10,11]);

%extract data for Food Trucks:
Food_trucks_CD=Output(5,3:5:end);
transposed_food_trucks_CD=(Food_trucks_CD)'
%create a vector with each trial as a vector value
Food_trucks_CD_v=reshape(transposed_food_trucks_CD, [10,11]);

%Create the Ratio values: needs to be 10
Ratios=Output(2,2:50:end)
Transposed_Ratios = (Ratios)'
Ten_ones=ones(11,10)
Real_Transposed_Ratios = times(Transposed_Ratios,Ten_ones)

% %boxplot for Collins-crowding duration 
% figure
% boxplot(transposed_Collins_CD,Real_Ratios_v)
% hold on
% xlabel('Ratio of Food Truck''s Threshold to Collins'' Threshold')
% ylabel('Duration of Crowding (Ticks)')
% title("Sensitivity Analysis-Duration of Crowding at Collins (Base Model)")
% 
% %boxplot for Food Trucks-crowding duration
% figure
% boxplot(transposed_food_trucks_CD,Real_Ratios_v)
% hold on
% xlabel('Ratio of Food Truck''s Threshold to Collins'' Threshold')
% ylabel('Duration of Crowding (Ticks)')
% title("Sensitivity Analysis-Duration of Crowding at Food Truck (Base Model)")
% 
% %Mean grap plot: 

%mean Collins:
%Collins Number of students 
mean_Collins_CD_v=mean(Collins_CD_v) 
mean_food_trucks_CD_v=mean(Food_trucks_CD_v)

figure
h1 = plot(Real_Transposed_Ratios,mean_Collins_CD_v,'color','#A2142F','LineWidth',1)
hold on

h2 = plot(Real_Transposed_Ratios,mean_food_trucks_CD_v,'color','#77AC30','LineWidth',1)
x1=xline(0.54,'--');
x2=xline(0.64,'--');
x3=xline(0.59,'-');
xlabel('Ratio of Food Truck''s Threshold to Collins'' Threshold')
ylabel('Duration of Crowding (Ticks)')
title('Ratio Sensitivity Analysis-Duration of Crowding (Base Model)')
legend([h1(1), h2(1), x1(1), x2(1), x3(1)], 'Collins', ' Food Trucks', '0.54', '0.64','0.59 (Our Value)')




