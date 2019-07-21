SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPreparaPantallaVista @Empresa char(5)

AS BEGIN
DECLARE
@IDMovilVista INT
IF NOT EXISTS(SELECT * FROM MovilPantallaVista WHERE Empresa = @Empresa AND Pantalla = 'Clientes')
BEGIN
SET @IDMovilVista = 0
INSERT INTO MovilPantallaVista(Empresa,Pantalla,Vista)VALUES(@Empresa,'Clientes','Movil_Cliente')
SELECT @IDMovilVista = @@IDENTITY
IF ISNULL(@IDMovilVista,0) <> 0
BEGIN
INSERT MovilVistaCampo(IDMovilVista,  Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'AlmacenDef', 0,              'Sucursal',      0,         1,       'Sucursal', 1,       6,     'Texto', 20,       1, 0)
INSERT MovilVistaCampo(IDMovilVista,  Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Contacto2', 0,              'Contacto2',      0,         1,       'Contacto 2', 1,       7,     'Texto', 20,       1, 1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_Cliente', 1,              'Cte',      0,         1,       'Clave Cliente', 1,       1,     'Texto', 20,       1,        0)
INSERT MovilVistaCampo(IDMovilVista,  Campo,        NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,   Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_Nombre', 1,              'Nombre', 1,         1,       'Nombre',     1,       2,   'Texto', 90,       1,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,        NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,   Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_Telefonos', 1,           'Telefonos', 1,         1,       'Teléfono', 1,       3,    'Texto', 19,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,        NecesarioMovil, Llave,          Requerido, Visible, Etiqueta,       Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_CodigoPostal', 1,        'CodigoPostal', 1,         1,      'Código Postal', 1,       4,    'Texto',  7,        0,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,        NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,   Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_RFC',    1,              'RFC',      1,         1,       'RFC',      1,       5,    'Texto',  120,      0,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,        NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,   Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Saldo',      0,             'Saldo',     0,         1,       'Saldo',    1,        6,    'Moneda', 20,      0,        0)
INSERT MovilVistaCampo(IDMovilVista,  Campo,        NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,     Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_Direccion', 1,           'Direccion', 0,         1,      'Dirección',  2,       1,    'Texto',  100,           0,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,                 NecesarioMovil, Llave,             Requerido, Visible, Etiqueta,   Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_DireccionNumero', 1,              'DireccionNumero', 0,         1,       'Exterior', 2,       2,    'Texto', 15,        0,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,                    NecesarioMovil, Llave,                Requerido, Visible, Etiqueta,   Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_DireccionNumeroInt', 1,              'DireccionNumeroInt', 0,         1,       'Interior', 2,       3,     'Texto', 15,      0,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,        NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,     Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_Delegacion', 1,          'Delegacion', 0,         1,     'Delegación', 2,       4,    'Texto', 50,           0,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,        NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,   Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_Colonia', 1,             'Colonia', 0,         1,       'Colonia',   2,       5,    'Texto', 30,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,        NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,   Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_Poblacion', 1,           'Poblacion', 0,        1,      'Población', 2,       6,    'Texto', 50,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,          NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,   Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_Estado', 1,              'Estado',     0,         1,       'Estado',   2,       7,    'Texto', 30,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,      NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,   Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_Pais', 1,              'Pais',     0,         1,       'País',     2,       8,     'Texto', 20,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,        NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,   Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_Contacto1', 1,           'Contacto1', 0,         1,       'Contacto 1', 3,       1,   'Texto', 90,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,               NecesarioMovil, Llave,           Requerido, Visible, Etiqueta,            Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_CreditoLimite', 1,              'CreditoLimite', 0,         1,       'Límite de Crédito', 3,       2,    'Moneda', 90,       0,        0)
INSERT MovilVistaCampo(IDMovilVista,  Campo,           NecesarioMovil, Llave,       Requerido,  Visible, Etiqueta,            Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_Condicion', 0,              'Condicion', 0,          1,       'Condicion de Pago', 3,       3,     'Texto', 10,       0,        0)
INSERT MovilVistaCampo(IDMovilVista,  Campo,           NecesarioMovil, Llave,       Requerido, Visible, Etiqueta,   Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_DefMoneda', 0,              'DefMoneda', 0,          1,       'Moneda',  3,       4,     'Texto', 10,       0,        0)
INSERT MovilVistaCampo(IDMovilVista,  Campo,        NecesarioMovil, Llave,    Requerido, Visible, Etiqueta,             Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_eMail1', 1,              'eMail1', 0,         1,       'Correo Electrónico', 3,       5,     'eMail', 90,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,             NecesarioMovil, Llave,         Requerido, Visible, Etiqueta,       Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_EntreCalles', 0,              'EntreCalles', 0,         1,       'Entre Calles', 3,       6,    'Texto', 10,      0,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,        NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,   Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_Extencion1', 0,          'Extencion1', 0,         1,       'Extensión', 3,     7,    'Texto', 10,      0,        1)
INSERT MovilVistaCampo(IDMovilVista,  Campo,        NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,   Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cte_Observaciones', 0,       'Observaciones', 0,         1,       'Observaciones', 3,8,    'Texto', 10,    0,        1)
END
END
IF NOT EXISTS(SELECT * FROM MovilPantallaVista WHERE Empresa = @Empresa AND Pantalla = 'Articulos')
BEGIN
SET @IDMovilVista = 0
INSERT INTO MovilPantallaVista(Empresa,Pantalla,Vista)VALUES(@Empresa,'Articulos','Movil_ArtAgenteMovil')
SELECT @IDMovilVista = @@IDENTITY
IF ISNULL(@IDMovilVista,0) <> 0
BEGIN
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista,	'Art_Almacen',  0,              'Almacen',  1,         1,       'Almacén',       2,       2,     'Texto', 30,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Art_Articulo', 0,              'Articulo',	1,	       1,	    'Clave Artículo',1,       1,    'Texto',  20,       1,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato,       Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Art_Categoria',0,	            'Categoria',1,         1,       'Categoría',     1,       4,     'Fecha/Hora',  20,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Art_Descripcion1',0,       	'Descripcion1',1,      1,       'Descripción',   1,       2,     'Texto', 50,       1,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Art_Descripcion2',0,       	'Descripcion2',1,      1,       'Descripción Corta',1,    3,     'Número',15,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Art_Disponible',0,             'Disponible',1,        1,       'Disponibilidad',2,	      3,     'Número',10,		0,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Art_Estatus',  0,              'Estatus',	0,	       1,       'Estatus',       2,       8,     'Texto', 15,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Art_Existencia',0,             'Existencia',0,        1,      'Existencia',	 3,       1,     'Número',10,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Art_Familia',  0,              'Familia',	1,	       1,       'Familia',       2,       6,     'Texto', 20,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Art_Grupo',  	0,              'Grupo',	1,         1,       'Grupo',         2,       4,     'Texto', 30,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Art_Linea',  	0,              'Linea',    1,         1,       'Línea',         2,       5,     'Texto', 20,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Art_PrecioLista',0,            'PrecioLista',0,       1,       'Precio de Lista',2,      7,     'Número',10,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Art_Tipo',  	0,              'Tipo',	    1,         1,       'Tipo',          2,       1,     'Texto', 20,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Art_Unidad',  	0,              'Unidad',	1,         1,       'Unidad',        1,       5,     'Texto', 5,        0,        1)
END
END
IF NOT EXISTS(SELECT * FROM MovilPantallaVista WHERE Empresa = @Empresa AND Pantalla = 'Cobros')
BEGIN
SET @IDMovilVista = 0
INSERT INTO MovilPantallaVista(Empresa,Pantalla,Vista)VALUES(@Empresa,'Cobros','Movil_Cobro')
SELECT @IDMovilVista = @@IDENTITY
IF ISNULL(@IDMovilVista,0) <> 0
BEGIN
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista,	'Cobro_Forma',  1,              'Forma',    1,         1,       'Forma',         1,       1,     'Combo', 30,       1,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cobro_Importe',1,              'Importe',	1,	       1,	    'Importe',       1,       2,     'Moneda',20,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cobro_Moneda', 1,	            'Moneda',   1,         1,       'Moneda',        1,       3,     'Combo', 30,       1,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cobro_Concepto',1,       	    'Concepto', 0,         1,       'Concepto',      1,       4,     'Combo', 30,       1,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cobro_Referencia',1,       	'Referencia',0,        1,       'Referencia',    1,       5,     'Texto', 50,       1,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cobro_Observaciones',1,       	'Observaciones',0,       1,     'Observaciones',  1,      6,     'Texto', 100,       0,        1)
INSERT MovilVistaCampo(IDMovilVista,   Campo,         NecesarioMovil, Llave,      Requerido, Visible, Etiqueta,        Seccion, Orden, Formato, Longitud, Busqueda, Editable)
VALUES(@IDMovilVista, 'Cobro_AutoAplicar',1,       	'AutoAplicar',0,       1,       'Auto Aplicar',  1,       7,     'Si/No', 10,       0,        1)
END
END
END

