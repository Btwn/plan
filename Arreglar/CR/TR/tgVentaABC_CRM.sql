SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgVentaABC_CRM ON Venta

FOR INSERT, UPDATE, DELETE
AS BEGIN
DECLARE
@IDI  				int,
@IDD				int,
@CRMII				varchar(36),
@CRMID				varchar(36),
@Datos				varchar(max),
@Usuario			varchar(10),
@Contrasena			varchar(32),
@Ok					int,
@OkRef				varchar(255),
@IDIS				int,
@Accion				varchar(20),
@OpportunityIdI		varchar(36),
@OpportunityIdD		varchar(36),
@EstatusI			varchar(15),
@EstatusD			varchar(15)
IF dbo.fnEstaSincronizandoCRM() = 1
RETURN
SELECT
@Usuario    = Usuario,
@Contrasena = Contrasena
FROM CfgCRM
SELECT @IDI = ID, @CRMII = CRMID, @EstatusI = Estatus, @OpportunityIdI = OpportunityId FROM Inserted
SELECT @IDD = ID, @CRMID = CRMID, @EstatusD = Estatus, @OpportunityIdD = OpportunityId FROM Deleted
IF (@CRMII IS NULL AND @CRMID IS NULL) OR ((@OpportunityIdI IS NULL) OR (@OpportunityIdI <> '') AND @EstatusI = @EstatusD)
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
IF @IDD IS NULL OR @IDD = @IDI
SELECT @Datos = @Datos + (SELECT CRMID, OpportunityId, Estatus, Observaciones FROM Inserted VentaInv FOR XML AUTO)
ELSE
SELECT @Datos = @Datos + (SELECT CRMID, OpportunityId, Estatus, Observaciones FROM Deleted VentaInv FOR XML AUTO)
SELECT @Datos = @Datos + '</' + @Accion + '></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Datos, NULL, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @IDIS OUTPUT
SELECT @Datos = '<Intelisis Sistema="IntelisisCRM" Contenido="Solicitud" Referencia="IntelisisCRM.CRM" SubReferencia="" Version="1.0">' + '<Solicitud>' + '<' + @Accion + '>'
IF @IDD IS NULL OR @IDD = @IDI
SELECT @Datos = @Datos + (SELECT CRMID, OpportunityId, Estatus, Observaciones FROM Inserted VentaOrd FOR XML AUTO)
ELSE
SELECT @Datos = @Datos + (SELECT CRMID, OpportunityId, Estatus, Observaciones FROM Deleted VentaOrd FOR XML AUTO)
SELECT @Datos = @Datos + '</' + @Accion + '></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Datos, NULL, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @IDIS OUTPUT
SELECT @Datos = '<Intelisis Sistema="IntelisisCRM" Contenido="Solicitud" Referencia="IntelisisCRM.CRM" SubReferencia="" Version="1.0">' + '<Solicitud>' + '<' + @Accion + '>'
IF @IDD IS NULL OR @IDD = @IDI
SELECT @Datos = @Datos + (SELECT CRMID, OpportunityId, Estatus, Observaciones FROM Inserted VentaOpo FOR XML AUTO)
ELSE
SELECT @Datos = @Datos + (SELECT CRMID, OpportunityId, Estatus, Observaciones FROM Deleted VentaOpo FOR XML AUTO)
SELECT @Datos = @Datos + '</' + @Accion + '></Solicitud></Intelisis>'
EXEC spIntelisisService @Usuario, @Contrasena, @Datos, NULL, @Ok OUTPUT, @OkRef OUTPUT, 1, 0, @IDIS OUTPUT
RETURN
END

