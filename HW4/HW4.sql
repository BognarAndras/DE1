USE classicmodels;

SELECT o.orderNumber, o2.priceEach, o2.quantityOrdered, p.productName, p.productLine, c.city, c.country, o.orderDate 
FROM orders AS o
	INNER JOIN orderdetails AS o2
	USING (orderNumber)
    INNER JOIN products AS p
    USING (productCode)
    INNER JOIN customers AS c
    USING (customerNumber);