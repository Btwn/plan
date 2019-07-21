[Forma]
Clave=DM0138MaviCteExpressDatosNominales
Nombre=DM0138MaviCteExpressDatosNominales
Icono=0
Modulos=(Todos)
MovModulo=DM0138MaviCteExpressDatosNominales
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=206
PosicionInicialArriba=348
PosicionInicialAlturaCliente=211
PosicionInicialAncho=853
VentanaExclusiva=S
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Mavi.DM0138Nomina, nulo)<BR>Asigna(Mavi.DM0138NominaAux, nulo)<BR>Asigna(Mavi.DM0138Puesto, nulo)<BR>Asigna(Mavi.DM0138ClaveINST, nulo)<BR>Asigna(Mavi.DM0138Cargo, nulo)<BR>Asigna(Mavi.DM0138Municipio, nulo)<BR>Asigna(Mavi.DM0138Validar1, nulo)<BR>Asigna(Mavi.DM0138Validar2, nulo)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0138Nomina<BR>Mavi.DM0138NominaAux<BR>Mavi.DM0138Puesto<BR>Mavi.DM0138RFC<BR>Mavi.DM0138ClaveINST<BR>Mavi.DM0138Cargo<BR>Mavi.DM0138Municipio
CarpetaVisible=S
[(Variables).Mavi.DM0138Nomina]
Carpeta=(Variables)
Clave=Mavi.DM0138Nomina
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
[(Variables).Mavi.DM0138Puesto]
Carpeta=(Variables)
Clave=Mavi.DM0138Puesto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
[(Variables).Mavi.DM0138RFC]
Carpeta=(Variables)
Clave=Mavi.DM0138RFC
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=18
ColorFondo=Blanco
[(Variables).Mavi.DM0138ClaveINST]
Carpeta=(Variables)
Clave=Mavi.DM0138ClaveINST
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
[(Variables).Mavi.DM0138Cargo]
Carpeta=(Variables)
Clave=Mavi.DM0138Cargo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
[(Variables).Mavi.DM0138Municipio]
Carpeta=(Variables)
Clave=Mavi.DM0138Municipio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=(Lista)
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Asignar<BR>SP
RefrescarDespues=S
[Acciones.Guardar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Guardar.SP]
Nombre=SP
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=Asigna(Info.Estatus,SQL(<T>Select Estatus From Comercializadora.dbo.Personal With(Nolock) Where Personal=:tPer<T>,Mavi.DM0138Nomina))<BR><BR>Si<BR>  Info.Estatus=<T>ALTA<T><BR>Entonces<BR>  Si<BR>    SQL(<T>Select Dbo.FnVTASValidaCteNomina(:tCte)<T>,Info.Cliente) = <T>SI<T><BR>    Entonces<BR>      Si<BR>        SQL(<T>Select Count(Nomina) From CteEnviarA With(Nolock) Where ID=34 and Nomina=:tNo<T>,Mavi.DM0138Nomina) = 0<BR>          Entonces<BR>          Si<BR>             (SQL(<T>Select Registro2 From Comercializadora.dbo.Personal With(Nolock) Where Personal=:tNom<T>,Mavi.DM0138Nomina)=Mavi.DM0138RFC) o (SQL(<T>Select Count(*) From CteEnviarA With(Nolock) Where ID=34 and Cliente=:tNom<T>,Info.Cliente)=0)<BR>             Entonces<BR>                   Si<BR>                     SQL(<T>select DAtediff(DD,FechaAlta,GETDATE()) from Personal With(Nolock) Where Personal=:tPer<T>,Mavi.DM0138Nomina) >= 365<BR>                        Entonces<BR>                            EjecutarSQL(<T>SP_MAVIDM0138GuardarDatosNominales :tNomina, :tCliente, :tPuesto, :tRFC, :tClaveINST, :tCargo, :tMunicipio, :nCanalVta<T>,<BR>                           Mavi.DM0138Nomina, Info.Cliente, Mavi.DM0138Puesto, Mavi.DM0138RFC, Mavi.DM0138ClaveINST, Mavi.DM0138Cargo, Mavi.DM0138Municipio, Info.CanalVentaMAVI)<BR>                           informacion(<T>Datos guardados correctamente<T>)<BR>                             Forma.Accion(<T>Cerrar<T>) <BR>                        Sino<BR>                         Error(<T>El Empleado no cuenta con un año de antiguedad<T>)<BR>                   Fin<BR>                Sino<BR>                   Error(<T>El RFC no coincide con el de la nomina ingresada<T>)<BR>                Fin                                                                          <BR>           Sino<BR>             Error(<T>La nomina ya existe en otra cuenta<T>)<BR>          Fin<BR>    Sino<BR>      Error(<T>Esta Cuenta ya tiene una nomina registrada<T>)<BR>    Fin                                                         <BR>Sino<BR>  Error(<T>El Empleado esta dado de baja<T>)<BR>Fin
EjecucionCondicion=Si longitud(Mavi.DM0138Nomina)>30<BR>    Entonces<BR>        Error(<T>El Campo Nomina no debe ser mayor de 30 caracteres.<T>)<BR>        Falso<BR>    Sino<BR>        Si (Vacio(SQL(<T>SP_MAVIDM0138CamposInstitucionalesObligatorios :tTexto, :nCV<T>, <T>%NOMINA OBLIGATORIO%<T>, Info.CanalVentaMAVI))<BR>            o ( SQL(<T>SELECT PorRFCNomina FROM VentasCanalMAVI WITH(NOLOCK) WHERE ID =:tId<T>, Info.CanalVentaMAVI) <> <T>N<T> ) )<BR>            entonces<BR>                Verdadero<BR>            sino<BR>                si (Vacio(Mavi.DM0138Nomina))<BR>                    entonces<BR>                        falso<BR>                        informacion(<T>El Número de Nómina es Obligatorio<T>)<BR>                    sino    <BR>                        Si Mavi.DM0138Nomina <> Mavi.DM0138NominaAux<BR>                            Entonces<BR>                                Error(<T>El número de Nomina no coincide.<T>)<BR>                                Falso<BR>                            Sino<BR>                                Verdadero<BR>                        fin<BR>                fin<BR>        fin<BR>fin<BR>y<BR>Si longitud(Mavi.DM0138Puesto)>100<BR>    Entonces<BR>        Error(<T>El Campo Puesto no debe ser mayor de 100 caracteres.<T>)<BR>        Falso<BR>    Sino<BR>        Si (Vacio(SQL(<T>SP_MAVIDM0138CamposInstitucionalesObligatorios :tTexto, :nCV<T>, <T>%PUESTO OBLIGATORIO%<T>, Info.CanalVentaMAVI)))<BR>            entonces<BR>                Verdadero<BR>            sino<BR>                si (Vacio(Mavi.DM0138Puesto))<BR>                    entonces<BR>                        falso<BR>                        informacion(<T>El Puesto es Obligatorio<T>)<BR>                    sino<BR>                        verdadero<BR>                fin<BR>        fin<BR>fin<BR>y                                                                            <BR>Si longitud(Mavi.DM0138RFC)>18<BR>    Entonces<BR>        Error(<T>El Campo FRC de la Institución no debe ser mayor de 18 caracteres.<T>)<BR>        Falso<BR>    Sino<BR>        Si (Vacio(SQL(<T>SP_MAVIDM0138CamposInstitucionalesObligatorios :tTexto, :nCV<T>, <T>%RFC OBLIGATORIO%<T>, Info.CanalVentaMAVI))<BR>           o ( SQL(<T>SELECT PorRFCNomina FROM VentasCanalMAVI WITH(NOLOCK) WHERE ID =:tId<T>, Info.CanalVentaMAVI) <> <T>R<T> ) )<BR>            entonces <BR>                Verdadero                                        <BR>            sino<BR>                si (Vacio(Mavi.DM0138RFC))<BR>                    entonces<BR>                        falso                                                               <BR>                        informacion(<T>El RFC de la Institución es Obligatorio<T>)<BR>                    sino<BR>                        verdadero<BR>                fin<BR>        fin<BR>fin<BR>y<BR>Si longitud(Mavi.DM0138ClaveINST)>30<BR>    Entonces<BR>        Error(<T>El Campo Clave Institución no debe ser mayor de 30 caracteres.<T>)<BR>        Falso<BR>    Sino<BR>        Si (Vacio(SQL(<T>SP_MAVIDM0138CamposInstitucionalesObligatorios :tTexto, :nCV<T>, <T>%CLAVEINST OBLIGATORIO%<T>, Info.CanalVentaMAVI))<BR>            o  (SQL(<T>SELECT COUNT(NOMBRE) FROM TablaStD WITH(NOLOCK) WHERE TablaSt = :tTab AND Valor = :tp AND Nombre = :tNom <T>, <T>CANALES VENTA PRESUPUESTAL<T>, <T>P<T>, Info.CanalVentaMAVI) = 0 ) )<BR>            entonces<BR>                Verdadero<BR>            sino<BR>                si (Vacio(Mavi.DM0138ClaveINST))<BR>                    entonces<BR>                        falso<BR>                        informacion(<T>La Clave de la Institución es Obligatoria<T>)<BR>                    sino<BR>                        verdadero<BR>                fin<BR>        fin<BR>fin<BR>y<BR>Si longitud(Mavi.DM0138Cargo)>50<BR>    Entonces<BR>        Error(<T>El Campo Cargo no debe ser mayor de 50 caracteres.<T>)<BR>        Falso<BR>    Sino<BR>        Si (Vacio(SQL(<T>SP_MAVIDM0138CamposInstitucionalesObligatorios :tTexto, :nCV<T>, <T>%CARGO OBLIGATORIO%<T>, Info.CanalVentaMAVI)))<BR>            entonces<BR>                Verdadero<BR>            sino<BR>                si (Vacio(Mavi.DM0138Cargo))<BR>                    entonces<BR>                        falso<BR>                        informacion(<T>El Campo Cargo es Obligatorio<T>)<BR>                    sino<BR>                        verdadero<BR>                fin<BR>        fin<BR>fin<BR>y<BR>Si longitud(Mavi.DM0138Municipio)>50<BR>    Entonces<BR>        Error(<T>El Campo Municipio no debe ser mayor de 50 caracteres.<T>)<BR>        Falso<BR>    Sino<BR>        Si (Vacio(SQL(<T>SP_MAVIDM0138CamposInstitucionalesObligatorios :tTexto, :nCV<T>, <T>%MUNICIPIO OBLIGATORIO%<T>, Info.CanalVentaMAVI)))<BR>            entonces<BR>                Verdadero<BR>            sino<BR>                si (Vacio(Mavi.DM0138Municipio))<BR>                    entonces<BR>                        falso<BR>                        informacion(<T>El Municipio es Obligatorio<T>)<BR>                    sino<BR>                        verdadero<BR>                fin<BR>        fin<BR>fin
[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Cerrar
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Asigna(Mavi.DM0138Validar1, (SQL(<T>Select DBO.Fn_MAVIDM0138DatosNominalesCerrar (:nBand, :tCliente, :tValidar, :nCV)<T>, 1, Info.Cliente, <T><T>, Info.CanalVentaMAVI)))<BR>Asigna(Mavi.DM0138Validar2, (SQL(<T>Select DBO.Fn_MAVIDM0138DatosNominalesCerrar (:nBand, :tCliente, :tValidar, :nCV)<T>, 2, Info.Cliente, <T><T>, Info.CanalVentaMAVI)))<BR>((Mavi.DM0138Validar1 = (<BR>(Si Vacio(Mavi.DM0138Nomina) entonces <T><T> sino (Mavi.DM0138Nomina) fin)+<BR>(Si Vacio(Mavi.DM0138Puesto) entonces <T><T> sino (Mavi.DM0138Puesto) fin)+<BR>(Si Vacio(Mavi.DM0138RFC) entonces <T><T> sino (Mavi.DM0138RFC) fin)))<BR>Y<BR>(Mavi.DM0138Validar2 = (<BR>(Si Vacio(Mavi.DM0138ClaveINST) entonces <T><T> sino (Mavi.DM0138ClaveINST) fin)+<BR>(Si Vacio(Mavi.DM0138Cargo) entonces <T><T> sino (Mavi.DM0138Cargo) fin)+<BR>(Si Vacio(Mavi.DM0138Municipio) entonces <T><T> sino (Mavi.DM0138Municipio) fin))))<BR>y<BR>(Si (Vacio(SQL(<T>SP_MAVIDM0138CamposInstitucionalesObligatorios :tTexto, :nCV<T>, <T>%NOMINA OBLIGATORIO%<T>, Info.CanalVentaMAVI))<BR>    o ( SQL(<T>SELECT PorRFCNomina FROM VentasCanalMAVI WITH(NOLOCK) WHERE ID =:tId<T>, Info.CanalVentaMAVI) <> <T>N<T> ))<BR>  entonces Verdadero<BR>  sino<BR>    si (Vacio(Mavi.DM0138Nomina))<BR>      entonces<BR>        falso<BR>        informacion(<T>El Número de Nómina es Obligatorio<T>)<BR>      sino verdadero<BR>    fin<BR>fin<BR>y<BR>Si (Vacio(SQL(<T>SP_MAVIDM0138CamposInstitucionalesObligatorios :tTexto, :nCV<T>, <T>%PUESTO OBLIGATORIO%<T>, Info.CanalVentaMAVI)))<BR>  entonces  Verdadero<BR>  sino<BR>    si (Vacio(Mavi.DM0138Puesto))<BR>      entonces<BR>        falso                              <BR>        informacion(<T>El Puesto es Obligatorio<T>)<BR>      sino verdadero<BR>    fin<BR>fin<BR>y<BR>Si (Vacio(SQL(<T>SP_MAVIDM0138CamposInstitucionalesObligatorios :tTexto, :nCV<T>, <T>%RFC OBLIGATORIO%<T>, Info.CanalVentaMAVI))<BR>    o ( SQL(<T>SELECT PorRFCNomina FROM VentasCanalMAVI WITH(NOLOCK) WHERE ID =:tId<T>, Info.CanalVentaMAVI) <> <T>R<T> ) )<BR>  entonces  Verdadero<BR>  sino<BR>    si (Vacio(Mavi.DM0138RFC))<BR>      entonces<BR>        falso<BR>        informacion(<T>El RFC de la Institución es Obligatorio<T>)<BR>      sino verdadero<BR>    fin<BR>fin<BR>y<BR>Si (Vacio(SQL(<T>SP_MAVIDM0138CamposInstitucionalesObligatorios :tTexto, :nCV<T>, <T>%CLAVEINST OBLIGATORIO%<T>, Info.CanalVentaMAVI))<BR>    o  (SQL(<T>SELECT COUNT(NOMBRE) FROM TablaStD WITH(NOLOCK) WHERE TablaSt = :tTab AND Valor = :tp AND Nombre = :tNom <T>, <T>CANALES VENTA PRESUPUESTAL<T>, <T>P<T>, Info.CanalVentaMAVI) = 0 ) )<BR>  entonces Verdadero<BR>  sino<BR>    si (Vacio(Mavi.DM0138ClaveINST))<BR>      entonces<BR>        falso<BR>        informacion(<T>La Clave de la Institución es Obligatoria<T>)<BR>      sino verdadero<BR>    fin<BR>fin<BR>y<BR>Si (Vacio(SQL(<T>SP_MAVIDM0138CamposInstitucionalesObligatorios :tTexto, :nCV<T>, <T>%CARGO OBLIGATORIO%<T>, Info.CanalVentaMAVI)))<BR>  entonces  Verdadero<BR>  sino<BR>    si (Vacio(Mavi.DM0138Cargo))<BR>      entonces<BR>        falso<BR>        informacion(<T>El Campo Cargo es Obligatorio<T>)<BR>      sino verdadero<BR>    fin<BR>fin<BR>y<BR>Si (Vacio(SQL(<T>SP_MAVIDM0138CamposInstitucionalesObligatorios :tTexto, :nCV<T>, <T>%MUNICIPIO OBLIGATORIO%<T>, Info.CanalVentaMAVI)))<BR>  entonces  Verdadero<BR>  sino<BR>    si (Vacio(Mavi.DM0138Municipio))<BR>      entonces<BR>        falso<BR>        informacion(<T>El Municipio es Obligatorio<T>)<BR>      sino verdadero<BR>    fin<BR>fin)
EjecucionMensaje=<T>No se han guardado los datos<T>
[Acciones.Cerrar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.Guardar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=SP
SP=(Fin)




[Acciones.Cerrar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Cerrar
Cerrar=(Fin)



[(Variables).Mavi.DM0138NominaAux]
Carpeta=(Variables)
Clave=Mavi.DM0138NominaAux
Editar=S
ValidaNombre=S
3D=S
Pegado=S
Tamano=20
ColorFondo=Blanco


[(Variables).ListaEnCaptura]
(Inicio)=Mavi.DM0138Nomina
Mavi.DM0138Nomina=Mavi.DM0138NominaAux
Mavi.DM0138NominaAux=Mavi.DM0138Puesto
Mavi.DM0138Puesto=Mavi.DM0138RFC
Mavi.DM0138RFC=Mavi.DM0138ClaveINST
Mavi.DM0138ClaveINST=Mavi.DM0138Cargo
Mavi.DM0138Cargo=Mavi.DM0138Municipio
Mavi.DM0138Municipio=(Fin)







[Forma.ListaAcciones]
(Inicio)=Guardar
Guardar=Cerrar
Cerrar=(Fin)

