/* HOW TO IMPORT LARGE FILES FAST IN MYSQL WORKBVENCH */

----------------------------------------------------------------------
/* STEP 1: GET FOLDER LOCATION */ 
SHOW VARIABLES LIKE "SECURE_FILE_PRIV";

----------------------------------------------------------------------
/* STEP 2: PASTE CSV FILE INTO THE PATH ABOVE */

----------------------------------------------------------------------
/* STEP 3: CREATE TABLE TO IMPORT YOUR DATA */

CREATE TABLE nashville_housing (
  UniqueID int DEFAULT NULL,
  ParcelID text,
  LandUse text,
  PropertyAddress text DEFAULT NULL,
  SaleDate text,
  SalePrice int DEFAULT NULL,
  LegalReference text,
  SoldAsVacant text,
  OwnerName text,
  OwnerAddress text,
  Acreage double DEFAULT NULL,
  TaxDistrict text,
  LandValue int DEFAULT NULL,
  BuildingValue int DEFAULT NULL,
  TotalValue int DEFAULT NULL,
  YearBuilt int DEFAULT NULL,
  Bedrooms int DEFAULT NULL,
  FullBath int DEFAULT NULL,
  HalfBath int DEFAULT NULL
  ) ;
  
----------------------------------------------------------------------
/* STEP 4: LOCAL INFILE MUST BE SET TO TRUE */ 

show variables like "local_infile";
set global local_infile = 1;
 
----------------------------------------------------------------------
/* STEP 5: LOAD THE DATA */ 
  
LOAD DATA local INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Nashville Housing Data for Data Cleaning.csv"
INTO TABLE nashville_housing
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;