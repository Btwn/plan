SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMonVerificar
@ID                		int,
@Accion					varchar(20),
@Base					varchar(20),
@Empresa	      		varchar(5),
@Usuario				varchar(10),
@Modulo	      			varchar(5),
@Mov	  	      		varchar(20),
@MovID             		varchar(20),
@MovTipo     			varchar(20),
@MovMoneda	      		varchar(10),
@MovTipoCambio	 		float,
@Estatus	 	      	varchar(15),
@EstatusNuevo	      	varchar(15),
@FechaEmision			datetime,
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT
AS
BEGIN
DECLARE
@Sucursal         int,
@FechaRegistro	datetime,
@Bandera			int,
@Serie			VARCHAR(20),
@Redime			int
SELECT @Sucursal = Sucursal, @FechaRegistro = FechaRegistro, @Serie = NULLIF(Monedero,'') ,@Redime = RedimePuntos
FROM Venta WITH(NOLOCK)
WHERE ID = @ID
IF @Modulo = 'VTAS' AND @Accion = 'AFECTAR' AND @Estatus = 'SINAFECTAR' AND @EstatusNuevo IN ('PROCESAR','CONCLUIDO')/* AND @MovTipo = 'VTAS.N' */AND @Serie IS NOT NULL
BEGIN
IF NOT EXISTS (SELECT * FROM TarjetaMonedero WITH (NOLOCK) WHERE  Serie =  @Serie) AND @Redime = 0
BEGIN
SELECT @OK =2122, @OKREF='La Serie no Existe'
END
ELSE
BEGIN
IF NOT EXISTS(SELECT * FROM SerieTarjetaMovM WITH (NOLOCK) WHERE Modulo = 'VTAS' AND ID = @ID)
BEGIN
INSERT SerieTarjetaMovM
(Empresa , Modulo, ID , Serie , Importe  , Sucursal)
SELECT Empresa , 'VTAS', ID , Monedero , Importe  , Sucursal
FROM Venta WITH (NOLOCK)
WHERE  ID = @ID
END
END
END
RETURN
END

