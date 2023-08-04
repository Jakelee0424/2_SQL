
--  SELECT문 해석 순서
--  
--  5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
--  1 : FROM 참조할 데이터명
--  2 : WHERE 컬럼명 | 함수식 비교연산자 비교값
--  3 : GROUP BY 그룹을 묶을 컬럼명
--  4 : HAVING 그룸함수식 비교연산자 비교값
--  6 : ORDER BY 컬럼명 | 별칭 | 컬럼순번, 정렬방식 [NULLS FIRST | LAST]
--  

-----------------------------------------------------------------------
-- ** GROUP BY
-- 같은 값들이 여러개 기록된 컬럼을 가지고, 같은 값들을 하나로 묶음
-- GROUP BY 컬럼명 | 함수식, ...
-- 여러개의 값을 묶어서 하나로 처리할 목적으로 사용
-- 그룹으로 묶은 값에 대해서는 SELECT절 그룹함수 사용

-- 그룹 함수는 단 한개의 결과값만 산출 
-- 즉, 그룹이 여러개면 오류 발생


-- EMPLOYEE 에서 부서코드, 부서별 급여 합 조회 
SELECT SUM(SALARY) FROM EMPLOYEE;

SELECT DEPT_CODE,SUM(SALARY) --5
FROM EMPLOYEE  			-- 1
GROUP BY DEPT_CODE;    -- 3

--EMPLOYEE 에서 직급별 직급코드, 급여 평균, 인원수 
SELECT JOB_CODE, ROUND(AVG(SALARY)), COUNT(*)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

--EMPLOYEE 테이블에서 
-- 성별(남여) 와 각 성별 별 인원수, 급여합을 인원수 오름차순으로 조회
SELECT  DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남','2','여') "성별", 
COUNT(*) "인원수", 
SUM(SALARY) "급여합"
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남','2','여')
ORDER BY 성별 DESC;

-------------------------------------------------------------------------------
-- ** WHERE 절 GROUP BY 절 혼합
-- WHERE 절은 각 컬럼에 대한 조건

-- EMPLOYEE 테이블에서 부서코드가 D5, D6인 부서의 평균 급여, 인원수 조회
SELECT ROUND(AVG(SALARY)) 평균급여, COUNT(*) 인원수
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6')
GROUP BY DEPT_CODE ;

-- EMPLOYEE에서 직급별 2000년도 이후 입사자들의 급여합을 조회
SELECT JOB_CODE 직급, SUM(SALARY) 급여합
FROM EMPLOYEE
WHERE TO_CHAR(HIRE_DATE, 'YYYY') >= 2000
GROUP BY JOB_CODE 
ORDER BY JOB_CODE ;

---------------------------------------------------------------------------------
-- 여러 컬럼을 묶어서 그룹으로 지정 가능 --> 그룹내 그룹

-- EMPLOYEE 테이블에서 부서별로 같은 직급인 사원의 수를 조회
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE, JOB_CODE DESC;

-- DEPT_CODE로 그룹을 나누고, 나눠진 그룹내에서 JOB_CODE로 또 그룹을 분류 -> 세분화

-- ** GROUP BY 사용시 주의사항
-- SELECT 문에 GROUP BY 절 사용할 경우
-- SELECT 절에 명시한 조회하려는 컬럼 중
-- 그룹 함수가 적용되지 않은 컬럼을
-- 모두 GROUP BY에 작성해야함

-------------------------------------------------------------------------------

-- ** HAVING 절 : 그룹 함수로 구해올 그룹에 대한 조건을 설정할 떄 사용
-- HAVING 컬럼명 | 함수식 비교연산자 비교값

-- 부서별 평균 급여가 3백만원 이상인 부서를 조회
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000
ORDER BY DEPT_CODE;

-- EMPLOYEE 테이블에서 직급별 인원수가 5명 이하인 직급코드, 인원수 조회
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(*) <= 5
ORDER BY DEPT_CODE;

----------------------------------------------------------------------------------

-- ** 집계함수(ROLLUP, CUBE)
-- 그룹별 산출 결과 값의 집계를 계산하는 함수
-- (그룹별로 중간 집계 결과를 추가)
-- GROUP BY 절에서만 사용할 수 있는 함수

-- ROLLUP(소계) : GROUP BY 절에서 가장 먼저 작성된 컬럼의 중간 집계를 처리하는 함수
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-- CUBE : GROUP BY 에서 작성된 모든 컬럼의 중간 집계를 처리하는 함수
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-----------------------------------------------------------------------------------

-- ** 집합 연산자
-- 여러 SELECT의 결과를 하나의 결과로 만드는 연산자

-- UNION(합집합) : 두 SELECT의 결과를 하나로 합침, 단 중복은 한번만 작성
-- INTERSECT(교집합) : 두 SELECT의 결과 중 중복되는 부분만 조회
-- UNION ALL : UNION + INTERSECT : 합집합에서 중복제거하지 않음
-- MINUS(차집합) : A에서 A,B 교집합을 제거하고 조회

-- 부서코드가 D5인 사원의 사번, 이름 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
-- 급여가 300만원 초과인 사원의 사번, 이름, 부서코드 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- (주의사항) 
-- 집합연산자를 사용하기 위한 SELECT 문들은
-- 조회하는 컬럼의 타입, 개수가 모두 동일해야 한다.

SELECT EMP_ID, EMP_NAME FROM EMPLOYEE;
UNION
SELECT DEPT_CODE, DEPT_TITLE FROM DEPARTMENT;
