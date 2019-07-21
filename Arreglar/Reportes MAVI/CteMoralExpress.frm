[Forma]
Clave=CteMoralExpress
Nombre=Agregar Cliente
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=331
PosicionInicialArriba=240
PosicionInicialAltura=393
PosicionInicialAncho=617
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Cancelar<BR>Buscar<BR>ListaNegra<BR>ListaNegraZonas
PosicionInicialAlturaCliente=286
ExpresionesAlMostrar=Asigna(Info.Cliente, Nulo)<BR>Asigna(CteX.Clave, General.CteExpressDef)<BR>Asigna(CteX.Delegacion, nulo)<BR>Asigna(CteX.Colonia, nulo)<BR>Asigna(CteX.CP, nulo)<BR>Asigna(CteX.Direccion, nulo)<BR>Asigna(CteX.Estado, nulo)<BR>Asigna(CteX.Nombre, nulo)<BR>Asigna(CteX.Pais, nulo)<BR>Asigna(CteX.Poblacion, nulo)<BR>Asigna(CteX.RFC, nulo)<BR>Asigna(CteX.Telefonos, nulo)<BR>Asigna(CteX.Contacto, nulo)<BR>Asigna(CteX.eMail, nulo)<BR>Asigna(CteX.Categoria, General.CteExpressCategoria)<BR>Asigna(CteX.Grupo, nulo)<BR>Asigna(CteX.Familia, nulo)<BR>Asigna(CteX.Ruta, nulo)<BR>Asigna(CteX.Agente, Usuario.DefAgente)<BR>Asigna(CteX.Comentarios, nulo)<BR>Asigna(CteX.Cuenta, nulo)<BR>Asigna(CteX.PersonalNombres, nulo)<BR>Asigna(CteX.PersonalApellidoPaterno, nulo)<BR>Asigna(CteX.PersonalApellidoMaterno, nulo)<CONTINUA>
ExpresionesAlMostrar002=<CONTINUA><BR>Asigna(CteX.ClaveCanal, Nulo)<BR>Asigna(Info.ClaveDeCanal, nulo)<BR>Asigna(Info.CadenaCanal, nulo)<BR>Asigna(Info.CategoriaCanal, nulo)<BR>Asigna(CteX.DireccionNumero, nulo)<BR>Asigna(CteX.DireccionNumeroInt, nulo)<BR>Asigna(CteX.TipoCalle, nulo)<BR>Asigna(CteX.TelefonosCelulares, nulo)<BR>Asigna(Afectar.ID, Nulo)
ExpresionesAlCerrar=Asigna(Info.Copiar, falso)

[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=4
FichaEspacioNombres=81
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
ListaEnCaptura=CteX.Nombre<BR>CteX.RFC<BR>CteX.TipoCalle<BR>CteX.Direccion<BR>CteX.DireccionNumero<BR>CteX.DireccionNumeroInt<BR>CteX.CP<BR>CteX.Delegacion<BR>CteX.Colonia<BR>CteX.Poblacion<BR>CteX.Estado<BR>CteX.Pais<BR>CteX.Telefonos<BR>CteX.TelefonosCelulares<BR>CteX.Contacto<BR>CteX.eMail<BR>CteX.ClaveCanal<BR>CteX.Clave
PermiteEditar=S


[(Variables).CteX.Clave]
Carpeta=(Variables)
Clave=CteX.Clave
Editar=S
LineaNueva=N
ValidaNombre=N
3D=S
Tamano=0
EspacioPrevio=N
IgnoraFlujo=S
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).CteX.Nombre]
Carpeta=(Variables)
Clave=CteX.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=62
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).CteX.RFC]
Carpeta=(Variables)
Clave=CteX.RFC
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=21
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).CteX.Telefonos]
Carpeta=(Variables)
Clave=CteX.Telefonos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).CteX.Direccion]
Carpeta=(Variables)
Clave=CteX.Direccion
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=41
EspacioPrevio=N
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).CteX.Poblacion]
Carpeta=(Variables)
Clave=CteX.Poblacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).CteX.CP]
Carpeta=(Variables)
Clave=CteX.CP
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).CteX.Pais]
Carpeta=(Variables)
Clave=CteX.Pais
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).CteX.Estado]
Carpeta=(Variables)
Clave=CteX.Estado
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).CteX.Colonia]
Carpeta=(Variables)
Clave=CteX.Colonia
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Guardar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Guardar.SQL]
Nombre=SQL
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=Si(EsNumerico(CteX.ClaveCanal),<T><T>,Si(Error(<T>El canal de venta debe de ser un dato numerico<T>,BotonAceptar)=BotonAceptar, AbortarOperacion,AbortarOperacion))<BR>Si(SQL(<T>Select count(*) from VentasCanalMAVI where ID=:n<T>,CteX.ClaveCanal)<=0,Si(Precaucion(<T>Seleccione un canal de venta correcto<T>, BotonCancelar)=BotonCancelar, AbortarOperacion))<BR>Asigna(Info.Cliente, Nulo)<BR>Si<BR>  SQL(<T>SELECT COUNT(*) FROM ListaNegraColonia WHERE Colonia=:tColonia<T>, CteX.Colonia)>0<BR>Entonces<BR>  Si(Precaucion(<T>No Es posible Entregar en esa Colonia.<T>+NuevaLinea+<T>Favor de Revisar la Lista Negra.<T>+NuevaLinea+NuevaLinea+NuevaLinea+<T>¿ Desea Agregar el Cliente ?<T>, BotonNo, BotonSi)<>BotonSi, AbortarOperacion)<BR>Fin<BR><BR>Asigna(Info.Cliente,<BR>SQL(<T>spAgregarClienteExpress :t<CONTINUA>
Expresion002=<CONTINUA>TC, :tNum, :tNumInt, :tCel, :tFR, :tClave, :tNom, :tDir, :tDel, :tCol, :tRuta, :tPob, :tEstado, :tPais, :tCP, :tRFC, :tTel, :tContacto, :teMail, :tCat, :tGrupo, :tFam, :tAgente, :tTipo, :tComenta, :tMon, :tPre, :tLike, :nDig, :tCond, :tCredito, :nCPID, :tEmp, :tCta, :tNombres, :tPaterno, :tMaterno, @Sucursal=:nSucursal<T>,<BR>CteX.TipoCalle, CteX.DireccionNumero, CteX.DireccionNumeroInt, CteX.TelefonosCelulares, Info.TipoCteExpress, CteX.Clave, CteX.Nombre, CteX.Direccion, CteX.Delegacion, CteX.Colonia, CteX.Ruta, CteX.Poblacion, CteX.Estado, CteX.Pais, CteX.CP,<BR>CteX.RFC, CteX.Telefonos, CteX.Contacto, CteX.eMail, CteX.Categoria, CteX.Grupo, CteX.Familia, CteX.Agente, Info.Tipo, CteX.Comentarios, Config.ContMoneda,<BR>General.CteExpressPrefijo, General.CteExpressPrefijo+<T>[0-9]%<T>, Ge<CONTINUA>
Expresion003=<CONTINUA>neral.CteExpressDigitos, General.DefCondicion, General.DefCredito, Afectar.ID, Empresa, CteX.Cuenta, CteX.PersonalNombres, CteX.PersonalApellidoPaterno, CteX.PersonalApellidoMaterno, Sucursal))<BR><BR>Si<BR>  ConDatos(Info.Cliente)<BR>Entonces<BR>  EjecutarSQLLocal(<T>spAgregarClienteExpress :tTC, :tNum, :tNumInt, :tCel, :tFR, :tClave, :tNom, :tDir, :tDel, :tCol, :tRuta, :tPob, :tEstado, :tPais, :tCP, :tRFC, :tTel, :tContacto, :teMail, :tCat, :tGrupo, :tFam, :tAgente, :tTipo, :tComenta, :tMon, :tPre, :tLike, :nDig, :tCond, :tCredito, :nCPID, :tEmp, :tCta, :tNombres, :tPaterno, :tMaterno, @Sucursal=:nSucursal<T>,<BR>  CteX.TipoCalle, CteX.DireccionNumero, CteX.DireccionNumeroInt, CteX.TelefonosCelulares, Info.TipoCteExpress, Info.Cliente, CteX.Nombre, CteX.Direccion, CteX.Delegacion, CteX.C<CONTINUA>
Expresion004=<CONTINUA>olonia, CteX.Ruta, CteX.Poblacion, CteX.Estado, CteX.Pais, CteX.CP,<BR>  CteX.RFC, CteX.Telefonos, CteX.Contacto, CteX.eMail, CteX.Categoria, CteX.Grupo, CteX.Familia, CteX.Agente, Info.Tipo, CteX.Comentarios, Config.ContMoneda,<BR>  General.CteExpressPrefijo, General.CteExpressPrefijo+<T>[0-9]%<T>, General.CteExpressDigitos, General.DefCondicion, General.DefCredito, Afectar.ID, Empresa, CteX.Cuenta, CteX.PersonalNombres, CteX.PersonalApellidoPaterno, CteX.PersonalApellidoMaterno, Sucursal)<BR>  Asigna(Info.ClaveDeCanal,SQL(<T>Select Clave from VentasCanalMAVI where ID=:nID<T>,Ctex.ClaveCanal))<BR>  Asigna(Info.CadenaCanal,SQL(<T>Select Cadena from VentasCanalMAVI where ID=:nID<T>,Ctex.ClaveCanal))<BR>  Vacio(Info.CadenaCanal,<T><T>)<BR>  Asigna(Info.CategoriaCanal,SQL(<T>Select Categoria <CONTINUA>
Expresion005=<CONTINUA>from VentasCanalMAVI where ID=:nID<T>,Ctex.ClaveCanal))<BR>  Vacio(Info.CategoriaCanal,<T><T>)<BR>  EjecutarSQL(<T>spInsertarSucursal_MAVI :tcte, :nCanal, :tNom, :tDir, :tcol, :tCP, :tclave, :tcadena, :tcat<T>,Info.Cliente,CteX.ClaveCanal,CteX.Nombre,CteX.Direccion,CteX.Colonia,CteX.CP,Info.ClaveDeCanal,Info.CadenaCanal,Info.CategoriaCanal)<BR>Fin
EjecucionCondicion=ConDatos(CteX.Nombre)

[Acciones.Guardar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=ConDatos(CteX.Nombre) y ConDatos(Info.Cliente)

[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=<T>&Cancelar<T>
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S



[Acciones.Guardar]
Nombre=Guardar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
ListaAccionesMultiples=Variables Asignar<BR>SQL<BR>Cerrar
Activo=S
Visible=S

[Acciones.Buscar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Buscar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Aceptar
ConCondicion=S
EjecucionCondicion=Forma(<T>CteExpressLista<T>)

[Acciones.Buscar]
Nombre=Buscar
Boton=51
NombreEnBoton=S
NombreDesplegar=&Buscar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
Activo=S
Visible=S

[(Variables).CteX.Ruta]
Carpeta=(Variables)
Clave=CteX.Ruta
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S

[(Variables).CteX.Contacto]
Carpeta=(Variables)
Clave=CteX.Contacto
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
EspacioPrevio=N
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).CteX.eMail]
Carpeta=(Variables)
Clave=CteX.eMail
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro



[Acciones.ListaNegra]
Nombre=ListaNegra
Boton=22
NombreEnBoton=S
NombreDesplegar=&Lista Negra Ctos
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=ListaNegraLista
Activo=S
Visible=S

[(Variables).CteX.Delegacion]
Carpeta=(Variables)
Clave=CteX.Delegacion
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


[Acciones.ListaNegraZonas]
Nombre=ListaNegraZonas
Boton=22
NombreEnBoton=S
NombreDesplegar=Lista Negra Zonas
EnBarraHerramientas=S
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=ListaNegraColoniaLista

[(Variables).CteX.Cuenta]
Carpeta=(Variables)
Clave=CteX.Cuenta
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro





[(Variables).CteX.ClaveCanal]
Carpeta=(Variables)
Clave=CteX.ClaveCanal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
[(Variables).CteX.DireccionNumero]
Carpeta=(Variables)
Clave=CteX.DireccionNumero
Editar=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
ValidaNombre=S
[(Variables).CteX.DireccionNumeroInt]
Carpeta=(Variables)
Clave=CteX.DireccionNumeroInt
Editar=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
ValidaNombre=S
[(Variables).CteX.TipoCalle]
Carpeta=(Variables)
Clave=CteX.TipoCalle
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).CteX.TelefonosCelulares]
Carpeta=(Variables)
Clave=CteX.TelefonosCelulares
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
