#include "Protheus.CH"

//Fun��o de Manuten��o de Cadastro de Contas
//Utiliza a fun��o pr� definida AxCadastro(), que contem todas as funcionalidades: inclus�o, altera��o, exclus�o e pesquisa
//Paramentro a ser passados
//	1)Alias do arquivo a ser editado
//	2)Titulo da Janela
//	3)Nome da fun��o a ser executada para validar uma exclus�o
//	4)Nome da fun��oa a ser executada para validar uma inclus�o ou altera��o

User Function Cad()

Local cVldAlt := ".T." 			//Valida inclus�o/alteracao
Local cVldExc := "u_VldExc()"	//valida exclusao

AxCadastro("SZ1", "Cadastro de Contas!", cVldExc, cVldAlt)

Return Nil


//--------------------------------------------------------------------------------------------------------------------//
//Valida��o da exclus�o. Verifica se existe alguma transa��o desta
//conta no arquivo SZ2. Caso exista n�o permite excluir
//--------------------------------------------------------------------------------------------------------------------//
User Function VldExc()
	dbSelectArea("SZ2")
	dbOrderNickName("NOME_NR_IT")
	If dbSeek(xFilial("SZ2")+SZ1->Z1_Nome)
		MsgAlert("Esta conta n�o pode ser excluida")
		Return .F.
	EndIf
	
	Return .T.
	
