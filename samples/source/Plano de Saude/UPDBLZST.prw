#INCLUDE "PROTHEUS.CH"

STATIC __lOracle 	:= nil

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )
#DEFINE X3_NAOUSADO '€€€€€€€€€€€€€€€'
#DEFINE X3_USADO '€€€€€€€€€€€€€€ '
#DEFINE X3_OBRIGAT 'ƒ€'
#DEFINE X3_NAOOBRIGAT 'şÀ'


//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} UPDBLZST

Realiza a chamada da função (UPDBLZ) que faz a atualização do campo BLZ_STATUS referente a
divisão do conteúdo do campo publicado pela Unimed do Brasil Versão 7.0 - MS.104 - REV.20
Serviços para integração SISPAC – Sistema de Pacotes – Vigência: 02/02/2024

@author Renan Marinho
@since 31/01/2024
@version P12
/*/
//-------------------------------------------------------------------------------------------------


User Function UPDBLZST()

//Inicializa variaveis
Local nOpca       := 0
Local aSays       := {}, aButtons := {}
Local lret		    := .F.
Private nModulo 	:= 33 // modulo SIGAPLS
Private cMessage
Private aArqUpd	  := {}
Private aREOPEN	  := {}
Private oMainWnd
Private cCadastro := "Compatibilizador do status x Banco de dados"
Private cCompat   := "UPBLZSTAT"
Private cChamado  := "DSAUPC-18070"
Private cRef      := "Atualização do Status do Pacote conforme publicado pela Unimed do Brasil PTU Integrações Versão 7.0 - MS.104 - REV.20  "
Set Dele On

getTpDB(@__lOracle) //verifica qual banco de dados

//Monta texto para janela de processamento 
aadd(aSays,"Esta rotina irá efetuar a compatibilização dos status dos pacotes no banco de dados,")
aadd(aSays, "assim contemplando a nova versão (Integrações v7.0) à partir do dia 02/02/2024:")
aadd(aSays,"   Chamado: " + cChamado)
aadd(aSays,cRef)
aadd(aSays," ")
aadd(aSays, "Atenção: efetuar backup da tabela (BLZ - Pacotes Itens) previamente")

//Monta botoes para janela de processamento
aadd(aButtons, { 1,.T.,{|| nOpca := 1, FechaBatch() }} )
aadd(aButtons, { 2,.T.,{|| nOpca := 0, FechaBatch() }} )

//Exibe janela de processamento
FormBatch( cCadastro, aSays, aButtons,, 230 )

//Processa 
If  nOpca == 1
	If  Aviso("Compatibilizador", "Deseja confirmar o processamento do compatibilizador ?", {"Sim","Não"}) == 1  //"Compatibilizador"###"Deseja confirmar o processamento do compatibilizador ?"###"Sim"###"Não"
		lret := Processa({||UPDBLZ()},"Processando","Aguarde , processando preparação da atualização",.F.)  //"Processando"###"Aguarde , processando preparação"
	Endif
	If lret
		Aviso( cTitulo, "Atualização concluída", {"Ok"} )
	endif
Endif

//Fim do programa
Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ProcATU   ³ Autor ³                       ³ Data ³  /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Baseado na funcao criada por Eduardo Riera em 01/02/2002   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcATU(lEnd,aRecnoSM0,lOpen)
Local cTexto    	:= ""
Local cFile     	:= ""
Local cMask     	:= "Arquivos Texto (*.TXT) |*.txt|" //"Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    	:= 0
Local nI        	:= 0
Local nX        	:= 0
Local cCodigo		:= ""


ProcRegua(1)
IncProc("Verificando integridade dos dicionários....")  //"Verificando integridade dos dicionários...."

If lOpen

	lSel:=.F.
	For nI := 1 To Len(aRecnoSM0)
		DbSelectArea("SM0")
		DbGotop()
		SM0->(dbGoto(aRecnoSM0[nI,9]))

		If !aRecnoSM0[nI,1] .OR. SM0->M0_CODIGO == cCodigo   // Se for o mesmo Grupo Empresa nao e necessario rodar novamente
			loop
		Endif
		lSel:=.T.

		RpcSetType(2)
		RpcSetEnv(  SM0->M0_CODIGO, FWGETCODFILIAL)
		cCodigo := SM0->M0_CODIGO
		nModulo := 51 // modulo SIGAHSP
		lMsFinalAuto := .F.
		cTexto += Replicate("-",128)+CHR(13)+CHR(10)
		cTexto += "Empresa: " + aRecnoSM0[nI][2]+CHR(13)+CHR(10)  //"Empresa: "

		DBSELECTAREA("BEA")
		ProcRegua(8)

		Begin Transaction

		
			IncProc("Atualizando dicionário de campos...")   //"Atualizando dicionário de campos..."
			// Atualiza SX3
			cTexto += FSAtuSX3()//PlsAtuSX3()
	    
	    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionário SX7         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc('Dicionário de Gatilhos - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...')
			ProcessMessage()
			cTexto += PLSAtuSX7()
			
		End Transaction

		__SetX31Mode(.F.)
		For nX := 1 To Len(aArqUpd)
			IncProc("Atualização concluída." +"["+aArqUpd[nx]+"]")  //"Atualização concluída."
			If Select(aArqUpd[nx])>0
				dbSelecTArea(aArqUpd[nx])
				dbCloseArea()
			EndIf
			X31UpdTable(aArqUpd[nx])
			If __GetX31Error()
				Alert(__GetX31Trace())
				Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : " + aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela." ,{"Continuar"},2)   //"Atencao!"###"Ocorreu um erro desconhecido durante a atualizacao da tabela : "###". Verifique a integridade do dicionario e da tabela."###"Continuar"
				cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : " +aArqUpd[nx] +CHR(13)+CHR(10) //"Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "
			EndIf
			dbSelectArea(aArqUpd[nx])
		Next nX

		RpcClearEnv()
		If !( lOpen := MyOpenSm0Ex() )
			Exit
		EndIf
	Next nI

	If lOpen

		cTexto 	:= "Log da atualizacao " + CHR(13) + CHR(10) + cTexto  //"Log da atualizacao "

		If !lSel
			cTexto+= "Não foram selecionadas nenhuma empresa para Atualização"  //"Não foram selecionadas nenhuma empresa para Atualização"
		Endif
		__cFileLog := MemoWrite(Criatrab(,.f.) + ".LOG", cTexto)

		DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
		DEFINE MSDIALOG oDlg TITLE "Chamado"+" ["+cChamado+"]"  From 3,0 to 340,417 PIXEL  //"   FNC: "###"   Referência: "
		@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
		oMemo:bRClicked := {||AllwaysTrue()}
		oMemo:oFont:=oFont
		DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
		DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
		ACTIVATE MSDIALOG oDlg CENTER

	EndIf

EndIf


Return(Nil)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³Sergio Silveira       ³ Data ³07/01/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao FIS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MyOpenSM0Ex()

Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. )
	If !Empty( Select( "SM0" ) )
		lOpen := .T.
		dbSetIndex("SIGAMAT.IND")
		Exit
	EndIf
	Sleep( 500 )
Next nLoop

If !lOpen
	Aviso( "Compatibilizador de Dicionários x Banco de dados", "Atenção: Não foi possível abrir o arquivo de empresas!", { "Ok" }, 2 ) //"Compatibilizador de Dicionários x Banco de dados"###"Atenção: Não foi possível abrir o arquivo de empresas!"
EndIf

Return( lOpen )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ UpdEmp   ³ Autor ³ Luciano Aparecido     ³ Data ³ 15.05.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Trata Empresa. Verifica as Empresas para Atualizar         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao PLS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function  UpdEmp(aRecnoSM0,lOpen)

Local cVar     := Nil
Local oDlg     := Nil
Local cTitulo  := "Escolha a(s) Empresa(s) que será(ão) Atualizada(s)"  //"Escolha a(s) Empresa(s) que será(ão) Atualizada(s)"
Local lMark    := .F.
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" )
Local oChk     := Nil
Local bCode := {||oDlg:End(),Processa({|lEnd| ProcATU(@lEnd,aRecnoSM0,lOpen)},"Atualizando estruturas. Aguarde... [","Atenção!",.F.)}  //"Atualizando estruturas. Aguarde... ["###"Atenção!"
Local nI :=0
Local aRecSM0 :={}
LOCAL cSeq := ""

Private lChk     := .F.
Private oLbx := Nil


If ( lOpen := MyOpenSm0Ex() )
	dbSelectArea("SM0")

	/////////////////////////////////////////
	//| Carrega o vetor conforme a condicao |/
	//////////////////////////////////////////
	dbGotop()

	aRecSM0:=FWLoadSM0()


	For nI := 1 to  len(aRecSM0)
		Aadd(aRecnoSM0,{lMark,aRecSM0[nI][1],aRecSM0[nI][6],aRecSM0[nI][2],aRecSM0[nI][3],aRecSM0[nI][4],aRecSM0[nI][5],aRecSM0[nI][7],aRecSM0[nI][12]})
	Next nI

	///////////////////////////////////////////////////
	//| Monta a tela para usuario visualizar consulta |
	///////////////////////////////////////////////////
	If Len( aRecnoSM0 ) == 0
		Aviso( cTitulo, "Não existe bancos a consultar", {"Ok"} ) //"Não existe bancos a consultar"
		Return
	Endif

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,700 PIXEL

	@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER ;
	" ","Grupo Emp","Descrição","Código","Empresa","Unidade","Filial","Descrição","Recno" ;  //"Grupo Emp"###"Descrição"###"Código"###"Empresa"###"Unidade"###"Filial"###"Descrição"###"Recno"
	SIZE 430,095 OF oDlg PIXEL ON dblClick(aRecnoSM0[oLbx:nAt,1] := !aRecnoSM0[oLbx:nAt,1],oLbx:Refresh())

	oLbx:SetArray( aRecnoSM0)
	oLbx:bLine := {|| {Iif(aRecnoSM0[oLbx:nAt,1],oOk,oNo),;
	aRecnoSM0[oLbx:nAt,2],;
	aRecnoSM0[oLbx:nAt,3],;
	aRecnoSM0[oLbx:nAt,4],;
	aRecnoSM0[oLbx:nAt,5],;
	aRecnoSM0[oLbx:nAt,6],;
	aRecnoSM0[oLbx:nAt,7],;
	aRecnoSM0[oLbx:nAt,8],;
	Alltrim(Str(aRecnoSM0[oLbx:nAt,9]))}}

	////////////////////////////////////////////////////////////////////
	//| Para marcar e desmarcar todos existem duas opçoes, acompanhe...
	////////////////////////////////////////////////////////////////////


	@ 110,10 CHECKBOX oChk VAR lChk PROMPT  "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg ;  //"Marca/Desmarca"
	ON CLICK(aEval(aRecnoSM0,{|x| x[1]:=lChk}),oLbx:Refresh())

	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION Eval(bCode) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
Endif

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} UPDBLZ

Atualização do campo BLZ_STATUS referente a divisão do conteúdo do campo publicado pela Unimed do Brasil PTU Integrações Versão 7.0 - MS.104 - REV.20
Serviços para integração SISPAC – Sistema de Pacotes – Vigência: 02/02/2024

@author Renan Marinho
@since 31/01/2024
@version P12
/*/
//-------------------------------------------------------------------
Static Function UPDBLZ()

Local cQueryBLZ 	:= ""
Local cQueryUpdate  := ""
//local cAliasBLZ 	:= getNextAlias()
local nRet       	:= .F.

	//rpcSetType(3)
    //rpcSetEnv("T1", "M SP 01",,,'PLS')
	// rpcSetEnv(cEmpAnt, cFilAnt,,,'PLS')

	getTpDB(@__lOracle) //verifica qual banco de dados

	cQueryBLZ := "SELECT BLZ_STATUS FROM " + RetSqlName("BLZ") + " WHERE BLZ_FILIAL = '" + xfilial("BLZ") + "' AND BLZ_STATUS <> '' AND D_E_L_E_T_ = ' '"

	dbUseArea(.t.,"TOPCONN",tcGenQry(,,cQueryBLZ),"cAliasBLZ",.f.,.t.)

	if !cAliasBLZ->(Eof()) 

		begin transaction

			//------------------------------ ATUALIZANDO  BLZ_ETPPAC ------------------------------//

			//Em construção 
			cQueryUpdate := " UPDATE " + RetsqlName("BLZ") 
			cQueryUpdate += " SET BLZ_ETPPAC = '1' "
			cQueryUpdate += " WHERE BLZ_FILIAL = '" + xfilial("BLZ") + "' "
			cQueryUpdate += " AND BLZ_STATUS = '" + '1' + "' "
			cQueryUpdate += " AND D_E_L_E_T_ = ' ' "
		
			if tcSqlExec( cQueryUpdate ) < 0
				Aviso( "Atencao!", "Erro na execução do update UPDBLZST.prw [ " + tcSqlERROR() + "]", {"Ok"} )
				userException("Erro na atualização do update em etapa: Em construção -> [ " + tcSqlERROR() + "]")
			elseIf __lOracle
				TCSQLExec("COMMIT")
			endIf

			//Em análise Administrativo
			cQueryUpdate := " UPDATE " + RetsqlName("BLZ") 
			cQueryUpdate += " SET BLZ_ETPPAC = '2' "
			cQueryUpdate += " WHERE BLZ_FILIAL = '" + xfilial("BLZ") + "' "
			cQueryUpdate += " AND BLZ_STATUS = '" + '2' + "' "
			cQueryUpdate += " AND D_E_L_E_T_ = ' ' "
		
			if tcSqlExec( cQueryUpdate ) < 0
				Aviso( "Atencao!", "Erro na execução do update UPDBLZST.prw [ " + tcSqlERROR() + "]", {"Ok"} )
				userException("Erro na atualização do update em etapa: Em análise Administrativo -> [ " + tcSqlERROR() + "]")
			elseIf __lOracle
				TCSQLExec("COMMIT")
			endIf
			 
			//Em análise Médico
			cQueryUpdate := " UPDATE " + RetsqlName("BLZ") 
			cQueryUpdate += " SET BLZ_ETPPAC = '3' "
			cQueryUpdate += " WHERE BLZ_FILIAL = '" + xfilial("BLZ") + "' "
			cQueryUpdate += " AND BLZ_STATUS = '" + '3' + "' "
			cQueryUpdate += " AND D_E_L_E_T_ = ' ' "
		
			if tcSqlExec( cQueryUpdate ) < 0
				Aviso( "Atencao!", "Erro na execução do update UPDBLZST.prw [ " + tcSqlERROR() + "]", {"Ok"} )
				userException("Erro na atualização do update em etapa: Em análise Médico -> [ " + tcSqlERROR() + "]")
			elseIf __lOracle
				TCSQLExec("COMMIT")
			endIf

			//Em análise Enfermeiro
			cQueryUpdate := " UPDATE " + RetsqlName("BLZ") 
			cQueryUpdate += " SET BLZ_ETPPAC = '4' "
			cQueryUpdate += " WHERE BLZ_FILIAL = '" + xfilial("BLZ") + "' "
			cQueryUpdate += " AND BLZ_STATUS = '" + '4' + "' "
			cQueryUpdate += " AND D_E_L_E_T_ = ' ' "
		
			if tcSqlExec( cQueryUpdate ) < 0
				Aviso( "Atencao!", "Erro na execução do update UPDBLZST.prw [ " + tcSqlERROR() + "]", {"Ok"} )
				userException("Erro na atualização do update em etapa: Em análise Enfermeiro -> [ " + tcSqlERROR() + "]")
			elseIf __lOracle
				TCSQLExec("COMMIT")
			endIf

			//Em análise Supervisor
			cQueryUpdate := " UPDATE " + RetsqlName("BLZ") 
			cQueryUpdate += " SET BLZ_ETPPAC = '5' "
			cQueryUpdate += " WHERE BLZ_FILIAL = '" + xfilial("BLZ") + "' "
			cQueryUpdate += " AND BLZ_STATUS = '" + '5' + "' "
			cQueryUpdate += " AND D_E_L_E_T_ = ' ' "
		
			if tcSqlExec( cQueryUpdate ) < 0
				Aviso( "Atencao!", "Erro na execução do update UPDBLZST.prw [ " + tcSqlERROR() + "]", {"Ok"} )
				userException("Erro na atualização do update em etapa: Em análise Supervisor -> [ " + tcSqlERROR() + "]")
			elseIf __lOracle
				TCSQLExec("COMMIT")
			endIf

			//Exigência
			cQueryUpdate := " UPDATE " + RetsqlName("BLZ") 
			cQueryUpdate += " SET BLZ_ETPPAC = '7' "
			cQueryUpdate += " WHERE BLZ_FILIAL = '" + xfilial("BLZ") + "' "
			cQueryUpdate += " AND BLZ_STATUS = '" + '6' + "' "
			cQueryUpdate += " AND D_E_L_E_T_ = ' ' "
		
			if tcSqlExec( cQueryUpdate ) < 0
				Aviso( "Atencao!", "Erro na execução do update UPDBLZST.prw [ " + tcSqlERROR() + "]", {"Ok"} )
				userException("Erro na atualização do update em etapa: Exigência -> [ " + tcSqlERROR() + "]")
			elseIf __lOracle
				TCSQLExec("COMMIT")
			endIf

			//------------------------------ FINALIZANDO ATUALIZAÇÃO BLZ_ETPPAC ------------------------------//

			//------------------------------ ATUALIZANDO STATUS QUE FORA MIGRADOS PARA ETAPA --------------------//

			cQueryUpdate := " UPDATE " + RetsqlName("BLZ") 
			cQueryUpdate += " SET BLZ_STATUS = '' "
			cQueryUpdate += " WHERE BLZ_FILIAL = '" + xfilial("BLZ") + "' "
			cQueryUpdate += " AND BLZ_STATUS in ('" + '1' + "','" + '2' + "','" + '3' + "','" + '4' + "','" + '5' + "' , '" + '6' + "') "
			cQueryUpdate += " AND D_E_L_E_T_ = ' ' "
		
			if tcSqlExec( cQueryUpdate ) < 0
				Aviso( "Atencao!", "Erro na execução do update UPDBLZST.prw [ " + tcSqlERROR() + "]", {"Ok"} )
				userException("Erro na atualização do update em status: Migração dos Status para Etapa -> [ " + tcSqlERROR() + "]")
			elseIf __lOracle
				TCSQLExec("COMMIT")
			endIf

			//----------------- FINALIZANDO ATUALIZAÇÃO STATUS DESCONTINUADOS BLZ_STATUS ---------------------//
 
			//----------------------------------- ATUALIZANDO  BLZ_STATUS ------------------------------------//
			//Publicado sem Aprovação 
			cQueryUpdate := " UPDATE " + RetsqlName("BLZ") 
			cQueryUpdate += " SET BLZ_STATUS = '1' "
			cQueryUpdate += " WHERE BLZ_FILIAL = '" + xfilial("BLZ") + "' "
			cQueryUpdate += " AND BLZ_STATUS = '" + '9' + "' "
			cQueryUpdate += " AND D_E_L_E_T_ = ' ' "
		
			if tcSqlExec( cQueryUpdate ) < 0
				Aviso( "Atencao!", "Erro na execução do update UPDBLZST.prw [ " + tcSqlERROR() + "]", {"Ok"} )
				userException("Erro na atualização do update em status: Publicado sem Aprovação -> [ " + tcSqlERROR() + "]")
			elseIf __lOracle
				TCSQLExec("COMMIT")
			endIf

			//Aprovado 
			cQueryUpdate := " UPDATE " + RetsqlName("BLZ") 
			cQueryUpdate += " SET BLZ_STATUS = '2' "
			cQueryUpdate += " WHERE BLZ_FILIAL = '" + xfilial("BLZ") + "' "
			cQueryUpdate += " AND BLZ_STATUS = '" + '7' + "' "
			cQueryUpdate += " AND D_E_L_E_T_ = ' ' "
			
			if tcSqlExec( cQueryUpdate ) < 0
				Aviso( "Atencao!", "Erro na execução do update UPDBLZST.prw [ " + tcSqlERROR() + "]", {"Ok"} )
				userException("Erro na atualização do update em status: Aprovado -> [ " + tcSqlERROR() + "]")
			elseIf __lOracle
				TCSQLExec("COMMIT")
			endIf
			
			//Aprovado com ressalva
			cQueryUpdate := " UPDATE " + RetsqlName("BLZ") 
			cQueryUpdate += " SET BLZ_STATUS = '3' "
			cQueryUpdate += " WHERE BLZ_FILIAL = '" + xfilial("BLZ") + "' "
			cQueryUpdate += " AND BLZ_STATUS = '" + '8' + "' "
			cQueryUpdate += " AND D_E_L_E_T_ = ' ' "
			
			if tcSqlExec( cQueryUpdate ) < 0
				Aviso( "Atencao!", "Erro na execução do update UPDBLZST.prw [ " + tcSqlERROR() + "]", {"Ok"} )
				userException("Erro na atualização do update em status: Aprovado com ressalva -> [ " + tcSqlERROR() + "]")
			elseIf __lOracle
				TCSQLExec("COMMIT")
			endIf
			
			//Reprovado
			cQueryUpdate := " UPDATE " + RetsqlName("BLZ") 
			cQueryUpdate += " SET BLZ_STATUS = '4' "
			cQueryUpdate += " WHERE BLZ_FILIAL = '" + xfilial("BLZ") + "' "
			cQueryUpdate += " AND BLZ_STATUS = '" + '10' + "' "
			cQueryUpdate += " AND D_E_L_E_T_ = ' ' "
			
			if tcSqlExec( cQueryUpdate ) < 0
				Aviso( "Atencao!", "Erro na execução do update UPDBLZST.prw [ " + tcSqlERROR() + "]", {"Ok"} )
				userException("Erro na atualização do update em status: Reprovado  -> [ " + tcSqlERROR() + "]")
			elseIf __lOracle
				TCSQLExec("COMMIT")
			endIf
			
			//Reprovado Vigente
			cQueryUpdate := " UPDATE " + RetsqlName("BLZ") 
			cQueryUpdate += " SET BLZ_STATUS = '5' "
			cQueryUpdate += " WHERE BLZ_FILIAL = '" + xfilial("BLZ") + "' "
			cQueryUpdate += " AND BLZ_STATUS = '" + '11' + "' "
			cQueryUpdate += " AND D_E_L_E_T_ = ' ' "

			if tcSqlExec( cQueryUpdate ) < 0
				Aviso( "Atencao!", "Erro na execução do update UPDBLZST.prw [ " + tcSqlERROR() + "]", {"Ok"} )
				userException("Erro na atualização do update em status: Reprovado Vigente -> [ " + tcSqlERROR() + "]")
			elseIf __lOracle
				TCSQLExec("COMMIT")
			endIf

			//Cancelado
			cQueryUpdate := " UPDATE " + RetsqlName("BLZ") 
			cQueryUpdate += " SET BLZ_STATUS = '6' "
			cQueryUpdate += " WHERE BLZ_FILIAL = '" + xfilial("BLZ") + "' "
			cQueryUpdate += " AND BLZ_STATUS = '" + '12' + "' "
			cQueryUpdate += " AND D_E_L_E_T_ = ' ' "
			
			if tcSqlExec( cQueryUpdate ) < 0
				Aviso( "Atencao!", "Erro na execução do update UPDBLZST.prw [ " + tcSqlERROR() + "]", {"Ok"} )
				userException("Erro na atualização do update em status: Cancelado -> [ " + tcSqlERROR() + "]")
			elseIf __lOracle
				TCSQLExec("COMMIT")
			endIf
			
			//Suspenso
			cQueryUpdate := " UPDATE " + RetsqlName("BLZ") 
			cQueryUpdate += " SET BLZ_STATUS = '7' "
			cQueryUpdate += " WHERE BLZ_FILIAL = '" + xfilial("BLZ") + "' "
			cQueryUpdate += " AND BLZ_STATUS = '" + '14' + "' "
			cQueryUpdate += " AND D_E_L_E_T_ = ' ' "
			
			if tcSqlExec( cQueryUpdate ) < 0
				Aviso( "Atencao!", "Erro na execução do update UPDBLZST.prw [ " + tcSqlERROR() + "]", {"Ok"} )
				userException("Erro na atualização do update em status: Suspenso -> [ " + tcSqlERROR() + "]")
			elseIf __lOracle
				TCSQLExec("COMMIT")
			endIf
			
			nRet := .T.

		end transaction

    else 
		nRet := .f. 
    endIf 

	cAliasBLZ->(dbCloseArea())

	//rpcClearEnv()

return nRet
