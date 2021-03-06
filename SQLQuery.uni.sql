use univercity
--سوال1نام دانشجویانی را بیابید که در نیمسال اول 80 درس پایگاه داده ها را گرفته اند
--روش1
select sname
from student,g,course
where student.st#=g.st# and course.crs#=g.crs# and cname=N'پایگاه داده ها' and term=801

--روش2
select sname
from student
where st# in(
select st#
from g
where term=801 and crs# in(
select crs#
from course 
where cname=N'پایگاه داده ها'
)
)
--روش3
select sname
from student
where exists(
select *
from g,course
where course.crs#=g.crs# and cname=N'پایگاه داده ها' and term=801
)

--2سوالنام دانشجویانی را بیابید که در نیمسال اول 80 درس پایگاه داده ها را نگرفته اند.
--روش1
select sname
from student
where not exists(
select *
from g,course
where course.crs#=g.crs# and cname=N'پایگاه داده ها' and term=801
)
--روش2
select sname
from student
where st# not IN(select st#
from g
where term=801 and crs# in(select crs#
from course
where cname=N'پایگاه داده ها'
)
)
--روش3
select sname	
from student 
where not exists (select *
                  from course 
				  where cname=N'پایگاه داده'
				  and exists(select * 
				             from G
							 where term=801
							 and G.crs#=course.crs#
							 and G.st#=student.st#
							 ))
							 
							 
							 
--سوال3نام دانشجویانی را بیابید که در نیمسال اول 80 هیچ درسی نگرفته اند
--روش1
select sname
from student
where not exists(select *
from g
where term=801 and student.st#=g.st#
)
--روش2
select sname
from student
where st# not in(select st#
from g
where term=801
)

--سوال4لیستی از نام دروس تخصصی رشته مهندسی کامپیوتر تهیه کنید
--روش1
select cname
from course
where crs# in(select crs#
from cf
where kind='t' and field in(select field
from field
where fieldname=N'مهندسي کامپيوتر'
)
)
--روش2
select cname
from course
where exists(
select *
from field
where fieldname=N'مهندسي کامپيوتر'
and exists
(select *
from cf
where kind='t' and field.field=cf.field and course.crs#=cf.crs#
) 
)
--روش3
select cname
from course,cf,field
where course.crs#=cf.crs# and field.field=cf.field and kind='t' and fieldname=N'مهندسي کامپيوتر'
--سوال5تعداد دروس تخصصی رشته مهندسی کامپیوتر را به دست آورید
--روش1
select COUNT(*)
from cf,field
where field.field=cf.field and kind='t' and fieldname=N'مهندسي کامپيوتر'
--روش2
select count(*)
from cf
where kind='t' and  exists(select *
from field
where fieldname=N'مهندسي کامپيوتر' and field.field=cf.field
)
--روش3
select COUNT(*)
from cf
where kind='t' and field in(select field
from field
where fieldname='مهندسي کامپيوتر'
)
--سوال6لیستی از شماره دانشجویان مهندسی کامپیوتر و تعداد کل درسهای تخصصی گذرانده شده توسط هر یک از آنها تهیه کنید
--روش1
select st#,COUNT(g.crs#)
from g,field,cf
where field.field=cf.field 
and cf.crs#=g.crs#
and fieldname='مهندسي کامپيوتر' 
and kind='t'
and grade>=10
group by g.st#
--روش2
select st#,COUNT(st#) 
from g
where grade>=10 and crs# in(select crs#
from cf where kind='t' and field in(select field
from field
where fieldname='مهندسي کامپيوتر'
)
)
group by st#
--روش3
select st#,COUNT(st#)
from g
where grade>=10 and exists(
select *
from field
where fieldname='مهندسي کامپيوتر' and exists(select *
from cf
where kind='t' and cf.field=field.field and cf.crs#=g.crs#
)
)
group by st#
--سوال7شماره دانشجویان مهندسی کامپیوتری را بیابید که کلیه درسهای تخصصی رشته خود را گذرانده اند
--روش1
select st#
from g,field,cf
where g.crs#=cf.crs# and field.field=cf.field
and fieldname='مهندسي کامپيوتر'
and kind='t'
and grade>=10
group by st#
having COUNT(g.crs#)=(select COUNT(*)
from cf,field
where field.field=cf.field
and kind='t' and fieldname='مهندسي کامپيوتر'
)
--روش2
select st#
from g
where grade>=10 and crs# in(select crs#
from cf
where kind='t' and field in(select field 
from field
where fieldname='مهندسي کامپيوتر'
)
)
group by st#
having COUNT(crs#)=(select COUNT(*)
from cf
where kind='t' and field in(select field
from field
where fieldname=N'مهندسي کامپيوتر'
)
)
--روش3
select st#
from g
where grade>=10 and exists(select *
from field
where fieldname=N'مهندسي کامپيوتر' and exists(select *
from cf
where kind='t'
and cf.field=field.field and g.crs#=cf.crs#
)
)
group by st#
having COUNT (crs#)=(select COUNT(*)
from cf
where kind='t' and exists(select *
from field 
where fieldname=N'مهندسي کامپيوتر'
and cf.field=field.field
)
)
--سوال8شماره دانشجویان مهندسی کامپیوتری را بیابید  که کلیه درسهای تخصصی رشته خود را نگذرانده اند
--نکته اینکه اگر با اجتمکاع میان دو سلکت اجرا بگیریم جواب سوال 9 حاصل میشود
--روش1
select st#
from student
where st# not in(select st# 
from g
)and field in(select field
from field where fieldname=N'مهندسي کامپيوتر'
)
union
select st#
from g
where grade>=10 and crs# in(select crs#
from cf
where kind='t' and field in(select field 
from field
where fieldname=N'مهندسي کامپيوتر'
)
)
group by st#
having COUNT(crs#)<>(select COUNT(*)
from cf
where kind='t' and field in(select field
from field
where fieldname=N'مهندسي کامپيوتر'
)
)
--روش2
select st#
from student
where st# not in(select st# 
from g
)and field in(select field
from field where fieldname=N'مهندسي کامپيوتر'
)
union
select st#
from g
where grade>=10 and exists(select *
from field
where fieldname=N'مهندسي کامپيوتر' and exists(select *
from cf
where kind='t'
and cf.field=field.field and g.crs#=cf.crs#
)
)
group by st#
having COUNT (crs#)<>(select COUNT(*)
from cf
where kind='t' and exists(select *
from field 
where fieldname=N'مهندسي کامپيوتر'
and cf.field=field.field
)
)
--سوال9شماره دانشجویان مهندسی کامپیوتری را بیابید که درس نخصصی مربوط به مهندسی کامپیوتر وجود دارد که این دانشجویان آنها را نگذرانده باشد.
--روش1
select st#
from student,field
where 	fieldname=N'مهندسي کامپيوتر'
and student.field=field.field
and  exists( select *
                from cf
				where cf.field=field.field
				and kind='t'
				and not exists(select * 
				               from g
							   where  g.st#=student.st#
							   and g.crs#=cf.crs# 
							   and grade>=10))

--روش2
select st#
from student
where exists(select *
from field
where  student.field=field.field and fieldname=N'مهندسي کامپيوتر' and exists(select *
from cf where cf.field=field.field and kind='t' and not exists(select *
from g
where grade>=10  and  cf.crs#=g.crs# and student.st#=g.st#
)
)
)
--سوال10 لیستی از شماره دانشجویان و تعداد کل واحدهای گذرانده شده توسط هر یک از انها
--روش1
select st#,sum(unit)
from g,course 
where course.crs#=g.crs# and grade>=10
group by st#
--سوال11 لیستی از نام دانشجویان و تعداد کل واحدهای گذرانده شده توسط هر یک از انها
--روش1
select sname,SUM(unit)
from student,g,course
where student.st#=g.st# and course.crs#=g.crs# and grade>=10
group by sname
--سوال12 لیستی از شماره دانشجویانی که مجموعا بیش از 100 واحد درس گذرانده اند
--روش1
select st#
from g,course
where course.crs#=g.crs# and grade>=10
group by st#
having
SUM(unit)>100
--سوال13 لیستی از نام دانشجویانی که مجموعا بیش از 100 واحد درس گذرانده اند
--روش1
select sname
from student,g,course
where student.st#=g.st# and course.crs#=g.crs# and grade>=10
group by sname
having
SUM(unit)>100
--سوال14 لیستی از شماره دانشجوییه کلیه دانشجویان ورودی سال 80 و معدل هر یک از انها در نیمسال اول 81 تهیه کنید
--روش1
select g.st#,AVG(grade)
from student,g
where student.st#=g.st# and startyear=80 and term=811
group by g.st#
--سوال 15 لیستی از نام دانشجویان ورودی سال 80 که معدلشان در نیمسال اول 81 بیشتر از 1 بوده باشد تهیه کنید
--روش1
select sname
from student,g
where student.st#=g.st# and startyear=80 and term=811
group by sname
having AVG(grade)>16
--روش2
select sname
from student
where startyear=80 and st# in(select st#
from g
where term=811
group by st#
having AVG(grade)>16
)
--روش3
select sname
from student
where startyear=80 and exists(select*
from g
where student.st#=g.st# and term=811
group by st#
having AVG(grade)>16
)
--سوال 16 لیستی از نام اساتیدی که درس پایگاه داده ها را تدریس کرده اند
--روش1
select distinct pname
from prof,pc,course
where prof.prof#=pc.prof# and course.crs#=pc.crs# and cname=N'پايگاه داده ها'
--روش2
select pname
from prof
where prof# in(select prof#
from pc
where crs# in(select crs#
from course
where cname=N'پايگاه داده ها'
)
)
--روش3
select pname
from prof
where exists(select *
from pc
where prof.prof#=pc.prof# and  exists(select *
from course
where course.crs#=pc.crs# and cname=N'پايگاه داده ها'
)
)
-- سوال 17 لیستی از شماره اساتیدی که درس پایگاه داده ها را بیش از 4 ترم تدریس کرده اند تهیه کنید
--روش1
select prof#
from pc,course
where course.crs#=pc.crs# and cname=N'پايگاه داده ها'
group by prof#
having count(term)>4
--روش2
select prof#
from pc
where crs# in(select crs#
from course 
where cname=N'پايگاه داده ها'
)
group by prof#
having count(term)>4
--روش3
select prof#
from pc
where exists(select*
from course
where cname=N'پايگاه داده ها' and pc.crs#=course.crs#
)
group by prof#
having COUNT(term)>4
--سوال18 لیستی از نام دروس عملی تهیه کنید که توسط استاد شماره 100 در نیمسال دوم 83 تدریس شده اند
--روش1
select cname
from course,type,pc
where type.type#=course.type# and course.crs#=pc.crs# and typename=N'عملي' and prof#=100 and term=832
--روش2
select cname
from course
where crs# in(select crs#
from pc
where term=832 and  prof#=100
)
and type# in(select type#
from type
where typename=N'عملي'
)

--روش3
select cname
from course
where exists(select*
from pc
where term=832 and course.crs#=pc.crs# and prof#=100
)
and exists(select *
from type
where typename=N'عملي'
)
--سوال19 لیستی از شماره دروسی تهیه کنید که پیش نیاز درس پایگاه داده ها هستند
--روش1
select pre#
from pre,course
where course.crs#=pre.crs# and cname=N'پايگاه داده ها'
--روش2
select pre#
from pre
where crs# in(select crs#
from course 
where cname=N'پايگاه داده ها'
)
--روش3
select pre#
from pre
where exists(select *
from course 
where course.crs#=pre.crs# and  cname=N'پايگاه داده ها'
)
--سوال 20 لیستی از نام دروسی تهیه کنید که پیش نیاز درس پایگاه داده ها هستند
--روش1
select cname
from course
where crs# in(select pre#
from pre
where crs# in(select crs#
from course 
where cname=N'پايگاه داده ها'
)
)
--روش2
select cname
from course
where crs# in(select pre#
from pre
where exists(select *
from course 
where course.crs#=pre.crs# and  cname=N'پايگاه داده ها'
)
)