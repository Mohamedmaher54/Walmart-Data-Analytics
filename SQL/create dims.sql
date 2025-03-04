CREATE TABLE customer_dim (
    customer_id NUMBER PRIMARY KEY
);

CREATE TABLE date_dim (
    date_ DATE,
    date_id NUMBER PRIMARY KEY,
    year_ NUMBER,
    month_ NUMBER,
    day_ NUMBER
);
CREATE TABLE product_dim (

    product_name VARCHAR2(255),
     product_id NUMBER PRIMARY KEY,
    category VARCHAR2(255),
    sub_category VARCHAR2(255),
    price NUMBER
);
CREATE TABLE fact_table (
    customer_id NUMBER,
    date_id NUMBER,
    product_id NUMBER,
    transaction_id NUMBER not null,
    FOREIGN KEY (customer_id) REFERENCES customer_dim(customer_id),
    FOREIGN KEY (date_id) REFERENCES date_dim(date_id),
    FOREIGN KEY (product_id) REFERENCES product_dim(product_id)
);

drop table fact_table;
drop table product_dim;
drop table date_dim;


select * from product_dim;
select count(*) from date_dim
;
select * from fact_table;
ALTER TABLE fact_table
ADD quantity NUMBER DEFAULT 1;
 

SELECT 
    sf1.product_id AS product_1,
    sf2.product_id AS product_2,
    COUNT(*) AS times_bought_together
FROM 
    fact_table sf1
JOIN 
    fact_table sf2
ON 
    sf1.transaction_id = sf2.transaction_id
    AND sf1.product_id < sf2.product_id-- Avoid duplicates
GROUP BY 
    sf1.product_id, sf2.product_id
ORDER BY 
    times_bought_together DESC
; -- Get top 10 product pairs


select product_id, product_name from product_dim where product_id =2 or product_id =17;


SELECT 
    sf1.customer_id,
    sf1.product_id AS product_1,
    sf2.product_id AS product_2,
    COUNT(DISTINCT sf1.transaction_id) AS times_bought_together
FROM 
    fact_table sf1
JOIN 
    fact_table sf2
ON 
    sf1.customer_id = sf2.customer_id
    AND sf1.product_id < sf2.product_id -- Avoid duplicates
GROUP BY 
    sf1.customer_id, sf1.product_id, sf2.product_id
ORDER BY 
    times_bought_together DESC;

SELECT 
    pd1.category AS category_1,
    pd2.category AS category_2,
    COUNT(*) AS times_bought_together
FROM 
    fact_table sf1
JOIN 
    fact_table sf2
ON 
    sf1.transaction_id = sf2.transaction_id
    AND sf1.product_id < sf2.product_id -- Avoid duplicates
JOIN 
    product_dim pd1
ON 
    sf1.product_id = pd1.product_id
JOIN 
    product_dim pd2
ON 
    sf2.product_id = pd2.product_id
GROUP BY 
    pd1.category, pd2.category
ORDER BY 
    times_bought_together DESC;
    
    
    
    
    
    
    
    
SELECT 
    sf.product_id,
    pd.product_name,
    TRUNC(dd.date_, 'MONTH') AS month,
    SUM(sf.quantity) AS total_quantity,
    RANK() OVER (PARTITION BY TRUNC(dd.date_, 'MONTH') 
                 ORDER BY SUM(sf.quantity) DESC) AS product_rank
FROM 
    fact_table sf
JOIN 
    product_dim pd
ON 
    sf.product_id = pd.product_id
JOIN 
    date_dim dd
ON 
    sf.date_id = dd.date_id
GROUP BY 
    sf.product_id, pd.product_name, TRUNC(dd.date_, 'MONTH')
ORDER BY 
    month, product_rank;


