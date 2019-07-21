SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRHIDSE
@ID             int,
@Estacion       int

AS BEGIN
DECLARE
@Ok                 int,
@OkRef              varchar(255),
@Confirmado         bit,
@SeguroSocial       varchar(20),
@Fecha              datetime,
@Mensaje            varchar(255),
@Personal           varchar(20),
@Clave              varchar(255)
DECLARE crIDSE CURSOR FOR
SELECT Clave FROM ListaST WHERE Estacion = @Estacion
OPEN crIDSE
FETCH NEXT FROM crIDSE INTO @Clave
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2 AND NULLIF(@Clave, '') IS NOT NULL
BEGIN
SELECT @Confirmado    = CONVERT(int, SUBSTRING(@Clave, 1, 1)),
@SeguroSocial  = SUBSTRING(@Clave, 2, 11),
@Mensaje       = SUBSTRING(@Clave, 21, 234)
SELECT @Personal = Personal FROM Personal WHERE Registro3 = @SeguroSocial
IF NULLIF(@Personal, '') IS NOT NULL
IF @Confirmado = 1
UPDATE RHD SET IDSEConciliado = @Confirmado, IDSEMensaje = 'OPERADO' WHERE ID = @ID AND Personal = @Personal
ELSE
UPDATE RHD SET IDSEConciliado = @Confirmado, IDSEMensaje = NULLIF(@Mensaje, '') WHERE ID = @ID AND Personal = @Personal
END
FETCH NEXT FROM crIDSE INTO @Clave
END
CLOSE crIDSE
DEALLOCATE crIDSE
RETURN
END

