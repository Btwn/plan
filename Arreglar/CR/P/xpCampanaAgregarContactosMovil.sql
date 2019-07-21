SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpCampanaAgregarContactosMovil
@Empresa        char(5),
@Estacion		int,
@Usuario		varchar(10),
@ID             int,
@ContactoTipo   varchar(20)
AS BEGIN
DECLARE
@SituacionPorOmision	varchar(30),
@Contacto		    	varchar(10),
@SitucacionFecha        datetime,
@EnviarA                int,
@Agente                 varchar(10),
@UsuarioD               varchar(10),
@MapaLatitud            float,
@MapaLongitud           float,
@MapaPrecision          int,
@Almacen                varchar(20),
@ListaPreciosEsp        varchar(20),
@Fecha                  datetime
SET @Fecha = dbo.fnFechaSinHora(GETDATE())
SELECT @SituacionPorOmision = dbo.fnCampanaSituacionPorOmision(@ID)
SELECT @SitucacionFecha = (DATEADD(ms, -DATEPART(ms, GETDATE()), DATEADD(ss, -DATEPART(ss, GETDATE()),  GETDATE())))
DECLARE crListaSt CURSOR LOCAL FOR
SELECT CteProcesarMovil.Cliente,CteProcesarMovil.EnviarA,CteProcesarMovil.Agente,MovilUsuarioCfg.Usuario
FROM ListaSt
JOIN CteProcesarMovil ON ListaSt.Clave = CteProcesarMovil.ID AND ListaSt.Estacion = CteProcesarMovil.Estacion
JOIN MovilUsuarioCfg  ON CteProcesarMovil.Empresa = MovilUsuarioCfg.Empresa AND CteProcesarMovil.Agente = MovilUsuarioCfg.Agente
WHERE ListaSt.Estacion = @Estacion 
OPEN crListaSt
FETCH NEXT FROM crListaSt INTO @Contacto, @EnviarA, @Agente, @UsuarioD
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @ContactoTipo = 'Cliente'
BEGIN
IF @EnviarA <> 0
SELECT @MapaLatitud = MapaLatitud, @MapaLongitud = MapaLongitud, @MapaPrecision = MapaPrecision, @Almacen = Almacen, @ListaPreciosEsp = ListaPreciosEsp FROM CteEnviarA WHERE  Cliente = @Contacto AND ID = @EnviarA
IF @EnviarA = 0
SELECT @MapaLatitud = MapaLatitud, @MapaLongitud = MapaLongitud, @MapaPrecision = MapaPrecision, @Almacen = AlmacenDef, @ListaPreciosEsp = ListaPreciosEsp  FROM Cte WHERE Cliente = @Contacto
END
IF ISNULL(@Almacen,'') = ''
SELECT @Almacen = DefAlmacen FROM Usuario WHERE Usuario = @UsuarioD
IF ISNULL(@ListaPreciosEsp,'') = ''
SELECT @ListaPreciosEsp = DefListaPreciosEsp FROM Usuario WHERE Usuario = @UsuarioD
INSERT CampanaD (
ID,  ContactoTipo,  Situacion,            SituacionFecha,   Contacto,  Usuario,  EnviarA,   MapaLatitud, MapaLongitud, MapaPrecision, Almacen, ListaPreciosEsp)
VALUES (@ID, @ContactoTipo, @SituacionPorOmision, @SitucacionFecha, @Contacto, @UsuarioD, @EnviarA, @MapaLatitud, @MapaLongitud, @MapaPrecision, @Almacen, @ListaPreciosEsp)
END
FETCH NEXT FROM crListaSt INTO @Contacto, @EnviarA, @Agente, @UsuarioD
END  
CLOSE crListaSt
DEALLOCATE crListaSt
RETURN
END

