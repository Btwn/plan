SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER  PROCEDURE dbo.spISIntelisisMovilCxCPendientesEnvio
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
BEGIN TRY
SELECT @Resultado = '<CxCPendientesEnvio><Cliente>' + 'Cliente' + '</Cliente></CxCPendientesEnvio>'
DECLARE
@Movimiento		Varchar (20) ,
@MovId			Varchar (20) ,
@IdVisita       Int  ,
@IDCxC			Int  ,
@Cliente        Varchar (10) ,
@Saldo          Money ,
@Fecha          Datetime ,
@Seleccion      varchar(5)
SELECT
@Movimiento  = Movimiento,
@MovId		 = MovId,
@IdVisita    = IdVisita,
@IDCxC	     = IDCxC,
@Cliente     = Cliente,
@Saldo       = Saldo,
@Fecha       = Fecha,
@Seleccion   = Seleccion
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/cxcpendientes', 2 )
WITH (	Movimiento	Varchar (20) , 	MovId	Varchar (20) , 	IdVisita Int, IDCxC Int ,
Cliente     Varchar (10) , 	Saldo   Money, 	Fecha   Datetime ,
Seleccion   varchar(5))
DELETE WebCxCPendientesPaso WHERE Cliente = @Cliente
INSERT WebCxCPendientesPaso (Movimiento, MovId, IdVisita, IDCxC, Cliente , Saldo, Fecha, Seleccion)
SELECT Movimiento, 	MovId, 	IdVisita, IDCxC, Cliente , Saldo, 	Fecha, Seleccion
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud/cxcpendientes', 2 )
WITH (	Movimiento	Varchar (20) , 	MovId	Varchar (20) , 	IdVisita Int, IDCxC Int ,
Cliente     Varchar (10) , 	Saldo   Money, 	Fecha   Datetime ,
Seleccion   varchar(5))
IF @Ok IS NOT NULL
SET @OkRef = (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok)
END TRY
BEGIN CATCH
SELECT @OkRef = REPLACE(ERROR_MESSAGE(), '"', ''), @Ok = 1
END CATCH
SELECT @Resultado = '<CxCPendientesEnvio><Cliente>' + @Cliente + '</Cliente></CxCPendientesEnvio>'
END

