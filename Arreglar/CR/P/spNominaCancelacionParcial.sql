SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaCancelacionParcial
@Empresa	char(5),
@Sucursal	int,
@Usuario	char(10),
@ID		int,
@Personal	char(10),
@FechaEmision	datetime = NULL

AS BEGIN
DECLARE
@Mov	char(20),
@Concepto	varchar(50),
@Referencia	varchar(50),
@Importe	money,
@Cantidad	float,
@Renglon	float,
@IDNuevo	int,
@Origen	char(20),
@OrigenID	varchar(20)
SELECT @Mov = NomCancelacionParcial
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT @Origen = Mov, @OrigenID = MovID FROM Nomina WHERE ID = @ID
IF EXISTS(SELECT * FROM Nomina n, NominaD d WHERE n.Mov = @Mov AND n.Empresa = @Empresa AND n.OrigenTipo = 'NOM' AND n.Origen = @Origen AND OrigenID = @OrigenID AND n.Estatus NOT IN ('SINAFECTAR', 'CANCELADO') AND d.ID = n.ID AND d.Personal = @Personal)
BEGIN
SELECT 'Esta Persona Ya Tiene una Cancelacion Parcial Realizada '+RTRIM(@Personal)
RETURN
END
BEGIN TRANSACTION
INSERT Nomina (Sucursal,  SucursalOrigen, SucursalDestino, Empresa,  Mov,  FechaEmision,                         FechaCancelacion, Proyecto, Usuario,  Moneda, TipoCambio,  Estatus,    FechaOrigen, PeriodoTipo, FechaD, FechaA, OrigenTipo, Origen, OrigenID)
SELECT Sucursal,         @Sucursal,      Sucursal,       @Empresa, @Mov, ISNULL(@FechaEmision, FechaEmision),  GETDATE(),        Proyecto, @Usuario,  Moneda, TipoCambio, 'BORRADOR', FechaOrigen, PeriodoTipo, FechaD, FechaA, 'NOM',      @Origen, @OrigenID
FROM Nomina
WHERE ID = @ID
SELECT @IDNuevo = SCOPE_IDENTITY()
SELECT * INTO #NominaD FROM cNominaD WHERE ID = @ID AND Personal = @Personal
UPDATE #NominaD SET SucursalOrigen = @Sucursal, ID = @IDNuevo, Importe = -Importe, Cantidad = -Cantidad
INSERT INTO cNominaD SELECT * FROM #NominaD
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
SELECT @Importe = Importe, @Cantidad = Cantidad FROM NominaD WHERE ID = @ID AND Concepto = @Concepto AND ISNULL(Referencia, '') = @Referencia AND Modulo = 'NOM' AND Personal = @Personal
IF @Importe IS NOT NULL
BEGIN
SELECT * INTO #NominaD2 FROM cNominaD WHERE ID = @ID AND Renglon = @Renglon
UPDATE #NominaD2 SET SucursalOrigen = @Sucursal, ID = @IDNuevo, Importe = -@Importe, Cantidad = -@Cantidad, Referencia = NULL
INSERT INTO cNominaD SELECT * FROM #NominaD2
DROP TABLE #NominaD2
END
END
FETCH NEXT FROM crNominaD INTO @Concepto, @Referencia, @Renglon
END  
CLOSE crNominaD
DEALLOCATE crNominaD
IF EXISTS(SELECT * FROM NominaD WHERE ID = @IDNuevo)
BEGIN
COMMIT TRANSACTION
SELECT 'Se Genero '+RTRIM(@Mov)+' en Borrador.'
END ELSE
BEGIN
ROLLBACK TRANSACTION
SELECT 'La Persona Indicada No Existe, En Este Movimiento.'
END
RETURN
END

