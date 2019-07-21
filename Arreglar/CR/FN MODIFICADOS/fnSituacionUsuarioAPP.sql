SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnSituacionUsuarioAPP
(
@Empresa				varchar(5),
@Modulo					varchar(5),
@Mov					varchar(20),
@Estatus				varchar(15),
@Situacion				varchar(50),
@Usuario				varchar(10)
)
RETURNS bit
AS BEGIN
DECLARE
@SituacionSiguiente varchar(50),
@Permite   int
SELECT  @SituacionSiguiente =  NULLIF(dbo.fnSituacionSiguiente(@Modulo, @Mov, @Estatus, @Situacion),'')
IF @SituacionSiguiente IS NOT NULL
BEGIN
IF ISNULL(dbo.fnSituacionPermiteAvanzar(@Empresa, @Modulo, @Mov, @Estatus, @SituacionSiguiente, @Usuario),0) = 1 SELECT @Permite = 1 ELSE SELECT @Permite = 0
END
RETURN(@Permite)
END

