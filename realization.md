# Витрина RFM

## 1.1. Выясните требования к целевой витрине.

-----------

{Что сделать: Создать витрину для RFM анализа. Схема и название - analysis.dm_rfm_segments.
Зачем: На основе RFM анализа выбирают клиентские категории, на которые стоит направить маркетинговые усилия.
Какой период: с начала 2022 года, без обновлений
Какие поля включить:
user_id - уникальный идентификатор клиента
recency - сколько времени прошло с момента последнего заказа (число от 1 до 5)
frequency - количество заказов (число от 1 до 5),
monetary_value - сумма затрат клиента (число от 1 до 5).
Особенности: Включать только выполненные заказы (статус заказа - closed)
Правила RFM-сегментации:
Присвойте каждому клиенту три значения — значение фактора Recency, значение фактора Frequency и значение фактора Monetary:
Фактор Recency измеряется по последнему заказу. Распределите клиентов по шкале от одного до пяти, где значение 1 получат те, кто либо вообще не делал заказов, либо делал их очень давно, а 5 — те, кто заказывал относительно недавно.
Фактор Frequency оценивается по количеству заказов. Распределите клиентов по шкале от одного до пяти, где значение 1 получат клиенты с наименьшим количеством заказов, а 5 — с наибольшим.
Фактор Monetary оценивается по потраченной сумме. Распределите клиентов по шкале от одного до пяти, где значение 1 получат клиенты с наименьшей суммой, а 5 — с наибольшей.
Проверьте, что количество клиентов в каждом сегменте одинаково. Например, если в базе всего 100 клиентов, то 20 клиентов должны получить значение 1, ещё 20 — значение 2 и т. д.}



## 1.2. Изучите структуру исходных данных.

{См. задание на платформе}

-----------

{Нужны таблицы хранящие инфу о заказах, продуктах и клиентах, на их основе вычисляется RFM, более подробно использованные поля см. в скрипте на создание вью.}


## 1.3. Проанализируйте качество данных

{См. задание на платформе}
-----------

{- Проверка MIN, MAX, AVG для сумм
- Проверка на отклоняющиеся значения (неправильное значения, отрицательные значения где их быть не должно и тд)
- Проверка на дубли
В результате: проблем с качеством данных не обнаружено. }


## 1.4. Подготовьте витрину данных

{См. задание на платформе}
### 1.4.1. Сделайте VIEW для таблиц из базы production.**

{См. задание на платформе}
```SQL
CREATE OR REPLACE VIEW ANALYSIS.ORDERS AS
(
SELECT
    ORDER_ID,
    ORDER_TS,
    USER_ID,
    BONUS_PAYMENT,
    PAYMENT,
    COST,
    BONUS_GRANT,
    STATUS
FROM PRODUCTION.ORDERS
);

CREATE OR REPLACE VIEW ANALYSIS.ORDERITEMS AS
(
SELECT
    ID,
    PRODUCT_ID,
    ORDER_ID,
    NAME,
    PRICE,
    DISCOUNT,
    QUANTITY
FROM PRODUCTION.ORDERITEMS
);

CREATE OR REPLACE VIEW ANALYSIS.ORDERSTATUSES AS
(
SELECT
    ID,
    KEY
FROM PRODUCTION.ORDERSTATUSES
);

CREATE OR REPLACE VIEW ANALYSIS.PRODUCTS AS
(
SELECT
    ID,
    NAME,
    PRICE
FROM PRODUCTION.PRODUCTS
);

CREATE OR REPLACE VIEW ANALYSIS.USERS AS
(
SELECT
    ID,
    NAME,
    LOGIN
FROM PRODUCTION.USERS
);


```

### 1.4.2. Напишите DDL-запрос для создания витрины.**

{См. задание на платформе}
```SQL
CREATE TABLE ANALYSIS.DM_RFM_SEGMENTS
(
USER_ID INT NOT NULL REFERENCES PRODUCTION.USERS(ID),
RECENCY INT NOT NULL CHECK (RECENCY BETWEEN 1 AND 5),
FREQUENCY INT NOT NULL CHECK (FREQUENCY BETWEEN 1 AND 5), 
MONETARY_VALUE INT NOT NULL CHECK (MONETARY_VALUE BETWEEN 1 AND 5),
PRIMARY KEY (USER_ID)
)
;


```

### 1.4.3. Напишите SQL запрос для заполнения витрины

{См. задание на платформе}
```SQL
INSERT INTO ANALYSIS.DM_RFM_SEGMENTS 
SELECT
    R.USER_ID
    ,R.RECENCY
    ,F.FREQUENCY
    ,M.MONETARY_VALUE
FROM ANALYSIS.TMP_RFM_RECENCY R
JOIN ANALYSIS.TMP_RFM_FREQUENCY F
    ON R.USER_ID = F.USER_ID
JOIN ANALYSIS.TMP_RFM_MONETARY_VALUE M 
    ON R.USER_ID = M.USER_ID
;



```



