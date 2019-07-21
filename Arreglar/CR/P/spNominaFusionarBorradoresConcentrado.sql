SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spNominaFusionarBorradoresConcentrado
@Estacion		int

AS BEGIN
DECLARE
@ID		int,
@Renglon	float
SELECT @Renglon = 0.0
SELECT @ID = MIN(ID) FROM ListaID WHERE Estacion = @Estacion
CREATE TABLE #Borrador (
ID			int		NOT NULL IDENTITY(1, 1) PRIMARY KEY,
Renglon			float		NULL,
Modulo			char(5)		COLLATE Database_Default NULL,
Personal		char(10)	COLLATE Database_Default NULL,
Concepto		varchar(50)	COLLATE Database_Default NULL,
Cuenta			char(10)	COLLATE Database_Default NULL,
Referencia 		varchar(50) 	COLLATE Database_Default NULL,
Beneficiario		varchar(100) 	COLLATE Database_Default NULL,
FormaPago 		varchar(50) 	COLLATE Database_Default NULL,
Movimiento		varchar(20)	COLLATE Database_Default NULL,
ContUso			varchar(20)	COLLATE Database_Default NULL,
CuentaContable		varchar(20)	COLLATE Database_Default NULL,
Importe			money		NULL,
Cantidad		float		NULL)
SELECT "Renglon" = MIN(Renglon), Concepto
INTO #Conceptos
FROM NominaD
WHERE ID IN (SELECT ID FROM ListaID WHERE Estacion = @Estacion)
GROUP BY Concepto
ORDER BY Concepto
INSERT #Borrador
(Modulo,  Personal,   Concepto,   Cuenta,   Referencia,   Beneficiario,   FormaPago,   Movimiento,   ContUso,   CuentaContable,   Importe,                    Cantidad)
SELECT d.Modulo, d.Personal, d.Concepto, d.Cuenta, d.Referencia, d.Beneficiario, d.FormaPago, d.Movimiento, d.ContUso, d.CuentaContable, "Importe" = SUM(d.Importe), "Cantidad" = SUM(d.Cantidad)
FROM NominaD d
LEFT OUTER JOIN #Conceptos c ON c.Concepto = d.Concepto
WHERE d.ID IN (SELECT ID FROM ListaID WHERE Estacion = @Estacion)
GROUP BY d.Modulo,      d.Personal, c.Renglon, d.Concepto, d.Cuenta, d.Referencia, d.Beneficiario, d.FormaPago, d.Movimiento, d.ContUso, d.CuentaContable
ORDER BY d.Modulo DESC, d.Personal, c.Renglon, d.Concepto, d.Cuenta, d.Referencia, d.Beneficiario, d.FormaPago, d.Movimiento, d.ContUso, d.CuentaContable
UPDATE #Borrador SET @Renglon = Renglon = ISNULL(Renglon, 0) + @Renglon + 2048.0
DELETE NominaD WHERE ID = @ID
INSERT NominaD (ID,  Renglon, Modulo, Personal, Concepto, Cuenta, Referencia, Beneficiario, FormaPago, Movimiento, ContUso, CuentaContable, Importe, Cantidad)
SELECT @ID, Renglon, Modulo, Personal, Concepto, Cuenta, Referencia, Beneficiario, FormaPago, Movimiento, ContUso, CuentaContable, Importe, Cantidad
FROM #Borrador
DELETE NominaD WHERE ID IN (SELECT ID FROM ListaID WHERE Estacion = @Estacion AND ID <> @ID)
DELETE Nomina  WHERE ID IN (SELECT ID FROM ListaID WHERE Estacion = @Estacion AND ID <> @ID)
SELECT CONVERT(varchar, COUNT(*))+ ' Movimientos Fusionados.' FROM ListaID WHERE Estacion = @Estacion
RETURN
END

