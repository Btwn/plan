SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spEmbarqueVerificar]
 @ID INT
,@Accion CHAR(20)
,@Empresa CHAR(5)
,@Usuario CHAR(10)
,@Modulo CHAR(5)
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@MovTipo CHAR(20)
,@FechaEmision DATETIME
,@Estatus CHAR(15)
,@EstatusNuevo CHAR(15)
,@Vehiculo CHAR(10)
,@PersonalCobrador VARCHAR(10)
,@Conexion BIT
,@SincroFinal BIT
,@Sucursal INT
,@CfgDesembarquesParciales BIT
,@AntecedenteID INT OUTPUT
,@AntecedenteMovTipo CHAR(20) OUTPUT
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
AS
BEGIN
	DECLARE
		@ModuloID INT
	   ,@EstadoTipo CHAR(20)
	   ,@Cliente CHAR(10)
	   ,@Proveedor CHAR(10)
	   ,@Importe MONEY

	IF @Accion = 'CANCELAR'
	BEGIN

		IF EXISTS (SELECT * FROM EmbarqueD WHERE ID = @ID AND DesembarqueParcial = 1)
			SELECT @Ok = 42050

		RETURN
	END
	ELSE
	BEGIN

		IF @Estatus = 'SINAFECTAR'
		BEGIN

			IF NOT EXISTS (SELECT * FROM EmbarqueD WHERE ID = @ID)
				SELECT @Ok = 60010

			IF (
					SELECT Estatus
					FROM Vehiculo
					WHERE Vehiculo = @Vehiculo
				)
				= 'ENTRANSITO'
				SELECT @Ok = 42010
			ELSE
			BEGIN
				SELECT @ModuloID = NULL
				SELECT @ModuloID = MIN(e.ModuloID)
				FROM EmbarqueDArt e
				INNER JOIN VentaD d
					ON e.ModuloID = d.ID
				INNER JOIN VENTA
					ON VENTA.ID = D.ID
				INNER JOIN EmpresaCfg2
					ON EmpresaCfg2.Empresa = VENTA.Empresa
				WHERE e.ID = @ID
				AND e.Modulo = 'VTAS'
				AND e.Renglon = d.Renglon
				AND e.RenglonSub = d.RenglonSub
				AND (e.Cantidad < 0 OR e.Cantidad > (d.Cantidad - ISNULL(d.CantidadCancelada, 0) - ISNULL(d.CantidadEmbarcada, 0)))
				AND d.Articulo <> EmpresaCfg2.CxcAnticipoArticuloServicio
				AND EmpresaCfg2.Empresa = @Empresa

				IF @ModuloID IS NOT NULL
					SELECT @Ok = 20010
						  ,@OkRef = RTRIM(Mov) + ' ' + RTRIM(MovID)
					FROM Venta
					WHERE ID = @ModuloID

			END

		END

		IF @Estatus = 'PENDIENTE'
		BEGIN
			DECLARE
				crEstado
				CURSOR FOR
				SELECT RTRIM(UPPER(e.Tipo))
					  ,NULLIF(RTRIM(m.Cliente), '')
					  ,NULLIF(RTRIM(m.Proveedor), '')
					  ,ISNULL(d.Importe, 0.0)
				FROM EmbarqueD d
				JOIN EmbarqueMov m
					ON d.EmbarqueMov = m.ID
				LEFT OUTER JOIN EmbarqueEstado e
					ON d.Estado = e.Estado
				WHERE d.ID = @ID
			OPEN crEstado
			FETCH NEXT FROM crEstado INTO @EstadoTipo, @Cliente, @Proveedor, @Importe
			WHILE @@FETCH_STATUS <> -1
			AND @Ok IS NULL
			BEGIN

			IF @@FETCH_STATUS <> -2
				AND @Ok IS NULL
			BEGIN

				IF @EstadoTipo = 'PENDIENTE'
					AND @CfgDesembarquesParciales = 0
					SELECT @Ok = 30340
				ELSE

				IF @EstadoTipo IN (NULL, '', 'PENDIENTE', 'TRANSITO')
					SELECT @Ok = 30340
				ELSE

				IF @EstadoTipo = 'COBRADO'
					AND @Cliente IS NULL
					SELECT @Ok = 20180
				ELSE

				IF @EstadoTipo = 'PAGADO'
					AND @Proveedor IS NULL
					SELECT @Ok = 20180
				ELSE

				IF @EstadoTipo IN ('COBRADO', 'PAGADO')
					AND @Importe = 0.0
					SELECT @Ok = 40140

			END

			FETCH NEXT FROM crEstado INTO @EstadoTipo, @Cliente, @Proveedor, @Importe
			END
			CLOSE crEstado
			DEALLOCATE crEstado
		END

	END

	RETURN
END

