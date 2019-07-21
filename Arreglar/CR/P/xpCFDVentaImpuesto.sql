SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpCFDVentaImpuesto
@Estacion		int,
@Modulo			char(5),
@ID				int,
@Layout			varchar(50),
@Validar		bit		= 0,
@Empresa		char(5),
@Sucursal		int,
@Cliente		varchar(10),
@Tipo			varchar(20),
@Impuesto		float OUTPUT,
@Importe		float OUTPUT
AS BEGIN
RETURN
END

