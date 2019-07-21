SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebRecibosNomina
@Personal  Char(10),
@FechaD   Datetime,
@FechaA   Datetime,
@Estatus	 tinyint = 0
AS BEGIN
DECLARE  @Id                  Int,
@Renglon             Float,
@MovId               Varchar(20),
@Empresa             Varchar(100),
@RFC                 Varchar(20),
@RegistroPatronal    Varchar(20),
@FechaDe             Datetime,
@FechaAA             Datetime,
@TipoNomina          Char(20),
@Concepto            Varchar(50),
@Referencia          Varchar(50),
@Cantidad            Money,
@Percepcion          Money,
@Deduccion           Money,
@NombreAnexoXML		Varchar(255),
@NombreAnexoPDF		Varchar(255),
@VioDetalle			Bit,
@FechaDetalle		Datetime,
@Acuerdo				Bit,
@FechaAcuerdo		Datetime,
@ClaveEmpresa		varchar(5)
CREATE TABLE #ConcNom (
Id                  Int NULL,
Renglon             Float NULL,
MovId               Varchar(20) NULL,
Empresa             Varchar(100) NULL,
RFC                 Varchar(20) NULL,
RegistroPatronal    Varchar(20) NULL,
FechaD              Datetime NULL,
FechaA              Datetime NULL,
TipoNomina          Char(20) NULL,
Concepto            Varchar(50) NULL,
Referencia          Varchar(50) NULL,
Cantidad            Money NULL,
Percepcion          Money NULL,
Deduccion           Money NULL,
NombreAnexoXML	  Varchar(255) NULL,
NombreAnexoPDF	  Varchar(255) NULL,
VioDetalle		  Bit NULL,
FechaDetalle		  Datetime NULL,
Acuerdo			  Bit NULL,
FechaAcuerdo		  Datetime NULL,
ClaveEmpresa        varchar(5) NULL
)
SET NOCOUNT ON
DECLARE curConcNom CURSOR FAST_FORWARD FOR
SELECT Nomina.Id,
NominaD.Renglon,
Nomina.MovId,
Empresa = Empresa.Nombre,
RFCEmpresa = ISNULL(RFC, ''),
RegistroPatronal = ISNULL(RegistroPatronal, ''),
Nomina.FechaD,
Nomina.FechaA,
TipoNomina = RTRIM(Nomina.Mov),
NominaD.Concepto,
Referencia = ISNULL(NominaD.Referencia, ''),
Cantidad = ISNULL(NominaD.Cantidad, 0),
Percepcion = CASE WHEN NominaD.Movimiento = 'Percepcion' THEN Nominad.Importe ELSE 0 END,
Deduccion = CASE WHEN NominaD.Movimiento = 'Deduccion'  THEN Nominad.Importe ELSE 0 END,
Nomina.Empresa
FROM Nomina
JOIN NominaD ON NominaD.Id = Nomina.Id
AND NominaD.Personal = @Personal
JOIN Empresa ON Empresa.Empresa = Nomina.Empresa
WHERE Nomina.FechaA Between @FechaD AND @FechaA
AND NominaD.Movimiento IN ('Percepcion', 'Deduccion')
AND Nomina.Estatus = 'CONCLUIDO'
AND NominaD.Modulo IN ('NOM', 'CXC', 'CXP' )
AND Nomina.Mov IN (SELECT Mov FROM MovTipo WHERE Modulo = 'NOM' AND RTRIM(UPPER(Clave)) IN ('NOM.N')) /*, 'NOM.NE', 'NOM.NC', 'COMS.B', 'COMS.CC', 'COMS.FL', 'COMS.CP', 'COMS.OP', 'COMS.O', 'COMS.C', 'COMS.DC', 'COMS.D','COMS.DG', 'COMS.F','COMS.EG', 'COMS.EI', 'COMS.EST', 'COMS.CA', 'COMS.GX', 'COMS.IG', 'COMS.R', 'COMS.OI', 'COMS.OD', 'COMS.OG', 'COMS.PR', 'COMS.R', 'COMS.F', 'COMS.D')) */
ORDER  BY Nomina.FechaD ASC, Nomina.Mov ASC, Percepcion DESC
OPEN curConcNom
FETCH NEXT FROM curConcNom INTO @Id, @Renglon, @MovId, @Empresa, @RFC, @RegistroPatronal, @FechaDe, @FechaAA, @TipoNomina, @Concepto, @Referencia, @Cantidad, @Percepcion, @Deduccion, @ClaveEmpresa
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @VioDetalle = NULL, @FechaDetalle = NULL, @Acuerdo = NULL, @FechaAcuerdo = NULL
SELECT @VioDetalle = VioDetalle,  @FechaDetalle = FechaDetalle, @Acuerdo = Acuerdo, @FechaAcuerdo = FechaAcuerdo, @NombreAnexoXML= NULL, @NombreAnexoPDF = NULL
FROM NominaConsulta WHERE ID = @Id AND Personal = @Personal AND Empresa = @ClaveEmpresa AND MovID = @MovId
UPDATE #ConcNom
SET Cantidad = Cantidad + @Cantidad, Percepcion = Percepcion + @Percepcion, Deduccion = Deduccion + @Deduccion
WHERE Concepto = @Concepto AND FechaD = @FechaDe AND FechaA = @FechaAA 
IF @@Rowcount = 0
BEGIN
SELECT @NombreAnexoXML = Nombre FROM AnexoMov WHERE Rama = 'NOM' AND id = @Id AND Nombre Like '%' + ltrim(rtrim(@Personal)) + '%.xml%'
SELECT @NombreAnexoPDF = Nombre FROM AnexoMov WHERE Rama = 'NOM' AND id = @Id AND Nombre Like '%' + ltrim(rtrim(@Personal)) + '%.pdf%'
INSERT INTO #ConcNom VALUES(@Id, @Renglon, @MovId, @Empresa, @RFC, @RegistroPatronal, @FechaDe, @FechaAA, @TipoNomina, @Concepto, @Referencia, @Cantidad, @Percepcion, @Deduccion, @NombreAnexoXML, @NombreAnexoPDF, @VioDetalle, @FechaDetalle, @Acuerdo, @FechaAcuerdo, @ClaveEmpresa)
END
FETCH NEXT FROM curConcNom INTO @Id, @Renglon, @MovId, @Empresa, @RFC, @RegistroPatronal, @FechaDe, @FechaAA, @TipoNomina, @Concepto, @Referencia, @Cantidad, @Percepcion, @Deduccion, @ClaveEmpresa
END
CLOSE curConcNom
DEALLOCATE curConcNom
SELECT Id,
Renglon,
MovId,
Empresa = RTRIM(Empresa),
RFC = RTRIM(RFC),
RegistroPatronal = RTRIM(RegistroPatronal),
FechaD = dbo.fnFormatDateTime(FechaD, 'YYYY-MM-DD'),
FechaA = dbo.fnFormatDateTime(FechaA, 'YYYY-MM-DD'),
TipoNomina = RTRIM(TipoNomina),
Concepto = RTRIM(Concepto),
Referencia  = RTRIM(Referencia),
Cantidad = ROUND(Cantidad, 0),
Percepcion = ROUND(Percepcion, 2),
Deduccion = ROUND(Deduccion, 2),
replace(NombreAnexoXML, ' ', '') NombreAnexoXML,
replace(NombreAnexoPDF, ' ', '') NombreAnexoPDF,
ISNULL(VioDetalle,0) VioDetalle,
FechaDetalle,
ISNULL(Acuerdo,0) Acuerdo,
FechaAcuerdo,
ClaveEmpresa
FROM #ConcNom
WHERE (Cantidad <> 0 OR Percepcion <> 0 OR Deduccion <> 0)
AND ISNULL(VioDetalle,0) = case
when @Estatus = 0 then ISNULL(VioDetalle,0)
when @Estatus = 1 then 0
when @Estatus = 2 then 1
when @Estatus = 3 then 1
end
AND ISNULL(Acuerdo,0) = case
when @Estatus = 0 then ISNULL(Acuerdo,0)
when @Estatus = 1 then 0
when @Estatus = 2 then 0
when @Estatus = 3 then 1
end
SET NOCOUNT OFF
END

