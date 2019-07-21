SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSAUXVerificar
@ID               	int,
@Accion				char(20),
@Empresa          	char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              	char(20),
@MovID				varchar(20),
@MovTipo	      	char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@Estatus			char(15),
@EstatusNuevo		char(15),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@Almacen			char(10),
@Agente				varchar(10),
@Ok               	int          OUTPUT,
@OkRef            	varchar(255) OUTPUT

AS BEGIN
DECLARE
@Servicio			varchar(20),
@Cantidad			int,
@Producto			varchar(20),
@Indicador			varchar(20),
@Valor				varchar(255),
@Contacto			varchar(20)
IF @Accion = 'CANCELAR'
BEGIN
IF @Conexion = 0
IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
SELECT @Ok = 60070
END
SELECT @Contacto = NULLIF(RTRIM(Contacto), '')
FROM SAUX
WHERE ID = @ID
IF @contacto IS NULL SELECT @Ok = 40010
IF NOT EXISTS (SELECT * FROM SAUXD d WHERE d.ID = @ID) AND @Ok IS NULL
SELECT @Ok = 60010
IF @Ok IS NULL
BEGIN
DECLARE crVerificarSAUXD CURSOR LOCAL FOR
SELECT NULLIF(RTRIM(d.Servicio), ''), ISNULL(d.Cantidad, 0), NULLIF(RTRIM(d.Producto), '')
FROM SAUXD d
WHERE d.ID = @ID
OPEN crVerificarSAUXD
FETCH NEXT FROM crVerificarSAUXD INTO @Servicio, @Cantidad, @Producto
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Servicio IS NULL OR NOT EXISTS (SELECT * FROM SAUXServicio WHERE Servicio = @Servicio) SELECT @Ok = 75010 ELSE
IF @Cantidad IS NULL OR @Cantidad = '' SELECT @Ok = 20011 ELSE
IF @Producto IS NULL OR NOT EXISTS(SELECT * FROM Art WHERE Articulo = @Producto) SELECT @Ok = 75020
IF @MovTipo = 'SAUX.S' AND @EstatusNuevo = 'CONCLUIDO' AND @Ok IS NULL
BEGIN
DECLARE crVerificarIndicador CURSOR LOCAL FOR
SELECT i.Indicador, s.Valor
FROM SAUXIndicador i
JOIN SAUXDIndicador s ON s.Indicador = i.Indicador AND s.ID = @ID AND s.Servicio = @Servicio
OPEN crVerificarIndicador
FETCH NEXT FROM crVerificarIndicador INTO @Indicador, @valor
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND @Ok IS NULL
IF dbo.fnValidarIndicadores(@ID, @Indicador, @Valor) = 1
SELECT @Ok = 75040
IF @Ok IS NOT NULL AND @OkRef IS NULL SELECT @OkRef = @Servicio
FETCH NEXT FROM crVerificarIndicador INTO @Indicador, @valor
END
CLOSE crVerificarIndicador
DEALLOCATE crVerificarIndicador
END
END
IF @Ok IS NOT NULL AND @OkRef IS NULL SELECT @OkRef = @Servicio
FETCH NEXT FROM crVerificarSAUXD INTO @Servicio, @Cantidad, @Producto
END
CLOSE crVerificarSAUXD
DEALLOCATE crVerificarSAUXD
END
IF @MovTipo = 'SAUX.S' AND @EstatusNuevo = 'CONCLUIDO' AND @Ok IS NULL
IF dbo.fnValidarIndicadoresID(@ID) = 1 SELECT @Ok = 75040
RETURN
END

