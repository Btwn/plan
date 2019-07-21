SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpTipoImpuesto
@Modulo			varchar(5),
@ID			int,
@Mov			varchar(20),
@Fecha			datetime,
@Empresa		varchar(5),
@Sucursal		int,
@Contacto		varchar(10),
@EnviarA		int		= NULL,
@Articulo		varchar(20)	= NULL,
@Concepto		varchar(50)	= NULL,
@VerTipos		bit		= 0,
@EnSilencio		bit		= 0,
@Impuesto1		float		= NULL	OUTPUT,
@Impuesto2		float		= NULL	OUTPUT,
@Impuesto3		float		= NULL	OUTPUT,
@Retencion1		float		= NULL	OUTPUT,
@Retencion2		float		= NULL	OUTPUT,
@Retencion3		float		= NULL	OUTPUT,
@TipoImpuesto1		varchar(10)	= NULL	OUTPUT,
@TipoImpuesto2		varchar(10)	= NULL	OUTPUT,
@TipoImpuesto3		varchar(10)	= NULL	OUTPUT,
@TipoRetencion1		varchar(10)	= NULL	OUTPUT,
@TipoRetencion2		varchar(10)	= NULL	OUTPUT,
@TipoRetencion3		varchar(10)	= NULL	OUTPUT,
@TipoImpuesto4		varchar(10)	= NULL	OUTPUT,
@Impuesto5		float		= NULL	OUTPUT,
@TipoImpuesto5		varchar(10)	= NULL	OUTPUT
AS BEGIN
/*
DECLARE @CedulaIEPS varchar(20)
IF @Modulo = 'VTAS'
BEGIN
SELECT @CedulaIEPS = IEPS FROM Cte WHERE Cliente = @Contacto
IF NULLIF(@CedulaIEPS,'') IS NULL
SELECT @Impuesto2 = NULL, @TipoImpuesto2 = NULL
END
*/
RETURN
END

