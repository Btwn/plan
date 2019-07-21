SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMonederoActivar
@Empresa	varchar(5),
@Serie		varchar(20),
@Usuario	varchar(10),
@Sucursal	int,
@Ok		int				OUTPUT,
@OkRef		varchar(255)	OUTPUT
AS BEGIN
DECLARE @FechaAlta			datetime,
@FechaActivacion	datetime,
@IDMonedero			int
SET @FechaActivacion = GETDATE()
SET @FechaAlta = dbo.fnFechaSinHora(@FechaActivacion)
SET @Serie = UPPER(@Serie)
IF NOT EXISTS (SELECT * FROM TarjetaMonedero  WITH (NOLOCK) WHERE Empresa = @Empresa AND Serie = @Serie)
INSERT INTO TarjetaMonedero (Empresa,	Serie,	Estatus,	TieneMovimientos,	Usuario,	FechaAlta,	UsuarioActivacion,	FechaActivacion,	FechaBaja)
VALUES						(@Empresa, @Serie,	'ALTA',		0,					@Usuario,	@FechaAlta, NULL,				NULL,				NULL)
IF @@ERROR <> 0	SET @Ok = 1
IF @Ok IS NULL
BEGIN
INSERT INTO Monedero (Empresa,	Mov,					MovID,	FechaEmision,	UltimoCambio,		UEN,	Usuario,	Observaciones,	Referencia, Estatus,
Ejercicio,	Periodo,	FechaRegistro,	FechaConclusion,	FechaCancelacion,	Importe,	Sucursal,	SucursalOrigen, SucursalDestino)
VALUES				 (@Empresa, 'Activacion Tarjeta',	NULL,	@FechaAlta,		@FechaActivacion,	NULL,	@Usuario,	'Alta POS',		NULL,		'SINAFECTAR',
NULL,		NULL,		NULL,			NULL,				NULL,				NULL,		@Sucursal,	@Sucursal,		NULL)
SELECT @IDMonedero = SCOPE_IDENTITY()
IF @@ERROR <> 0	SET	@Ok = 1
IF @Ok IS NULL
BEGIN
INSERT INTO MonederoD (ID,			Renglon,	RenglonSub, Serie,	SerieDestino,	Importe,	Sucursal,	SucursalOrigen)
VALUES				  (@IDMonedero, 2048.0,		0,			@Serie, NULL,			NULL,		@Sucursal,	@Sucursal)
IF @@ERROR <> 0	SET	@Ok = 1
END
IF @Ok IS NULL
EXEC spAfectarMonederoWS @Empresa, @Sucursal, 'AFECTAR', @IDMonedero, @Usuario, 'MONEL', 'Activacion Tarjeta', 'SINAFECTAR', @Ok OUTPUT, @OkRef OUTPUT
END
END

