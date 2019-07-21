SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speDocInReprocesarIS
@ID             int,
@Usuario        varchar(10)

AS BEGIN
DECLARE
@xml         varchar(max),
@xml2        xml,
@Resultado   varchar(max),
@Nombre      varchar(255),
@Estacion    int,
@Origen2     varchar(255),
@Destino2    varchar(255),
@Contrasena  varchar(32),
@Ok          int,
@OkRef       varchar(255)
SELECT @Contrasena = Contrasena
FROM Usuario
WHERE Usuario = @Usuario
SELECT @xml = Solicitud, @Nombre = eDocInArchivo FROM IntelisisService WHERE ID = @ID
SELECT @xml2 = CONVERT(xml,@xml)
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SET QUOTED_IDENTIFIER ON
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_PADDING ON
EXEC spIntelisisService @Usuario,@Contrasena,@xml,@Resultado,@Ok OUTPUT,@OkRef OUTPUT,1,0,@ID OUTPUT
IF @ID IS NOT NULL
UPDATE IntelisisService SET eDocInArchivo = @Nombre
WHERE ID = @ID
SET ANSI_NULLS OFF
SET ANSI_WARNINGS OFF
SET QUOTED_IDENTIFIER OFF
SET CONCAT_NULL_YIELDS_NULL OFF
SET ANSI_PADDING OFF
END

