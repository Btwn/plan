SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW CteAnexoMov

AS
SELECT
a.Rama,
a.ID,
a.Nombre,
a.Direccion,
a.Icono,
a.Tipo,
a.Orden,
a.Comentario,
m.Mov,
m.MovID,
m.Estatus,
m.Situacion,
m.SituacionFecha,
m.SituacionUsuario,
m.SituacionNota,
m.FechaEmision,
m.Empresa,
m.Sucursal,
m.Cliente,
m.Referencia,
m.Concepto,
m.UEN,
m.Proyecto,
m.Usuario
FROM CteMov m
JOIN AnexoMov a ON m.ID = a.ID AND m.Modulo = a.Rama

