CREATE SCHEMA zjutuser AUTHORIZATION zjutuser;
SET SEARCH_PATH TO zjutuser, Public;
SHOW SEARCH_PATH;


DROP TABLE IF EXISTS 123_dept02;
CREATE TABLE 123_dept02			
(
456_dno02 VARCHAR(2) PRIMARY KEY,		
456_dname02 VARCHAR(20) NOT NULL
);

--建立聚簇索引dept_dno
CREATE INDEX dept_dno ON 123_dept02 (456_dno02);
CLUSTER 123_dept02 USING dept_dno;

--建立班级表123_class02
DROP TABLE IF EXISTS 123_class02;
CREATE TABLE 123_class02			
(
456_cno02 VARCHAR(10) PRIMARY KEY,		
456_cname02 VARCHAR(20) NOT NULL,
456_dno02 VARCHAR(2),
CONSTRAINT class_dept FOREIGN KEY (456_dno02) REFERENCES 123_dept02
);

--建立聚簇索引class_cno
CREATE INDEX class_cno ON 123_class02 (456_cno02);
CLUSTER 123_class02 USING class_cno;

--建立学生表
DROP TABLE IF EXISTS 123_student02;
CREATE TABLE 123_student02			
(
456_sno02 VARCHAR(10) PRIMARY KEY,	
456_sname02 VARCHAR(20) NOT NULL,
456_cno02 VARCHAR(10) NOT NULL, 	
456_ssex02 VARCHAR(2) NOT NULL,
456_sage02 INT,
456_source02 VARCHAR(20) NOT NULL,
456_startDate02 timestamp(0) without time zone,
456_credithours02  INT,
456_dno02 VARCHAR(2)NOT NULL,
CONSTRAINT student_dept FOREIGN KEY (456_dno02) REFERENCES 123_dept02,
CONSTRAINT student_class FOREIGN KEY (456_cno02) REFERENCES 123_class02
);

--建立聚簇索引student_sno
CREATE INDEX student_sno ON 123_student02 (456_sno02);
CLUSTER 123_student02 USING student_sno;

--建立课程表
DROP TABLE IF EXISTS 123_course02;
CREATE TABLE 123_course02			
(
456_cno02 VARCHAR(10) PRIMARY KEY,		
456_cname02 VARCHAR(20) NOT NULL,
456_ccredit02 FLOAT
);

--建立聚簇索引course_cno
CREATE INDEX course_cno ON 123_course02 (456_cno02);
CLUSTER 123_course02 USING course_cno;

--建立教师表
DROP TABLE IF EXISTS 123_teacher02;
CREATE TABLE 123_teacher02			
(
456_tno02 VARCHAR(10) PRIMARY KEY,	
456_tname02 VARCHAR(20) NOT NULL,
456_tsex02 VARCHAR(2) NOT NULL,
456_tage02 INT,
456_phone02 VARCHAR(11),
456_title02 VARCHAR(10)
);

--建立聚簇索引teacher_tno
CREATE INDEX teacher_tno ON 123_teacher02 (456_tno02);
CLUSTER 123_teacher02 USING teacher_tno;

--建立成绩评分表
DROP TABLE IF EXISTS 123_report02;
CREATE TABLE 123_report02			
(
456_sno02 VARCHAR(10),	
456_cno02 VARCHAR(10) NOT NULL, 	
456_semester02 VARCHAR(10),
456_grade02 FLOAT,
456_appraise02 VARCHAR(100),

PRIMARY KEY (456_sno02,456_cno02,456_semester02)
);
--建立成绩降序索引
drop INDEX rep_grade;
CREATE INDEX rep_grade on 123_report02(456_grade02 DESC);
--建立授课表
DROP TABLE IF EXISTS 123_teach02;
CREATE TABLE 123_teach02			
(
456_tno02 VARCHAR(10),	
456_courseno02 VARCHAR(10) NOT NULL, 	
456_cno02 VARCHAR(10),
456_semester02 VARCHAR(10),
PRIMARY KEY (456_tno02,456_courseno02,456_cno02,456_semester02),
CONSTRAINT report_teacher FOREIGN KEY (456_tno02) REFERENCES 123_teacher02,
CONSTRAINT report_course FOREIGN KEY (456_cno02) REFERENCES 123_class02
);

--建立开课表
DROP TABLE IF EXISTS 123_deptcourse02;
CREATE TABLE 123_deptcourse02			
(
456_dno02 VARCHAR(10),	
456_cno02 VARCHAR(10),
456_optional02 VARCHAR(5),	
456_semester02 VARCHAR(5),
PRIMARY KEY (456_cno02,456_dno02,456_semester02),
CONSTRAINT deptcourse_dept FOREIGN KEY (456_dno02) REFERENCES 123_dept02,
CONSTRAINT deptcourse_course FOREIGN KEY (456_cno02) REFERENCES 123_course02
);


--建立视图
DROP VIEW IF EXISTS Tea_Cou_Cla;
CREATE VIEW Tea_Cou_Cla
AS
SELECT 123_teach02.456_tno02,456_tname02,123_course02.456_cno02 courseno,123_course02.456_cname02 coursename,123_class02.456_cno02,123_class02.456_cname02,123_teach02.456_semester02,123_course02.456_ccredit02
FROM 123_teacher02,123_course02,123_class02,123_teach02
WHERE 123_teach02.456_cno02 = 123_class02.456_cno02 AND 123_teach02.456_courseno02 = 123_course02.456_cno02 AND 123_teach02.456_tno02 = 123_teacher02.456_tno02;

--建立视图
DROP VIEW IF EXISTS Tea_Cou_Cla_all;
CREATE VIEW Tea_Cou_Cla_all
AS
SELECT 123_teach02.456_tno02,456_tname02,123_course02.456_cno02 courseno,123_course02.456_cname02 coursename,123_class02.456_cno02,123_class02.456_cname02,123_teach02.456_semester02
FROM 123_teacher02,123_course02,123_class02,123_teach02;

--建立视图
DROP VIEW IF EXISTS dep_cou_dc;
CREATE VIEW dep_cou_dc
AS
SELECT 123_course02.456_cname02,123_course02.456_cno02,123_dept02.456_dname02,123_dept02.456_dno02,123_deptcourse02.456_optional02,123_deptcourse02.456_semester02
FROM 123_course02,123_dept02,123_deptcourse02
WHERE 123_course02.456_cno02 = 123_deptcourse02.456_cno02 AND 123_dept02.456_dno02 = 123_deptcourse02.456_dno02;

--建立视图
DROP VIEW IF EXISTS cla_cou_tea_ter;
CREATE VIEW cla_cou_tea_ter
AS
SELECT 123_class02.456_cno02,123_teach02.456_semester02,123_course02.456_cname02 coursename,123_course02.456_ccredit02,123_teacher02.456_tname02,123_teacher02.456_tsex02,123_teacher02.456_tage02,123_teacher02.456_phone02,123_teacher02.456_title02,123_course02.456_cno02 courseno
FROM 123_class02,123_course02,123_teach02,123_teacher02
WHERE 123_class02.456_cno02 = 123_teach02.456_cno02 AND 123_teach02.456_courseno02 = 123_course02.456_cno02 AND 123_teach02.456_tno02 = 123_teacher02.456_tno02;

--建立视图
DROP VIEW IF EXISTS stu_rep_tea_ter_cou;
CREATE VIEW stu_rep_tea_ter_cou
AS
SELECT 123_student02.456_sno02,123_student02.456_sname02,123_report02.456_semester02,123_report02.456_cno02,123_course02.456_cname02 coursename,123_report02.456_grade02,123_course02.456_ccredit02,123_teacher02.456_tname02,123_teacher02.456_tsex02,123_teacher02.456_tage02,123_teacher02.456_phone02,123_teacher02.456_title02,123_report02.456_appraise02,123_teach02.456_tno02
FROM 123_course02,123_teach02,123_teacher02,123_report02,123_student02
WHERE 123_student02.456_sno02 = 123_report02.456_sno02 AND 123_report02.456_cno02 = 123_course02.456_cno02 AND 123_report02.456_cno02 = 123_teach02.456_courseno02 AND 123_teach02.456_tno02 = 123_teacher02.456_tno02 AND 123_student02.456_cno02 = 123_teach02.456_cno02;

--建立视图
DROP VIEW IF EXISTS stu_cla_dep_rep_tea;
CREATE VIEW stu_cla_dep_rep_tea
AS
SELECT 123_report02.456_cno02,123_teach02.456_tno02,123_report02.456_semester02,123_student02.456_sno02,123_student02.456_sname02,123_class02.456_cname02,123_student02.456_ssex02,123_student02.456_sage02,123_dept02.456_dname02
FROM 123_student02,123_class02,123_dept02,123_report02,123_teach02
WHERE 123_student02.456_dno02 = 123_dept02.456_dno02 AND 123_student02.456_cno02 = 123_class02.456_cno02 AND 123_student02.456_sno02 = 123_report02.456_sno02 AND 123_report02.456_semester02 = 123_teach02.456_semester02 AND 123_teach02.456_courseno02 = 123_report02.456_cno02 AND 123_student02.456_cno02 = 123_teach02.456_cno02;

--建立视图
DROP VIEW IF EXISTS stu_cla;
CREATE VIEW stu_cla
AS
SELECT 123_student02.456_sno02,123_student02.456_sname02,123_class02.456_cno02,123_class02.456_cname02
FROM 123_class02,123_student02
WHERE 123_student02.456_cno02 = 123_class02.456_cno02;

--建立视图
DROP VIEW IF EXISTS stu_tea_cou;
CREATE VIEW stu_tea_cou
AS
SELECT 123_student02.456_sno02,123_student02.456_cno02,123_course02.456_cno02 courseno,123_course02.456_cname02,123_course02.456_ccredit02,123_teach02.456_semester02
FROM 123_student02,123_course02,123_teach02
WHERE 123_student02.456_cno02 = 123_teach02.456_cno02 AND 123_course02.456_cno02 = 123_teach02.456_courseno02;




--建立触发器1
CREATE OR REPLACE FUNCTION Reports_update_func() RETURNS TRIGGER AS 
           $$ 
           DECLARE 
           BEGIN   
              UPDATE 123_Student02 set 456_creditHours02=456_creditHours02 + (select 456_CreditHours02  from 123_Course02 where 123_Course02.456_Cno02 = NEW.456_Cno02) where NEW.456_Grade02>=60 and 123_Student02.456_Sno02=NEW.456_Sno02; 
                RETURN  NEW;
           END 
           $$ LANGUAGE PLPGSQL; 
--DROP TRIGGER Report_update_trigger ON 123_Report02 ;         
CREATE TRIGGER Report_update_trigger 
           AFTER INSERT ON 123_Report02
           FOR EACH ROW 
           EXECUTE PROCEDURE Reports_update_func();
           
--建立触发器2
CREATE OR REPLACE FUNCTION Reports_DELETE_FUNC() RETURNS TRIGGER AS 
           $$ 
           DECLARE 
           BEGIN 
                UPDATE 123_Student02 set 456_creditHours02= 456_creditHours02 - (select  456_CreditHours02  from 123_Course02 where 123_Course02.456_Cno02 = OLD.456_Cno02)  where  OLD.456_Grade02>=60  and  123_Student02.456_Sno02=OLD.456_Sno02;
                RETURN  OLD;
           END 
           $$ LANGUAGE PLPGSQL; 
--DROP TRIGGER Report_delete_trigger ON 123_Report02 ;   
CREATE TRIGGER Report_delete_trigger 
           AFTER  DELETE ON 123_Report02
           FOR EACH ROW 
          EXECUTE PROCEDURE Reports_DELETE_FUNC();
          
--建立存储器1
CREATE OR REPLACE PROCEDURE  sp_delete_graduate ( 456_end_date  VARCHAR2(10) ,  456_min_credit  integer)
AS
DECLARE
    456_stu_sno  VARCHAR(10) ;
CURSOR  C  IS SELECT  456_Sno02  FROM 123_Student02 WHERE 456_Startdate02 <=(cast (456_end_date as TIMESTAMP) - interval'4 years') and 456_creditHours02>= 456_min_credit ;  
BEGIN 
   OPEN C; 
   LOOP 
      FETCH C INTO 456_stu_sno; 
      EXIT WHEN C%NOTFOUND;  
       delete from 123_Report02 where 456_Sno02=456_stu_sno;
       delete from 123_Student02 where 456_Sno02 = 456_stu_sno;
   END LOOP; 
   CLOSE C; 
END;  
          
--建立存储过程 手动选课
CREATE OR REPLACE PROCEDURE  sp_xk ( sno  VARCHAR(10) , cno  VARCHAR(10) , semester  VARCHAR(10))
AS
DECLARE
BEGIN
  INSERT INTO  zjutuser.123_report02 values(sno,cno,semester); 
END;  

--建立存储过程 手动退课
CREATE OR REPLACE PROCEDURE  sp_tk ( sno  VARCHAR(10) , cno  VARCHAR(10) , semester  VARCHAR(10))
AS
DECLARE
BEGIN
  delete from zjutuser.123_report02 where 456_sno02 = sno and 456_cno02 = cno and 456_semester02 = semester;
END;  


