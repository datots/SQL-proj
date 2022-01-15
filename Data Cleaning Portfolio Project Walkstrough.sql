--Cleaning Data in SQL Queries



Select *
From PortfolioProject..NashvilleHousing

-- Standardized Data Fromat

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject..NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT (date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
SET SaleDateConverted = CONVERT (Date,SaleDate)


--Populate Property Adress Data
Select * 
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a 
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND  a.[UniqueID ] <> b.[UniqueID]
Where a.PropertyAddress is null		

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a 
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND  a.[UniqueID ] <> b.[UniqueID]




-- Breaking out Adress into Individual Columns(Adress,City,State)


Select PropertyAddress
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
,  SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


Select*

From PortfolioProject..NashvilleHousing


Select OwnerAddress

From PortfolioProject..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject..NashvilleHousing

-------------------------------------------------------------
ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


Select *

From PortfolioProject..NashvilleHousing



Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, Case when SoldAsVacant = 'Y' THEN 'YES'
	   when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
From PortfolioProject..NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = Case when SoldAsVacant = 'Y' THEN 'YES'
	   when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END


--- Remove Duplicates


Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_um



From PortfolioProject..NashvilleHousing
--order by ParcelID

Select * 
From RowNumCTE
Where row_num > 1
Order by PropertAddress


Select *
From PortfolioProject..NashvilleHousing



Select *
From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioprojectNsdhvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioprojectNsdhvilleHousing
DROP COLUMN saleDate
