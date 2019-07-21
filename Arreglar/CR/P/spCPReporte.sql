SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCPReporte
@ID		    int,
@Proy		varchar(50) = NULL,
@Emp		char(5) = NULL,
@ClaveDes	varchar(50) = NULL,
@ClaveHas	varchar(50) = NULL,
@FechaDes	datetime = NULL,
@FechaHas	datetime = NULL,
@Est	varchar(15) = NULL

AS BEGIN
DECLARE
@Movimiento							varchar(100),
@Estatus							varchar(15),
@Proyecto							varchar(50),
@Moneda								varchar(50),
@FechaEmision						varchar(10),
@Empresa							varchar(5),
@Usuario							varchar(10),
@MovTipo							varchar(20),
@EmpresaNombre						varchar(100),
@Origen								varchar(100),
@Concepto							varchar(100),
@Referencia							varchar(100),
@Observaciones						varchar(100),
@Agente								varchar(100),
@UEN								varchar(100),
@Columna1							varchar(100),
@Columna2							varchar(100),
@Columna3							varchar(100),
@Columna4							varchar(100),
@Columna5							varchar(100),
@Columna6							varchar(100),
@Columna7							varchar(100),
@Columna8							varchar(100),
@Columna9							varchar(100),
@Columna10							varchar(100),
@Columna11							varchar(100),
@Columna12							varchar(100),
@Contador							int,
@IDTabla							int,
@ClaveD								varchar(50),
@ClaveA								varchar(50)
DECLARE @Tabla TABLE
(
ID				int IDENTITY,
Tipo				varchar(20),
Columna1			varchar(100),
Columna2			varchar(100),
Columna3			varchar(100),
Columna4			varchar(100),
Columna5			varchar(100),
Columna6			varchar(100),
Columna7			varchar(100),
Columna8			varchar(100),
Columna9			varchar(100),
Columna10			varchar(100),
Columna11			varchar(100),
Columna12			varchar(100),
Movimiento		varchar(100),
Estatus			varchar(15),
Proyecto			varchar(50),
Moneda			varchar(50),
FechaEmision		varchar(20),
Usuario			varchar(10),
MovTipo			varchar(20),
EmpresaNombre		varchar(100),
Origen			varchar(100),
Concepto			varchar(100),
Referencia		varchar(100),
Observaciones		varchar(100),
Agente			varchar(100),
UEN				varchar(100),
Empresa			varchar(100)
)
SELECT
@Contador = 1,
@Movimiento = ISNULL(c.Mov,'') + ' ' + ISNULL(c.MovID,''),
@Estatus = CASE
WHEN c.Estatus = 'SINAFECTAR' THEN 'SIN AFECTAR'
WHEN c.Estatus = 'PROCESAR'   THEN 'POR PROCESAR'
WHEN c.Estatus IN ('BORRADOR','PENDIENTE','VIGENTE','CONCLUIDO','CANCELADO')   THEN c.Estatus
END,
@Proyecto = c.Proyecto,
@Moneda = c.Moneda + CASE WHEN c.TipoCambio <> 1 AND c.TipoCambio IS NOT NULL THEN ': ' + CONVERT(varchar,ROUND(TipoCambio,2)) END,
@FechaEmision = CONVERT(varchar,c.FechaEmision,101),
@Usuario = c.Usuario,
@MovTipo = CASE WHEN @ID IS NULL THEN 'CP.OP' ELSE mt.Clave END,
@EmpresaNombre = e.Nombre,
@Origen = dbo.fnModuloNombre(c.origenTipo) + ' - ' + ISNULL(c.Origen,'') + ' ' + ISNULL(c.OrigenID,''),
@Concepto = ISNULL(c.Concepto, ''),
@Referencia = ISNULL(c.Referencia, ''),
@Observaciones = ISNULL(c.Observaciones, ''),
@Agente = ISNULL(a.Nombre, ''),
@UEN = ISNULL(u.Nombre, '')
FROM CP c JOIN MovTipo mt
ON c.Mov = mt.Mov AND mt.Modulo = 'CP' JOIN Empresa e
ON e.Empresa = c.Empresa LEFT OUTER JOIN Agente a
ON c.Agente = a.Agente LEFT OUTER JOIN UEN u
ON c.UEN = u.UEN
WHERE c.ID = ISNULL(@ID, c.ID)
IF @ClaveD = NULL
SELECT @ClaveD = (SELECT MIN(ClavePresupuestal) FROM ClavePresupuestal)
IF @ClaveA = NULL
SELECT @ClaveA = (SELECT MAX(ClavePresupuestal) FROM ClavePresupuestal)
INSERT @Tabla (Tipo, Columna1,               Columna2)
VALUES ('A1', 'Control Presupuestal', @EmpresaNombre)
INSERT @Tabla (Tipo, Columna1,    Columna2, Columna3,  Columna4, Columna5)
VALUES ('A2', @Movimiento, @Estatus, @Proyecto, @Moneda,  @FechaEmision)
IF NULLIF(@Origen,'') IS NOT NULL
INSERT @Tabla (Tipo, Columna1,  Columna2)
VALUES ('A3', 'Origen:',  @Origen)
IF NULLIF(@Concepto,'') IS NOT NULL
INSERT @Tabla (Tipo, Columna1,   Columna2)
VALUES ('A3', 'Concepto:', @Concepto)
IF NULLIF(@Referencia,'') IS NOT NULL
INSERT @Tabla (Tipo, Columna1,     Columna2)
VALUES ('A3', 'Referencia:', @Referencia)
IF NULLIF(@Observaciones,'') IS NOT NULL
INSERT @Tabla (Tipo, Columna1,     Columna2)
VALUES ('A3', 'Observaciones:', @Observaciones)
IF NULLIF(@Agente,'') IS NOT NULL
INSERT @Tabla (Tipo, Columna1, Columna2)
VALUES ('A3', 'Agente:', @Agente)
IF NULLIF(@UEN,'') IS NOT NULL
INSERT @Tabla (Tipo, Columna1,  Columna2)
VALUES ('A3', 'UEN:',		@UEN)
IF @MovTipo IN ('CP.OP')
BEGIN
INSERT @Tabla (Tipo, Columna1, Columna2, Columna3, Columna4, Columna5, Columna6, Columna7, Columna8, Columna9, Columna10, Columna11, Columna12, Movimiento, Estatus, Proyecto, Moneda, FechaEmision, Usuario, MovTipo, EmpresaNombre, Origen, Concepto, Referencia, Observaciones, Agente, UEN, Empresa)
SELECT
'A4', 'Clave Presupuestal',
CASE 
WHEN (SELECT COUNT(ISNULL(Presupuesto, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Presupuesto, 0) <> 0) <> 0 THEN 'Presupuesto'
WHEN (SELECT COUNT(ISNULL(Comprometido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Comprometido, 0) <> 0) <> 0 THEN 'Comprometido'
WHEN (SELECT COUNT(ISNULL(Comprometido2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Comprometido2, 0) <> 0) <> 0 THEN 'Comprometido 2'
WHEN (SELECT COUNT(ISNULL(Devengado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado, 0) <> 0) <> 0 THEN 'Devengado'
WHEN (SELECT COUNT(ISNULL(Devengado2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado2, 0) <> 0) <> 0 THEN 'Devengado 2'
WHEN (SELECT COUNT(ISNULL(Ejercido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Ejercido, 0) <> 0) <> 0 THEN 'Ejercido'
WHEN (SELECT COUNT(ISNULL(EjercidoPagado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(EjercidoPagado, 0) <> 0) <> 0 THEN 'Pagado'
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN 'Anticipos'
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN 'RemanenteDisp.'
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN 'Sobrante'
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN 'Disponible'
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Comprometido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Comprometido, 0) <> 0) <> 0 THEN 'Comprometido'
WHEN (SELECT COUNT(ISNULL(Comprometido2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Comprometido2, 0) <> 0) <> 0 THEN 'Comprometido 2'
WHEN (SELECT COUNT(ISNULL(Devengado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado, 0) <> 0) <> 0 THEN 'Devengado'
WHEN (SELECT COUNT(ISNULL(Devengado2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado2, 0) <> 0) <> 0 THEN 'Devengado 2'
WHEN (SELECT COUNT(ISNULL(Ejercido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Ejercido, 0) <> 0) <> 0 THEN 'Ejercido'
WHEN (SELECT COUNT(ISNULL(EjercidoPagado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(EjercidoPagado, 0) <> 0) <> 0 THEN 'Pagado'
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN 'Anticipos'
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN 'RemanenteDisp.'
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN 'Sobrante'
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN 'Disponible'
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Comprometido2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Comprometido2, 0) <> 0) <> 0 THEN 'Comprometido 2'
WHEN (SELECT COUNT(ISNULL(Devengado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado, 0) <> 0) <> 0 THEN 'Devengado'
WHEN (SELECT COUNT(ISNULL(Devengado2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado2, 0) <> 0) <> 0 THEN 'Devengado 2'
WHEN (SELECT COUNT(ISNULL(Ejercido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Ejercido, 0) <> 0) <> 0 THEN 'Ejercido'
WHEN (SELECT COUNT(ISNULL(EjercidoPagado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(EjercidoPagado, 0) <> 0) <> 0 THEN 'Pagado'
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN 'Anticipos'
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN 'RemanenteDisp.'
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN 'Sobrante'
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN 'Disponible'
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Devengado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado, 0) <> 0) <> 0 THEN 'Devengado'
WHEN (SELECT COUNT(ISNULL(Devengado2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado2, 0) <> 0) <> 0 THEN 'Devengado 2'
WHEN (SELECT COUNT(ISNULL(Ejercido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Ejercido, 0) <> 0) <> 0 THEN 'Ejercido'
WHEN (SELECT COUNT(ISNULL(EjercidoPagado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(EjercidoPagado, 0) <> 0) <> 0 THEN 'Pagado'
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN 'Anticipos'
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN 'RemanenteDisp.'
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN 'Sobrante'
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN 'Disponible'
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Devengado2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado2, 0) <> 0) <> 0 THEN 'Devengado 2'
WHEN (SELECT COUNT(ISNULL(Ejercido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Ejercido, 0) <> 0) <> 0 THEN 'Ejercido'
WHEN (SELECT COUNT(ISNULL(EjercidoPagado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(EjercidoPagado, 0) <> 0) <> 0 THEN 'Pagado'
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN 'Anticipos'
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN 'RemanenteDisp.'
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN 'Sobrante'
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN 'Disponible'
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Ejercido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Ejercido, 0) <> 0) <> 0 THEN 'Ejercido'
WHEN (SELECT COUNT(ISNULL(EjercidoPagado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(EjercidoPagado, 0) <> 0) <> 0 THEN 'Pagado'
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN 'Anticipos'
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN 'RemanenteDisp.'
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN 'Sobrante'
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN 'Disponible'
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(EjercidoPagado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(EjercidoPagado, 0) <> 0) <> 0 THEN 'Pagado'
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN 'Anticipos'
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN 'RemanenteDisp.'
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN 'Sobrante'
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN 'Disponible'
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN 'Anticipos'
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN 'RemanenteDisp.'
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN 'Sobrante'
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN 'Disponible'
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN 'RemanenteDisp.'
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN 'Sobrante'
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN 'Disponible'
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN 'Sobrante'
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN 'Disponible'
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN 'Disponible'
ELSE
NULL
END,
'Movimiento', 'Estatus', 'Proyecto', 'Moneda', 'Fecha de Emision', 'Usuario', 'MovTipo', 'EmpresaNombre', 'Origen', 'Concepto', 'Referencia', 'Observaciones', 'Agente', 'UEN', 'Empresa'
INSERT @Tabla (Tipo, Columna1, Columna2, Columna3, Columna4, Columna5, Columna6, Columna7, Columna8, Columna9, Columna10, Columna11, Columna12, Movimiento, Estatus, Proyecto, Moneda, FechaEmision, Usuario, MovTipo, EmpresaNombre, Origen, Concepto, Referencia, Observaciones, Agente, UEN, Empresa)
SELECT
'B1', d.ClavePresupuestal,
CASE 
WHEN (SELECT COUNT(ISNULL(Presupuesto, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Presupuesto, 0) <> 0) <> 0 THEN CASE WHEN ISNULL(d.Tipo, 'Ampliacion') = 'Ampliacion' THEN d.Presupuesto ELSE -d.Presupuesto END
WHEN (SELECT COUNT(ISNULL(Comprometido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Comprometido, 0) <> 0) <> 0 THEN d.Comprometido
WHEN (SELECT COUNT(ISNULL(Comprometido2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Comprometido2, 0) <> 0) <> 0 THEN d.Comprometido2
WHEN (SELECT COUNT(ISNULL(Devengado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado, 0) <> 0) <> 0 THEN d.Devengado
WHEN (SELECT COUNT(ISNULL(Devengado2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado2, 0) <> 0) <> 0 THEN d.Devengado2
WHEN (SELECT COUNT(ISNULL(Ejercido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Ejercido, 0) <> 0) <> 0 THEN d.Ejercido
WHEN (SELECT COUNT(ISNULL(EjercidoPagado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(EjercidoPagado, 0) <> 0) <> 0 THEN d.EjercidoPagado
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN d.Anticipos
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN d.RemanenteDisponible
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN d.Sobrante
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN d.Disponible
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Comprometido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Comprometido, 0) <> 0) <> 0 THEN d.Comprometido
WHEN (SELECT COUNT(ISNULL(Comprometido2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Comprometido2, 0) <> 0) <> 0 THEN d.Comprometido2
WHEN (SELECT COUNT(ISNULL(Devengado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado, 0) <> 0) <> 0 THEN d.Devengado
WHEN (SELECT COUNT(ISNULL(Devengado2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado2, 0) <> 0) <> 0 THEN d.Devengado2
WHEN (SELECT COUNT(ISNULL(Ejercido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Ejercido, 0) <> 0) <> 0 THEN d.Ejercido
WHEN (SELECT COUNT(ISNULL(EjercidoPagado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(EjercidoPagado, 0) <> 0) <> 0 THEN d.EjercidoPagado
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN d.Anticipos
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN d.RemanenteDisponible
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN d.Sobrante
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN d.Disponible
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Comprometido2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Comprometido2, 0) <> 0) <> 0 THEN d.Comprometido2
WHEN (SELECT COUNT(ISNULL(Devengado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado, 0) <> 0) <> 0 THEN d.Devengado
WHEN (SELECT COUNT(ISNULL(Devengado2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado2, 0) <> 0) <> 0 THEN d.Devengado2
WHEN (SELECT COUNT(ISNULL(Ejercido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Ejercido, 0) <> 0) <> 0 THEN d.Ejercido
WHEN (SELECT COUNT(ISNULL(EjercidoPagado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(EjercidoPagado, 0) <> 0) <> 0 THEN d.EjercidoPagado
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN d.Anticipos
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN d.RemanenteDisponible
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN d.Sobrante
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN d.Disponible
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Devengado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado, 0) <> 0) <> 0 THEN d.Devengado
WHEN (SELECT COUNT(ISNULL(Devengado2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado2, 0) <> 0) <> 0 THEN d.Devengado2
WHEN (SELECT COUNT(ISNULL(Ejercido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Ejercido, 0) <> 0) <> 0 THEN d.Ejercido
WHEN (SELECT COUNT(ISNULL(EjercidoPagado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(EjercidoPagado, 0) <> 0) <> 0 THEN d.EjercidoPagado
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN d.Anticipos
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN d.RemanenteDisponible
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN d.Sobrante
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN d.Disponible
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Devengado2, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Devengado2, 0) <> 0) <> 0 THEN d.Devengado2
WHEN (SELECT COUNT(ISNULL(Ejercido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Ejercido, 0) <> 0) <> 0 THEN d.Ejercido
WHEN (SELECT COUNT(ISNULL(EjercidoPagado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(EjercidoPagado, 0) <> 0) <> 0 THEN d.EjercidoPagado
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN d.Anticipos
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN d.RemanenteDisponible
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN d.Sobrante
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN d.Disponible
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Ejercido, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Ejercido, 0) <> 0) <> 0 THEN d.Ejercido
WHEN (SELECT COUNT(ISNULL(EjercidoPagado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(EjercidoPagado, 0) <> 0) <> 0 THEN d.EjercidoPagado
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN d.Anticipos
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN d.RemanenteDisponible
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN d.Sobrante
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN d.Disponible
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(EjercidoPagado, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(EjercidoPagado, 0) <> 0) <> 0 THEN d.EjercidoPagado
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN d.Anticipos
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN d.RemanenteDisponible
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN d.Sobrante
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN d.Disponible
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Anticipos, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Anticipos, 0) <> 0) <> 0 THEN d.Anticipos
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN d.RemanenteDisponible
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN d.Sobrante
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN d.Disponible
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(RemanenteDisponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(RemanenteDisponible, 0) <> 0) <> 0 THEN d.RemanenteDisponible
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN d.Sobrante
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN d.Disponible
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN d.Sobrante
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN d.Disponible
ELSE
NULL
END,
CASE 
WHEN (SELECT COUNT(ISNULL(Sobrante, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Sobrante, 0) <> 0) <> 0 THEN d.Sobrante
WHEN (SELECT COUNT(ISNULL(Disponible, 0)) FROM CPD WHERE ID = ISNULL(@ID, ID) AND ISNULL(Disponible, 0) <> 0) <> 0 THEN d.Disponible
ELSE
NULL
END,
ISNULL(c.Mov,'') + ' ' + ISNULL(c.MovID,''), CASE WHEN c.Estatus = 'SINAFECTAR' THEN 'SIN AFECTAR' WHEN c.Estatus = 'PROCESAR'   THEN 'POR PROCESAR' WHEN c.Estatus IN ('BORRADOR','PENDIENTE','VIGENTE','CONCLUIDO','CANCELADO') THEN c.Estatus END, c.Proyecto, c.Moneda + CASE WHEN c.TipoCambio <> 1 AND c.TipoCambio IS NOT NULL THEN ': ' + CONVERT(varchar,ROUND(TipoCambio,2)) END, CONVERT(varchar,c.FechaEmision,101), c.Usuario, mt.Clave, e.Nombre, dbo.fnModuloNombre(c.origenTipo) + ' - ' + ISNULL(c.Origen,'') + ' ' + ISNULL(c.OrigenID,''), ISNULL(c.Concepto, ''), ISNULL(c.Referencia, ''), ISNULL(c.Observaciones, ''), ISNULL(a.Nombre, ''), ISNULL(u.Nombre, ''), c.Empresa
FROM CPD d JOIN CP c
ON c.ID = d.ID JOIN MovTipo mt
ON c.Mov = mt.Mov AND mt.Modulo = 'CP' JOIN Empresa e
ON e.Empresa = c.Empresa LEFT OUTER JOIN Agente a
ON c.Agente = a.Agente LEFT OUTER JOIN UEN u
ON c.UEN = u.UEN
WHERE c.ID = ISNULL(@ID, c.ID)
AND mt.Clave IN('CP.OP', 'CP.AS')
AND ISNULL(c.Proyecto,'') = ISNULL(@Proy, ISNULL(c.Proyecto,''))
AND ISNULL(c.Empresa,'') = ISNULL(@Emp, ISNULL(c.Empresa,''))
AND d.ClavePresupuestal BETWEEN ISNULL(@ClaveDes, d.ClavePresupuestal) AND ISNULL(@ClaveHas, d.ClavePresupuestal)
AND c.FechaEmision BETWEEN ISNULL(@FechaDes, c.FechaEmision) AND ISNULL(@FechaHas, c.FechaEmision)
AND c.Estatus = ISNULL(@Est, c.Estatus)
ORDER BY d.Renglon
UPDATE @Tabla SET Tipo = 'B2' WHERE Tipo = 'B1'
INSERT @Tabla(Columna1, Tipo, Columna2,                     Columna3,                     Columna4,                     Columna5,                     Columna6,                     Columna7,                     Columna8,                     Columna9,                     Columna10,                     Columna11,                     Columna12,                     Proyecto)
SELECT        Columna1, 'B1', SUM(CONVERT(float,Columna2)), SUM(CONVERT(float,Columna3)), SUM(CONVERT(float,Columna4)), SUM(CONVERT(float,Columna5)), SUM(CONVERT(float,Columna6)), SUM(CONVERT(float,Columna7)), SUM(CONVERT(float,Columna8)), SUM(CONVERT(float,Columna9)), SUM(CONVERT(float,Columna10)), SUM(CONVERT(float,Columna11)), SUM(CONVERT(float,Columna12)), Proyecto
FROM @Tabla
WHERE Tipo = 'B2'
GROUP BY Proyecto, Columna1
DELETE @Tabla WHERE Tipo = 'B2'
WHILE @Contador < 11
BEGIN
DECLARE crTabla CURSOR FOR
SELECT Columna1, Columna2, Columna3, Columna4, Columna5, Columna6, Columna7, Columna8, Columna9, Columna10, Columna11, Columna12
FROM @Tabla
WHERE Tipo = 'A4'
OPEN crTabla
FETCH NEXT FROM crTabla INTO @Columna1, @Columna2, @Columna3, @Columna4, @Columna5, @Columna6, @Columna7, @Columna8, @Columna9, @Columna10, @Columna11, @Columna12
WHILE @@FETCH_STATUS = 0
BEGIN
IF @Columna1 = @Columna2
UPDATE @Tabla SET Columna1 = Columna2, Columna2 = Columna3, Columna3 = Columna4, Columna4 = Columna5, Columna5 = Columna6, Columna6 = Columna7, Columna7 = Columna8, Columna8 = Columna9, Columna9 = Columna10, Columna10 = Columna11, Columna11 = Columna12, Columna12 = NULL WHERE TIPO IN ('A4', 'B1')
ELSE
IF @Columna2 = @Columna3
UPDATE @Tabla SET Columna2 = Columna3, Columna3 = Columna4, Columna4 = Columna5, Columna5 = Columna6, Columna6 = Columna7, Columna7 = Columna8, Columna8 = Columna9, Columna9 = Columna10, Columna10 = Columna11, Columna11 = Columna12, Columna12 = NULL WHERE TIPO IN ('A4', 'B1')
ELSE
IF @Columna3 = @Columna4
UPDATE @Tabla SET Columna3 = Columna4, Columna4 = Columna5, Columna5 = Columna6, Columna6 = Columna7, Columna7 = Columna8, Columna8 = Columna9, Columna9 = Columna10, Columna10 = Columna11, Columna11 = Columna12, Columna12 = NULL WHERE TIPO IN ('A4', 'B1')
ELSE
IF @Columna4 = @Columna5
UPDATE @Tabla SET Columna4 = Columna5, Columna5 = Columna6, Columna6 = Columna7, Columna7 = Columna8, Columna8 = Columna9, Columna9 = Columna10, Columna10 = Columna11, Columna11 = Columna12, Columna12 = NULL WHERE TIPO IN ('A4', 'B1')
ELSE
IF @Columna5 = @Columna6
UPDATE @Tabla SET Columna5 = Columna6, Columna6 = Columna7, Columna7 = Columna8, Columna8 = Columna9, Columna9 = Columna10, Columna10 = Columna11, Columna11 = Columna12, Columna12 = NULL WHERE TIPO IN ('A4', 'B1')
ELSE
IF @Columna6 = @Columna7
UPDATE @Tabla SET Columna6 = Columna7, Columna7 = Columna8, Columna8 = Columna9, Columna9 = Columna10, Columna10 = Columna11, Columna11 = Columna12, Columna12 = NULL WHERE TIPO IN ('A4', 'B1')
ELSE
IF @Columna7 = @Columna8
UPDATE @Tabla SET Columna7 = Columna8, Columna8 = Columna9, Columna9 = Columna10, Columna10 = Columna11, Columna11 = Columna12, Columna12 = NULL WHERE TIPO IN ('A4', 'B1')
ELSE
IF @Columna8 = @Columna9
UPDATE @Tabla SET Columna8 = Columna9, Columna9 = Columna10, Columna10 = Columna11, Columna11 = Columna12, Columna12 = NULL WHERE TIPO IN ('A4', 'B1')
ELSE
IF @Columna9 = @Columna10
UPDATE @Tabla SET Columna9 = Columna10, Columna10 = Columna11, Columna11 = Columna12, Columna12 = NULL WHERE TIPO IN ('A4', 'B1')
ELSE
IF @Columna10 = @Columna11
UPDATE @Tabla SET Columna10 = Columna11, Columna11 = Columna12, Columna12 = NULL WHERE TIPO IN ('A4', 'B1')
ELSE
IF @Columna11 = @Columna12
UPDATE @Tabla SET Columna11 = Columna12, Columna12 = NULL WHERE TIPO IN ('A4', 'B1')
SELECT @Contador = @Contador + 1
FETCH NEXT FROM crTabla INTO @Columna1, @Columna2, @Columna3, @Columna4, @Columna5, @Columna6, @Columna7, @Columna8, @Columna9, @Columna10, @Columna11, @Columna12
END
CLOSE crTabla
DEALLOCATE crTabla
END
INSERT @Tabla (Tipo, Columna1, Columna2,																										Columna3,																										 Columna4,																										  Columna5,																										   Columna6,																										Columna7,																										 Columna8,																										  Columna9,																										   Columna10,																										  Columna11,                                                                                                         Columna12)
SELECT         'C1', 'Total',  CASE WHEN ISNULL(SUM(CONVERT(money,Columna2)),0) <> 0 THEN ISNULL(SUM(CONVERT(money,Columna2)),0) ELSE NULL END, CASE WHEN ISNULL(SUM(CONVERT(money,Columna3)),0) <> 0 THEN ISNULL(SUM(CONVERT(money,Columna3)),0) ELSE NULL END, CASE WHEN ISNULL(SUM(CONVERT(money,Columna4)),0) <> 0 THEN ISNULL(SUM(CONVERT(money,Columna4)),0) ELSE NULL END, CASE WHEN ISNULL(SUM(CONVERT(money,Columna5)),0) <> 0 THEN ISNULL(SUM(CONVERT(money,Columna5)),0) ELSE NULL END, CASE WHEN ISNULL(SUM(CONVERT(money,Columna6)),0) <> 0 THEN ISNULL(SUM(CONVERT(money,Columna6)),0) ELSE NULL END, CASE WHEN ISNULL(SUM(CONVERT(money,Columna7)),0) <> 0 THEN ISNULL(SUM(CONVERT(money,Columna7)),0) ELSE NULL END, CASE WHEN ISNULL(SUM(CONVERT(money,Columna8)),0) <> 0 THEN ISNULL(SUM(CONVERT(money,Columna8)),0) ELSE NULL END, CASE WHEN ISNULL(SUM(CONVERT(money,Columna9)),0) <> 0 THEN ISNULL(SUM(CONVERT(money,Columna9)),0) ELSE NULL END, CASE WHEN ISNULL(SUM(CONVERT(money,Columna10)),0) <> 0 THEN ISNULL(SUM(CONVERT(money,Columna10)),0) ELSE NULL END, CASE WHEN ISNULL(SUM(CONVERT(money,Columna11)),0) <> 0 THEN ISNULL(SUM(CONVERT(money,Columna11)),0) ELSE NULL END, CASE WHEN ISNULL(SUM(CONVERT(money,Columna12)),0) <> 0 THEN ISNULL(SUM(CONVERT(money,Columna12)),0) ELSE NULL END
FROM @Tabla
WHERE Tipo = 'B1'
END
ELSE
BEGIN
INSERT @Tabla (Tipo, Columna1,             Columna3,     Columna4,    Columna5)
SELECT         'A4', 'Clave Presupuestal', 'Ampliación', 'Reducción', 'Saldo'
INSERT @Tabla (Tipo, Columna1,            Columna3,                                                     Columna4,                                                    Columna5)
SELECT         'B1', d.ClavePresupuestal, CASE WHEN d.Tipo = 'Ampliación' THEN d.Importe ELSE 0.00 END, CASE WHEN d.Tipo = 'Reducción' THEN d.Importe ELSE 0.00 END, CASE WHEN d.Tipo = 'Ampliación' THEN d.Importe ELSE 0.00 END - CASE WHEN d.Tipo = 'Reducción' THEN d.Importe ELSE 0.00 END
FROM CPD d JOIN CP c
ON c.ID = d.ID
WHERE c.ID = ISNULL(@ID, c.ID)
ORDER BY d.Renglon
INSERT @Tabla (Tipo, Columna1, Columna3,                               Columna4,                               Columna5)
SELECT         'C1', 'Total',  ISNULL(SUM(CONVERT(money,Columna3)),0), ISNULL(SUM(CONVERT(money,Columna4)),0), ISNULL(SUM(CONVERT(money,Columna5)),0)
FROM @Tabla
WHERE Tipo = 'B1'
END
DECLARE crCampos CURSOR FOR
SELECT ID, Columna2, Columna3, Columna4, Columna5, Columna6, Columna7, Columna8, Columna9, Columna10, Columna11, Columna12
FROM @Tabla
WHERE Tipo IN ('B1', 'C1')
OPEN crCampos
FETCH NEXT FROM crCampos INTO @IDTabla, @Columna2, @Columna3, @Columna4, @Columna5, @Columna6, @Columna7, @Columna8, @Columna9, @Columna10, @Columna11, @Columna12
WHILE @@FETCH_STATUS = 0
BEGIN
UPDATE @Tabla
SET Columna2  = CASE WHEN @Columna2  IS NOT NULL AND @MovTipo = 'CP.OP' THEN (SELECT CONVERT(varchar, ISNULL(CONVERT(money,Columna2 ),0), 1) FROM @Tabla WHERE ID = @IDTabla) ELSE Columna2 END,
Columna3  = CASE WHEN @Columna3  IS NOT NULL THEN (SELECT CONVERT(varchar, ISNULL(CONVERT(money,Columna3 ),0), 1) FROM @Tabla WHERE ID = @IDTabla) ELSE NULL END,
Columna4  = CASE WHEN @Columna4  IS NOT NULL THEN (SELECT CONVERT(varchar, ISNULL(CONVERT(money,Columna4 ),0), 1) FROM @Tabla WHERE ID = @IDTabla) ELSE NULL END,
Columna5  = CASE WHEN @Columna5  IS NOT NULL THEN (SELECT CONVERT(varchar, ISNULL(CONVERT(money,Columna5 ),0), 1) FROM @Tabla WHERE ID = @IDTabla) ELSE NULL END,
Columna6  = CASE WHEN @Columna6  IS NOT NULL THEN (SELECT CONVERT(varchar, ISNULL(CONVERT(money,Columna6 ),0), 1) FROM @Tabla WHERE ID = @IDTabla) ELSE NULL END,
Columna7  = CASE WHEN @Columna7  IS NOT NULL THEN (SELECT CONVERT(varchar, ISNULL(CONVERT(money,Columna7 ),0), 1) FROM @Tabla WHERE ID = @IDTabla) ELSE NULL END,
Columna8  = CASE WHEN @Columna8  IS NOT NULL THEN (SELECT CONVERT(varchar, ISNULL(CONVERT(money,Columna8 ),0), 1) FROM @Tabla WHERE ID = @IDTabla) ELSE NULL END,
Columna9  = CASE WHEN @Columna9  IS NOT NULL THEN (SELECT CONVERT(varchar, ISNULL(CONVERT(money,Columna9 ),0), 1) FROM @Tabla WHERE ID = @IDTabla) ELSE NULL END,
Columna10 = CASE WHEN @Columna10 IS NOT NULL THEN (SELECT CONVERT(varchar, ISNULL(CONVERT(money,Columna10),0), 1) FROM @Tabla WHERE ID = @IDTabla) ELSE NULL END,
Columna11 = CASE WHEN @Columna11 IS NOT NULL THEN (SELECT CONVERT(varchar, ISNULL(CONVERT(money,Columna11),0), 1) FROM @Tabla WHERE ID = @IDTabla) ELSE NULL END,
Columna12 = CASE WHEN @Columna12 IS NOT NULL THEN (SELECT CONVERT(varchar, ISNULL(CONVERT(money,Columna12),0), 1) FROM @Tabla WHERE ID = @IDTabla) ELSE NULL END
WHERE ID = @IDTabla
FETCH NEXT FROM crCampos INTO @IDTabla, @Columna2, @Columna3, @Columna4, @Columna5, @Columna6, @Columna7, @Columna8, @Columna9, @Columna10, @Columna11, @Columna12
END
CLOSE crCampos
DEALLOCATE crCampos
SELECT * FROM @Tabla ORDER BY Tipo
END

