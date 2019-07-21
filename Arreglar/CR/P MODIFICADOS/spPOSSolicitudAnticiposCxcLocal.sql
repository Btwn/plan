SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spPOSSolicitudAnticiposCxcLocal
@ID      		varchar(50),
@Empresa        varchar(5),
@Estacion       int,
@Sucursal       int,
@Usuario        varchar(10),
@Ok             int				OUTPUT,
@OkRef          varchar(255)	OUTPUT

AS
BEGIN
DECLARE
@Cliente      varchar(10)
DECLARE @Tabla table(
RID                     int          NULL,
Cliente                 varchar(10)  NULL,
Mov                     varchar(20)  NULL,
MovID                   varchar(20)  NULL,
FechaEmision            datetime     NULL,
Referencia              varchar(50)  NULL,
Concepto                varchar(50)  NULL,
AnticipoSaldo           float        NULL,
Moneda                  varchar(10)  NULL,
TipoCambio              float        NULL,
Importe                 float        NULL,
Impuestos               float        NULL,
Retencion               float        NULL,
AnticipoAplicar         float        NULL,
POSGUID                 varchar(50)  NULL)
SELECT @Cliente = Cliente FROM POSL WITH (NOLOCK) WHERE ID = @ID
IF @Ok IS NULL
BEGIN
DELETE POSCxcAnticipoTemp  WHERE Estacion = @Estacion
INSERT @Tabla(
RID, Cliente, Mov, MovID, FechaEmision, Referencia, Concepto, AnticipoSaldo, Moneda, TipoCambio, Importe, Impuestos, Retencion, AnticipoAplicar, POSGUID)
SELECT
ID, Cliente, Mov, MovID, FechaEmision, Referencia, Concepto, AnticipoSaldo, Moneda, TipoCambio, Importe, Impuestos, Retencion, AnticipoAplicar, POSGUID
FROM Cxc WITH (NOLOCK)
WHERE Empresa = @Empresa
AND Estatus IN ('PENDIENTE', 'CONCLUIDO')
AND AnticipoSaldo>0
AND Cliente = @Cliente
IF @@ERROR<>0
SET @Ok = 1
IF @Ok IS NULL
BEGIN
INSERT POSCxcAnticipoTemp(
Estacion, RID, Cliente, Mov, MovID, FechaEmision, Referencia, Concepto, AnticipoSaldo, Moneda, TipoCambio, Importe, Impuestos,
Retencion, AnticipoAplicar, GUIDOrigen)
SELECT
@Estacion, RID, Cliente, Mov, MovID, FechaEmision, Referencia, Concepto, AnticipoSaldo, Moneda, TipoCambio, Importe, Impuestos,
Retencion, AnticipoAplicar, POSGUID
FROM @Tabla
IF @@ERROR<>0
SET @Ok = 1
END
END
END

