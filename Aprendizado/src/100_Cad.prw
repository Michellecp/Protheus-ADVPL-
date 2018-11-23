#include "Protheus.CH"

//Função de Manutenção de Cadastro de Contas
//Utiliza a função pré definida AxCadastro(), que contem todas as funcionalidades: inclusão, alteração, exclusão e pesquisa
//Paramentro a ser passados
//	1)Alias do arquivo a ser editado
//	2)Titulo da Janela
//	3)Nome da função a ser executada para validar uma exclusão
//	4)Nome da funçãoa a ser executada para validar uma inclusão ou alteração

User Function Cad()

Local cVldAlt := ".T." 			//Valida inclusão/alteracao
Local cVldExc := "u_VldExc()"	//valida exclusao

AxCadastro("SZ1", "Cadastro de Contas!", cVldExc, cVldAlt)

Return Nil


//--------------------------------------------------------------------------------------------------------------------//
//Validação da exclusão. Verifica se existe alguma transação desta
//conta no arquivo SZ2. Caso exista não permite excluir
//--------------------------------------------------------------------------------------------------------------------//
User Function VldExc()
	dbSelectArea("SZ2")
	dbOrderNickName("NOME_NR_IT")
	If dbSeek(xFilial("SZ2")+SZ1->Z1_Nome)
		MsgAlert("Esta conta não pode ser excluida")
		Return .F.
	EndIf
	
	Return .T.
	
