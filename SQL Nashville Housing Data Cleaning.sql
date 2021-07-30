SELECT * 
FROM NashvilleHousing
ORDER BY [UniqueID ]


-------------------------------------------------------------------------------------------------------------
--Editing date format

ALTER TABLE NashvilleHousing
ADD Sale_Date Date

UPDATE NashvilleHousing
SET Sale_Date = CONVERT(date, SaleDate)

SELECT Sale_Date
FROM NashvilleHousing



-------------------------------------------------------------------------------------------------------------
--POPULATING PROPERTY ADDRESS COLUMN

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress is NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL



------------------------------------------------------------------------------------------------------------
--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (Address, City, State)
--PROPERTY ADDRESS

SELECT PropertyAddress
FROM NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD Property_Address NVarchar(255)

UPDATE NashvilleHousing
SET Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing	
ADD Property_City NVarchar(255)

UPDATE NashvilleHousing
SET Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM NashvilleHousing


--OWNER ADDRESS

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD Owner_Address NVarchar(255)

UPDATE NashvilleHousing
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing	
ADD Owner_City NVarchar(255)

UPDATE NashvilleHousing
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing	
ADD Owner_State NVarchar(255)

UPDATE NashvilleHousing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



--------------------------------------------------------------------------------------------------------
--CHANGING Y AND N TO YES AND NO IN 'SoldasVacant' FIELD

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END



---------------------------------------------------------------------------------------------------------------
--REMOVING DUPLICATES

WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM NashvilleHousing)

DELETE
FROM RowNumCTE
WHERE row_num > 1



------------------------------------------------------------------------------------------------------------
--DELETING UNUSED COLUMNS

SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress