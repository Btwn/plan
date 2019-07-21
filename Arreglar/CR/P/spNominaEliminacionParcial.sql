SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaEliminacionParcial
@Empresa	char(5),
@Sucursal	int,
@Usuario	char(10),
@ID		int,
@Personal	char(10),
@FechaEmision	datetime = NULL

AS BEGIN
DECLARE
@Concepto	varchar(50),
@Referencia	varchar(50),
@Importe	money,
@Cantidad	float,
@Renglon	float,
@IDNuevo	int
BEGIN TRANSACTION
/*
Para calcular la proporcion que se debe de cancelar de los movimientos que afectan a cxp y dinero,
los conceptos de los movimientos deben exitir en un movimiento de la nomina.
*/
DECLARE crNominaD CURSOR FOR
SELECT Concepto, ISNULL(Referencia, ''), MIN(Renglon)
FROM NominaD
WHERE ID = @ID AND Modulo IN ('CXP', 'DIN', 'GAS')
GROUP BY Concepto, ISNULL(Referencia, '')
OPEN crNominaD
FETCH NEXT FROM crNominaD INTO @Concepto, @Referencia, @Renglon
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Importe = NULL, @Cantidad = NULL
SELECT @Importe = ISNULL(Importe, 0), @Cantidad = ISNULL(Cantidad, 0) FROM NominaD WHERE ID = @ID AND Concepto = @Concepto AND ISNULL(Referencia, '') = @Referencia AND Modulo = 'NOM' AND Personal = @Personal
IF @Importe IS NOT NULL
UPDATE NominaD SET Importe = NULLIF(ISNULL(Importe, 0)-@Importe, 0), Cantidad = NULLIF(ISNULL(Cantidad, 0)-@Cantidad, 0) WHERE ID = @ID AND Concepto = @Concepto AND ISNULL(Referencia, '') = @Referencia AND Modulo IN ('CXP', 'DIN', 'GAS')
END
FETCH NEXT FROM crNominaD INTO @Concepto, @Referencia, @Renglon
END  
CLOSE crNominaD
DEALLOCATE crNominaD
DELETE NominaD WHERE ID = @ID AND Personal = @Personal
/*
Bug 24358. Cuando hay incidencias, el generar el borrador de la nómina implica agregar registros en la tabla NominaCorrespondeLote.
Si se elimina un empleado (Eliminación Parcial) de dicho borrador, también se debe eliminar esa información de la
tabla NominaCorrespondeLote.
*/
DELETE NominaCorrespondeLote WHERE IDNomina = @ID AND Personal = @Personal
IF @@ROWCOUNT > 0
BEGIN
COMMIT TRANSACTION
SELECT 'Se Elimino a '+RTRIM(@Personal)+' del Borrador.'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT 'La Persona indicada No Existe, en este Movimiento.'
END
RETURN
END

