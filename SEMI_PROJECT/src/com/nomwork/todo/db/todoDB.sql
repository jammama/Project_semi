DROP SEQUENCE TODOSEQ;
DROP TABLE TODO;
CREATE SEQUENCE TODOSEQ;

CREATE TABLE TODO(
	TODONO NUMBER PRIMARY KEY,
	PROJECTNO NUMBER NOT NULL,
	TODOTITLE VARCHAR2(4000) NOT NULL,
	TODOCONTENT VARCHAR2(4000),
	TODODATE VARCHAR2(12),
	TODOREGDATE DATE NOT NULL,
CONSTRAINT TD_FK_PROJECTNO FOREIGN KEY(PROJECTNO) REFERENCES PROJECT(PROJECTNO)
);

INSERT INTO TODO
VALUES (TODOSEQ.NEXTVAL, 1,'테스트이벤트','일정내용없음','201901281550',SYSDATE);


