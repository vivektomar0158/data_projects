select SaleDate, CONVERT(Date,SaleDate) 
from Project.dbo.NorthCarolina

update NorthCarolina
Set SaleDate = CONVERT(Date,SaleDate)

Alter Table NorthCarolina
Add SalesDateConverted Date;

update NorthCarolina
Set SalesDateConverted = CONVERT(Date,SaleDate)

select SalesDateConverted, CONVERT(Date,SaleDate)
from NorthCarolina

select * 
from Project.dbo.NorthCarolina
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Project.dbo.NorthCarolina as a
join NorthCarolina as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a 
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Project.dbo.NorthCarolina as a
join NorthCarolina as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

select PropertyAddress
from Project.dbo.NorthCarolina
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
--CHARINDEX(',',PropertyAddress)

from Project.dbo.NorthCarolina


Alter Table NorthCarolina
Add PropertySplit nvarchar(255);

update NorthCarolina
Set PropertySplit = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

Alter Table NorthCarolina
Add PropertySplitCity nvarchar(255);

update NorthCarolina
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select *
from NorthCarolina

Select
parsename(REPLACE(OwnerAddress,',','.') ,3),
parsename(REPLACE(OwnerAddress,',','.') ,2),
parsename(REPLACE(OwnerAddress,',','.') ,1)
from NorthCarolina

Alter Table NorthCarolina
Add OwnerSplit nvarchar(255);

update NorthCarolina
Set OwnerSplit = parsename(REPLACE(OwnerAddress,',','.') ,3)

Alter Table NorthCarolina
Add OwnerSplitCity nvarchar(255);

update NorthCarolina
Set OwnerSplitCity =parsename(REPLACE(OwnerAddress,',','.') ,2)

Alter Table NorthCarolina
Add OwnerSplitState nvarchar(255);

update NorthCarolina
Set OwnerSplitState =parsename(REPLACE(OwnerAddress,',','.') ,1)

select * 
from NorthCarolina

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from NorthCarolina
group by SoldAsVacant
order by 2


select SoldAsVacant,
Case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from NorthCarolina

update NorthCarolina
set SoldAsVacant= Case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end

WITH ROWNUMCTE AS (
select *,
ROW_NUMBER() OVER(
partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by
UniqueID
) Row_Num
from NorthCarolina
)
select *
FROM ROWNUMCTE
WHERE Row_Num >1
order by PropertyAddress


select *
from NorthCarolina

alter table NorthCarolina
Drop Column OwnerAddress, TaxDistrict, PropertyAddress


alter table NorthCarolina
Drop Column SaleDate
