SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovReg
@Modulo			char(5),
@ID			int,
@UnicamenteActualizar	bit = 0

AS BEGIN
DECLARE
@Existe	bit
SELECT @Existe = 0
IF EXISTS(SELECT * FROM MovReg WHERE Modulo = @Modulo AND ID = @ID)
SELECT @Existe = 1
IF @Existe = 0 AND @UnicamenteActualizar = 0
INSERT MovReg (
Modulo,  ID, Mov, MovID, Estatus, Sucursal, UEN, FechaEmision, Empresa, CtoTipo, Contacto, EnviarA, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Proyecto, Concepto, Referencia, Usuario, MovTipo, Ejercicio, Periodo, FechaCancelacion, Clase, SubClase, Causa, FormaEnvio, Condicion, ZonaImpuesto, CtaDinero, Cajero, Moneda, TipoCambio, Deudor, Acreedor, Personal, Agente)
SELECT Modulo,  ID, Mov, MovID, Estatus, Sucursal, UEN, FechaEmision, Empresa, CtoTipo, Contacto, EnviarA, Situacion, SituacionFecha, SituacionUsuario, SituacionNota, Proyecto, Concepto, Referencia, Usuario, MovTipo, Ejercicio, Periodo, FechaCancelacion, Clase, SubClase, Causa, FormaEnvio, Condicion, ZonaImpuesto, CtaDinero, Cajero, Moneda, TipoCambio, Deudor, Acreedor, Personal, Agente
FROM dbo.fnMovReg(@Modulo, @ID)
IF @Existe = 1 AND @UnicamenteActualizar = 1
UPDATE MovReg
SET Mov = r.Mov, MovID = r.MovID, Estatus = r.Estatus, Sucursal = r.Sucursal, UEN = r.UEN, FechaEmision = r.FechaEmision, Empresa = r.Empresa,
CtoTipo = r.CtoTipo, Contacto = r.Contacto, EnviarA = r.EnviarA, Situacion = r.Situacion, SituacionFecha = r.SituacionFecha, SituacionUsuario = r.SituacionUsuario, SituacionNota = r.SituacionNota, Proyecto = r.Proyecto,
Concepto = r.Concepto, Referencia = r.Referencia, Usuario = r.Usuario, MovTipo = r.MovTipo, Ejercicio = r.Ejercicio, Periodo = r.Periodo, FechaCancelacion = r.FechaCancelacion,
Clase = r.Clase, SubClase = r.SubClase, Causa = r.Causa, FormaEnvio = r.FormaEnvio, Condicion = r.Condicion, ZonaImpuesto = r.ZonaImpuesto, CtaDinero = r.CtaDinero,
Cajero = r.Cajero, Moneda = r.Moneda, TipoCambio = r.TipoCambio, Deudor = r.Deudor, Acreedor = r.Acreedor, Personal = r.Personal, Agente = r.Agente
FROM dbo.fnMovReg(@Modulo, @ID) r, MovReg m
WHERE m.Modulo = @Modulo AND m.ID = @ID
UPDATE Mov
SET Concepto = r.Concepto, Proyecto = r.Proyecto, Referencia = r.Referencia
FROM dbo.fnMovReg(@Modulo, @ID) r, Mov m
WHERE m.Empresa = r.Empresa AND m.Modulo = @Modulo AND m.ID = @ID
RETURN
END

