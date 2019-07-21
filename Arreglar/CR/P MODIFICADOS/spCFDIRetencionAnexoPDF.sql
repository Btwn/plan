SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionAnexoPDF
@Empresa		varchar(5),
@Usuario		varchar(10),
@ID				int,
@ArchivoPDF		varchar(255),
@Estacion		int

AS
BEGIN
DECLARE @Proveedor		varchar(10),
@ConceptoSAT		varchar(2),
@Version			varchar(5),
@AlmacenarXML		bit,
@AlmacenarPDF		bit,
@NomArch			varchar(255),
@Reporte			varchar(100),
@Ruta				varchar(255),
@EnviarPara		varchar(255),
@EnviarAsunto		varchar(255),
@EnviarMensaje	varchar(255),
@Enviar			bit,
@EnviarXML		bit,
@EnviarPDF		bit,
@UUID				varchar(50),
@Ok				int,
@OkRef			varchar(255),
@ModuloAnt		varchar(5),
@Modulo			varchar(5),
@ModuloIDAnt		int,
@ModuloID			int,
@Sucursal			int,
@Ejerc				int,
@MesIni			int,
@MesFin			int
DELETE FROM ListaID WHERE ID = @ID AND Estacion =@Estacion
SELECT @Proveedor = Proveedor, @ConceptoSAT = ConceptoSAT, @UUID = UUID, @Ejerc = Ejercicio, @MesIni = Periodo, @MesFin = Periodo FROM CFDRetencion WITH (NOLOCK) WHERE Modulo = 'CXP' AND ModuloID = @ID
SELECT @Sucursal = Sucursal FROM Cxp WITH (NOLOCK) WHERE ID = @ID
SELECT @Version = Version FROM CFDIRetencionCfg WITH (NOLOCK)
EXEC spCFDIRetencionAlmacenar @Empresa, @Usuario, @Proveedor, @ConceptoSAT, @Version,
@Ejerc, @MesIni, @MesFin, @AlmacenarXML OUTPUT, @AlmacenarPDF OUTPUT,
@NomArch OUTPUT, @Reporte OUTPUT, @Ruta OUTPUT, @EnviarPara OUTPUT, @EnviarAsunto OUTPUT, @EnviarMensaje OUTPUT,
@Enviar OUTPUT, @EnviarXML OUTPUT, @EnviarPDF OUTPUT, 0
EXEC spCrearRuta @Ruta, @Ok OUTPUT, @OkRef OUTPUT
SELECT @NomArch = REPLACE(REPLACE(@ArchivoPDF, @Ruta, ''), '\', '')
IF @Ok IS NULL
BEGIN
SELECT @ModuloAnt = ''
WHILE(1=1)
BEGIN
SELECT @Modulo = MIN(Modulo)
FROM CFDRetencion WITH (NOLOCK)
WHERE UUID = @UUID
AND Modulo > @ModuloAnt
IF @Modulo IS NULL BREAK
SELECT @ModuloAnt = @Modulo
SELECT @ModuloIDAnt = 0
WHILE(1=1)
BEGIN
SELECT @ModuloID = MIN(ModuloID)
FROM CFDRetencion WITH (NOLOCK)
WHERE UUID = @UUID
AND Modulo = @Modulo
AND ModuloID > @ModuloIDAnt
IF @ModuloID IS NULL BREAK
SELECT @ModuloIDAnt = @ModuloID
IF NOT EXISTS(SELECT * FROM AnexoMov WITH (NOLOCK) WHERE Rama = @Modulo AND ID = @ModuloID AND CFD = 1 AND Nombre = @NomArch)
INSERT AnexoMov (Sucursal,  Rama,    ID,        Nombre,   Direccion,  Tipo,      Icono, CFD)
VALUES (@Sucursal, @Modulo, @ModuloID, @NomArch, @ArchivoPDF, 'Archivo', 745,    1)
END
END
END
SELECT 'Proceso Concluido'
RETURN
END

