USE PortfolioProject;


GO
-- Change SaleDate from DATETIME to DATE
UPDATE PortfolioProject.dbo.NashvilleHousing
SET    SaleDate = CONVERT (DATE, SaleDate);

ALTER TABLE PortfolioProject.dbo.NashvilleHousing ALTER COLUMN SaleDate DATE;

-- Populate Property Address
UPDATE base
SET    PropertyAddress = ISNULL(base.PropertyAddress, rep.PropertyAddress)
FROM   PortfolioProject.dbo.NashvilleHousing AS base
       INNER JOIN
       PortfolioProject.dbo.NashvilleHousing AS rep
       ON base.ParcelID = rep.ParcelID
          AND base.UniqueID <> rep.UniqueID
WHERE  base.PropertyAddress IS NULL;

-- Breaking Down Property Address
IF EXISTS (SELECT 1
           FROM   INFORMATION_SCHEMA.COLUMNS
           WHERE  TABLE_NAME = 'NashvilleHousing'
                  AND COLUMN_NAME = 'PropertySAddress'
                  AND TABLE_SCHEMA = 'dbo')
    BEGIN
        ALTER TABLE NashvilleHousing DROP COLUMN PropertySAddress;
    END


GO
IF EXISTS (SELECT 1
           FROM   INFORMATION_SCHEMA.COLUMNS
           WHERE  TABLE_NAME = 'NashvilleHousing'
                  AND COLUMN_NAME = 'PropertySCity'
                  AND TABLE_SCHEMA = 'dbo')
    BEGIN
        ALTER TABLE NashvilleHousing DROP COLUMN PropertySCity;
    END


GO
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
    ADD PropertySAddress NVARCHAR (MAX),
        PropertySCity    NVARCHAR (50) ;


GO
UPDATE PortfolioProject.dbo.NashvilleHousing
SET    PropertySAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1),
       PropertySCity    = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))
FROM   PortfolioProject.dbo.NashvilleHousing;

-- Breaking Down Owner Address
IF EXISTS (SELECT 1
           FROM   INFORMATION_SCHEMA.COLUMNS
           WHERE  TABLE_NAME = 'NashvilleHousing'
                  AND COLUMN_NAME = 'OwnerSAddress'
                  AND TABLE_SCHEMA = 'dbo')
    BEGIN
        ALTER TABLE NashvilleHousing DROP COLUMN OwnerSAddress;
    END


GO
IF EXISTS (SELECT 1
           FROM   INFORMATION_SCHEMA.COLUMNS
           WHERE  TABLE_NAME = 'NashvilleHousing'
                  AND COLUMN_NAME = 'OwnerSCity'
                  AND TABLE_SCHEMA = 'dbo')
    BEGIN
        ALTER TABLE NashvilleHousing DROP COLUMN OwnerSCity;
    END


GO
IF EXISTS (SELECT 1
           FROM   INFORMATION_SCHEMA.COLUMNS
           WHERE  TABLE_NAME = 'NashvilleHousing'
                  AND COLUMN_NAME = 'OwnerSState'
                  AND TABLE_SCHEMA = 'dbo')
    BEGIN
        ALTER TABLE NashvilleHousing DROP COLUMN OwnerSState;
    END


GO
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
    ADD OwnerSAddress NVARCHAR (MAX),
        OwnerSCity    NVARCHAR (50) ,
        OwnerSState   NVARCHAR (50) ;


GO
UPDATE PortfolioProject.dbo.NashvilleHousing
SET    OwnerSAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
       OwnerSCity    = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
       OwnerSState   = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM   PortfolioProject.dbo.NashvilleHousing;

-- Update Date in SoldAsVacant to Match Yes/No
UPDATE PortfolioProject.dbo.NashvilleHousing
SET    SoldAsVacant = CASE WHEN SoldAsVacant LIKE 'Y%' THEN 'Yes' WHEN SoldAsVacant LIKE 'N%' THEN 'No' ELSE SoldAsVacant END;

SELECT *
FROM   PortfolioProject.dbo.NashvilleHousing;

-- Remove Duplicates
WITH RowNumCTE
AS   (SELECT *,
             ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) AS row_num
      FROM   PortfolioProject.dbo.NashvilleHousing)
DELETE RowNumCTE
WHERE  row_num > 1;

-- Delete Unused Columns (for practice only)
ALTER TABLE PortfolioProject.dbo.NashvilleHousing DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict;