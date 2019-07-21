SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpContAutoPolizaClave
@Empresa					char(5),
@Sucursal				int,
@Modulo					char(5),
@ID						int,
@Mov						varchar(20),
@MovID					varchar(20),
@MovTipo					char(20),
@Estatus					char(15),
@EstatusNuevo			char(15),
@Usuario					char(10),
@FechaEmision			datetime,
@FechaRegistro			datetime,
@Clave					varchar(20)     OUTPUT,
@Ok						int				OUTPUT,
@OkRef					varchar(255)	OUTPUT
AS BEGIN
RETURN
END

