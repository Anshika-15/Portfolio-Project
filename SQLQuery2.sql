/*

CLEANING DATA FROM SQL

*/

SELECT * 
FROM Portfolioproject.dbo.NashvilleHousing;


-- STANDARDIZE DATE FORMAT

SELECT SaleDate
FROM Portfolioproject ..NashvilleHousing

ALTER TABLE Portfolioproject ..NashvilleHousing
ALTER COLUMN SaleDate DATE

-- POPULATE PROPERTY ADDRESS DATA

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress , b.PropertyAddress)
FROM Portfolioproject ..NashvilleHousing a
JOIN Portfolioproject..NashvilleHousing b
ON a.ParcelId = b.ParcelId
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL ;

--BREAKING OUT PROPERTY ADDRESS INTO INDIVIDUAL COLUMNS


SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address ,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS Address
FROM Portfolioproject ..NashvilleHousing;

ALTER TABLE Portfolioproject ..NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255)

UPDATE Portfolioproject ..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE Portfolioproject ..NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)

UPDATE Portfolioproject ..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

-- BREAKING OUT OWNER ADDRESS INTO INDIVIDUAL COLUMNS


SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM Portfolioproject ..NashvilleHousing

ALTER TABLE Portfolioproject ..NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE Portfolioproject ..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE Portfolioproject ..NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255)

UPDATE Portfolioproject ..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE Portfolioproject ..NashvilleHousing
ADD OwnerSplitState NVARCHAR(255)

UPDATE Portfolioproject ..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

-- CHANGE Y AND N TO YES AND NO

SELECT SoldAsVacant,
CASE  When SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'NO'
	  ELSE SoldAsVacant END
FROM Portfolioproject ..NashvilleHousing


UPDATE Portfolioproject ..NashvilleHousing
SET SoldAsVacant = CASE  When SoldAsVacant = 'Y' THEN 'Yes'
                         WHEN SoldAsVacant = 'N' THEN 'NO'
	                     ELSE SoldAsVacant END


-- REMOVE DUPLICATES

WITH RowNumCTE AS (
SELECT * ,
          ROW_NUMBER() OVER (PARTITION BY ParcelId,
                                           PropertyAddress,
										   SalePrice,
										   SaleDate,
										   LegalReference
										   ORDER BY
										        UniqueId
												) row_num
FROM Portfolioproject ..NashvilleHousing
)

DELETE
FROM RowNumCTE
WHERE row_num >1

-- DELETE UNUSED COLUMNS

ALTER TABLE Portfolioproject ..NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict 

ALTER TABLE Portfolioproject ..NashvilleHousing
DROP COLUMN SaleDate 














