SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNetAmenidadesBorrarEspacio
@ID				INT,
@Espacio			VARCHAR(20),
@FechaReservacion	VARCHAR(20),
@HorasEvento		VARCHAR(MAX)
AS BEGIN
DECLARE @HoraRequerida NVARCHAR(255)
DECLARE db_cursor CURSOR FOR
SELECT * FROM dbo.splitstring(@HorasEvento)
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @HoraRequerida
WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE @FechaRequerida   VARCHAR(MAX)
SET @FechaRequerida = @FechaReservacion + ' ' + @HoraRequerida
select @FechaRequerida
DELETE VentaD WHERE ID = @ID AND Espacio = @Espacio AND FechaRequerida = @FechaRequerida
FETCH NEXT FROM db_cursor INTO @HoraRequerida
END
CLOSE db_cursor
DEALLOCATE db_cursor
END

