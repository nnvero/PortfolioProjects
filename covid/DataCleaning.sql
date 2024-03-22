-- Cleaning data in SQL Queries
SELECT * FROM PortfolioProject..NashvilleHousing


-- Standardize date format
SELECT SaleDate, CONVERT(date, SaleDate) as StandDate 
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate)

ALTER TABLE NashvilleHousing
ADD DateConverted date;
 
UPDATE NashvilleHousing
SET DateConverted = CONVERT(date, SaleDate)

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate;


-- Populate property address data
SELECT * 
FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress is NULL

SELECT * 
FROM PortfolioProject..NashvilleHousing as a
	JOIN PortfolioProject..NashvilleHousing as b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM PortfolioProject..NashvilleHousing as a
	JOIN PortfolioProject..NashvilleHousing as b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing as a
	JOIN PortfolioProject..NashvilleHousing as b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL


-- Breaking out address into individual columns
SELECT PropertyAddress
, SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+2, LEN(PropertyAddress)) as City 
 FROM NashvilleHousing

 ALTER TABLE NashvilleHousing
 ADD PropertySplitAddress nvarchar(255)
 , PropertySplitCity nvarchar(255);

 UPDATE NashvilleHousing
 SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)
, PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+2, LEN(PropertyAddress));


-- Breaking out owner address into individual columns
SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as OwnerSplitAddress
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as OwnerSplitCity
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as OwnerSplitState
FROM NashvilleHousing
ORDER BY OwnerSplitAddress desc

 ALTER TABLE NashvilleHousing
 ADD OwnerSplitAddress nvarchar(255)
 , OwnerSplitCity nvarchar(255)
 , OwnerSplitState nvarchar(255);

 UPDATE NashvilleHousing
 SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);


-- Replase Y an N with Yes and No in SoldAsVacant
SELECT DISTINCT SoldAsVacant
FROM NashvilleHousing

SELECT SoldAsVacant
, CASE 
	WHEN SoldAsVacant = 'Y'
		THEN 'Yes'
	WHEN SoldAsVacant = 'N'
		THEN 'No'
	ELSE SoldAsVacant
END 
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
	WHEN SoldAsVacant = 'Y'
		THEN 'Yes'
	WHEN SoldAsVacant = 'N'
		THEN 'No'
	ELSE SoldAsVacant
END 


-- Remove duplicates
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 DateConverted,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProject.dbo.NashvilleHousing;

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 DateConverted,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProject.dbo.NashvilleHousing
)
SELECT * FROM NashvilleHousing

-- Removing unnecessary columns
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

SELECT * FROM NashvilleHousing