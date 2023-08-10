-- 데이터 딕셔너리(DATA DICTIONARY)

-- 자원을 효율적으로 관리하기 위한 다양한 정보를 저장하는 시스템 테이블
-- 데이터 딕셔너리는 사용자가 테이블을 생성하거나, 사용자를 변경하는 등의
-- 작업을 할 때 데이터베이스 서버에 의해 자동으로 갱신되는 테이블

-- > USER_TABLES : 자신의 계정이 소유한 객체 등에 관한 정보를 조회할 수 있는 딕셔너리 뷰
SELECT * FROM USER_TABLES;

-----------------------------------------------------------------------------------------------

-- DQL(DATA QUERY LANGUAGE) : 데이터 조회 언어  - SELECT
-- DML(DATA MANIPULATION LANGUAGE) : 데이터 조작 언어  - INSERT, UPDATE, DELETE 
-- TCL(TRANSACTION CONTOL LANGUAGE) : 트랜잭션 제어 언어 - COMMIT, ROLLBACK, SAVEPOINT 

-- ** DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어 
-- 		객체(OBJECT)를 만들고(CREATE), 수정(ALTER), 삭제(DROP) 등 
-- 		데이터의 전체 구조를 정의하는 언어
--		DB 관리자나 설계자가 사용

--		ORACLE에서의 객체 : "테이블, 뷰, 시퀀스, 인덱스", 패키지, 트리거, 
--							프로시져, 함수(FUCTION), 동의어(SYNONYM), 사용자(USER) 등

-----------------------------------------------------------------------------------------------

-- 1. CREATE

-- 테이블이나 인덱스, 뷰 등 다양한 데이터베이스 객체를 생성하는 구문
-- 테이블로 생성된 객체는 DROP 구문을 통해 제거 가능

-- 1) 테이블 생성
--		TABLE : 행(ROW)과 열(COLUMN)으로 구성되는 가장 기본적인 DB 객체
-- 		데이터베이스 내에서 모든 데이터는 테이블을 통해 저장

-- [표현식]
-- CREATE TABLE 테이블명 (
--	컬럼명 자료형 크기,
--	컬럼명 자료형 크기,
--	... );

-- [자료형]
-- NUMBER - 숫자형(정수, 실수)
-- CHAR(크기) - 고정길이 문자형(최대 2,000바이트)
--				EX) CHAR(10) 컬럼에 3바이트 저장해도 10바이트 공간 모두 사용
-- VARCHAR2(크기) - 가변길이 문자형(최대 4,000바이트)
--					EX) VARCHAR2(10) 컬럼에 3바이트 저장하면 나머지 7바이트는 반환
-- DATE - 날짜
-- BLOB - 대용량 이진 데이터(4GB)
-- CLOB - 대용량 문자 데이터(4GB) - 웹소설, 긴 게시판 등에 활용

-- MEMBER 테이블 생성
CREATE TABLE MEMBER(
	MEMBER_ID VARCHAR2(20),
	MEMBER_PWD VARCHAR2(20),
	MEMBER_NAME VARCHAR2(30),
	MEMBER_SSD CHAR(14),
	ENROLL_DATE DATE DEFAULT SYSDATE		
);

SELECT * 
FROM MEMBER;

-- SQL 작성법 : 대문자 작성 권장, 띄어쓰기는 ' _ ' 사용
-- 문자 인코딩 UTF-8 : 영어, 숫자 1BYTE, 한글,(특수문자도 대부분) 3BYTE로 취급

---------------------------------------------------------------------------------------------

-- 2. 컬럼에 주석달기

--	[표현식]
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';

COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD  IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME  IS '회원 이름';
COMMENT ON COLUMN MEMBER.MEMBER_SSD  IS '회원 주민등록번호';
COMMENT ON COLUMN MEMBER.ENROLL_DATE IS '회원가입 일';

----------------------------------------------------------------------------------------------

-- SAMPLE 데이터 삽입
INSERT INTO "MEMBER" VALUES('MEM01', '123ABC', '홍길동', '980224-1564876', DEFAULT);

-- INSERT / UPDATE 시 컬럼 값으로 DEFAULT를 작성하면
-- 테이블 생성 시 해당 컬럼에 지정된 DEFAULT 값으로 삽입된다.

INSERT INTO "MEMBER" VALUES('MEM02', '456ABC', '박철수', '920224-1564876', DEFAULT);
INSERT INTO "MEMBER" VALUES('MEM03', '789ABC', '김명희', '951115-1458876', SYSDATE);
INSERT INTO "MEMBER" (MEMBER_ID, MEMBER_PWD, MEMBER_NAME) VALUES ('MEM04', '416BVD', '이지연');

ROLLBACK;
COMMIT;

-- ** JDBC에서 날짜를 입력받았을때 삽입하는 방법 **
INSERT INTO "MEMBER" VALUES('MEM05', 'JJKKLL', '김길동', '950615-1457876', 
							   TO_DATE('2022-09-13 17:33:27', 'YYYY-MM-DD HH24:MI:SS'));

----------------------------------------------------------------------------------------------------							  
							  
-- ** NUMBER 타입의 문제점
CREATE TABLE MEMBER2(
	MEMBER_ID VARCHAR2(20),
	MEMBER_PWD VARCHAR2(20),
	MEMBER_NAME VARCHAR2(30),
	MEMBER_TEL NUMBER
);

INSERT INTO MEMBER2 VALUES('MEM01', 'PASS01', '고길동', '7712341234');
INSERT INTO MEMBER2 VALUES('MEM02', 'PASS02', '고길순', '01012341234');
SELECT * FROM MEMBER2;

-- 넘버 타입 걸럼에 데이터 삽입 시 
-- 제일 앞에 0이 있으면 자동 제거
-- SO, 전화번호, 주민등록번호 처럼 숫자 데이터도 0으로 시작하는 가능성이 있으면 CHAR OR VARCHAR 권장

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------


-- 제약 조건(CONSTRAINTS)
-- : 사용자가 원하는 조건의 데이터만 유지하기 위해서 특정 컬럼에 설정하는 제약

-- [목적]
-- 데이터 무결성
-- 입력 데이터에 문자가 없는지 자동으로 검사
-- 데이터의 수정/삭제 가능 여부 검사 등
-- 		> 제약조건을 위배하는 DML구문은 수행할 수 없다.

-- [종류]
-- PRIMARY KEY, NOT NULL, UNIQUE, CHECK, FOREIGN KEY

--------------------------------------------------------------------------------------------------------

-- 1) NOT NULL 
--	해당 컬럼에 반드시 값이 기록되어야 함.
--	삽입/수정 시 NULL값 허용하지 않게 컬럼 레벨에서 제약조건 설정
CREATE TABLE USER_USED_NN(
	USER_NUMBER NUMBER NOT NULL, <-- 컬럼 레벨
	USER_ID VARCHAR2(20),
	USER_PWD VARCHAR2(30),
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50)
					  <-- 테이블 레벨
);

INSERT INTO USER_USED_NN VALUES(1, 'USER01', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
INSERT INTO USER_USED_NN VALUES(NULL, NULL, NULL, NULL, NULL, '010-7712-1234', 'kd-park@KH.OR.kr'); -- NOT NULL 위배

---------------------------------------------------------------------------------------------------------------------------

-- 2) UNIQUE
--	컬럼에 입력값에 대해 중복을 제한하는 제약조건
-- 	컬럼레벨 AND 테이블 레벨에서 설정 가능 -> 단, UNIQUE조건 설정 컬럼에 NULL값은 중복 가능
--				** 테이블 레벨 : 테이블 생성 시 컬럼 설정 끝난 후 마지막 
--		컬럼 레벨에서 작성시 : [CONSTRAINTS 제약조건명] 제약조건
--   	테이블 레벨에서 작성시 : [CONSTRAINTS 제약조건명] 제약조건(컬럼명)

CREATE TABLE USER_USED_UK(
	USER_NUMBER NUMBER, 
	USER_ID VARCHAR2(20),  
--	USER_ID VARCHAR2(20) UNIQUE, <-- 컬럼 레벨 제약 (제약조건명 미지정)   
--	USER_ID VARCHAR2(20) CONSTRAITS USER_ID_U UNIQUE, <-- 컬럼 레벨 제약 (제약조건명 지정)   
	USER_PWD VARCHAR2(30),
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
--	UNIQUE(USER_ID)				  <-- 테이블 레벨 제약(제약조건명 미지정)
--	CONSTRAINTS USER_ID_U UNIQUE(USER_ID)				  <-- 테이블 레벨 제약(제약조건 미지정)
	CONSTRAINTS USER_ID_U UNIQUE(USER_ID)				 -- <-- 테이블 레벨 제약(제약조건 미지정)
);

INSERT INTO USER_USED_UK VALUES(1, 'USER01', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
INSERT INTO USER_USED_UK VALUES(1, 'USER01', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
-- SQL Error [1] [23000]: ORA-00001: 무결성 제약 조건(KH.USER_ID_U)에 위배됩니다.

INSERT INTO USER_USED_UK VALUES(1, NULL, 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
INSERT INTO USER_USED_UK VALUES(1, NULL, 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
-- NULL 값이면 중복 입력 가능

SELECT * FROM USER_USED_UK;

-------------------------------------------------------------------------------------------------------------------------

-- UNIQUE 복합키
-- 두 개 이상의 컬럼을 묶어서 하나의 UNIQUE 제약 조건을 설정
-- ** 복합키 지정은 테이블 레벨에서만 가능
-- ** 복합키는 지정되는 모든 컬럼의 값이 같을 때 위배 -> 

CREATE TABLE USER_USED_UK2(
	USER_NUMBER NUMBER, 
	USER_ID VARCHAR2(20),  
	USER_PWD VARCHAR2(30),
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
	CONSTRAINTS USER_ID_NAME_U UNIQUE(USER_ID, USER_NAME)	
);
SELECT * FROM USER_USED_UK2;

INSERT INTO USER_USED_UK2 VALUES(1, 'USER01', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
INSERT INTO USER_USED_UK2 VALUES(1, 'USER02', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
INSERT INTO USER_USED_UK2 VALUES(1, 'USER01', 'PASS01', '고길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
-- 아이디 네임  두개 중 하나라도 틀리면 생성 가능

INSERT INTO USER_USED_UK2 VALUES(1, 'USER01', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
-- 불가

-------------------------------------------------------------------------------------------------------------------------

-- 3) PRIMARY KEY(기본ㅋ) 제약조건
-- 테이블에서 한 행의 정보를 찾기 위해 사용할 컬럼을 의미
-- 테이블에 대한 식별자(학번, 사번 등)의 역할

-- 		'NOT NULL + UNIQUE'의 성격 --> 중복되지 않는 값이 필수로 존재해야함.

-- 한 테이블당 한개만 설정 가능
-- 컬럼 레벨, 테이블 레벨에서 설정 가능
-- 한개 혹은 여러개 컬럼을 묶어서 설정 가능

CREATE TABLE USER_USED_PK(
	USER_NO NUMBER CONSTRAINT USER_NO_PK PRIMARY KEY,    -- 컬럼 레벨 
	USER_ID VARCHAR2(20),  
	USER_PWD VARCHAR2(30),
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50)
--	CONSTRAINTS USER_NO PRIMARY KEY(USER_NO)	-- 테이블 레벨
);

SELECT * FROM USER_USED_PK;

INSERT INTO USER_USED_PK VALUES(1, 'USER02', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
INSERT INTO USER_USED_PK VALUES(1, 'USER01', 'PASS01', '고길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
-- 넘버 겹침

INSERT INTO USER_USED_PK VALUES(NULL, 'USER01', 'PASS01', '고길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
-- NULL도 안됨

-----------------------------------------------------------------------------------------------------------------------

-- PRIMARY 복합키 (테이블 레벨에서만 가능)
CREATE TABLE USER_USED_PK2(
	USER_NO NUMBER,  
	USER_ID VARCHAR2(20),  
	USER_PWD VARCHAR2(30),
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
	CONSTRAINTS USER_NO_ID_PK PRIMARY KEY(USER_NO, USER_ID)	-- 테이블 레벨
);

SELECT * FROM USER_USED_PK2;

INSERT INTO USER_USED_PK2 VALUES(1, 'USER02', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
INSERT INTO USER_USED_PK2 VALUES(2, 'USER02', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
INSERT INTO USER_USED_PK2 VALUES(1, 'USER01', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
-- 둘 중 하나라도 다르면 가능

INSERT INTO USER_USED_PK2 VALUES(1, 'USER02', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
-- 둘 다 같으면 안됨

INSERT INTO USER_USED_PK2 VALUES(NULL, 'USER03', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
-- NULL도 안됨

-------------------------------------------------------------------------------------------------------------------------

-- 4) FOREIGN KEY(외부키, 외래키)
--  참조된 다른 테이블의 컬럼이 제공하는 값만 사용할 수 있음
-- 	FOREIGN KEY제약조건에 의해서 테이블간 관계가 형성됨
-- 	제공하는 값 외에는 NULL(참조값 없음)을 사용할 수 있음

-- 컬럼레벨일 경우
--	 컬럼명 자료형(크기) [CONSTRAINT 이름] REFERENCES 참조할테이블명[(참조할 컬럼)][삭제룰]

-- 테이블레벨일 경우
-- [CONSTRAINT 이름] FOREIGN KEY (적용할 컬럼명) REFERENCES 참조할테이블명[(참조할 컬럼)][삭제룰]

-- * 참조될 수 있는 컬럼은 PRIMARY KEY컬럼과, UNIQUE 지정된 컬럼만 외래키로 사용가능
-- 	 참조할 테이블의 컬럼명이 생략되면, PRIMARY KEY로 설정된 컬럼이 자동 참조할 컬럼이 됨

CREATE TABLE USER_GRADE(
	GRADE_CODE NUMBER PRIMARY KEY,
	GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO USER_GRADE VALUES(10, '일반회원');
INSERT INTO USER_GRADE VALUES(20, '우수회원');
INSERT INTO USER_GRADE VALUES(30, '특별회원');

SELECT * FROM USER_GRADE;

CREATE TABLE USER_USED_FK(
	USER_NO NUMBER PRIMARY KEY,
	USER_ID VARCHAR2(20) UNIQUE,
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
	GRADE_CODE NUMBER CONSTRAINT GRADE_CODE_FK  -- 컬럼 레벨
					   REFERENCES USER_GRADE /*GRADE_CODE)*/ -- 컬럼명 미작성 시, 참조 테이블의 PRIMARY KEY 자동 참조 
--	CONSTRAINT GRADE_CODE_FK FOREIGN KEY(GRADE_CODE) REFERENCES USER_GRADE  -- 테이블 레벨
);

SELECT * FROM USER_USED_FK ;

INSERT INTO USER_USED_FK VALUES(1, 'USER01', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr', '10');
INSERT INTO USER_USED_FK VALUES(2, 'USER02', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr', '10');
INSERT INTO USER_USED_FK VALUES(3, 'USER03', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr', '30');
INSERT INTO USER_USED_FK VALUES(4, 'USER04', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr', NULL);
-- GRADE_CODE에 참조하고 있는 테이블의 10, 20, 30만 입력 가능 (NULL도 포함)

INSERT INTO USER_USED_FK VALUES(5, 'USER05', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr', '50');
-- 왜래키 제약조건 위배(부모키가 없습니다.)

------------------------------------------------------------------------------------------------------------------------

-- FOREIGN KEY 삭제 옵션
-- 부모테이블의 데이터 삭제 시 자식 테이블의 데이터를 어떤식으로 처리할 지 설정

-- 1) ON DELETE RESTRICTED(삭제 제한)로 기본 지정
--  > 외래키로 지정된 컬럼에서 사용되고 있는 값일 경우, 제공하는 걸럼의 값을 삭제하지 못함

DELETE FROM USER_GRADE WHERE GRADE_CODE ='10';
-- 삭제 불가 (자식 레코드가 발견되었습니다)

DELETE FROM USER_GRADE WHERE GRADE_CODE ='20';
-- 삭제 가능 (자식 사용 안하는중)


-- 2) ON DELETE SET NULL : 부모키 삭제시 자식키를 NULL로 변경

CREATE TABLE USER_GRADE2(
	GRADE_CODE NUMBER PRIMARY KEY,
	GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO USER_GRADE2 VALUES(10, '일반회원');
INSERT INTO USER_GRADE2 VALUES(20, '우수회원');
INSERT INTO USER_GRADE2 VALUES(30, '특별회원');

SELECT * FROM USER_GRADE2;

CREATE TABLE USER_USED_FK2(
	USER_NO NUMBER PRIMARY KEY,
	USER_ID VARCHAR2(20) UNIQUE,
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
	GRADE_CODE NUMBER CONSTRAINT GRADE_CODE_FK2 REFERENCES USER_GRADE2 ON DELETE SET NULL -- 부모에서 삭제시 NULL
);

SELECT * FROM USER_USED_FK2 ;

INSERT INTO USER_USED_FK2 VALUES(1, 'USER01', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr', '10');
INSERT INTO USER_USED_FK2 VALUES(2, 'USER02', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr', '10');
INSERT INTO USER_USED_FK2 VALUES(3, 'USER03', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr', '30');

DELETE FROM USER_GRADE2 WHERE GRADE_CODE ='10';


-- 3) ON DELETE CASCADE : 부모키 삭제시 값을 사용하는 자식키도 삭제

CREATE TABLE USER_GRADE3(
	GRADE_CODE NUMBER PRIMARY KEY,
	GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO USER_GRADE3 VALUES(10, '일반회원');
INSERT INTO USER_GRADE3 VALUES(20, '우수회원');
INSERT INTO USER_GRADE3 VALUES(30, '특별회원');

SELECT * FROM USER_GRADE3;

CREATE TABLE USER_USED_FK3(
	USER_NO NUMBER PRIMARY KEY,
	USER_ID VARCHAR2(20) UNIQUE,
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
	GRADE_CODE NUMBER CONSTRAINT GRADE_CODE_FK3 REFERENCES USER_GRADE3 ON DELETE CASCADE -- 부모에서 삭제시 자식도 삭제(행 전체가)
);

SELECT * FROM USER_USED_FK3 ;

INSERT INTO USER_USED_FK3 VALUES(1, 'USER01', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr', '10');
INSERT INTO USER_USED_FK3 VALUES(2, 'USER02', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr', '10');
INSERT INTO USER_USED_FK3 VALUES(3, 'USER03', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr', '30');

DELETE FROM USER_GRADE3 WHERE GRADE_CODE ='10';

----------------------------------------------------------------------------------------------------------------------------------------------

-- 5. CHECK 제약 조건 : 컬럼에 기록되는 값에 조건 설정을 할 수 있음.
-- CHECK (컬럼명 비교연산자 비교값)
-- 	* 주의 : 비교값은 리터럴만 사용할 수 있음. 변하는 값이나 함수 사용 못함

CREATE TABLE USER_USED_CHECK(
	USER_NO NUMBER PRIMARY KEY,
	USER_ID VARCHAR2(20) UNIQUE,
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10) CONSTRAINT GENDER_CHECK CHECK(GENDER IN('남', '여')),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50)
);

INSERT INTO USER_USED_CHECK VALUES(1, 'USER03', 'PASS01', '박길동', '남', '010-7712-1234', 'kd-park@KH.OR.kr');

INSERT INTO USER_USED_CHECK VALUES(2, 'USER03', 'PASS01', '박길동', '남자', '010-7712-1234', 'kd-park@KH.OR.kr');
-- 체크 제약조건(KH.GENDER_CHECK)이 위배되었습니다.
-- GENDER에 '남', '여' 만 입력 가능

-- ** CHECK는 범위로도 설정 가능
-- EX) CHECK(COL > 0 AND COL < 10);

------------------------------------------------------------------------------------------------------------------------------------------

-- [연습문제]
-- 각 컬럼 제약 조건에 이름 부여
-- 5명 이상 INSERT

CREATE TABLE USER_TEST(
	USER_NO NUMBER CONSTRAINT PK_USER_TEST PRIMARY KEY, -- 기본키
	USER_ID VARCHAR2(20) CONSTRAINT USER_ID_UK UNIQUE, -- 중복금지 UNIQUE 
	USER_PWD VARCHAR2(30) CONSTRAINT NN_USER_PWD NOT NULL, -- NULL값 허용 안함 NOT NULL 	
	PNO CHAR(20) CONSTRAINT NN_PNO NOT NULL, -- 중복금지, NULL 허용 안함 UNIQUE + NOT NULL
	GENDER VARCHAR2(20) CONSTRAINT GENDER_CHECK CHECK(GENDER IN ('남', '여')), -- '남' 혹은 '여'로 입력 CHECK
	PHONE VARCHAR2(20),
	ADDRESS VARCHAR2(50),
	STATUS CHAR(10) DEFAULT 'N' CONSTRAINT NN_STATUS NOT NULL, 
	CONSTRAINT STATUS_CHECK CHECK(STATUS IN ('Y', 'N')),	-- NOT NULL, CHECK;
	CONSTRAINTS PK_PNO UNIQUE (PNO)
);

COMMENT ON COLUMN USER_TEST.USER_NO IS '회원번호';
COMMENT ON COLUMN USER_TEST.USER_ID IS '회원 아이디';
COMMENT ON COLUMN USER_TEST.USER_PWD IS '비밀번호';
COMMENT ON COLUMN USER_TEST.PNO IS '주민등록번호';
COMMENT ON COLUMN USER_TEST.GENDER IS '성별';
COMMENT ON COLUMN USER_TEST.PHONE IS '전화번호';
COMMENT ON COLUMN USER_TEST.ADDRESS IS '주소';
COMMENT ON COLUMN USER_TEST.STATUS IS '탈퇴여부';

INSERT INTO USER_TEST VALUES(1, 'USER01', 'PASS01', '981102-15481358', '남', '010-7712-1234', '서울시 도봉구', 'N');
INSERT INTO USER_TEST VALUES(2, 'USER02', 'PASS02', '050102-22415658', '여', '010-7712-1234', '서울시 도봉구', 'N');
INSERT INTO USER_TEST VALUES(3, 'USER03', 'PASS03', '951102-20156458', '여', '010-7712-1234', '서울시 도봉구', 'Y');
INSERT INTO USER_TEST VALUES(4, 'USER04', 'PASS04', '610202-15412358', '남', '010-7712-1234', '서울시 도봉구', 'N');
INSERT INTO USER_TEST VALUES(5, 'USER05', 'PASS05', '000402-11548358', '남', '010-7712-1234', '서울시 도봉구', 'N');

SELECT * FROM USER_TEST;

----------------------------------------------------------------------------------------------------------------------------------

-- 8. 서브쿼리를 이용한 테이블 생성
-- 컬럼명, 데이터 타입, 값이 복사 -> 제약조건은 NOT NULL만 복사

-- 1) 테이블 전체 복사
CREATE TABLE EMPLOYEE_COPY
AS SELECT * FROM EMPLOYEE;
--> 서브쿼리의 조회 결과의 모양대로 테이블이 생성

SELECT * FROM EMPLOYEE_COPY;


-- 2) JOIN 후 원하는 컬럼만 테이블로 복사
CREATE TABLE EMPLOYEE_COPY2
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);

SELECT * FROM EMPLOYEE_COPY2;


--> 서브쿼리로 테이블 생성시 테이블의 형태(컬럼명, 데이터타입) + NOT NULL 까지는 복사 가능
-- 이외의 제약조건, COMMENT 등은 복사되지 않음
-- SO, 별도로 추가해주어야함.

-----------------------------------------------------------------------------------------------------------------------------------

-- 9. 제약조건 추가
-- ALTER TABLE 테이블명 ADD[CONSTRAINT 제약조건명] PRIMARY KEY (컬럼명); -- 프라이머리 키 추가
-- ALTER TABLE 테이블명 ADD[CONSTRAINT 제약조건명] FOREIGN KEY (컬럼명) REFERENCES 참조테이블명(참조컬럼명); -- 외래 키 추가
-- ALTER TABLE 테이블명 ADD[CONSTRAINT 제약조건명] UNIQUE (컬럼명); 
-- ALTER TABLE 테이블명 ADD[CONSTRAINT 제약조건명] CHECK (컬럼명 비교연산자 비교값); 


-- EMP_ID 컬럼에 PRIMARY KEY 추가하기
ALTER TABLE EMPLOYEE_COPY2 ADD CONSTRAINT PK_EMP_COPY PRIMARY KEY(EMP_ID);

-- EMPLOYEE 테이블의 DEPT_CODE에 외래키 제약조건 추가
-- 참조 테이블은 DEPARTMENT
-- 참조 컬럼은 DEPARTMENT 기본키
ALTER TABLE EMPLOYEE ADD CONSTRAINT EMP_DEPT_CODE FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT ON DELETE SET NULL;

-- EMPLOYEE 테이블의 SAL_LEVEL 왜래키 제약조건 추가
-- 참조 테이블은 SAL_GRADE 
-- 참조 컬럼은 SAL_GRADE의 기본키
ALTER TABLE EMPLOYEE ADD CONSTRAINT EMP_SAL_LEVEL FOREIGN KEY(SAL_LEVEL) REFERENCES SAL_GRADE ON DELETE SET NULL;

-- DEPARTMENT 테이블의 LOCARION_ID에 외래키 제약조건 추가
-- 참조테이블은 LOCATION, 참조 컬럼은 LOCATION의 기본키
ALTER TABLE DEPARTMENT ADD CONSTRAINT DEPT_LOCATION_ID FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION ON DELETE SET NULL;

-- LOCATION 테이블의 NATIONAL_CODE에 외래키 제약조건 추가
-- 참조 테이블은 NATIONAL, 참조 컬럼은 NATIONAL의 기본키
ALTER TABLE LOCATION ADD CONSTRAINT LOC_NTL_CODE FOREIGN KEY(NATIONAL_CODE) REFERENCES NATIONAL ON DELETE SET NULL;



