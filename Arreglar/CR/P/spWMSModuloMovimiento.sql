SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWMSModuloMovimiento
@Modulo		varchar(5),
@Mov		varchar(20),
@Tipo		varchar(10)

AS BEGIN
IF @Modulo = 'WMS' SELECT @Modulo = 'TMA'
IF @Mov = ''
BEGIN
IF @Modulo = 'INV'
BEGIN
IF @Tipo = 'Acomodo'
SELECT Mov FROM MovTipo WHERE Modulo = @Modulo AND Clave IN ('INV.DTI' ,'INV.TMA' ,'INV.E', 'INV.EI', 'INV.T', 'INV.TIS') ORDER BY Orden 
IF @Tipo = 'Surtido'
SELECT Mov FROM MovTipo WHERE Modulo = @Modulo AND Clave IN ('INV.OT', 'INV.OI')
UNION
SELECT Mov FROM MovTipo WHERE Modulo = @Modulo AND Clave = 'INV.SOL' AND ISNULL(SubClave,'') <> 'INV.ENT'
IF @Tipo = 'Destino'
SELECT Mov FROM MovTipo WHERE Modulo = @Modulo AND Clave = 'INV.S' AND Subclave = 'INV.SCHEP' OR Modulo = @Modulo ORDER BY Orden
END
ELSE
IF @Modulo = 'COMS'
BEGIN
IF @Tipo = 'Acomodo'
SELECT Mov FROM MovTipo WHERE Modulo = @Modulo AND Clave IN ('COMS.B', 'COMS.FL', 'COMS.F', 'COMS.EG', 'COMS.EI') ORDER BY Orden
IF @Tipo = 'Surtido'
SELECT Mov FROM MovTipo WHERE Modulo = @Modulo AND Clave IN ('COMS.OD') ORDER BY Orden
END
ELSE
IF @Modulo = 'VTAS'
BEGIN
IF @Tipo = 'Acomodo'
SELECT Mov FROM MovTipo WHERE Modulo = @Modulo AND Clave IN ('VTAS.D') ORDER BY Orden
IF @Tipo = 'Surtido'
SELECT Mov FROM MovTipo WHERE Modulo = @Modulo AND Clave IN ('VTAS.P') ORDER BY Orden
END
ELSE
IF @Modulo = 'TMA'
BEGIN
IF @Tipo = 'Acomodo'
SELECT Mov FROM MovTipo WHERE Modulo = @Modulo AND Clave IN ('TMA.SADO', 'TMA.SRADO') ORDER BY Orden
IF @Tipo = 'Surtido'
SELECT Mov FROM MovTipo WHERE Modulo = @Modulo AND Clave IN ('TMA.SADO', 'TMA.SRADO') ORDER BY Orden
END
IF @Modulo = 'PROD'
BEGIN
IF @Tipo = 'Surtido'
SELECT Mov FROM MovTipo WHERE Modulo = @Modulo AND Clave IN ('PROD.CO') ORDER BY Orden
END
END
ELSE
IF @Mov IS NOT NULL
IF (SELECT Clave FROM MovTipo WHERE Modulo = @Modulo AND Mov = @Mov) IN('COMS.O', 'COMS.OD', 'INV.OT', 'INV.OI', 'VTAS.P' ,'INV.SOL')
SELECT 'PENDIENTE' ELSE SELECT 'CONCLUIDO'
ELSE
SELECT ''
RETURN
END

