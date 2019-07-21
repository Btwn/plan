SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW Cubo_SL

AS
SELECT
'Sucursal' 		= sl.Sucursal,
'SucursalNombre'	= s.Nombre,
'SucursalRegion' 	= s.Region,
'Empresa'		= sl.Empresa,
'EmpresaNombre'	= e.Nombre,
'EmpresaGrupo' 	= e.Grupo,
sl.Modulo,
'Articulo' 		= sl.Articulo,
'ArtNombre' 		= a.Descripcion1,
'ArtFamilia'		= a.Familia,
'ArtCategoria' 	= a.Categoria,
'ArtGrupo' 		= a.Grupo,
'ArtLinea' 		= a.Linea,
'ArtFabricante' 	= a.Fabricante,
'Opcion' 		= sl.SubCuenta,
'OpcionNombre'	= dbo.fnOpcion(sl.SubCuenta),
sl.SerieLote,
'Cliente' 		= sl.Cliente,
'ClienteNombre' 	= c.Nombre,
'ClienteFamilia' 	= c.Familia,
'ClienteCategoria' 	= c.Categoria,
'ClienteGrupo' 	= c.Grupo,
'ClienteTipo'		= c.Tipo,
Cantidad,
CantidadAlterna,
sl.Ubicacion,
Localizacion,
sl.Propiedades,
slp.Extra1,
slp.Extra2,
slp.Extra3,
'Caducidad'		= slp.Fecha1,
slp.Fecha2,
slp.Fecha3,
t.trimestre,
t.Semana,
'Mes'			= t.MesNombre,
'Año'			= t.Anio,
'DiaSemana'		= t.DiaNombre,
'Dia'			= CASE WHEN DATEPART(d, slp.Fecha1) < 10
THEN '0' + CONVERT(CHAR(1),DATEPART(d, slp.Fecha1))
ELSE RTRIM(CONVERT(CHAR(2),DATEPART(d, slp.Fecha1))) END ,
slp.PedimentoClave,
slp.PedimentoRegimen,
slp.ValorDolares,
slp.ValorAduana,
slp.ValorComercial,
slp.AgenteAduanal,
slp.Aduana,
slp.DTA,
slp.IVA,
slp.IGI,
'Almacen'		= NULL,
'AlmNombre' 		= NULL,
'AlmGrupo' 		= NULL,
'AlmCategoria' 	= NULL,
'Existencia'		= 0,
'ExistenciaAlterna'	= 0,
'ExistenciaActivoFijo'= 0,
'UltimaEntrada'	= NULL,
'UltimaSalida'	= NULL,
'Costo'		= 0,
'CostoInv'		= 0,
'CostoPromedio'	= 0,
'Dias'		= 0,
'Antigüedad'		= null
FROM
SerieLoteMov sl WITH (NOLOCK)
LEFT OUTER JOIN Empresa 	e WITH (NOLOCK) 	ON sl.Empresa  	= e.Empresa
LEFT OUTER JOIN Sucursal 	s WITH (NOLOCK)	ON sl.Sucursal 	= s.Sucursal
LEFT OUTER JOIN Art 		a WITH (NOLOCK)  	ON sl.Articulo 	= a.Articulo
LEFT OUTER JOIN Cte  		c WITH (NOLOCK)    	ON sl.Cliente  	= c.Cliente
LEFT OUTER JOIN SerieLoteProp	slp WITH (NOLOCK)   	ON sl.Propiedades= slp.Propiedades
LEFT OUTER JOIN Tiempo t WITH (NOLOCK)		ON YEAR(slp.Fecha1) = YEAR(t.Fecha)
AND MONTH(slp.Fecha1) = MONTH(t.Fecha)
AND DAY(slp.Fecha1) = DAY(t.Fecha)
UNION
SELECT
'Sucursal' 		= sl.Sucursal,
'SucursalNombre'	= s.Nombre,
'SucursalRegion' 	= s.Region,
'Empresa'		= sl.Empresa,
'EmpresaNombre'	= e.Nombre,
'EmpresaGrupo' 	= e.Grupo,
NULL,
'Articulo' 		= sl.Articulo,
'ArtNombre' 		= a.Descripcion1,
'ArtFamilia'		= a.Familia,
'ArtCategoria' 	= a.Categoria,
'ArtGrupo' 		= a.Grupo,
'ArtLinea' 		= a.Linea,
'ArtFabricante' 	= a.Fabricante,
'Opcion' 		= sl.SubCuenta,
'OpcionNombre'	= dbo.fnOpcion(sl.SubCuenta),
sl.SerieLote,
'Cliente' 		= sl.Cliente,
'ClienteNombre' 	= c.Nombre,
'ClienteFamilia' 	= c.Familia,
'ClienteCategoria' 	= c.Categoria,
'ClienteGrupo' 	= c.Grupo,
'ClienteTipo'		= c.Tipo,
0,
0,
NULL,
Localizacion,
sl.Propiedades,
slp.Extra1,
slp.Extra2,
slp.Extra3,
slp.Fecha1,
slp.Fecha2,
slp.Fecha3,
t.trimestre,
t.Semana,
'Mes'			= t.MesNombre,
'Año'			= t.Anio,
'DiaSemana'		= t.DiaNombre,
'Dia'			= CASE WHEN DATEPART(d, slp.Fecha1) < 10
THEN '0' + CONVERT(CHAR(1),DATEPART(d, slp.Fecha1))
ELSE RTRIM(CONVERT(CHAR(2),DATEPART(d, slp.Fecha1))) END ,
slp.PedimentoClave,
slp.PedimentoRegimen,
slp.ValorDolares,
slp.ValorAduana,
slp.ValorComercial,
slp.AgenteAduanal,
slp.Aduana,
slp.DTA,
slp.IVA,
slp.IGI,
sl.Almacen,
'AlmNombre' 		= al.Nombre,
'AlmGrupo' 		= al.Grupo,
'AlmCategoria' 	= al.Categoria,
Existencia,
ExistenciaAlterna,
ExistenciaActivoFijo,
UltimaEntrada,
UltimaSalida,
Costo,
CostoInv,
CostoPromedio,
'Dias'		= CASE WHEN Existencia > 0
THEN DATEDIFF(day,UltimaEntrada,GETDATE())
ELSE 0 END,
'Antigüedad'	 	= CASE	WHEN DATEDIFF(day, slp.Fecha1, GETDATE())<= 0
THEN 'Corriente'
WHEN DATEDIFF(day, slp.Fecha1, GETDATE())>= 1
AND DATEDIFF(day, slp.Fecha1, GETDATE())<= 30
THEN ' 1 - 30'
WHEN DATEDIFF(day, slp.Fecha1, GETDATE())>= 31
AND DATEDIFF(day, slp.Fecha1, GETDATE())<= 60
THEN '31 - 60'
WHEN DATEDIFF(day, slp.Fecha1, GETDATE())>= 61
AND DATEDIFF(day, slp.Fecha1, GETDATE())<= 90
THEN '61 - 90'
WHEN DATEDIFF(day, slp.Fecha1, GETDATE())>= 91
THEN '+ 90'    END
FROM
SerieLote sl WITH (NOLOCK)
LEFT OUTER JOIN Empresa 	e WITH (NOLOCK) 	ON sl.Empresa  	= e.Empresa
LEFT OUTER JOIN Sucursal 	s WITH (NOLOCK)	ON sl.Sucursal 	= s.Sucursal
LEFT OUTER JOIN Art 		a WITH (NOLOCK)  	ON sl.Articulo 	= a.Articulo
LEFT OUTER JOIN Cte  		c WITH (NOLOCK)    	ON sl.Cliente  	= c.Cliente
LEFT OUTER JOIN SerieLoteProp	slp WITH (NOLOCK)   	ON sl.Propiedades= slp.Propiedades
LEFT OUTER JOIN Alm 		al WITH (NOLOCK)    	ON sl.Almacen  	= al.Almacen
LEFT OUTER JOIN Tiempo t WITH (NOLOCK)		ON YEAR(slp.Fecha1) = YEAR(t.Fecha)
AND MONTH(slp.Fecha1) = MONTH(t.Fecha)
AND DAY(slp.Fecha1) = DAY(t.Fecha)

