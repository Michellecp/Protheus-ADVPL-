#include "Protheus.ch"

User Function prin_Binaria()
	Private nNum := Space(1)
	Private aVet := {}
	
	//usario ira entrar com o CPF
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Ordena Vetor") FROM 01,01 TO 100,220 PIXEL
	@ 14,05 SAY "Digite:" SIZE 050, 010 OF oDlg PIXEL
	@ 10,35  MSGET nNum PICTURE "@D" When .T. SIZE 050,010 OF oDlg PIXEL
	DEFINE SBUTTON FROM 30, 33 TYPE 1 ACTION ((Busca_Binaria())) ENABLE OF oDlg
	DEFINE SBUTTON FROM 30, 63 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED
	/* ATÉ AQUI, É A MONTAGEM DA TELA */
	
Return Nil
//----------------------------------------------------------------------------------------------------------------------//
Static Function Busca_Binaria()
	Private cMsg := ""
	Private i := 0, esq :=1, meio := 0, dir 
	
	for i:= 1 to 15
		aadd(aVet,(Randomize( 1, 10)))  					//adiciona numeros aleatórios entre (1 a 10) em um array 
	Next 1
	
	dir := len(aVet)
	
	ASort(aVet,,,, {|x,y|x > y}) 							// ordenando o Vetor
	
	meio := round((len(aVet))/2,0) 							// pega o meio do Vetor
			
	for i:= 1 to 15
	
		if(aVet[meio] == val(nNum))						// Verifica se o elemento esta localizado no meio do Vetor 
			Alert("Numero Encontrado")
			break
						
		elseif(val(nNum)< aVet[meio]  )
			dir = meio - 1
			meio := round((dir + esq)/ 2,0)
			
			if(aVet[meio] == val(nNum))
				Alert("Numero Encontrado")
				break
			endif
						
		elseif (val(nNum) > aVet[meio])
			esq = meio + 1
			meio := round((dir + esq)/ 2,0)
			
			if(aVet[meio] == val(nNum))
				Alert("Numero Encontrado")
			break
			endif
			
		 else
			Alert("Numero n�o Encontrado")
		endif
		
	Next 1
		
Return 