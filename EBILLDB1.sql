create database EBillDB;

create table tbl_BillDetails(Id int primary key identity, CustomerName varchar(255),MobileNumber varchar(255), Address varchar(255),TotalAmount int);

create table tbl_BillItems(Id int primary key identity, ProductName varchar(255),Price int,Quantity int, BillId int foreign key references tbl_BillDetails(Id));

create procedure spt_saveEBillDetails
@CustomerName varchar(255),
@MobileNumber varchar(255),
@Address varchar(255),
@TotalAmount int,
@Id int output
as
begin
insert into tbl_BillDetails(CustomerName,MobileNumber,Address,TotalAmount)
values(@CustomerName,@MobileNumber,@Address,@TotalAmount)
select @Id = SCOPE_IDENTITY();
end

create procedure spt_getAllEBillDetails
as
begin
select * from tbl_BillDetails;
end

create procedure spt_getEBillDetails
@Id int
as
begin
select d.Id as 'BillId', d.CustomerName, d.MobileNumber, d.Address,d.TotalAmount,
i.Id as 'ItemId', i.ProductName, i.Price, i.Quantity
from tbl_BillDetails d inner join tbl_BillItems i
on d.Id = i.BillId
where d.Id = @Id;
end

select * from tbl_BillItems;
select * from tbl_BillDetails;

DELETE FROM tbl_BillDetails;

-- Update tbl_BillDetails
ALTER TABLE tbl_BillDetails ALTER COLUMN TotalAmount DECIMAL(18,2);

-- Update tbl_BillItems
ALTER TABLE tbl_BillItems
ALTER COLUMN Price DECIMAL(18,2);

ALTER TABLE tbl_BillItems
ALTER COLUMN Quantity DECIMAL(18,2);

-- Update spt_saveEBillDetails
ALTER PROCEDURE spt_saveEBillDetails
    @CustomerName VARCHAR(255),
    @MobileNumber VARCHAR(255),
    @Address VARCHAR(255),
    @TotalAmount DECIMAL(18,2), -- ✅ changed
    @Id INT OUTPUT
AS
BEGIN
    INSERT INTO tbl_BillDetails(CustomerName, MobileNumber, Address, TotalAmount)
    VALUES(@CustomerName, @MobileNumber, @Address, @TotalAmount);

    SELECT @Id = SCOPE_IDENTITY();
END
GO

-- Update spt_getAllEBillDetails (no data type issue here)
ALTER PROCEDURE spt_getAllEBillDetails
AS
BEGIN
    SELECT * FROM tbl_BillDetails;
END
GO

-- Update spt_getEBillDetails (also no type issue since it selects directly)
ALTER PROCEDURE spt_getEBillDetails
    @Id INT
AS
BEGIN
    SELECT d.Id AS BillId, d.CustomerName, d.MobileNumber, d.Address, d.TotalAmount,
           i.Id AS ItemId, i.ProductName, i.Price, i.Quantity
    FROM tbl_BillDetails d
    INNER JOIN tbl_BillItems i ON d.Id = i.BillId
    WHERE d.Id = @Id;
END
GO

