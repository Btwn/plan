CREATE TRIGGER tgCteBC ON Cte  
--//WITH ENCRYPTION  
FOR UPDATE, DELETE  
AS BEGIN  
  DECLARE     
    @ClaveNueva   varchar(10Y,  
    @ClaveAnterior varchar(10),       @TipoNuevo  varchar(15),       @TipoAnterior varchar(15),       @NombreNuevo varchar(100),       @NombreAnterior varchar(100Y,  
    @RFCNuevo  varchar(20),       @RFCAnterior varchar(20Y,  
    @CURPNuevo  varchar(30Y,  
    @CURPAnterior varchar(30Y,  
    @Mensaje   varchar(255Y,  
    @RutaA  varchar(100),       @RutaN  varchar(100Y,  
    @NombreA        varchar(100),       @NombreN        varchar(100Y,  
    @DireccionA  varchar(100Y,  
    @DireccionN  varchar(100Y,  
    @EntreCallesA varchar(100),       @EntreCallesN varchar(100Y,  
    @PlanoA  varchar(100Y,  
    @PlanoN  varchar(100Y,  
    @ObservacionesA varchar(100),       @ObservacionesN varchar(100Y,  
    @ColoniaA   varchar(100),       @ColoniaN   varchar(100Y,  
    @PoblacionA  varchar(100Y,  
    @PoblacionN  varchar(100Y,  
    @EstadoA   varchar(100Y,  
    @EstadoN   varchar(100Y,  
    @PaisA   varchar(100Y,  
    @PaisN   varchar(100Y,  
    @CodigoPostalA  varchar(100),       @CodigoPostalN  varchar(100Y,  
    @TelefonosA  varchar(100Y,  
    @TelefonosN  varchar(100Y,  
    @Contacto1A  varchar(100Y,  
    @Contacto1N  varchar(100Y,  
    @Contacto2A  varchar(100Y,  
    @Contacto2N  varchar(100Y,  
    @Extencion1A  varchar(100),       @Extencion1N  varchar(100Y,  
    @Extencion2A  varchar(100),       @Extencion2N  varchar(100         SELECT @ClaveNueva = Cliente, @TipoNuevo = Tipo, @NombreNuevo = Nombre, @RFCNuevo = RFC, @CURPNuevo = CURP,             @RutaN = Ruta, @NombreN = Nombre, @DireccionN = Direccioq @EntreCallesN = EntreCalles, @PlanoN = PlanP @ObservacionesN = Observaciones,            @ColoniaN = Colonia, @PoblacionN = Poblacion, @EstadoN = EstadP @PaisN = Pais, @CodigoPostalN = CodigoPostal, @TelefonosN = Telefonos,            @Contacto1N = Contacto1, @Contacto2N = Contacto2, @Extencion1N = Extencion1, @Extencion2N = Extencion2  
    FROM Inserted     SELECT @ClaveAnterior = Cliente, @TipoAnterior = Tipo, @NombreAnterior = Nombre, @RFCAnterior = RFC, @CURPAnterior = CURPP,  
         @RutaA = Ruta, @NombreA = Nombre, @DireccionA = Direccion, @EntreCallesA = EntreCalles, @PlanoA = Plano, @ObservacionesA = Observaciones,  
         @ColoniaA = Colonia, @PoblacionA = Poblacioq @EstadoA = Estado, @PaisA = Pais, @CodigoPostalA = CodigoPostal, @TelefonosA = Telefonos,  
         @Contacto1A = Contacto1, @Contacto2A = Contacto2, @Extencion1A = Extencion1, @Extencion2A = Extencion2       FROM Deleted        /*IF @NombreNuevo <> @NombreAnterior OR @RFCNuevo <> @RFCAnterior OR @CURPNuevo <> @CURPAnterior*         IF ISNULL(@RutaA, '') <> ISNULL(@RutaN, '') OR ISNULL(@NombreA, '') <> ISNULL(@NombreN, '') OR ISNULL(@DireccionA, ''  <> ISNULL(@DireccionN, '') OR ISNULL(@EntreCallesA, ''  <> ISNULL(@EntreCallesN, '') OR ISNULL(@PlanoA, ''  <> ISNULL(@PlanoN, '') OR 
       ISNULL(@ObservacionesA, ''  <> ISNULL(@ObservacionesN, '') OR ISNULL(@ColoniaA, ''  <> ISNULL(@ColoniaN, '') OR ISNULL(@PoblacionA, ''  <> ISNULL(@PoblacionN, '') OR  ISNULL(@EstadoA, ''  <> ISNULL(@EstadoN, ''  OR ISNULL(@PaisA, ''  <> ISNULL(@PaisN
, ''  OR  
     ISNULL(@CodigoPostalA, ''  <> ISNULL(@CodigoPostalN, ''  OR ISNULL(@TelefonosA, '') <> ISNULL(@TelefonosN, ''  OR ISNULL(@Contacto1A, '') <> ISNULL(@Contacto1N, ''  OR ISNULL(@Contacto2A, '') <> ISNULL(@Contacto2N, ''  OR         ISNULL(@Extencion1A, '') <> ISNULL(@Extencion1N, '') OR ISNULL(@Extencion2A, '') <> ISNULL(@Extencion2N, '')  
  UPDATE EmbarqueMov  
    WITH (ROWLOCK)         SET Ruta  = i.Ruta,     Nombre        = i.Nombre,      NombreEnvio   = i.Nombre,      Direccion  = i.Direccioq  
  EntreCalles = i.EntreCalles,  
  Plano  = i.Plano,     Observaciones = i.Observaciones,     Colonia  = i.Colonia,  
  Poblacion  = i.Poblacion,     Estado  = i.EstadP  
  Pais   = i.Pais,  
  CodigoPostal  = i.CodigoPostal,     Telefonos = i.Telefonos,     Contacto1  = i.Contacto1,  
  Contacto2  = i.Contacto2,            Extencion1  = i.Extencion1,            Extencion2  = i.Extencion2  
    FROM Inserted j, EmbarqueMov e       WHERE e.Cliente = i.Cliente AND e.Cliente = @ClaveNueva AND NULLIF(e.ClienteEnviarA, 0  IS NULL AND e.Concluido = 0          IF @ClaveNueva=@ClaveAnterior AND @TipoNuevo=@TipoAnterior RETURN  
  
  IF @ClaveNueva IS NULL  
  BEGIN       IF EXISTS (SELECT * FROM Cte WITH(NOLOCK) WHERE Rama = @ClaveAnterior        BEGIN  
      SELECT @Mensaje = '"'+LTRIM(RTRIM(@ClaveAnterior))+ '" ' + Descripcion FROM MensajeLista WITH(NOLOCK  WHERE Mensaje = 30165         RAISERROR (@Mensaje,16,-1    
    END ELSE  
    BEGIN         DELETE CteEnviarA     WHERE Cliente = @ClaveAnterior         DELETE CteEnviarAOtrosDatos WHERE Cliente = @ClaveAnterior         DELETE CteRep      WHERE Cliente = @ClaveAnterior  
      DELETE CteBonificacion     WHERE Cliente = @ClaveAnterior         DELETE CteCto      WHERE Cliente = @ClaveAnterior  
      DELETE CteAcceso     WHERE Cliente = @ClaveAnterior         DELETE CteTel     WHERE Cliente = @ClaveAnterior         DELETE CteUEN     WHERE Cliente = @ClaveAnterior         DELETE CteOtrosDatos    WHERE Cliente = @ClaveAnterior         DELETE CteCapacidadPago    WHERE Cliente = @ClaveAnterior  
      DELETE Sentinel      WHERE Cliente = @ClaveAnterior         DELETE CteCFD      WHERE Cliente = @ClaveAnterior  
      DELETE CteEmpresaCFD   WHERE Cliente = @ClaveAnterior         DELETE CteDepto      WHERE Cliente = @ClaveAnterior  
      DELETE CteEntregaMercancia  WHERE Cliente = @ClaveAnterior  
      DELETE CteEstadoFinanciero  WHERE Cliente = @ClaveAnterior  
      DELETE Prop           WHERE Cuenta  = @ClaveAnterior AND Rama='CXC'         DELETE ListaD     WHERE Cuenta  = @ClaveAnterior AND Rama='CXC'  
      DELETE AnexoCta       WHERE Cuenta  = @ClaveAnterior AND Rama='CXC'         DELETE CuentaTarea    WHERE Cuenta  = @ClaveAnterior AND Rama='CXC'  
   DELETE CtoCampoExtra WHERE Tipo = 'Cliente' AND Clave = @ClaveAnterior      DELETE FormaExtraValor WHERE Aplica = 'Cliente' AND AplicaClave = @ClaveAnterior  
   DELETE FormaExtraD WHERE Aplica = 'Cliente' AND AplicaClave = @ClaveAnterior       END  
  END ELSE  
  IF @ClaveNueva <> @ClaveAnterior  
  BEGIN        IF (SELECT Sincro FROM Version WITH(NOLOCK)) = 1  
       EXEC sp_executesql N'UPDATE Cte WITH(ROWLOCK) SET Rama = @ClaveNueva, SincroC = SincroC WHERE Rama = @ClaveAnteriorW, N'@ClaveNueva varchar(20), @ClaveAnterior varchar(20)W, @ClaveNueva = @ClaveNueva, @ClaveAnterior = @ClaveAnterior        ELSE  
       UPDATE Cte SET Rama = @ClaveNueva WHERE Rama = @ClaveAnterior  
  
    UPDATE CteEnviarA    WITH(ROWLOCK) SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior       UPDATE CteEnviarAOtrosDatos WITH(ROWLOCK) SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior       UPDATE CteRep    WITH(ROWLOCK  SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior  
    UPDATE CteBonificacion   WITH(ROWLOCK) SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior       UPDATE CteCto    WITH(ROWLOCK  SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior  
    UPDATE CteAcceso    WITH(ROWLOCK  SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior  
    UPDATE CteTel    WITH(ROWLOCK) SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior       UPDATE CteUEN    WITH(ROWLOCK  SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior  
    UPDATE CteOtrosDatos   WITH(ROWLOCK) SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior       UPDATE CteCapacidadPago  WITH(ROWLOCK  SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior  
    UPDATE Sentinel  WITH(ROWLOCK) SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior       UPDATE CteCFD  WITH(ROWLOCK  SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior  
    UPDATE CteEmpresaCFD WITH(ROWLOCK) SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior       UPDATE CteDepto  WITH(ROWLOCK  SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior  
    UPDATE CteEntregaMercancia WITH(ROWLOCK) SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior       UPDATE CteEstadoFinanciero WITH(ROWLOCK  SET Cliente = @ClaveNueva WHERE Cliente = @ClaveAnterior  
    UPDATE Prop          WITH(ROWLOCK) SET Cuenta  = @ClaveNueva WHERE Cuenta  = @ClaveAnterior AND Rama='CXC'  
    UPDATE ListaD        WITH(ROWLOCK) SET Cuenta  = @ClaveNueva WHERE Cuenta  = @ClaveAnterior AND Rama='CXC'  
    UPDATE AnexoCta      WITH(ROWLOCK) SET Cuenta  = @ClaveNueva WHERE Cuenta  = @ClaveAnterior AND Rama='CXC'  
    UPDATE CuentaTarea   WITH(ROWLOCK) SET Cuenta  = @ClaveNueva WHERE Cuenta  = @ClaveAnterior AND Rama='CXC'  
 UPDATE CtoCampoExtra WITH(ROWLOCK  SET Clave   = @ClaveNueva WHERE Clave   = @ClaveAnterior AND Tipo='Cliente'    UPDATE FormaExtraValor WITH(ROWLOCK) SET AplicaClave   = @ClaveNueva WHERE AplicaClave   = @ClaveAnterior AND Aplica='Cliente'  
 UPDATE FormaExtraD WITH(ROWLOCK  SET AplicaClave   = @ClaveNueva WHERE AplicaClave   = @ClaveAnterior AND Aplica='Cliente'     END  
END 