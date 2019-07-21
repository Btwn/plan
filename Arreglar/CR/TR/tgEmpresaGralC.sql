SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgEmpresaGralC ON EmpresaGral

FOR UPDATE
AS BEGIN
DECLARE	@EmpresaI		varchar(5),
@EmpresaD		varchar(5)
IF dbo.fnEstaSincronizando() = 1 RETURN
SELECT @EmpresaI = Empresa FROM Inserted
SELECT @EmpresaD = Empresa FROM Deleted
IF UPDATE(AC)
BEGIN
IF (SELECT AC FROM Inserted) = 1
BEGIN
if not exists(select * from MovTipo WHERE Modulo = 'CXC' AND Mov = 'Documento Factoraje') INSERT MovTipo (Modulo, Orden, Mov, Clave, ConsecutivoModulo, ConsecutivoMov) VALUES ('CXC', 4000, 'Documento Factoraje', 'CXC.F',  'CXC', 'Documento Factoraje')
if not exists(select * from MovTipo WHERE Modulo = 'CXC' AND Mov = 'Prestamo Factoraje')  INSERT MovTipo (Modulo, Orden, Mov, Clave, ConsecutivoModulo, ConsecutivoMov) VALUES ('CXC', 4010, 'Prestamo Factoraje',  'CXC.F',  'CXC', 'Prestamo Factoraje')
if not exists(select * from MovTipo WHERE Modulo = 'CXC' AND Mov = 'Disposicion')         INSERT MovTipo (Modulo, Orden, Mov, Clave, ConsecutivoModulo, ConsecutivoMov) VALUES ('CXC', 4020, 'Disposicion',         'CXC.CAP','CXC', 'Disposicion')
if not exists(select * from MovTipo WHERE Modulo = 'CXC' AND Mov = 'Back to Back')        INSERT MovTipo (Modulo, Orden, Mov, Clave, ConsecutivoModulo, ConsecutivoMov) VALUES ('CXC', 4030, 'Back to Back',        'CXC.CAP','CXC', 'Back to Back')
if not exists(select * from MovTipo WHERE Modulo = 'CXP' AND Mov = 'Documento Factoraje') INSERT MovTipo (Modulo, Orden, Mov, Clave, ConsecutivoModulo, ConsecutivoMov) VALUES ('CXP', 4000, 'Documento Factoraje', 'CXP.F',  'CXP', 'Documento Factoraje')
if not exists(select * from MovTipo WHERE Modulo = 'CXP' AND Mov = 'Prestamo Factoraje')  INSERT MovTipo (Modulo, Orden, Mov, Clave, ConsecutivoModulo, ConsecutivoMov) VALUES ('CXP', 4010, 'Prestamo Factoraje',  'CXP.F',  'CXP', 'Prestamo Factoraje')
if not exists(select * from MovTipo WHERE Modulo = 'CXP' AND Mov = 'Fondeo')              INSERT MovTipo (Modulo, Orden, Mov, Clave, ConsecutivoModulo, ConsecutivoMov) VALUES ('CXP', 4020, 'Fondeo',              'CXP.CAP','CXP', 'Fondeo')
if not exists(select * from MovTipo WHERE Modulo = 'CXP' AND Mov = 'Fondeo Anticipado')   INSERT MovTipo (Modulo, Orden, Mov, Clave, ConsecutivoModulo, ConsecutivoMov) VALUES ('CXP', 4040, 'Fondeo Anticipado',   'CXP.F',  'CXP', 'Fondeo Anticipado')
END
END
IF UPDATE(MAF)
BEGIN
IF (SELECT MAF FROM Inserted) = 1 
BEGIN
IF NOT EXISTS(SELECT * FROM MovClave WHERE Clave = 'MAF.SI') INSERT MovClave (Modulo, NombreOmision, SubClaveDe, Clave) values ('GES',	'Solicitud Inspeccion',		'GES.SRES',	'MAF.SI')
IF NOT EXISTS(SELECT * FROM MovClave WHERE Clave = 'MAF.I')  INSERT MovClave (Modulo, NombreOmision, SubClaveDe, Clave) values ('GES',	'Inspeccion',			'GES.RES',	'MAF.I')
IF NOT EXISTS(SELECT * FROM MovClave WHERE Clave = 'MAF.S')  INSERT MovClave (Modulo, NombreOmision, SubClaveDe, Clave) values ('VTAS',	'Servicio AF',			'VTAS.S',	'MAF.S')
IF NOT EXISTS(SELECT * FROM movtipo WHERE modulo = 'GES' AND  Mov = 'Solicitud Inspeccion') INSERT MovTipo (Modulo, Orden, Mov, Clave, SubClave, ConsecutivoModulo, ConsecutivoMov) values ('GES',	970,	'Solicitud Inspeccion',		'GES.SRES',	'MAF.SI',	'GES',   'Solicitud Inspeccion')
IF NOT EXISTS(SELECT * FROM movtipo WHERE modulo = 'GES' AND  Mov = 'Inspeccion')           INSERT MovTipo (Modulo, Orden, Mov, Clave, SubClave, ConsecutivoModulo, ConsecutivoMov) values ('GES',	980,	'Inspeccion',			'GES.RES',      'MAF.I',	'GES',   'Inspeccion')
IF NOT EXISTS(SELECT * FROM movtipo WHERE modulo = 'VTAS' AND Mov = 'Servicio AF')          INSERT MovTipo (Modulo, Orden, Mov, Clave, SubClave, ConsecutivoModulo, ConsecutivoMov) values ('VTAS',	990,	'Servicio AF',			'VTAS.S',       'MAF.S',	'VTAS',  'Servicio AF')
IF NOT EXISTS(SELECT * FROM CfgMovFlujo WHERE modulo = 'GES' AND Orden = 1 AND OMov = 'Solicitud Inspeccion' AND DMov = 'Inspeccion') INSERT CfgMovFlujo (Modulo, Orden, OMov, DMov, Nombre) VALUES ('GES', 1, 'Solicitud Inspeccion',	'Inspeccion',			'Aceptar Inspeccion')
END
IF (SELECT MAF FROM Inserted) = 0 
BEGIN
IF NOT EXISTS(SELECT * FROM Gestion g JOIN MovTipo mt ON mt.Modulo = 'GES' AND mt.Mov = g.Mov WHERE mt.SubClave IN ('MAF.SI','MAF.I')) AND
NOT EXISTS(SELECT * FROM Venta v JOIN MovTipo mt ON mt.Modulo = 'VTAS' AND mt.Mov = v.Mov WHERE mt.SubClave IN ('MAF.S'))
BEGIN
IF EXISTS(SELECT * FROM MovClave WHERE Clave = 'MAF.SI') DELETE FROM MovClave WHERE Clave = 'MAF.SI'
IF EXISTS(SELECT * FROM MovClave WHERE Clave = 'MAF.I')  DELETE FROM MovClave WHERE Clave = 'MAF.I'
IF EXISTS(SELECT * FROM MovClave WHERE Clave = 'MAF.S')  DELETE FROM MovClave WHERE Clave = 'MAF.S'
IF EXISTS(SELECT * FROM movtipo WHERE modulo = 'GES'  AND  Mov = 'Solicitud Inspeccion') DELETE FROM MovTipo WHERE Modulo = 'GES'  AND Mov = 'Solicitud Inspeccion'
IF EXISTS(SELECT * FROM movtipo WHERE modulo = 'GES'  AND  Mov = 'Inspeccion')           DELETE FROM MovTipo WHERE Modulo = 'GES'  AND Mov = 'Inspeccion'
IF EXISTS(SELECT * FROM movtipo WHERE modulo = 'VTAS' AND Mov = 'Servicio AF')           DELETE FROM MovTipo WHERE Modulo = 'VTAS' AND Mov = 'Servicio AF'
IF EXISTS(SELECT * FROM CfgMovFlujo WHERE modulo = 'GES' AND Orden = 1 AND OMov = 'Solicitud Inspeccion' AND DMov = 'Inspeccion' AND Nombre = 'Aceptar Inspeccion') DELETE FROM CfgMovFlujo WHERE modulo = 'GES' AND Orden = 1 AND OMov = 'Solicitud Inspeccion' AND DMov = 'Inspeccion' AND Nombre = 'Aceptar Inspeccion'
END
END
END
IF UPDATE(VIC)
BEGIN
IF (SELECT VIC FROM Inserted) = 1 
BEGIN
IF NOT EXISTS(SELECT 1 FROM MovClave WHERE Modulo='PACTO' AND Clave='VIC.CR')  INSERT INTO MovClave (Modulo,  Clave,      NombreOmision,    EstatusContabilizar, SubClaveDe) VALUES ('PACTO', 'VIC.CR', 'Contrato Renta', 'CONCLUIDO',         'PACTO.C')
IF NOT EXISTS(SELECT 1 FROM MovClave WHERE Modulo='PACTO' AND Clave='VIC.CV')  INSERT INTO MovClave (Modulo,  Clave,      NombreOmision,    EstatusContabilizar, SubClaveDe) VALUES ('PACTO', 'VIC.CV', 'Contrato Venta', 'CONCLUIDO',         'PACTO.C')
IF NOT EXISTS(SELECT 1 FROM MovClave WHERE Modulo='PACTO' AND Clave='VIC.CM')  INSERT INTO MovClave (Modulo,  Clave,      NombreOmision,    EstatusContabilizar, SubClaveDe) VALUES ('PACTO', 'VIC.CM', 'Contrato Compra', 'CONCLUIDO',         'PACTO.C')
IF NOT EXISTS(SELECT 1 FROM MovClave WHERE Modulo='PACTO' AND Clave='VIC.CS')  INSERT INTO MovClave (Modulo,  Clave,      NombreOmision,    EstatusContabilizar, SubClaveDe) VALUES ('PACTO', 'VIC.CS', 'Contrato Cosociedad', 'CONCLUIDO',    'PACTO.C')
IF NOT EXISTS(SELECT 1 FROM MovClave WHERE Modulo='PACTO' AND Clave='VIC.INV') INSERT INTO MovClave (Modulo,  Clave,       NombreOmision,        EstatusContabilizar, SubClaveDe) VALUES ('PACTO', 'VIC.INV', 'Contrato Inversion', 'CONCLUIDO',         'PACTO.C')
IF NOT EXISTS(SELECT 1 FROM MovClave WHERE Modulo='PACTO' AND Clave='VIC.ARR') INSERT INTO MovClave (Modulo,  Clave,      NombreOmision,    EstatusContabilizar, SubClaveDe) VALUES ('PACTO', 'VIC.ARR', 'Arrendamiento', 'CONCLUIDO',         'PACTO.C')
IF NOT EXISTS(SELECT 1 FROM MovClave WHERE Modulo='PACTO' AND Clave='VIC.O')   INSERT INTO MovClave (Modulo,  Clave,      NombreOmision,    EstatusContabilizar, SubClaveDe) VALUES ('PACTO', 'VIC.O', 'Orden Compra',    'CONCLUIDO',         'PACTO.C')
IF NOT EXISTS(SELECT 1 FROM MovClave WHERE Modulo='PACTO' AND Clave='VIC.MA')  INSERT INTO MovClave (Modulo,  Clave,      NombreOmision,    EstatusContabilizar, SubClaveDe) VALUES ('PACTO', 'VIC.MA', 'Mantenimiento',    'CONCLUIDO',       'PACTO.C')
IF NOT EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Arrendamiento' AND Modulo = 'PACTO')       INSERT INTO MovTipo (Modulo,  Mov,             Orden, Clave,     SubClave,    ConsecutivoModulo, ConsecutivoMov,  Grupo, Icono, Factor, ConsecutivoPorEmpresa, AfectarPresupuesto, ProyectoSugerir, TipoConsecutivo)            VALUES ('PACTO', 'Arrendamiento', 300,   'PACTO.C', 'VIC.ARR',   'PACTO',           'Arrendamiento', NULL,  NULL,  1,      'Si',                  '(por Omision)',    'Movimiento',    'Modulo')
IF NOT EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Contrato Compra' AND Modulo = 'PACTO')     INSERT INTO MovTipo (Modulo,  Mov,               Orden, Clave,     SubClave,   ConsecutivoModulo, ConsecutivoMov,    Grupo, Icono, Factor, ConsecutivoPorEmpresa, AfectarPresupuesto, ProyectoSugerir, TipoConsecutivo)         VALUES ('PACTO', 'Contrato Compra', 310,   'PACTO.C', 'VIC.CM',   'PACTO',           'Contrato Compra', NULL,  NULL,  1,      'Si',                  '(por Omision)',    'Movimiento',    'Modulo')
IF NOT EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Contrato Cosociedad' AND Modulo = 'PACTO') INSERT INTO MovTipo (Modulo,  Mov,                   Orden, Clave,     SubClave,   ConsecutivoModulo, ConsecutivoMov,        Grupo, Icono, Factor, ConsecutivoPorEmpresa, AfectarPresupuesto, ProyectoSugerir, TipoConsecutivo) VALUES ('PACTO', 'Contrato Cosociedad', 320,   'PACTO.C', 'VIC.CS',   'PACTO',           'Contrato Cosociedad', NULL,  NULL,  1,      'Si',                  '(por Omision)',    'Movimiento',    'Modulo')
IF NOT EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Contrato Inversion' AND Modulo = 'PACTO')  INSERT INTO MovTipo (Modulo,  Mov,                  Orden, Clave,     SubClave,    ConsecutivoModulo, ConsecutivoMov,       Grupo, Icono, Factor, ConsecutivoPorEmpresa, AfectarPresupuesto, ProyectoSugerir, TipoConsecutivo)  VALUES ('PACTO', 'Contrato Inversion', 330,   'PACTO.C', 'VIC.INV',   'PACTO',           'Contrato Inversion', NULL,  NULL,  1,      'Si',                  '(por Omision)',    'Movimiento',    'Modulo')
IF NOT EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Contrato Renta' AND Modulo = 'PACTO')      INSERT INTO MovTipo (Modulo,  Mov,              Orden, Clave,     SubClave,   ConsecutivoModulo, ConsecutivoMov,   Grupo, Icono, Factor, ConsecutivoPorEmpresa, AfectarPresupuesto, ProyectoSugerir, TipoConsecutivo)           VALUES ('PACTO', 'Contrato Renta', 340,   'PACTO.C', 'VIC.CR',   'PACTO',           'Contrato Renta', NULL,  NULL,  1,      'Si',                  '(por Omision)',    'Movimiento',    'Modulo')
IF NOT EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Contrato Venta' AND Modulo = 'PACTO')      INSERT INTO MovTipo (Modulo,  Mov,              Orden, Clave,     SubClave,   ConsecutivoModulo, ConsecutivoMov,   Grupo, Icono, Factor, ConsecutivoPorEmpresa, AfectarPresupuesto, ProyectoSugerir, TipoConsecutivo)           VALUES ('PACTO', 'Contrato Venta', 350,   'PACTO.C', 'VIC.CV',   'PACTO',           'Contrato Venta', NULL,  NULL,  1,      'Si',                  '(por Omision)',    'Movimiento',    'Modulo')
IF NOT EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Mantenimiento' AND Modulo = 'PACTO')       INSERT INTO MovTipo (Modulo,  Mov,             Orden, Clave,     SubClave,    ConsecutivoModulo, ConsecutivoMov,  Grupo, Icono, Factor, ConsecutivoPorEmpresa, AfectarPresupuesto, ProyectoSugerir, TipoConsecutivo)            VALUES ('PACTO', 'Mantenimiento', 360,   'PACTO.C', 'VIC.MA',    'PACTO',           'Mantenimiento', NULL,  NULL,  1,      'Si',                  '(por Omision)',    'Movimiento',     'Modulo')
IF NOT EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Orden Compra' AND Modulo = 'PACTO')        INSERT INTO MovTipo (Modulo,  Mov,            Orden, Clave,     SubClave,  ConsecutivoModulo, ConsecutivoMov, Grupo, Icono, Factor, ConsecutivoPorEmpresa, AfectarPresupuesto, ProyectoSugerir, TipoConsecutivo)                VALUES ('PACTO', 'Orden Compra', 370,   'PACTO.C', 'VIC.O',   'PACTO',           'Orden Compra', NULL,  NULL,  1,      'Si',                  '(por Omision)',    'Movimiento',    'Modulo')
END
IF (SELECT VIC FROM Inserted) = 0 
BEGIN
IF NOT EXISTS(SELECT * FROM Contrato p JOIN MovTipo mt ON mt.Modulo = 'PACTO' AND mt.Mov = p.Mov WHERE mt.SubClave IN ('VIC.CR','VIC.CV','VIC.CM','VIC.CS','VIC.INV','VIC.ARR','VIC.O','VIC.MA'))
BEGIN
IF EXISTS(SELECT * FROM MovClave WHERE Clave IN ('VIC.CR','VIC.CV','VIC.CM','VIC.CS','VIC.INV','VIC.ARR','VIC.O','VIC.MA')) DELETE FROM MovClave WHERE Clave IN ('VIC.CR','VIC.CV','VIC.CM','VIC.CS','VIC.INV','VIC.ARR','VIC.O','VIC.MA')
IF EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Arrendamiento' AND Modulo = 'PACTO')       DELETE FROM MovTipo WHERE Mov = 'Arrendamiento' AND Modulo = 'PACTO'
IF EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Contrato Compra' AND Modulo = 'PACTO')     DELETE FROM MovTipo WHERE Mov = 'Contrato Compra' AND Modulo = 'PACTO'
IF EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Contrato Cosociedad' AND Modulo = 'PACTO') DELETE FROM MovTipo WHERE Mov = 'Contrato Cosociedad' AND Modulo = 'PACTO'
IF EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Contrato Inversion' AND Modulo = 'PACTO')  DELETE FROM MovTipo WHERE Mov = 'Contrato Inversion' AND Modulo = 'PACTO'
IF EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Contrato Renta' AND Modulo = 'PACTO')      DELETE FROM MovTipo WHERE Mov = 'Contrato Renta' AND Modulo = 'PACTO'
IF EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Contrato Venta' AND Modulo = 'PACTO')      DELETE FROM MovTipo WHERE Mov = 'Contrato Venta' AND Modulo = 'PACTO'
IF EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Mantenimiento' AND Modulo = 'PACTO')       DELETE FROM MovTipo WHERE Mov = 'Mantenimiento' AND Modulo = 'PACTO'
IF EXISTS (SELECT 1 FROM MovTipo WHERE Mov = 'Orden Compra' AND Modulo = 'PACTO')        DELETE FROM MovTipo WHERE Mov = 'Orden Compra' AND Modulo = 'PACTO'
END
END
END
END

