#include "PROTHEUS.CH"

User Function valida_CPF()

	Public cCPF := Space(11) // retorna o n de espaços. Utilizado para iniciar uma variavel tipo caracter
	Public aCPF1 := {}
	Public i:=1, nAux, ndivCPF, ndivCPF1:=0, nConvert, nResul:=0, nSoma:=0, nDiv:=0

	//usario ira entrar com o CPF
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Validação de CPF") FROM 01,01 TO 100,220 PIXEL
	@ 14,05 SAY "Digite o nº" SIZE 050, 010 OF oDlg PIXEL
	@ 10,35  MSGET cCPF PICTURE "@E999.999.999-99" When .T. SIZE 050,010 OF oDlg PIXEL
	DEFINE SBUTTON FROM 30, 33 TYPE 1 ACTION (nOpca:=1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 30, 63 TYPE 2 ACTION (nOpca:=2,oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED
	/* ATÉ AQUI, É A MONTAGEM DA TELA */
	 
	msginfo("CPF: " + cCPF)
	 
	for i=1 to len(cCPF) step +1
		aadd(aCPF1, val(Substr(cCPF,i,1)))
	End
	
	nAux := 10
	
		
	if Len(aCPF1) == 11
		//validando o primeiro digito
		for i := 1 to 9
			nSoma := (aCPF1[i] * nAux) + nSoma
			nAux := nAux - 1
		next i
		nResul := (nSoma%11) - 11
		
		If nResul > 9
			nResul := 0
		Endif
		ndivCPF := nResul * 10
					
		//validando o segundo digito caso o primeiro seja valido
		nAux := 11
		for i = 2 to 11 
			nSoma := (aCPF1[i] * nAux) + nSoma
			nAux := nAux - 1
		next i
			nResul := (nSoma%11) - 11
			
		If nResul > 9
			nResul := 0
		Endif
		
		ndivCPF1 := ndivCPF1 + nResul
		
		If (ndivCPF == aCPF1[10]) .And. (ndivCPF1 == aCPF1[11])
			MsgAlert("CPF Válido")
		else
			MsgAlert("CPF Inválido")
		endif
	
Endif
Return Nil
	
	
		
		
	
		
		
		
		 	
	
	
	
	
	
	

