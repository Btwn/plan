SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spMovGenerar]
 @Sucursal INT
,@Empresa CHAR(5)
,@Modulo CHAR(5)
,@Ejercicio INT
,@Periodo INT
,@Usuario CHAR(10)
,@FechaEmision DATETIME
,@Estatus CHAR(15)
,@Almacen CHAR(10)
,@AlmacenDestino CHAR(10)
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@GenerarDirecto BIT
,@GenerarMov CHAR(20)
,@GenerarSerie CHAR(20)
,@GenerarMovID VARCHAR(20) OUTPUT
,@GenerarID INT OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) = NULL OUTPUT
AS
BEGIN
	DECLARE
		@ID INT
	   ,@Moneda CHAR(10)
	   ,@TipoCambio FLOAT
	   ,@CFD BIT
	   ,@CFDFlex BIT
		 ,@CopiarBitacoraOrigen BIT
	   ,@ArrastrarTipoCambioGenerarMov BIT
	SELECT @CFD = 0
		  ,@CFDFlex = 0

	IF @Ok IS NOT NULL
		RETURN

	EXEC spExtraerFecha @FechaEmision OUTPUT
	BEGIN TRANSACTION
	EXEC spMovEnID @Modulo
				  ,@Empresa
				  ,@Mov
				  ,@MovID
				  ,@ID OUTPUT
				  ,@Moneda OUTPUT
				  ,@Ok OUTPUT
	SELECT @TipoCambio = TipoCambio
	FROM Mon WITH(NOLOCK)
	WHERE Moneda = @Moneda
	SELECT @CopiarBitacoraOrigen = ISNULL(CopiarBitacoraOrigen, 0)
		  ,@ArrastrarTipoCambioGenerarMov = ISNULL(ArrastrarTipoCambioGenerarMov, 0)
	FROM EmpresaGral WITH(NOLOCK)
	WHERE Empresa = @Empresa

	IF @ArrastrarTipoCambioGenerarMov = 1
		OR (
			SELECT ISNULL(ArrastrarTipoCambioGenerarMov, 0)
			FROM MovTipo WITH(NOLOCK)
			WHERE Modulo = @Modulo
			AND Mov = @GenerarMov
		)
		= 1
		SELECT @TipoCambio = NULL

	IF @Estatus IN ('SINAFECTAR', 'CONFIRMAR', 'BORRADOR')
		SELECT @GenerarMovID = NULL
	ELSE
		EXEC spConsecutivoAuto @Sucursal
							  ,@Empresa
							  ,@Modulo
							  ,@GenerarMov
							  ,@Ejercicio
							  ,@Periodo
							  ,@GenerarSerie
							  ,@GenerarMovID OUTPUT
							  ,@Ok OUTPUT
							  ,@OkRef OUTPUT
							  ,@CFD OUTPUT
							  ,@CFDFlex OUTPUT

	EXEC spMovCopiarEncabezado @Sucursal
							  ,@Modulo
							  ,@ID
							  ,@Empresa
							  ,@Mov
							  ,@MovID
							  ,@Usuario
							  ,@FechaEmision
							  ,@Estatus
							  ,@Moneda
							  ,@TipoCambio
							  ,@Almacen
							  ,@AlmacenDestino
							  ,@GenerarDirecto
							  ,@GenerarMov
							  ,@GenerarMovID
							  ,@GenerarID OUTPUT
							  ,@Ok OUTPUT
							  ,@CopiarBitacoraOrigen

	IF @GenerarID IS NOT NULL
		EXEC xpMovGenerar @Sucursal
						 ,@Empresa
						 ,@Modulo
						 ,@ID
						 ,@Usuario
						 ,@FechaEmision
						 ,@Mov
						 ,@MovID
						 ,@GenerarDirecto
						 ,@GenerarMov
						 ,@GenerarSerie
						 ,@GenerarMovID
						 ,@GenerarID
						 ,@Ok OUTPUT
						 ,@OkRef OUTPUT

	COMMIT TRANSACTION
	RETURN
END

