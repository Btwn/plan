SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNetAmenidadesCte
@Cliente 			varchar(20)

AS
BEGIN
BEGIN TRAN
BEGIN TRY
SELECT
A.ID as ID,
A.Espacio as Espacio,
A.DiaCompletoHora as DiaCompletoHora,
E.Nombre as Nombre,
CONVERT(VARCHAR(24),A.FechaDesde,121) as FechaDesde,
CONVERT(VARCHAR(24),A.FechaHasta,121) as FechaHasta,
A.NumPersonas as NumPersonas,
A.Vivienda as Vivienda,
A.Telefono as Telefono,
A.eMail as eMail,
A.Observaciones as Observaciones
from Amenidades as A
INNER JOIN Espacio as E ON A.Espacio = E.Espacio
WHERE A.Cliente = @Cliente
COMMIT TRAN
END TRY
BEGIN CATCH
SELECT -1 Ok, ERROR_MESSAGE() OkRef
ROLLBACK TRAN
END CATCH
END

