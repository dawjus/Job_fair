include "alldifferent.mzn";
% Constants

int: room_cost = 200;
int: n_interviews = 3;

set of int: Preference = 1..5;
set of int: Slot = 1..20;

% Parameters

int: n_students;
int: n_companies;
set of int: Student = 1..n_students;
set of int: Company = 1..n_companies;

array[Student, Company] of Preference: preferences;
array[Student] of int: best_expectations;
array[Company] of int: min_capacities;
array[Company] of int: max_capacities;
array[Company] of int: attendance_costs;
array[Company] of int: parallel_limits;
array[Student] of set of Slot: slots;
array[Slot] of var int: total_room_costs;


array[Company] of var int: start_day_company;
array[Company] of var int: end_day_company;
array[Company] of var int: total_attendance_cost;

array [Student,Slot] of var int: help_student_schedule;
array [Company,Slot] of var int: help_company_schedule;

array[Company,1..3] of var int:company_slots;

array[Student,1..3] of var int: student_interview;
array[Student,1..3] of var int: student_time_slots;
array[Student] of var int: student_disappointment_value;



%The actual code:

%%%%%%% Variables %%%%%%%%
array [Student,Slot] of var 0..n_companies: student_schedule; %student_schedule[i][j] is index of company, which interviews student i in slot j
array [Company,Slot] of var 0..n_students: company_schedule; %company_schedule[i][j] is number of students, which company i hunts in slot j

constraint forall(i in 1..n_companies,j in 1..20) (company_schedule[i,j]=sum (g in 1..n_students)(if student_schedule[g,j]==i then 1 else 0 endif));


%%%%%% Student constraints %%%%%%%

%Student has to have time for this
constraint forall (i in 1..n_students,j in 1..20) (j in slots[i] \/ student_schedule[i,j] = 0);


%Each student has to be interviwed at least 3 times
constraint forall (i in 1..n_students) (sum(j in 1..20)(if student_schedule[i,j]!=0 then 1 else 0 endif)=3);

%Student has at most one interview with each company
constraint forall(i in 1..n_students) (alldifferent(j in 1..20 where student_schedule[i,j]!=0)(student_schedule[i,j]));

%array for easier sorting
constraint forall(i in 1..n_students, j in Slot)(help_student_schedule[i,j] = if (student_schedule[i,j]==0) then n_companies+1 else student_schedule[i,j] endif); 

% Table students iterview to print
constraint forall(i in 1..n_students)(student_interview[i,1] = min([ help_student_schedule[i,j] | j in 1..20]));
constraint forall(i in 1..n_students)(student_interview[i,3] = max([ student_schedule[i,j] | j in 1..20]));
constraint forall(i in 1..n_students)(student_interview[i,2] = (sum(j in 1..20)(student_schedule[i,j])-(student_interview[i,1]+student_interview[i,3])));


%Student disappointment
constraint forall (i in 1..n_students)(student_disappointment_value[i] =max(sum(j in 1..20) ( if student_schedule[i,j]!=0 then preferences[i,student_schedule[i,j]] else 0 endif ) - best_expectations[i],0));


%Filling slots for output

constraint forall(i in 1..n_students) (forall (j in 1..20 where student_schedule[i,j]=student_interview[i,1])(student_time_slots[i,1]=j));
constraint forall(i in 1..n_students) (forall (j in 1..20 where student_schedule[i,j]=student_interview[i,2])(student_time_slots[i,2]=j));
constraint forall(i in 1..n_students) (forall (j in 1..20 where student_schedule[i,j]=student_interview[i,3])(student_time_slots[i,3]=j));


%%%%%%% Company constraints %%%%%%%

%Parallelellel limit constraint
constraint forall (i in 1..n_companies,j in 1..20) (company_schedule[i,j]<=parallel_limits[i]);

%Min/max capacity constraints
constraint forall(i in 1..n_companies) (sum(j in 1..20)(company_schedule[i,j])<=max_capacities[i] /\ sum(j in 1..20)(company_schedule[i,j])>=min_capacities[i]);


%TotalCost Constraint
constraint forall(i in Slot) (total_room_costs[i] = sum(j in 1..n_companies) (company_schedule[j,i]));

%TotalAttendence Constraint
constraint forall(i in 1..n_companies) ( start_day_company[i]=
  if (company_schedule[i,4] !=0 \/ company_schedule[i,1] !=0 \/ 
      company_schedule[i,2] !=0 \/ company_schedule[i,3] !=0) 
  then 0
  
  elseif (company_schedule[i,8] !=0 \/ company_schedule[i,5] !=0 \/ 
      company_schedule[i,6] !=0 \/ company_schedule[i,7] !=0)
  then 1
  elseif (company_schedule[i,12] !=0 \/ company_schedule[i,9]!=0 \/ 
  company_schedule[i,10] !=0 \/ company_schedule[i,11] !=0)
  then 2
   
  elseif (company_schedule[i,16] !=0 \/ company_schedule[i,13] !=0 \/ 
      company_schedule[i,14] !=0 \/ company_schedule[i,15] !=0 )
  then 3

  elseif (company_schedule[i,20] !=0 \/ company_schedule[i,17] !=0 \/ 
      company_schedule[i,18] !=0 \/ company_schedule[i,19] !=0 )
  then 4
  
  else -1
  endif);
   

constraint forall(i in 1..n_companies) ( end_day_company[i]=
  if (company_schedule[i,20] !=0 \/ company_schedule[i,17] !=0 \/ 
      company_schedule[i,18] !=0 \/ company_schedule[i,19] !=0 )
  then 5
  
  elseif 
  (company_schedule[i,16] !=0 \/ company_schedule[i,13] !=0 \/ 
      company_schedule[i,14] !=0 \/ company_schedule[i,15] !=0 )
  then 4

  elseif (company_schedule[i,12] !=0 \/ company_schedule[i,9]!=0 \/ 
  company_schedule[i,10] !=0 \/ company_schedule[i,11] !=0)
  then 3
   
  elseif (company_schedule[i,8] !=0 \/ company_schedule[i,5] !=0 \/ 
      company_schedule[i,6] !=0 \/ company_schedule[i,7] !=0)
  then 2
  elseif (company_schedule[i,4] !=0 \/ company_schedule[i,3] !=0 \/ 
      company_schedule[i,1] !=0 \/ company_schedule[i,2] !=0)

  then 1  
  else -1
  endif);


%% Attendance costs companies
constraint forall(i in 1..n_companies)  (total_attendance_cost[i] = (end_day_company[i]-start_day_company[i])*attendance_costs[i]);


constraint forall (i in 1..n_students) (sum (j in 1..n_companies)(if preferences[i,student_interview[i,1]] > preferences[i,j] then 1 else 0 endif) <3
  \/ sum (j in 1..n_companies)(if preferences[i,student_interview[i,2]]>preferences[i,j] then 1 else 0 endif) <3 
  \/ sum (j in 1..n_companies)(if preferences[i,student_interview[i,3]]>preferences[i,j] then 1 else 0 endif) <3);



%solve minimize sum (total_attendance_cost) + max(total_room_costs)*room_cost +sum(student_disappointment_value);
solve satisfy;

output["companies = [" ];
output[show(student_interview[i,j]) ++if j == 3 /\ i==n_students then "" else ", " endif |i in 1..n_students, j in 1..3];
output["];\ntimeslots = ["];
output[show(student_time_slots[i,j]) ++if j == 3 /\ i==n_students then "" else ", " endif |i in 1..n_students, j in 1..3];
output["];\nobjective = "];
output[show(sum (total_attendance_cost) + max(total_room_costs)*room_cost +sum(student_disappointment_value))];
output[";\ntotal_room_cost = "];
output[show(max(total_room_costs)*room_cost)];
output[";\ntotal_attendance_cost = "];
output[show(sum(total_attendance_cost))];
output[";\ntotal_disappointment_value = "];
output[show(sum(student_disappointment_value))++";"];
