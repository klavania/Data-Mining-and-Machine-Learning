create database DMML;
use DMML;

create table std_ifo(
id INT,
code_module nvarchar(50),
code_prsnt nvarchar(50),
id_std nvarchar(50),
gender nvarchar(50),
imd_band nvarchar(50),
highest_education nvarchar(50),
age_band nvarchar(50),
num_of_prev_attempts nvarchar(50),
stdied_credits nvarchar(50),
region nvarchar(50),
disability nvarchar(50),
final_result nvarchar(50)	 
);
select * from stdifo; --32593 --total stds enrolled
select distinct id_std from std_ifo --28785
select distinct id_std from New_stdifo

insert into std_ifo
SELECT * FROM stdifo
WHERE id IN
(SELECT MIN(id) FROM stdifo GROUP BY id_std) --to have unique stds

select * from std_ifo ---28785
Select * from std_ifo where code_prsnt = '2014J'; --11260
Select * from std_ifo where code_prsnt = '2014B'; --7804
Select * from std_ifo where code_prsnt = '2013J';	--8845
Select * from std_ifo where code_prsnt = '2013B'; --4684

select distinct * from std_ifo;

Select distinct id_std from std_ifo where code_prsnt = '2014J'; --11260

--std ifo 28785--

select * from stdrgstr
select distinct id_std from stdrgstr

CREATE TABLE std_rgstr(
id INT IDENTITY (1,1),
code_module nvarchar(50),
code_prsnt nvarchar(50),
id_std nvarchar(50),
date_rgstr INT,
date_unrgstr INT
);

insert into std_rgstr
select * from stdrgstr

drop table stdrgstr



insert into FinalstdTable
select a.code_module, 
a.code_prsnt,
a.id_std,
a.gender,
a.imd_band,
a.highest_education,
a.age_band,
a.num_of_prev_attempts,
a.stdied_credits,
a.region,
a.disability,
a.final_result,
a.date_rgstr,
a.date_unrgstr,
a.sum_click,
a.id_assessment,
a.date_submitted,
a.is_banked,
a.score,
a.assessment_type,
a.date,
a.weight,
b.module_prsnt_length
from joiniifo4 a
LEFT JOIN courses b
ON a.code_module=b.code_module
AND a.code_prsnt=b.code_prsnt

select * from FinalstdTable -- 173912

select distinct id_std from FinalstdTable				--11763
where code_module = 'BBB'
AND code_prsnt = '2013B'
AND assessment_type = 'TMA'

select distinct id_std from FinalstdTable
where code_module = 'BBB'
AND code_prsnt = '2013B'




insert into joiniifo1
select a.code_module, 
a.code_prsnt,
a.id_std,
a.gender,
a.imd_band,
a.highest_education,
a.age_band,
a.num_of_prev_attempts,
a.stdied_credits,
a.region,
a.disability,
a.final_result,
b.date_rgstr,
b.date_unrgstr
FROM std_ifo a
JOIN stdrgstr b
ON a.id_std=b.id_std



create table joiniclick
(
id_std nvarchar(50),
sum_click int
)


create table joinifo2(
code_module nvarchar(50),
code_prsnt nvarchar(50),
id_std nvarchar(50),
gender nvarchar(50),
imd_band nvarchar(50),
highest_education nvarchar(50),
age_band nvarchar(50),
num_of_prev_attempts nvarchar(50),
stdied_credits nvarchar(50),
region nvarchar(50),
disability nvarchar(50),
final_result nvarchar(50),
date_rgstr INT,
date_unrgstr INT,
sum_click INT
)

insert into joinifo2
select a.code_module, 
a.code_prsnt,
a.id_std,
a.gender,
a.imd_band,
a.highest_education,
a.age_band,
a.num_of_prev_attempts,
a.stdied_credits,
a.region,
a.disability,
a.final_result,
a.date_rgstr,
a.date_unrgstr,
b.sum_click
FROM joiniifo1 a
LEFT JOIN joiniclick b
ON a.id_std=b.id_std



select * from joinifo2 --28785

select * from stdAssessment --173912 apply right join
insert into joiniifo3
select a.code_module, 
a.code_prsnt,
a.id_std,
a.gender,
a.imd_band,
a.highest_education,
a.age_band,
a.num_of_prev_attempts,
a.stdied_credits,
a.region,
a.disability,
a.final_result,
a.date_rgstr,
a.date_unrgstr,
a.sum_click,
b.id_assessment,
b.date_submitted,
b.is_banked,
b.score
FROM joinifo2 a
RIGHT JOIN stdAssessment b
ON a.id_std=b.id_std

create table joiniifo3
(
code_module nvarchar(50),
code_prsnt nvarchar(50),
id_std nvarchar(50),
gender nvarchar(50),
imd_band nvarchar(50),
highest_education nvarchar(50),
age_band nvarchar(50),
num_of_prev_attempts nvarchar(50),
stdied_credits nvarchar(50),
region nvarchar(50),
disability nvarchar(50),
final_result nvarchar(50),
date_rgstr INT,
date_unrgstr INT,
sum_click INT,
id_assessment nvarchar(50),
date_submitted nvarchar(50),
is_banked nvarchar(50),
score nvarchar(50)
)


select count(*) from joiniifo3 --173912

select * from assessments

create table joiniifo4(
code_module nvarchar(50),
code_prsnt nvarchar(50),
id_std nvarchar(50),
gender nvarchar(50),
imd_band nvarchar(50),
highest_education nvarchar(50),
age_band nvarchar(50),
num_of_prev_attempts nvarchar(50),
stdied_credits nvarchar(50),
region nvarchar(50),
disability nvarchar(50),
final_result nvarchar(50),
date_rgstr INT,
date_unrgstr INT,
sum_click INT,
id_assessment nvarchar(50),
date_submitted nvarchar(50),
is_banked nvarchar(50),
score nvarchar(50),
assessment_type nvarchar(50),
date nvarchar(50),
weight nvarchar(50)
)

insert into joiniifo4
select a.code_module, 
a.code_prsnt,
a.id_std,
a.gender,
a.imd_band,
a.highest_education,
a.age_band,
a.num_of_prev_attempts,
a.stdied_credits,
a.region,
a.disability,
a.final_result,
a.date_rgstr,
a.date_unrgstr,
a.sum_click,
a.id_assessment,
a.date_submitted,
a.is_banked,
a.score,
b.assessment_type,
b.date,
b.weight
FROM joiniifo3 a
LEFT JOIN assessments b
ON a.id_assessment=b.id_assessment


select * from joiniifo4 -- 173912

select * from courses --22

create table FinalstdTable(
code_module nvarchar(50),
code_prsnt nvarchar(50),
id_std nvarchar(50),
gender nvarchar(50),
imd_band nvarchar(50),
highest_education nvarchar(50),
age_band nvarchar(50),
num_of_prev_attempts nvarchar(50),
stdied_credits nvarchar(50),
region nvarchar(50),
disability nvarchar(50),
final_result nvarchar(50),
date_rgstr INT,
date_unrgstr INT,
sum_click INT,
id_assessment nvarchar(50),
date_submitted nvarchar(50),
is_banked nvarchar(50),
score nvarchar(50),
assessment_type nvarchar(50),
date nvarchar(50),
weight nvarchar(50),
module_prsnt_length nvarchar(50)
)





create table stdTable_CCC2014B(
code_module nvarchar(50),
code_prsnt nvarchar(50),
id_std nvarchar(50),
gender nvarchar(50),
imd_band nvarchar(50),
highest_education nvarchar(50),
age_band nvarchar(50),
num_of_prev_attempts nvarchar(50),
stdied_credits nvarchar(50),
region nvarchar(50),
disability nvarchar(50),
final_result nvarchar(50),
date_rgstr INT,
date_unrgstr INT,
sum_click INT,
id_assessment nvarchar(50),
date_submitted nvarchar(50),
is_banked nvarchar(50),
score nvarchar(50),
assessment_type nvarchar(50),
date nvarchar(50),
weight nvarchar(50),
module_prsnt_length nvarchar(50)
)




select distinct sub.id_std from (
select * from FinalstdTable where code_module='CCC' AND code_prsnt = '2014B' and assessment_type = 'Exam' 
) sub

select * from stdsCCC


select distinct sub.id_std from (
select * from FinalstdTable where assessment_type = 'TMA' 
) sub

drop table stdsTMA
drop table stdTable_CCC2014B

create table stdsCCC(
code_module nvarchar(50),
code_prsnt nvarchar(50),
id_std nvarchar(50),
gender nvarchar(50),
region nvarchar(50),
highest_education nvarchar(50),
imd_band nvarchar(50),
age_band nvarchar(50),
num_of_prev_attempts nvarchar(50),
stdied_credits nvarchar(50),
disability nvarchar(50),
final_result nvarchar(50),
date_rgstr INT,
date_unrgstr INT,
sum_click INT,
id_assessment nvarchar(50),
date_submitted nvarchar(50),
is_banked nvarchar(50),
score nvarchar(50),
assessment_type nvarchar(50),
date nvarchar(50),
weight nvarchar(50),
module_prsnt_length nvarchar(50)
)

insert into stdsCCC
select * from FinalstdTable
where code_module='CCC' AND code_prsnt = '2014B' and assessment_type = 'Exam' 

insert into stdsTMA
select * from FinalstdTable where assessment_type = 'TMA' 


select * from stdsTMA --98426

select * from FinalstdTable

select distinct sub.id_std from (
select * from FinalstdTable where code_module='CCC' AND code_prsnt = '2014B' and assessment_type = 'Exam' 
) sub

create table stdBBB(
code_module nvarchar(50),
code_prsnt nvarchar(50),
id_std nvarchar(50),
gender nvarchar(50),
region nvarchar(50),
highest_education nvarchar(50),
imd_band nvarchar(50),
age_band nvarchar(50),
num_of_prev_attempts nvarchar(50),
stdied_credits nvarchar(50),
disability nvarchar(50),
final_result nvarchar(50),
date_rgstr INT,
date_unrgstr INT,
sum_click INT,
id_assessment nvarchar(50),
date_submitted nvarchar(50),
is_banked nvarchar(50),
score nvarchar(50),
assessment_type nvarchar(50),
date nvarchar(50),
weight nvarchar(50),
module_prsnt_length nvarchar(50)
)

insert into stdBBB
select * from FinalstdTable				--11763 --distinct id_std
where --code_module = 'EEE' --AND
-- code_prsnt = '2014J'AND
  assessment_type = 'CMA' 

select * from stdBBB --6502
select * from FinalstdTable

select  distinct id_std from FinalstdTable

select distinct id_std from stdBBB


CREATE TABLE stdrgstr(
id INT,
code_module nvarchar(50),
code_prsnt nvarchar(50),
id_std nvarchar(50),
date_rgstr INT,
date_unrgstr INT
);

insert into stdrgstr
SELECT * FROM std_rgstr
WHERE id IN
(SELECT MIN(id) FROM std_rgstr GROUP BY id_std)


select * from std_rgstr --32593
select * from stdrgstr --28785


create table joiniifo1(
code_module nvarchar(50),
code_prsnt nvarchar(50),
id_std nvarchar(50),
gender nvarchar(50),
imd_band nvarchar(50),
highest_education nvarchar(50),
age_band nvarchar(50),
num_of_prev_attempts nvarchar(50),
stdied_credits nvarchar(50),
region nvarchar(50),
disability nvarchar(50),
final_result nvarchar(50),
date_rgstr INT,
date_unrgstr INT
)


select count(*) from joiniifo1; --28785

select * from stdVle --10655280

ALTER TABLE stdVle
ALTER COLUMN sum_click int;

insert into joiniclick --26074
select 
id_std,
sum(sum_click) as sum_click
from stdVle
group by id_std

truncate table stdBBB