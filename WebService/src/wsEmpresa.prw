#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

#DEFINE OP_INCLUSAO 3

/**************************************************************************************************************************
* WebService: WS_EMPRESA
* Objetivo:Retornar as Filiais/Empresas E Municipios cadastradas e Inclusão automatica de cliente via Fluig
* Data:15/06/18
* Autor: Michelle Pacheco
* Alterado:
*/

//Estrutura
WSSTRUCT Empresas
	WSDATA M0_CODIGO AS STRING //Codigo Empresa
	WSDATA M0_CODFIL AS STRING //Codigo Filial
	WSDATA M0_FILIAL AS STRING //Filias
	WSDATA M0_NOME   AS STRING //Empresa
ENDWSSTRUCT

WSSTRUCT Municipios
	WSDATA CC2_EST AS STRING
	WSDATA CC2_MUN AS STRING
ENDWSSTRUCT

WSSTRUCT Clientes
	WSDATA COD		 AS STRING //A1_COD
	WSDATA LOJA 	 AS STRING //A1_LOJA
	WSDATA NOME		 AS STRING //A1_NOME
	WSDATA NOMEREDUZ AS STRING //A1_NREDUZ
	WSDATA TIPO		 AS STRING //A1_TIPO
	WSDATA ENDERECO	 AS STRING //A1_END
	WSDATA ESTADO 	 AS STRING //A1_EST
	WSDATA MUNICIPIO AS STRING //A1_MUN
ENDWSSTRUCT

WSSTRUCT ClienteRet 
	WSDATA STATUS 	AS STRING
	WSDATA MENSAGEM AS STRING
ENDWSSTRUCT	

WSSERVICE wsCadastro	DESCRIPTION "Serviço de Retorno de Dados"
//Propriedade
	WSDATA dadosRet	  AS Array of Empresas
	WSDATA munRet  	  AS Array of Municipios
	WSDATA ESTADO	  AS STRING
	WSDATA ClienteEnt AS CLIENTES
	WSDATA Retorno	  AS ClienteRet
	WSDATA cEmpJob	  AS STRING
	WSDATA cFilJob	  AS STRING
	
//Metodo
	WSMETHOD getCadastro   DESCRIPTION "<b>Método de retorno Empresa.</b><br>Retorno!!</br>"
	WSMETHOD getMunicipio  DESCRIPTION "<b>Método de retorno Municipio.</b><br>Retorno!!</br>"
	WSMETHOD AddCliente    DESCRIPTION "<b>Método para a inclusão de Cliente via Fluig"
ENDWSSERVICE

//----------------------------------------------------------------------------------------------------------------------------
WSMETHOD getCadastro WSRECEIVE NULLPARAM WSSEND dadosRet WSSERVICE wsCadastro
Local oNewEmpresa  := nil

dbUseArea( .T., , "SIGAMAT.EMP", "QRYSM0", .T., .F.)

while QRYSM0->(!EOF())
		oNewEmpresa := WSClassNew( "Empresas" )
		oNewEmpresa:M0_CODIGO := QRYSM0->M0_CODIGO
		oNewEmpresa:M0_CODFIL := QRYSM0->M0_CODFIL
		oNewEmpresa:M0_FILIAL := QRYSM0->M0_FILIAL
		oNewEmpresa:M0_NOME   := QRYSM0->M0_NOME
		
		aadd(::dadosRet,oNewEmpresa)
		QRYSM0->(dbSkip())	
endDo

QRYSM0->(dbCloseArea())


Return .T.

//-----------------------------------------------------------------------------------------------------------------------------
WSMETHOD getMunicipio WSRECEIVE cEmpJob, cFilJob, ESTADO WSSEND munRet WSSERVICE wsCadastro

Local cAliasCC2 := getNextAlias()
Local cQuery 	:= ""
Local   cArea 	:= "CC2"

PREPARE ENVIRONMENT EMPRESA cEmpJob  FILIAL cFilJob 

//Contruindo a consulta
cQuery += "  SELECT 		"							+CRLF
cQuery += "  CC2_EST, 		"							+CRLF
cQuery += "  CC2_MUN		"							+CRLF
cQuery += "  FROM" +RetSqlTab("CC2")					+CRLF
cQuery += "	 WHERE						"				+CRLF
cQuery += "	 CC2_FILIAL  = '"+xFilial('CC2')+"' "		+CRLF
if !(EMPTY(ESTADO))
cQuery += "  AND CC2_EST = '"+ESTADO+"' " 				+CRLF
else	
cQuery += "  AND  CC2.D_E_L_E_T_=' ' "					+CRLF
//cQuery := ChangeQuery(cQuery)
endif

tcQuery cQuery new Alias &cAliasCC2

while (cAliasCC2)->(!EOF())
		oNewMunicipio := WSClassNew( "Municipios")
		oNewMunicipio:CC2_EST := (cAliasCC2)->CC2_EST
		oNewMunicipio:CC2_MUN := (cAliasCC2)->CC2_MUN
		
		aadd(::munRet,oNewMunicipio)
		(cAliasCC2)->(DbSkip())
endDo

(cAliasCC2)->(dbCloseArea())

Return .T.

//----------------------------------------------------------------------------------------------------
WSMETHOD AddCliente WSRECEIVE cEmpJob, cFilJob,ClienteEnt  WSSEND Retorno WSSERVICE wsCadastro

Local   aCliente  		:= {}
Local   cArea 			:= "SA1"
Local   cErro			:= ""
Private	lMsErroAuto 	:= .F.
Private lAutoErrNoFile  := .T.

PREPARE ENVIRONMENT EMPRESA cEmpJob  FILIAL cFilJob 

  		dbSelectArea(cArea)         
  		
  		  		  	
  	  	aadd(aCliente,{"A1_COD",   	ClienteEnt:COD, 		Nil})
  	   	aadd(aCliente,{"A1_LOJA",  	ClienteEnt:LOJA,		Nil})
  	  	aadd(aCliente,{"A1_NOME",  	ClienteEnt:NOME, 		Nil})
  	  	aadd(aCliente,{"A1_NREDUZ",	ClienteEnt:NOMEREDUZ,	Nil})
  	  	aadd(aCliente,{"A1_TIPO",	ClienteEnt:TIPO,		Nil})
  	  	aadd(aCliente,{"A1_END",	ClienteEnt:ENDERECO,	Nil})
		aadd(aCliente,{"A1_EST",	ClienteEnt:ESTADO,		Nil})
		aadd(aCliente,{"A1_MUN",	ClienteEnt:MUNICIPIO,	Nil})
		
				
		MSExecAuto({|x,y| Mata030(x,y)}, aCliente, OP_INCLUSAO) //Inclusão via Rotina Automática 3 - Inclusão
		
		If lMsErroAuto
			cErro := GeraErra()
		endif	
		::Retorno:STATUS 	:= if(lMsErroAuto,"NOk","Ok")
		::Retorno:MENSAGEM 	:= cErro
		
//Reset Environment
 
Return .T.	

//------------------------------------------------------------------------------------------------------
static function GeraErra() //Função para retorno de erro da função automatica
	Local 	aErro			:= {}
	Local   cMsg			:= ""
	Local   nI				:= 0
	

	aErro := GetAutoGRLog()
	for nI := 1 to len(aErro)
	conout(cvaltochar(nI))
 		cMsg+= aErro[nI]+"<br>"
 	next nI	

Return cMsg	
//-----------------------------------------------------------------------------------------------------
