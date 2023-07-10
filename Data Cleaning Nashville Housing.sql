--Change SaleDate (fromat)
SELECT SaleDate, CONVERT(Date, SaleDate)
  FROM [Project].[dbo].[Nashville Housing Data for Data Cleaning]

  UPDATE [Nashville Housing Data for Data Cleaning] 
  SET SaleDate = CONVERT(Date, SaleDate)

-------------------------------------------------------------------------------

--Populate property address data
SELECT PropertyAddress
  FROM [Project].[dbo].[Nashville Housing Data for Data Cleaning]
  WHERE PropertyAddress IS NULL


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  FROM [Project].[dbo].[Nashville Housing Data for Data Cleaning] a
  JOIN [Project].[dbo].[Nashville Housing Data for Data Cleaning] b ON
  a.ParcelID = b.ParcelID AND
  a.UniqueID <> b.UniqueID
  WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Project].[dbo].[Nashville Housing Data for Data Cleaning] a
  JOIN [Project].[dbo].[Nashville Housing Data for Data Cleaning] b ON
  a.ParcelID = b.ParcelID AND
  a.UniqueID <> b.UniqueID
  WHERE a.PropertyAddress IS NULL

-------------------------------------------------------------------------------

--Breaking Address into separate columns ( Address, City, State )
SELECT PropertyAddress
  FROM [Project].[dbo].[Nashville Housing Data for Data Cleaning]

  SELECT
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
 SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address

  FROM [Project].[dbo].[Nashville Housing Data for Data Cleaning]



  ALTER TABLE [Project].[dbo].[Nashville Housing Data for Data Cleaning]
ADD PropertySplitAddress NVARCHAR(255);

Update [Project].[dbo].[Nashville Housing Data for Data Cleaning]
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE [Project].[dbo].[Nashville Housing Data for Data Cleaning]
ADD PropertySplitCity NVARCHAR(255);

Update [Project].[dbo].[Nashville Housing Data for Data Cleaning]
SET PropertySplitCity  =  SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT 
PARSENAME (REPLACE(OwnerAddress,',','.'),3),
PARSENAME (REPLACE(OwnerAddress,',','.'),2),
PARSENAME (REPLACE(OwnerAddress,',','.'),1)
FROM [Nashville Housing Data for Data Cleaning]


ALTER TABLE [Project].[dbo].[Nashville Housing Data for Data Cleaning]
ADD OwnerSplitAddress NVARCHAR(255);

Update [Project].[dbo].[Nashville Housing Data for Data Cleaning]
SET OwnerSplitAddress = PARSENAME (REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE [Project].[dbo].[Nashville Housing Data for Data Cleaning]
ADD OwnerSplitCity  NVARCHAR(255);

Update [Project].[dbo].[Nashville Housing Data for Data Cleaning]
SET OwnerSplitCity  =  PARSENAME (REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE [Project].[dbo].[Nashville Housing Data for Data Cleaning]
ADD OwnerSplitState  NVARCHAR(255);

Update [Project].[dbo].[Nashville Housing Data for Data Cleaning]
SET OwnerSplitState  =  PARSENAME (REPLACE(OwnerAddress,',','.'),1)

--Change 0 to No and 1 to Yes "SoldAsVacant" 
SELECT SoldAsVacant
FROM [Nashville Housing Data for Data Cleaning]

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM [Nashville Housing Data for Data Cleaning]
GROUP BY SoldAsVacant
ORDER  BY 2

ALTER TABLE [Nashville Housing Data for Data Cleaning]
ALTER COLUMN SoldAsVacant NVARCHAR(3);

UPDATE [Nashville Housing Data for Data Cleaning]
SET SoldAsVacant = CASE WHEN SoldAsVacant = '1' THEN 'Yes'
                        WHEN SoldAsVacant = '0' THEN 'No'
                        ELSE SoldAsVacant
                   END;


--Remove Duplicates
WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER BY
UniqueID) row_num
FROM [Nashville Housing Data for Data Cleaning]
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

SELECT *
FROM [Nashville Housing Data for Data Cleaning]

--Delete unsed columns

SELECT *
FROM [Nashville Housing Data for Data Cleaning]

ALTER TABLE [Nashville Housing Data for Data Cleaning]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE [Nashville Housing Data for Data Cleaning]
DROP COLUMN SaleDate





