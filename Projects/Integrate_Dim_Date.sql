# ===================================================================================
# How to Integrate a Dimension table. In other words, how to look-up Foreign Key
# values FROM a dimension table and add them to new Fact table columns.
#
# First, go to Edit -> Preferences -> SQL Editor and disable 'Safe Edits'.
# Close SQL Workbench and Reconnect to the Server Instance.
# ===================================================================================

USE chinook_dw;

# populate dim_date table
CALL PopulateDateDimension('2000/01/01', '2013/12/31');

# verify inserts occurred correctly
SELECT * FROM dim_date
LIMIT 20;

# ==============================================================
# Step 1: Add New Column(s)
# ==============================================================
ALTER TABLE chinook_dw.fact_invoices
ADD COLUMN invoice_date_key int NOT NULL AFTER invoice_date;

# ==============================================================
# Step 2: Update New Column(s) with value from Dimension table
#         WHERE Business Keys in both tables match.
# ==============================================================
UPDATE chinook_dw.fact_invoices AS f
JOIN chinook_dw.dim_date AS dd
ON DATE(f.invoice_date) = dd.full_date
SET f.invoice_date_key = dd.date_key;

# ==============================================================
# Step 3: Validate that newly updated columns contain valid data
# ==============================================================
SELECT invoice_date
	, invoice_date_key
FROM chinook_dw.fact_invoices
LIMIT 10;

# =============================================================
# Step 4: If values are correct then drop old column(s)
# =============================================================
ALTER TABLE chinook_dw.fact_invoices
DROP COLUMN invoice_date;

# =============================================================
# Step 5: Validate Finished Fact Table.
# =============================================================
SELECT * FROM chinook_dw.fact_invoices
LIMIT 10;

