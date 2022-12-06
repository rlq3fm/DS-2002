-- --------------------------------------------------------------------------------------------------------------
-- Extract the appropriate data from the chinook database, and INSERT it into the Northwind_DW database.
-- --------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------
-- Populate dim_customers
-- ----------------------------------------------
INSERT INTO `chinook_dw`.`dim_customers`
(`customer_key`
  ,`customer_first_name`
  ,`customer_last_name`
  ,`company`
  ,`address`
  ,`city`
  ,`state`
  ,`country`
  ,`postal_code`
  ,`phone`
  ,`email`
  ,`support_employee_key`)
SELECT `CustomerId`,
`FirstName`,
`LastName`,
`Company`,
`Address`,
`City`,
`State`,
`Country`,
`PostalCode`,
`Phone`,
`Email`,
`SupportRepId`
FROM chinook.customer;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT 
    *
FROM
    chinook_dw.dim_customers;


-- ----------------------------------------------
-- Populate dim_employees
-- ----------------------------------------------
INSERT INTO `chinook_dw`.`dim_employees`
(
  `employee_key`,
  `employee_last_name`,
  `employee_first_name`,
  `title`,
  `reports_to_employee_key`,
  `address`,
  `city`,
  `state`,
  `country`,
  `postal_code`,
  `phone`,
  `fax`,
  `email`
  )
SELECT `EmployeeId`,
`LastName`,
`FirstName`,
`Title`,
`ReportsTo`,
`Address`,
`City`,
`State`,
`Country`,
`PostalCode`,
`Phone`,
`Fax`,
`Email`
FROM chinook.employee;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT 
    *
FROM
    chinook_dw.dim_employees;


-- ----------------------------------------------
-- Populate dim_tracks
-- ----------------------------------------------
INSERT INTO `chinook_dw`.`dim_tracks`
(
  `track_key`,
  `track_name`,
  `album_key`,
  `album_title`,
  `artist_key`,
  `artist_name`,
  `media_type_key`,
  `media_type_name`,
  `genre_key`,
  `genre_name`,
  `composer`,
  `milliseconds`,
  `bytes`,
  `unit_price`
  )
SELECT 
t.TrackId,
t.Name AS TrackName,
t.AlbumId,
a.Title AS AlbumTitle,
a.ArtistId,
ar.Name AS ArtistName,
t.MediaTypeId,
m.Name AS MediaTypeName,
t.GenreId,
g.Name AS GenreName,
t.Composer,
t.Milliseconds,
t.Bytes,
t.UnitPrice
FROM chinook.track AS t
LEFT OUTER JOIN chinook.album AS a
ON t.AlbumId = a.AlbumId
INNER JOIN chinook.artist AS ar
ON a.ArtistId = ar.ArtistId
LEFT OUTER JOIN chinook.genre AS g
ON t.GenreId = g.GenreId
LEFT OUTER JOIN chinook.mediatype AS m
ON t.MediaTypeId = m.MediaTypeId ;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT 
    *
FROM
    chinook_dw.dim_tracks;


-- ----------------------------------------------
-- Populate fact_invoices
-- ----------------------------------------------
INSERT INTO `chinook_dw`.`fact_invoices`
(
  `invoice_key`,
  `customer_key`,
  `track_key`,
  `invoice_date`,
  `billing_address`,
  `billing_city`,
  `billing_state`,
  `billing_country`,
  `billing_postal_code`,
  `unit_price`,
  `quantity`,
  `invoice_total`
)
SELECT
i.InvoiceId,
i.CustomerId,
il.TrackId,
i.InvoiceDate,
i.BillingAddress,
i.BillingCity,
i.BillingState,
i.BillingCountry,
i.BillingPostalCode,
il.UnitPrice,
il.Quantity,
i.Total
FROM chinook.invoiceline AS il
LEFT OUTER JOIN chinook.invoice AS i
ON il.InvoiceId = i.InvoiceId;


-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT 
    *
FROM
    chinook_dw.fact_invoices;