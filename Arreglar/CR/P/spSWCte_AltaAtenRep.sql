SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSWCte_AltaAtenRep
@Cliente		char(10),
@Empresa		char(5),
@Recurso		varchar(10),
@Prioridad		char(10),
@Mov			char(20),
@Comentarios	varchar(50) = NULL
AS BEGIN
DECLARE
@Usuario		  char(10),
@Observaciones  varchar(100),
@Contacto		  varchar(50),
@Agente		  char(10),
@Telefono		  varchar(30),
@Extencion      varchar(10),
@Fax			  varchar(30),
@SucursalCte    int,
@eMail		  varchar(30),
@Proyecto       varchar(50)
SELECT @Usuario = Usuario, @Observaciones = @Observaciones
FROM Recurso
WHERE Recurso = @Recurso
SELECT @Usuario = ISNULL(@Usuario, @Cliente)
SELECT
@Contacto		= NULLIF(RTrim(Contacto1), ''),
@Agente		= NULLIF(RTrim(Agente), ''),
@Telefono		= NULLIF(RTrim(SUBSTRING(Telefonos, 1, 30)), ''),
@Extencion	= NULLIF(RTrim(Extencion1), ''),
@Fax			= NULLIF(RTrim(SUBSTRING(Fax, 1, 30)), ''),
@SucursalCte	= RTRIM(EnviarA),
@eMail		= NULLIF(RTrim(SUBSTRING(eMail1, 1, 30)), ''),
@Proyecto		= NULLIF(RTrim(Proyecto), '')
FROM Cte
WHERE Cliente = @Cliente
SET NOCOUNT ON
INSERT INTO Soporte (
Empresa, Usuario,  UsuarioResponsable, FechaEmision, UltimoCambio, Cliente,  EnviarA,
Proyecto, Contacto,  Telefono,   Extencion,  Fax,   eMail,   Agente,
Titulo,  Observaciones, Referencia,   Prioridad,  Mov,   Version,  Problema,  Comentarios,
SubModulo, Estatus,  Estado,    Sucursal,  SucursalOrigen, TieneContrato, PuedeDevolver, GenerarPoliza)
VALUES (
@Empresa, @Usuario, @Usuario, dbo.fnFechaSinHora(GETDATE()),  GETDATE(),  @Cliente,  @SucursalCte,
@Proyecto, @Contacto,  @Telefono,   @Extencion,  @Fax,   @Email,   @Agente,
@Mov, @Observaciones, '',     NULLIF(@Prioridad,''),    @Mov,   0,  NULL, CAST(@Comentarios + CASE WHEN @Usuario IS NULL THEN ' - SIN USUARIO, Cliente: ' + @Cliente ELSE '' END AS TEXT),
'ST',  'SINAFECTAR', 'No comenzado',  0,    0,    0,    0,    0)
SET NOCOUNT OFF
SELECT @@IDENTITY AS NewID
RETURN
END

