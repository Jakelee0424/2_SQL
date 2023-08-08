/*
 *  ** DML (DATA MANIPULATION LANGUAGE) : 데이터 조작언어
 * : 테이블에 값을 INSERT(삽입), UPDATE(수정), DELETE(삭제) 하는 구문 
 * 
 * */

-- 주의 : 혼자서 COMMIT, ROLLBACK 하지 말것!
-- > 데이터 조작시 INSERT, UPDATE, DELETE 할때 트랜잭션에 저장됨
-- > 실제로 데이터 값에 저장할 때 COMMIT, 트랜잭션을 비우는 게 ROLLBACK 
-- FOR 안정적인 데이터 저장

-- 테스트 용 테이블 생성
CREATE TABLE EMPLOYEE2 AS SELECT * FROM EMPLOYEE; --(디폴트 값은 복사 안됨)
CREATE TABLE DEPARTMENT2 AS SELECT * FROM DEPARTMENT;

-- 테이블 삭제
DROP TABLE EMPLOYEE2 

--------------------------------------------------------------------------------

-- 1. INSERT 구문
-- : 테이블에 새로운 행 추가
--  [사용법 (1)] 
--  INSERT INTO 테이블명 VALUES(넣을 데이터, .. 데이터..);
-- 	  - 테이블에 있는 모든 컬럼에 대한 값을 INSERT할 때
--	  - INSERT하고자 하는 컬럼이 모든 컬럼인 경우 컬럼명 생략 가능
-- 	  - 컬럼 순서 반드시 지켜야 함
INSERT INTO EMPLOYEE2 
VALUES(900, '홍길동', '981121-1548154', 'KH_DJ@KH.OR.KR', '01024430234', 'D2', 'J3', 'S3', 5000000, '0.2', 200, SYSDATE, NULL, 'N');

SELECT *
FROM EMPLOYEE2
WHERE EMP_ID = 900;

ROLLBACK;

DELETE 
FROM EMPLOYEE2 
WHERE EMP_ID = 900;

COMMIT;

-- [사용법 (2)] 
-- INSERT INTO 테이블명(컬럼명1, 컬럼명2, ...) VALUES(데이터1, 데이터2, ...);
--	  - 내가 선택한 컬럼에 대한 값만 입력할 때 사용
--	  - 선택 안 된 컬럼은 NULL값 자동 입력(DEFALUT값이 존재 시 DEFAULT값으로 삽입)
INSERT INTO EMPLOYEE2(EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY) 
VALUES(900, '아깽이','184874-4897454', 'CAT_DD@KH.OR.KR', '01032343523', 'D2', 'J2', 'S1', '7400000');

SELECT *
FROM EMPLOYEE2
WHERE EMP_ID = 900;

------------------------------------------------------------------------------------------------------------
-- (참고) INSERT시 'VALUES' 대신 서브쿼리 사용 가능
-- SELECT 조회 결과의 데이터 타입, 컬럼 개수가 테이블과 동일해야함

-- 테스트 테이블 생성
CREATE TABLE EMP_01(
	EMP_ID NUMBER,
	EMP_NAME VARCHAR2(30),
	DEMP_TITLE VARCHAR2(20)
);

-- EMPLOYEE2 값 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE2
LEFT JOIN DEPARTMENT2 ON (DEPT_CODE = DEPT_ID);

-- EMPLOYEE2 값 EMP_01에 INSERT
INSERT INTO EMP_01
(SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE2
LEFT JOIN DEPARTMENT2 ON (DEPT_CODE = DEPT_ID));

SELECT *
FROM EMP_01;

-------------------------------------------------------------------------------------------------------------

-- 2. UPDATE 구문 (내용을 바꾸거나 추가해서 최신화, 새롭게 만드는 것)
-- 	  : 테이블에 기록된 컬럼의 값을 수정하는 구문

-- [사용법 (1)] 
-- UPDATE 테이블명 SET 컬럼명 = 바꿀값
-- [WHERE 컬럼명 비교연산자 비교값];

-- DEPARTMENT2 테이블에서 DEPT_ID가 'D9'인 부서 조회
SELECT *
FROM DEPARTMENT2
WHERE DEPT_ID = 'D9';

-- DEPARTMENT2 테이블에서 DEPT_ID가 'D9'인 행의 DEPT_TITLE을 전략기획팀으로 수정
UPDATE DEPARTMENT2 
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID  = 'D9';

-- EMPLOYEE2 테이블에서 BONUS를 받지 않는 사원의
-- BONUS를 01.로 변경
UPDATE EMPLOYEE2
SET BONUS = 0.1
WHERE BONUS IS NULL; -- ** 조건절을 설정하지 않고 UPDATE 하면 모든 행의 컬럼값이 변경

SELECT * FROM DEPARTMENT2;
SELECT * FROM EMPLOYEE2;

UPDATE DEPARTMENT2 SET DEPT_TITLE = '기술연구팀';

COMMIT;
ROLLBACK;
-------------------------------------------------------------------
-- 여러 컬럼을 한번에 수정시, 콤마(,)로 구분

-- D9/전략기획팀 -> D0/전략기획 2팀 수정
UPDATE DEPARTMENT2 
SET DEPT_ID = 'D0', 
DEPT_TITLE = '전략기획2팀'
WHERE DEPT_ID  = 'D9'
AND DEPT_TITLE = '전략기획팀';

SELECT * FROM DEPARTMENT2;

---------------------------------------------------------------------
-- 서브쿼리 사용 가능
-- [작성법]
-- UPDATE 테이블명 SET 컬럼명 = (서브쿼리)

-- EMPLOYEE2 테이블에서
-- 방명수 사원의 급여와 보너스율을 유재식과 동일하게 변경

SELECT SALARY, BONUS FROM EMPLOYEE2 WHERE EMP_NAME = '유재식';
SELECT SALARY FROM EMPLOYEE2 WHERE EMP_NAME = '유재식';
SELECT BONUS FROM EMPLOYEE2 WHERE EMP_NAME = '유재식';

UPDATE EMPLOYEE2
SET SALARY = (SELECT SALARY FROM EMPLOYEE2 WHERE EMP_NAME = '유재식'),
BONUS = (SELECT BONUS FROM EMPLOYEE2 WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

UPDATE EMPLOYEE2
SET SALARY = (SELECT SALARY FROM EMPLOYEE2 WHERE EMP_NAME = '유재식'),
BONUS = (SELECT BONUS FROM EMPLOYEE2 WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

SELECT EMP_NAME, SALARY, BONUS 
FROM EMPLOYEE2
WHERE EMP_NAME IN ('유재식', '방명수');

ROLLBACK;

------------------------------------------------------------------------
-- 3. MERGE (병합)
-- 구조가 같은 두 개의 테이블을 하나로 합치는 기능
-- 테이블에서 지정하는 조건의 값이 존재하면 UPDATE 
-- 조건의 값이 없으면 INSERT

CREATE TABLE EMP_M01 -- 테스트 테이블 1
AS SELECT * FROM EMPLOYEE;

CREATE TABLE EMP_M02 -- 테스트 테이블 2
AS SELECT * FROM EMPLOYEE
WHERE JOB_CODE = 'J4';

SELECT * FROM EMP_M01;
SELECT * FROM EMP_M02;

INSERT INTO EMP_M02 
VALUES (999, '곽두원', '456874-1894987', 'ajsd@asndj.sk.kr', '01054847154', 'D9', 'J4', 'S1', 9000000, 0.5, NULL, SYSDATE, NULL, DEFAULT);

UPDATE EMP_M02 SET SALARY = 0;

MERGE INTO EMP_M01 USING EMP_M02 ON(EMP_M01.EMP_ID = EMP_M02.EMP_ID)
WHEN MATCHED THEN
UPDATE SET
	EMP_M01.EMP_NAME = EMP_M02.EMP_NAME,
	EMP_M01.EMP_NO = EMP_M02.EMP_NO,
	EMP_M01.EMAIL = EMP_M02.EMAIL,
	EMP_M01.PHONE = EMP_M02.PHONE,
	EMP_M01.DEPT_CODE = EMP_M02.DEPT_CODE,
	EMP_M01.JOB_CODE = EMP_M02.JOB_CODE,
	EMP_M01.SAL_LEVEL = EMP_M02.SAL_LEVEL,
	EMP_M01.SALARY = EMP_M02.SALARY,
	EMP_M01.BONUS = EMP_M02.BONUS,
	EMP_M01.MANAGER_ID = EMP_M02.MANAGER_ID,
	EMP_M01.HIRE_DATE = EMP_M02.HIRE_DATE,
	EMP_M01.ENT_DATE = EMP_M02.ENT_DATE,
	EMP_M01.ENT_YN = EMP_M02.ENT_YN
WHEN NOT MATCHED THEN
INSERT VALUES
(EMP_M02.EMP_ID, EMP_M02.EMP_NAME, EMP_M02.EMP_NO, EMP_M02.EMAIL, 
EMP_M02.PHONE, EMP_M02.DEPT_CODE, EMP_M02.JOB_CODE, EMP_M02.SAL_LEVEL,
EMP_M02.SALARY, EMP_M02.BONUS, EMP_M02.MANAGER_ID, EMP_M02.HIRE_DATE, 
EMP_M02.ENT_DATE, EMP_M02.ENT_YN);
	        
-- EMP_M01 로 흡수
	        
------------------------------------------------------------------------------------

-- 4. DELETE 
-- 테이블의 행을 삭제하는 구문

-- [작성법]
-- DELETE FROM 테이블명 WHERE 조건설정
-- WHERE 절 조건 설정하지 않으면 모든 행이 삭제	        

-- EMPLOYEE2의 홍길동 삭제
DELETE FROM EMPLOYEE2
WHERE EMP_NAME = '홍길동';

SELECT * FROM EMPLOYEE2
WHERE EMP_NAME = '홍길동';

-- EMPLOYEE2 테이블 전체 삭제
DELETE FROM EMPLOYEE2;

ROLLBACK;
COMMIT;


---------------------------------------------------------------------------------------

-- 5. TRUNCATE (DML 아님), DDL임
-- 테이블의 전체 행을 삭제하는 DDL
--    1) DELETE보다 수행 속도 빠름
--    2) ROLLBACK으로 복구 안됨

-- TRUNCATE용 테스트 테이블 생성
CREATE TABLE EMPLOYEE3 AS SELECT * FROM EMPLOYEE2;

-- 생성 확인
SELECT * FROM EMPLOYEE3

-- TRUCATE로 삭제
TRUNCATE TABLE EMPLOYEE3;

-- 롤백해도 소용없음
ROLLBACK;



	        


