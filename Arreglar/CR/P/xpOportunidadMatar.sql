SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC xpOportunidadMatar
@Empresa		varchar(5),
@Usuario		varchar(5),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@Sucursal		int,
@ID				int,
@Accion			varchar(20),
@OrigenTipo		varchar(5),
@Origen			varchar(20),
@OrigenID		varchar(20),
@ContactoTipo	varchar(10),
@Contacto		varchar(20),
@Ok				int				OUTPUT,
@OkRef			varchar(255)	OUTPUT
AS
BEGIN
RETURN
END

