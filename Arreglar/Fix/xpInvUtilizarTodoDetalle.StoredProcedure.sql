SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[xpInvUtilizarTodoDetalle]
 @Sucursal INT
,@Modulo CHAR(5)
,@Base CHAR(20)
,@OID INT
,@OrigenMov CHAR(20)
,@OrigenMovID VARCHAR(20)
,@OrigenMovTipo CHAR(20)
,@DID INT
,@GenerarDirecto BIT
,@Ok INT OUTPUT
AS
BEGIN
	DECLARE
		@MovOrigen VARCHAR(20)
	   ,@EsModVenta BIT
	SELECT @MovOrigen = Mov
		  ,@EsModVenta = EsModVenta
	FROM Venta
	WHERE ID = @OID

	IF @EsModVenta <> 1
	BEGIN

		IF @Modulo = 'VTAS'
			AND @Base = 'TODO'
			AND @MovOrigen IN ('Solicitud Credito', 'Solicitud Mayoreo', 'Analisis Credito', 'Analisis Mayoreo', 'Pedido', 'Pedido Mayoreo', 'Factura', 'Factura VIU', 'Factura Mayoreo', 'Credilana', 'Prestamo Personal', 'Seguro Auto', 'Seguro Vida')
		BEGIN
			UPDATE VentaD
			SET Cantidad = NULL
			WHERE ID = @DID
		END

	END

	RETURN
END
GO