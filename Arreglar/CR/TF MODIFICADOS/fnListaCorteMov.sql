SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnListaCorteMov (@Caja varchar(20), @Cajero varchar(20), @Fecha datetime)
RETURNS @Resultado TABLE (Movimiento varchar(50))

AS BEGIN
SELECT @Cajero = NULLIF(NULLIF(@Cajero, '(Todos)'), ''),
@Fecha = dbo.fnFechaSinHora(@Fecha)
INSERT @Resultado
SELECT '(Todos)'
UNION
SELECT d.Mov + ' ' + d.MovID
FROM Dinero d WITH(NOLOCK)
JOIN MovTipo mt WITH(NOLOCK)
ON d.Mov = mt.Mov
AND mt.Modulo = 'DIN'
WHERE mt.Clave = 'DIN.C'
AND mt.SubClave IS NULL
AND d.Estatus = 'CONCLUIDO'
AND d.CtaDinero = @Caja
AND ISNULL(d.Cajero,'') = ISNULL(@Cajero, ISNULL(d.Cajero,''))
AND d.Importe > 0
AND dbo.fnFechaSinHora(d.FechaEmision) = @Fecha
RETURN
END

