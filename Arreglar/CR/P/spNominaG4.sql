SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaG4
@Estacion    INT,
@Empresa     VARCHAR(5),
@Sucursal    INT,
@ID          INT,
@PeriodoTipo VARCHAR(50),
@FechaD      DATETIME,
@FechaA      DATETIME

AS
BEGIN
DECLARE
@Mov          VARCHAR(20),
@TipoNominaG4 VARCHAR(50),
@Ok          INT,
@OkRef       VARCHAR(255)
SELECT @Mov = Mov FROM Nomina WHERE ID = @ID
SELECT @TipoNominaG4 = TipoNominaG4 FROM NomX WHERE NomMov = @Mov
EXEC spNominaG4Validar @Estacion, @Empresa, @Sucursal, @ID, @PeriodoTipo, @FechaD, @FechaA, @TipoNominaG4, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok = NULL
BEGIN
IF @TipoNominaG4 IN ('Nomina Normal', 'Nomina Finiquito', 'Nomina Liquidacion')
EXEC spNominaG4Archivos @Estacion, @Empresa, @Sucursal, @ID, @PeriodoTipo, @FechaD, @FechaA, @TipoNominaG4
END
ELSE
SELECT @OkRef
RETURN
END

