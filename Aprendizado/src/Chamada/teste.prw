Private lMsErroAuto  := .F. //Determina se houve algum tipo de erro durante a execucao do ExecAuto
Private lMsHelpAuto  := .T. //Define se mostra ou não os erros na tela (T= Nao mostra; F=Mostra)
Private lAutoErrNoFile := .T. //Habilita a gravacao de erro da rotina automatica 

If lMsErroAuto
 aErro := GetAutoGRLog()
 For nX := 1 To Len(aErro)
  cErro += aErro[nX] + CRLF
 Next nX
 
 //************************************************************************************************************//
 
 http://tdn.totvs.com/pages/releaseview.action?pageId=6815090