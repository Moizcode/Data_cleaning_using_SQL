/*
    Cleaning Data using SQL queries

*/

Select * 
From practice..NashvilleHousing

---------------------------------------------------------------------------------------------------------------
-- Standardize Date Format

Select SaleDateConverted, convert(Date,SaleDate)
From practice..NashvilleHousing

Update practice..NashvilleHousing     -- Not convert SaleDate
Set SaleDate = CONVERT(Date,SaleDate)

Alter Table NashvilleHousing 
Add SaleDateConverted Date

Update practice..NashvilleHousing     
Set SaleDateConverted = CONVERT(Date,SaleDate)  

------------------------------------------------------------------------------------------------------------------

-- Populate property Address data

Select *
From practice..NashvilleHousing
-- Where PropertyAddress is null
Order by ParcelID                -- we observed that if two parcelid is same then property address is also same


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.propertyAddress,b.PropertyAddress)
From practice..NashvilleHousing a
JOIN practice..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.propertyAddress,b.PropertyAddress)
From practice..NashvilleHousing a
JOIN practice..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Column(Address,City,State)

Select PropertyAddress
From practice..NashvilleHousing

Select  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
   SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress)) as City
From practice..NashvilleHousing

Alter Table practice..NashvilleHousing 
Add PropertySplitAddress Nvarchar(255)

Update practice..NashvilleHousing     
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table practice..NashvilleHousing 
Add PropertySplitCity Nvarchar(255)

Update practice..NashvilleHousing     
Set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))


Select  PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From practice..NashvilleHousing

Alter Table practice..NashvilleHousing 
Add OwnerSplitAddress Nvarchar(255)

Update practice..NashvilleHousing     
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table practice..NashvilleHousing 
Add OwnerSplitCity Nvarchar(255)

Update practice..NashvilleHousing     
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table practice..NashvilleHousing 
Add OwnerSplitState Nvarchar(255)

Update practice..NashvilleHousing     
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

-------------------------------------------------------------------------------------------------------------------
-- change y and n to yes and no in 'sold as vacant'

Select SoldAsVacant,Count(SoldAsVacant) as count
From practice..NashvilleHousing
Group by SoldAsVacant

Select SoldAsVacant,
 Case when SoldAsVacant = 'Y' Then 'Yes'
	  when SoldAsVacant = 'N' THEN 'No'
	  Else SoldAsVacant
      End
From practice..NashvilleHousing

Update practice..NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
	  when SoldAsVacant = 'N' THEN 'No'
	  Else SoldAsVacant
      End

--------------------------------------------------------------------------------------------------------------------
-- Remove Duplicate
	
with rownumcte AS (
Select *,
	ROW_NUMBER() Over(
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by ParcelID
					  ) row_num
From practice..NashvilleHousing
)
Delete
From rownumcte
where row_num>1


-------------------------------------------------------------------------------------------------------------------
-- Delete unused Data

Select *
From practice..NashvilleHousing

Alter Table practice..NashvilleHousing
Drop Column OwnerAddress,PropertyAddress,TaxDistrict,SaleDateś


