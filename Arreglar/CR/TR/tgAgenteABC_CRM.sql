SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgAgenteABC_CRM ON Agente

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@AgenteI  		varchar(10),
@AgenteD		varchar(10),
@CRMII			varchar(36),
@CRMID			varchar(36),
@Datos			varchar(max),
@Usuario		varchar(10),
@Contrasena		varchar(32),
@Ok				int,
@OkRef			varchar(255),
@IDIS			int,
@Accion			varchar(20)
IF dbo.fnEstaSincronizandoCRM() = 1
RETURN
SELECT
@Usuario    = Usuario,
@Contrasena = Contrasena
FROM CfgCRM
SELECT @AgenteI = Agente, @CRMII = CRMID FROM Inserted
SELECT @AgenteD = Agente, @CRMID = CRMID FROM Deleted
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
IF @CRMID IS NULL
BEGIN
SELECT @CRMID = NEWID()
UPDATE Agente
SET CRMID = ISNULL(CRMID,@CRMID)
WHERE Agente = ISNULL(@AgenteI, @AgenteD)
END
IF @AgenteD IS NULL OR @AgenteD = @AgenteI
SELECT @Datos = @Datos + (SELECT Acreedor, Agente, AlmacenDef, Alta, ArticuloDef, Baja, BeneficiarioNombre, Categoria, Clase, CodigoPostal, Colonia, Conciliar, CostoHora, @CRMID As CRMID, Cuota, CURP, Direccion, DireccionNumero, DireccionNumeroInt, DomainName, eMail, eMailAuto, Equipo, Estado, Estatus, Extencion, Familia, FueraLinea, Grupo, Jornada, Logico1, Logico2, MapaLatitud, MapaLongitud, MapaPrecision, Mensaje, Moneda, NivelAcceso, Nombre, Nomina, NominaConcepto, NominaMov, Pais, Personal, Poblacion, Porcentaje, ReportaA, RFC, SucursalEmpresa, Telefonos, TieneMovimientos, Tipo, TipoComision, UltimoCambio, VentasCasa, Zona FROM Inserted Agente FOR XML AUTO)
ELSE
SELECT @Datos = @Datos + (SELECT Acreedor, Agente, AlmacenDef, Alta, ArticuloDef, Baja, BeneficiarioNombre, Categoria, Clase, CodigoPostal, Colonia, Conciliar, CostoHora, CRMID, Cuota, CURP, Direccion, DireccionNumero, DireccionNumeroInt, DomainName, eMail, eMailAuto, Equipo, Estado, Estatus, Extencion, Familia, FueraLinea, Grupo, Jornada, Logico1, Logico2, MapaLatitud, MapaLongitud, MapaPrecision, Mensaje, Moneda, NivelAcceso, Nombre, Nomina, NominaConcepto, NominaMov, Pais, Personal, Poblacion, Porcentaje, ReportaA, RFC, SucursalEmpresa, Telefonos, TieneMovimientos, Tipo, TipoComision, UltimoCambio, VentasCasa, Zona FROM Deleted Agente FOR XML AUTO)
SELECT @Datos = @Datos + '</' + @Accion + '></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Datos, NULL, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @IDIS OUTPUT
RETURN
END

