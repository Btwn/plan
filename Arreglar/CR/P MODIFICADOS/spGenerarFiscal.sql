SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGenerarFiscal
@Empresa		char(5),
@Sucursal		int,
@Modulo		char(5),
@ID			int,
@Estatus		char(15),
@EstatusNuevo	char(15),
@Usuario		char(10),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@Mov			char(20),
@MovID		varchar(20),
@MovTipo		char(20),
@AfectarFiscal	varchar(20),
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@FiscalID					int,
@FiscalMov					varchar(20),
@FiscalMovID				varchar(20),
@ObligacionFiscal			varchar(50),
@OrigenModulo				varchar(5),
@OrigenModuloID				int,
@Tipo						varchar(20),
@ObligacionFechaD			datetime,
@Importe					money,
@OtrosImpuestos				money,
@Tasa						float,
@Excento					bit,
@Deducible					float,
@Moneda						varchar(10),
@TipoCambio					float,
@Proyecto					varchar(50),
@UEN						int,
@Renglon					float,
@CfgOmitirDepositoAntCxc	bit,
@CfgOmitirChAntCxp			bit,
@CfgOmitirCobrosChDevCxc	bit,
@CfgOmitirPagosChDevCxp		bit,
@CfgOmitirPagosEndosoCxp	bit,
@CfgRegAplicaAnticipoCxc	bit,
@CfgRegAplicaFacturaCxc		bit,
@CfgRegAplicaAnticipoCxp	bit,
@CfgRegAplicaFacturaCxp		bit,
@FiscalRegimen				varchar(30),
@ObligacionFiscalEspecifica	bit,
@ObligacionFiscalRegimen	varchar(30)
IF @EstatusNuevo <> 'CANCELADO'
IF EXISTS (SELECT DID FROM MovFlujo WITH(NOLOCK) WHERE DModulo = 'FIS' AND OModulo = @Modulo AND OID = @ID) AND @EstatusNuevo <> 'CANCELADO'
RETURN
IF @EstatusNuevo <> 'CANCELADO' AND dbo.fnFiscalVerificarContacto(@Modulo, @ID) = 0 
RETURN 
SELECT @CfgOmitirDepositoAntCxc = FiscalOmitirDepositoAntCxc,
@CfgOmitirChAntCxp = FiscalOmitirChAntCxp,
@CfgOmitirCobrosChDevCxc = FiscalOmitirCobrosChDevCxc,
@CfgOmitirPagosChDevCxp = FiscalOmitirPagosChDevCxp,
@CfgOmitirPagosEndosoCxp = FiscalOmitirPagosEndosoCxp,
@CfgRegAplicaAnticipoCxc = FiscalRegAplicaAnticipoCxc,
@CfgRegAplicaFacturaCxc = FiscalRegAplicaFacturaCxc,
@CfgRegAplicaAnticipoCxp = FiscalRegAplicaAnticipoCxp,
@CfgRegAplicaFacturaCxp = FiscalRegAplicaFacturaCxp
FROM EmpresaCfg2
WHERE Empresa = @Empresa
/*
IF @CfgOmitirDepositoAntCxc = 1 AND @MovTipo IN ('DIN.D', 'DIN.DE')
BEGIN
IF EXISTS (SELECT d.ID FROM Dinero d
 WITH(NOLOCK) JOIN MovFlujo m  WITH(NOLOCK) ON d.ID = m.DID AND m.DModulo = 'DIN' AND m.OModulo = 'DIN'
JOIN MovTipo ts  WITH(NOLOCK) ON m.OMov = ts.Mov AND ts.Clave = 'DIN.SD'
JOIN Dinero s  WITH(NOLOCK) ON m.OID = s.ID
JOIN MovTipo omt  WITH(NOLOCK) ON omt.Modulo = s.OrigenTipo  AND omt.Mov = s.Origen
WHERE omt.Clave = 'CXC.A' AND d.ID = @ID)
OR (SELECT mt.Clave FROM Dinero d  WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = d.OrigenTipo AND mt.Mov = d.Origen WHERE ID = @ID) = 'CXC.A'
RETURN
END
IF @CfgOmitirChAntCxp = 1 AND @MovTipo IN ('DIN.CH', 'DIN.CHE')
BEGIN
IF EXISTS (SELECT d.ID FROM Dinero d
 WITH(NOLOCK) JOIN MovFlujo m  WITH(NOLOCK) ON d.ID = m.DID AND m.DModulo = 'DIN' AND m.OModulo = 'DIN'
JOIN MovTipo ts  WITH(NOLOCK) ON m.OMov = ts.Mov AND ts.Clave = 'DIN.SCH'
JOIN Dinero s  WITH(NOLOCK) ON m.OID = s.ID
JOIN MovTipo omt  WITH(NOLOCK) ON omt.Modulo = s.OrigenTipo  AND omt.Mov = s.Origen
WHERE omt.Clave = 'CXP.A' AND d.ID = @ID)
OR (SELECT mt.Clave FROM Dinero d  WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = d.OrigenTipo AND mt.Mov = d.Origen WHERE ID = @ID) = 'CXP.A'
RETURN
END
*/
IF @CfgOmitirCobrosChDevCxc = 1
IF EXISTS (SELECT * FROM MovImpuesto p
 WITH(NOLOCK) JOIN cxc c  WITH(NOLOCK) ON p.OrigenModulo = 'CXC' AND p.OrigenModuloID = c.ID AND c.Estatus = 'CONCLUIDO'
JOIN MovTipo m  WITH(NOLOCK) ON c.Mov = m.Mov AND m.Modulo = 'CXC' AND m.Clave = 'CXC.CD'
WHERE p.Modulo = 'DIN' AND p.ModuloID = @ID)
RETURN
IF @CfgOmitirPagosChDevCxp = 1
IF EXISTS (SELECT * FROM MovImpuesto p
 WITH(NOLOCK) JOIN cxp c  WITH(NOLOCK) ON p.OrigenModulo = 'CXP' AND p.OrigenModuloID = c.ID AND c.Estatus = 'CONCLUIDO'
JOIN MovTipo m  WITH(NOLOCK) ON c.Mov = m.Mov AND m.Modulo = 'CXP' AND m.Clave = 'CXP.CD'
WHERE p.Modulo = 'DIN' AND p.ModuloID = @ID)
RETURN
IF @CfgOmitirPagosChDevCxp = 1
IF EXISTS (SELECT * FROM MovImpuesto p
 WITH(NOLOCK) JOIN cxp c  WITH(NOLOCK) ON p.OrigenModulo = 'CXP' AND p.OrigenModuloID = c.ID AND c.Estatus = 'CONCLUIDO'
JOIN MovTipo m  WITH(NOLOCK) ON c.Mov = m.Mov AND m.Modulo = 'CXP' AND m.Clave = 'CXP.CD'
WHERE p.Modulo = 'CXP' AND p.ModuloID = @ID)
RETURN
IF @CfgOmitirCobrosChDevCxc = 1
IF EXISTS (SELECT * FROM MovImpuesto p
 WITH(NOLOCK) JOIN cxc c  WITH(NOLOCK) ON p.OrigenModulo = 'CXC' AND p.OrigenModuloID = c.ID AND c.Estatus = 'CONCLUIDO'
JOIN MovTipo m  WITH(NOLOCK) ON c.Mov = m.Mov AND m.Modulo = 'CXC' AND m.Clave = 'CXC.CD'
WHERE p.Modulo = 'CXC' AND p.ModuloID = @ID)
RETURN
IF @CfgRegAplicaAnticipoCxc = 1 AND @MovTipo = 'CXC.ANC'
BEGIN
IF (SELECT Clave FROM Cxc c  WITH(NOLOCK) JOIN MovTipo m  WITH(NOLOCK) ON c.MovAplica = m.Mov AND m.Modulo = 'CXC'  WHERE c.ID = @ID) <> 'CXC.A'
RETURN
IF @CfgRegAplicaFacturaCxc = 1 AND NOT EXISTS (SELECT *
FROM Cxc c
 WITH(NOLOCK) JOIN CXCD d  WITH(NOLOCK) ON c.ID = D.ID
JOIN cxc a  WITH(NOLOCK) ON d.Aplica = a.Mov AND d.aplicaID = a.MovID and c.Empresa = a.Empresa
JOIN Movtipo m  WITH(NOLOCK) ON m.mov = d.Aplica and m.Modulo = 'CXC'
WHERE c.ID = @ID AND m.Clave = 'CXC.F')
RETURN
END
IF @CfgRegAplicaAnticipoCxp = 1 AND @MovTipo = 'CXP.ANC'
BEGIN
IF (SELECT Clave FROM Cxc c  WITH(NOLOCK) JOIN MovTipo m  WITH(NOLOCK) ON c.MovAplica = m.Mov AND m.Modulo = 'CXP'  WHERE c.ID = @ID) <> 'CXP.A'
RETURN
IF @CfgRegAplicaFacturaCxp = 1 AND NOT EXISTS (SELECT *
FROM Cxc c
 WITH(NOLOCK) JOIN CXCD d  WITH(NOLOCK) ON c.ID = D.ID
JOIN cxc a  WITH(NOLOCK) ON d.Aplica = a.Mov AND d.aplicaID = a.MovID and c.Empresa = a.Empresa
JOIN Movtipo m  WITH(NOLOCK) ON m.mov = d.Aplica and m.Modulo = 'CXP'
WHERE c.ID = @ID AND m.Clave = 'CXP.F')
RETURN
END
IF @CfgOmitirPagosEndosoCxp = 1
IF @MovTipo = 'CXP.P' AND EXISTS (SELECT * FROM Cxp c  WITH(NOLOCK) JOIN MovFlujo m  WITH(NOLOCK) ON m.DModulo = 'CXP' AND m.DID = c.ID AND m.OModulo = 'CXP' JOIN MovTipo t  WITH(NOLOCK) ON t.Modulo = 'CXP' AND t.Mov = m.OMov WHERE c.ID = @ID AND t.Clave = 'CXP.FAC')
RETURN
DECLARE
@FiscalD		TABLE (
Renglon				float		NULL,
ObligacionFiscal	varchar(50)	COLLATE Database_Default NULL,
TipoImpuesto		varchar(10)	COLLATE Database_Default NULL,
Importe             money           NULL,
OtrosImpuestos		money           NULL,
Tasa				float		NULL,
Excento				bit		NULL	DEFAULT 0,
Deducible			float		NULL 	DEFAULT 100,
OrigenModulo		varchar(5)	COLLATE Database_Default NULL,
OrigenModuloID		int		NULL,
Contacto			varchar(10)	COLLATE Database_Default NULL,
ContactoTipo		varchar(20)	COLLATE Database_Default NULL,
AFArticulo			varchar(20)	COLLATE Database_Default NULL,
AFSerie				varchar(50)	COLLATE Database_Default NULL,  
OrigenMoneda		varchar(10)	COLLATE Database_Default NULL,	
OrigenTipoCambio	float	NULL,								
Tipo				varchar(20) NULL,							
Retencion1		float	NULL,									
Retencion2		float	NULL,									
Retencion3		float	NULL,									
AplicaModulo    varchar(20) NULL,
AplicaID        int NULL)
IF @MovTipo IN ('DIN.D', 'DIN.CH') AND @EstatusNuevo = 'PENDIENTE'
RETURN
IF @EstatusNuevo = 'CANCELADO'
BEGIN
/*
DECLARE crFiscal CURSOR LOCAL FOR
SELECT ID, Mov, MovID
FROM Fiscal WITH(NOLOCK)
WHERE  Empresa = @Empresa AND Estatus = 'CONCLUIDO' AND OrigenTipo = @Modulo AND Origen = @Mov AND OrigenID = @MovID
*/
DECLARE crFiscal CURSOR LOCAL FOR
SELECT F.ID, F.Mov, F.MovID
FROM MovFlujo M
 WITH(NOLOCK) JOIN Fiscal   F  WITH(NOLOCK) ON M.DID = F.ID
WHERE M.Empresa = @Empresa AND OModulo = @Modulo AND OID = @ID AND OMov = @Mov AND OMovID = @MovID AND M.DModulo = 'FIS' AND M.Cancelado = 0
OPEN crFiscal
FETCH NEXT FROM crFiscal  INTO @FiscalID, @FiscalMov, @FiscalMovID
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
EXEC spAfectar 'FIS', @FiscalID, 'CANCELAR', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
EXEC spMovFlujo @Sucursal, 'CANCELAR', @Empresa, @Modulo, @ID, @Mov, @MovID, 'FIS', @FiscalID, @FiscalMov, @FiscalMovID, @Ok OUTPUT
END
FETCH NEXT FROM crFiscal  INTO @FiscalID, @FiscalMov, @FiscalMovID
END
CLOSE crFiscal
DEALLOCATE crFiscal
RETURN
END ELSE
BEGIN
EXEC spMovInfo @ID, @Modulo, @Moneda = @Moneda OUTPUT, @TipoCambio = @TipoCambio OUTPUT, @Proyecto = @Proyecto OUTPUT, @UEN = @UEN OUTPUT
SELECT @FiscalRegimen = dbo.fnFiscalRegimen(@Modulo, @ID) 
IF EXISTS(SELECT * FROM MovTipoObligacionFiscal WITH(NOLOCK) WHERE Modulo = @Modulo AND Mov = @Mov) SELECT @ObligacionFiscalEspecifica = 1 ELSE SELECT @ObligacionFiscalEspecifica = 0
DECLARE crObligacionFiscal CURSOR LOCAL FOR
SELECT o.ObligacionFiscal, o.Tipo, o.FechaD, o.Regimen
FROM ObligacionFiscal o LEFT OUTER  WITH(NOLOCK) JOIN MovTipoObligacionFiscal mtof
 WITH(NOLOCK) ON mtof.Modulo = @Modulo AND mtof.Mov = @Mov AND mtof.ObligacionFiscal = o.ObligacionFiscal
WHERE o.GenerarEn = ISNULL(CASE WHEN @AfectarFiscal IN ('Emision Acumulable', 'Emision Deducible') THEN 'Emision' WHEN @AfectarFiscal IN ('Endoso Acumulable', 'Endoso Deducible') THEN NULL ELSE 'Flujo' END, o.GenerarEn) 
AND o.GenerarEn NOT IN (NULL, 'No')
AND ((ISNULL(NULLIF(o.Regimen,'(Todos)'),@FiscalRegimen) = @FiscalRegimen) OR (o.Regimen = ISNULL(NULLIF(@FiscalRegimen,'(Todos)'),o.Regimen))) 
AND (mtof.ObligacionFiscal IS NOT NULL OR @ObligacionFiscalEspecifica = 0)
ORDER BY Orden
OPEN crObligacionFiscal
FETCH NEXT FROM crObligacionFiscal  INTO @ObligacionFiscal, @Tipo, @ObligacionFechaD, @ObligacionFiscalRegimen
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @Tipo = 'Impuesto 1'
INSERT @FiscalD (
ObligacionFiscal,  Importe,       OtrosImpuestos, TipoImpuesto,  Tasa,      Excento,  OrigenModulo, OrigenModuloID, Deducible,       OrigenMoneda,                                           OrigenTipoCambio,                                           Tipo,  Retencion1, Retencion2, Retencion3, AplicaModulo, AplicaID) 
SELECT @ObligacionFiscal, SUM(SubTotal), SUM(Importe2),  TipoImpuesto1, Impuesto1, Excento1, OrigenModulo, OrigenModuloID, OrigenDeducible, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), @Tipo, 0.0,        Retencion2, 0.0, AplicaModulo, AplicaID 
FROM MovImpuesto
WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID AND ISNULL(Excento1,0) = 0
AND (((ISNULL(NULLIF(@ObligacionFiscalRegimen,'(Todos)'),dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) = dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) OR (@ObligacionFiscalRegimen = ISNULL(NULLIF(dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID),'(Todos)'),@ObligacionFiscalRegimen))) OR @AfectarFiscal NOT IN ('Conciliacion'))
AND (dbo.fnFiscalVerificarContacto(OrigenModulo, OrigenModuloID) = 1  OR @AfectarFiscal NOT IN ('Conciliacion'))  
AND dbo.fnFiscalVerificarObligacionFiscal(@Modulo, @Mov, OrigenModulo, dbo.fnFiscalOrigenMov(OrigenModulo,OrigenModuloID),@ObligacionFiscal) = 1 
GROUP BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), TipoImpuesto1, Impuesto1, Excento1, OrigenDeducible, Retencion1, Retencion2, Retencion3, AplicaModulo, AplicaID 
ORDER BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), TipoImpuesto1, Impuesto1, Excento1, OrigenDeducible, Retencion1, Retencion2, Retencion3, AplicaModulo, AplicaID 
ELSE
IF @Tipo = 'Impuesto 2'
INSERT @FiscalD (
ObligacionFiscal, Importe,        TipoImpuesto,  Tasa,      OrigenModulo, OrigenModuloID, Deducible,       OrigenMoneda,                                           OrigenTipoCambio,                                           Tipo,  Retencion1, Retencion2, Retencion3, AplicaModulo, AplicaID) 
SELECT @ObligacionFiscal, SUM(SubTotal), TipoImpuesto2, Impuesto2, OrigenModulo, OrigenModuloID, OrigenDeducible, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), @Tipo, 0.0,        0.0,        0.0, AplicaModulo, AplicaID 
FROM MovImpuesto
WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID AND NULLIF(Impuesto2, 0.0) IS NOT NULL
AND (((ISNULL(NULLIF(@ObligacionFiscalRegimen,'(Todos)'),dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) = dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) OR (@ObligacionFiscalRegimen = ISNULL(NULLIF(dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID),'(Todos)'),@ObligacionFiscalRegimen))) OR @AfectarFiscal NOT IN ('Conciliacion'))
AND (dbo.fnFiscalVerificarContacto(OrigenModulo, OrigenModuloID) = 1  OR @AfectarFiscal NOT IN ('Conciliacion'))  
AND dbo.fnFiscalVerificarObligacionFiscal(@Modulo, @Mov, OrigenModulo, dbo.fnFiscalOrigenMov(OrigenModulo,OrigenModuloID),@ObligacionFiscal) = 1 
GROUP BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), TipoImpuesto2, Impuesto2, OrigenDeducible, Retencion1, Retencion2, Retencion3, AplicaModulo, AplicaID 
ORDER BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), TipoImpuesto2, Impuesto2, OrigenDeducible, Retencion1, Retencion2, Retencion3, AplicaModulo, AplicaID 
ELSE
IF @Tipo = 'Impuesto 3'
INSERT @FiscalD (
ObligacionFiscal,  Importe,       TipoImpuesto,   Tasa,      OrigenModulo, OrigenModuloID, Deducible,       OrigenMoneda,                                           OrigenTipoCambio,                                           Tipo,  Retencion1, Retencion2, Retencion3, AplicaModulo, AplicaID) 
SELECT @ObligacionFiscal, SUM(Importe3), TipoImpuesto3,  100.0,     OrigenModulo, OrigenModuloID, OrigenDeducible, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), @Tipo, Retencion1, Retencion2, Retencion3, AplicaModulo, AplicaID 
FROM MovImpuesto
WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID AND NULLIF(Impuesto3, 0.0) IS NOT NULL
AND (((ISNULL(NULLIF(@ObligacionFiscalRegimen,'(Todos)'),dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) = dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) OR (@ObligacionFiscalRegimen = ISNULL(NULLIF(dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID),'(Todos)'),@ObligacionFiscalRegimen))) OR @AfectarFiscal NOT IN ('Conciliacion'))
AND (dbo.fnFiscalVerificarContacto(OrigenModulo, OrigenModuloID) = 1  OR @AfectarFiscal NOT IN ('Conciliacion'))  
AND dbo.fnFiscalVerificarObligacionFiscal(@Modulo, @Mov, OrigenModulo, dbo.fnFiscalOrigenMov(OrigenModulo,OrigenModuloID),@ObligacionFiscal) = 1 
GROUP BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), TipoImpuesto3, Impuesto3, OrigenDeducible, Retencion1, Retencion2, Retencion3, AplicaModulo, AplicaID 
ORDER BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), TipoImpuesto3, Impuesto3, OrigenDeducible, Retencion1, Retencion2, Retencion3, AplicaModulo, AplicaID 
ELSE
IF @Tipo = 'Retencion 1'
INSERT @FiscalD (
ObligacionFiscal, Importe,        TipoImpuesto,  Tasa,       OrigenModulo, OrigenModuloID, Deducible,        OrigenMoneda,                                           OrigenTipoCambio,                                           Tipo, AplicaModulo, AplicaID) 
SELECT @ObligacionFiscal, SUM(SubTotal), TipoRetencion1, Retencion1, OrigenModulo, OrigenModuloID, OrigenDeducible, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), @Tipo, AplicaModulo, AplicaID 
FROM MovImpuesto
WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID AND NULLIF(Retencion1, 0.0) IS NOT NULL
AND (((ISNULL(NULLIF(@ObligacionFiscalRegimen,'(Todos)'),dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) = dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) OR (@ObligacionFiscalRegimen = ISNULL(NULLIF(dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID),'(Todos)'),@ObligacionFiscalRegimen))) OR @AfectarFiscal NOT IN ('Conciliacion'))
AND (dbo.fnFiscalVerificarContacto(OrigenModulo, OrigenModuloID) = 1  OR @AfectarFiscal NOT IN ('Conciliacion'))  
AND dbo.fnFiscalVerificarObligacionFiscal(@Modulo, @Mov, OrigenModulo, dbo.fnFiscalOrigenMov(OrigenModulo,OrigenModuloID),@ObligacionFiscal) = 1 
GROUP BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), TipoRetencion1, Retencion1, OrigenDeducible, AplicaModulo, AplicaID 
ORDER BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), TipoRetencion1, Retencion1, OrigenDeducible, AplicaModulo, AplicaID 
ELSE
IF @Tipo = 'Retencion 2'
INSERT @FiscalD (
ObligacionFiscal, Importe,        TipoImpuesto,   Tasa,       OrigenModulo, OrigenModuloID, Deducible,       OrigenMoneda,                                           OrigenTipoCambio,                                           Tipo, AplicaModulo, AplicaID) 
SELECT @ObligacionFiscal, SUM(SubTotal), TipoRetencion2, Retencion2, OrigenModulo, OrigenModuloID, OrigenDeducible, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), @Tipo, AplicaModulo, AplicaID 
FROM MovImpuesto
WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID AND NULLIF(Retencion2, 0.0) IS NOT NULL
AND (((ISNULL(NULLIF(@ObligacionFiscalRegimen,'(Todos)'),dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) = dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) OR (@ObligacionFiscalRegimen = ISNULL(NULLIF(dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID),'(Todos)'),@ObligacionFiscalRegimen))) OR @AfectarFiscal NOT IN ('Conciliacion'))
AND (dbo.fnFiscalVerificarContacto(OrigenModulo, OrigenModuloID) = 1  OR @AfectarFiscal NOT IN ('Conciliacion'))  
AND dbo.fnFiscalVerificarObligacionFiscal(@Modulo, @Mov, OrigenModulo, dbo.fnFiscalOrigenMov(OrigenModulo,OrigenModuloID),@ObligacionFiscal) = 1 
GROUP BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), TipoRetencion2, Retencion2, OrigenDeducible, AplicaModulo, AplicaID 
ORDER BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), TipoRetencion2, Retencion2, OrigenDeducible, AplicaModulo, AplicaID 
ELSE
IF @Tipo = 'Retencion 3'
INSERT @FiscalD (
ObligacionFiscal, Importe,        TipoImpuesto,   Tasa,       OrigenModulo, OrigenModuloID, Deducible,       OrigenMoneda,                                           OrigenTipoCambio,                                           Tipo, AplicaModulo, AplicaID) 
SELECT @ObligacionFiscal, SUM(SubTotal), TipoRetencion3, Retencion3, OrigenModulo, OrigenModuloID, OrigenDeducible, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), @Tipo, AplicaModulo, AplicaID 
FROM MovImpuesto
WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID AND NULLIF(Retencion3, 0.0) IS NOT NULL
AND (((ISNULL(NULLIF(@ObligacionFiscalRegimen,'(Todos)'),dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) = dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) OR (@ObligacionFiscalRegimen = ISNULL(NULLIF(dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID),'(Todos)'),@ObligacionFiscalRegimen))) OR @AfectarFiscal NOT IN ('Conciliacion'))
AND (dbo.fnFiscalVerificarContacto(OrigenModulo, OrigenModuloID) = 1  OR @AfectarFiscal NOT IN ('Conciliacion'))  
AND dbo.fnFiscalVerificarObligacionFiscal(@Modulo, @Mov, OrigenModulo, dbo.fnFiscalOrigenMov(OrigenModulo,OrigenModuloID),@ObligacionFiscal) = 1 
GROUP BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), TipoRetencion3, Retencion3, OrigenDeducible, AplicaModulo, AplicaID 
ORDER BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), TipoRetencion3, Retencion3, OrigenDeducible, AplicaModulo, AplicaID 
ELSE
IF @Tipo = 'Base 2'
INSERT @FiscalD (
ObligacionFiscal, Importe,        Excento,  OrigenModulo, OrigenModuloID, Deducible,       OrigenMoneda,                                           OrigenTipoCambio,                                           Tipo, AplicaModulo, AplicaID) 
SELECT @ObligacionFiscal, SUM(SubTotal), Excento2, OrigenModulo, OrigenModuloID, OrigenDeducible, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), @Tipo, AplicaModulo, AplicaID 
FROM MovImpuesto
WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID AND ISNULL(Excento2,0) = 0
AND (((ISNULL(NULLIF(@ObligacionFiscalRegimen,'(Todos)'),dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) = dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) OR (@ObligacionFiscalRegimen = ISNULL(NULLIF(dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID),'(Todos)'),@ObligacionFiscalRegimen))) OR @AfectarFiscal NOT IN ('Conciliacion'))
AND (dbo.fnFiscalVerificarContacto(OrigenModulo, OrigenModuloID) = 1  OR @AfectarFiscal NOT IN ('Conciliacion'))  
AND dbo.fnFiscalVerificarObligacionFiscal(@Modulo, @Mov, OrigenModulo, dbo.fnFiscalOrigenMov(OrigenModulo,OrigenModuloID),@ObligacionFiscal) = 1 
GROUP BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), Excento2, OrigenDeducible, AplicaModulo, AplicaID 
ORDER BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), Excento2, OrigenDeducible, AplicaModulo, AplicaID 
ELSE
IF @Tipo = 'Base 3'
INSERT @FiscalD (
ObligacionFiscal, Importe,        Excento,  OrigenModulo, OrigenModuloID, Deducible,       OrigenMoneda,                                           OrigenTipoCambio,                                           Tipo, AplicaModulo, AplicaID) 
SELECT @ObligacionFiscal, SUM(SubTotal), Excento3, OrigenModulo, OrigenModuloID, OrigenDeducible, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), @Tipo, AplicaModulo, AplicaID 
FROM MovImpuesto
WITH(NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID AND ISNULL(Excento3,0) = 0 AND Origenfecha > @ObligacionFechaD
AND (((ISNULL(NULLIF(@ObligacionFiscalRegimen,'(Todos)'),dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) = dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID)) OR (@ObligacionFiscalRegimen = ISNULL(NULLIF(dbo.fnFiscalRegimen(OrigenModulo,OrigenModuloID),'(Todos)'),@ObligacionFiscalRegimen))) OR @AfectarFiscal NOT IN ('Conciliacion'))
AND (dbo.fnFiscalVerificarContacto(OrigenModulo, OrigenModuloID) = 1  OR @AfectarFiscal NOT IN ('Conciliacion'))  
AND dbo.fnFiscalVerificarObligacionFiscal(@Modulo, @Mov, OrigenModulo, dbo.fnFiscalOrigenMov(OrigenModulo,OrigenModuloID),@ObligacionFiscal) = 1 
GROUP BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), Excento3, OrigenDeducible, AplicaModulo, AplicaID 
ORDER BY OrigenModulo, OrigenModuloID, dbo.fnFiscalOrigenMoneda(OrigenModulo, OrigenModuloID), dbo.fnFiscalOrigenTipoCambio(OrigenModulo, OrigenModuloID), Excento3, OrigenDeducible, AplicaModulo, AplicaID 
END
FETCH NEXT FROM crObligacionFiscal  INTO @ObligacionFiscal, @Tipo, @ObligacionFechaD, @ObligacionFiscalRegimen
END
CLOSE crObligacionFiscal
DEALLOCATE crObligacionFiscal
DELETE @FiscalD
WHERE ABS(ROUND(ISNULL(Importe, 0.0)+ISNULL(OtrosImpuestos, 0.0), 10)) < 0.01
DELETE @FiscalD
FROM @FiscalD d
LEFT OUTER JOIN ObligacionFiscal o  WITH(NOLOCK) ON o.ObligacionFiscal = d.ObligacionFiscal
JOIN Mov m  WITH(NOLOCK) ON m.Empresa = @Empresa AND m.Modulo = d.OrigenModulo AND m.ID = d.OrigenModuloID
WHERE m.FechaEmision NOT BETWEEN ISNULL(o.FechaD, m.FechaEmision) AND ISNULL(o.FechaA, m.FechaEmision)
DELETE @FiscalD
FROM @FiscalD d
LEFT OUTER JOIN ObligacionFiscal o  WITH(NOLOCK) ON o.ObligacionFiscal = d.ObligacionFiscal
JOIN Mov m  WITH(NOLOCK) ON m.Empresa = @Empresa AND m.Modulo = d.OrigenModulo AND m.ID = d.OrigenModuloID
JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = m.Modulo AND mt.Mov = m.Mov
WHERE mt.Clave <> @MovTipo AND mt.AfectarFiscal IN ('Endoso Acumulable', 'Endoso Deducible')
IF @Modulo = 'CONC'
BEGIN
INSERT @FiscalD (
OrigenModulo, OrigenModuloID, ObligacionFiscal, Tasa, Importe)
SELECT @Modulo,      @ID,            ObligacionFiscal, Tasa, dbo.fnFiscalImporte(TipoImporte, ISNULL(SUM(Cargo), 0.0)-ISNULL(SUM(Abono), 0.0), Tasa)
FROM ConciliacionD
WITH(NOLOCK) WHERE ID = @ID AND NULLIF(RTRIM(ObligacionFiscal), '') IS NOT NULL
GROUP BY ObligacionFiscal, Tasa, TipoImporte
ORDER BY ObligacionFiscal, Tasa, TipoImporte
INSERT @FiscalD (
OrigenModulo, OrigenModuloID, ObligacionFiscal,  Tasa, Importe)
SELECT @Modulo,      @ID,            ObligacionFiscal2, Tasa, dbo.fnFiscalImporte(TipoImporte, ISNULL(SUM(Cargo), 0.0)-ISNULL(SUM(Abono), 0.0), Tasa)
FROM ConciliacionD
WITH(NOLOCK) WHERE ID = @ID AND NULLIF(RTRIM(ObligacionFiscal2), '') IS NOT NULL
GROUP BY ObligacionFiscal2, Tasa, TipoImporte
ORDER BY ObligacionFiscal2, Tasa, TipoImporte
END
IF @CfgOmitirChAntCxp = 1
DELETE @FiscalD
FROM @FiscalD d
JOIN Mov m  WITH(NOLOCK) ON m.Empresa = @Empresa AND m.Modulo = d.OrigenModulo AND m.ID = d.OrigenModuloID
JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = m.Modulo AND mt.Mov = m.Mov
WHERE mt.Clave = 'CXP.A'
IF @CfgOmitirDepositoAntCxc = 1
DELETE @FiscalD
FROM @FiscalD d
JOIN Mov m  WITH(NOLOCK) ON m.Empresa = @Empresa AND m.Modulo = d.OrigenModulo AND m.ID = d.OrigenModuloID
JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = m.Modulo AND mt.Mov = m.Mov
WHERE mt.Clave = 'CXC.A'
IF @Modulo = 'NOM'
INSERT @FiscalD (
ObligacionFiscal,   Tasa,    Importe,        OrigenModulo, OrigenModuloID)
SELECT d.ObligacionFiscal, nc.Tasa, SUM(d.Importe), @Modulo,      @ID
FROM NominaD d
 WITH(NOLOCK) JOIN NominaConcepto nc  WITH(NOLOCK) ON nc.NominaConcepto = d.NominaConcepto
WHERE d.ID = @ID AND NULLIF(RTRIM(d.ObligacionFiscal), '') IS NOT NULL
GROUP BY d.ObligacionFiscal, nc.Tasa
ORDER BY d.ObligacionFiscal, nc.Tasa
IF @Modulo = 'DIN'
BEGIN
INSERT @FiscalD (
ObligacionFiscal,    Tasa,                    Importe,                                                                                 OrigenModulo, OrigenModuloID)
SELECT mt.ObligacionFiscal, mt.ObligacionFiscalTasa, dbo.fnFiscalImporte(mt.ObligacionFiscalTipoImporte, d.Importe, mt.ObligacionFiscalTasa), @Modulo,      @ID
FROM Dinero d
 WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = @Modulo AND mt.Mov = d.Mov
WHERE d.ID = @ID AND UPPER(mt.AfectarFiscal)='(DIRECTO)' AND NULLIF(RTRIM(mt.ObligacionFiscal), '') IS NOT NULL
IF NOT EXISTS (SELECT * FROM @FiscalD)
BEGIN
IF EXISTS(SELECT *
FROM Dinero d
 WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = @Modulo AND mt.Mov = d.Mov
WHERE d.ID = @ID AND UPPER(mt.AfectarFiscal) = @AfectarFiscal AND mt.Clave IN ('DIN.AB','DIN.CB'))
BEGIN
IF @MovTipo = 'DIN.AB'
INSERT @FiscalD (
ObligacionFiscal,    Tasa,                    Importe,                                                                                 OrigenModulo, OrigenModuloID)
SELECT mt.ObligacionFiscal, mt.ObligacionFiscalTasa, dbo.fnFiscalImporte(mt.ObligacionFiscalTipoImporte, d.Importe, mt.ObligacionFiscalTasa), @Modulo,      @ID
FROM Dinero d
 WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = @Modulo AND mt.Mov = d.Mov
WHERE d.ID = @ID AND UPPER(mt.AfectarFiscal) = @AfectarFiscal AND mt.Clave = 'DIN.AB'
ELSE
INSERT @FiscalD (
ObligacionFiscal,    Tasa,                    Importe,                                                                                 OrigenModulo, OrigenModuloID)
SELECT mt.ObligacionFiscal, mt.ObligacionFiscalTasa, dbo.fnFiscalImporte(mt.ObligacionFiscalTipoImporte, d.Importe, mt.ObligacionFiscalTasa), @Modulo,      @ID
FROM Dinero d
 WITH(NOLOCK) JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = @Modulo AND mt.Mov = d.Mov
WHERE d.ID = @ID AND UPPER(mt.AfectarFiscal) = @AfectarFiscal AND mt.Clave = 'DIN.CB'
END
END
END
/*    DECLARE crTempOrigen CURSOR LOCAL FOR
SELECT DISTINCT OrigenModuloID, OrigenModulo, ObligacionFiscal
FROM @FiscalD
WHERE OrigenModuloID IS NOT NULL AND OrigenModulo IS NOT NULL AND ObligacionFiscal IS NOT NULL
OPEN crTempOrigen
FETCH NEXT FROM crTempOrigen  INTO @OrigenModuloID, @OrigenModulo, @ObligacionFiscal
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF EXISTS(SELECT *
FROM FiscalD d
 WITH(NOLOCK) JOIN Fiscal e  WITH(NOLOCK) ON e.ID = d.ID AND e.Empresa = @Empresa AND e.Estatus IN ('CONCLUIDO', 'PENDIENTE')
WHERE d.OrigenModuloID = @OrigenModuloID AND d.OrigenModulo = @OrigenModulo AND d.ObligacionFiscal = @ObligacionFiscal)
DELETE @FiscalD
WHERE OrigenModuloID = @OrigenModuloID AND OrigenModulo = @OrigenModulo AND ObligacionFiscal = @ObligacionFiscal
END
FETCH NEXT FROM crTempOrigen  INTO @OrigenModuloID, @OrigenModulo, @ObligacionFiscal
END
CLOSE crTempOrigen
DEALLOCATE crTempOrigen*/
UPDATE @FiscalD 
SET Importe = ABS(Importe)*ISNULL(dbo.fnFactorFiscal(mt.FactorFiscalEsp,mt.FactorFiscal,mt.Factor),1)*CASE WHEN @AfectarFiscal = 'Conciliacion' AND d.OrigenModulo IN ('COMS', 'GAS', 'CXP', 'NOM')  THEN -1.0 ELSE 1.0 END, 
OtrosImpuestos = OtrosImpuestos*dbo.fnFactorFiscal(mt.FactorFiscalEsp,mt.FactorFiscal,mt.Factor)*CASE WHEN @AfectarFiscal = 'Conciliacion' AND d.OrigenModulo IN ('COMS', 'GAS', 'CXP', 'NOM') THEN -1.0 ELSE 1.0 END 
FROM @FiscalD d
JOIN Mov m  WITH(NOLOCK) ON m.Empresa = @Empresa AND m.Modulo = d.OrigenModulo AND m.ID = d.OrigenModuloID
JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = m.Modulo AND mt.Mov  = m.Mov
UPDATE @FiscalD
SET Importe = Importe*CASE WHEN (@AfectarFiscal = 'Conciliacion' AND mt.Clave = 'CXC.CAP' AND amt.Clave = 'DIN.CH') OR (@AfectarFiscal = 'Conciliacion' AND mt.Clave = 'CXP.CAP' AND amt.Clave = 'DIN.D') THEN -1.0 ELSE 1.0 END,
OtrosImpuestos = OtrosImpuestos*CASE WHEN (@AfectarFiscal = 'Conciliacion' AND mt.Clave = 'CXC.CAP' AND amt.Clave = 'DIN.CH') THEN -1.0 ELSE 1.0 END
FROM @FiscalD d
JOIN Mov m  WITH(NOLOCK) ON m.Empresa = @Empresa AND m.Modulo = d.OrigenModulo AND m.ID = d.OrigenModuloID
JOIN MovTipo mt  WITH(NOLOCK) ON mt.Modulo = m.Modulo AND mt.Mov  = m.Mov
JOIN Mov ma  WITH(NOLOCK) ON ma.Empresa = @Empresa AND ma.Modulo = d.AplicaModulo AND ma.ID = d.AplicaID
JOIN MovTipo amt  WITH(NOLOCK) ON amt.Modulo = ma.Modulo AND amt.Mov  = ma.Mov
IF NOT EXISTS(SELECT * FROM @FiscalD)
DELETE Fiscal WHERE ID = @FiscalID
ELSE BEGIN
SELECT @Renglon = 0.0
UPDATE @FiscalD SET @Renglon = Renglon = ISNULL(Renglon, 0.0) + @Renglon + 2048.0
SELECT @FiscalMov = CASE @AfectarFiscal
WHEN 'Emision Acumulable' THEN FiscalEmisionAcumulable
WHEN 'Endoso Acumulable'  THEN FiscalEndosoAcumulable
WHEN 'Flujo Acumulable'   THEN CASE @MovTipo WHEN 'DIN.AB' THEN FiscalFlujoAcumulable ELSE FiscalFlujoAcumulable END 
WHEN 'Emision Deducible'  THEN FiscalEmisionDeducible
WHEN 'Endoso Deducible'   THEN FiscalEndosoDeducible
WHEN 'Flujo Deducible'    THEN CASE @MovTipo WHEN 'DIN.CB' THEN FiscalFlujoDeducible ELSE FiscalFlujoDeducible END 
WHEN 'Conciliacion'       THEN FiscalFlujoAcumulable
WHEN '(Directo)'          THEN FiscalFlujoDeducible
END
FROM EmpresaCfgMov
WITH(NOLOCK) WHERE Empresa = @Empresa
INSERT Fiscal (
Sucursal,  Empresa,  Usuario,  Mov,        Moneda,  TipoCambio,  FechaEmision,  Proyecto,  UEN,  Estatus,      OrigenTipo, Origen, OrigenID)
VALUES (@Sucursal, @Empresa, @Usuario, @FiscalMov, @Moneda, @TipoCambio, @FechaEmision, @Proyecto, @UEN, 'SINAFECTAR', @Modulo,    @Mov,   @MovID)
SELECT @FiscalID = SCOPE_IDENTITY()
IF @AfectarFiscal = 'Conciliacion'
INSERT FiscalD (
ID,        Sucursal,  Renglon, ObligacionFiscal, Importe, OtrosImpuestos, Tasa, Excento, Deducible,	            OrigenModulo, OrigenModuloID, Contacto, ContactoTipo, AFArticulo, AFSerie/*, DebeFiscal, HaberFiscal*/, Tipo, Retencion1,             Retencion2,             Retencion3, TipoImpuesto)  
SELECT @FiscalID, @Sucursal, Renglon, ObligacionFiscal, Importe, OtrosImpuestos, Tasa, Excento, ISNULL(Deducible, 100), OrigenModulo, OrigenModuloID, Contacto, ContactoTipo, AFArticulo, AFSerie/*, DebeFiscal, HaberFiscal*/, Tipo, ISNULL(Retencion1,0.0), ISNULL(Retencion2,0.0), ISNULL(Retencion3,0.0), TipoImpuesto   
FROM @FiscalD
WHERE ISNULL(Importe, 0.0) > 0.0
ELSE
INSERT FiscalD (
ID,        Sucursal,  Renglon, ObligacionFiscal, Importe, OtrosImpuestos, Tasa, Excento, Deducible,		        OrigenModulo, OrigenModuloID, Contacto, ContactoTipo, AFArticulo, AFSerie/*, DebeFiscal, HaberFiscal*/, Tipo, Retencion1,             Retencion2,             Retencion3, TipoImpuesto)  
SELECT @FiscalID, @Sucursal, Renglon, ObligacionFiscal, Importe, OtrosImpuestos, Tasa, Excento, ISNULL(Deducible, 100), OrigenModulo, OrigenModuloID, Contacto, ContactoTipo, AFArticulo, AFSerie/*, DebeFiscal, HaberFiscal*/, Tipo, ISNULL(Retencion1,0.0), ISNULL(Retencion2,0.0), ISNULL(Retencion3,0.0), TipoImpuesto   
FROM @FiscalD
WHERE NULLIF(Importe, 0.0) IS NOT NULL
IF NOT EXISTS(SELECT * FROM FiscalD WITH(NOLOCK) WHERE ID = @FiscalID)
DELETE Fiscal WHERE ID = @FiscalID
ELSE BEGIN
EXEC spAfectar 'FIS', @FiscalID, 'AFECTAR', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
BEGIN
SELECT @FiscalMovID = MovID FROM Fiscal WITH(NOLOCK) WHERE ID = @FiscalID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @ID, @Mov, @MovID, 'FIS', @FiscalID, @FiscalMov, @FiscalMovID, @Ok OUTPUT
END
END
IF @AfectarFiscal = 'Conciliacion'
BEGIN
SELECT @FiscalMov = FiscalFlujoDeducible FROM EmpresaCfgMov WITH(NOLOCK) WHERE Empresa = @Empresa
INSERT Fiscal (
Sucursal,  Empresa,  Usuario,  Mov,        Moneda,  TipoCambio,  FechaEmision,  Proyecto,  UEN,  Estatus,      OrigenTipo, Origen, OrigenID)
VALUES (@Sucursal, @Empresa, @Usuario, @FiscalMov, @Moneda, @TipoCambio, @FechaEmision, @Proyecto, @UEN, 'SINAFECTAR', @Modulo,    @Mov,   @MovID)
SELECT @FiscalID = SCOPE_IDENTITY()
INSERT FiscalD (
ID,        Sucursal,  Renglon, ObligacionFiscal, Importe,  OtrosImpuestos, Tasa, Excento, Deducible,	             OrigenModulo, OrigenModuloID, Contacto, ContactoTipo, AFArticulo, AFSerie/*, DebeFiscal, HaberFiscal*/, Tipo, Retencion1,             Retencion2,             Retencion3, TipoImpuesto)  
SELECT @FiscalID, @Sucursal, Renglon, ObligacionFiscal, -Importe, OtrosImpuestos, Tasa, Excento, ISNULL(Deducible, 100), OrigenModulo, OrigenModuloID, Contacto, ContactoTipo, AFArticulo, AFSerie/*, DebeFiscal, HaberFiscal*/, Tipo, ISNULL(Retencion1,0.0), ISNULL(Retencion2,0.0), ISNULL(Retencion3,0.0), TipoImpuesto   
FROM @FiscalD
WHERE ISNULL(Importe, 0.0) < 0.0
IF NOT EXISTS(SELECT * FROM FiscalD WITH(NOLOCK) WHERE ID = @FiscalID)
DELETE Fiscal WHERE ID = @FiscalID
ELSE BEGIN
EXEC spAfectar 'FIS', @FiscalID, 'AFECTAR', @EnSilencio = 1, @Conexion = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
IF @Ok IS NULL OR @Ok BETWEEN 80030 AND 81000
BEGIN
SELECT @FiscalMovID = MovID FROM Fiscal WITH(NOLOCK) WHERE ID = @FiscalID
EXEC spMovFlujo @Sucursal, 'AFECTAR', @Empresa, @Modulo, @ID, @Mov, @MovID, 'FIS', @FiscalID, @FiscalMov, @FiscalMovID, @Ok OUTPUT
END
END
END
END
END
RETURN
END

