SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelCambiaproveedores]

AS BEGIN
UPDATE AspelCargaprop WITH(ROWLOCK) SET
Valor =  C.Nueva
FROM AspelCargaprop A, AspelCambiaclaves C WITH (NOLOCK) 
WHERE ltrim(rtrim(A.Tipo)) = ltrim(rtrim(C.Anterior)) And A.CAMPO = 'Proveedor'
UPDATE AspelCargareg WITH(ROWLOCK) SET
Proveedor =  C.Nueva
FROM AspelCargaReg A, AspelCambiaclaves C WITH (NOLOCK) 
WHERE ltrim(rtrim(A.Proveedor)) = dbo.fnAspelJustificaClave(ltrim(rtrim(C.Anterior))) And A.Modulo in ('COMS','CXP')
END

