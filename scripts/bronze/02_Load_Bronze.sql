
/*
===============================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
        - Truncates the bronze tables before loading data.
        - Uses the BULK INSERT command to load data from CSV files into bronze tables.
===============================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    -- Track ETL Duration:
    -- Helps identify bottlenecks, optimize performance, and monitor trends.
    DECLARE
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '=====================================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '=====================================================================';
        PRINT '---------------------------------------------------------------------';
        PRINT 'Loading Tables';
        PRINT '---------------------------------------------------------------------';

        -- Load bronze.equipment
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.equipment';
        TRUNCATE TABLE bronze.equipment;

        PRINT '>> Inserting Data Into: bronze.equipment';
        BULK INSERT bronze.equipment
        FROM 'C:\Users\Isaias\Desktop\RME-OPS-DATA\equipment.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';
        PRINT '---------------------------------------------------------------------';

        -- Load bronze.inventory_transactions
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.inventory_transactions';
        TRUNCATE TABLE bronze.inventory_transactions;

        PRINT '>> Inserting Data Into: bronze.inventory_transactions';
        BULK INSERT bronze.inventory_transactions
        FROM 'C:\Users\Isaias\Desktop\RME-OPS-DATA\inventory_transactions.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';
        PRINT '---------------------------------------------------------------------';

        -- Load bronze.parts
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.parts';
        TRUNCATE TABLE bronze.parts;

        PRINT '>> Inserting Data Into: bronze.parts';
        BULK INSERT bronze.parts
        FROM 'C:\Users\Isaias\Desktop\RME-OPS-DATA\parts.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';
        PRINT '---------------------------------------------------------------------';

        -- Load bronze.parts_usage
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.parts_usage';
        TRUNCATE TABLE bronze.parts_usage;

        PRINT '>> Inserting Data Into: bronze.parts_usage';
        BULK INSERT bronze.parts_usage
        FROM 'C:\Users\Isaias\Desktop\RME-OPS-DATA\parts_usage.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';
        PRINT '---------------------------------------------------------------------';

        -- Load bronze.work_orders
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.work_orders';
        TRUNCATE TABLE bronze.work_orders;

        PRINT '>> Inserting Data Into: bronze.work_orders';
        BULK INSERT bronze.work_orders
        FROM 'C:\Users\Isaias\Desktop\RME-OPS-DATA\work_orders.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';
        PRINT '---------------------------------------------------------------------';

        -- Total batch duration
        SET @batch_end_time = GETDATE();

        PRINT '=================================================';
        PRINT 'Loading Bronze Layer is Completed';
        PRINT '>> Total Load Duration: '
            + CAST(
                DATEDIFF(SECOND, @batch_start_time, @batch_end_time)
                AS NVARCHAR(20)
            )
            + ' seconds';
        PRINT '=================================================';

    END TRY
    BEGIN CATCH
        PRINT '================================================================';
        PRINT 'Error Occurred During Loading Bronze Layer';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(20));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(20));
        PRINT '================================================================';
    END CATCH;
END;


EXEC  bronze.load_bronze 
