CREATE TABLE TEST06 ( YMD VARCHAR2(08) NOT NULL, LEASE NUMBER,
  CONSTRAINT TEST06_PK PRIMARY KEY (YMD)
);
INSERT INTO TEST06 VALUES ('20010115', 21000000);
INSERT INTO TEST06 VALUES ('20010127', 24000000);
INSERT INTO TEST06 VALUES ('20010316', 24000000);
INSERT INTO TEST06 VALUES ('20010320', 21000000);
INSERT INTO TEST06 VALUES ('20010720', 23000000);
INSERT INTO TEST06 VALUES ('20010731', 22000000);
INSERT INTO TEST06 VALUES ('20010822', 23000000);
INSERT INTO TEST06 VALUES ('20010831', 22000000);
INSERT INTO TEST06 VALUES ('20010906', 22000000);
INSERT INTO TEST06 VALUES ('20010915', 22000000);
--2001년 1월 15일에 2,100,000원의 차입이 있은 이후 수시로 차입이 있었다.
--2001년 말에 1월부터 당시까지 있었던 차입금에 대한 이자를 계산하는데,
--매월 말일을 기준으로 계산해서 매월 말 지급 되었어야 할 이자를 알아낸다.
--단 이자에 대한 이자는 계산하지 않는다.
--2001년 01월 31일에는 20010115에 차이한 2,100,000원에 대한 31-15일 만큼의 이자와
--2001년 01월 27일에는 차입한 2,400,000원에 대한 31-27만큼의 이자를 더해서 발생시켜주고,
--2001년 02월 28일에는 2001년 1월에 차입한 2,100,000 + 2,400,000원에 대한 28일차의 이자를 발생시켜주며,
--2001년 03월 31일에는 1월에 차입한 4,500,000원에 대한 31일치의 이자와
--3월 16일에 차입한 2,400,000에 대한 31-16일 만큼의 이자와
--3월 20일에 차입한 2,400,000원에 대한 31-20만큼의 이자를 더해서 발생시켜주는 방식으로 계산을 해나간다.
--결국 1월에 차입한 금액에 대한 이자는 1월부터 12월까지 12번 발생하며, 2월은 11번 ..
--이런 식으로 12월에 차입한 금액은 12월에 한번만 발생되면 된다.
--이율은 년 12.5%이다.
SELECT LAST_DAY(A.YMD) YMD, B.NO,
        SUM(A.LEASE) 차입, 
        ROUND(SUM(DECODE(B.NO,SUBSTR(A.YMD,5,2),B.LL1,B.LL2))) 달이자,
        SUM(ROUND(SUM(DECODE(B.NO,SUBSTR(A.YMD,5,2),B.LL1,B.LL2))))
                            OVER (PARTITION BY LAST_DAY(A.YMD)
                             ORDER BY B.NO) 이자합,
        SUM(A.LEASE) +  SUM(ROUND(SUM(DECODE(B.NO,SUBSTR(A.YMD,5,2),B.LL1,B.LL2)))) 
                            OVER (PARTITION BY LAST_DAY(A.YMD)
                             ORDER BY B.NO) 차입플이자합
FROM TEST06 A,
    (SELECT C.NO, LAST_DAY(A.YMD), YMD, 
            ROUND((A.LEASE * (LAST_DAY('2019'||C.NO||'01')-TO_DATE('2019'||C.NO||'01'))) * (0.125/365)) LL2,
            ((LEASE * (LAST_DAY(YMD)-TO_DATE(YMD))) * (0.125/365)) LL1
    FROM TEST06 A, 
        (SELECT LPAD(NO,2,0) NO FROM T1_DATA WHERE NO<13) C) B
WHERE B.NO >= SUBSTR(A.YMD,5,2)
AND A.YMD = B.YMD
GROUP BY LAST_DAY(A.YMD), B.NO
ORDER BY 1,2;