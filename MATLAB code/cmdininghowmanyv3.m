% Measuring When It's Crowded-Behaviors' Influence (V3)
%import data
Collins_output = readmatrix('version-3 Experiment Collins-spreadsheet');
% Collins Number Students at Collins every 5 ticks: 
%thresholds:
FT_threshold=124
C_threshold=210
%NF-threshold=62
%extract data:
Collins_students_base=Collins_output(9:5:end,2:3:31);
%transpose the matrix
transposed_collins_students_base=(Collins_students_base)'
%create a vector with each trial as a vector value
Collins_student_base_v=reshape(transposed_collins_students_base, [1,410]);
%transpose the vector
Final_Collins_student_base_v=(Collins_student_base_v)'

%Food Trucks
%extract data:
Food_Trucks_output = readmatrix('version-3 Experiment Food Truck-spreadsheet');
Food_trucks_students_base=Food_Trucks_output(9:5:end,2:3:31);
%transpose the matrix
transposed_food_trucks_students_base=(Food_trucks_students_base)'
%create a vector with each trial as a vector value
Food_trucks_students_base_v=reshape(transposed_food_trucks_students_base, [1,410]);
%transpose the vector
Final_Food_trucks_student_base_v=(Food_trucks_students_base_v)'

%Ticks
Ticks_number=Collins_output(9:5:end,4:3:end);
%transpose the matrix
Real_output_ticks=(Ticks_number)';
%turn it into a vector
Real_output_ticks_v=Real_output_ticks(:);
%transpose the vector
Final_output_ticks_v= (Real_output_ticks_v)'

%boxplot for Collins number of students 
figure
boxplot(Final_Collins_student_base_v,Final_output_ticks_v)
hold on
y2=yline(210,'--','Collins Threshold', LineWidth=1);
y2.LabelHorizontalAlignment = 'left';
%line(Final_output_ticks_v, C_threshold*ones(size(Final_output_ticks_v)), 'Color','b')
xlabel('Ticks')
ylabel('Students at Collins')
title("Number of Students at Collins Every Five Ticks (Version 3)")

%boxplot for Food Trucks number of students 

figure
boxplot(Final_Food_trucks_student_base_v,Final_output_ticks_v)
hold on
%line(Final_output_ticks_v, FT_threshold*ones(size(Final_output_ticks_v)),'Color','g')
y2=yline(124,'--','Food Truck Threshold',LineWidth=1);
y2.LabelHorizontalAlignment = 'left';
xlabel('Ticks')
ylabel('Students at Food Trucks')
title("Number of Students at Food Trucks Every Five Ticks (Version 3)")
 
%Mean Graphs
%Collins Graphs:

%Collins Number of students 
mean_collins_students_base=mean(transposed_collins_students_base) 
%Get ticks:
mean_graph_ticks=(Ticks_number)'

%Food Truck Graphs:
mean_food_trucks_students_base=mean(transposed_food_trucks_students_base)
% 
%Mean grap plot: Collins and Food Trucks-no thresholds:
figure
hold on
h1 = plot(Ticks_number,mean_collins_students_base,'color','#A2142F','LineWidth',1)
h2 = plot(Ticks_number,mean_food_trucks_students_base,'color','#77AC30','LineWidth',1)
y1=yline(124,'--','Food Truck Threshold',LineWidth=1);
y1.LabelHorizontalAlignment = 'left';
y2=yline(210,'--','Collins Threshold',LineWidth=1);
y2.LabelHorizontalAlignment = 'left';
xlabel('Ticks')
ylabel('Average Students at Food Trucks')
title("Average Number of Students at Each Food Source Every Five Ticks (Version 3)")
legend([h1(1), h2(1)], 'Collins', ' Food Trucks')