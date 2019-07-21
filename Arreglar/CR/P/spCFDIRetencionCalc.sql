SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCFDIRetencionCalc
@Estacion		int,
@Empresa		varchar(5),
@FechaD			datetime,
@FechaA			datetime,
@Proveedor	varchar(10)

AS
BEGIN
SET NOCOUNT ON
SELECT @Proveedor = NULLIF(RTRIM(@Proveedor), '')
DECLARE @Ok						           int,
@OkRef					         varchar(255),
@GastoRetencionConcepto	 varchar(50),
@GastoRetencion2Concepto varchar(50)
CREATE TABLE #Pagos(
RID					      int			IDENTITY,
Modulo				    varchar(5)	COLLATE Database_Default	NULL,
ID					      int			  NULL,
Empresa				    varchar(5)	COLLATE Database_Default	NULL,
Mov					      varchar(20)	COLLATE Database_Default	NULL,
MovID				      varchar(20)	COLLATE Database_Default	NULL,
Ejercicio			    int			NULL,
Periodo				    int			NULL,
FechaEmision		  datetime	NULL,
AplicaModulo		  varchar(5)	COLLATE Database_Default	NULL,
AplicaModuloID		int			NULL,
Aplica				    varchar(20)	COLLATE Database_Default	NULL,
AplicaID			    varchar(20)	COLLATE Database_Default	NULL,
Importe				    float		NULL,
TipoCambio			  float		NULL,
Dinero				    varchar(20)	COLLATE Database_Default	NULL,
DineroID			    varchar(20)	COLLATE Database_Default	NULL,
FechaConciliacion	datetime	NULL,
EsAnticipo			  bit			NULL DEFAULT 0,
EsComprobante		  bit			NULL DEFAULT 0,
EsRetencion			  bit			NULL DEFAULT 0,
EsIEPS				    bit			NULL DEFAULT 0,
DineroMov			    varchar(20) COLLATE DATABASE_DEFAULT	NULL,
DineroMovID			  varchar(20) COLLATE DATABASE_DEFAULT	NULL
)
CREATE TABLE #Documentos(
RID					        int			IDENTITY,
ID					        int			NULL,
Modulo				      varchar(5)	COLLATE Database_Default	NULL,
ModuloID			      int			NULL,
Sucursal			      int			NULL,
Empresa				      varchar(5)	COLLATE Database_Default	NULL,
Pago				        varchar(20)	COLLATE Database_Default	NULL,
PagoID				      varchar(20)	COLLATE Database_Default	NULL,
Mov					        varchar(20)	COLLATE Database_Default	NULL,
MovID				        varchar(20)	COLLATE Database_Default	NULL,
Ejercicio			      int			NULL,
Periodo				      int			NULL,
FechaEmision		    datetime	NULL,
Proveedor			      varchar(10)	COLLATE Database_Default	NULL,
TipoTercero			    varchar(20) COLLATE Database_Default	NULL,
Importe				      float		NULL,
IVA					        float		NULL,
IEPS				        float		NULL,
ISAN				        float		NULL,
Retencion1			    float		NULL,
Retencion2			    float		NULL,
BaseIVA				      float		NULL,
Tasa				        float		NULL,
ConceptoSAT			    varchar(2)  COLLATE Database_Default	NULL,
ConceptoClave		    varchar(50) COLLATE Database_Default	NULL,
Concepto			      varchar(100)COLLATE Database_Default	NULL,
EsComplemento		    bit			NOT NULL DEFAULT 0,
EsRetencion			    bit			NOT NULL DEFAULT 0,
EsIEPS				      bit			NOT NULL DEFAULT 0,
PorcentajeDeducible	float		NOT NULL DEFAULT 100
)
CREATE TABLE #Movtos (Empresa     varchar(5)  NULL,
ModuloRaiz  varchar(5)  NULL,
IDRaiz      int         NULL,
MovRaiz     varchar(20) NULL,
MovIDRaiz   varchar(20) NULL,
OModulo     varchar(5)  NULL,
OID         int         NULL,
OMov        varchar(20) NULL,
OMovID      varchar(20) NULL
)
CREATE TABLE #Movtos2 (Empresa    varchar(5)  NULL,
ModuloRaiz varchar(5)  NULL,
IDRaiz     int         NULL,
MovRaiz    varchar(20) NULL,
MovIDRaiz  varchar(20) NULL,
OModulo    varchar(5)  NULL,
OID        int         NULL,
OMov       varchar(20) NULL,
OMovID     varchar(20) NULL
)
CREATE TABLE #Movtos3 (Empresa    varchar(5)  NULL,
ModuloRaiz varchar(5)  NULL,
IDRaiz     int         NULL,
MovRaiz    varchar(20) NULL,
MovIDRaiz  varchar(20) NULL,
OModulo    varchar(5)  NULL,
OID        int         NULL,
OMov       varchar(20) NULL ,
OMovID     varchar(20) NULL
)
CREATE INDEX Importe ON #Documentos(Mov, MovID, Pago, PagoID, Empresa) INCLUDE(Importe, IVA, IEPS, ISAN, Retencion1, Retencion2)
DELETE CFDIRetencionD WHERE EstacionTrabajo = @Estacion
SELECT @Ok = NULL, @OkRef = NULL
SELECT @GastoRetencionConcepto = GastoRetencionConcepto, @GastoRetencion2Concepto = GastoRetencion2Concepto FROM EmpresaCfg2 WHERE Empresa = @Empresa
IF YEAR(@FechaD)  = 1899 SELECT @FechaD = NULL
IF YEAR(@FechaA) = 1899  SELECT @FechaA = NULL
IF @Proveedor IS NOT NULL AND NOT EXISTS(SELECT Proveedor FROM Prov WHERE Proveedor = @Proveedor)
SELECT @Ok = 26050
IF @Proveedor IS NULL
SELECT @Ok = 40020
IF @Ok IS NULL AND @FechaD IS NULL
SELECT @Ok = 1, @OkRef = 'Favor de Especificar la Fecha Inicial'
IF @Ok IS NULL AND @FechaA IS NULL
SELECT @Ok = 1, @OkRef = 'Favor de Especificar la Fecha Final'
IF @Ok IS NULL AND YEAR(@FechaD) <> YEAR(@FechaA)
SELECT @Ok = 1, @OkRef = 'Solo se puede presentar la Información de un Ejercicio'
IF @Ok IS NULL AND @GastoRetencionConcepto NOT LIKE 'ISR%'
SELECT @Ok = 1, @OkRef = 'El Concepto de Retención ISR debe ser "ISR - (Concepto Gasto)"<BR>Configuración de Módulos de la Empresa'
IF @Ok IS NULL AND @GastoRetencion2Concepto NOT LIKE 'IVA%'
SELECT @Ok = 1, @OkRef = 'El Concepto de Retención IVA debe ser "IVA - (Concepto Gasto)"<BR>Configuración de Módulos de la Empresa'
IF @Ok IS NULL
BEGIN
EXEC spCFDIRetencionObtenerPago @Empresa, @FechaD, @FechaA, @Proveedor
EXEC spCFDIRetencionObtenerPagoIEPS @Empresa, @FechaD, @FechaA, @Proveedor
EXEC spCFDIRetencionObtenerDocumento @Estacion, @Empresa, @FechaD, @FechaA, @Proveedor
EXEC spCFDIRetencionObtenerDocumentoIEPS @Estacion, @Empresa, @FechaD, @FechaA, @Proveedor
EXEC spCFDIRetencionObtenerGasto @Estacion, @Empresa, @FechaD, @FechaA, @Proveedor
EXEC spCFDIRetencionProcesar @Estacion, @Empresa, @FechaD, @FechaA
END
IF @Ok IS NULL
SELECT 'Proceso Concluido'
ELSE
IF @Ok = 1
SELECT @OkRef
ELSE
SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok
END

