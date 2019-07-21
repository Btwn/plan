SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpContratoVerificar
@ID				int,
@Accion				char(20),
@Empresa			char(5),
@Usuario			char(10),
@Modulo				char(5),
@Mov				char(20),
@MovID				varchar(20),
@MovTipo			char(20),
@FechaEmision			datetime,
@Estatus			char(15),
@EstatusNuevo			char(15),
@ContactoTipo			varchar(20),
@Prospecto			varchar(10),
@Cliente			varchar(10),
@Proveedor			varchar(10),
@Personal			varchar(10),
@Agente				varchar(10),
@ContratoRama			varchar(50),
@Desde				datetime,
@Hasta				datetime,
@Prioridad			varchar(10),
@Titulo				varchar(100),
@Contrato			varchar(50),
@IDOrigen			int,
@RamaID				int,
@OrigenTipo			varchar(20),
@Origen				varchar(20),
@OrigenID			varchar(20),
@FechaRegistro			datetime,
@Conexion			bit,
@SincroFinal			bit,
@Sucursal			int,
@Ok				int		OUTPUT,
@OkRef				varchar(255)	OUTPUT
AS
BEGIN
RETURN
END

