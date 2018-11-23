#include "Protheus.CH"

User Function TransM2()
Private aRotina := {}
Private cCadastro := "Transações"

	aadd(aRotina, {"Pesquisar" , "AxPesqui",   0, 1})
	aadd(aRotina, {"Visualizar", "u_TM2Manut", 0, 2})
	aadd(aRotina, {"Incluir"   , "u_TM2Manut", 0, 3})
	aadd(aRotina, {"Alterar"   , "u_TM2Manut", 0, 4})
	aadd(aRotina, {"Excluir"   , "u_TM2Manut", 0, 5})
	
	dbselectArea("SZ2")
	dbOrderNickName("NR_IT")
	dbGoTop()
	
	mBrowse(,,,,"SZ2")
	
Return Nil
	
//---------------------------------------------------------------------------------//
User Function TM2Manut(cAlias, nReg, nOpc)

Local oDlg
Local oFont
Local nLin
Local nTop
Local nLeft
Local nBottom
Local nRight
Local cLinhaOK
Local cTudoOK
Local cIniCpos
Local lDelete
Local nMax
Local cFieldOk
Local cSuperDel
Local cDelOK
Local nCol
Local nCampo

Local oEnchoice
Local oGetDados
Local aAlt := {}

Private aHeader := {}      //cabeçalho das colunas da GetDados
Private aCols := {}		   // Colunas da GetDados
Private aSayTotalD
Private aSayTotalS

////////////////////////////////////////////////////////////////////////////////////////////////////////
//Cria  variaveis de memória
//Para cada campo da tabela, cria uma variavel de memmoria com o mesmo nome.
//Estas variaveis são usadas em validacoes e gatilhos que existirem para este arquivo.
////////////////////////////////////////////////////////////////////////////////////////////////////////

//*Campos da AZ2

	dbSelectArea(cAlias)
	For nCampo :=  1 to FCount()
		//nCampo --> 1	 		2			3			:::	9
		//cCampo -->"Z2_Filial" "Z2_Nome"	"Z2_Numero"	:::	"Z2_Aprov"
		
		cCampo := FildName(cCampo)
		M->&(cCampo) := CriaVar(cCampo, .T.)
		
	Next
	
////////////////////////////////////////////////////////////////////////////////////////////////////////
//Cria vetor
///////////////////////////////////////////////////////////////////////////////////////////////////////

dbSelectArea("SX3")
dbSetOrder(1)	
dbSeek(cAlias)

	while SX3->X3_Arquivo == cAlias .And. !SX3->(EOF())
	
		if SX3Uso (SX3->X3_Usado) .And. ;   //Campo é usado
			cNivel >= SX3->X3_Nivel .And.; //Nivel do Usuario >= Nivel do Campo
			
			Trim (SX3 -> X3_Campo) $ "Z2_Item/Z2_Tipo/Z2_Hist/Z2_Valor"
				//os campos ficarão na GetDados
			
			Aadd (aHeader, {Trim(SX3->X3_Titulo),;
							SX3->X3_Campo		,;
							SX3->X3_Picture		,;
							SX3->X3_Tamanho		,;
							SX3->X3_Decimal		,;
							SX3->X3_Valid		,;
							SX3->X3_Usado		,;
							SX3->X3_Tipo		,;
							SX3->X3_Arquivo		,;
							SX3->X3_Context	})
							
			Endif
			
			SX3 -> (dbskip())
			
	End
	
	If nOpc == 3
		aadd (aCols, Array(Len(aHeader)+1)) //aCols[1] -->{Nil, Nil, Nil, Nil, Nil}
		
		For nCol := 1 to Len(aHeader)
			aCols[1][nCol] := CriaVar (aHeader[nCol][2])
		Next
		
		aCols[1][Len(aHeader)+1] := .F.
		aCols[1][AScan(aHeader, {|aX|Trim(aX[2] == "Z2_Item"})] := "01"
	Else
		M->Z2_Numero := SZ2->Z2_Numero
		M->Z2_Nome	 := SZ2->Z2_Nome
		M->Z2_Data	 := SZ2->Z2_Data
		dbSelectArea(cAlias)
		dbOrderNickName(Nome_NR_IT)  //Z2_Filial+Z2_Nome+Z2_Numero+Z2_Item
		dbSeek(xFilial(cAlias)+ M->Z2_Nome + M->Z2_Numero)
		
		while !EOF() .And. SZ2->(Z2_Filial+Z2_Numero) == xFilial(cAlias) + M->Z2_Numero
			AAdd(aCols, Array(Len(aHeader)+1)) //aCols[1] -> {Nil, Nil, Nil, Nil, Nil}
			nLin := Len(aCols)
			
	For nCol := 1 To Len(aHeader)
		
	
