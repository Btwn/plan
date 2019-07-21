SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spNetEntregaDocsPersonal
@Estatus		AS VARCHAR(20),
@ListDocs		AS VARCHAR(MAX),
@ListPersonal	AS VARCHAR(MAX)
AS
BEGIN
SET NOCOUNT ON
DECLARE @Ok				AS INT,
@OkRef			AS varchar(MAX),
@Archivos	AS VARCHAR(MAX)
IF @Estatus = 'Entregaron'
BEGIN
SELECT DISTINCT
Personal.Personal,
Personal.ApellidoPaterno,
Personal.ApellidoMaterno,
Personal.Nombre,
Personal.Tipo
FROM Personal
LEFT OUTER JOIN CtaSituacion ON 'RH'=CtaSituacion.Rama AND Personal.Situacion=CtaSituacion.Situacion
LEFT OUTER JOIN CtaDinero CtaDineroDestino ON Personal.CtaDinero=CtaDineroDestino.CtaDinero
LEFT OUTER JOIN Prov ON Personal.Afore=Prov.Proveedor
LEFT OUTER JOIN Personal PersonalLista ON Personal.ReportaA=PersonalLista.Personal
LEFT OUTER JOIN Sucursal ON Personal.SucursalTrabajo=Sucursal.Sucursal
LEFT OUTER JOIN CentroCostos ON Personal.CentroCostos=CentroCostos.CentroCostos
LEFT OUTER JOIN MinimosProfesionales ON Personal.MinimoProfesional=MinimosProfesionales.Numero
LEFT OUTER JOIN Vehiculo ON Personal.Vehiculo=Vehiculo.Vehiculo
LEFT OUTER JOIN Departamento ON Personal.Departamento=Departamento.Departamento
LEFT OUTER JOIN Puesto ON Personal.Puesto=Puesto.Puesto
LEFT OUTER JOIN PersonalCat ON Personal.Categoria=PersonalCat.Categoria
LEFT OUTER JOIN PersonalGrupo ON Personal.Grupo=PersonalGrupo.Grupo
LEFT OUTER JOIN UEN ON Personal.UEN=UEN.UEN
LEFT OUTER JOIN Personal PersonalDestino ON Personal.Reclutador=PersonalDestino.Personal
LEFT OUTER JOIN Personal PersonalOrigen ON Personal.RecomendadoPor=PersonalOrigen.Personal
LEFT OUTER JOIN Cta ON Personal.Cuenta=Cta.Cuenta
LEFT OUTER JOIN Cta CtaRetencion ON Personal.CuentaRetencion=CtaRetencion.Cuenta
LEFT OUTER JOIN Cte ON Personal.Cliente=Cte.Cliente
LEFT OUTER JOIN Plaza ON Personal.Plaza=Plaza.Plaza
LEFT OUTER JOIN ProyectoDEnFirme ON Personal.Proyecto=ProyectoDEnFirme.Proyecto AND Personal.Actividad=ProyectoDEnFirme.Actividad
LEFT OUTER JOIN Empresa ON Personal.Empresa=Empresa.Empresa
WHERE Personal.Empresa = 'SHMEX' AND NOT Personal.Estatus = 'BAJA'
AND Personal.Personal IN (
SELECT Cuenta
FROM DocCta WHERE Rama = 'RH'
AND Documento IN (SELECT * FROM dbo.splitstring(@ListDocs))
AND Cuenta IN (SELECT * FROM dbo.splitstring(@ListPersonal))
)
ORDER BY Personal.ApellidoPaterno, Personal.ApellidoMaterno, Personal.Nombre
END
ELSE
BEGIN
DECLARE @TablaPersonal TABLE (
Personal VARCHAR(10),
ApellidoPaterno VARCHAR(30),
ApellidoMaterno VARCHAR(30),
Nombre VARCHAR(30),
Tipo VARCHAR(20)
)
INSERT INTO @TablaPersonal
SELECT DISTINCT
Personal.Personal,
Personal.ApellidoPaterno,
Personal.ApellidoMaterno,
Personal.Nombre,
Personal.Tipo
FROM Personal
LEFT OUTER JOIN CtaSituacion ON 'RH'=CtaSituacion.Rama AND Personal.Situacion=CtaSituacion.Situacion
LEFT OUTER JOIN CtaDinero CtaDineroDestino ON Personal.CtaDinero=CtaDineroDestino.CtaDinero
LEFT OUTER JOIN Prov ON Personal.Afore=Prov.Proveedor
LEFT OUTER JOIN Personal PersonalLista ON Personal.ReportaA=PersonalLista.Personal
LEFT OUTER JOIN Sucursal ON Personal.SucursalTrabajo=Sucursal.Sucursal
LEFT OUTER JOIN CentroCostos ON Personal.CentroCostos=CentroCostos.CentroCostos
LEFT OUTER JOIN MinimosProfesionales ON Personal.MinimoProfesional=MinimosProfesionales.Numero
LEFT OUTER JOIN Vehiculo ON Personal.Vehiculo=Vehiculo.Vehiculo
LEFT OUTER JOIN Departamento ON Personal.Departamento=Departamento.Departamento
LEFT OUTER JOIN Puesto ON Personal.Puesto=Puesto.Puesto
LEFT OUTER JOIN PersonalCat ON Personal.Categoria=PersonalCat.Categoria
LEFT OUTER JOIN PersonalGrupo ON Personal.Grupo=PersonalGrupo.Grupo
LEFT OUTER JOIN UEN ON Personal.UEN=UEN.UEN
LEFT OUTER JOIN Personal PersonalDestino ON Personal.Reclutador=PersonalDestino.Personal
LEFT OUTER JOIN Personal PersonalOrigen ON Personal.RecomendadoPor=PersonalOrigen.Personal
LEFT OUTER JOIN Cta ON Personal.Cuenta=Cta.Cuenta
LEFT OUTER JOIN Cta CtaRetencion ON Personal.CuentaRetencion=CtaRetencion.Cuenta
LEFT OUTER JOIN Cte ON Personal.Cliente=Cte.Cliente
LEFT OUTER JOIN Plaza ON Personal.Plaza=Plaza.Plaza
LEFT OUTER JOIN ProyectoDEnFirme ON Personal.Proyecto=ProyectoDEnFirme.Proyecto AND Personal.Actividad=ProyectoDEnFirme.Actividad
LEFT OUTER JOIN Empresa ON Personal.Empresa=Empresa.Empresa
WHERE Personal.Empresa = 'SHMEX' AND NOT Personal.Estatus = 'BAJA'
AND Personal.Personal IN (
SELECT * FROM dbo.splitstring(@ListPersonal)
)
ORDER BY Personal.ApellidoPaterno, Personal.ApellidoMaterno, Personal.Nombre
SELECT * FROM  @TablaPersonal
WHERE Personal NOT IN (
SELECT DISTINCT  DC.Cuenta
FROM  DocRama DR LEFT OUTER JOIN DocCta DC ON DR.Documento = DC.Documento
WHERE DC.Documento IN (SELECT * FROM dbo.splitstring(@ListDocs))
)
END
SET NOCOUNT OFF
END

