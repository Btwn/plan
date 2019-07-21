SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelCambiaagentes]

AS BEGIN
UPDATE AspelCargaprop WITH(ROWLOCK) SET
Valor =  C.Nueva
FROM AspelCargaprop A, AspelCambiaclaves C
WHERE ltrim(rtrim(A.Valor)) = dbo.fnAspelJustificaClave(ltrim(rtrim(C.Anterior))) And A.CAMPO = 'Agente'
UPDATE AspelCargareg WITH(ROWLOCK) SET
agente =  C.Nueva
FROM AspelCargaReg A, AspelCambiaclaves C
WHERE ltrim(rtrim(A.agente)) = dbo.fnAspelJustificaClave(ltrim(rtrim(C.Anterior))) And A.MODULO = 'VTAS'
END

