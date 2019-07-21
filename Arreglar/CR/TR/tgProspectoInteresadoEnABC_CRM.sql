SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgProspectoInteresadoEnABC_CRM ON ProspectoInteresadoEn

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@ProspectoInteresadoEnI  		varchar(10),
@ProspectoInteresadoEnD		varchar(10),
@CRMII			varchar(36),
@CRMID			varchar(36),
@Datos			varchar(max),
@Usuario		varchar(10),
@Contrasena		varchar(32),
@Ok				int,
@OkRef			varchar(255),
@IDIS			int,
@Accion			varchar(20),
@ArticuloI		varchar(25),
@ArticuloD		varchar(25),
@Precio			varchar(25)
IF dbo.fnEstaSincronizandoCRM() = 1
RETURN
SELECT
@Usuario    = Usuario,
@Contrasena = Contrasena
FROM CfgCRM
SELECT @ArticuloI = Articulo, @CRMII = CRMID FROM Inserted
SELECT @ArticuloD = Articulo, @CRMII = CRMID FROM Deleted
SELECT @Precio = PrecioLista FROM Art WHERE Articulo = ISNULL(@ArticuloI, @ArticuloD)
IF @CRMII IS NULL AND @CRMID IS NULL
RETURN
IF @CRMII IS NOT NULL AND @CRMID IS NULL
SELECT @Accion = 'INSERT'
ELSE
IF @CRMII IS NOT NULL AND @CRMID IS NOT NULL
SELECT @Accion = 'UPDATE'
ELSE
IF @CRMII IS NULL AND @CRMID IS NOT NULL
SELECT @Accion = 'DELETE'
ELSE
RETURN
SELECT @Datos = '<Intelisis Sistema="IntelisisCRM" Contenido="Solicitud" Referencia="IntelisisCRM.CRM" SubReferencia="" Version="1.0">' + '<Solicitud>' + '<' + @Accion + '>'
IF @ArticuloD IS NULL OR @ArticuloD = @ArticuloI
SELECT @Datos = @Datos + (SELECT Articulo, CRMID, InteresadoEn, @Precio AS 'PrecioLista' FROM Inserted ProspectoInteresadoEn FOR XML AUTO)
ELSE
SELECT @Datos = @Datos + (SELECT Articulo, CRMID, InteresadoEn, @Precio AS 'PrecioLista' FROM Deleted ProspectoInteresadoEn FOR XML AUTO)
SELECT @Datos = @Datos + '</' + @Accion + '></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Datos, NULL, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @IDIS OUTPUT
RETURN
END

