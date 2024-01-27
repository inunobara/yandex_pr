CREATE OR REPLACE VIEW ANALYSIS.ORDERS
AS 
(
SELECT
    ORDERS.ORDER_ID,
    ORDERS.ORDER_TS,
    ORDERS.USER_ID,
    ORDERS.BONUS_PAYMENT,
    ORDERS.PAYMENT,
    ORDERS.COST,
    ORDERS.BONUS_GRANT,
    ST.STATUS_ID AS STATUS
FROM PRODUCTION.ORDERS ORDERS
JOIN (
      SELECT 
            ORDER_ID, 
            STATUS_ID, 
            ROW_NUMBER() OVER(PARTITION BY ORDER_ID ORDER BY DTTM DESC) AS RN
      FROM PRODUCTION.ORDERSTATUSLOG    
    ) ST ON ORDERS.ORDER_ID = ST.ORDER_ID
WHERE RN = 1    
);