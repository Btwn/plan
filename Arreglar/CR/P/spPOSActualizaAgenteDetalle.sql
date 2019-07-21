SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSActualizaAgenteDetalle
@ID				varchar(50),
@Agente			varchar(10),
@Renglon		float,
@Sucursal		int,
@Ok				int = NULL				OUTPUT,
@OkRef			varchar(255) = NULL		OUTPUT

AS
BEGIN
IF EXISTS(SELECT * FROM Agente WHERE Estatus = 'ALTA' AND  Agente = @Agente AND SucursalEmpresa = @Sucursal )
BEGIN
UPDATE POSLVenta SET Agente = @Agente WHERE ID = @ID AND Renglon = @Renglon
END
ELSE
SELECT @Ok = 304190, @OkRef = 'Sucursal del Agente Incorrecta o Agente en Estatus Baja, Verifique....'
SELECT @OkRef
END

