
------ BASIC

-- 1번 문제
SELECT DEPARTMENT_NAME 학과명, CATEGORY 계열 
FROM TB_DEPARTMENT;

-- 2번 문제
SELECT DEPARTMENT_NAME, '정원은', CAPACITY || '명 입니다.' 
FROM TB_DEPARTMENT;

-- 3번 문제
SELECT STUDENT_NAME  
FROM TB_STUDENT 
WHERE DEPARTMENT_NO = 
(SELECT DEPARTMENT_NO FROM TB_DEPARTMENT WHERE DEPARTMENT_NAME = '국어국문학과') 
AND ABSENCE_YN ='Y'
AND STUDENT_SSN LIKE '_______2%';

-- 4번 문제
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN ('A513079', 'A513090', 'A513091', 'A513110', 'A513119');

-- 5번 문제
SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT 
WHERE CAPACITY BETWEEN '20' AND '30';

--6번 문제
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

--7번 문제
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

--8번 문제
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

--9번 문제
SELECT DISTINCT CATEGORY
FROM TB_DEPARTMENT
ORDER BY CATEGORY;

--10번 문제
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'N'
AND EXTRACT(YEAR FROM ENTRANCE_DATE) = 2002
AND STUDENT_ADDRESS LIKE '전주시%';


------------------------- FUNCTION


-- 1번 문제
SELECT STUDENT_NO 학번, STUDENT_NAME 이름, TO_CHAR(TO_DATE(ENTRANCE_DATE, 'RRRR-MM-DD'), 'YYYY-MM-DD') 입학년도 
FROM TB_STUDENT
WHERE DEPARTMENT_NO = '002'
ORDER BY ENTRANCE_DATE;

-- 2번 문제
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME NOT LIKE '___' ;

-- 3번 문제 
SELECT PROFESSOR_NAME 교수이름, 
EXTRACT(YEAR FROM SYSDATE) - (TO_CHAR(TO_DATE(SUBSTR(PROFESSOR_SSN, 1, 6), 'YYMMDD') , 'YYYY') - 100) 나이
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = 1
ORDER BY PROFESSOR_SSN DESC;

-- 4번 문제
SELECT SUBSTR(PROFESSOR_NAME, 2, 3) 이름 
FROM TB_PROFESSOR;

-- 5번 문제
SELECT STUDENT_NO, STUDENT_NAME, EXTRACT(YEAR FROM ENTRANCE_DATE) - (19 || (SUBSTR(STUDENT_SSN, 1,2))) "입학 나이"
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) - (19 || (SUBSTR(STUDENT_SSN, 1,2))) > 19;

-- 6번 문제
SELECT TO_CHAR(TO_DATE('2020-12-25'), 'DAY') FROM DUAL;

-- 7번 문제
SELECT TO_DATE('99/10/11', 'YY/MM/DD'), TO_DATE('49/10/11', 'YY/MM/DD') FROM DUAL;
SELECT TO_DATE('99/10/11', 'RR/MM/DD'), TO_DATE('49/10/11', 'RR/MM/DD') FROM DUAL;

-- 8번 문제
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO NOT LIKE 'A%';

-- 9번 문제
SELECT ROUND(AVG(POINT), 1) 평점
FROM TB_GRADE
WHERE STUDENT_NO = 'A517178';

-- 10번 문제
SELECT DEPARTMENT_NO "학과 번호", COUNT(*) "학생수(명)"
FROM TB_STUDENT GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO;

-- 11번 문제
SELECT COUNT(*)
FROM TB_STUDENT 
WHERE COACH_PROFESSOR_NO IS NULL; 

-- 12번 문제
SELECT SUBSTR(TERM_NO, 1, 4) 년도, ROUND(AVG(POINT),1) 평점
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY SUBSTR(TERM_NO, 1, 4);

-- 13번 문제 
SELECT DEPARTMENT_NO 학과코드명, COUNT(CASE WHEN ABSENCE_YN = 'Y' THEN 1 END) "휴학생 수"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO;

-- 14번 문제
SELECT STUDENT_NAME, COUNT(*)
FROM TB_STUDENT
GROUP BY STUDENT_NAME
HAVING COUNT(*) >= 2
ORDER BY 1;

-- 15번 문제
SELECT SUBSTR(TERM_NO, 1, 4), SUBSTR(TERM_NO, 5, 2),  ROUND(AVG(POINT), 1)
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP (SUBSTR(TERM_NO, 1, 4), SUBSTR(TERM_NO, 5, 2))
ORDER BY 1;


------------------------------option


-- 1번 문제
SELECT STUDENT_NAME "학생 이름", STUDENT_ADDRESS "주소지"
FROM TB_STUDENT
ORDER BY 1;

-- 2번 문제
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
ORDER BY STUDENT_SSN DESC;

-- 3번 문제
SELECT STUDENT_NAME 학생이름, STUDENT_NO 학번, STUDENT_ADDRESS "거주지 주소"
FROM TB_STUDENT
WHERE STUDENT_NO LIKE '9%'
AND (STUDENT_ADDRESS LIKE'경기%'
OR STUDENT_ADDRESS LIKE'강원%')
ORDER BY 1;

-- 4번 문제
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO = 
(SELECT DEPARTMENT_NO FROM TB_DEPARTMENT WHERE DEPARTMENT_NAME = '법학과')
ORDER BY PROFESSOR_SSN;

-- 5번 문제
SELECT STUDENT_NO, POINT
FROM TB_GRADE
WHERE CLASS_NO = 'C3118100'
AND TERM_NO LIKE '200402'
ORDER BY POINT DESC, STUDENT_NO ;

-- 6번 문제
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME 
FROM TB_STUDENT
NATURAL JOIN TB_DEPARTMENT;

-- 7번 문제
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
NATURAL JOIN TB_DEPARTMENT;

-- 8번 문제
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS_PROFESSOR
JOIN TB_PROFESSOR USING(PROFESSOR_NO)
JOIN TB_CLASS USING(CLASS_NO);

-- 9번 문제
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS_PROFESSOR
JOIN TB_PROFESSOR USING(PROFESSOR_NO)
JOIN TB_CLASS C USING(CLASS_NO)
JOIN TB_DEPARTMENT D ON(C.DEPARTMENT_NO = D.DEPARTMENT_NO) 
WHERE CATEGORY = '인문사회';

-- 10번 문제
SELECT STUDENT_NO 학번, STUDENT_NAME 학생이름, ROUND(AVG(POINT),1) "전체 평점"
FROM TB_GRADE
JOIN TB_STUDENT USING(STUDENT_NO)
WHERE DEPARTMENT_NO ='059'
GROUP BY STUDENT_NAME, STUDENT_NO 
ORDER BY 학번;

-- 11번 문제
SELECT DEPARTMENT_NAME 학과이름, STUDENT_NAME 학생이름, PROFESSOR_NAME 지도교수이름 
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_PROFESSOR ON(COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE STUDENT_NO = 'A313047';

--12번 문제
SELECT STUDENT_NAME, TERM_NO
FROM TB_GRADE
JOIN TB_STUDENT USING(STUDENT_NO)
JOIN TB_CLASS USING(CLASS_NO)
WHERE TERM_NO LIKE '2007%'
AND CLASS_NAME = '인간관계론';

--13번 문제
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
FULL JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
FULL JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
WHERE CATEGORY ='예체능'
AND PROFESSOR_NO IS NULL;

--14번 문제
SELECT STUDENT_NAME 학생이름, NVL(PROFESSOR_NAME, '지도교수 미지정') 지도교수
FROM TB_STUDENT E
LEFT JOIN TB_PROFESSOR ON(COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE E.DEPARTMENT_NO = '020'
ORDER BY STUDENT_NO;

--15번 문제
SELECT STUDENT_NO 학번, STUDENT_NAME 이름, DEPARTMENT_NAME 학과이름, AVG(POINT) 평점 
FROM TB_STUDENT
FULL JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
FULL JOIN TB_GRADE USING(STUDENT_NO)
WHERE ABSENCE_YN = 'N'
GROUP BY STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
HAVING AVG(POINT) >= 4.0
ORDER BY 학번;

--16번 문제
SELECT CLASS_NO, CLASS_NAME, AVG(POINT)
FROM TB_CLASS
FULL JOIN TB_GRADE USING(CLASS_NO)
FULL JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '환경조경학과'
AND CLASS_TYPE LIKE '전공%'
GROUP BY CLASS_NO, CLASS_NAME
ORDER BY CLASS_NO ;

--17번 문제
SELECT  STUDENT_NAME, STUDENT_ADDRESS
FROM TB_STUDENT
WHERE DEPARTMENT_NO = 
(SELECT DEPARTMENT_NO FROM TB_STUDENT WHERE STUDENT_NAME = '최경희');

--18번 문제
SELECT STUDENT_NO, STUDENT_NAME 
FROM (SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
JOIN TB_GRADE USING (STUDENT_NO)
WHERE DEPARTMENT_NO= '001'  
GROUP BY STUDENT_NO, STUDENT_NAME
ORDER BY AVG(POINT) DESC )
WHERE ROWNUM=1;
 
--19번 문제
SELECT DEPARTMENT_NAME "계열 학과명", ROUND(AVG(POINT), 1) 전공평점  
FROM TB_CLASS
FULL JOIN TB_GRADE USING(CLASS_NO)
FULL JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE CATEGORY = 
(SELECT CATEGORY FROM TB_DEPARTMENT WHERE DEPARTMENT_NAME = '환경조경학과')
AND CLASS_TYPE LIKE '전공%'
GROUP BY DEPARTMENT_NAME
ORDER BY DEPARTMENT_NAME;


----------------------------------------- DML

-- 1번
CREATE TABLE USER_TEST(
	ID NUMBER,
	NAME VARCHAR2(30),
	RESERVE_DATE DATE(20),
	ROOM_NUM NUMBER
);

INSERT INTO USER_TEST VALUES(1, '홍길동', '2016-01-05', 2014);
INSERT INTO USER_TEST VALUES(2, '임꺽정', '2016-02-12', 918);
INSERT INTO USER_TEST VALUES(3, '장길산', '2016-01-16', 1208);
INSERT INTO USER_TEST VALUES(4, '홍길동', '2016-03-17', 504);
INSERT INTO USER_TEST VALUES(6, '김유신', NULL, NULL);

-- 2번
UPDATE USER_TEST 
SET ROOM_NUM = '2002'
WHERE NAME = '홍길동';

DELETE FROM USER_TEST
WHERE ID = '6';


--3번
UPDATE USER_TEST 
SET ROOM_NUM = '2002';


--4번
CREATE TABLE EMPLOYEE4 AS SELECT * FROM EMPLOYEE; 



SELECT * FROM USER_TEST;
ROLLBACK;
COMMIT;