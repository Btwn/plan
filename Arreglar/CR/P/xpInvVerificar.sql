SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[xpInvVerificar]
 @ID INT
,@Accion CHAR(20)
,@Base CHAR(20)
,@Empresa CHAR(5)
,@Usuario CHAR(10)
,@Modulo CHAR(5)
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@MovTipo CHAR(20)
,@MovMoneda CHAR(10)
,@MovTipoCambio FLOAT
,@Estatus CHAR(15)
,@EstatusNuevo CHAR(15)
,@FechaEmision DATETIME
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@Conteo INT
	   ,@Renglon FLOAT
	   ,@TotReg INT
	   ,@Art VARCHAR(20)
	   ,@Precio MONEY
	   ,@PrecioArt MONEY
	   ,@PrecioAnterior MONEY
	   ,@Origen VARCHAR(20)
	   ,@Redime BIT
	   ,@Sucursal INT
	   ,@bloq VARCHAR(15)

	IF @Modulo = 'VTAS'
		SELECT @Origen = Origen
			  ,@Sucursal = Sucursal
		FROM Venta
		WHERE ID = @ID

	IF @Modulo = 'VTAS'
		AND @Accion IN ('AFECTAR', 'VERIFICAR')
		AND @Mov IN ('Solicitud Credito', 'Solicitud Mayoreo')
		OR (@Mov = 'Pedido' AND @Origen IS NULL)
		AND @Estatus = 'SINAFECTAR'
	BEGIN
		SELECT @Redime = RedimePtos
		FROM Venta
		WHERE ID = @ID
		DECLARE
			crArtPrecio
			CURSOR LOCAL FORWARD_ONLY FOR
			SELECT Renglon
				  ,D.Articulo
				  ,Precio
				  ,D.PrecioAnterior
				  ,A.Estatus
			FROM VentaD D
			LEFT JOIN Art A
				ON A.Articulo = D.Articulo
				AND A.Familia = 'Calzado'
				AND A.Estatus = 'Bloqueado'
			WHERE ID = @ID
		OPEN crArtPrecio
		FETCH NEXT FROM crArtPrecio INTO @Renglon, @Art, @PrecioArt, @PrecioAnterior, @bloq
		WHILE @@FETCH_STATUS <> -1
		AND @Ok IS NULL
		BEGIN

		IF @@FETCH_STATUS <> -2
			AND NULLIF(@Art, '') IS NOT NULL
		BEGIN
			SET @Precio = dbo.fnPropreprecio(@ID, @Art, @Renglon, @Redime)

			IF (ISNULL(@PrecioAnterior, @PrecioArt) <> @Precio)
				AND (@bloq <> 'Bloqueado')
				AND (@Sucursal NOT IN (SELECT Nombre FROM TablaStD WHERE TablaSt = 'SUCURSALES LINEA')
				)
				SELECT @Ok = 20305
					  ,@OkRef = RTRIM(@Art)

		END

		FETCH NEXT FROM crArtPrecio INTO @Renglon, @Art, @PrecioArt, @PrecioAnterior, @bloq
		END
		CLOSE crArtPrecio
		DEALLOCATE crArtPrecio
	END

	RETURN
END

