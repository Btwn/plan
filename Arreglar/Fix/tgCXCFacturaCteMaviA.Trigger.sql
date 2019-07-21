SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER [dbo].[tgCXCFacturaCteMaviA]
ON [dbo].[CXCFacturaCteMavi]
FOR INSERT
AS
BEGIN
	DECLARE
		@Empresa VARCHAR(5)
	   ,@Cliente CHAR(10)
	   ,@Estacion INT
	   ,@IDOrigen INT
	   ,@IDCxc INT
	   ,@IDBonifSI INT
	   ,@Modulo VARCHAR(5)
	   ,@Articulo VARCHAR(100)
	SELECT @Estacion = Estacion
		  ,@Empresa = Empresa
		  ,@Cliente = Cliente
		  ,@IDOrigen = IdOrigen
		  ,@IDCxc = inserted.IdOrigen
		  ,@IDBonifSI = bs.IDCxc
		  ,@Modulo = 'CXC'
	FROM inserted
	LEFT OUTER JOIN BonifSIMavi bs
		ON bs.IdCxC = inserted.IdOrigen

	IF @IDBonifSI IS NULL
	BEGIN
		EXEC spVerMovFlujo @Estacion
						  ,@Empresa
						  ,@Modulo
						  ,@IDOrigen
		SELECT @IDOrigen = vmf.ModuloID
		FROM VerMovFlujo vmf
		JOIN MovTipo mt
			ON mt.Modulo = vmf.Modulo
			AND mt.Mov = vmf.Mov
		WHERE vmf.Estacion = @Estacion
		AND mt.Clave IN ('VTAS.F')
		SELECT TOP 1 @Articulo = a.Descripcion1
		FROM Venta v
		JOIN VentaD vd
			ON vd.ID = v.ID
		LEFT OUTER JOIN Art a
			ON a.Articulo = vd.Articulo
		WHERE v.ID = @IDOrigen
		ORDER BY vd.Renglon
	END
	ELSE
		SELECT @Articulo = Articulo
		FROM BonifSIMavi bs
		WHERE bs.IDCxc = @IDCxc

	UPDATE CXCFacturaCteMavi
	SET Articulo = @Articulo
	WHERE Cliente = @Cliente
	AND Empresa = @Empresa
	AND IdOrigen = @IDCxc
	AND Estacion = @Estacion
END
GO
