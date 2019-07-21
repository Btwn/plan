SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpNameSpace
@Estacion		int,
@Modulo			char(5),
@ID				int,
@Layout			varchar(50),
@Version		varchar(10),
@TipoAddenda	varchar(50),
@NameSpace		varchar(8000) OUTPUT
AS BEGIN
DECLARE
@Mov varchar(20),
@MovTipo varchar(20),
@MovTipoSubClave varchar(20),
@Complemento     varchar(50)
EXEC spMovInfo @ID, @Modulo, @Mov OUTPUT
SELECT @MovTipo = Clave, @MovTipoSubClave = SubClave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov
IF @Modulo = 'VTAS'
SELECT @Complemento = c.TipoComplemento FROM Venta v JOIN CteCFD c ON v.Cliente = c.Cliente WHERE v.ID = @ID
IF @Modulo = 'VTAS' AND (@MovTipoSubClave = 'CFDI.TERCEROSPROV' OR @MovTipoSubClave = 'CFDI.TERCEROSCTE')
SELECT @NameSpace = ' xmlns:xsi='+char(34)+'http://www.w3.org/2001/XMLSchema-instance'+char(34)+' xmlns:cfdi='+char(34)+'http://www.sat.gob.mx/cfd/3'+char(34)+' xmlns:terceros='+char(34)+'http://www.sat.gob.mx/terceros'+char(34)+' xsi:schemaLocation='+char(34)+'http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd http://www.sat.gob.mx/terceros http://www.sat.gob.mx/sitio_internet/cfd/terceros/terceros11.xsd'+char(34)+' '
IF @Modulo = 'VTAS' AND (@MovTipoSubClave = 'CFDI.COMERCIOEXT' OR (ISNULL(@Complemento,'') = 'Comercio Exterior'))
SELECT @NameSpace = ' xmlns:cfdi="http://www.sat.gob.mx/cfd/3" xmlns:xsi='+char(34)+'http://www.w3.org/2001/XMLSchema-instance'+char(34)+' xmlns:cce='+char(34)+'http://www.sat.gob.mx/ComercioExterior'+char(34)+' xsi:schemaLocation='+char(34)+'http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd http://www.sat.gob.mx/ComercioExterior http://www.sat.gob.mx/sitio_internet/cfd/ComercioExterior/ComercioExterior10.xsd'+char(34)+' '
IF @Modulo = 'VTAS' AND (@MovTipoSubClave = 'CFDI.INE' OR (ISNULL(@Complemento,'') = 'INE'))
SELECT @NameSpace = ' xmlns:cfdi="http://www.sat.gob.mx/cfd/3" xmlns:xsi='+char(34)+'http://www.w3.org/2001/XMLSchema-instance'+char(34)+' xmlns:ine='+char(34)+'http://www.sat.gob.mx/ine'+char(34)+' xsi:schemaLocation='+char(34)+'http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd http://www.sat.gob.mx/ine http://www.sat.gob.mx/sitio_internet/cfd/ine/ine10.xsd'+char(34)+' '
RETURN
END

