SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSCancelarCobroLDI
@ID                 varchar(36),
@RID                int,
@Estacion           int,
@Ok                 int           OUTPUT,
@OkRef              varchar(255)  OUTPUT

AS
BEGIN
SELECT @ok =1,@OkRef='No es Posible Cancelar el Cobro'
RETURN
END

