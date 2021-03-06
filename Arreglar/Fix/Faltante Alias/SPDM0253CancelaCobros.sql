SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
-- ========================================================================================================================================         
-- NOMBRE          : SPDM0253CancelaCobros    
-- AUTOR           : Fernando Romero           
-- FECHA CREACION  : 05/04/2016           
-- DESARROLLO      : DM0253    
-- MODULO          : CXC        
-- DESCRIPCION     : sp para cancelar todos los cobros que se hicieron en el cobro x monto 
-- EJEMPLO         : EXEC SPDM0253CancelaCobros 24726482,'VENTP00205'  
-- ======================================================================================================================================== 
ALTER  PROCEDURE [dbo].[SPDM0253CancelaCobros]
   @ID Int,
   @Usuario Varchar(10)

AS
BEGIN
 Declare 
	 @Idcobro Int,
	 @min int,
	 @max int,
	 @Idc int,
	 @Ok varchar(25),
	 @OkRef varchar(255)	

  IF Exists (Select Cobroticket From Cxc With(NoLock) Where ID=@ID and CobroTicket is not null)
     Begin
		IF EXISTS(SELECT ID FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#Cobros') AND type ='U')
		  DROP TABLE #Cobros

		  Create Table #cobros (Inc int identity(1,1), ID int)

		  select @Idcobro=CobroTicket From Cxc With(Nolock) Where ID=@ID
		  insert into #cobros(ID)
		  select ID  From Cxc With(NoLock) Where CobroTicket=@Idcobro order by ID DESC 

			DECLARE @AfectaMsj TABLE(
				Ok1 INT NULL,
				OkDesc VARCHAR(255) NULL,
				OkTipo VARCHAR(50) NULL,
				OkRef1 VARCHAR(255) NULL,
				IdGenerar INT
			)

		  Declare @msj as Table (Ok varchar(25), Okref Varchar(255))

		  Select @min=MIN(Inc), @max=MAX(Inc) From #cobros

		  BEGIN TRANSACTION Cob
		  
		  While @min <= @max
		    begin
				select @Idc=ID From #cobros Where Inc=@min
				   INSERT INTO @AfectaMsj
				   EXEC spAfectar 'CXC', @Idc, 'CANCELAR', 'Todo', NULL, @Usuario, NULL, 1, @Ok OUTPUT, @OkRef OUTPUT, NULL 
					
                  insert into @msj(Ok,Okref)
				  Select @Ok,@OkRef

				  IF Exists(Select ok from @msj Where Ok is not null)
					SET @min=@max 


			  SET @min=@min+1
			end

		If Exists(Select * from @msj Where Ok is not null)
          begin
			 ROLLBACK TRANSACTION Cob
			 select okref From @msj Where Ok is not null	
		  end	
		 Else
		  begin
			 COMMIT TRANSACTION Cob
			 select 'Se Cancelaron todos los cobros'
		  end 	
	 End
	
END