SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpPOSVentaInsertaArticulo
@Codigo				varchar(30),
@ID					varchar(50),
@FechaEmision		datetime,
@Agente				varchar(10),
@Moneda				varchar(10),
@TipoCambio			float,
@Condicion			varchar(50),
@Almacen			varchar(10),
@Proyecto			varchar(50),
@FormaEnvio			varchar(50),
@Mov				varchar(20),
@Empresa			varchar(5),
@Sucursal			int,
@ListaPreciosEsp	varchar(20),
@Cliente			varchar(10),
@CtaDinero			varchar(10),
@Accion				varchar(50),
@ArtDescripcion		varchar(100)	OUTPUT,
@Imagen				varchar(255)	OUTPUT,
@Ok					int				OUTPUT,
@OkRef				varchar(255)	OUTPUT
AS
BEGIN
RETURN
END

