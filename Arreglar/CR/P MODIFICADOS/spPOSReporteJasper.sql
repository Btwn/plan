SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSReporteJasper
@Empresa	    varchar(5),
@Modulo	        varchar(20),
@ModuloID	    varchar(20),
@ArchivoXML		varchar(255),
@NomArch        varchar(255)

AS
BEGIN
DECLARE
@MovCFD                     varchar(20),
@ReferenciaOrdenCompra      varchar(50),
@XmlJasper                  varchar(max)
SELECT @MovCFD = MovFactura
FROM POSCfg WITH (NOLOCK)
WHERE Empresa = @Empresa
IF @Modulo = 'VTAS'
BEGIN
IF EXISTS(SELECT * FROM Venta WITH (NOLOCK) WHERE OrigenTipo = 'POS' AND ID = @ModuloID AND Mov = @MovCFD)
BEGIN
SELECT @ReferenciaOrdenCompra = ReferenciaOrdenCompra
FROM Venta WITH (NOLOCK)
WHERE ID = @ModuloID
SELECT @XmlJasper = dbo.fnPOSLeerArchivo(@ArchivoXML)
IF EXISTS(SELECT * FROM POSL WITH (NOLOCK) WHERE ID = @ReferenciaOrdenCompra)
UPDATE POSL SET XmlJasper = @XmlJasper, NombreArchivo = @NomArch
WHERE ID = @ReferenciaOrdenCompra
END
END
RETURN
END

