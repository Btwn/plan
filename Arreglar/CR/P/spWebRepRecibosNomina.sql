SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebRepRecibosNomina
@Personal	varchar(10) = NULL,
@FechaD		datetime,
@FechaA		datetime,
@Estatus     varchar(15),
@PersonalVioDetalle	varchar(2) = NULL,
@PersonalAcuerdo     varchar(2) = NULL
AS BEGIN
DECLARE
@VioDetalle bit,
@Acuerdo    bit
IF ISNULL(@Personal, '') IN ('', '(Todos)', 'Todos', '(Todas)', 'Todas', 'NULL') SELECT @Personal = NULL
IF ISNULL(@Estatus, '') IN ('', '(Todos)', 'Todos', '(Todas)', 'Todas', 'NULL') SELECT @Estatus = NULL
IF ISNULL(UPPER(@PersonalVioDetalle),'') = 'SI' SELECT @VioDetalle = 1 ELSE SELECT @VioDetalle = 0
IF ISNULL(UPPER(@PersonalAcuerdo),'') = 'SI' SELECT @Acuerdo = 1 ELSE SELECT @Acuerdo = 0
SELECT Nomina.ID,
Nomina.Mov,
Nomina.MovID,
Empresa.Nombre EmpresaNombre,
RFCEmpresa = ISNULL(RFC,''),
RegistroPatronal = ISNULL(RegistroPatronal, ''),
Nomina.FechaD,
Nomina.FechaA,
TipoNomina = RTRIM(Nomina.Mov),
NominaD.Concepto,
Referencia = ISNULL(NominaD.Referencia, ''),
Cantidad = ISNULL(NominaD.Cantidad, 0),
Percepcion = CASE WHEN NominaD.Movimiento = 'Percepcion' THEN NominaD.Importe ELSE 0 END,
Deduccion = CASE WHEN NominaD.Movimiento = 'Deduccion'  THEN NominaD.Importe ELSE 0 END,
Nomina.Empresa,
ISNULL(nc.VioDetalle,0) VioDetalle,
nc.FechaDetalle,
ISNULL(nc.Acuerdo,0) Acuerdo,
nc.FechaAcuerdo,
NominaD.Personal,
p.Nombre + ' ' + p.ApellidoPaterno + ' ' + ISNULL(p.ApellidoMaterno, '') NombreCompleto,
p.Estatus
FROM Nomina
JOIN NominaD ON NominaD.ID = Nomina.ID AND NominaD.Personal = ISNULL(@Personal, NominaD.Personal)
JOIN Empresa ON Empresa.Empresa = Nomina.Empresa
JOIN Personal p ON NominaD.Personal = p.Personal
LEFT JOIN NominaConsulta nc ON Nomina.ID = nc.ID AND NominaD.Personal = nc.Personal AND Nomina.Empresa = nc.Empresa AND Nomina.MovID = nc.MovID
WHERE Nomina.FechaA Between @FechaD AND @FechaA
AND NominaD.Movimiento IN ('Percepcion', 'Deduccion')
AND Nomina.Estatus = 'CONCLUIDO'
AND NominaD.Modulo IN ('NOM', 'CXC', 'CXP' )
AND Nomina.Mov IN (SELECT Mov FROM MovTipo WHERE Modulo = 'NOM' AND RTRIM(UPPER(Clave)) IN ('NOM.N'))
AND ISNULL(p.Estatus,'') = ISNULL(@Estatus, ISNULL(p.Estatus,''))
AND ISNULL(nc.VioDetalle,0) = ISNULL(@VioDetalle, ISNULL(nc.VioDetalle,0))
AND ISNULL(nc.Acuerdo,0) = ISNULL(@Acuerdo, ISNULL(nc.Acuerdo,0))
ORDER BY NominaD.Personal ASC
RETURN
END

