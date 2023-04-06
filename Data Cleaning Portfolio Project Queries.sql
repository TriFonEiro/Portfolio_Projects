/*
Cleaning Data in SQL Queries( Step by step)
*/


Select *
From PortfolioProject2023..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select SaleDate,Convert(Date,Saledate)
From PortfolioProject2023.dbo.NashvilleHousing
Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted,Convert(Date,Saledate)
From PortfolioProject2023..NashvilleHousing

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data


Select PropertyAddress
From PortfolioProject2023..NashvilleHousing
--


Select PropertyAddress
From PortfolioProject2023..NashvilleHousing
Where PropertyAddress is null
--


Select *
From PortfolioProject2023..NashvilleHousing
Where PropertyAddress is null
--


Select *
From PortfolioProject2023..NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID
--


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From PortfolioProject2023.dbo.NashvilleHousing a
JOIN PortfolioProject2023.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
--


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From PortfolioProject2023.dbo.NashvilleHousing a
JOIN PortfolioProject2023.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null
--


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject2023.dbo.NashvilleHousing a
JOIN PortfolioProject2023.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null
--


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject2023.dbo.NashvilleHousing a
JOIN PortfolioProject2023.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null
--


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject2023.dbo.NashvilleHousing a
JOIN PortfolioProject2023.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject2023.dbo.NashvilleHousing
--


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address
From PortfolioProject2023.dbo.NashvilleHousing
--


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address,
CHARINDEX(',', PropertyAddress)
From PortfolioProject2023.dbo.NashvilleHousing
--


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
From PortfolioProject2023.dbo.NashvilleHousing
--


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From PortfolioProject2023.dbo.NashvilleHousing
--


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )
--


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))
--


Select *
From PortfolioProject2023.dbo.NashvilleHousing
--


--we will split out the owner adress now, but with a different way(when there is a delimeter inbetween)

Select OwnerAddress
From PortfolioProject2023.dbo.NashvilleHousing
--


Select
PARSENAME(OwnerAddress,1)
From PortfolioProject2023.dbo.NashvilleHousing
--


Select
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject2023.dbo.NashvilleHousing
--


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
From PortfolioProject2023.dbo.NashvilleHousing
--


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject2023.dbo.NashvilleHousing
--


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
--


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
--


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
--


Select *
From PortfolioProject2023.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant)
From PortfolioProject2023.dbo.NashvilleHousing
--


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject2023.dbo.NashvilleHousing
Group by SoldAsVacant
--


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject2023.dbo.NashvilleHousing
Group by SoldAsVacant
Order by SoldAsVacant
--


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject2023.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2
--


Select SoldAsVacant,
  CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject2023.dbo.NashvilleHousing
--


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
--


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject2023.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


Select *
From PortfolioProject2023.dbo.NashvilleHousing
--


Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From PortfolioProject2023.dbo.NashvilleHousing
--


Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From PortfolioProject2023.dbo.NashvilleHousing
Order by ParcelID
--


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject2023.dbo.NashvilleHousing
)
Select *
From RowNumCTE
--


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject2023.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress
--


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject2023.dbo.NashvilleHousing
)
DELETE
From RowNumCTE
Where row_num > 1
--


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject2023.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress
--


Select *
From PortfolioProject2023.dbo.NashvilleHousing

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From PortfolioProject2023.dbo.NashvilleHousing
--


ALTER TABLE PortfolioProject2023.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
--


Select *
From PortfolioProject2023.dbo.NashvilleHousing


