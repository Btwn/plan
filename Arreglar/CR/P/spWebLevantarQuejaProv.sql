SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spWebLevantarQuejaProv
@Empresa		char(5),
@Usuario		char(10),
@FechaHoy		DATETIME,
@User			CHAR(10),
@Proyecto		VARCHAR(50),
@Contacto		VARCHAR(50),
@Telefono		VARCHAR(30),
@Extencion		VARCHAR(10),
@Fax			VARCHAR(30),
@eMail			VARCHAR(30),
@Agente			CHAR(10),
@Titulo 		VARCHAR(100),
@Comentarios 		VARCHAR(4192),
@Observaciones 		VARCHAR(100),
@Referencia 		VARCHAR(50),
@Prioridad 		CHAR(10)
AS BEGIN
SET NOCOUNT ON
INSERT INTO Soporte
(Empresa, Usuario, UsuarioResponsable, FechaEmision, UltimoCambio, Vencimiento, Proveedor, Proyecto, Contacto,
Telefono, Extencion, Fax, eMail, Agente, Titulo, Comentarios, Observaciones, Referencia, Prioridad, Problema, Solucion,
Mov, SubModulo, Estatus, Estado, Sucursal, SucursalOrigen, TieneContrato, PuedeDevolver, GenerarPoliza)
VALUES(@Empresa, @Usuario, @Usuario, @FechaHoy, @FechaHoy, @FechaHoy, @User, @Proyecto,
@Contacto, @Telefono, @Extencion, @Fax, @Email, @Agente, @Titulo, @Comentarios,
@Observaciones, @Referencia, @Prioridad, '', '',
'Queja', 'STPRO', 'SINAFECTAR', 'No comenzado', 0, 0, 0, 0, 0)
SELECT @@IDENTITY AS NewID
RETURN
END

