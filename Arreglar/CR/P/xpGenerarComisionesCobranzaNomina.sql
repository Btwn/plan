SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpGenerarComisionesCobranzaNomina
@Empresa	char(5),
@Usuario	char(10),
@Sucursal	int,
@FechaEmision	datetime,
@Mov		char(20),
@Concepto	varchar(50),
@Moneda		char(10),
@EsBono		bit,
@MovID		varchar(20)	OUTPUT,
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT
AS BEGIN
DECLARE
@NominaID		int,
@Renglon		float,
@FechaRegistro	datetime,
@TipoCambio		float,
@Personal		char(10),
@Importe		money
SELECT @FechaRegistro = GETDATE()
SELECT @TipoCambio = TipoCambio FROM Mon WHERE Moneda = @Moneda
INSERT INTO Nomina (Sucursal,  Empresa,  Mov,  FechaEmision,  Concepto,  Moneda,  TipoCambio,  Usuario,  Estatus)
VALUES (@Sucursal, @Empresa, @Mov, @FechaEmision, @Concepto, @Moneda, @TipoCambio, @Usuario, 'SINAFECTAR')
SELECT @NominaID = SCOPE_IDENTITY()
DECLARE crNominaD CURSOR FOR
SELECT Personal, NULLIF(SUM(CASE WHEN @EsBono = 1 THEN Bono ELSE Comision END), 0.0)
FROM #Comision
GROUP BY Personal
ORDER BY Personal
SELECT @Renglon = 0.0
OPEN crNominaD
FETCH NEXT FROM crNominaD INTO @Personal, @Importe
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL AND @Importe IS NOT NULL
BEGIN
SELECT @Renglon = @Renglon + 2048
INSERT NominaD (Sucursal,  ID,        Renglon,  Personal, Importe)
VALUES (@Sucursal, @NominaID, @Renglon, @Personal, @Importe)
END
FETCH NEXT FROM crNominaD INTO @Personal, @Importe
END  
CLOSE crNominaD
DEALLOCATE crNominaD
IF EXISTS(SELECT * FROM NominaD WHERE ID = @NominaID)
EXEC spNomina @NominaID, 'NOM', 'AFECTAR', 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0,
@Mov OUTPUT, @MovID OUTPUT, NULL, @Ok OUTPUT, @OkRef OUTPUT
ELSE
DELETE Nomina WHERE ID = @NominaID
RETURN
END

