SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spAspelInsertaAlmacenes]

AS BEGIN
DECLARE	@Observaciones	varchar(30),
@Sucursal	varchar(30),
@Cuenta		int
SELECT @Observaciones = Valor FROM AspelCfg WITH (NOLOCK) WHERE Descripcion = 'Observaciones'
IF NOT EXISTS(SELECT Grupo FROM AlmGrupo WITH (NOLOCK) WHERE Grupo = @Observaciones)
INSERT INTO AlmGrupo (Grupo) VALUES (@Observaciones)
SELECT @Sucursal = Valor FROM AspelCfg WITH (NOLOCK) WHERE Descripcion = 'Sucursal'
INSERT INTO Alm (Almacen,Nombre,Estatus,UltimoCambio,Alta,Grupo, Sucursal, Observaciones)
SELECT Valor, Nombre, ISNULL(Estatus, 'ALTA'), getdate(), getdate(), @Observaciones, @Sucursal, @Observaciones
FROM AspelCargaProp WITH (NOLOCK)
WHERE Campo = 'Almacen'
END

