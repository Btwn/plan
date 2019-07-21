SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSWProv_AltaRep
@Empresa		VARCHAR(5),
@Proveedor		VARCHAR(10),
@Mov 			VARCHAR(100),
@Prioridad 		CHAR(10),
@Recurso		VARCHAR(10),
@Comentarios 	VARCHAR(MAX)
AS BEGIN
DECLARE
@Usuario		VARCHAR(10),
@UsuarioResp	VARCHAR(10),
@Contacto		VARCHAR(50),
@Telefono		VARCHAR(30),
@Extencion		VARCHAR(10),
@Fax			VARCHAR(30),
@eMail			VARCHAR(30),
@Agente			CHAR(10),
@Proyecto		VARCHAR(50)
SELECT	@Usuario = NULLIF(Usuario, ''), @UsuarioResp = Usuario
FROM	Recurso
WHERE	Recurso = @Recurso
SELECT	@Usuario = ISNULL(@Usuario, @Proveedor), @UsuarioResp = ISNULL(@UsuarioResp, @Recurso)
SET NOCOUNT ON
INSERT INTO Soporte (
Empresa,	Usuario,	UsuarioResponsable,	FechaEmision,	UltimoCambio,	Vencimiento,
Proveedor,	Proyecto,	Contacto,			Telefono,		Extencion,		Fax,			eMail,			Agente,
Titulo,		Comentarios,					Observaciones,	Referencia,		Prioridad,		Problema,		Solucion,
Mov,		SubModulo,	Estatus,			Estado,			Sucursal,		SucursalOrigen,	TieneContrato,	PuedeDevolver,	GenerarPoliza)
VALUES(
@Empresa,	@Usuario,	@UsuarioResp,		dbo.fnFechaSinHora(GETDATE()),	GETDATE(),		dbo.fnFechaSinHora(GETDATE()),
@Proveedor,	@Proyecto,	@Contacto,			@Telefono,		@Extencion,		@Fax,			@Email,			@Agente,
@Mov,		CAST(@Comentarios AS TEXT),		@Comentarios,	@Recurso,		@Prioridad,		'',				'',
@Mov,		'STPRO',	'SINAFECTAR',		'No Comenzado', 0,				0,				0,				0,				0)
SET NOCOUNT OFF
SELECT @@IDENTITY AS NewID
RETURN
END

