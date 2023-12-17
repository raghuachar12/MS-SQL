CREATE  TABLE tblUsers (
    User_id SERIAL PRIMARY KEY,
    User_name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL
);
select * from tblUsers

INSERT INTO tblUsers (User_id, User_name, Email)
VALUES
		(1001,'Akash','akash@gmail.com'), 
		(1002,'Arvind','arvind123@gmail.com'),
		(1003,'Sakshi','sakshimys12@gmail.com'),
		(1004,'Kumar','kumar987@gmail.com' );


CREATE   TABLE tblCategory (
    Category_id SERIAL PRIMARY KEY,
    Category_name VARCHAR(50) NOT NULL,
    Description VARCHAR(255) NOT NULL
);
select * from tblCategory

INSERT INTO tblCategory (Category_id, Category_name, Description)
VALUES
		(201,'Electronics','One stop for electronic items'),
		(202,'Apparel','Apparel is the next destination for fashion'),
		(203,'Grocery','All needs in one place' );


CREATE  TABLE tblProducts (
    Product_id SERIAL PRIMARY KEY,
    Product_name VARCHAR(50) NOT NULL,
    Quantity INT NOT NULL,
    Product_price INT NOT NULL,
    Category_id INT REFERENCES tblCategory(Category_id)
);
select * from tblProducts
INSERT INTO tblProducts (Product_id, Product_name, Quantity, Product_price, Category_id)
VALUES
			(1,'Mobile Phone',1000,15000,201 ),
			(2,'Television',500,40000,201 ),
			(3,'Denims',2000,700,202 ),
			(4,'Vegetables',4000,40,203 ),
			(5,'Ethnic Wear',300,1500,202 ),
			(6,'Wireless Earphone',5000,2500,201 ),
			(7,'Lounge Wear',200,1600,202 ),
			(8,'Refrigerator',50,30000,201 ),
			(9,'Pulses',60,150,202),
			(10,'Fruits',100,250,203 );


CREATE   TABLE tblSales (
    Sales_id SERIAL PRIMARY KEY,
    Sales_user_id INT REFERENCES tblUsers(User_id),
    Product_id INT REFERENCES tblProducts(Product_id)
);

		   
INSERT INTO tblSales (Sales_id, Sales_user_id, Product_id)
VALUES
			(500,1001,1 ),
			(501,1002,1 ),
			(502,1003,2 ),
			(504,1004,3) ,
			(505,1004,1 ),
			(506,1004,1) ,
			(507,1002,2 ),
			(508,1003,1 ),
			(509,1001,7 ),
			(510,1001,8 );
			
select * from tblProducts     
select * from tblusers                                                                      
select * from tblcategory                                                 
select * from tblSales	     

--1

CREATE OR REPLACE FUNCTION fetch_dtl(IN saleid int)

Returns table (product_name1 varchar(25),category_name1 varchar(25),user_name1 varchar(25),product_id1 int,product_price1 int)
    Language plpgsql
  as
  $$
  DECLARE cost1 int;
  Begin
  return query
   SELECT product_name,category_name,User_name,s.product_id,product_price as price
   FROM tblCategory c 
   INNER JOIN tblProducts p on c.category_id=p.category_id
   INNER JOIN tblSales s on s.product_id=p.product_id
   INNER JOIN tblUsers u on u.user_id=s.sales_user_id
   WHERE s.sales_id=saleid ;
  
  SELECT P.product_price INTO cost1  FROM tblProducts P INNER JOIN tblsales S USING(Product_id)
   WHERE s.sales_id=saleid;

IF cost1>2000 
THEN
RAISE NOTICE 'The product has gained profit';
END IF;

IF cost1>500 AND cost1<1000 
THEN
RAISE NOTICE 'The product has occured loss';
END IF;

IF cost1<500 
THEN
RAISE EXCEPTION 'No profit no loss';
END IF;
END;
$$

select * from fetch_dtl(504)


--2

CREATE OR REPLACE PROCEDURE updateandfetch(IN userID INT)
LANGUAGE PLPGSQL
AS $$
BEGIN
	DROP TABLE IF EXISTS temp_tbl1;
  
    CREATE TEMPORARY TABLE temp_tbl1 AS
    SELECT
        c.Category_name AS original_category,
        p.Product_name AS original_product
    FROM
        tblSales s
        JOIN tblProducts p ON s.Product_id = p.Product_id
        JOIN tblCategory c ON p.Category_id = c.Category_id
    WHERE
        s.Sales_user_id = userID;

   
    UPDATE tblCategory
    SET Category_name = 'Modern Gadgets'
    WHERE Category_name = 'Electronics';

   
    PERFORM * FROM temp_tbl1;


END;
$$;


CALL updateandfetch(1004)
SELECT * FROM temp_tbl1

SELECT * FROM  tblCategory