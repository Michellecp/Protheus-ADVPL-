#Include "Protheus.ch"
#Include "TopConn.ch"
#INCLUDE "APWEBSRV.CH"


*   WebService: WSIPFLUIG 
*   Autor     : Daniel
*   Data 	  : 11/04/2011 
*   Descricao : Rotinas genericas usadas no webservice IP Compras 
*


WSSTRUCT tableHeader
	wsData nome as string 
	wsData descricao as string 
	wsData tipo as string 
	wsData tamanho as integer
	wsData decimal as integer
ENDWSSTRUCT

WSSTRUCT tableFields
	wsData valor as array of string 
	
ENDWSSTRUCT    

WSSTRUCT resultSet
	wsData headerFld as array of tableHeader OPTIONAL
	wsData colsFld   as array of tableFields OPTIONAL 
ENDWSSTRUCT

WSSTRUCT campos
	wsData nomeCampo as string
	wsData valor1 as string
	wsData valor2 as string  OPTIONAL
ENDWSSTRUCT

WSSTRUCT soItem
	wsData linha as  array of campos	 
ENDWSSTRUCT

WSSTRUCT SoHeader
	wsData soHd  as array of campos
	wsData soIt  as array of soItem OPTIONAL

ENDWSSTRUCT

WSSTRUCT soLinha
	wsData soIt  as array of soItem OPTIONAL
ENDWSSTRUCT

WSSERVICE WSIPFLUIG DESCRIPTION "Serviço de métodos genéricos usados no portal de vendas TOTVSIP"  NAMESPACE "http://totvsip.com.br/wsportal.apw"

    wsData cAdd  as string      
	wsData cSql  as string
	wsData table as resultSet
	wsData cDocumento as string
	wsData cMsg   as string
	wsData lMsg   as boolean    
	wsData cAlias as string
	wsData nIndice as integer
	wsData cChave as string
	wsData cCampo  as string
	wsData objRot as  soHeader   
	wsData nOpc as integer
	wsData cTipo as string
	wsData cFil as string
	wsData cPedido as string 
	wsData cCliente as string 
	wsData cLoja as string
	wsData cItem as string
	wsData cTable as string
	wsData objCampos  as  soItem
	wsData cFuncao as string 
	wsData cEmp as string
	wsData cKey	as string

	WsData pedido			As 	String
	WsData registroSCR		As 	Float
	//WsData aRetAprovadores	AS Array of WsRetAprovadores
	//WsData aRetStatusPC		AS Array of WsStatusPC
	
	wsData empresaAtual	 as string
	wsData filialAtual	 as string
	wsData usuarioLogado as string
	wsData processoFluig as string
		
	//WsData itensSC		AS ListItensSC
	//WsData cabecSC		AS cabecSComp	
	//WsData aRetSC		AS Array of WsRetSC
	
	//WsData aFiliais		As Array of WsGetFiliais
	//WsData aRastreioSC  As Array of WsRastreioSC
	//WsData aUsrProt		As Array of WsGetUsrProt
	//WsData aUsrFluig	As Array of WsGetUsrFluig
	
	wsMethod execQuery      DESCRIPTION "Executa query's retornando seu resultSet "  				
	//wsMethod existReg 	   	DESCRIPTION "Verifica se existe um registro. Usa o dbseek para estï¿½ verificaï¿½ï¿½o"
	//wsMethod retField 	   	DESCRIPTION "Retorna o campo de acordo com a parï¿½metro de acordo com a posiï¿½ï¿½o do registro"
	//wsMethod rotAuto        DESCRIPTION "Método responsï¿½vel por cadastrar registro via rotina automï¿½tica. "   
	//wsMethod getTable       DESCRIPTION "Método retorna o nome da tabela real "
	//wsMethod getFilial      DESCRIPTION "Método retorna a filial da tabela "
	//wsMethod grvReclock     DESCRIPTION "Método responsável pela gravaï¿½ï¿½o via reclock"
	//wsMethod execFunction   DESCRIPTION "Método responsável por executar função sem e com retorno"
	//wsMethod setSC   		DESCRIPTION "Gera SC"
	//wsMethod getEmpFil   	DESCRIPTION "Método responsável por executar função sem e com retorno"
	//wsMethod rastreamentoSC	DESCRIPTION "Rastreia movimentos pós SC"
	//wsMethod getStatusPC	DESCRIPTION "Retorna o status do PC que foi reprovado no FLUIG"
	//wsMethod retAprovadores	DESCRIPTION "Retorna aprovadores do PC"
	//wsMethod atuSCRFluig	DESCRIPTION "Atualiza SCR com o numero do processo FLUIG"
	//wsMethod liberPedCompra	DESCRIPTION "Libera o pedido de compra"
	
	//wsMethod getSupervisorProtheus	Description "Metodo para retornar supervisor do usuário do sistema protheus."
	//wsMethod getUserFluig   Description "Metodo para retornar o código do usuário Fluig."
	
ENDWSSERVICE

/*WsMethod getSupervisorProtheus WsReceive usuarioLogado WsSend aUsrProt WsService WSIPFLUIG
	
	local aArea		:= getArea()
	local nX		:= 0
	local nDados	:= 0
	local aDados	:= {}
	local aUsrProt	:= {}
	
	local oApoio	:=	ApoioSC():New()
	
//	RpcClearEnv() 
	conout("Metodo - getUsuarioProtheus Logando no contexto " + usuarioLogado)
//	rpcsettype(3)
//    RpcSetEnv("20","83", ,,"COM")
			
	//Verificando todas as filiais da empresa informada
	aDados := oApoio:getSupProtheus(usuarioLogado)
	
	nDados := len(aDados)
		
	for nX:=1 to nDados
		
		aAdd(::aUsrProt, WsClassNew("WsGetUsrProt"))
		
		aTail(::aUsrProt):codigoUsr	:=	aDados[nX][1]
		aTail(::aUsrProt):nomeUsr	:=	aDados[nX][2]
				
	next nX 
				
	restArea(aArea)
	
return (.T.)

WsMethod getUserFluig WsReceive usuarioLogado WsSend aUsrFluig WsService WSIPFLUIG
	
	local aArea		:= getArea()
	local nX		:= 0
	local nDados	:= 0
	local aDados	:= {}
	local aUsrFluig	:= {}
	
	local oApoio	:=	ApoioSC():New()
	
//	RpcClearEnv() 
	conout("Metodo - getUsuarioFluig Logando no contexto " + usuarioLogado)
//	rpcsettype(3)
//    RpcSetEnv("20","83", ,,"COM")
			
	//Verificando todas as filiais da empresa informada
	aDados := oApoio:getUsrFluig(usuarioLogado)
	
	nDados := len(aDados)
		
	for nX:=1 to nDados
		
		aAdd(::aUsrFluig, WsClassNew("WsGetUsrFluig"))
		
		aTail(::aUsrFluig):codigoUsrf :=	aDados[nX][1]
		aTail(::aUsrFluig):nomeUsrf	  :=	aDados[nX][2]
				
	next nX 
				
	restArea(aArea)
	
return (.T.)


WsMethod liberPedCompra WsReceive empresaAtual, filialAtual, pedido WsSend cMsg WsService WSIPFLUIG
	
	local aArea		:= getArea()
	local aResult	:= {}
	local lRetorno 	:= .T.
	local oApoio	:=	ApoioSC():New()
	
//	RpcClearEnv()
	conout("Metodo - liberPedCompra Logando no contexto 01/" + filialAtual)
//	rpcsettype(3)
//    RpcSetEnv(empresaAtual, filialAtual, ,,"COM")
    
	::cMsg := oApoio:atuSC7(filialAtual,pedido)
	
	lRetorno := (::cMsg == "OK")
	
	restArea(aArea)
	
Return(.T.)

WsMethod atuSCRFluig WsReceive empresaAtual, filialAtual, registroSCR, processoFluig WsSend cMsg WsService WSIPFLUIG
	
	local aArea		:= getArea()
	local aResult	:= {}
	local lRetorno 	:= .T.
	local oApoio	:=	ApoioSC():New()
	
//	RpcClearEnv()
	conout("Metodo - atuSCRFluig Logando no contexto 01/" + filialAtual)
//	rpcsettype(3)
//    RpcSetEnv(empresaAtual, filialAtual, ,,"COM")
    
	::cMsg := oApoio:atuSCR(registroSCR, processoFluig)
	
	lRetorno := (::cMsg == "OK")
	
	restArea(aArea)
	
return (lRetorno)

WsMethod getStatusPC WsReceive empresaAtual, filialAtual, pedido WsSend aRetStatusPC WsService WSIPFLUIG
	
	local aArea		:= getArea()
	local aResult	:= {}
	local lRetorno 	:= .T.
	local oApoio	:=	ApoioSC():New()
	
//	RpcClearEnv() 
	conout("Metodo - getStatusPC Logando no contexto 01/" + filialAtual)
//	rpcsettype(3) 
//   RpcSetEnv(empresaAtual, filialAtual, ,,"COM")
    
	aResult := oApoio:getStatusPC(pedido )
	
	aAdd(aRetStatusPC, WsClassNew("WsStatusPC"))
	
	aTail(aRetStatusPC):status		:=	aResult[1][1]
	aTail(aRetStatusPC):mensagem	:=	aResult[1][2]
	
	restArea(aArea)
	
return (lRetorno)

WsMethod retAprovadores WsReceive empresaAtual, filialAtual, pedido WsSend aRetAprovadores WsService WSIPFLUIG

	local aArea		:= getArea()
	local aDados	:= {}
	local i			:= 0	
	local oApoio	:=	ApoioSC():New()
	
//	RpcClearEnv()
	conout("Metodo - retAprovadores Logando no contexto 01/" + filialAtual)
//	rpcsettype(3)
//    RpcSetEnv(empresaAtual, filialAtual, ,,"COM")
    
	aDados := oApoio:retornaAprovadores(filialAtual, pedido)
	
	if len(aDados) > 0
		for i := 1 to len(aDados)
			aAdd(aRetAprovadores, WsClassNew("WsRetAprovadores"))
			
			aTail(aRetAprovadores):idFluig	:=	iif(valtype(aDados[i][1]) <> 'U',Alltrim(aDados[i][1]),"")
			aTail(aRetAprovadores):nivel	:=	iif(valtype(aDados[i][2]) <> 'U',Alltrim(aDados[i][2]),"")
			aTail(aRetAprovadores):registro	:=	iif(valtype(aDados[i][3]) <> 'U',aDados[i][3],"")
			
		next i
	endIf
	
	restArea(aArea)

Return (.T.)

WsMethod SetSC WsReceive empresaAtual, cabecSC, itensSC WsSend aRetSC WsService WSIPFLUIG
	
	Local aArea		:=	getArea()
	local aResult	:= {}
	
	local oApoio	:=	ApoioSC():New()
//	RpcClearEnv() 
	conout("Metodo - SetSC Logando no contexto 01/"+cabecSC:filialSC)
//	RpcSetType(3)
//    RpcSetEnv(empresaAtual, cabecSC:filialSC, ,,"COM")
			
	aResult := oApoio:criaSC(cabecSC,itensSC )
	
	aAdd(aRetSC, WsClassNew("WsRetSC"))
	
	aTail(aRetSC):status	:=	aResult[1][1]
	aTail(aRetSC):mensagem	:=	aResult[1][2]
			
	restArea(aArea)
 	
Return(.T.)

WsMethod getEmpFil WsReceive usuarioLogado WsSend aFiliais WsService WSIPFLUIG

	Local aArea		:= getArea()
	local nX		:= 0
	local nDados	:= 0
	local aDados	:= {}
	
	local oApoio	:=	ApoioSC():New()
	
//	RpcClearEnv() 
	conout("Metodo - getEmpFil Logando no contexto 01/" )
//	rpcsettype(3)
//    RpcSetEnv("20", "83", ,,"COM")

	aDados := oApoio:getFiliais(usuarioLogado)
	
	nDados := len(aDados)
	
	for nX := 1 to nDados
		
		aAdd(aFiliais, WsClassNew("WsGetFiliais"))
			
		aTail(aFiliais):cCodigoEmpresa		:=	Alltrim(aDados[nX][1])
		aTail(aFiliais):cCodigoFilial		:=	Alltrim(aDados[nX][2])
		aTail(aFiliais):cNomeFilial			:=	Alltrim(aDados[nX][3])
		aTail(aFiliais):cNome				:=	Alltrim(aDados[nX][4])
		aTail(aFiliais):cEnderecoCobranca	:=	Alltrim(aDados[nX][5])
		aTail(aFiliais):cCidadeCobranca		:=	Alltrim(aDados[nX][6])
		aTail(aFiliais):cEstadoCobranca		:=	Alltrim(aDados[nX][7])
		aTail(aFiliais):cCepCobranca		:=	Alltrim(aDados[nX][8])
				
	next nX
		
	restArea(aArea)
	
Return(.T.)

WsMethod rastreamentoSC WsReceive empresaAtual, filialAtual, processoFluig WsSend aRastreioSC WsService WSIPFLUIG

	Local aArea		:= getArea()
	local aDados	:= {}
	local i			:= 0	
	local oApoio	:=	ApoioSC():New()
	
//	RpcClearEnv() 
	conout("Metodo - rastreamentoSC Logando no contexto 01/" + filialAtual)
//	rpcsettype(3) 
//    RpcSetEnv(empresaAtual, filialAtual, ,,"COM")
    
	aDados := oApoio:getRastreio(filialAtual, processoFluig)
	
	if len(aDados) > 0
		for i:=1 to len(aDados)
			aAdd(aRastreioSC, WsClassNew("WsRastreioSC"))
				
			aTail(aRastreioSC):solicitacaoCompras	:=	Alltrim(aDados[i][1])
			aTail(aRastreioSC):cotacao				:=	iif(valtype(aDados[i][2]) <> 'U',Alltrim(aDados[i][2]),"")
			aTail(aRastreioSC):pedidoCompras		:=	iif(valtype(aDados[i][3]) <> 'U',Alltrim(aDados[i][3]),"")
			aTail(aRastreioSC):notaFiscal			:=	iif(valtype(aDados[i][4]) <> 'U',Alltrim(aDados[i][4]),"")
			aTail(aRastreioSC):statusPC				:=	iif(valtype(aDados[i][5]) <> 'U',Alltrim(aDados[i][5]),"")
		next i
	endIf
	
	restArea(aArea)
return (.T.)*/

WSMETHOD execQuery  WSRECEIVE cSql,cEmp,cFil,cKey WSSEND table WSSERVICE WSIPFLUIG
	local cAlias := getNextAlias()
	local nI     := 0
	local cCampo := ""
	local nX     := 0
	
//	RpcSetType(3)
//	RpcClearEnv()
//	RpcSetEnv( ::cEmp, ::cFil)
	
//	if !checkKey(cKey)
//		RpcClearEnv()
//		SetSoapFault("KEY", "Chave invalida !!")
//		return .f.
//	end if
	
	if !Empty(cSql)
	
		conout(Replicate("=",50))
		conout("[ WSMETHOD execQuery | "+ dtoc(Date()) +" - "+ time() +" ] ")
		conout(Replicate("=",50))
		conout(cSql)
		TCQUERY ::cSql NEW ALIAS (cAlias)
		
		// carregar header
		for nI:= 1 to (cAlias)->(fCount())
			cCampo := (cAlias)->(FieldName(nI))
			conout("cCampo = " + cCampo)
			if !cCampo $ "D_E_L_E_T_*R_E_C_N_O_*R_E_C_D_E_L_"
				aadd(::table:headerFld,WsClassNew("tableHeader"))
					 ::table:headerFld[nI]:nome      := cCampo 
					 ::table:headerFld[nI]:descricao := RetTitle(cCampo)
					 ::table:headerFld[nI]:tamanho   := (cAlias)->(dbfieldinfo(3,nI))
					 ::table:headerFld[nI]:decimal   := (cAlias)->(dbfieldinfo(4,nI))
					 ::table:headerFld[nI]:tipo      := (cAlias)->(dbfieldinfo(2,nI))
			endIf	 
		next nI
		
		
		while (cAlias)->(!eof())
			aadd(::table:colsFld,WsClassNew("tableFields"))
				nX++
				::table:colsFld[nX]:valor := {}
				
				for nI:= 1 to (cAlias)->(fCount())
					//conout("Campo "+(cAlias)->(FieldName(nI)))
					if !(cAlias)->(FieldName(nI)) $ "D_E_L_E_T_*R_E_C_N_O_*R_E_C_D_E_L_"
						Do Case
							
							//Case (cAlias)->(dbfieldinfo(2,nI)) == "N"
							Case InfoSX3((cAlias)->(FieldName(nI)))[3] =="N"
//								conout("Campo(Inteiro) "+(cAlias)->(FieldName(nI)))
//								conout("Campo(Inteiro) "+(cAlias)->(FieldName(nI))+" >> "+transform((cAlias)->(FieldGet(FieldPos( (cAlias)->(FieldName(nI)))  )),PesqPictQt((cAlias)->(FieldName(nI)))) )
								aadd(::table:colsFld[nX]:valor,transform((cAlias)->(FieldGet(FieldPos( (cAlias)->(FieldName(nI)))  )),PesqPictQt((cAlias)->(FieldName(nI)))) )
							Case InfoSX3((cAlias)->(FieldName(nI)))[3] =="D"
//								conout("Campo(Data) "+(cAlias)->(FieldName(nI)))
//								conout("Campo(Data) "+(cAlias)->(FieldName(nI))+" >> "+dtoc(STOD((cAlias)->(FieldGet(FieldPos((cAlias)->(FieldName(nI))))))))
								aadd(::table:colsFld[nX]:valor,dtoc(STOD((cAlias)->(FieldGet(FieldPos((cAlias)->(FieldName(nI))))))))
							OtherWise
//								conout("Campo(String) "+(cAlias)->(FieldName(nI)))
//								conout("Campo(String) "+(cAlias)->(FieldName(nI))+" >> "+(cAlias)->(FieldGet(FieldPos((cAlias)->(FieldName(nI))))))
								aadd(::table:colsFld[nX]:valor, AllTrim(EnCodeUtf8(NOACENTO((cAlias)->(FieldGet(FieldPos((cAlias)->(FieldName(nI)))))))) )
						EndCase		
					endIf
				next nI
		
			(cAlias)->(dbSkip())
		endDo
		//conout("TERMINO DA ADD EM TABLES")		
	endIf	 
	
	(cAlias)->(dbcloseArea())
	
return(.t.)

static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
Local cTio   := "ãõ"
Local cCecid := "çÇ"

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next
For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If Asc(cChar) < 32 .Or. Asc(cChar) > 123 .Or. cChar $ '&'
		cString := StrTran(cString,cChar,".")
	Endif
	if Asc(cChar) == 157
		cString := StrTran(cString,cChar," ")
		//conout("achou ASCII 157")
	endIf
Next nX
cString := _NoTags(cString)
Return cString


/*WSMETHOD existReg  WSRECEIVE cAlias,nIndice,cChave,cEmp,cFil,cKey WSSEND lMsg WSSERVICE WSIPFLUIG
	local aArea := getArea() 
	local lRet  := .T.

	conout("METHOD: existReg ")	
	
//	RpcSetType(3)
//	RpcSetEnv( ::cEmp, ::cFil)
	
	if !checkKey(cKey)
		SetSoapFault("KEY", "Chave invalida !!")
		return .f.
	end if
	
	if !Empty(::cAlias) .and. !Empty(::nIndice) .and. !Empty(::cChave)
		::lMsg := existCpo(cAlias,cChave,nIndice)
	else
	 	lRet := .F.	 
	endIf
	restArea(aArea)

return lRet

WSMETHOD retField  WSRECEIVE cAlias,nIndice,cChave,cCampo,cEmp,cFil,cKey WSSEND cMsg WSSERVICE WSIPFLUIG
	local aArea := getArea()
	local xRet 
	local aInfo:= {} 
	
	conout("METHOD: retField ")		
	
//	RpcSetType(3)
//	RpcSetEnv( ::cEmp, ::cFil)
	
	if !checkKey(cKey)
		SetSoapFault("KEY", "Chave invalida !!")
		return .f.
	end if
	
	if !Empty(::cAlias) .and. !Empty(::nIndice) .and. !Empty(::cChave) .and. !Empty(::cCampo)
		
		xRet :=  posicione(::cAlias,::nIndice,::cChave,::cCampo)
		aInfo:= InfoSX3(::cCampo)
		if aInfo[3]=="N"
			::cMsg := cValToChar(xRet)		
		elseIf aInfo[3]=="D"
			::cMsg := dToC(xRet)
		else
			::cMsg := xRet
		endif
		
	else
		::cMsg := ""
	endif
	restArea(aArea)
	
return(.T.)

WSMETHOD rotAuto  WSRECEIVE objRot,nOpc,cTipo,cEmp,cFil,cKey WSSEND cMsg WSSERVICE WSIPFLUIG
	local aHeader := {}
	local aCols   := {}
	local aLinha  := {}
	local nI      := 0
	local nX      := 0
	local nJ      := 0
	local lRetorno:=.T.
	local cRotina := ""
	local cErro   := ""
	local aErro   := {}
	Local aArea	  := GetArea()
	local nPos 	 := 0
	
	Private lMsErroAuto		:= .F. //Determina se houve algum tipo de erro durante a execucao do ExecAuto
	Private lMsHelpAuto		:= .T. //Define se mostra ou não os erros na tela (T= Nao mostra; F=Mostra)
	Private lAutoErrNoFile	:= .T. //Habilita a gravacao de erro da rotina automatica

	conout("METHOD: rotAuto ")		
		
//	RpcSetType(3)
//	RpcClearEnv()
//	RpcSetEnv( ::cEmp, ::cFil)
	
	if !checkKey(cKey)
		SetSoapFault("KEY", "Chave invalida !!")
		return .f.
	end if
	
	conout("EMPRESA->"+::cEmp)
	conout("FILIAL->"+::cFil)
	
	// cabeï¿½alho da rotina
	for nI:=1  to len(::objRot:soHd)
		conout("Linha"+cValTochar(nI)+"-"+::objRot:soHd[nI]:nomeCampo+"-"+::objRot:soHd[nI]:valor1+"-"+::objRot:soHd[nI]:valor2)
		
		if infoSx3(::objRot:soHd[nI]:nomeCampo)[3] == "N"
			aadd(aHeader,{::objRot:soHd[nI]:nomeCampo, val(::objRot:soHd[nI]:valor1) ,iif(empty( ::objRot:soHd[nI]:valor2 ),nil,::objRot:soHd[nI]:valor2) })
		elseIf infoSx3(::objRot:soHd[nI]:nomeCampo)[3] =="D"
			aadd(aHeader,{::objRot:soHd[nI]:nomeCampo, ctod(::objRot:soHd[nI]:valor1) ,iif(empty( ::objRot:soHd[nI]:valor2 ),nil,::objRot:soHd[nI]:valor2) })
		else
			if  !allTrim(::objRot:soHd[nI]:nomeCampo) $ "AUTBANCO|AUTAGENCIA|AUTCONTA"
				aadd(aHeader,{::objRot:soHd[nI]:nomeCampo, padR(::objRot:soHd[nI]:valor1,infoSx3(::objRot:soHd[nI]:nomeCampo)[1] ) ,iif(empty( ::objRot:soHd[nI]:valor2 ),nil,::objRot:soHd[nI]:valor2)  })
			else  
				aadd(aHeader,{::objRot:soHd[nI]:nomeCampo,::objRot:soHd[nI]:valor1 ,::objRot:soHd[nI]:valor2})
			end if
		endif
		
		
	
	next nI
		
	// item para rotina
	for nX := 1 to len(::objRot:soIt)
	 	for nJ := 1 to len(::objRot:soIt[nX]:linha)
	 		
	 		if InfoSX3(::objRot:soIt[nX]:linha[nJ]:nomeCampo)[3] =="N"
	 			aadd(aLinha,{::objRot:soIt[nX]:linha[nJ]:nomeCampo,val(::objRot:soIt[nX]:linha[nJ]:valor1),iif(empty(::objRot:soIt[nX]:linha[nJ]:valor2),nil,::objRot:soIt[nX]:linha[nJ]:valor2 )})
	 		elseIf	InfoSX3(::objRot:soIt[nX]:linha[nJ]:nomeCampo)[3] =="D"
	 			aadd(aLinha,{::objRot:soIt[nX]:linha[nJ]:nomeCampo,ctod(::objRot:soIt[nX]:linha[nJ]:valor1),iif(empty(::objRot:soIt[nX]:linha[nJ]:valor2),nil,::objRot:soIt[nX]:linha[nJ]:valor2 )})
	 		else
	 			aadd(aLinha,{::objRot:soIt[nX]:linha[nJ]:nomeCampo,padR(::objRot:soIt[nX]:linha[nJ]:valor1,tamSx3(::objRot:soIt[nX]:linha[nJ]:nomeCampo)[1] ),iif(empty(::objRot:soIt[nX]:linha[nJ]:valor2),nil,::objRot:soIt[nX]:linha[nJ]:valor2 )})
	 		endif
	 		
	 		conout("Linha"+cValTochar(nx)+"-"+::objRot:soIt[nX]:linha[nJ]:nomeCampo)
	 		conout("Linha"+cValTochar(nx)+"-"+::objRot:soIt[nX]:linha[nJ]:valor1)
	 		conout("Linha"+cValTochar(nx)+"-"+::objRot:soIt[nX]:linha[nJ]:valor2)
		next nj
		aadd(aCols,aLinha)
	    aLinha :={}
	next nX	

 	CONOUT(" QTD CABEC"+STR(LEN(AHEADER)))
 	do Case 
 		Case cTipo == "PV"
	 		
 			aHeader := FWVetByDic( aHeader, "SC5")
 			aCols 	:= FWVetByDic( aCols, "SC6", .t.)
 			
 			MSExecAuto( {|x,y,z| Mata410(x,y,z)} , aHeader, aCols, nOpc)
	 		
 		Case cTipo == "ORC"
 			cRotina := "ORCAMENTO"
 			MATA415(aHeader,aCols,nOpc)	
 		Case cTipo == "CLI"
 			cRotina := "CLIENTE"	
 			MATA030(aHeader,nOpc)					
 		Case cTipo == "FOR"
 			cRotina := "FORNECEDOR"	
 			MATA020(aHeader,nOpc)
 		Case cRotina == "PC"
 			nModulo := 2
 			MsExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,FWVetByDic(aHeader,"SC7"),FWVetByDic(aCols,"SC7",.T.),nOpc)	
 		Case cTipo == "PRO"
 			cRotina := "PRODUTO"	
 			MATA010(aHeader,nOpc)	
 		Case cTipo == "MATA110"
 			aCols := FWVetByDic( aCols, "SC1", .T. )
 			MsExecAuto({|x, y, z| MATA110(x, y, z)}, aHeader, aCols, nOpc)
 		Case cTipo =="FINA050"
 			cRotina := "FINA050"
 			nPos:= aScan(aHeader,{|x| alltrim(x[1]) =="E2_EMISSAO"  })
 			if nPos > 0
 				dDatabase := aHeader[nPos,2]
 			end if 
 			
 			if nOpc == 5 
 				
 				nPos := aScan(aHeader,{|x| alltrim(x[1]) =="E2_NUM"  })
 				aHeader[nPos,2] := strZero( val(aHeader[nPos,2]) , tamSx3("E2_NUM")[1] ) 
 				
 				
 				//MSExecAuto({|a,b,c,d,e,f,g| FINA050(a,b,c,d,e,f,g)}, , ,5, Nil, Nil, Nil,.T.,.T.)	
 				MSExecAuto({|a,b,c,d,e,f,g| Fina050(a,b,c,d,e,f,g)}, aHeader, ,5,,,.T.,.T.)
 			else 
 				MSExecAuto({|a,b,c,d,e,f,g| FINA050(a,b,c,d,e,f,g)}, aHeader, nOpc, Nil, Nil, Nil,.F.,.F.)
 			
 			end If
 		otherwise
 			lRetorno :=.F.
 	endCase
 	
	If lMsErroAuto
		aErro := GetAutoGRLog()
		For nX := 1 To Len(aErro)
			cErro += strTran(aErro[nX]  ,Chr(13)+Chr(10), " ")+" <br> "
		Next nX
		//SetSoapFault(cRotina,cErro)
		::cMsg := cErro
		lRetorno := .t.
	else 
		::cMsg := "OK" 
	Endif
	
	restArea(aArea)
	
return(lRetorno)

wsMethod getTable WSRECEIVE  cTable,cEmp,cFil,cKey WSSEND cMsg WSSERVICE WSIPFLUIG
	Local lRet := .T.    

	conout("METHOD: getTable ")	
	
//	RpcSetType(3)
//	RPCClearEnv()
//	RpcSetEnv( ::cEmp, ::cFil)
	
	if !checkKey(cKey)
		SetSoapFault("KEY", "Chave invalida !!")
		return .f.
	end if
	
	::cMsg := RetSqlName(cTable)
			
	if Empty(::cMsg)
		lRet := .F.
	endIf

	
return lRet

wsMethod getFilial  WSRECEIVE  cTable,cEmp,cFil,cKey WSSEND cMsg WSSERVICE WSIPFLUIG
	Local lRet := .T.

	conout("METHOD: getFilial ")	
	
//	RpcSetType(3)
//	RPCClearEnv()
//	RpcSetEnv( ::cEmp, ::cFil)
	
	if !checkKey(cKey)
		setSoupFalt("KEY", "Chave invalida !!")
		return .f.
	end if
	
	::cMsg := xFilial(cTable)
	

	
return lRet     


wsMethod grvReclock  WSRECEIVE  objCampos, cAlias,nOpc,cEmp,cFil,cKey WSSEND cMsg WSSERVICE WSIPFLUIG
	Local lRet := .T.
	Local nX   := 0
	Local nJ   := 0
	Local aLinha := {}
	Local cCampo := ""
	Local aParam  := {}  
	
	conout("METHOD: grvReclock ")		
	
//	RpcSetType(3)
//	RpcSetEnv( ::cEmp, ::cFil)
	
	if !checkKey(cKey)
		SetSoapFault("KEY", "Chave invalida !!")
		return .f.
	end if
		
   // item para rotina
   conout("Tamanho"+cValToChar(len(::objCampos:linha)))
	
	
 	for nJ := 1 to len(::objCampos:linha)
 		
 		
 		if InfoSX3(::objCampos:linha[nJ]:nomeCampo)[3] =="N"
 			aadd(aLinha,{::objCampos:linha[nJ]:nomeCampo,val(::objCampos:linha[nJ]:valor1),iif(empty(::objCampos:linha[nJ]:valor2),nil,::objCampos:linha[nJ]:valor2 )})
 		elseIf	InfoSX3(::objCampos:linha[nJ]:nomeCampo)[3] =="D"
 			aadd(aLinha,{::objCampos:linha[nJ]:nomeCampo,stod(::objCampos:linha[nJ]:valor1),iif(empty(::objCampos:linha[nJ]:valor2),nil,::objCampos:linha[nJ]:valor2 )})
 		else
 			
 				aadd(aLinha,{::objCampos:linha[nJ]:nomeCampo,::objCampos:linha[nJ]:valor1,iif(empty(::objCampos:linha[nJ]:valor2),nil,::objCampos:linha[nJ]:valor2 )})
 			
 		endif
 		
 		
 		
 		//conout("Linha"+cValTochar(nJ)+"-"+::objCampos:linha[nJ]:nomeCampo)
 		//conout("Linha"+cValTochar(nJ)+"-"+::objCampos:linha[nJ]:valor1)
 	   //conout("Linha"+cValTochar(nJ)+"-"+::objCampos:linha[nJ]:valor2)
	next nj
		
	    
	 aParam := {aLinha,cAlias,nOpc}
	
	if ExistBlock("IPWSRCPT")		
	    lRet := ExecBlock("IPWSRCPT",.F.,.F.,aParam)
	endif
	
	

Return lRet 


wsMethod execFunction  WSRECEIVE  cFuncao,cEmp,cFil,cKey  WSSEND cMsg WSSERVICE WSIPFLUIG
	local xRet 
	local lRet := .T.
	local nI := 0

	conout("METHOD: execFunction ")		
	
//	RPCClearEnv()
//	RpcSetType(3)
//	RpcSetEnv( ::cEmp, ::cFil)
	
	if !checkKey(cKey)
		SetSoapFault("KEY", "Chave invalida !!")
		return .f.
	end if
	
	if !Empty(cFuncao)
		
		xRet := &(::cFuncao)
		
		if valType(xRet)=="N"
			::cMsg := cValTochar(xRet)		
		elseIf valType(xRet)=="D"
			::cMsg := dToC(xRet)
		elseIf valType(xRet)=="L"
			if xRet
				::cMsg := "T"
			else
				::cMsg := "F" 
			endIf
		elseIf valType(xRet)=="A"
			for nI := 1 to len(xRet)
				if empty(::cMsg)
					::cMsg := xRet[nI]
				else 
					::cMsg :=::cMsg+";"+xRet[nI]
				end if 
			next nI
		else
			::cMsg := AllTrim(xRet)
		endif		
		
	else
		SetSoapFault("ExecFunction","Informe a funï¿½ï¿½o.")
		lRet := .F.
	endif

   
return lRet

static  Function InfoSX3(cCampo)
	Local	aAliasSX3	:=	SX3->(	GetArea())
	Local	aRetorno	:=	{0,0,""}

	SX3->(DbSetOrder(2))
	SX3->(DbSeek(cCampo))

	If SX3->(Found())
		aRetorno[1] := SX3->X3_TAMANHO
		aRetorno[2] := SX3->X3_DECIMAL
		aRetorno[3] := SX3->X3_TIPO
	EndIf

	RestArea(aAliasSX3)

Return(aRetorno)

static function checkKey(cKey)
	
	//dbSelectArea("ZIP")
	//ZIP->(dbSetOrder(1))
	//return dbSeek(xFilial("ZIP")+padR(cKey,100))
	
return .t.*/
