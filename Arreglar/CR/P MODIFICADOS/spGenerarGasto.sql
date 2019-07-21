SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarGasto
@Accion		char(20),
@Empresa	char(5),
@Sucursal	int,
@Usuario	char(10),
@Modulo		char(5),
@ID		int,
@Mov		char(20),
@MovID		varchar(20),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@Ok		int		OUTPUT,
@OkRef		varchar(255)	OUTPUT,
@CRMovimiento	varchar(20) = NULL,
@MovTipo	varchar(20) = NULL,
@MovTipoGenerarGasto bit = 0

AS BEGIN
DECLARE
@CfgImpRetencionConcepto		BIT,
@TieneRetencion					BIT,
@GastoID		 				INT,
@GastoMov		 				CHAR(20),
@GastoMovID		 				VARCHAR(20),
@GastoClase		 				VARCHAR(50),
@GastoSubClase	 				VARCHAR(50),
@GastoConcepto	 				VARCHAR(50),
@GastoAcreedor	 				CHAR(10),
@GastoFactor	 				FLOAT,
@Espacio		 				CHAR(10),
@Acreedor		 				CHAR(10),
@Concepto   	 				VARCHAR(50),
@Referencia		 				VARCHAR(50),
@PorcentajeDeducible 			FLOAT,
@CfgRetencion2BaseImpuesto1		BIT,
@Importe		 				MONEY,
@Impuestos		 				MONEY,
@Retencion		 				MONEY,
@Retencion2		 				MONEY,
@Retencion3		 				MONEY,/*,
@Fecha		 					datetime,
@Moneda		 					char(10),
@TipoCambio		 				float,
@RenglonID		 				int*/
@AFGenerarGastoCfg				VARCHAR(20),
@AFMovGenerarGastoCfg			VARCHAR(20),
@CentroCostos					VARCHAR(20)
SELECT @CfgRetencion2BaseImpuesto1 = ISNULL(Retencion2BaseImpuesto1, 0) FROM Version  WITH (NOLOCK)
SELECT @GastoID = NULL
SELECT @GastoMov = CASE
WHEN @Modulo = 'CR' AND @CRMovimiento = 'Gasto' THEN GastoComprobante
WHEN @Modulo = 'CR' AND @CRMovimiento = 'Devolucion Gasto' THEN GastoDevComprobante
WHEN @Modulo = 'AF'    THEN GastoDepreciacion
WHEN @Modulo = 'AGENT' THEN AgentPagoGastos
WHEN @Modulo = 'VTAS'  THEN VentaFacturaGasto
ELSE Gasto
END
FROM EmpresaCfgMov
WITH(NOLOCK) WHERE Empresa = @Empresa
SELECT @Importe = NULL, @Impuestos = NULL, @Retencion = NULL, @Retencion2 = NULL, @Retencion3 = NULL
IF @Accion = 'CANCELAR'
BEGIN
SELECT @GastoID = ID, @GastoMov = Mov, @GastoMovID = MovID
FROM Gasto
WITH(NOLOCK) WHERE Empresa = @Empresa AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID AND Estatus NOT IN ('SINAFECTAR', 'CANCELADO')
END ELSE
BEGIN
IF @MovTipoGenerarGasto = 1
BEGIN
SELECT @GastoFactor = GastoFactor, @GastoMov = GastoMov, @GastoAcreedor = GastoAcreedor, @GastoClase = GastoClase, @GastoSubClase = GastoSubClase, @GastoConcepto = NULLIF(RTRIM(GastoConcepto), '')
FROM MovTipo
WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov
SELECT @GastoConcepto = NULLIF(NULLIF(@GastoConcepto, '(Movimiento)'), '(Articulo)')
IF @GastoAcreedor IS NULL AND @Modulo NOT IN('AF','AGENT') 
SELECT @Ok = 10118
ELSE
BEGIN
SELECT @Acreedor = @GastoAcreedor
IF @Modulo = 'INV'
BEGIN
INSERT Gasto (Sucursal, Empresa,  Mov,       FechaEmision,  Moneda, TipoCambio, Usuario,  Estatus,      UltimoCambio, Acreedor,       Clase,       SubClase,       OrigenTipo, Origen, OrigenID, Prioridad, UEN,   Proyecto)
SELECT @Sucursal, @Empresa, @GastoMov, @FechaEmision, Moneda, TipoCambio, @Usuario, 'SINAFECTAR', GETDATE(),    @GastoAcreedor, @GastoClase, @GastoSubClase, @Modulo,    e.Mov,  e.MovID, 'Normal',   e.UEN, e.Proyecto
FROM Inv e
WITH(NOLOCK) WHERE e.ID = @ID
SELECT @GastoID = SCOPE_IDENTITY()
IF @GastoID IS NOT NULL AND @Ok IS NULL
IF UPPER(@GastoConcepto) IS NULL
INSERT GastoD (ID,      Renglon,   Concepto,       Fecha,         Cantidad,                Precio,  Importe,                         Sucursal, ContUso)
SELECT @GastoID, d.Renglon, a.Descripcion1, @FechaEmision, d.Cantidad*@GastoFactor, d.Costo, d.Cantidad*d.Costo*@GastoFactor, @Sucursal, d.ContUso
FROM InvD d WITH (NOLOCK), Art a  WITH (NOLOCK)
WHERE d.ID = @ID AND a.Articulo = d.Articulo
ELSE
INSERT GastoD (ID,      Renglon,   Concepto,       Fecha,         Cantidad,                Precio,  Importe,                         Sucursal, ContUso)
SELECT @GastoID, d.Renglon, @GastoConcepto, @FechaEmision, d.Cantidad*@GastoFactor, d.Costo, d.Cantidad*d.Costo*@GastoFactor, @Sucursal, d.ContUso
FROM InvD d WITH (NOLOCK), Art a WITH (NOLOCK)
WHERE d.ID = @ID AND a.Articulo = d.Articulo
END ELSE
IF @Modulo = 'DIN'
BEGIN
INSERT Gasto (Sucursal, Empresa,  Mov,       FechaEmision,  Moneda, TipoCambio, Usuario,  Estatus,      UltimoCambio, Acreedor,       Clase,       SubClase,       OrigenTipo, Origen, OrigenID, Prioridad, UEN,   Proyecto)
SELECT @Sucursal, @Empresa, @GastoMov, @FechaEmision, Moneda, TipoCambio, @Usuario, 'SINAFECTAR', GETDATE(),    @GastoAcreedor, @GastoClase, @GastoSubClase, @Modulo,    e.Mov,  e.MovID, 'Normal',   e.UEN, e.Proyecto
FROM Dinero e
WITH(NOLOCK) WHERE e.ID = @ID
SELECT @GastoID = SCOPE_IDENTITY()
IF @GastoID IS NOT NULL AND @Ok IS NULL
INSERT GastoD (ID,      Renglon, Concepto,                                                             Fecha,         Cantidad,     Precio,    Importe,                Impuestos,                Sucursal,  ContUso)
SELECT @GastoID, 2048.0,  ISNULL(@GastoConcepto, ISNULL(NULLIF(RTRIM(e.Concepto), ''), e.Mov)), @FechaEmision, @GastoFactor, e.Importe, e.Importe*@GastoFactor, e.Impuestos*@GastoFactor, @Sucursal, e.ContUso
FROM Dinero e
WITH(NOLOCK) WHERE e.ID = @ID
END ELSE
IF @Modulo = 'CXC'
BEGIN
INSERT Gasto (Sucursal, Empresa,  Mov,       FechaEmision,  Moneda, TipoCambio, Usuario,  Estatus,      UltimoCambio, Acreedor,       Clase,       SubClase,       OrigenTipo, Origen, OrigenID, Prioridad, UEN,   Proyecto)
SELECT @Sucursal, @Empresa, @GastoMov, @FechaEmision, Moneda, TipoCambio, @Usuario, 'SINAFECTAR', GETDATE(),    @GastoAcreedor, @GastoClase, @GastoSubClase, @Modulo,    e.Mov,  e.MovID, 'Normal',   e.UEN, e.Proyecto
FROM Cxc e
WITH(NOLOCK) WHERE e.ID = @ID
SELECT @GastoID = SCOPE_IDENTITY()
IF @GastoID IS NOT NULL AND @Ok IS NULL
INSERT GastoD (ID,      Renglon, Concepto,                                                             Fecha,         Cantidad,     Precio,    Importe,                Impuestos,                Sucursal,  ContUso)
SELECT @GastoID, 2048.0,  ISNULL(@GastoConcepto, ISNULL(NULLIF(RTRIM(e.Concepto), ''), e.Mov)), @FechaEmision, @GastoFactor, e.Importe, e.Importe*@GastoFactor, e.Impuestos*@GastoFactor, @Sucursal, e.ContUso
FROM Cxc e
WITH(NOLOCK) WHERE e.ID = @ID
END ELSE
IF @Modulo = 'CR'
BEGIN
INSERT Gasto (Sucursal, Empresa,  Mov,       FechaEmision,  Moneda, TipoCambio, Usuario,  Estatus,      UltimoCambio, Acreedor,                          Clase,       SubClase,       FormaPago,       OrigenTipo, Origen, OrigenID, CtaDinero, Prioridad, UEN,    Proyecto)
SELECT @Sucursal, @Empresa, @GastoMov, @FechaEmision, Moneda, TipoCambio, @Usuario, 'SINAFECTAR', GETDATE(),    NULLIF(RTRIM(cfg.CRAcreedor), ''), cfg.CRClase, cfg.CRSubClase, cfg.CRFormaPago, @Modulo,    Mov,    MovID,    cr.Caja,   'Normal',  cr.UEN, cr.Proyecto
FROM CR WITH (NOLOCK), EmpresaCfg cfg
WITH(NOLOCK) WHERE cr.ID = @ID AND cfg.Empresa = @Empresa
SELECT @GastoID = SCOPE_IDENTITY()
IF (SELECT Acreedor FROM Gasto WITH(NOLOCK) WHERE ID = @GastoID) IS NULL SELECT @Ok = 10117
IF @GastoID IS NOT NULL AND @Ok IS NULL
INSERT GastoD (ID,      Renglon,   Concepto,   Fecha,         Referencia,   Cantidad,  Precio,    Importe,                                      Impuestos,                                                                   Sucursal,  PorcentajeDeducible)
SELECT @GastoID, d.Renglon, d.Concepto, @FechaEmision, d.Referencia, 1,         d.Importe, d.Importe/(1+(ISNULL(c.Impuestos, 0)/100.0)), d.Importe/(1+(ISNULL(c.Impuestos, 0)/100.0))*(ISNULL(c.Impuestos, 0)/100.0), @Sucursal, ISNULL(c.PorcentajeDeducible, 0.0)
 FROM CRCaja d WITH(NOLOCK), Concepto c
WITH(NOLOCK) WHERE d.ID = @ID AND d.Movimiento = @CRMovimiento
AND c.Modulo = 'GAS' AND c.Concepto = d.Concepto
END ELSE
IF @Modulo = 'VTAS'
BEGIN
SELECT @Espacio = NULLIF(RTRIM(Espacio), ''), @Concepto = NULLIF(RTRIM(GastoConcepto), ''), @Acreedor = NULLIF(RTRIM(GastoAcreedor), '') FROM Venta WITH(NOLOCK) WHERE ID = @ID
IF @Concepto IS NULL OR @Acreedor IS NULL
SELECT @Ok = 10115
ELSE BEGIN
SELECT @Referencia = RTRIM(@Mov)+' '+RTRIM(@MovID)
/*IF @MovTipo = 'VTAS.FX'
SELECT @Importe = SUM(CostoTotal), @Impuestos = SUM(CostoTotal*(Impuesto1/100.0)) FROM VentaTCalc WHERE ID = @ID
ELSE*/
SELECT @Importe = SUM(SubTotal), @Impuestos = SUM(Impuestos) FROM VentaTCalc WITH(NOLOCK) WHERE ID = @ID
INSERT Gasto (Sucursal, Empresa,  Mov,       FechaEmision,  Moneda, TipoCambio, Usuario,  Estatus,      UltimoCambio, Acreedor,  Clase,   SubClase,   Condicion,   OrigenTipo, Origen, OrigenID, Prioridad, UEN,   Proyecto)
SELECT @Sucursal, @Empresa, @GastoMov, @FechaEmision, Moneda, TipoCambio, @Usuario, 'SINAFECTAR', GETDATE(),    @Acreedor, c.Clase, c.SubClase, p.Condicion, @Modulo,    Mov,    MovID,    'Normal',  m.UEN, m.Proyecto
FROM Venta m WITH(NOLOCK), Concepto c WITH(NOLOCK), Prov p
WITH(NOLOCK) WHERE m.ID = @ID AND c.Modulo = 'GAS' AND c.Concepto = m.GastoConcepto AND p.Proveedor = m.GastoAcreedor
SELECT @GastoID = SCOPE_IDENTITY()
END
END ELSE
IF @Modulo = 'AF'
BEGIN
EXEC spAFGenerarGastoInfo @Empresa, @Mov, @Concepto OUTPUT, @GastoFactor OUTPUT, @GastoMov OUTPUT, @Acreedor OUTPUT, @GastoClase OUTPUT, @GastoSubClase OUTPUT, @AFGenerarGastoCfg OUTPUT, @AFMovGenerarGastoCfg OUTPUT
IF (SELECT Clave FROM MovTipo WITH(NOLOCK) WHERE Mov = @GastoMov AND Modulo = 'GAS') = 'GAS.GTC'
SELECT @Ok = 35005, @OkRef = @GastoMov 
ELSE IF (@AFGenerarGastoCfg = 'Empresa' AND @Concepto IS NULL) OR
(@AFGenerarGastoCfg = 'Movimiento' AND @AFMovGenerarGastoCfg = 'Especifico' AND @Concepto IS NULL) OR
(@AFGenerarGastoCfg = 'Movimiento' AND @GastoMov IS NULL) OR
(@Acreedor IS NULL)
SELECT @Ok = 10116
ELSE BEGIN
SELECT @Referencia = RTRIM(@Mov)+' '+RTRIM(@MovID)
INSERT Gasto (Sucursal, Empresa,  Mov,       FechaEmision,  Moneda, TipoCambio, Usuario,  Estatus,      UltimoCambio, Acreedor,  Clase,       SubClase,       OrigenTipo, Origen, OrigenID, Prioridad, UEN,   Proyecto,   Observaciones)
SELECT @Sucursal, @Empresa, @GastoMov, @FechaEmision, Moneda, TipoCambio, @Usuario, 'SINAFECTAR', GETDATE(),    @Acreedor, @GastoClase, @GastoSubClase, @Modulo,    Mov,    MovID,    'Normal',  m.UEN, m.Proyecto, m.Observaciones
FROM ActivoFijo m WITH(NOLOCK), Prov p
WITH(NOLOCK) WHERE m.ID = @ID AND p.Proveedor = @Acreedor
SELECT @GastoID = SCOPE_IDENTITY()
END
END ELSE
IF @Modulo = 'AGENT'
BEGIN
IF (SELECT Clave FROM MovTipo WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov) IN('AGENT.CO')
SELECT @GastoMov = GastoOtrosIngresos FROM EmpresaCfgMov WITH(NOLOCK) WHERE Empresa  = @Empresa
IF (SELECT Clave FROM MovTipo WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov) IN('AGENT.P')
SELECT @GastoMov = AgentPagoGastos FROM EmpresaCFGMov WITH(NOLOCK) WHERE Empresa  = @Empresa
SELECT @Concepto = NULLIF(RTRIM(AgentConceptoGastos), ''), @CfgImpRetencionConcepto = AgentImpRetencionConcepto FROM EmpresaCfg2  WITH(NOLOCK)WHERE Empresa = @Empresa
SELECT @Acreedor = NULLIF(RTRIM(a.Acreedor), '') FROM Agente a  WITH(NOLOCK), Agent m  WITH(NOLOCK) WHERE a.Agente = m.Agente AND m.ID = @ID
SELECT @CentroCostos = CentroCostos FROM Prov WITH(NOLOCK) WHERE Proveedor = @Acreedor
EXEC xpGenerarGastoConceptoAcreedor @Modulo, @ID, @Acreedor OUTPUT, @Concepto OUTPUT
IF @Concepto IS NULL OR @Acreedor IS NULL
SELECT @Ok = 10116
ELSE BEGIN
SELECT @Referencia = RTRIM(@Mov)+' '+RTRIM(@MovID)
SELECT @Importe = Importe, @Impuestos = Impuestos, @Retencion = Retencion FROM Agent  WITH(NOLOCK) WHERE ID = @ID
IF @CfgImpRetencionConcepto = 1
SELECT @Impuestos  = @Importe * (Impuestos/100.0),
@Retencion  = @Importe * (Retencion/100.0),
@Retencion2 = CASE WHEN @CfgRetencion2BaseImpuesto1 = 1 THEN @Importe * (Impuestos/100.0) * (Retencion2/100.0) ELSE @Importe * (Retencion2/100.0) END,
@Retencion3 = @Importe * (Retencion3/100.0)
FROM Concepto
WITH(NOLOCK) WHERE Modulo = 'GAS' AND Concepto = @Concepto
IF NULLIF(@Retencion, 0.0) IS NOT NULL OR NULLIF(@Retencion2, 0.0) IS NOT NULL SELECT @TieneRetencion = 1 ELSE SELECT @TieneRetencion = 0
INSERT Gasto (Sucursal, Empresa,  Mov,       FechaEmision,  Moneda, TipoCambio, Usuario,  Estatus,      UltimoCambio, Acreedor,  Clase,   SubClase,   OrigenTipo, Origen, OrigenID, CtaDinero,   FormaPago,   TieneRetencion,  Prioridad, UEN,   Proyecto)
SELECT @Sucursal, @Empresa, @GastoMov, @FechaEmision, Moneda, TipoCambio, @Usuario, 'SINAFECTAR', GETDATE(),    @Acreedor, c.Clase, c.SubClase, @Modulo,    Mov,    MovID,    m.CtaDinero, m.FormaPago, @TieneRetencion, 'Normal',  m.UEN, m.Proyecto
FROM Agent m  WITH(NOLOCK), Concepto c  WITH(NOLOCK), Prov p
WITH(NOLOCK) WHERE m.ID = @ID AND c.Modulo = 'GAS' AND c.Concepto = @Concepto AND p.Proveedor = @Acreedor
SELECT @GastoID = SCOPE_IDENTITY()
END
END
IF @Ok IS NULL
BEGIN
IF @GastoID IS NULL
SELECT @Ok = 10110, @OkRef = @Modulo
ELSE
BEGIN
SELECT @PorcentajeDeducible = 0.0
SELECT @PorcentajeDeducible = ISNULL(PorcentajeDeducible, 0.0) FROM Concepto  WITH(NOLOCK) WHERE Modulo = 'GAS' AND Concepto = @Concepto
IF @Modulo <> 'AF'
INSERT GastoD (
ID,       Renglon,  Concepto,  Fecha,         Referencia,  Cantidad,  Precio,   Importe,  Impuestos,  Retencion,  Retencion2,  Retencion3,  Sucursal,  Espacio,  PorcentajeDeducible,  UEN, Proyecto, ContUso)
SELECT @GastoID, 2048,     @Concepto, @FechaEmision, @Referencia, 1,         @Importe, @Importe, @Impuestos, @Retencion, @Retencion2, @Retencion3, @Sucursal, @Espacio, @PorcentajeDeducible, UEN, Proyecto, @CentroCostos
FROM Gasto
WITH(NOLOCK) WHERE ID = @GastoID
ELSE
BEGIN
CREATE TABLE #GastoD(
ID						int,
Renglon					int			IDENTITY(2048, 2048),
Categoria				varchar(50) COLLATE Database_Default NULL,
Articulo				varchar(20) COLLATE Database_Default NULL,
Serie					varchar(20) COLLATE Database_Default NULL,
Concepto				varchar(50) COLLATE Database_Default NULL,
Cantidad				float		NULL,
Precio					float		NULL,
Importe					float		NULL,
Impuestos				float		NULL,
PorcentajeDeducible		float		NULL,
Impuesto1				float		NULL,
Impuesto2				float		NULL,
Impuesto3				float		NULL,
Retencion				float		NULL,
Retencion2				float		NULL,
Retencion3				float		NULL,
Espacio					varchar(10)	COLLATE Database_Default NULL,
UEN						int			NULL,
Proyecto				varchar(50)	COLLATE Database_Default NULL,
ContUso					varchar(20)	COLLATE Database_Default NULL,
ContUso2				varchar(20)	COLLATE Database_Default NULL,
ContUso3				varchar(20)	COLLATE Database_Default NULL
)
EXEC spAFGenerarGastoD @Empresa, @Mov, @ID, @GastoID, @MovTipo, @Concepto, @GastoFactor, @AFGenerarGastoCfg, @AFMovGenerarGastoCfg, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL
INSERT GastoD (
ID,       Renglon, Concepto,   Fecha,         Referencia,  Cantidad, Precio, Importe,   Retencion,   Retencion2,   Retencion3,   Impuestos,   Sucursal,  Espacio,  PorcentajeDeducible,   UEN,   Proyecto,   ContUso,   ContUso2,   ContUso3,   AFArticulo, AFSerie, Impuesto1, Impuesto2, Impuesto3)
SELECT @GastoID, Renglon, d.Concepto, @FechaEmision, @Referencia, Cantidad, Precio, d.Importe, d.Retencion, d.Retencion2, d.Retencion3, d.Impuestos, @Sucursal, @Espacio, d.PorcentajeDeducible, d.UEN, d.Proyecto, d.ContUso, d.ContUso2, d.ContUso3, Articulo,   Serie,   Impuesto1, Impuesto2, Impuesto3
FROM #GastoD d
JOIN Gasto g  WITH(NOLOCK) ON d.ID = g.ID
END
END
END
END
END
END
IF @GastoID IS NOT NULL AND @Ok IS NULL
EXEC xpGenerarGasto @GastoID, @Accion, @Empresa, @Sucursal, @Usuario, @Modulo, @ID, @Mov, @MovID, @FechaEmision, @FechaRegistro, @Ok OUTPUT, @OkRef OUTPUT
IF @GastoID IS NOT NULL AND @Ok IS NULL
EXEC spGasto @GastoID, 'GAS', @Accion, 'TODO', @FechaRegistro, NULL, @Usuario, 1, 0, @GastoMov, @GastoMovID OUTPUT, NULL, @Ok OUTPUT, @OkRef OUTPUT
IF @GastoID IS NOT NULL AND (@Ok IS NULL OR @Ok BETWEEN 80030 AND 81000)
EXEC spMovFlujo @Sucursal, @Accion, @Empresa, @Modulo, @ID, @Mov, @MovID, 'GAS', @GastoID, @GastoMov, @GastoMovID, @Ok OUTPUT
RETURN
END

