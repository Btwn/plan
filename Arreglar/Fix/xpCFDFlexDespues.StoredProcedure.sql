SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[xpCFDFlexDespues]
 @Estacion INT
,@Empresa VARCHAR(5)
,@Modulo VARCHAR(5)
,@ID INT
,@Estatus VARCHAR(15)
,@Ok INT OUTPUT
,@OkRef VARCHAR(255) OUTPUT
,@LlamadaExterna BIT
,@Mov VARCHAR(20)
,@MovID VARCHAR(20)
,@Contacto VARCHAR(10)
,@CrearArchivo BIT
,@Debug BIT
,@XMLFinal VARCHAR(MAX) OUTPUT
,@Encripcion VARCHAR(20)
AS
BEGIN
	EXEC spActualizaDatosXMLEnCFD @Estacion
								 ,@Empresa
								 ,@Modulo
								 ,@ID
								 ,@Estatus
								 ,@Ok OUTPUT
								 ,@OkRef OUTPUT
	EXEC xpActualizarContSATComprobante @Modulo
									   ,@ID
	EXEC spAsociacionRetroactiva @Modulo
								,@ID
								,@Empresa
	RETURN
END
GO