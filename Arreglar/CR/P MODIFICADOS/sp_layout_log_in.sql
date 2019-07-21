SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE sp_layout_log_in
@usuario	varchar(20),
@accion		varchar(50),
@estatus	varchar(50),
@Empresa	varchar(5),
@log_id		int		OUTPUT

AS BEGIN
INSERT INTO layout_log
(usuario,  accion,  estatus,  Empresa)
SELECT @usuario, @accion, @estatus, @Empresa
SELECT @log_id = SCOPE_IDENTITY()
END

