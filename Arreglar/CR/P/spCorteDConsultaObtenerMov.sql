SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spCorteDConsultaObtenerMov
@ID					int,
@RID				int,
@CEmpresa			varchar(5),
@CSucursal			int,
@CUEN				int,
@CUsuario			varchar(10),
@CModulo			varchar(5),
@CMovimiento		varchar(20),
@CEstatus			varchar(15),
@CSituacion			varchar(50),
@CProyecto			varchar(50),
@CContactoTipo		varchar(20),
@CContacto			varchar(10),
@CImporteMin		float,
@CImporteMax		float,
@CValidarAlEmitir	bit,
@CAccion			varchar(8),
@CDesglosar			varchar(20),
@CAgrupador			varchar(50),
@CMoneda			varchar(10),
@Moneda				varchar(10),
@TipoCambio			float,
@CFiltrarFechas		bit,
@CPeriodo			int,
@CEjercicio			int,
@CFechaD			datetime,
@CFechaA			datetime,
@CTotalizador		varchar(255),
@Ok                	int          OUTPUT,
@OkRef             	varchar(255) OUTPUT

AS
BEGIN
IF @CModulo = 'AF'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM ActivoFijo e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Proveedor, '')	= ISNULL(@CContacto, ISNULL(e.Proveedor, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'AGENT'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Agent e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(Agente, '')		= ISNULL(@CContacto, ISNULL(Agente, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'ASIS'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Asiste e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'CAM'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		NULL 'Moneda',		Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		NULL 'TipoCambio',	e.Periodo,			e.Ejercicio,
e.Estatus
FROM Cambio e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Cliente, '')	= ISNULL(@CContacto, ISNULL(e.Cliente, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'CAP'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Capital e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'CAPT'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		NULL 'Moneda',		Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		NULL 'TipoCambio',	e.Periodo,			e.Ejercicio,
e.Estatus
FROM Captura e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'CMP'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		NULL 'Moneda',		Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		NULL 'TipoCambio',	e.Periodo,			e.Ejercicio,
e.Estatus
FROM Campana e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'COMS'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
e.Almacen 'Grupo',	e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Compra e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Proveedor, '')	= ISNULL(@CContacto, ISNULL(e.Proveedor, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'CONC'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Conciliacion e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'CONT'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Cont e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(Contacto, '')		= ISNULL(@CContacto, ISNULL(Contacto, ''))
AND ISNULL(ContactoTipo, '')	= ISNULL(@CContactoTipo, ISNULL(ContactoTipo, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'CORTE'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Corte e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
AND e.ID					   <> @ID
END ELSE IF @CModulo = 'CP'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM CP e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'CR'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM CR e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'CREDI'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Credito e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'CXC'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Cxc e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Cliente, '')	= ISNULL(@CContacto, ISNULL(e.Cliente, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'CXP'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Cxp e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Proveedor, '')	= ISNULL(@CContacto, ISNULL(e.Proveedor, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'DIN'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Dinero e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(Contacto, '')		= ISNULL(@CContacto, ISNULL(Contacto, ''))
AND ISNULL(ContactoTipo, '')	= ISNULL(@CContactoTipo, ISNULL(ContactoTipo, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'EMB'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Embarque e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'FIS'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Fiscal e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'OPORT'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Oportunidad e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'FRM'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		NULL 'Moneda',		Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		NULL 'TipoCambio',	e.Periodo,			e.Ejercicio,
e.Estatus
FROM FormaExtra e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'GAS'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				NULL 'Referencia',
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Gasto e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(Acreedor, '')		= ISNULL(@CContacto, ISNULL(Acreedor, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'GES'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		NULL 'Moneda',		Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		NULL 'TipoCambio',	e.Periodo,			e.Ejercicio,
e.Estatus
FROM Gestion e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'INC'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Incidencia e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(Acreedor, '')		= ISNULL(@CContacto, ISNULL(Acreedor, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'INV'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
e.Almacen 'Grupo',	e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Inv e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'ISL'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM ISL e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'NOM'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				NULL 'Referencia',
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Nomina e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'OFER'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Oferta e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Proveedor, '')	= ISNULL(@CContacto, ISNULL(e.Proveedor, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'ORG'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Organiza e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'PACTO'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Contrato e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND (ISNULL(e.Cliente, '')	= ISNULL(@CContacto, ISNULL(e.Cliente, ''))
OR ISNULL(e.Proveedor, '')	= ISNULL(@CContacto, ISNULL(e.Proveedor, ''))
OR ISNULL(Agente, '')		= ISNULL(@CContacto, ISNULL(Agente, '')))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'PC'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM PC e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'PCP'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM PCP e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'PPTO'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Presup e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'PROD'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
e.Almacen 'Grupo',	e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Prod e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'PROY'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Proyecto e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Cliente, '')	= ISNULL(@CContacto, ISNULL(e.Cliente, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'RE'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Recluta e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'RH'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM RH e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'RSS'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		NULL 'Moneda',		Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		NULL 'TipoCambio',	e.Periodo,			e.Ejercicio,
e.Estatus
FROM RSS e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'SAUX'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		NULL 'Moneda',		Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		NULL 'TipoCambio',	e.Periodo,			e.Ejercicio,
e.Estatus
FROM SAUX e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'ST'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		NULL 'Moneda',		Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		NULL 'TipoCambio',	e.Periodo,			e.Ejercicio,
e.Estatus
FROM Soporte e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Cliente, '')	= ISNULL(@CContacto, ISNULL(e.Cliente, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'TMA'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		NULL 'Moneda',		Referencia,
e.Almacen 'Grupo',	e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL 'Importe',
@RID 'RID',			@ID 'ID',		NULL 'TipoCambio',	e.Periodo,			e.Ejercicio,
e.Estatus
FROM TMA e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0)			= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'VALE'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
e.Almacen 'Grupo',	e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Vale e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Cliente, '')	= ISNULL(@CContacto, ISNULL(e.Cliente, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'VTAS'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		Moneda,				Referencia,
e.Almacen 'Grupo',	e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		TipoCambio,			e.Periodo,			e.Ejercicio,
e.Estatus
FROM Venta e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND ISNULL(e.Cliente, '')	= ISNULL(@CContacto, ISNULL(e.Cliente, ''))
AND ISNULL(e.Importe, 0)		BETWEEN ISNULL(@CImporteMin, ISNULL(e.Importe, 0)) AND ISNULL(@CImporteMax, ISNULL(e.Importe, 0))
AND ISNULL(e.Moneda, '')		= ISNULL(@CMoneda, ISNULL(e.Moneda, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END ELSE IF @CModulo = 'CONTP'
BEGIN
SELECT Mov,					MovID,			FechaEmision,		NULL,				Referencia,
NULL 'Grupo',		e.Sucursal,		@CModulo 'Modulo',	e.ID 'ModuloID',	NULL,
@RID 'RID',			@ID 'ID',		NULL,				e.Periodo,			e.Ejercicio,
e.Estatus
FROM ContParalela e
WHERE ISNULL(e.Empresa, '')	= ISNULL(@CEmpresa, ISNULL(e.Empresa, ''))
AND ISNULL(e.Sucursal, 0)	= ISNULL(@CSucursal, ISNULL(e.Sucursal, 0))
AND ISNULL(e.UEN, 0) 		= ISNULL(@CUEN, ISNULL(e.UEN, 0))
AND ISNULL(e.Usuario, '')	= ISNULL(@CUsuario, ISNULL(e.Usuario, ''))
AND ISNULL(e.Mov, '')		= ISNULL(@CMovimiento, ISNULL(e.Mov, ''))
AND ISNULL(e.Estatus, '')	= ISNULL(@CEstatus, ISNULL(e.Estatus, ''))
AND ISNULL(e.Situacion, '')	= ISNULL(@CSituacion, ISNULL(e.Situacion, ''))
AND ISNULL(e.Proyecto, '')	= ISNULL(@CProyecto, ISNULL(e.Proyecto, ''))
AND e.FechaEmision			BETWEEN ISNULL(@CFechaD, e.FechaEmision) AND ISNULL(@CFechaA, e.FechaEmision)
AND ISNULL(e.Ejercicio, 0)	= ISNULL(@CEjercicio, ISNULL(e.Ejercicio, 0))
AND ISNULL(e.Periodo, 0)		= ISNULL(@CPeriodo, ISNULL(e.Periodo, 0))
END
RETURN
END

