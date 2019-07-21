SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSAfectarPOSLSuc
@SucursalT		int,
@Debugg			bit = 0

AS
BEGIN
DECLARE
@Empresa			varchar(5),
@Modulo				varchar(5),
@Sucursal			int,
@Usuario			varchar(10),
@Host               varchar(20),
@ID					varchar(36),
@Empresa2			varchar(5),
@Modulo2			varchar(5),
@Sucursal2          int,
@Usuario2			varchar(10),
@Host2				varchar(20),
@ID2                varchar(36),
@Ok					int,
@OkRef				varchar(255),
@Mov				varchar(20),
@Mov2				varchar(20),
@MovClave			varchar(20),
@MovAfectar			varchar(20),
@Cuerpo				varchar(200),
@Asunto				varchar(100),
@EnviaCorreo		bit,
@Remitente			varchar(255),
@Perfil				varchar(20),
@IDError            varchar(36),
@Cajero				varchar(10),
@FechaEmision		datetime,
@FechaRegistro		datetime,
@Caja				varchar(10),
@Ok2				int,
@OkRef2				varchar(255),
@Trans1				varchar(255),
@Trans2				varchar(255),
@Contador			int
SELECT @Contador = 0
SET TRANSACTION ISOLATION LEVEL Read UnCommitted
SELECT @EnviaCorreo = EnviaCorreo, @Perfil = Perfil, @Remitente = NULLIF(Remitente,'')
FROM Sucursal
WHERE Sucursal = @SucursalT
DECLARE @POSLM TABLE(RID			int	identity(1,1)	NOT NULL,
Empresa		char(5)		NULL,
Modulo			varchar(5)	NULL,
Sucursal		int			NULL,
Usuario		varchar(10)	NULL,
ID				varchar(36)	NULL,
Host			varchar(20)	NULL,
Mov			varchar(20)	NULL,
Cajero			varchar(10) NULL,
FechaEmision	datetime	NULL,
FechaRegistro	datetime	NULL,
Caja			varchar(10) NULL)
DELETE @POSLM
INSERT INTO @POSLM(
Empresa, Modulo, Sucursal, Usuario, ID, Host, Mov, Cajero, FechaEmision, FechaRegistro, Caja)
SELECT
p.Empresa, p.Modulo, p.Sucursal, p.Usuario, p.ID, p.Host, p.Mov, p.Cajero, p.FechaEmision, p.FechaRegistro, p.Caja
FROM POSL p
INNER JOIN MovTipo mt ON p.Mov = mt.Mov
AND mt.Modulo = 'POS'
WHERE p.Estatus IN ('CONCLUIDO') AND p.Sucursal = @SucursalT
ORDER BY p.FechaRegistro
DECLARE crPOSL CURSOR LOCAL FOR
SELECT Empresa,Modulo,Sucursal,Usuario,ID,Host,Mov, Cajero, FechaEmision, FechaRegistro, Caja
FROM @POSLM
OPEN crPOSL
FETCH NEXT FROM crPOSL INTO @Empresa, @Modulo, @Sucursal, @Usuario, @ID, @Host, @Mov, @Cajero, @FechaEmision, @FechaRegistro, @Caja
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @IDError = @ID, @Ok = NULL, @OkRef = NULL, @Ok2 = NULL, @OkRef2 = NULL, @Contador = @Contador + 1
SELECT @MovClave = Clave FROM MovTipo WHERE Mov = @Mov AND Modulo = 'POS'
IF @MovClave IN ('POS.AC', 'POS.ACM')
BEGIN
IF EXISTS (	SELECT TOP 1 *
FROM POSL p WITH (NOLOCK)
INNER JOIN MovTipo mt WITH (NOLOCK) ON p.Mov = mt.Mov AND mt.Modulo = 'POS'
WHERE p.Usuario = @Usuario
AND p.Cajero = @Cajero
AND p.Host = @Host
AND p.Empresa = @Empresa
AND p.Sucursal = @Sucursal
AND p.Estatus = 'CONCLUIDO'
AND mt.Clave IN ('POS.CC', 'POS.CCM')
AND p.FechaEmision <= @FechaEmision
AND p.FechaRegistro <= @FechaRegistro
ORDER BY FechaRegistro DESC )
SELECT @Ok2 = 10001, @OkRef2 = 'No se puede traspasar la Apertura existe un Corte Caja Pendiente'
END
IF @MovClave NOT IN ('POS.FTE','POS.STE','POS.CC','POS.CCM','POS.TCAC','POS.CTCAC','POS.CTCRC','POS.TCRC', 'POS.AC', 'POS.ACM') AND @Ok2 IS NULL
BEGIN
IF EXISTS (	SELECT TOP 1 *
FROM POSL p WITH (NOLOCK)
INNER JOIN MovTipo mt WITH (NOLOCK) ON p.Mov = mt.Mov AND mt.Modulo = 'POS'
WHERE p.Usuario = @Usuario
AND p.Cajero = @Cajero
AND p.Host = @Host
AND p.Empresa = @Empresa
AND p.Sucursal = @Sucursal
AND p.Estatus = 'CONCLUIDO'
AND mt.Clave IN ('POS.AC', 'POS.ACM')
AND p.FechaEmision <= @FechaEmision
AND p.FechaRegistro <= @FechaRegistro
ORDER BY FechaRegistro DESC )
SELECT @Ok2 = 10001, @OkRef2 = 'No se puede traspasar las Ventas existe un Apertura Caja Pendiente'
END
IF @MovClave IN ('POS.CC', 'POS.CCM') AND @Ok2 IS NULL
BEGIN
IF EXISTS (	SELECT TOP 1 *
FROM POSL p WITH (NOLOCK)
INNER JOIN MovTipo mt WITH (NOLOCK) ON p.Mov = mt.Mov AND mt.Modulo = 'POS'
WHERE p.Usuario = @Usuario
AND p.Cajero = @Cajero
AND p.Host = @Host
AND p.Empresa = @Empresa
AND p.Sucursal = @Sucursal
AND p.Estatus = 'CONCLUIDO'
AND mt.Clave NOT IN ('POS.FTE','POS.STE','POS.CC','POS.CCM','POS.TCAC','POS.CTCAC','POS.CTCRC','POS.TCRC')
AND p.FechaEmision <= @FechaEmision
AND p.FechaRegistro <= @FechaRegistro
ORDER BY FechaRegistro DESC )
SELECT @Ok2 = 10001, @OkRef2 = 'No se puede traspasar el Corte Caja existen Ventas Pendientes'
IF @Ok2 IS NULL AND (SELECT EsConcentradora FROM CtaDinero WHERE CtaDinero = @Caja) = 1
BEGIN
IF EXISTS (	SELECT TOP 1 *
FROM POSL p WITH (NOLOCK)
WHERE p.Empresa = @Empresa
AND p.Sucursal = @SucursalT
AND p.Estatus = 'CONCLUIDO'
AND p.FechaEmision <= @FechaEmision
AND p.FechaRegistro <= @FechaRegistro
ORDER BY FechaRegistro DESC )
SELECT @Ok2 = 10001, @OkRef2 = 'No se puede traspasar el Corte Caja Concetradora existen Operaciones Pendientes'
END
END
IF @Ok2 IS NOT NULL
BEGIN
SELECT @OkRef2 = Descripcion +', '+ @OkRef2
FROM MensajeLista
WHERE Mensaje = @Ok2
IF @Debugg = 1
SELECT @Ok2, @OkRef2, @IDError, @Mov
IF @EnviaCorreo = 1 AND @Perfil IS NOT NULL AND @Remitente IS NOT NULL
BEGIN
SELECT  @Asunto = 'ERROR ' + convert(varchar,@Ok2), @Cuerpo  = convert(varchar,@Ok2) + ', ' + @OkRef2 + ', ' + @IDError + ', ' + @Mov
EXEC  msdb.dbo.sp_send_dbmail  @profile_name     = @Perfil
,@recipients       = @Remitente
,@body             =  @Cuerpo
,@subject          =  @Asunto
END
IF @EnviaCorreo = 0
BEGIN
SELECT @Cuerpo  = convert(varchar,@Ok2) + ', ' + @OkRef2 + ', ' + @IDError + ', ' + @Mov
IF NOT EXISTS (SELECT * FROM POSJobErrores WHERE Sucursal = @SucursalT AND IDPos = @IDError)
INSERT INTO POSJobErrores (
Sucursal, IDPos, Error, Atendido)
VALUES (
@SucursalT,	@IDError, @Cuerpo, 0)
ELSE
UPDATE POSJobErrores SET Error = @Cuerpo WHERE Sucursal = @SucursalT AND IDPos = @IDError
END
END
ELSE
SELECT @Trans1 = 'POS1'+@ID , @Trans2 = 'POS2'+@ID
IF @MovClave NOT IN ('POS.FTE','POS.STE','POS.CC','POS.CCM','POS.TCAC','POS.CTCAC','POS.CTCRC','POS.TCRC') AND @Ok2 IS NULL
BEGIN
BEGIN TRAN @Trans1
EXEC spPOSAfectar @Empresa, @Modulo, @Sucursal, @Usuario, @ID, @Host, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NOT NULL
SELECT @MovAfectar = @Mov
IF @MovClave IN ('POS.TCM','POS.CTCM') AND @Ok IS NULL
BEGIN
IF EXISTS (SELECT * FROM POSL p JOIN MovTipo m ON p.Mov = m.Mov AND m.Modulo = 'POS'
WHERE p.IDR = @ID AND p.Estatus IN('CONCLUIDO') AND m.Clave IN('POS.TCM','POS.CTCM'))
UPDATE POSL SET Estatus = 'TRASPASADO'
WHERE ID IN (SELECT ID FROM POSL p JOIN MovTipo m ON p.Mov = m.Mov AND m.Modulo = 'POS'
WHERE p.IDR = @ID AND p.Estatus IN('CONCLUIDO') AND m.Clave IN('POS.TCM','POS.CTCM'))
END
IF @MovClave IN ('POS.TRM','POS.CTRM' ) AND @Ok IS NULL
BEGIN
IF EXISTS (SELECT * FROM POSL p JOIN MovTipo m ON p.Mov = m.Mov AND m.Modulo = 'POS'
WHERE p.IDR = @ID AND p.Estatus IN('CONCLUIDO') AND m.Clave IN('POS.TRM','POS.CTRM'))
UPDATE POSL SET Estatus = 'TRASPASADO'
WHERE ID IN (SELECT ID FROM POSL p JOIN MovTipo m ON p.Mov = m.Mov AND m.Modulo = 'POS'
WHERE p.IDR = @ID AND p.Estatus IN('CONCLUIDO') AND m.Clave IN('POS.CTCRC','POS.TCRC'))
END
IF @Ok BETWEEN 80030 AND 81000
SET @Ok = NULL
IF @Ok IS NULL
BEGIN
UPDATE POSL Set Estatus = 'TRASPASADO' WHERE ID = @ID
COMMIT TRAN @Trans1
END
ELSE
BEGIN
ROLLBACK TRAN @Trans1
SELECT @OkRef = Descripcion +' '+ISNULL(@OkRef,'')
FROM MensajeLista
WHERE Mensaje = @Ok
IF @Debugg = 1
SELECT @Ok, @OkRef, @Modulo, @IDError, @MovAfectar
SELECT @OkRef = Descripcion +' '+ISNULL(@OkRef,'')
FROM MensajeLista
WHERE Mensaje = @Ok
IF @EnviaCorreo = 1 AND @Perfil IS NOT NULL AND @Remitente IS NOT NULL
BEGIN
SELECT @Asunto = 'ERROR ' + convert(varchar,@Ok), @Cuerpo  = convert(varchar,@Ok) + ', ' +
@OkRef + ', ' + @Modulo + ', ' + @IDError + ', ' + @MovAfectar
EXEC  msdb.dbo.sp_send_dbmail @profile_name = @Perfil, @recipients = @Remitente, @body = @Cuerpo,
@subject =  @Asunto
END
IF @EnviaCorreo = 0
BEGIN
SELECT @Cuerpo  = convert(varchar,@Ok) + ', ' + @OkRef + ', ' + @Modulo + ', ' + @IDError + ', ' + @MovAfectar
IF NOT EXISTS (SELECT * FROM POSJobErrores WHERE Sucursal = @SucursalT AND IDPos = @IDError)
INSERT INTO POSJobErrores (
Sucursal, IDPos, Error, Atendido)
VALUES (
@SucursalT,	@IDError, @Cuerpo, 0)
ELSE
UPDATE POSJobErrores SET Error = @Cuerpo WHERE Sucursal = @SucursalT AND IDPos = @IDError
END
END
END
IF @MovClave IN ('POS.CC','POS.CCM')AND @Ok2 IS NULL
BEGIN
BEGIN TRAN @Trans2
IF  EXISTS( SELECT * FROM POSL p JOIN MovTipo m ON p.Mov = m.Mov  AND m.Modulo = 'POS'
WHERE p.IDR = @ID AND m.Clave IN ('POS.FTE','POS.STE') AND p.Estatus = 'CONCLUIDO')
BEGIN
DECLARE crFaltanteSobrante CURSOR FOR
SELECT p.Empresa, p.Modulo, p.Sucursal, p.Usuario, p.ID, p.Host, p.Mov
FROM POSL p
INNER JOIN MovTipo mt ON p.Mov = mt.Mov  AND mt.Modulo = 'POS'AND mt.Clave IN ('POS.FTE','POS.STE')
WHERE p.Estatus IN ('CONCLUIDO') AND p.IDR = @ID
ORDER BY FechaRegistro
OPEN crFaltanteSobrante
FETCH NEXT FROM crFaltanteSobrante INTO @Empresa2, @Modulo2, @Sucursal2, @Usuario2, @ID2, @Host2, @Mov2
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
IF @Ok IS NOT NULL
SELECT @MovAfectar = @Mov2,  @ID = @ID2
SELECT @Ok = NULL, @OkRef = NULL
IF @Ok IS NULL
UPDATE POSL Set Estatus = 'TRASPASADO' WHERE ID = @ID2
FETCH NEXT FROM crFaltanteSobrante INTO @Empresa2, @Modulo2, @Sucursal2, @Usuario2, @ID2, @Host2, @Mov2
END
CLOSE crFaltanteSobrante
DEALLOCATE crFaltanteSobrante
IF @Ok IS NULL
EXEC spPOSAfectar @Empresa, @Modulo, @Sucursal, @Usuario, @ID, @Host, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NOT NULL
SELECT @MovAfectar = @Mov
END
ELSE
BEGIN
EXEC spPOSAfectar @Empresa, @Modulo, @Sucursal, @Usuario, @ID, @Host, @Ok OUTPUT, @OkRef OUTPUT
IF @Ok IS NOT NULL
SELECT @MovAfectar = @Mov
END
IF @Ok BETWEEN 80030 AND 81000
SET @Ok = NULL
IF @Ok IS NULL
BEGIN
UPDATE POSL Set Estatus = 'TRASPASADO' WHERE ID = @ID
COMMIT TRAN @Trans2
END
ELSE
BEGIN
ROLLBACK TRAN @Trans2
SELECT @OkRef = Descripcion +' '+ISNULL(@OkRef,'')
FROM MensajeLista
WHERE Mensaje = @Ok
IF @Debugg = 1
SELECT @Ok, @OkRef, @Modulo, @IDError, @MovAfectar
SELECT @OkRef = Descripcion +' '+ISNULL(@OkRef,'')
FROM MensajeLista
WHERE Mensaje = @Ok
IF @EnviaCorreo = 1 AND @Perfil IS NOT NULL AND @Remitente IS NOT NULL
BEGIN
SELECT @Asunto = 'ERROR ' + convert(varchar,@Ok), @Cuerpo = convert(varchar,@Ok) + ', ' +
@OkRef + ', ' + @Modulo + ', ' + @IDError + ', ' + @MovAfectar
EXEC msdb.dbo.sp_send_dbmail @profile_name = @Perfil, @recipients = @Remitente,
@body =  @Cuerpo, @subject = @Asunto
END
IF @EnviaCorreo = 0
BEGIN
SELECT @Cuerpo  = convert(varchar,@Ok) + ', ' + @OkRef + ', ' + @Modulo + ', ' + @IDError + ', ' + @MovAfectar
IF NOT EXISTS (SELECT * FROM POSJobErrores WHERE Sucursal = @SucursalT AND IDPos = @IDError)
INSERT INTO POSJobErrores (
Sucursal, IDPos, Error,	Atendido)
VALUES (
@SucursalT,	@IDError, @Cuerpo, 0)
ELSE
UPDATE POSJobErrores SET Error = @Cuerpo WHERE Sucursal = @SucursalT AND IDPos = @IDError
END
END
END
END
FETCH NEXT FROM crPOSL INTO @Empresa, @Modulo, @Sucursal, @Usuario, @ID, @Host, @Mov, @Cajero, @FechaEmision, @FechaRegistro, @Caja
END
CLOSE crPOSL
DEALLOCATE crPOSL
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

