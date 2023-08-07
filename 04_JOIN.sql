/* 
[JOIN 용어 정리]
  오라클       	  	             |                   SQL : 1999표준(ANSI)
---------------------------------|-------------------------------------------------------------------------------
등가 조인		                 |           내부 조인(INNER JOIN), JOIN USING / ON
                                 |           + 자연 조인(NATURAL JOIN, 등가 조인 방법 중 하나)
---------------------------------|-------------------------------------------------------------------------------
포괄 조인 		                 |       왼쪽 외부 조인(LEFT OUTER), 오른쪽 외부 조인(RIGHT OUTER)
                                 |           + 전체 외부 조인(FULL OUTER, 오라클 구문으로는 사용 못함)
---------------------------------|-------------------------------------------------------------------------------
자체 조인, 비등가 조인   	     |           		    JOIN ON
---------------------------------|-------------------------------------------------------------------------------
카테시안(카티션) 곱		         |     			 교차 조인(CROSS JOIN)
CARTESIAN PRODUCT				 |

- 미국 국립 표준 협회(American National Standards Institute, ANSI) 미국의 산업 표준을 제정하는 민간단체.
- 국제표준화기구 ISO에 가입되어 있음.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------

-- JOIN
-- 하나 이상의 테이블에서 데이터를 조회하기 위해 사용.
-- 수행 결과는 하나의 Result Set으로 나옴.

-- (참고) JOIN은 서로 다른 테이블의 행을 하나씩 이어 붙이기 때문에
--       시간이 오래 걸리는 단점이 있다!

/* 
- 관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법.

- 관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어
  원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서 
  데이터를 읽어와야 되는 경우가 많다.
  이 때, 테이블간 관계를 맺기 위한 **연결고리 역할**이 필요한데,
  두 테이블에서 같은 데이터를 저장하는 컬럼이 연결고리가됨.   
*/

--------------------------------------------------------------------------------------------------------------------------------------------------

-- 직원 번호, 직원명, 부서코드, 부서명 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE ;

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;


-- 1. 내부 조인(INNER JOIN, 안시 기준) ( == 등가 조인(EQUAL JOIN), 오라클 기준)
--> 연결되는 컬럼의 값이 일치하는 행들만 조인됨.  (== 일치하는 값이 없는 행은 조인에서 제외됨. ) --> 포함시키고 시키면 외부조인

-- 작성 방법 크게 ANSI구문과 오라클 구문 으로 나뉘고 
-- ANSI에서  USING과 ON을 쓰는 방법으로 나뉜다.

-- * ANSI 표준 구문
-- ANSI는 미국 국립 표준 협회를 뜻함, 미국의 산업표준을 제정하는 민간단체로 
-- 국제표준화기구 ISO에 가입되어있다.
-- ANSI에서 제정된 표준을 ANSI라고 하고 
-- 여기서 제정한 표준 중 가장 유명한 것이 ASCII코드이다.

-- 1) 연결에 사용할 두 컬럼명이 다른 경우 -> ON 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

SELECT DEPT_TITLE, LOCAL_NAME 
FROM DEPARTMENT
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

-- 2) 연결에 사용할 두 컬럼명이 같은 경우 -> USING
-- EMPLOYEE 테이블 + JOB 테이블 참조 하여 사번, 이름, 직급코드, 직급명 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE);


-- * 오라클 전용 구문
-- FROM절에 쉼표(,) 로 구분하여 합치게 될 테이블명을 기술하고
-- WHERE절에 합치기에 사용할 컬럼명을 명시한다

-- 1) 연결에 사용할 두 컬럼명이 다른 경우  
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

SELECT DEPT_TITLE, LOCAL_NAME 
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

-- 2) 연결에 사용할 두 컬럼명이 같은 경우 -> 테이블 별로 별칭 사용
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;


---------------------------------------------------------------------------------------------------------------


-- 2. 외부 조인(OUTER JOIN)

-- 두 테이블의 지정하는 컬럼값이 일치하지 않는 행도 조인에 포함을 시킴
-->  *반드시 OUTER JOIN임을 명시해야 한다.

-- 1) 안시 기준 : OUTER JOIN (LEFT(왼쪽 테이블), RIGHT(오른쪽 테이블), FULL(전체 테이블)) --> OUTER 생략 가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
FULL OUTER JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 2) 오라클 기준 : 반대쪽 테이블 뒤에 (+), 오라클은 FULL OUTER JOIN 없음.. 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);


---------------------------------------------------------------------------------------------------------------

-- 3. 교차 조인(CROSS JOIN == CARTESIAN PRODUCT) : 사실상 오류 확인용
--  조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 방법(곱집합)
--> JOIN 구문을 잘못 작성하는 경우 CROSS JOIN의 결과가 조회됨

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT; -- 23 * 9 


---------------------------------------------------------------------------------------------------------------

-- 4. 비등가 조인(NON EQUAL JOIN)

-- '='(등호)를 사용하지 않는 조인문
--  지정한 컬럼 값이 일치하는 경우가 아닌, **값의 범위**에 포함되는 행들을 연결하는 방식

SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);


---------------------------------------------------------------------------------------------------------------

-- 5. 자체 조인(SELF JOIN)

-- 같은 테이블을 조인.
-- 자기 자신과 조인을 맺음
-- TIP! 같은 테이블 2개 있다고 생각하고 JOIN을 진행

-- 1) 안시 기준
SELECT A.EMP_ID, A.EMP_NAME, NVL(A.MANAGER_ID, '없음'), NVL(B.EMP_NAME,'-')
FROM EMPLOYEE A
LEFT JOIN EMPLOYEE B ON(A.MANAGER_ID = B.EMP_ID);

-- 2) 오라클 기준
SELECT A.EMP_ID, A.EMP_NAME, NVL(A.MANAGER_ID, '없음'), NVL(B.EMP_NAME,'-')
FROM EMPLOYEE A, EMPLOYEE B
WHERE A.MANAGER_ID = B.EMP_ID(+);


---------------------------------------------------------------------------------------------------------------

-- 6. 자연 조인(NATURAL JOIN)
-- 동일한 타입과 이름을 가진 컬럼이 있는 테이블 간의 조인을 간단히 표현하는 방법
-- 반드시 두 테이블 간의 동일한 컬럼명, 타입을 가진 컬럼이 필요
--> 없을 경우 교차조인이 됨.
SELECT EMP_NAME, JOB_NAME
FROM EMPLOYEE
-- JOIN JOB USING(JOB_CODE);
NATURAL JOIN JOB;


SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
NATURAL JOIN DEPARTMENT; --> 교차 조인


---------------------------------------------------------------------------------------------------------------

-- 7. 다중 조인
-- N개의 테이블을 조회할 때 사용  (순서 중요!)
-- 위에서 아래로 차례대로 진행 -> 조인된 결과에 새로운 테이블 내용을 조인

--  사원 이름,   부서명,      지역명    조회
--  EMPLOYEE,  DEPARTMENT,  LOCATION

-- 1) 안시 기준 
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);

-- 2) 오라클 기준
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID AND LOCATION_ID = LOCAL_CODE; -- AND 없으면 교차조인남


--[다중 조인 연습 문제]

-- 직급이 대리(JOB, JOB_CODE = J6)이면서 아시아 지역(LOCATION, LOCAL_CODE = L1, L2, L3)에 근무하는 직원 조회
-- 사번, 이름, 직급명, 부서명, 근무지역명, 급여를 조회하세요

-- 안시
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY  
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
WHERE JOB_CODE = 'J6' 
AND LOCAL_NAME LIKE 'ASIA%';

-- 오라클
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY  
FROM EMPLOYEE E, JOB J, DEPARTMENT, LOCATION
WHERE E.JOB_CODE = J.JOB_CODE
AND DEPT_ID = DEPT_CODE 
AND LOCATION_ID = LOCAL_CODE
AND J.JOB_CODE = 'J6'
AND LOCAL_NAME LIKE 'ASIA%';

---------------------------------------------------------------------------------------------------------------


-- [연습문제]

-- 1. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 '전'씨인 직원들의 
-- 사원명, 주민번호, 부서명, 직급명을 조회하시오.

-- 1) 안시
SELECT EMP_NAME 사원명, EMP_NO 주민번호, DEPT_TITLE 부서명, JOB_NAME 직급명
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE)
WHERE EMP_NAME LIKE '전%'
AND SUBSTR(EMP_NO, 1, 1) = 7
AND SUBSTR(EMP_NO, 8, 1) = 2;

-- 2) 오라클
SELECT E.EMP_NAME 사원명, E.EMP_NO 주민번호, D.DEPT_TITLE 부서명, J.JOB_NAME 직급명
FROM EMPLOYEE E, DEPARTMENT D, JOB J 
WHERE D.DEPT_ID = E.DEPT_CODE AND E.JOB_CODE = J.JOB_CODE 
AND E.EMP_NAME LIKE '전%'
AND SUBSTR(EMP_NO, 1, 1) = 7
AND SUBSTR(EMP_NO, 8, 1) = 2;


-- 2. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 직급명(JOB, JOB_CODE), 부서명((DEPARTMENT, DEPT_TITLE)을 조회하시오.
-- 1) 안시
SELECT EMP_ID 사번, EMP_NAME 사원명, JOB_NAME 직급명, DEPT_TITLE 부서명 
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE) --NATURAL JOIN JOB도 가능
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_NAME LIKE('%형%');

-- 2) 오라클
SELECT E.EMP_ID 사번, E.EMP_NAME 사원명, J.JOB_NAME 직급명, D.DEPT_TITLE 부서명 
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID 
AND E.JOB_CODE = J.JOB_CODE 
AND EMP_NAME LIKE('%형%');
 


-- 3. 해외영업 1부(DEPARTMENT, DEPT_ID, D5), 2부(D6)에 근무하는 사원의 
-- 사원명, 직급명(JOB, JOB_NAME), 부서코드, 부서명(DEPARTMENT, DEPT_TITLE)을 조회하시오.
-- 1) 안시
SELECT EMP_NAME 사원명, JOB_NAME 직급명, DEPT_CODE 부서코드, DEPT_TITLE 부서명
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE)
WHERE DEPT_ID IN('D5', 'D6');

-- 2) 오라클
SELECT EMP_NAME 사원명, JOB_NAME 직급명, DEPT_CODE 부서코드, DEPT_TITLE 부서명
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE D.DEPT_ID = E.DEPT_CODE
AND E.JOB_CODE = J.JOB_CODE
AND DEPT_ID IN('D5', 'D6');


--4. 보너스포인트를 받는 직원들의 
--사원명, 보너스포인트, 부서명, 근무지역명(LOCATION, LOCAL_NAME)을 조회하시오.
-- 1) 안시
SELECT EMP_NAME 사원명, BONUS 보너스, DEPT_TITLE 부서, LOCAL_NAME 근무지역
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE) -- 아우터 해주어야함
FULL JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
WHERE BONUS IS NOT NULL;

-- 2) 오라클
SELECT EMP_NAME 사원명, BONUS 보너스, DEPT_TITLE 부서, LOCAL_NAME 근무지역
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE D.DEPT_ID(+) = E.DEPT_CODE
AND D.LOCATION_ID = L.LOCAL_CODE(+) 
AND BONUS IS NOT NULL;


--5. 부서가 있는 사원의 사원명, 직급명, 부서명, 지역명 조회
-- 1) 안시
SELECT EMP_NAME 사원명, JOB_NAME 직급명, DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
WHERE DEPT_CODE IS NOT NULL;

-- 2) 오라클
SELECT EMP_NAME 사원명, JOB_NAME 직급명, DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE E.JOB_CODE = J.JOB_CODE 
AND D.DEPT_ID = E.DEPT_CODE 
AND D.LOCATION_ID = L.LOCAL_CODE 
AND DEPT_CODE IS NOT NULL;


-- 6. 급여등급별 최소급여(MIN_SAL)를 초과해서 받는 직원들의
--사원명, 직급명, 급여, 연봉(보너스포함)을 조회하시오.
--연봉에 보너스포인트를 적용하시오.
-- SALARY * (1 + NVL(BONUS,0) ) * 12 연봉
-- 1) 안시
SELECT EMP_NAME 사원명, JOB_NAME 직급명, SALARY 급여, (SALARY * (1 + NVL(BONUS,0) ) * 12) 연봉
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN SAL_GRADE ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);

SELECT EMP_NAME 사원명, JOB_NAME 직급명, SALARY 급여, (SALARY * (1 + NVL(BONUS,0) ) * 12) 연봉
FROM EMPLOYEE
NATURAL JOIN JOB
JOIN SAL_GRADE USING (SAL_LEVEL)
WHERE SALARY > MIN_SAL;


-- 2) 오라클
--SELECT EMP_NAME 사원명, JOB_NAME 직급명, SALARY 급여, (SALARY * (1 + NVL(BONUS,0) ) * 12) 연봉
--FROM EMPLOYEE E, JOB J, SAL_GRADE S
--WHERE E.JOB_CODE = J.JOB_CODE
--AND S.SAL_LEVEL BETWEEN S.MIN_SAL AND S.MAX_SAL;


-- 7.한국(KO)과 일본(JP)에 근무하는 직원들의 
-- 사원명, 부서명, 지역명, 국가명(NATIONAL_CODE)을 조회하시오.
-- 1) 안시
SELECT EMP_NAME 사원명, DEPT_TITLE 부서명, LOCAL_NAME 지역명, NATIONAL_NAME 국가명
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국'
OR NATIONAL_NAME = '일본';

-- 2) 오라클
SELECT EMP_NAME 사원명, DEPT_TITLE 부서명, LOCAL_NAME 지역명, NATIONAL_NAME 국가명
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE D.DEPT_ID = E.DEPT_CODE 
AND D.LOCATION_ID = L.LOCAL_CODE 
AND N.NATIONAL_CODE = L.NATIONAL_CODE 
AND NATIONAL_NAME IN('한국', '일본');


-- 8. 같은 부서에 근무하는 직원들의
--  사원명, 부서코드, 동료이름을 조회하시오.
-- SELF JOIN 사용
-- 1) 안시
SELECT A.EMP_NAME 사원명, A.DEPT_CODE 부서코드, B.EMP_NAME 동료이름
FROM EMPLOYEE A
JOIN EMPLOYEE B ON (A.DEPT_CODE = B.DEPT_CODE)
WHERE A.EMP_NAME != B.EMP_NAME 
ORDER BY A.EMP_NAME;

-- 2) 오라클
SELECT A.EMP_NAME 사원명, A.DEPT_CODE 부서코드, B.EMP_NAME 동료이름
FROM EMPLOYEE A, EMPLOYEE B
WHERE A.DEPT_CODE = B.DEPT_CODE
AND A.EMP_NAME != B.EMP_NAME 
ORDER BY A.EMP_NAME ;


-- 9. 보너스포인트가 없는 직원들 중에서 
--  직급코드가 J4와 J7인 직원들의 
--  사원명, 직급명, 급여를 조회하시오.
--  단, JOIN, IN 사용할 것
-- 1) 안시
SELECT EMP_NAME 사원명, JOB_NAME 직급명, SALARY 급여
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_CODE IN ('J4', 'J7')
AND BONUS IS NULL
ORDER BY 직급명 DESC;

-- 2) 오라클
SELECT EMP_NAME 사원명, JOB_NAME 직급명, SALARY 급여
FROM EMPLOYEE E, JOB J 
WHERE E.JOB_CODE = J.JOB_CODE 
AND E.JOB_CODE IN ('J4', 'J7')
AND BONUS IS NULL
ORDER BY 직급명 DESC;




