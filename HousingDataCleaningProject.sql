Select * From HousingData.dbo.NashvilleHousingData


--Populate property address data---------------------------------------
--1. Inspecting the data

Select PropertyAddress,ParcelID
from HousingData..NashvilleHousingData
where PropertyAddress is null
order by ParcelID

--2.Finding Null Property address

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
from HousingData..NashvilleHousingData a
join HousingData..NashvilleHousingData b
on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null

--3.Replacing Null with correct Data

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from HousingData..NashvilleHousingData a
join HousingData..NashvilleHousingData b
on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null

Update a
SET PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
from HousingData..NashvilleHousingData a
join HousingData..NashvilleHousingData b
on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null

--Breaking Address into Individual Columns(Address,City,State)---------

--1.Property Address

Select PropertyAddress,SUBSTRING(PropertyAddress,1,(CHARINDEX(',',PropertyAddress)-1)) As Address,
SUBSTRING(PropertyAddress,(CHARINDEX(',',PropertyAddress)+1),Len(PropertyAddress)) As City
from HousingData..NashvilleHousingData


Alter table HousingData..NashvilleHousingData
Add PropertySplitAddress nvarchar(255)

Update HousingData..NashvilleHousingData
Set PropertySplitAddress=SUBSTRING(PropertyAddress,1,(CHARINDEX(',',PropertyAddress)-1))

Alter table HousingData..NashvilleHousingData
Add PropertySplitCity nvarchar(255)

Update HousingData..NashvilleHousingData
Set PropertySplitCity=SUBSTRING(PropertyAddress,(CHARINDEX(',',PropertyAddress)+1),Len(PropertyAddress))

--2.Owner Address

Select PARSENAME(REPLACE(owneraddress,',','.'),3) as OwnerSplitAddress,
PARSENAME(REPLACE(owneraddress,',','.'),2) as OwnerCity,
PARSENAME(REPLACE(owneraddress,',','.'),1) as OwnerState
from HousingData..NashvilleHousingData

Alter table HousingData..NashvilleHousingData
Add OwnerSplitAddress NVARCHAR (255),
OwnerCity NVARCHAR (255),
OwnerState NVARCHAR (255);

Update HousingData..NashvilleHousingData
Set OwnerSplitAddress=PARSENAME(REPLACE(owneraddress,',','.'),3),
OwnerCity=PARSENAME(REPLACE(owneraddress,',','.'),2),
OwnerState=PARSENAME(REPLACE(owneraddress,',','.'),1)


---Change Y to Yes and N to No in 'Sold As Vacant' field

Select Distinct(SoldAsVacant),Count(SoldAsVacant)
from [NashvilleHousingData ]
group by SoldAsVacant

Select SoldAsVacant,
(Case
    When SoldAsVacant='N' Then 'No'
    When SoldAsVacant='Y' Then 'Yes'
    Else SoldAsVacant
    End
    )
from HousingData..[NashvilleHousingData ]

Alter table HousingData..NashvilleHousingData
add SoldAsVacantUpdated nvarchar(10)

Update HousingData..NashvilleHousingData
Set SoldAsVacantUpdated=(Case
    When SoldAsVacant='N' Then 'No'
    When SoldAsVacant='Y' Then 'Yes'
    Else SoldAsVacant
    End
    )

---Removing duplicates----

--1.Fetching the duplicates

With RowNumCTE As(
Select *,
ROW_NUMBER() OVER (Partition by
ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by UniqueID) row_num
from HousingData..NashvilleHousingData
)
Select * from RowNumCTE
where row_num>1
order by PropertyAddress

--2.Deleting the duplicates

With RowNumCTE As(
Select *,
ROW_NUMBER() OVER (Partition by
ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by UniqueID) row_num
from HousingData..NashvilleHousingData
)
Delete from RowNumCTE
where row_num>1





