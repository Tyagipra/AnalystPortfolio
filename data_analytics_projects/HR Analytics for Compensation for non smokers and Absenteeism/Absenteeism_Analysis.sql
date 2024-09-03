--Create a Join--

Select * from Absenteeism_at_work a
Left Join compensation c
on a.ID=c.ID
Left Join Reasons r
on a.Reason_for_absence=r.number

---Find the healthiest employees for bonus--

Select * from Absenteeism_at_work
where Social_drinker=0 and Social_smoker=0 and Body_mass_index<25
and Absenteeism_time_in_hours< (Select AVG(Absenteeism_time_in_hours) from Absenteeism_at_work)

--Compensation rate increase for non smokers/budget $983,221 so .68 increase per hr/$1414.4 per year

Select Count(*) as Non_Smokers from Absenteeism_at_work
where Social_smoker=0 

--Optimizing the query


Select a.ID,
r.Reason,
Month_of_absence,
Body_mass_index,
Case When Body_mass_index <18.5 Then 'Underweight'
     When Body_mass_index between 18.5 and 25 Then 'Healthy'
	 When Body_mass_index between 25 and 30 Then 'Overweight'
	 When Body_mass_index >30 Then 'Obese'
	 Else 'Unknown' End as BMI_Category,
Case When Month_of_absence IN (12,1,2) Then 'Winter'
	 When Month_of_absence IN (3,4,5) Then 'Spring'
     When Month_of_absence IN (6,7,8) Then 'Summer'
	 When Month_of_absence IN (9,10,11) Then 'Autumn'
	 Else 'Unknown' End as Season_Names,
      Day_of_the_week,
      Transportation_expense,
      Distance_from_Residence_to_Work,
      Service_time,
      Age,
      Work_load_Average_day,
      Hit_target,
      Disciplinary_failure,
      Education,
      Son,
      Social_drinker,
      Social_smoker,
      Pet,
      Absenteeism_time_in_hours
from Absenteeism_at_work a
Left Join compensation c
on a.ID=c.ID
Left Join Reasons r
on a.Reason_for_absence=r.number
