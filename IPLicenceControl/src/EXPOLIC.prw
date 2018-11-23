//Bibliotecas
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'IPLICENSE.CH'
#INCLUDE 'TOPCONN.CH'
//-------------------------------------------------------------------	
/*/{Protheus.doc} EXPOLIC
Rotina Exporta a lista e gera o arquivo de Licença
@author: Michelle Pacheco
@since: 08/10/2018
@Version: 1.0
@return: 
/*/
//-------------------------------------------------------------------	
user function EXPOLIC()
Local lFalha 	  := .f.
Local nArquivo
Local cArqLicenca := ""

   cArqLicenca := ZZ6->ZZ6_LICEN

	nArquivo := fcreate("C:\Protheus 12117\Licenças\Geradas\iplicense.lic")
	
	if ferror()
		msgalert("ERRO AO CRIAR O ARQUIVO DE LICENÇA. ERRO:" + str(ferror()))
		lFalha := .t.
	else
		fseek(nArquivo, 0)       
		fwrite(nArquivo, cArqLicenca)
		fclose(nArquivo)                   
    	MsgAlert('Arquivo de Licença gerado!')
	endif

 
Return

//-----------------------------------------------------------------------------------------------------//