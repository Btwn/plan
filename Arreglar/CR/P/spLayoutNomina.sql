SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spLayoutNomina
@Estacion			int,
@Ok				    int					OUTPUT,
@OkRef			    varchar(255)		OUTPUT

AS BEGIN
DECLARE
@Transaccion	    varchar(50),
@LayoutNomina       varchar(100),
@Empresa			varchar(5),
@Mov				varchar(20),
@MovID				varchar(20),
@NumeroCliente		varchar(10),
@Consecutivo			int,
@Descripcion		varchar(20),
@Cuenta  			varchar(10),
@Sucursal			varchar(50),
@FechaAplicacion    datetime
SET @Ok = NULL
SET @OkRef = NULL
SET @Transaccion = 'spLayoutNomina' + RTRIM(LTRIM(CONVERT(varchar,@Estacion)))
BEGIN TRANSACTION @Transaccion
SELECT
@LayoutNomina = InfoLayoutNomina,
@Empresa = InfoEmpresa,
@Mov = InfoMov,
@MovID = InfoMovID,
@NumeroCliente = InfoNumeroCliente,
@Consecutivo = InfoConsecutivo,
@Descripcion = InfoDescripcion,
@Cuenta = InfoCtaDinero,
@Sucursal = InfoSucursal,
@FechaAplicacion = InfoFechaD
FROM RepParam
WHERE Estacion = @Estacion
IF @LayoutNomina = 'Banamex'
EXEC spLayoutNominaBanamexD @Estacion  , @Empresa , @Mov , @MovID , @NumeroCliente , @Consecutivo , @Descripcion , @Cuenta , @Sucursal , @Ok OUTPUT , @OkRef OUTPUT
ELSE
IF @LayoutNomina = 'Santander'
EXEC spLayoutNominaSantander @Estacion , @Empresa , @Mov , @MovID , @NumeroCliente , @Consecutivo , @Descripcion	, @Cuenta , @Sucursal , @FechaAplicacion , @Ok 	OUTPUT , @OkRef OUTPUT
ELSE
IF @LayoutNomina = 'Bancomer'
EXEC spLayoutNominaBancomer  @Estacion  , @Empresa , @Mov , @MovID , @NumeroCliente , @Consecutivo , @Cuenta , @Sucursal , @Descripcion , @Ok OUTPUT , @OkRef OUTPUT
ELSE
IF @LayoutNomina = 'Inbursa'
EXEC spLayoutNominaInbursa @Estacion  , @Empresa , @Mov , @MovID , @Cuenta , @Sucursal , @NumeroCliente , @Consecutivo , @Ok OUTPUT, @OkRef OUTPUT
ELSE
IF @LayoutNomina = 'Banorte'
EXEC spLayoutNominaBanorte 	@Estacion , @Empresa , @Mov , @MovID , @NumeroCliente , @Consecutivo , @Descripcion	, @Cuenta , @Sucursal , @Ok OUTPUT , @OkRef 		OUTPUT
IF @Ok IS NULL
BEGIN
COMMIT TRANSACTION @Transaccion
END ELSE
BEGIN
ROLLBACK TRANSACTION @Transaccion
SELECT 'ERROR: ' + CONVERT(varchar,@Ok) + (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok) +'. ' + ISNULL(@OkRef,'')
END
END

