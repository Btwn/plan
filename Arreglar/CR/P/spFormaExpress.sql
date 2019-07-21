SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spFormaExpress
@Empresa	varchar(5),
@Sucursal	int,
@Usuario	varchar(10),
@FechaEmision	datetime,
@FormaTipo	varchar(20),
@Aplica		varchar(50), 	
@AplicaClave	varchar(50)	

AS BEGIN
DECLARE
@ID		int
SELECT @ID = NULL
SELECT @ID = MAX(ID) FROM FormaExtra WHERE Aplica = @Aplica AND AplicaClave = @AplicaClave
IF @ID IS NULL
BEGIN
INSERT FormaExtra (Mov, Empresa, Sucursal, Usuario, Estatus, FechaEmision, FormaTipo, Aplica, AplicaClave)
VALUES ('Evaluacion', @Empresa, @Sucursal, @Usuario, 'SINAFECTAR', @FechaEmision, @FormaTipo, @Aplica, @AplicaClave)
SELECT @ID = SCOPE_IDENTITY()
END
SELECT 'ID' = @ID
RETURN
END

