--  DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어 
-- 		객체(OBJECT)를 만들고(CREATE), 수정(ALTER), 삭제(DROP) 등 

-- ** ALTER

-- 테이블에서 수정할 수 있는 것
-- 1) 제약 조건 (추가, 삭제)
-- 2) 컬럼(추가, 수정, 삭제)
-- 3) 이름 변경(테이블 명 OR 제약조건 명 OR 컬럼명)

------------------------------------------------------------------------------

-- 1. 제약조건(추가/삭제)

-- [작성법]
-- 	> 추가
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] 제약조건 (컬럼명);		<-기본 제약조건
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] 제약조건 (컬럼명) REFERENCES 참조테이블명(참조컬럼명) 	<- 외래키

--	> 삭제
--	ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

--		** 수정은 별도 존재하지 않음 --> 삭제 후 추가

-- DEPARTMENT 테이블 복사
CREATE TABLE DEPT_COPY AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

-- DEPT_COPY의 DEPT_TITLE에 UNIQUE 추가
ALTER TABLE DEPT_COPY ADD CONSTRAINT DEPT_COPY_TITLE_U UNIQUE(DEPT_TITLE); 

-- DEPT_COPY의 DEPT_TITLE에 UNIQUE 삭제
ALTER TABLE DEPT_COPY DROP CONSTRAINT DEPT_COPY_TITLE_U;

-- ** 제약조건 명을 설정하지 않은 경우 자동 생성 -> 테이블에서 직접 확인해야함



--  DEPT_COPY의 DEPT_TITLE에 NOT NULL 추가
ALTER TABLE DEPT_COPY ADD CONSTRAINT DEPT_COPY_TITLE_NN NOT NULL(DEPT_TITLE);
-- 실행 안됨

-- *** NOT NULL은 새로운 제약 조건을 추가하는 것이 아니라, 허용/비허용의 성격 -> MODIFY
-- EX) 스위치를 껐다 켰다 

ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE NOT NULL;
-- 킬때 
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE NULL;
-- 끌때

------------------------------------------------------------------------------------------------
SELECT * FROM DEPT_COPY;
INSERT INTO DEPT_COPY VALUES('D10', '개발1팀', 'L1', DEFAULT, DEFAULT);
ALTER TABLE DEPT_COPY ADD CONSTRAINT D_COPY_PK PRIMARY KEY(DEPT_ID);


-- 2. 컬럼 (추가, 수정, 삭제)

-- 컬럼 추가
-- ALTER TABLE 테이블명 ADD(컬럼명 데이터타입[DEFAULT '값']);
ALTER TABLE DEPT_COPY ADD (CNAME VARCHAR2(30));
ALTER TABLE DEPT_COPY ADD (LNAME VARCHAR2(30) DEFAULT '한국');

-- 컬럼 수정
-- ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입;    <- 데이터 타입 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_ID VARCHAR2(5);

-- ALTER TABLE 테이블명 MODIFY 컬럼명 DEFALUT '값';  <- 디폴트값 변경
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT 'KOREA'; --> 디폴트 변경 != 기존 데이터 변경

-- ALTER TABLE 테이블명 MODIFY 컬럼명 NULL(NOT NULL);     <- NULL 수정

-- 컬럼 삭제
-- ALTER TABLE 테이블명 DROP (컬럼명);
ALTER TABLE DEPT_COPY DROP(LNAME);

-- ALTER TABLE 테이블명 DROP COLUMN 컬럼명;
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
-- * 주의 사항 : 최소 1개의 컬럼이 남아야 하기 때문에, 모두 삭제 불가능

------------------------------------------------------------------------------------------------
SELECT * FROM DCOPY;

-- 3. 이름변경

-- 1) 컬럼명 변경 
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

-- 2) 제약조건명 변경
ALTER TABLE DEPT_COPY RENAME CONSTRAINT D_COPY_PK TO DEPT_COPY_PK;

-- 3) 테이블명 변경
ALTER TABLE DEPT_COPY RENAME TO DCOPY;

------------------------------------------------------------------------------------------------

-- 4. 테이블 삭제

-- DROP TABLE 테이블명 [CASCADE CONSTRAINTS];

-- 1) 관계형성 없을 때
DROP TABLE DCOPY;

-- 2) 관계 형성 테이블 삭제 
CREATE TABLE TABLE1(
	TB1_PK NUMBER PRIMARY KEY,
	TB1_COM NUMBER
);

CREATE TABLE TABLE2(
	TB2_PK NUMBER PRIMARY KEY,
	TB2_COM NUMBER REFERENCES TABLE1
);

INSERT INTO TABLE1 VALUES(1, 100);
INSERT INTO TABLE1 VALUES(2, 200);
INSERT INTO TABLE1 VALUES(3, 300);

INSERT INTO TABLE2 VALUES(11, 1);
INSERT INTO TABLE2 VALUES(22, 2);
INSERT INTO TABLE2 VALUES(33, 3);

DROP TABLE TABLE1;
-- 불가

-- 해결 방법
-- 1) 자식, 부모 순으로 삭제
-- 2) 제약조건 삭제 후 테이블 삭제(ALTER)
-- 3) DROP TABLE 삭제옵션 CASCADE CONSTRAINTS 사용 -> 삭제하려는 FK 제약조건 모두 삭제

DROP TABLE TABLE1 CASCADE CONSTRAINTS;

--------------------------------------------------------------------------------------------------------

-- DDL 주의 사항

-- 1) DDL은 COMMIT, ROLLBACK이 되지 않음 --> ALTER와 DROP을 신중히
-- 2) DDL과 DML 구문을 번갈아 쓰면 안됨 --> DDL이 자동 커밋되어버리기 떄문에 DML이 강제 COMMIT 되어버림

