#include "Protheus.ch"

User Function Principal()
	Private cArray := Space(20) // retorna o n de espaços. Utilizado para iniciar uma variavel tipo caracter
	Private aVet := {}
	
	//usario ira entrar com o CPF
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Ordena Vetor") FROM 01,01 TO 100,220 PIXEL
	@ 14,05 SAY "Digite os n(s):" SIZE 050, 010 OF oDlg PIXEL
	@ 10,35  MSGET cArray PICTURE "@D" When .T. SIZE 050,010 OF oDlg PIXEL
	DEFINE SBUTTON FROM 30, 33 TYPE 1 ACTION (Ord_vet()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 30, 63 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED
	/* ATÉ AQUI, É A MONTAGEM DA TELA */
	
Return Nil

//--------------------------------------------------------------------------------------------------------//
static function Ord_vet()
	Private i
	Private cMsg := ""
	

	aadd(aVet, val(cArray)) //recebendo e convertendo
	
	cMsg += "Vetor Ordenado" + CRLF
	
	for i:=1 to len(aVet) 
		ASort(aVet,,,, {|x,y|x > y}) // ordenando o Vetor
		cMsg += Str(aVet[i]) + CRLF //concatena
	Next i
	
	Alert(cMsg) //imprime o vetor ordenando
			
Return