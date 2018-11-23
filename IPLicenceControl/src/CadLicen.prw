//Bibliotecas
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

#DEFINE CAMPOS_CAB  "ZZ6_FILIAL|ZZ6_COD|ZZ6_CLIENT|ZZ6_DATA|ZZ6_HORA|ZZ6_LICEN|"
#DEFINE CAMPOS_ITEM "ZZ7_DATA|ZZ7_CNPJ|ZZ7_FCLI|ZZ7_GRUPO|ZZ7_RAZAO|ZZ7_CODAC|ZZ7_NOM|ZZ7_LIMITA|ZZ7_DTINI|ZZ7_DTFIM|ZZ7_VERSAO|ZZ7_CCOMER|ZZ7_CTIPO|ZZ7_EARSOL|ZZ7_JUST|ZZ7_OBS|"

//-------------------------------------------------------------------	
/*/{Protheus.doc} CadLicen
Tela de Cadastro/Visualização de Licenças Geradas
@author: Michelle Pacheco
@since: 04/09/2018
@Version: 1.0
	@return: 
/*/
//-------------------------------------------------------------------		
User function CadLicen()
	Local oBrowse

	
	xfilial("ZZ6")
	
   	oBrowse := FWmBrowse():New()                            
	oBrowse:SetAlias( 'ZZ6' )           
	oBrowse:SetDescription( 'Controle de Licenças' )             
	
	//Legenda
	//oBrowse:AddLegend()
	
	//Ativa o Browse	
	oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------	
/****************************************************
|Func: MenuDef										|
|Autor: Michelle Pacheco							|
|Data: 04/09/2018									|
|Desc: Criação do Menu MVC							|
****************************************************/
Static Function MenuDef()
	Private aRotina := {}
	
	//Adicionando Opções
	ADD OPTION aRotina Title 'Visualizar'  Action 'VIEWDEF.CadLicen' OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Incluir'     Action 'VIEWDEF.CadLicen' OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Alterar'     Action 'VIEWDEF.CadLicen' OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Excluir'     Action 'VIEWDEF.CadLicen' OPERATION 5 ACCESS 0
	ADD OPTION aRotina Title 'Imprimir'    Action 'VIEWDEF.CadLicen' OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE 'Exportar'    Action 'u_EXPOLIC' 		 OPERATION 6 ACCESS 0
	
Return aRotina	
//-------------------------------------------------------------------		

/****************************************************
|Func: ModelDef										|
|Autor: Michelle Pacheco							|
|Data: 04/09/2018									|
|Desc: Criação do Model MVC							|
****************************************************/	
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oModel   := Nil
	Local oStruZZ6 := FWFormStruct( 1, 'ZZ6', { | cCampo |  AllTrim( cCampo ) + '|'  $CAMPOS_CAB }) 
	Local oStruZZ7 := FWFormStruct( 1, 'ZZ7', { | cCampo |  AllTrim( cCampo ) + '|'  $CAMPOS_ITEM})
	Local aZZ7Rel  := {}
	
	
	// Cria o objeto do Modelo de Dados	com pos validação do modelo
	oModel := MPFormModel():New( 'zCadLiM', /*bPreValidacao*/,  , /*bCommit*/, /*bCancel*/ )
	
	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZZ6MASTER', /*cOwner*/, oStruZZ6 )
	
	// Adiciona ao modelo uma estrutura de formulário de edição por grid com validação de linha
	oModel:AddGrid( 'ZZ7DETAIL', 'ZZ6MASTER', oStruZZ7, /*bLinePre*/,  , /*bPreVal*/, /*bPosVal*/ )
	
	// Fazendo relacionamento PaixFilho
	aadd(aZZ7Rel, {'ZZ7_FILIAL', 'ZZ6_FILIAL'})
	aadd(aZZ7Rel, {'ZZ7_COD', 'ZZ6_COD'})

	
	oModel:SetRelation( 'ZZ7DETAIL',aZZ7Rel , ZZ7->( IndexKey( 1 ) ) )
	
		// Liga o controle de nao repeticao de linha
	//oModel:GetModel( 'ZZ7DETAIL' ):SetUniqueLine( {  } )
	
	//Define chave primaria
	oModel:SetPrimaryKey({})
			
	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Descrição' )
	
	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZZ6MASTER' ):SetDescription( 'Dados do Cliente' )
	oModel:GetModel( 'ZZ7DETAIL' ):SetDescription( 'Dados da Licença' )
	
Return oModel
//-------------------------------------------------------------------
	
/****************************************************
|Func: ViewDef()									|
|Autor: Michelle Pacheco							|
|Data: 04/09/2018									|
|Desc: Criação do ViewDef							|
****************************************************/

Static Function ViewDef()// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado	
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oStruZZ6 := FWFormStruct( 2, 'ZZ6', { | cCampo |  AllTrim( cCampo ) + '|'  $CAMPOS_CAB }) 
	Local oStruZZ7 := FWFormStruct( 2, 'ZZ7', { | cCampo |  AllTrim( cCampo ) + '|'  $CAMPOS_ITEM})
	
	// Cria a estrutura a ser usada na View
	Local oModel   := FWLoadModel( 'CadLicen' )
	Local oView
	
	// Cria o objeto de View
	oView := FWFormView():New()
	
	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )
	
	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZZ6', oStruZZ6, 'ZZ6MASTER' )
	
	//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
	oView:AddGrid(  'VIEW_ZZ7', oStruZZ7, 'ZZ7DETAIL' )
		
	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'CAB', 30 )
	oView:CreateHorizontalBox( 'GRID', 70 )
	
	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZZ6', 'CAB' )
	oView:SetOwnerView( 'VIEW_ZZ7', 'GRID' )
	
	// Define um titulo para o componente
	oView:EnableTitleView('VIEW_ZZ6','DADOS CLIENTE')
	oView:EnableTitleView('VIEW_ZZ7','DADOS LICENÇAS')
	
	// Liga a Edição de Campos na FormGrid
	//oView:SetViewProperty( 'VIEW_ZZ7', "ENABLEDGRIDDETAIL", { 60 } )
	
	
	
Return oView	
//-------------------------------------------------------------------

