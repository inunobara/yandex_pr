INSERT INTO ANALYSIS.TMP_RFM_FREQUENCY
SELECT 
    USERS.USER_ID
    ,NTILE(5) OVER(ORDER BY CNT) AS FREQUENCY
FROM (
    WITH ORDERS AS
    (
    SELECT
        USER_ID
        ,COUNT(ORDER_ID) AS CNT 
    FROM ANALYSIS.ORDERS O 
    WHERE STATUS = 4 AND CAST(ORDER_TS AS DATE) >= '2022-01-01'::DATE
    GROUP BY 1
    )
    SELECT
        U.ID AS USER_ID
        ,COALESCE(CNT, 0) AS CNT
    FROM ANALYSIS.USERS U
    LEFT JOIN ORDERS O ON U.ID = O.USER_ID
    ) USERS;