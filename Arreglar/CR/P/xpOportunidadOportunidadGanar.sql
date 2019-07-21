SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC xpOportunidadOportunidadGanar
@Empresa			varchar(5),
@Usuario			varchar(10),
@FechaEmision		datetime,
@FechaRegistro		datetime,
@Sucursal			int,
@ID					int,
@Accion				varchar(20),
@OrigenTipo			varchar(5),
@Origen				varchar(20),
@OrigenID			varchar(20),
@ContactoTipo		varchar(20),
@Contacto			varchar(10),
@Propuesta			varchar(50),
@Plantilla			varchar(20),
@IDPropuesta		int,
@Mensaje			int				OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT
AS
BEGIN
RETURN
END

