#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/**************************************************************************************************************************
* WebService: WS_Acelerador
* Objetivo:Retornar pesquisa de acordo com a solicitação feita via Fluig, (CNPJ, Razão Social, Código do Cliente)
* Data:15/10/18
* Autor: Michelle Pacheco
* Alterado:
*/
//Estrutura
WSSTRUCT Acelerador
	WSDATA 	CODIGO	 		AS STRING 
	WSDATA 	ZZ6_CLIENT  	AS STRING 
	WSDATA  ZZ7_DTINI		AS STRING
	WSDATA  ZZ7_GRUPO  		AS STRING
	WSDATA  ZZ7_RAZAO		AS STRING
	WSDATA  ZZ7_CNPJ		AS STRING
	WSDATA  ZZ7_FCLI  		AS STRING
	WSDATA  ZZ7_CODAC		AS STRING
	WSDATA  ZZ7_NOME  		AS STRING
ENDWSSTRUCT

WSSERVICE wsAcelerador	DESCRIPTION "Serviço de Retorno de Clientes e Aceleradores"
//Propriedade
	WSDATA dadosRet   		AS Array of Acelerador
	WSDATA busca_cod	  	AS STRING
	WSDATA busca_client		AS STRING
	WSDATA busca_CNPJ		AS STRING
	
//Metodo
	WSMETHOD getAcelerador  DESCRIPTION "<b>Método de retorno de Aceleradores Liberados.</b><br>Retorno!!</br>"
ENDWSSERVICE
//*************************************************************************************************************************//
WSMETHOD getAcelerador WSRECEIVE busca_cod, busca_client, busca_CNPJ WSSEND dadosRet  WSSERVICE wsAcelerador

Local cAliasZZ6 := getNextAlias()
Local cQuery 	:= ""
Local cArea 	:= "ZZ6"

PREPARE ENVIRONMENT EMPRESA '99'  FILIAL '01'

//Construindo Consulta
cQuery +=	"SELECT ZZ6_COD, ZZ6_CLIENT,  "			 			+ CRLF
cQuery +=	"ZZ7_DTINI, ZZ7_GRUPO,   "							+ CRLF
cQuery += 	"ZZ7_RAZAO, ZZ7_FCLI, "								+ CRLF
cQuery +=	"ZZ7_CNPJ, ZZ7_CODAC, ZZ7_NOM "  					+ CRLF				
cQuery += 	"FROM " + RetSqlName( "ZZ6" ) + " ZZ6 "		 		+ CRLF
cQuery +=	"INNER JOIN " + RetSqlName( "ZZ7" ) + " ZZ7  ON"	+ CRLF
cQuery += 	"ZZ7_FILIAL = '"  + xFilial("ZZ7") + "' " 			+ CRLF
cQuery +=   "AND ZZ7_COD = ZZ6_COD"								+ CRLF
cQuery += 	"AND ZZ7.D_E_L_E_T_=' ' " 							+ CRLF
cQuery += 	"WHERE"												+ CRLF
cQuery +=   "ZZ6_FILIAL = '"  + xFilial("ZZ6") + "' "			+ CRLF	
cQuery += 	"AND ZZ6.D_E_L_E_T_=' ' "							+ CRLF 

if !(EMPTY(busca_cod))
	cQuery += " AND ZZ6_COD = '"+busca_cod+"' " 				+ CRLF
endif

if !(EMPTY(busca_client))
	cQuery += " AND ZZ6_CLIENT = '"+busca_client+"' " 			+ CRLF
endif

if !(EMPTY(busca_CNPJ))
	cQuery += " AND ZZ7_CNPJ = '"+busca_CNPJ+"' " 				+ CRLF
endif
	
//cQuery := ChangeQuery(cQuery)

tcQuery cQuery new Alias &cAliasZZ6	

while(cAliasZZ6)->(!EOF())
	oNewCliente := WSClassNew( "Acelerador" )
	oNewCliente:CODIGO := (cAliasZZ6)->ZZ6_COD
	oNewCliente:ZZ6_CLIENT  := (cAliasZZ6)->ZZ6_CLIENT
	oNewCliente:ZZ7_DTINI   := (cAliasZZ6)->ZZ7_DTINI
	oNewCliente:ZZ7_GRUPO   := (cAliasZZ6)->ZZ7_GRUPO
	oNewCliente:ZZ7_CNPJ	:= (cAliasZZ6)->ZZ7_CNPJ
	oNewCliente:ZZ7_RAZAO   := (cAliasZZ6)->ZZ7_RAZAO
	oNewCliente:ZZ7_FCLI   	:= (cAliasZZ6)->ZZ7_FCLI
	oNewCliente:ZZ7_CODAC   := (cAliasZZ6)->ZZ7_CODAC
	oNewCliente:ZZ7_NOME    := (cAliasZZ6)->ZZ7_NOM
	
	aadd(::dadosRet,oNewCliente)
		(cAliasZZ6)->(DbSkip())
endDo

(cAliasZZ6)->(dbCloseArea())

//Reset Environment

Return .T. 

//*************************************************************************************************************************//
