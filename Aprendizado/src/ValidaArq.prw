#include "Protheus.ch"
#define ATIVO "S"
#define RotAut_Inclusao 3

User function ValidaArq()
	Private nArquivo := 0
	Private lMsErroAut  := .F.
	Private nI			:= 0
	Private aErrorlog   := {}
	Private cCodProd 	 := ""
	Private cNome 	  	 := ""
	Private dtCadatro 	 := ""
	Private nInativo  	 := 0
	Private nPesoB		 := 0
	Private nCompri		 := 0
	Private nEspe		 := 0
	Private nLargura 	 := 0
	Private cCor 		 := ""
	Private cPreco	     := 0
	Private cTipo		 := 0
	Private aProduto 	 := {}
	Private aComp        := {}
	Private cLine
	Private	cRotAut 	 := "N"
	
	
	// Abre o arquivo
	nArquivo := FT_FUse("C:\Users\mi_cr\Downloads\Exercícios de Lógica Aplicada a AdvPL\CadProdutos.txt")
							
	nLast := FT_FLastRec()
	
	if nArquivo == - 1 								// Se houver erro de abertura abandona processamento
		MsgAlert("Erro ao carregar o Arquivo.")
	else
		Carrega()
		RotinaAuto()
	endif
	

Return Nil

//***********************************************************************************************************************************//
Static function Carrega()
	
	FT_FGoTop()
	
	while !FT_FEOF()

		cLine := FT_FReadLn()
	
		cNome 	    :=	Alltrim(Substr(cLine, 6, 50))
	
		//if cNome <> "." .And. cNome <> "" 											//valida se o campo nome esta vazio ou com "."
			cCodProd    :=  Alltrim(Substr(cLine, 1, 5))
			cDtCadastro :=	ctod(Substr(cLine, 56,2) + "/" + Substr(cLine, 58,2)+ "/" + Substr(cLine, 60,4))
			nInativo 	:=  Val(Substr(cLine, 64, 1))
			nPesoB 		:=  Val(Substr(cLine, 65, 9))
			nCompri	    :=	Val(Substr(cLine, 74, 9))
			nEspe		:=	Val(Substr(cLine, 83, 9))
			nLargura	:= 	Val(Substr(cLine, 92, 9))
			cCor		:=  Alltrim(Substr(cLine, 101, 15))
			cPreco		:=	Val(Alltrim(Substr(cLine, 116, 12)))
			ctipo		:=  Alltrim(Substr(cLine, 128, 24))
			
			If (cCor == "")
					cCor := "N/A"
			endif
			
					
			if nInativo <> 1 .And. cDtCadastro > ctod("30/06/2002") 				//valida se o cadastro esta ativo e é maior
			
				aadd(aProduto, {"B1_COD" , padl(cCodProd, 4, "0") , nil})
				aadd(aProduto, {"B1_DESC", cNome , nil})
				aadd(aProduto, {"B1_TIPO", "MP" , nil})
				aadd(aProduto, {"B1_UM", "UN" , nil})
				aadd(aProduto, {"B1_LOCPAD", "01" , nil})
				aadd(aProduto, {"B1_ZZDATA", ddatabase, nil})
				aadd(aProduto, {"B1_ATIVO", ATIVO, nil})
				aadd(aProduto, {"B1_PESO", nPesoB, nil})
				aadd(aProduto, {"B1_PRV1", cPreco, nil})
				aadd(aProduto, {"B1_ZZAUT", cRotAut, nil})
				
				aadd(aComp,    {"B5_CEME", cNome, nil})
				aadd(aComp,    {"B5_COD" , padl(cCodProd, 4, "0") , nil})
				aadd(aComp,    {"B5_COMPR", nCompri, nil})
				aadd(aComp,    {"B5_ESPESS", nEspe, nil})
				aadd(aComp,    {"B5_LARG", nLargura, nil})
				aadd(aComp,    {"B5_COR", cCor, nil})
				aadd(aComp,    {"B5_CTRWMS", "1", nil})
								
								
				aadd(aProdutos, {aProduto, aComp})
				
				aProduto := {}
				aComp	 := {}
				
			endif
			
		//endif
	
		FT_FSKIP()
	end

	FT_FUse() //fecha arquivo

Return Nil
//*****************************************************************************************************************************************//

static function RotinaAuto()

	local 	aProduto 		:= {}
	local 	aComplemento  	:= {}
	local 	aErroLog		:= {}
	local 	cErro			:= ""
	local 	nX 				:= 0
	local 	nCont			:= 0
	Private lMsErroAuto  	:= .F. //Determina se houve algum tipo de erro durante a execucao do ExecAuto
	Private lMsHelpAuto  	:= .T. //Define se mostra ou não os erros na tela (T= Nao mostra; F=Mostra)
	Private lAutoErrNoFile 	:= .T. //Habilita a gravacao de erro da rotina automatica 
	
			
	BEGIN TRANSACTION
		for nI:=1 to len(aProdutos)
		
 			cRotAut	 		:= "S"	
			lMsErroAut 		:= .F.
			aProduto 		:= aProdutos[nI][1]
			aComplemento	:= aProdutos[nI][2]
 			
			MSExecAuto({|x,y| Mata010(x,y)}, aProduto, RotAut_Inclusao)	//Inclusão via Rotina Automática 3 - Inclusão
			if lMsErroAuto
				aErroLog := GetAutoGRLog()
				 For nX := 1 To Len(aErroLog)
 					 cErro += aErroLog[nX] + Chr(13)+ Chr(10)
 				 Next 
 				lMsErroAuto := .F.
 				
				Alert(cErro)
				DisarmTransaction()
			else
				MSExecAuto({|x,y| Mata180(x,y)}, aComplemento, RotAut_Inclusao)
				if lMsErroAuto
					aErroLog := GetAutoGRLog()
				 	For nX := 1 To Len(aErroLog)
 					 cErro += aErroLog[nX] + Chr(13)+ Chr(10)
 					Next nX
 					cRotAut	 	:= "N" 
					Alert(cErro)
					DisarmTransaction()
					
				endif
					
					nCont  		+= 1 	//contador para armazenar a quantidade de dados importados
										
			endif
			
												
		next 1
		
		Alert("Dados Importados. Total de Registros "+ Str(nCont))
		
	END TRANSACTION
	
Return nil

//*******************************************************************************************************************************//

	