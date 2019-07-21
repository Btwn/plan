SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelRevisaTablas]

AS BEGIN
DECLARE
@Cuenta		varchar(50)
/****** AspelWarnings ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspelWarnings]') AND type in (N'U'))
DROP TABLE [dbo].[AspelWarnings]
CREATE TABLE [dbo].[AspelWarnings](
[Id] [int] IDENTITY(1,1) NOT NULL,
[Descripcion] [varchar](100) COLLATE Database_Default NULL,
CONSTRAINT [PK_AspelWarnings] PRIMARY KEY CLUSTERED
(
[Id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
SELECT @Cuenta = COUNT(*) FROM AgenteCat WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen ' + CONVERT(varchar, @Cuenta) + ' Registros en el Cat�logo de Categor�as de Agentes')
SELECT @Cuenta = COUNT(*) FROM Agente WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Cat�logo de Agentes')
SELECT @Cuenta = COUNT(*) FROM AlmGrupo WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Cat�logo de Grupos de Almacenes')
SELECT @Cuenta = COUNT(*) FROM Alm WITH (NOLOCK) 
IF @Cuenta > 1
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta-1) + ' Registros en el Cat�logo de Almacenes')
SELECT @Cuenta = COUNT(*) FROM ArtCat WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Cat�logo de Categor�as de Art�culos')
SELECT @Cuenta = COUNT(*) FROM ArtLinea WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Cat�logo de Categor�as de L�neas de Art�culos')
SELECT @Cuenta = COUNT(*) FROM Art WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Cat�logo de Art�culos')
SELECT @Cuenta = COUNT(*) FROM CteCat WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen ' + CONVERT(varchar, @Cuenta) + ' Registros en el Cat�logo de Categor�as de Clientes')
SELECT @Cuenta = COUNT(*) FROM CteGrupo WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Cat�logo de Grupos de Clientes')
SELECT @Cuenta = COUNT(*) FROM Cte WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Cat�logo de Clientes')
SELECT @Cuenta = COUNT(*) FROM Condicion WITH (NOLOCK) 
IF @Cuenta > 1
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta-1) + ' Registros en el Cat�logo de Condiciones')
SELECT @Cuenta = COUNT(*) FROM Descuento WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen ' + CONVERT(varchar, @Cuenta) + ' Registros en el Cat�logo de Descuentos')
SELECT @Cuenta = COUNT(*) FROM CteFam WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Cat�logo de Familias de Clientes')
SELECT @Cuenta = COUNT(*) FROM COMPRA WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Compras')
SELECT @Cuenta = COUNT(*) FROM COMPRAD WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen ' + CONVERT(varchar, @Cuenta) + ' Registros en Detalle de Compras')
SELECT @Cuenta = COUNT(*) FROM CTA WITH (NOLOCK) 
IF @Cuenta > 17
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta-17) + ' Registros en el Cat�logo de Cuentas')
SELECT @Cuenta = COUNT(*) FROM CXC WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen ' + CONVERT(varchar, @Cuenta) + ' Registros en Cuentas por Cobrar')
SELECT @Cuenta = COUNT(*) FROM CXP WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Cuentas por Pagar')
SELECT @Cuenta = COUNT(*) FROM SerieLote WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Series Lote')
SELECT @Cuenta = COUNT(*) FROM INV WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Movimientos de Inventarios')
SELECT @Cuenta = COUNT(*) FROM SerieLoteMov WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Movimientos de Serie Lote')
SELECT @Cuenta = COUNT(*) FROM INVD WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen ' + CONVERT(varchar, @Cuenta) + ' Registros en Detalle de Movimientos de Inventarios')
SELECT @Cuenta = COUNT(*) FROM Mon WITH (NOLOCK) 
IF @Cuenta > 1
INSERT INTO AspelWarnings (Descripcion) Values ('Existen ' + CONVERT(varchar, @Cuenta-1) + ' Registros en Cat�logos de Monedas')
SELECT @Cuenta = COUNT(*) FROM CONT WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en P�lizas')
SELECT @Cuenta = COUNT(*) FROM CONTD WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Detalles de P�lizas')
SELECT @Cuenta = COUNT(*) FROM ProvCat WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Cat�logo de Categor�as de Proveedores')
SELECT @Cuenta = COUNT(*) FROM ProvFam WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Cat�logo de Familias de Proveedores')
SELECT @Cuenta = COUNT(*) FROM Prov WITH (NOLOCK) 
IF @Cuenta > 6
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta-6) + ' Registros en el Cat�logo de Proveedores')
SELECT @Cuenta = COUNT(*) FROM ArtUnidad WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en el Cat�logo de Unidades de Art�culos')
SELECT @Cuenta = COUNT(*) FROM VENTA WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Ventas')
SELECT @Cuenta = COUNT(*) FROM VENTAD WITH (NOLOCK) 
IF @Cuenta > 0
INSERT INTO AspelWarnings (Descripcion) Values ('Existen  ' + CONVERT(varchar, @Cuenta) + ' Registros en Detalles de Ventas')
SELECT * FROM aspelwarnings WITH (NOLOCK) 
END

