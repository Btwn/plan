SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebLevantarSugerenciaProv
@Empresa		char(5),
@Usuario		char(10),
@FechaHoy		datetime,
@User			char(10),
@Proyecto		varchar(50),
@Contacto		varchar(50),
@Telefono		varchar(30),
@Extencion		varchar(10),
@Fax			varchar(30),
@eMail			varchar(30),
@Agente			char(10),
@Comentarios 	varchar(4192)
AS BEGIN
SET NOCOUNT ON
INSERT INTO Soporte (Empresa, Usuario, UsuarioResponsable, FechaEmision, UltimoCambio, Vencimiento, Proveedor, Proyecto,
Contacto, Telefono, Extencion, Fax, eMail, Agente, Comentarios, Titulo, Problema, Solucion,
Mov, SubModulo, Estatus, Estado, Sucursal, SucursalOrigen, TieneContrato, PuedeDevolver, GenerarPoliza)
VALUES(@Empresa, @Usuario, @Usuario, @FechaHoy, @FechaHoy, @FechaHoy, @User, @Proyecto,
@Contacto, @Telefono, @Extencion, @Fax, @Email, @Agente, @Comentarios,
'Sugerencia', '', '', 'Sugerencia', 'STPRO', 'SINAFECTAR', 'No comenzado', 0, 0, 0, 0, 0)
SELECT @@IDENTITY AS NewID
RETURN
END

