SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spMAviBuscaCxCVentaTest]
  @MovIdCxc    varchar(20),              
  @MovCxc      varchar(20),             
  @IdMovResul  varchar(20) Output,             
  @MovResul    varchar(20) Output,            
  @IdOrigen    Int Output            

AS BEGIN            

DECLARE            
  @Tipo      Varchar(20),            
  @IdNvo     varchar(20),            
  @IdMovNvo  varchar(20),            
  @IdMovNvo2 varchar(20),            
  @MovtipoNvo varchar(20),               
  @IdOrigenNvo  int,            
  @IdCXC  int,            
  @Aplica    varchar(20),            
  @AplicaID varchar(20),            
  @IDdetalle varchar(20),            
  @Contador  int ,             
  @ContadorD int,
  @Concepto varchar(50),
  @CveAfecta varchar(20)

  --- Inicializa             
SELECT @Tipo = 'CxC', @IdNvo = @MovIdCxc, @IdMovNvo= @MovCxc, @Contador = 0, @ContadorD = 0, @MovtipoNvo = ''             

Select @IdCXC = Id, @Concepto = Concepto From CXC With(Nolock) Where Mov = @MovCxc And mOViD = @MovIdCxc
Select @CveAfecta = Clave From MovTipo With(Nolock) Where Modulo = 'CXC' And Mov = @MovCxc 

If @CveAfecta = 'CXC.CA' And @Concepto = 'Monedero Electronico'
	SELECT @IdMovResul=@MovIdCxc, @MovResul=@MovCxc, @IdOrigen= @IdCXC            
Else
  Begin
        ----SELECT 'text ', @IdNvo IdMov , @IdMovNvo Movimiento, @Tipo Tipo,@MovtipoNvo MovtipoNvo, @IdOrigenNvo IdNuevo   --- Test            
  
        WHILE @MovtipoNvo NOT IN('VTAS.F','CXC.EST')  AND @Contador < 10            
        BEGIN            
          
         SELECT @Tipo=OModulo, @IdMovNvo=OMov, @IdNvo=(OMovId),@IdOrigenNvo=isnull(mf.OID,0), @MovtipoNvo = Mt.Clave            
           FROM MovFlujo mf WITH(NOLOCK), Movtipo Mt WITH(NOLOCK) WHERE mf.OMov=Mt.Mov             
           AND mf.DMov = @IdMovNvo AND mf.DMovID = @IdNvo AND DModulo = 'CXC'
                Order BY OMovId DESC             
                          
          IF @MovtipoNvo = 'CXC.EST'          
           BEGIN          
             SELECT @IdOrigenNvo = OID,@IdNvo = OMovID,@IdMovNvo = OMov          
              FROM MovFlujo mf WITH(NOLOCK), Movtipo Mt WITH(NOLOCK) WHERE mf.OMov=Mt.Mov             
               AND mf.DMov = @MovCxC AND mf.DMovID = @MovIDCxC AND DModulo = 'CXC'         
              ORDER BY OMovId DESC             
           END          
             
         SELECT @Contador = @Contador + 1            
  
         -----SELECT @IdNvo IdMov , @IdMovNvo Movimiento, @Tipo Tipo,@MovtipoNvo MovtipoNvo, @IdOrigenNvo IdNuevo, @Contador   --- Test            
  
        END            
                    
    IF @Contador > 10 SELECT @IdNvo = NULL, @IdMovNvo = NULL, @IdOrigenNvo = 0            
    ---IF @Contador < 10 SELECT @IdOrigenNvo = id FROM venta WHERE Mov = @IdMovNvo AND MovID = @IdNvo    
      SELECT @Aplica = Aplica, @AplicaID = AplicaID FROM CxcD WITH(NOLOCK) WHERE Id = @IdOrigen            
             
     IF NOT @AplicaID IS NULL             
      BEGIN            
      DECLARE crCxCCte CURSOR FOR            
       SELECT  Id FROM CXc WITH(NOLOCK) WHERE Mov = @Aplica AND MovId = @AplicaID            
      OPEN crCxCCte            
      FETCH NEXT FROM crCxCCte INTO @IdMovNvo2            
      WHILE @MovtipoNvo <> 'VTAS.F' AND @ContadorD < 10            
      BEGIN  
            
         SELECT @Tipo=OModulo, @IdMovNvo=OMov, @IdNvo=(OMovId),@IdOrigenNvo=mf.OID, @MovtipoNvo = Mt.Clave            
           FROM MovFlujo mf WITH(NOLOCK), Movtipo Mt WITH(NOLOCK) WHERE mf.OMov = Mt.Mov             
           AND mf.DMov = @IdMovNvo2 AND mf.DMovID = @IdNvo AND DModulo = 'CXC'            
                Order BY OMovId DESC            

 
         SELECT @ContadorD = @ContadorD + 1                   
      FETCH NEXT FROM crCxCCte INTO @IdMovNvo2            
      END            
      CLOSE crCxCCte            
      DEALLOCATE crCxCCte            
      END                  
    SELECT @IdMovResul=@IdNvo, @MovResul=@IdMovNvo, @IdOrigen= @IdOrigenNvo            
    ----SELECT @IdMovResul, @MovResul, @IdOrigen, 'jijo'         ----test     
    ---SELECT @IdNvo IdMov , @IdMovNvo Movimiento, @Tipo Tipo,@MovtipoNvo MovtipoNvo, @IdOrigenNvo IdNuevo , @Contador   --- Test            
  RETURN             
End         

End
GO
