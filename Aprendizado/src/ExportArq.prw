#include "Protheus.ch"
#Include "TopConn.ch"

User Function ExportArq()
	Private nCont        	:= 0
	Private aRegistro   	:= {}
	Private nPosicao    	:= 0 
	
 dbSelectArea("SC5")
	
	if SC5->(EOF())
		MsgAlert("Tabela vazia!!")
	else
		Carrega()
		CriaArq() 
	endIf 

 dbCloseArea("SC5")
 
 Return Nil 
 
//***********************************************************************************************//  
Static Function Carrega()
	
	FT_FGoTop()
	
	while !FT_FEOF()
	
	
		
	
		
		
		
		



//***********************************************************************************************//
Static Function CriaArq(cTab)

	Local lCria  	:= .F.
	Local cDire		:= cDir
	Local cAr		:= ""
	Local aEstru	:= {}
	Local cCampo	:= ""
	Local nQtdReg	:= 0
	Local nContad	:= 1
	Local cFieldO	:= ""
	Local cFieldD	:= ""
	
	cArq := CriaTrab(, .F.) //valida se o arquivo ja existe e se não cria

		
	DbSelectArea(cTab)
	Count to nQtdReg
	ProcRegua(nQtdReg)
	DbGoTop()
	Copy To &(cArquivo) while (IncProc("Criando a Tabela [" + cTab + "] - Registro " + StrZero(nContad++,7) +  " de " + StrZero(nQtdReg,7)),.T.)
	
		
	__copyfile(cArquivo + GetDbExtension(),cDire + RetSqlName(cTab) + GetDbExtension())
	Ferase(cArquivo + GetDbExtension())
	
	//MsgAlert("Criado o Arquivo " + cDire + RetSqlName(cTab) + GetDbExtension())
	
Return

	
	