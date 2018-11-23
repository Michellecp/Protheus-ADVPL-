#include "Protheus.ch"

User Function prin_Rand()
	Private nNum := Space(1)
	
	//usario ira entrar com o CPF
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Ordena Vetor") FROM 01,01 TO 100,220 PIXEL
	@ 14,05 SAY "Digite um n�mero:" SIZE 050, 010 OF oDlg PIXEL
	@ 10,35  MSGET nNum PICTURE "@D" When .T. SIZE 050,010 OF oDlg PIXEL
	DEFINE SBUTTON FROM 30, 33 TYPE 1 ACTION ((Random())) ENABLE OF oDlg
	DEFINE SBUTTON FROM 30, 63 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED
	/* ATÉ AQUI, É A MONTAGEM DA TELA */
	
Return Nil
//----------------------------------------------------------------------------------------------------------------------//
Static Function Random()
	Private aVet := {}
	Private cMsg := ""
	Private nAux, i 
		
	for i:= 1 to 15
		aadd(aVet,(Randomize( 1, 50)))  //adiciona numeros aleatórios entre (1 a 50) em um array de 15 posiçoes
	Next 1
	
	nAux := AScan(aVet, nNum)
	
	if (nAux == 0)											//valida se o elemento não foi encontrado
		Alert("Elemento nao encontrado!!!")
	else													//valida o elemento encontrado no vetor, imprime a posição
		cMsg += "Elemento encontrado. Posicao " + nAux
		Alert(cMsg)
	endif
Return 
	
	
