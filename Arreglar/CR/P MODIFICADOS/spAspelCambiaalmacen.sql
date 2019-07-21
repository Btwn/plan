SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelCambiaalmacen]

AS BEGIN
UPDATE AspelCargaprop WITH(ROWLOCK) SET
Valor =  C.Nueva
FROM AspelCargaprop A, AspelCambiaclaves C
WHERE ltrim(rtrim(A.Valor)) = ltrim(rtrim(C.Anterior)) And A.CAMPO = 'Almacen'
UPDATE AspelCargareg WITH(ROWLOCK) SET
Almacen =  C.Nueva
FROM AspelCargaReg A, AspelCambiaclaves C
WHERE ltrim(rtrim(A.almacen)) = ltrim(rtrim(C.Anterior)) And A.modulo IN ('VTAS','COMS','INV')
END

