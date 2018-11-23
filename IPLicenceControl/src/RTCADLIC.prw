//Bibliotecas
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'IPLICENSE.CH'
#INCLUDE 'TOPCONN.CH'
#DEFINE  RotAut_Inclusao  3
#DEFINE	 RotAut_Alteracao 4
#DEFINE  RotAut_Exclusao  5
#DEFINE  RotAut_Imprimir  8
#DEFINE	 RotAut_Importar  9
#DEFINE  RotAut_Exportar  6

//-------------------------------------------------------------------	
/*/{Protheus.doc}
Rotina automatica para Inclusão e Rotina de Exclusão 
@author: Michelle Pacheco
@since: 04/09/2018
@Version: 1.0
	@return: 
/*/
//-------------------------------------------------------------------	

/******************************************************
|Func: Rot_Aut()									  |
|Autor: Michelle Pacheco							  |
|Data: 11/09/2018									  |
|Desc: Importa e recebe os dados |
******************************************************/
User function RTCADLIC(aParam, lRet)
Local aArea 		:= GetArea()
Local aAtefatos		:= {}
Local aLicGeradas	:= {}
Local cCodCli		:= ""
Local cNomeCli		:= ""
Local aRetCad		:= {}
Local cCodCli		:= ""
Local cNomeCli		:= ""
Local dtAltera		:= Ddatabase
Local cHora			:= TIME()
Private aRotina		:= FWMVCMenu("CadLicen")
	
	dbSelectArea("ZZ6")
	ZZ6->(dbSetOrder(1))
	
	//Recebendo Codigo e Nome do Cliente
	If !selCodCli(@aRetCad)
		return
	Endif	
	
	cCodCli := aRetCad[1]
	cNomeCli := aRetCad[2]
		
   	if(validaCliente(cCodCli))
   		MSGYESNO( 'CÓDIGO ENCONTRADO.DESEJA REENCREVER?', 'AVISO!!' )
   		ExcluiItens(cCodCli)
   		AddLicenca(cCodCli, cNomeCli)
   	else 		
   		AddLicenca(cCodCli, cNomeCli)	
   	endif
   	
   				
		RestArea(aArea)
		
Return 
//------------------------------------------------------------------------------------------------//
/*
*	Função responsável pela seleção de Código e Cliente
*/
Static function selCodCli(aRetCad)
Local aParamBox := {}
Local cCod		:= Space(15)
Local cCli		:= Space(50)


	aAdd(aParamBox,{1,"Código" ,cCod,"@","naoVazio()",,"",0,.F.})
	aAdd(aParamBox,{1,"Cliente",cCli,"@!","","","",80,.F.}) 
	
return ParamBox(aParamBox,"Selecione o os dados...",@aRetCad,,, .T.,,,,,.F. ,.F.) 

//--------------------------------------------------------------------------------------------------//
/*
*	Função Valida Cliente existente
*/ 
static function validaCliente(cCodCli)
Local cQuery := ""
Local lRet   := .F.
Local aArea  := GetArea()

		//Construindo Consulta
		cQuery +=" SELECT ZZ6_COD, ZZ6_CLIENT " 				    + CRLF
		cQuery += "FROM " + RetSqlName( "ZZ6" ) + " ZZ6 " 			+ CRLF
		cQuery += "WHERE"											+ CRLF
		cQuery +=	 " ZZ6_FILIAL='" + xFilial("ZZ6") + "'  "		+ CRLF 
		cQuery += 	 "AND ZZ6_COD='" + cCodCli + "' " 	        	+ CRLF 
		cQuery += 	 "AND ZZ6.D_E_L_E_T_=' ' "						+ CRLF 	
		
                      
		//Executando consulta
		TcQuery ChangeQuery(cQuery) New Alias ('TMPZZ6')
				
		//TCSetField("QRY_ZZ6", ZZ6_DATA,'D')
		if TMPZZ6->(! EOF()) 
			lRet := .T.
		endif
		
		TMPZZ6 -> (DbCloseArea())
		RestArea(aArea)
   	

Return lRet
//--------------------------------------------------------------------------------------------------//
/*
* Função de Exclusão de registro
*/
static function ExcluiItens(cCodCli)
local cQuery := ""
Local aArea :=GetArea()
Local aZZ6 := ZZ6->(GetArea())
Local cAliasZZ6 := GetNextAlias()
Local cCod := ""

DbSelectArea("ZZ6")
cCodCli	:= padr(cCodCli,tamsx3("ZZ6_COD")[1])
ZZ6->(DbSetOrder(1))
ZZ6->(DbGoTop())

		//Consulta que retorna o cliente existente
		cQuery +=" SELECT ZZ6_COD, ZZ6_CLIENT " 				    + CRLF
		cQuery += "FROM " + RetSqlName( "ZZ6" ) + " ZZ6 " 			+ CRLF
		cQuery += "WHERE"											+ CRLF
		cQuery +=	 " ZZ6_FILIAL='" + xFilial("ZZ6") + "'  "		+ CRLF 
		cQuery += 	 "AND ZZ6_COD='" + cCodCli + "' " 	        	+ CRLF 
		cQuery += 	 "AND ZZ6.D_E_L_E_T_=' ' "						+ CRLF 	
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasZZ6,.T.,.T.)

		cCod   := (cAliasZZ6)->ZZ6_COD
		
		if ZZ6->(dbseek(xFilial("ZZ6")+cCod))
				RecLock("ZZ6",.F.)
     			ZZ6->(DBDelete())
      			ZZ6->(MsUnlock())
      			      			
			if ZZ7->(dbseek(xFilial("ZZ7")+cCod))
				while ZZ7->(dbseek(xFilial("ZZ7")+cCod))
					RecLock("ZZ7",.F.)
	     			ZZ7->(DBDelete())
	      			ZZ7->(MsUnlock())
	      		enddo
			endif
		endif	
						
	ZZ6->(RestArea(aZZ6))
	RestArea(aArea)

Return
//-------------------------------------------------------------------------------------------------//
/*
*Função de Adicionar licença via rotina automatica
*/
static function AddLicenca(cCodCli,cNomeCli)
Local cAtefatos		:= {}
Local aLicGeradas	:= {}
Local aAutoCab		:= {}
Local aAutoItem		:= {}
Local dtIni			:= stod("")
Local dtFim			:= stod("")
Local dtAltera		:= Ddatabase
Local cHora			:= TIME()
Local nVersao		:= 0
Local nI			:= 0
Local nPosDesc		:= 0
Local lConcCom		:= .F.
Local oModel		:= FwLoadModel("CadLicen")
Local cArtCode		:= ""
Local cNomeArt		:= ""
Local lUsoLmta		:= .F.
Local aItens		:= {}
Local cCodCli
Local cNomeCli
Local cTipo			:= ""
Local cEarSol		:= ""
Local cObser		:= ""
Local cJust			:= ""
Private lMsErroAuto := .F.	

	oiplicense 	:= Paramixb[5]
	aLicGeradas	:= Paramixb[2]
	aArqLicenca := Paramixb[1]
	cArtefatos	:= oiplicense:getArtifacts()
	
	//carregando os dados da Lista para o Array
	aadd(aAutoCab,{'ZZ6_COD', cCodCli})
	aadd(aAutoCab,{'ZZ6_CLIENT',cNomeCli})
	aadd(aAutoCab,{'ZZ6_DATA', dtAltera})
	aadd(aAutoCab,{'ZZ6_HORA', cHora})
	aadd(aAutoCab,{'ZZ6_LICEN', alltrim(aArqLicenca)})
		
	for nI := 1 to len(aLicGeradas)
		cArtCode 	:= aLicGeradas[nI][5]
		
		//validando o tipo de Acelerador PRJ, que não tem código de Artefato
		if ( Empty(cArtCode))
			cNomeArt := " "
		else
			nPosDesc	:= aScan(cArtefatos,{|X|X[1] == cArtCode})
			if (nPosDesc > 0)
				cNomeArt := cArtefatos[nPosDesc][2]
			else
				cNomeArt := ""	
			endif
		endif
		
		aAutoItem := {}
		
		// Array contendo dados dos itens
		aadd(aAutoItem,{'ZZ7_GRUPO', ALLTRIM(aLicGeradas[nI][FILELICENSE_ARTIFACT_GROUP])}) 
		aadd(aAutoItem,{'ZZ7_RAZAO', ALLTRIM(aLicGeradas[nI][FILELICENSE_ARTIFACT_NAME])}) 
		aadd(aAutoItem,{'ZZ7_FCLI',  ALLTRIM(aLicGeradas[nI][FILELICENSE_ARTIFACT_BRANCH])}) 
		aadd(aAutoItem,{'ZZ7_CNPJ',  ALLTRIM(aLicGeradas[nI][FILELICENSE_ARTIFACT_CNPJ])}) 
		aadd(aAutoItem,{'ZZ7_CODAC', cArtCode}) 
		aadd(aAutoItem,{'ZZ7_DATA',  SToD(aLicGeradas[nI][FILELICENSE_ARTIFACT_DSTART])})
		aadd(aAutoItem,{'ZZ7_NOM', 	 cNomeArt})
						 
		//Validando Licença Limitada
		if(aLicGeradas[nI][FILELICENSE_ARTIFACT_DAYS_TO_USE] > '0')
			lUsoLmta 	:= .T. 
			dtIni	 	:= SToD(aLicGeradas[nI][FILELICENSE_ARTIFACT_DSTART])
			dtFim	 	:= SToD(aLicGeradas[nI][FILELICENSE_ARTIFACT_DFINISH])
		else
			lUsoLmta	:= .F.
		endif
			
		aadd(aAutoItem,{'ZZ7_LIMITA', lUsoLmta})
		aadd(aAutoItem,{'ZZ7_DTINI', dtIni})
		aadd(aAutoItem,{'ZZ7_DTFIM', dtFim})
		aadd(aAutoItem,{'ZZ7_CCOMER', lConcCom})
		
			
		aadd(aAutoItem,{'ZZ7_VERSAO', nVersao})
		aadd(aAutoItem,{'ZZ7_CTIPO', cTipo})
		aadd(aAutoItem,{'ZZ7_EARSOL', cEarSol})
		aadd(aAutoItem,{'ZZ7_JUST', cJust})
		aadd(aAutoItem,{'ZZ7_OBS', cObser})
		
			
		aadd(aItens, aAutoItem )
	Next 
			
	
		//Chamando a Inclusão
		lMsErroAuto := .F.

		FWMVCRotAuto(oModel,"ZZ6",RotAut_Inclusao,{{'ZZ6MASTER', aAutoCab},{ 'ZZ7DETAIL', aItens}})
	
		if lMsErroAuto
			MostraErro()
		Endif
	
	
Return
//-------------------------------------------------------------------------------------------------//