SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgeDocInRutaTablaDC ON eDocInRutaTablaD

AFTER UPDATE, INSERT
AS BEGIN
DECLARE
@RID                int,
@IDNodo             int,
@CampoXMLAnterior   varchar(8000),
@CampoXMLNuevo      varchar(8000),
@eDocIn             varchar(50),
@Ruta               varchar(50),
@Tablas             varchar(50),
@Nodo               varchar(8000)
IF dbo.fnEstaSincronizando() = 1 RETURN
DECLARE crTablaD CURSOR LOCAL FOR
SELECT i.RID, i.CampoXML, d.CampoXML, i.eDocIn, i.Ruta, i.Tablas
FROM Inserted i LEFT JOIN Deleted d ON i.RID = d.RID
WHERE i.CampoXML <> ISNULL(d.CampoXML,'') AND (NULLIF(i.CampoXML,'') IS NOT NULL OR NULLIF(d.CampoXML,'') IS  NULL)
OPEN crTablaD
FETCH NEXT FROM crTablaD INTO @RID, @CampoXMLNuevo, @CampoXMLAnterior, @eDocIn, @Ruta, @Tablas
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Nodo = ISNULL(NULLIF(Nodo,''),'/')
FROM eDocInRutaTabla WHERE eDocIn = @eDocIn AND Ruta = @Ruta AND Tablas= @Tablas
SELECT @IDNodo = ID FROM eDocInNodoAtributoTemp WHERE Estacion = @@SPID AND NodoNombre = @CampoXMLNuevo
UPDATE eDocInRutaTablaD SET ExpresionXML = n.NodoNombre, CampoXMLRuta = n.Ruta, CampoXMLAtributo = n.Atributo, CampoXMLTipoXML = n.CampoTipoxml
FROM eDocInNodoAtributoTemp n
WHERE n.Estacion = @@SPID
AND n.ID = @IDNodo
AND RID = @RID
FETCH NEXT FROM crTablaD INTO @RID, @CampoXMLNuevo, @CampoXMLAnterior, @eDocIn, @Ruta, @Tablas
END
CLOSE crTablaD
DEALLOCATE crTablaD
END

