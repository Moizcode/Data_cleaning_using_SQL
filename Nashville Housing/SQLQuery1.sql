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