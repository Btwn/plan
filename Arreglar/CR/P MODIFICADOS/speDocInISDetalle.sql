SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInISDetalle
@Estacion         int,
@ID               int

AS BEGIN
DECLARE
@XML          xml,
@iSolicitud   int
DELETE eDocInISDetalleTemp WHERE Estacion = @Estacion
SELECT @XML = CONVERT(xml,Resultado) FROM IntelisisService WITH(NOLOCK) WHERE ID = @ID
EXEC sp_xml_preparedocument @iSolicitud OUTPUT, @XML
INSERT eDocInISDetalleTemp (RID, eDocIn, Ruta, Modulo, ID, Mov, Estatus, Estacion, Origen)
SELECT 	                @ID, eDocIn, Ruta, Modulo, ID, Mov, Estatus, @Estacion, Origen
FROM OPENXML (@iSolicitud, '/Intelisis/Resultado/eDocInRutaTemp',1)
WITH (eDocIn varchar(50), Ruta varchar(50),Modulo varchar(5),ID int,Mov varchar(50),Estatus varchar(20), Origen varchar(255))
EXEC sp_xml_removedocument @iSolicitud
END

