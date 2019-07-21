SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPocket_ML
@Accion     Varchar(30) = '',
@Dato       Varchar(50) = '',
@Dato2      Varchar(50) = '',
@Dato3      Varchar(50) = '',
@Dato4      Varchar(50) = '',
@Dato5      Varchar(50) = ''

AS BEGIN
DECLARE
@Temp   VARCHAR(100),
@Temp2 int
SET DATEFORMAT DMY
SET NOCOUNT ON
IF @Accion = 'ALMACEN'
BEGIN
SELECT Almacen , Nombre, Tipo
FROM Alm
WHERE Tipo='Normal'
AND Estatus='ALTA'
END
IF @Accion = 'USUARIO'
BEGIN
SELECT Usuario, Contrasena, Nombre, Sucursal, DefEmpresa, DefAgente, DefAlmacen, DefCtaDinero, DefMoneda, BloquearPrecios, BloquearDescLinea  ,ModificarListaPrecios
FROM Usuario
WHERE Estatus='ALTA'
END
IF @Accion = 'USUARIOD'
BEGIN
SELECT Usuario, Empresa
FROM UsuarioD
END
IF @Accion = 'DESCUENTOS'
BEGIN
SELECT Descuento, Porcentaje
FROM Descuento
END
IF @Accion = 'CONDICIONES'
BEGIN
SELECT Condicion, TipoCondicion, DiasVencimiento, Interes
FROM Condicion
WHERE TipoCondicion <> ''
END
IF @Accion = 'CLIENTE'
BEGIN
SELECT Cliente, Nombre, Direccion, EntreCalles, Delegacion, Colonia, Poblacion,
Estado, Pais,  CodigoPostal, RFC, Telefonos, Contacto1, eMail1, Credito,
ZonaImpuesto, Descuento, Agente,  ListaPrecios, ListaPreciosEsp, DefMoneda,
CreditoLimite, Cobrador, AlmacenDef, SucursalEmpresa,
FormasPagoRestringidas, BloquearMorosos, Condicion , 9283 as 'IDRuta', 'mexico' as 'Ruta', '09/05/2010' as 'DiaVisita'
FROM Cte
WHERE Estatus='ALTA'
AND Tipo='Cliente'
END
IF @Accion = 'ARTICULO'
BEGIN
SELECT Art.Articulo, Art.Descripcion1, Art.Grupo, Art.Categoria, Art.Familia, Art.Linea,
Art.Impuesto1, Art.Impuesto2, Art.Impuesto3,
Art.Unidad, Art.UnidadCantidad, Art.Peso, Art.Tipo, Art.TipoOpcion, Art.MonedaPrecio,
Art.PrecioLista, Art.PrecioMinimo, Art.Unidad, Art.AlmacenROP, Art.Precio2 , Art.Precio3, Art.Precio4, Art.Precio5,
Art.Precio6, Art.Precio7, Art.Precio8, Art.Precio9, Art.Precio10, Art.Utilidad,
Art.AlmacenROP, 100 As Disponible,  Art.Estatus
FROM Art
WHERE ESTATUS = 'ALTA'
END
IF @Accion = 'UNIDAD'
BEGIN
SELECT dbo.ListaPreciosDUnidad.Articulo, dbo.ListaPreciosDUnidad.Lista, dbo.ListaPreciosDUnidad.Unidad, dbo.ListaPreciosDUnidad.Precio
FROM dbo.ListaPreciosDUnidad INNER JOIN
dbo.Art ON dbo.ListaPreciosDUnidad.Articulo = dbo.Art.Articulo
WHERE (dbo.Art.Estatus = 'ALTA')
ORDER BY ListaPreciosDUnidad.Articulo, ListaPreciosDUnidad.Lista, ListaPreciosDUnidad.Unidad
END
IF @Accion = 'DESCUENTOS'
BEGIN
SELECT Descuento, Porcentaje
FROM Descuento
END
IF @Accion = 'CXC'
BEGIN
SELECT c.Movid, c.Vencimiento, c.Mov, c.Cliente, t.Nombre,
c.Saldo * m.Factor as Cargo, c.Empresa
FROM Cxc c, MovTipo m, Cte t
WHERE c.Cliente = t.Cliente
AND c.Mov = m.Mov
AND m.Modulo = 'CXC'
AND m.clave  IN ('CXC.F', 'CXC.D')
AND c.Estatus = 'PENDIENTE'
END
IF @Accion = 'EMPRESA'
BEGIN
SELECT VentaPreciosImpuestoIncluido, Empresa , FacturasPendientes, (SELECT top 1 DefImpuesto From EmpresaGral) as 'DefImpuesto'
FROM EmpresaCFG
END
IF @Accion = 'CONDICIONES'
BEGIN
SELECT Condicion, TipoCondicion, DiasVencimiento, Interes
FROM Condicion
WHERE TipoCondicion <> ''
END
IF @Accion = 'LISTAPRECIOS'
BEGIN
SELECT dbo.ListaPreciosEsp.Lista, dbo.ListaPrecios.Descripcion
FROM dbo.ListaPreciosEsp FULL OUTER JOIN
dbo.ListaPrecios ON dbo.ListaPreciosEsp.Lista = dbo.ListaPrecios.Lista
END
IF @Accion = 'SERIELOTE'
BEGIN
SELECT SerieLote, (CASE WHEN Existencia  IS null THEN 0 ELSE Existencia END) as Existencia FROM SerieLote
WHERE Articulo = @Dato
AND Almacen = @Dato2
END
IF @Accion = 'CLIENTE_BUSQUEDA'
IF @Dato='Cliente'
BEGIN
SELECT COUNT(Cliente)
FROM Cte
WHERE Estatus = 'ALTA'
AND Tipo = 'Cliente'
AND Cliente like '%' + @Dato2 + '%'
END
ELSE
BEGIN
SELECT COUNT(Cliente)
FROM Cte
WHERE Estatus = 'ALTA'
AND Tipo = 'Cliente'
AND Nombre like '%' + @Dato2 + '%'
END
IF @Accion = 'CLIENTE_RES_BUSQUEDA'
IF @Dato='Cliente'
BEGIN
SELECT '00000', 'Nueva Busqueda'
UNION ALL
SELECT Cliente, RTRIM(Cliente) + ' - ' + Nombre
FROM Cte
WHERE Estatus = 'ALTA'
AND Tipo = 'Cliente'
AND Cliente like '%' + @Dato2 + '%'
END
ELSE
BEGIN
SELECT '0000', 'Nueva Busqueda'
UNION ALL
SELECT Cliente, RTRIM(Cliente) + ' - ' + Nombre
FROM Cte
WHERE Estatus = 'ALTA'
AND Tipo = 'Cliente'
AND Nombre like '%' + @Dato2 + '%'
END
IF @Accion = 'CLIENTE_CLIENTE'
BEGIN
SELECT Cliente, Nombre, Agente,AlmacenDef, Cobrador,CodigoPostal,Colonia, Contacto1,Credito,CreditoLimite,DefMoneda,Delegacion,Descuento,Direccion, eMail1,EntreCalles, Estado, ListaPreciosEsp, Pais,Poblacion,RFC,SucursalEmpresa,Telefonos, ZonaImpuesto, Condicion
FROM Cte
WHERE Estatus = 'ALTA'
AND Tipo = 'Cliente'
AND Cliente = @Dato
END
IF @Accion = 'ARTICULO_RES_BUSQUEDA'
BEGIN
IF @Dato4 like '%Pedido%'
BEGIN
IF @Dato='Articulo'
BEGIN
SELECT CASE WHEN Art.Articulo IS NULL THEN '' ELSE Art.Articulo END AS Articulo,
CASE WHEN Art.Articulo IS NULL THEN '' ELSE Art.Articulo END AS Expr1,
CASE WHEN Descripcion1 IS NULL THEN '' ELSE Descripcion1 END AS Expr2, CASE WHEN Familia IS NULL THEN '' ELSE Familia END AS Expr3, CASE WHEN Grupo IS NULL
THEN '' ELSE Grupo END AS Expr4, CASE WHEN Linea IS NULL THEN '' ELSE Linea END AS Expr5, CASE WHEN AlmacenROP IS NULL
THEN '' ELSE AlmacenROP END AS Expr6, CASE WHEN Peso IS NULL THEN '' ELSE Peso END AS Expr7, CASE WHEN PrecioLista IS NULL
THEN '' ELSE PrecioLista END AS Expr8, CASE WHEN Tipo IS NULL THEN '' ELSE Tipo END AS Expr9, CASE WHEN Unidad IS NULL
THEN '' ELSE Unidad END AS Expr10,
CONVERT(varchar (30), CONVERT(money,SUM(CASE WHEN Disponible IS NULL OR Disponible = 0  THEN '0' ELSE Disponible END)),1) AS Expr11
FROM Art LEFT OUTER JOIN
ArtExistenciaReservado ON Art.Articulo = ArtExistenciaReservado.Articulo
WHERE (Art.Estatus = 'ALTA') and PrecioLista>0
GROUP BY Art.Articulo,
CASE WHEN Unidad IS NULL THEN '' ELSE Unidad END, CASE WHEN Tipo IS NULL THEN '' ELSE Tipo END,
CASE WHEN PrecioLista IS NULL THEN '' ELSE PrecioLista END, CASE WHEN Peso IS NULL THEN '' ELSE Peso END,
CASE WHEN AlmacenROP IS NULL THEN '' ELSE AlmacenROP END, CASE WHEN Linea IS NULL THEN '' ELSE Linea END,
CASE WHEN Grupo IS NULL THEN '' ELSE Grupo END,
CASE WHEN Familia IS NULL THEN '' ELSE Familia END,
CASE WHEN Descripcion1 IS NULL THEN '' ELSE Descripcion1 END,
CASE WHEN Art.Articulo IS NULL THEN '' ELSE Art.Articulo END
HAVING (Art.Articulo LIKE '%' + @Dato2 + '%')
ORDER BY Art.Articulo
END
ELSE
BEGIN
SELECT CASE WHEN Art.Articulo IS NULL THEN '' ELSE Art.Articulo END AS Articulo,
CASE WHEN Art.Articulo IS NULL THEN '' ELSE Art.Articulo END AS Expr1,
CASE WHEN Descripcion1 IS NULL THEN '' ELSE Descripcion1 END AS Expr2,
CASE WHEN Familia IS NULL THEN '' ELSE Familia END AS Expr3,
CASE WHEN Grupo IS NULL THEN '' ELSE Grupo END AS Expr4,
CASE WHEN Linea IS NULL THEN '' ELSE Linea END AS Expr5,
CASE WHEN AlmacenROP IS NULL THEN '' ELSE AlmacenROP END AS Expr6,
CASE WHEN Peso IS NULL THEN '' ELSE Peso END AS Expr7,
CASE WHEN PrecioLista IS NULL THEN '' ELSE PrecioLista END AS Expr8,
CASE WHEN Tipo IS NULL THEN '' ELSE Tipo END AS Expr9,
CASE WHEN Unidad IS NULL THEN '' ELSE Unidad END AS Expr10,
CONVERT(varchar (30), CONVERT(money,SUM(CASE WHEN Disponible IS NULL OR Disponible = 0 THEN '0' ELSE Disponible END)),1) AS Expr11
FROM Art LEFT OUTER JOIN
ArtExistenciaReservado ON Art.Articulo = ArtExistenciaReservado.Articulo
WHERE (Art.Estatus = 'ALTA') AND PrecioLista > 0
GROUP BY Art.Articulo, Descripcion1,
CASE WHEN Unidad IS NULL THEN '' ELSE Unidad END,
CASE WHEN Tipo IS NULL THEN '' ELSE Tipo END,
CASE WHEN PrecioLista IS NULL THEN '' ELSE PrecioLista END,
CASE WHEN Peso IS NULL THEN '' ELSE Peso END,
CASE WHEN AlmacenROP IS NULL THEN '' ELSE AlmacenROP END,
CASE WHEN Linea IS NULL THEN '' ELSE Linea END,
CASE WHEN Grupo IS NULL THEN '' ELSE Grupo END, CASE WHEN Familia IS NULL THEN '' ELSE Familia END,
CASE WHEN Descripcion1 IS NULL THEN '' ELSE Descripcion1 END,
CASE WHEN Art.Articulo IS NULL THEN '' ELSE Art.Articulo END
HAVING (Art.Descripcion1 LIKE '%' + @Dato2 + '%')
ORDER BY Art.Articulo
END
END
ELSE
BEGIN
IF @Dato = 'Articulo'
BEGIN
SELECT CASE WHEN Articulo IS NULL THEN '' ELSE Articulo END,
CASE WHEN Articulo IS NULL THEN '' ELSE Articulo END,
CASE WHEN Descripcion1 IS NULL THEN '' ELSE Descripcion1 END,
CASE WHEN Familia  IS NULL THEN '' ELSE Familia END,
CASE WHEN Grupo IS NULL THEN '' ELSE Grupo END,
CASE WHEN Linea IS NULL THEN '' ELSE Linea END,
CASE WHEN AlmacenROP IS NULL THEN '' ELSE AlmacenROP END,
CASE WHEN Peso IS NULL THEN '' ELSE Peso END,
CASE WHEN PrecioLista IS NULL THEN '' ELSE PrecioLista END,
CASE WHEN Tipo IS NULL THEN '' ELSE Tipo END,
CASE WHEN Unidad  IS NULL THEN '' ELSE Unidad END
FROM Art
WHERE Art.Estatus = 'ALTA' AND PrecioLista > 0
AND Art.Articulo like  '%' + @Dato2 + '%'
ORDER BY  Art.Articulo
END
ELSE
BEGIN
SELECT CASE WHEN Articulo IS NULL THEN '' ELSE Articulo END,
CASE WHEN Articulo IS NULL THEN '' ELSE Articulo END,
CASE WHEN Descripcion1 IS NULL THEN '' ELSE Descripcion1 END,
CASE WHEN Familia  IS NULL THEN '' ELSE Familia END,
CASE WHEN Grupo IS NULL THEN '' ELSE Grupo END,
CASE WHEN Linea IS NULL THEN '' ELSE Linea END,
CASE WHEN AlmacenROP IS NULL THEN '' ELSE AlmacenROP END,
CASE WHEN Peso IS NULL THEN '' ELSE Peso END,
CASE WHEN PrecioLista IS NULL THEN '' ELSE PrecioLista END,
CASE WHEN Tipo IS NULL THEN '' ELSE Tipo END,
CASE WHEN Unidad  IS NULL THEN '' ELSE Unidad END
FROM Art
WHERE Art.Estatus = 'ALTA' AND PrecioLista > 0
AND Descripcion1 like  '%' + @Dato2 + '%'
ORDER BY Art.Articulo
END
END
END
IF @Accion = 'ARTICULO_ARTICULO'
BEGIN
SELECT CASE WHEN Articulo IS NULL THEN '' ELSE Articulo END,
CASE WHEN Descripcion1 IS NULL THEN '' ELSE Descripcion1 END,
CASE WHEN Familia  IS NULL THEN '' ELSE Familia END,
CASE WHEN Grupo IS NULL THEN '' ELSE Grupo END,
CASE WHEN Linea IS NULL THEN '' ELSE Linea END,
CASE WHEN AlmacenROP IS NULL THEN '' ELSE AlmacenROP END,
CASE WHEN Peso IS NULL THEN '' ELSE Peso END,
CASE WHEN PrecioLista IS NULL THEN '' ELSE PrecioLista END,
CASE WHEN Tipo IS NULL THEN '' ELSE Tipo END,
CASE WHEN Unidad  IS NULL THEN '' ELSE Unidad END
FROM Art
WHERE ESTATUS = 'ALTA'
AND Articulo like  '%' + @Dato + '%'
ORDER BY Articulo
END
IF @Accion = 'CXC_RES_BUSQUEDA'
BEGIN
SELECT '0000', 'Nueva Busqueda'
UNION ALL
SELECT t.Cliente, RTRIM(t.Cliente) + ' - ' + t.Nombre
FROM Cxc c, MovTipo m, Cte t
WHERE c.Cliente = t.Cliente
AND c.Mov = m.Mov
AND m.Modulo = 'CXC'
AND m.clave  IN ('CXC.F', 'CXC.D')
AND c.Estatus = 'PENDIENTE'
AND t.Agente = (SELECT u.DefAgente FROM Usuario u WHERE u.Usuario = @Dato)
GROUP BY t.Cliente, RTRIM(t.Cliente) + ' - ' + t.Nombre
END
IF @Accion = 'VALIDAUSUARIO'
BEGIN
SET @Temp = (SELECT Nombre FROM Usuario WHERE Usuario = @Dato AND Estatus = 'Alta')
IF @Temp IS NULL
SET @Temp2 = 5/0
IF (SELECT COUNT(Sucursal)+COUNT(DefEmpresa) FROM Usuario WHERE Usuario = @Dato) <> 2
SET @Temp2 = 5/0
RETURN
END
END

