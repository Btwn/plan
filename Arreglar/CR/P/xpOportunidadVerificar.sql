SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpOportunidadVerificar
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@MovTipoCambio		float,
@FechaEmision		datetime,
@Estatus			char(15),
@EstatusNuevo		char(15),
@NivelInteres		varchar(50),
@Plantilla			varchar(20),
@ContactoTipo		varchar(20),
@Contacto			varchar(10),
@ImporteOportunidad	float,
@PorcentajeCierre	float,
@ImportePonderado	float,
@ProbCierre			float,
@Competidor			varchar(50),
@Motivo				varchar(100),
@Propuesta			varchar(50),
@Intermediario		varchar(10),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT
AS
BEGIN
RETURN
END

