#include "PROTHEUS.CH"

User Function TranM1()

Private cNomAnt, cTipAnt, nValAnt
Private cAlias := "SZ2"
Private aRotina := {}
Private lRefresh := .T.
Private cCadastro := "Transação de Depósito ou Saque"

	AAdd( aRotina, {"Pesquisar", "AxPesqui", 0, 1})
	AAdd( aRotina, {"Visualizar","AxVisual", 0, 2})
	AAdd( aRotina, {"Incluir","u_Inclui", 0, 3})
	AAdd( aRotina, {"Alterar", "u_Altera",0, 4})
	AAdd( aRotina, {"Excluir", "u_Deleta", 0, 5})

	dbSelectArea(cAlias)
	
	dbOrderNickName("NR_IT")
	
	mBrowse(,,,,cAlias)
	
	Return Nil	
	
//------------------------------------------------------------------------------------//
User Function Inclui(cAlias, nRegistro, nOpcao)

Local nConfirmou

nConfirmou := AxInclui(cAlias, nRegistro, nOpcao)

	if nConfirmou == 1 //confirmou a inclusão
		Begin Transaction
		
		//Atualiza o saldo
		dbSelectArea("SZ1")
		dbOrderNickName("Name")
		dbSeek(xFilial("SZ1") + SZ2->Z2_Nome)
		RecLock("SZ1", .F.)
		if SZ2_>Z2_Tipo == "D"
			SZ1->Z1_Saldo := SZ1->Z1_Saldo + SZ2->Z2_Valor
		else
			SZ1->Z1_Saldo := SZ1->Z1_Saldo - SZ2->Z2_Valor
		EndIf
		MSUnlock()
		
		if SZ1->Z1_Saldo < 0
			
			if ExistBlock ("WFSalNeg") //Ponto de Entrada
				//o saldo negativo. Envia um Workflow para o aprovador
				//A resposta do aprovador (SIM ou NAO) sera gravado no campo Z2_aprov
				u_WFSalNeg(SZ1->Z1_Nome, SZ1->Z1_Email, SZ1->Z1_Email1,;
						   SZ2->Z2_Numero, SZ2->Z2_Item, SZ2->Z2_Data,;
						   SZ2->Z2_Hist, SZ2->Z2_Valor, SZ1->Z1_Saldo)
			EndIf
		EndIf
		
		//Confirma o numero obtido por GetSXENum() no inicio. -padrao do campo Z2_numero
		
		ConfirmSX8()
	End Transaction
	EndIf
	
Return Nil

//--------------------------------------------------------------------------------------------------------------//
User Function Altera(cAlias, nRegistro, nOpcao)

Local nConfirmou

cNomAnt := SZ2 ->Z2_Nome
CTipAnt := SZ2->Z2_Tipo
nValAnt := SZ2->Z2_Valor

if nConfirmou == 1 //Confirmou a alteração
	
	Begin Transaction
	
		if(SZ2->Z2_Nome <> cNomAnt .Or.;
		   SZ2->Z2_Tipo <> CTipAnt .Or.;
		   SZ2->Z2_Valor <> nValAnt)

		//Desatualiza o movimento anterior
		dbSelectArea("SZ1")
		dbOrderNickName("NOME")
		dbSeek(xFilial("SZ1") + cNomAnt)
		RecLock("SZ1", .F.)
			if cTipAnt == "D"
				SZ1->Z1_Saldo := SZ1->Z1_Saldo - nValAnt
			Else
				SZ1->Z1_Saldo := SZ1->Z1_Saldo + nValAnt
			EndIf
			MSUnLock()
			
			//Atualiza o novo movimento
			dbSelectArea("SZ1")
			dbOrderNickName("Name")
			dbSeek(XFilial ("SZ1") + cNomAnt)
			RecLock("SZ1", .F.)
			if SZ2->Z2_Tipo == "1"
				SZ1->Z1_Saldo := SZ1->Z1_Saldo + nValAnt
			Else
				SZ1->Z1_Saldo := SZ1->Z1_Saldo - nValAnt
			EndIf
			MSUnlock()
		EndIf
		
End Transaction
	
Endif
	
Return Nil
	
//------------------------------------------------------------------------------------------------//
User Function Deleta(cAlias, nRegistro, nOpcao)

Local nConfirmou

//chama a rotina de visualização para montar o movimento a ser excluido

if nConfirmou == 1 //Confirmou a exclusão

	Begin Transaction
		
		//Desatualiza o Saldo
		
		dbSelectArea("SZ1")
		dbOrderNickName("NOME")
		dbSeek(xFilial() + SZ2->Z2_Nome)
		RecLock("SZ1", .F.)
		If SZ2->Z2 == "1"
			SZ1->Z1_Saldo := SZ1->Z1_Saldo - nValAnt
		Else
			SZ1->Z1_Saldo := SZ1->Z1_Saldo + nValAnt
		EndIf
		MSUnLock()
		
		//Exclui o movimento
		dbSelectArea(cAlias)
		RecLock(cAlias, .F.)
		dbDelete()
		MSUnLock()
		
	End	Transaction

EndIf

Return Nil	

//---------------------------------------------------------------------------------------------------//

		
			
	