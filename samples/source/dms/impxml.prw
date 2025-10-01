#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"
#include "protheus.ch"
#include "topconn.ch"
#include "fileio.ch"
/*
===============================================================================
###############################################################################
##+----------+------------+-------+-----------------------+------+----------+##
##|Função    | IMPXML     | Autor | MIL			          | Data | 18/01/13 |##
##+----------+------------+-------+-----------------------+------+----------+##
##|Descrição |                                                              |##
##+----------+--------------------------------------------------------------+##
##|Uso       |                                                              |##
##+----------+--------------------------------------------------------------+##
###############################################################################
===============================================================================
*/
User Function IMPXML()
//
Local cDesc1       := "Importação de nota fiscal de compra de peças." // TODO - Descrição do FormBatch
Local cDesc2       := "" // TODO - Descrição do FormBatch
Local cDesc3       := "" // TODO - Descrição do FormBatch
Local aSay         := {}
Local aButton      := {}
PRIVATE cCadastro  := ""
PRIVATE oXmlHelper := nil
PRIVATE aRotina
//
Private cTitulo    := "Importação XML Entrada" // TODO - Titulo do Assunto (Vai no relatório e FormBatch)
Private cPerg      := "GOBJXML2"
Private lErro      := .f.		// Se houve erro, não move arquivo gerado
Private cArquivo				// Nome do Arquivo a ser importado
Private aLinhasRel := {}		// Linhas que serão apresentadas no relatorio
Private aItemErro  := {}
Private aVolumes   := {}
Private cPedido := ""
Private cItemPc := ""
Private nMostraTela := 0 // Obrigatória já que é usada diretamente na função A140NFISCAL()

if Empty(GetNewPar("MV_ESPECNF",""))
   MsgStop("Parâmetro MV_ESPECNF não esta preenchido, favor configurar o parâmetro para prosseguir!")
   Return(.f.)
Endif

//////////////////////////////////////////////////////////////////////////////////////////
//  A T E N Ç Ã O :   É  NECESSARIO  CRIAR  A  PERGUNTE  (SX1)    "GOBJXML2"            //
//////////////////////////////////////////////////////////////////////////////////////////
// 01 "mv_par01" - "Caminho do Arquivo" "C" 40 Get - valid: "mv_par01 := u_impxmlGtF()" //
// 02 "mv_par02" - "Marca"              "C"  3 Get                                      //
// 03 "mv_par03" - "Mostra Detalhes"    "N"  1 Combo ( "Sim" / "Não" )                  //
//////////////////////////////////////////////////////////////////////////////////////////

//
aAdd( aSay, cDesc1 ) // Um para cada cDescN
aAdd( aSay, cDesc2 ) // Um para cada cDescN
aAdd( aSay, cDesc3 ) // Um para cada cDescN
//
nOpc := 0
aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T. )    }} )
aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )
//
FormBatch( cTitulo, aSay, aButton )
//
If nOpc <> 1
	Return
Endif
//
Pergunte(cPerg,.f.)
If Empty(MV_PAR01) .or. Empty(MV_PAR02)
	MsgStop("Favor preencher os parâmetros corretamente.")
	Return
EndIf
//
FS_SELARQUIVOS()
//
return

Static Function FS_SELARQUIVOS()

	Local oDlgSelArquivo

	Local cDir     := Alltrim(MV_PAR01)
	Local cMarca   := MV_PAR02
	
	Local aSize    := FWGetDialogSize( oMainWnd )
	Local oNo      := LoadBitmap( GetResources(), "LBNO" )
	Local oTik     := LoadBitmap( GetResources(), "LBTIK" )

	Local aVetNome := {}
	Local aVetTam  := {}
	Local aVetData := {}
	Local aVetHora := {}

	Local nOpca    := 0
	Local nAcao    := 1
	Local nCntFor  := 0

	Private cCadastro := "Selecionar arquivos XML para importação"

	Private oProcImpXML
	Private lMarcar    := .f.

	Private cEspecNF := GetNewPar("MV_ESPECNF","NF")

	Private oLBoxArquivos
	Private aArquivos := {{.f.,""}}

	if aDir(Alltrim(MV_PAR01)+"*.xml" ,aVetNome,aVetTam,aVetData,aVetHora) <= 0
		MsgStop("Nenhum arquivo XML encontrado no diretório!")
		Return
	endif

	for nCntFor := 1 to Len(aVetNome)
		if Len(aArquivos) == 1 .and. Empty(aArquivos[1,2])
			aArquivos := {}
	  	Endif
		If MV_Par03 == 1 // Mostra detalhes dos Arquivos
			lError     := .f.
			lContinue  := .t.
			cError     := ""
			cWarning   := ""
			cFile      := cDir + aVetNome[nCntFor]
			cFileSalva := cDir + ALLTRIM("salva\ ") + aVetNome[nCntFor]
			//Gera o Objeto XML
			oXml       := XmlParserFile( cFile, "_", @cError, @cWarning )
			If !Empty(cError) .or. VALTYPE( XmlChildEx(oXml, "_NFEPROC") ) == "U" // valida se o xml é válido
				Loop
			EndIf
			oXmlHelper := Mil_XmlHelper():New(oXml)
			cVerXML := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_VERSAO:Text")
			If ValType(oXml:_NFEPROC:_NFE:_INFNFE:_DET) == "O"
				nPecas := 1
			Else
				nPecas := Len(oXml:_NFEPROC:_NFE:_INFNFE:_DET)
			EndIf
			if nPecas <= 0
				Loop
			EndIf
			cSerie  := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_IDE:_serie:Text")
			cNF     := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:Text")
			If Val(Left(cVerXML,1)) <= 2
				cEmissao := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:Text")
			Else
				cEmissao := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:Text")
			EndIf
			dEmissao := stod(Left(cEmissao,4)+subs(cEmissao,6,2)+subs(cEmissao,9,2))
			cCNPJFor := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:Text")
			DBSelectArea("SA2")
			DBSetOrder(3)
			DBSeek(xFilial("SA2") + Alltrim(cCNPJFor))
	 		aAdd(aArquivos,{.f.,aVetNome[nCntFor],cNF,cSerie,cEmissao,cCNPJFor,SA2->A2_COD+"-"+SA2->A2_LOJA+" "+SA2->A2_NOME})
		Else
	 		aAdd(aArquivos,{.f.,aVetNome[nCntFor],"","","","",""})
		Endif
	Next
	
	oDlgSelArquivo := MSDialog():New( aSize[1], aSize[2], aSize[3], aSize[4], cCadastro, , , , nOr( WS_VISIBLE, WS_POPUP ), , , , , .T., , , , .F. )
		oLBoxArquivos := TWBrowse():New(1,1,100,100,,,,oDlgSelArquivo,,,,,{ || FS_TIK( lMarcar, "0") },,,,,,,.F.,,.T.,,.F.,,,)
		oLBoxArquivos:AddColumn( TCColumn():New( "", { || IIf(aArquivos[oLBoxArquivos:nAt,1],oTik,oNo) } ,,,,"LEFT" ,05,.T.,.F.,,,,.F.,) ) // Tik
		oLBoxArquivos:AddColumn( TCColumn():New( "Arquivo XML" , { || aArquivos[oLBoxArquivos:nAt,2] } ,,,,"LEFT" ,100,.F.,.F.,,,,.F.,) )
		oLBoxArquivos:AddColumn( TCColumn():New( "Nota Fiscal" , { || aArquivos[oLBoxArquivos:nAt,3] } ,,,,"LEFT" ,60,.F.,.F.,,,,.F.,) )
		oLBoxArquivos:AddColumn( TCColumn():New( "Série" , { || aArquivos[oLBoxArquivos:nAt,4] } ,,,,"LEFT" ,30,.F.,.F.,,,,.F.,) )
		oLBoxArquivos:AddColumn( TCColumn():New( "Emissão" , { || aArquivos[oLBoxArquivos:nAt,5] } ,,,,"LEFT" ,100,.F.,.F.,,,,.F.,) )
		oLBoxArquivos:AddColumn( TCColumn():New( "CNPJ Fornecedor" , { || Transform(aArquivos[oLBoxArquivos:nAt,6],GetSX3Cache("A2_CGC","X3_PICTURE")) } ,,,,"LEFT" ,100,.F.,.F.,,,,.F.,) )
		oLBoxArquivos:AddColumn( TCColumn():New( "Fornecedor" , { || aArquivos[oLBoxArquivos:nAt,7] } ,,,,"LEFT",200,.F.,.F.,,,,.F.,) )
		oLBoxArquivos:setArray( aArquivos )
		oLBoxArquivos:Align := CONTROL_ALIGN_ALLCLIENT
		oLBoxArquivos:bHeaderClick := {|oObj,nCol| IIf( nCol==1 , ( lMarcar := !lMarcar , FS_TIK(lMarcar,"1") ) , ) , }
	ACTIVATE MSDIALOG oDlgSelArquivo ON INIT EnchoiceBar(oDlgSelArquivo,{|| (nOpca := 1,oDlgSelArquivo:End()) },{|| oDlgSelArquivo:End() },,)

	If nOpca == 1
		nAcao := Aviso("Tipo de Movimento","O que deseja fazer?", { "Pré-Nota" , "Classificar" } )
		oProcImpXML := MsNewProcess():New({ |lEnd| ImportaXML(cDir , nAcao, cMarca) }," Importando XML ...","",.f.)
		oProcImpXML:Activate()
	Endif

Return

Static Function ImportaXML(cDir, nAcao, cMarca)

	Local cError   := ""
	Local cWarning := ""
	Local cFile    := ""
	Local lAchou   := .f.
	Local nCntFor  := 0
	Local nCntFor2 := 0

	Local aSize    := FWGetDialogSize( oMainWnd )
	Local cNF      := ""
	Local cSerNF   := ""
	Local cCodSA2  := ""
	Local cLojSA2  := ""
	Local aVetCpos := {}
	
	Local cVerXML := ""

	Local cQuery     := ""

	Local cChaveNFE := Space(44)

	Local nTotArquivos := 0
	Local nQtdePedido := 0

	Local cTmpTotIni := Time()
	Local cTmpArqIni
	Local nRecSA2

	Local nSModulo  := nModulo
	Local cSFunName := ""

	Local lFuncTempo := ExistFunc("OA3630011_Tempo_Total_Conferencia_Volume_Entrada")

	Private	nBasICM    	:= 0
	Private	nPerICM    	:= 0
	Private	nValICM    	:= 0
	Private	nBasICMST  	:= 0
	Private	nPerICMST  	:= 0
	Private	nValICMST  	:= 0
	Private	cModBCST    := ""
	Private nAlqSB1		:= 0

	Private lError := .f.

	Private cProduto := ""
	Private cDescP   := ""
	Private cCFOP    := ""
	Private nQuant   := 0
	Private nValUni  := 0

	Private nBasIPITri := 0
	Private nPerIPITri := 0
	Private nValIPITri := 0
	Private nBasPIS    := 0
	Private nPerPIS    := 0
	Private nValPIS    := 0
	Private nBasCOF    := 0
	Private nPerCOF    := 0
	Private nValCOF    := 0
	Private nTBaseIPI  := 0

	Private cNumIte    := Repl( "0", Len(SD1->D1_ITEM) )
	Private aItens 	   := {}

	Private oDet

	Private cAliasSB   := "SQLSB"

	Private oXml := NIL

   	Private lContinue := .t.
	Private aVetPed := {}
	Private nTamMatItens := IIf( nAcao == 1 , 18 , 19 )

	// Totaliza Barra 1
	aEval(aArquivos,{ |x| nTotArquivos += IIf( x[1] , 1 , 0 ) })
	oProcImpXML:SetRegua1(nTotArquivos)
	//

	// tem pedido jdprism pendente?
	cQuery := " SELECT COUNT(*) FROM "+RetSqlName('SC7')
	cQuery += "  WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
	cQuery += "    AND C7_PEDFAB  = 'JDPRISM' "
	cQuery += "    AND D_E_L_E_T_ = ' ' "
	if FM_SQL(cQuery) > 0
		cMsg := "Um pedido importado via jdprism encontrasse pendente, "
		cMsg += "tem certeza que deseja continuar com a importação?" + chr(13) + chr(10)
		cMsg += "Isto pode fazer com que um pedido seja duplicado e o estoque encomendado seja alterado."
		if ! MsgNoYes(cMsg, "Atenção!")
			MsgStop("Operação cancelada, o pedido pendente pode ser adequado na rotina de Importações JDPRISM(OFINJD44)")
			return .f.
		endif
	endif

	for nCntFor := 1 to Len(aArquivos)

		if !aArquivos[nCntFor,1]
			Loop
		Endif

		cTmpArqIni := Time()

		lError := .f.
		lContinue := .t.

		cFile := cDir + aArquivos[nCntFor,2]
		cFileSalva := cDir + ALLTRIM("salva\ ") + aArquivos[nCntFor,2]

		//Gera o Objeto XML
		oXml       := XmlParserFile( cFile, "_", @cError, @cWarning )
		If !Empty(cError) .or. VALTYPE( XmlChildEx(oXml, "_NFEPROC") ) == "U" // valida se o xml é válido
			MsgStop("Arquivo XML inválido" + chr(13) + chr(10)  + chr(13) + chr(10) + ;
				"Arquivo: " + AllTrim(cFile) + chr(13) + chr(10) + ;
				IIf( !Empty(cError), "Erro: " + AllTrim(cError), "" ),"Erro")
			Loop
		EndIf

		oXmlHelper := Mil_XmlHelper():New(oXml)

		cVerXML := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_VERSAO:Text")

		If ValType(oXml:_NFEPROC:_NFE:_INFNFE:_DET) == "O"
			nPecas := 1
		Else
			nPecas := Len(oXml:_NFEPROC:_NFE:_INFNFE:_DET)
		EndIf

		if nPecas <= 0
			Loop
		EndIf

		cTxtObs := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_INFADIC:_INFADFISCO:Text")
		cSerie  := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_IDE:_serie:Text")
		cNF     := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:Text")

		oProcImpXML:IncRegua1("Processando Nota Fiscal: " + cSerie + "-" + cNF)

		If Val(Left(cVerXML,1)) <= 2
			cEmissao := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:Text")
		Else
			cEmissao := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:Text")
		EndIf
		dEmissao := stod(Left(cEmissao,4)+subs(cEmissao,6,2)+subs(cEmissao,9,2))
		cCNPJFor := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:Text")
		//--------------------------------------------------------------------------------------------------------//
		// Estes campos abaixo não estavam sendo utilizados mas serão mantidos por 1 versao para manter historico //
		//--------------------------------------------------------------------------------------------------------//
		// nCNPJCli  := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:Text")                             //
		// nTBasICM  := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:Text", 0)                 //
		// nTValMerc := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPROD:Text", 0)               //
		// nTValDesc := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:Text", 0)               //
		// nTValPIS  := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPIS:Text", 0)                //
		// nTValCOF  := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VCOFINS:Text", 0)             //
		// nTotNF    := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:Text", 0)                 //
		// cDatVenc  := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_COBR:_DUP:_DVENC:Text", 0)                    //
		// nNumDupl  := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_COBR:_DUP:_NDUP:Text", 0)                     //
		// nValDupl  := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_COBR:_DUP:_VDUP:Text", 0)                     //
		// dDatVenc  := stod(Left(cDatVenc,4)+subs(cDatVenc,6,2)+subs(cDatVenc,9,2))                              //
		//--------------------------------------------------------------------------------------------------------//
		nTValICM  := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:Text"  , '0')
		nTBasST   := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:Text"  , '0')
		nTValST   := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:Text"    , '0')
		nTValFre  := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE:Text" , '0')
		nTValSeg  := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VSEG:Text"   , '0')
		nTValIPI  := oXmlHelper:GetValue("_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:Text"   , '0')

		cChaveNFE := oXmlHelper:GetValue("_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:Text"   , '0')

		cNF := STRZERO(VAL(cNF),9)

		lError := FS_VALIDIMP(cMarca, cCNPJFor, cNF, cSerie)
		If lError
			Loop
		EndIf

		nRecSA2 := SA2->(Recno())

		nSModulo := nModulo
		nModulo  := 41 // Auto Peças

		aPedidos := {}
		nQtdePedido := 0
		// Relaciona Pedido de Compra para Baixa do Estoque Encomendado
		lContinue := OFINJD47(	cNF,;
								cSerie,;
								SA2->A2_COD,;
								SA2->A2_LOJA,;
								aVetPed,;
								.t.,;
								VE4->VE4_PGTNFP ,;
								cMarca,;
								oProcImpXML,;
								"",;
								oXml,;
								nPecas)
		If !lContinue
			Return .f.
		EndIf

		SA2->(DbGoTo(nRecSA2))

		nModulo  := nSModulo
		// Cabecalho da nota fiscal de entrada
		aCabec   := {}
		aItens   := {}
		aadd(aCabec,{"F1_TIPO"   	,"N"})
		aadd(aCabec,{"F1_FORMUL" 	,"N"})
		aadd(aCabec,{"F1_DOC"    	,cNF})
		aadd(aCabec,{"F1_SERIE"  	,Alltrim(cSerie)})
		aadd(aCabec,{"F1_EMISSAO"	,dEmissao})
		aadd(aCabec,{"F1_FORNECE"	,SA2->A2_COD})
		aadd(aCabec,{"F1_LOJA"   	,SA2->A2_LOJA})
		aadd(aCabec,{"F1_ESPECIE"	,cEspecNF})
		aadd(aCabec,{"F1_COND"		,VE4->VE4_PGTNFP})
		aadd(aCabec,{"F1_EST"		,SA2->A2_EST}) // Alteraçao realizada pois estava gravando incorretamente quando transferencia entre estado - MAQNELSON
		aadd(aCabec,{"F1_SEGURO"  	, Val(nTValSeg) })
		aadd(aCabec,{"F1_FRETE"   	, Val(nTValFre) })
		aadd(aCabec,{"F1_VALICM"	, Val(nTValICM)	})
		aadd(aCabec,{"F1_VALIPI"	, Val(nTValIPI)	})
		aadd(aCabec,{"F1_BRICMS"	, Val(nTBasST)  })
		aadd(aCabec,{"F1_ICMSRET"	, Val(nTValST)  })
		aadd(aCabec,{"F1_RECBMTO"	, dDataBase		})

		cSerNF  := PadR( Alltrim(cSerie) ,TamSX3("D1_SERIE")[1] )
		cCodSA2 := SA2->A2_COD
		cLojSA2 := SA2->A2_LOJA

		cChaveSD1 := xFilial("SD1") + cNF + cSerNF + cCodSA2 + cLojSA2

		aVolumes  := {}
		aItemErro := {}
		If nPecas == 1
			oDet := oXml:_NFEPROC:_NFE:_INFNFE:_DET
			FS_CRIAVIA( nAcao )
			FS_ItemErro()
		Else
			for nCntFor2 := 1 to nPecas
				oDet := oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCntFor2]
				FS_CRIAVIA( nAcao )
				FS_ItemErro()
			next nCntFor2
		EndIf
		if Len(aItemErro) > 0
			cCadastro := "Itens com problemas"
			oDlgErro := MSDialog():New( aSize[1], aSize[2], aSize[3], aSize[4], cCadastro, , , , nOr( WS_VISIBLE, WS_POPUP ), , , , , .T., , , , .F. )
				oLBErro := TWBrowse():New(1,1,100,100,,,,oDlgErro,,,,,{ || .t. },,,,,,,.F.,,.T.,,.F.,,,)
				oLBErro:AddColumn( TCColumn():New( "Cód.Produto" , { || aItemErro[oLBErro:nAt,1] } ,,,,"LEFT" ,100,.F.,.F.,,,,.F.,) )
				oLBErro:AddColumn( TCColumn():New( "Descrição"   , { || aItemErro[oLBErro:nAt,2] } ,,,,"LEFT" ,200,.F.,.F.,,,,.F.,) )
				oLBErro:AddColumn( TCColumn():New( "Observação"  , { || aItemErro[oLBErro:nAt,3] } ,,,,"LEFT" ,200,.F.,.F.,,,,.F.,) )
				oLBErro:setArray( aItemErro )
				oLBErro:Align := CONTROL_ALIGN_ALLCLIENT
			ACTIVATE MSDIALOG oDlgErro ON INIT EnchoiceBar(oDlgErro,{|| oDlgErro:End() },{|| oDlgErro:End() },,)
			Return .f.
		Endif

		aAdd(aCabec,{"F1_BASEIPI", nTBaseIPI , Nil})  // Carrega o total da base do IPI

		If VVF->(FieldPos("VVF_CHVNFE")) > 0
			aAdd(aCabec,{"F1_CHVNFE" , cChaveNFE   ,Nil})
		endif

		LMSERROAUTO := .F.

		//MATA140(aCabec,aItens,3)
		MSExecAuto({|x,y,z| MATA140(x,y,z)},aCabec,aItens,3)

		If lMsErroAuto
			MostraErro()
			Return .f.
		else
			// Criação dos Volumes dos Itens
			For nCntFor2 := 1 to len(aVolumes)
				aVetCpos := {}
				aadd(aVetCpos,{ "VCX_DOC"    , cNF })
				aadd(aVetCpos,{ "VCX_SERIE"  , cSerNF })
				aadd(aVetCpos,{ "VCX_FORNEC" , cCodSA2 })
				aadd(aVetCpos,{ "VCX_LOJA"   , cLojSA2 })
				aadd(aVetCpos,{ "VCX_COD"    , aVolumes[nCntFor2,1] })
				aadd(aVetCpos,{ "VCX_ITEM"   , aVolumes[nCntFor2,2] })
				aadd(aVetCpos,{ "VCX_VOLUME" , aVolumes[nCntFor2,3] })
				aadd(aVetCpos,{ "VCX_QTDITE" , aVolumes[nCntFor2,4] })
				OA3200011_Volumes_dos_Itens_da_NF_Entrada( 0 , aVetCpos ) // Incluir Volumes com quantidade dos Itens da NF de Entrada
				If lFuncTempo
					OA3630011_Tempo_Total_Conferencia_Volume_Entrada( 1 , aVolumes[nCntFor2,3] ) // 1=Iniciar o Tempo Total da Conferencia de Volume de Entrada caso não exista o registro
				EndIf
			Next
			If ExistFunc("OA3600011_Tempo_Total_Conferencia_NF_Entrada")
				OA3600011_Tempo_Total_Conferencia_NF_Entrada( 1 , cNF , cSerNF , cCodSA2 , cLojSA2 ) // 1=Iniciar o Tempo Total da Conferencia de NF de Entrada caso não exista o registro
			EndIf
			//
			DBSelectArea("SD1")
			DBSetOrder(1)
			DBSeek(cChaveSD1)
			while xFilial(cChaveSD1) == SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
				reclock("SD1",.f.)
				SD1->D1_CONBAR := "0"
				msunlock()
				DBSkip()
			enddo
		EndIf

		Conout(" ")
		Conout("======================================================================")
		Conout("IMPXML - Finalizada a importacao: " + cChaveSD1 + " (Filial+NF+Serie+Fornecedor+Loja)")
		Conout("         Tempo de Processamento: " + ElapTime(cTmpArqIni,Time()))
		Conout("======================================================================")

		oProcImpXML:IncRegua2("Executando rotina de Nota Fiscal")

		ALTERA    := .T.
		INCLUI    := .F.
		EXCLUI    := .F.
		VISUALIZA := .F.

		If nAcao == 1 //PRE NOTA

			// Executa alteração da pre-nota
			//A140NFiscal('SF1',SF1->(recno()),4)
			MSExecAuto({|x,y,z,a,b| MATA140(x,y,z,a,b)},aCabec,aItens,4,,2)

		ElseIf nAcao == 2 //Classifica

			// Executa classificao da rotina de documento de entrada
			//A103NFiscal('SF1',SF1->(recno()),4)
			MSExecAuto({|x,y,z,a| MATA103(x,y,z,a)},aCabec,aItens,4,.T.)

		Endif

		Copy File &(cFile) to &(cFileSalva)
		Dele File &(cFile)

		lAchou := .t.

	next
	if lAchou
		MsgInfo("Todos os arquivos foram importados. Tempo de Processamento: " + ElapTime(cTmpTotIni,Time()))
	Else
		MsgInfo("Nenhum arquivo foi importado, verifique!")
	Endif
return .t.


Static Function FS_VALIDIMP(cMarca, cCNPJFor, cNF, cSerie)
	DbSelectArea("VE4")
	DbSetOrder(1)
	If !DbSeek( xFilial("VE4") + cMarca + cCNPJFor) // Busca por marca + CNPJ do fornecedor da nota fiscal
		MsgStop("Não foi possível encontrar o cadastro do fornecedor com CNPJ " + Alltrim(cCNPJFor) +;
			" na rotina Parâmetro Marca (OFIPA980). A operação será abortada. Por favor verifique!","Atenção!")
		Return .t.
	EndIf
	If Empty(VE4->VE4_PGTNFP)
		MsgStop("A condição de pagamento padrão a ser utilizada na importação de pedido de compras está em " +;
			"branco. Por favor, verifique o conteúdo do campo F.Pgto NF Pc (VE4_PGTNFP) da rotina Parâmetro " +;
			"Marca (OFIPA980)!","Atenção!")
		Return .t.
	EndIf

	DBSelectArea("SA2")
	DBSetOrder(3)
	if !DBSeek(xFilial("SA2") + Alltrim(cCNPJFor))
		MsgStop("O Fornecedor com CNPJ " + Alltrim(cCNPJFor) + " não foi encontrado. " +;
			"A Nota Fiscal " + Alltrim(cNF) + " não será importada.")
		Return .t.
	endif
	cQuery := "SELECT SF1.R_E_C_N_O_ RECSF1 " +;
			"  FROM "+RetSQLName("SF1")+" SF1 " +;
			" WHERE SF1.F1_FILIAL = '" + xFilial("SF1") + "'" + ;
			"   AND SF1.F1_DOC = '" + cNF + "'" +;
			"   AND SF1.F1_SERIE = '" + cSerie + "'" +;
			"   AND SF1.F1_FORNECE = '" + SA2->A2_COD + "'" +;
			"   AND SF1.F1_LOJA = '" + SA2->A2_LOJA + "'" +;
			"   AND SF1.D_E_L_E_T_ = ' '"
	If FM_SQL(cQuery) > 0
		MsgStop("Nota Fiscal "+cNF+"-"+cSerie+" já existe e não será importada.")
		Return .t.
	endif
Return .f.

/*
===============================================================================
###############################################################################
##+----------+------------+-------+-----------------------+------+----------+##
##|Função    | impxmlGtF  | Autor |  Vinicius Gati        | Data | 29/05/15 |##
##+----------+------------+-------+-----------------------+------+----------+##
##+ Criado para ser usado dentro da pergunte                                +##
##+----------+------------+-------+-----------------------+------+----------+##
###############################################################################
===============================================================================
*/
User Function impxmlGtF()
Return	cGetFile("","Local dos arquivos XML para importação",,"",.T.,GETF_RETDIRECTORY,.T.)

/*
===============================================================================
###############################################################################
##+----------+------------+-------+-----------------------+------+----------+##
##|Função    | CriaVIA    | Autor |  ?????????????        | Data | 29/05/15 |##
##+----------+------------+-------+-----------------------+------+----------+##
##+ Criado para ser usado no pergunte                                       +##
##+----------+------------+-------+-----------------------+------+----------+##
###############################################################################
===============================================================================
*/
Static Function FS_CRIAVIA( nAcao )

Local cTesE   := ""
Local cPedido := ""
Local cItemPc := ""
Local cInfProd:= ""
Local cVolume := ""
Local cConfer := ""
Local cQtdIte := ""
Local cAuxQtd := ""
Local nTamStr := 0
Local nCntFor := 0
Local nPosPed := 0
Local nPosItens
Local aAuxItens := {}
Local aCposAlt  := {}

nBasIPITri := 0
nPerIPITri := 0
nValIPITri := 0

nBasPIS    := 0
nPerPIS    := 0
nValPIS    := 0

nBasCOF    := 0
nPerCOF    := 0
nValCOF    := 0

oXmlDetHlp := Mil_XmlHelper():New(oDet)

cProduto   := oXmlDetHlp:GetValue('_PROD:_CPROD:Text')
cDescP     := oXmlDetHlp:GetValue('_PROD:_XPROD:Text')
cCFOP      := oXmlDetHlp:GetValue('_PROD:_CFOP:Text' )
nQuant     := Val( oXmlDetHlp:GetValue('_PROD:_QCOM:Text'  , '0') )
nValUni    := Val( oXmlDetHlp:GetValue('_PROD:_VUNCOM:Text', '0') )

nBasICM    := 0
nPerICM    := 0
nValICM    := 0
nBasICMST  := 0
nPerICMST  := 0
nValICMST  := 0
FS_TrataICM()

if XmlChildEx(oDET:_Imposto:_IPI, "_IPITRIB" )!= Nil
	nBasIPITri := Val( oXmlDetHlp:GetValue('_IMPOSTO:_IPI:_IPITRIB:_VBC:Text' , '0') )
	nPerIPITri := Val( oXmlDetHlp:GetValue('_IMPOSTO:_IPI:_IPITRIB:_PIPI:Text', '0') )
	nValIPITri := Val( oXmlDetHlp:GetValue('_IMPOSTO:_IPI:_IPITRIB:_VIPI:Text', '0') )
Endif

if XmlChildEx(oDET:_Imposto:_PIS, "_PISALIQ" ) != Nil
	nBasPIS    := Val( oXmlDetHlp:GetValue('_IMPOSTO:_PIS:_PISALIQ:_VBC:Text' , '0') )
	nPerPIS    := Val( oXmlDetHlp:GetValue('_IMPOSTO:_PIS:_PISALIQ:_PPIS:Text', '0') )
	nValPIS    := Val( oXmlDetHlp:GetValue('_IMPOSTO:_PIS:_PISALIQ:_VPIS:Text', '0') )
Endif

if XmlChildEx(oDET:_Imposto:_COFINS, "_COFINSALIQ" ) != Nil
	nBasCOF    := Val( oXmlDetHlp:GetValue('_IMPOSTO:_COFINS:_COFINSALIQ:_VBC:Text'    , '0') )
	nPerCOF    := Val( oXmlDetHlp:GetValue('_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS:Text', '0') )
	nValCOF    := Val( oXmlDetHlp:GetValue('_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS:Text', '0') )
Endif
//

cInfProd := oXmlDetHlp:GetValue('_INFADPROD:Text')

if !lError

	cQuery := " SELECT B1_COD, B1_GRUPO, B1_TE , B1_PICMENT, B1_UM, B1_LOCPAD  "
	cQuery += "   FROM "+RetSqlName("SB1")
	cQuery += "  WHERE B1_FILIAL  = '" + xFilial("SB1")    + "' "
	cQuery += "    AND B1_CODFAB  = '" + Alltrim(cProduto) + "' "
	cQuery += "    AND D_E_L_E_T_ = ' ' "
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasSB , .F., .T. )

	If (cAliasSB)->(Eof())
		AADD(aItemErro,{cProduto,cDescP,"PRODUTO NAO ENCONTRADO"})
	EndIf

	If nAcao == 2
		cTesE := ""
		If !Empty((cAliasSB)->(B1_TE))
			cTesE := (cAliasSB)->(B1_TE)
		ElseIf !Empty(VE4->VE4_TESENT)
			cTesE := VE4->VE4_TESENT
		Else
			cTesE := FM_PRODSBZ((cAliasSB)->(B1_COD),"SB1->B1_TE")
		EndIf
		DbSelectArea("SF4")
		DbSetOrder(1)
		MsSeek( xFilial("SF4") + cTesE )
	EndIf

	cPedido  := ""
	cItemPc  := ""
	lResiduo := .f.
	 	If Len(aVetPed) > 0
		nPosPed := aScan(aVetPed,{|x| x[2] == (cAliasSB)->(B1_COD) .and. ;
										x[6] == nQuant .and. ;
										x[8] == "naousado"})
		If nPosPed > 0
			cPedido := aVetPed[nPosPed,4]
			cItemPc := aVetPed[nPosPed,5]
			nRecSC7 := aVetPed[nPosPed,7]
			aVetPed[nPosPed,8] := "usado"
		Else
			nPosPed := aScan(aVetPed,{|x| x[2] == (cAliasSB)->(B1_COD) .and. ;
											x[6] == nQuant .and. ;
											x[8] == "residuo"})
			If nPosPed > 0
				lResiduo := .t.
				cPedido := aVetPed[nPosPed,4]
				cItemPc := aVetPed[nPosPed,5]
				nRecSC7 := aVetPed[nPosPed,7]
				aVetPed[nPosPed,8] := "usado"
			EndIf
		EndIf
	EndIf
	If !Empty(cPedido)
		//
		// Atualização dos Valores e Aliquotas de IPI e ICMS no Pedido de Compras, conforme conteúdo do XML
		//
		aCposAlt := {}
		AADD( aCposAlt , { "C7_IPI"       , nPerIPITri } )
		AADD( aCposAlt , { "C7_PICM"      , nPerICM    } )
		AADD( aCposAlt , { "C7_VALIPI"    , nValIPITri } )
		AADD( aCposAlt , { "C7_VALICM"    , nValICM    } )
		OFJD10AtuPed(cPedido,cItemPC,nRecSC7,aCposAlt)
	Endif
	nPosItens := Len(aItens)
	If nPosItens > 0
		cNumIte := aItens[nPosItens,1,2]
	EndIf
	cNumIte := SOMA1(cNumIte)

	aAuxItens := {}
	AADD( aAuxItens , { "D1_ITEM"    , cNumIte                                         , NIL } )
	AADD( aAuxItens , { "D1_COD"     , (cAliasSB)->(B1_COD)                            , NIL } )
	AADD( aAuxItens , { "D1_UM"      , (cAliasSB)->(B1_UM)                             , NIL } )
	If !Empty(cPedido)
		AADD( aAuxItens , { "D1_PEDIDO"  , cPedido                                     , NIL } )
		AADD( aAuxItens , { "D1_ITEMPC"  , cItemPc                                     , NIL } )
	EndIf
	AADD( aAuxItens , { "D1_QUANT"   , nQuant                                          , NIL } )
	AADD( aAuxItens , { "D1_VUNIT"   , nValUni                                         , NIL } )
	AADD( aAuxItens , { "D1_TOTAL"   , nValUni * nQuant                                , NIL } )
	AADD( aAuxItens , { "D1_VALIPI"  , nValIPITri                                      , NIL } )
	AADD( aAuxItens , { "D1_IPI"     , nPerIPITri                                      , NIL } )
	AADD( aAuxItens , { "D1_PICM"    , nPerICM                                         , NIL } )
	AADD( aAuxItens , { "D1_BASEIPI" , Round( ( nValIPITri / ( nPerIPITri/100 ) ) ,2 ) , NIL } )
	AADD( aAuxItens , { "D1_VALICM"  , nValIcm                                         , NIL } )
	If nAcao == 2
		AADD( aAuxItens , { "D1_TES"     , cTesE                                       , NIL } )
	EndIf
	AADD( aAuxItens , { "D1_RATEIO"  , "2"                                             , NIL } )
	AADD( aAuxItens , { "D1_ALIQSOL" , nPerICMST                                       , NIL } )
	AADD( aAuxItens , { "D1_BRICMS"  , nBasICMST                                       , NIL } )
	AADD( aAuxItens , { "D1_ICMSRET" , nValICMST                                       , NIL } )
	AADD( aAuxItens , { "D1_LOCAL"   , (cAliasSB)->B1_LOCPAD                           , NIL } )

	AADD( aItens , aClone(aAuxItens) )
	
	If At("LPN-",cInfProd) > 0

		// Carregar Vetor com os Volumes e Qtdes para serem gravados no VCX
		cInfProd := substr(cInfProd,At("LPN-",cInfProd)+4)
		nQtdVol := 0
		While .t.
			nTamStr  := At("(",cInfProd)-1 // Ate chegar no inicio da Qtde
			If nTamStr > 0
				cVolume  := left(cInfProd,nTamStr) // Codigo do Volume
				cInfProd := substr(cInfProd,nTamStr+2) // Retira o Codigo do Volume da String principal
				nTamStr  := At(")",cInfProd)-1 // Ate chegar no final da Qtde
				If nTamStr <= 0
					nTamStr := len(cInfProd)
				EndIf
				cAuxQtd  := left(cInfProd,nTamStr) // Bloco da Qtde
				cQtdIte  := ""
				For nCntFor :=  1 to len(cAuxQtd)
					If substr(cAuxQtd,nCntFor,1) >= "0" .and. substr(cAuxQtd,nCntFor,1) <= "9" // Somente Numeros
						cQtdIte += substr(cAuxQtd,nCntFor,1) // Constroi o STR referente a Qtde
					Else
						Exit
					EndIf
				Next
				If Empty(cQtdIte)
					cQtdIte  := "0" // Zerar Qtde quando não existe a mesma
				EndIf
				// Verificar se ja existe o Volume em um VM7
				VM7->(DbSetOrder(1))
				cConfer := OA3400121_ExisteConferencia( cVolume , .t. )
				If !Empty(cConfer) .and. VM7->(DbSeek(xFilial("VM7") + cConfer ))
					If VM7->VM7_STATUS == "1" // Conferencia Pendente
						OA3400211_GravaObservacaoConferencia("Reprovado automaticamente na Importação"+" "+Transform(dDataBase,"@D")+" "+left(time(),5)+" "+__CUSERID+"-"+left(Alltrim(UsrRetName(__CUSERID)),15)) // Reprovado automaticamente na Importação
						OA3400111_StatusConferencia( cConfer , "5", "0" ) // Reprovar Conferencia que estiver Pendente para recomeçar o processo de Conferencia
					ElseIf VM7->VM7_STATUS $ "2/3/4" // Conferido Parcialmente ou Conferencia Finalizada ou Conferencia Aprovada
						AADD(aItemErro,{ (cAliasSB)->(B1_COD) ,cDescP,cConfer+" CONFERENCIA JA INICIADA PARA O VOLUME "+cVolume})
					EndIf
				EndIf
				aAdd(aVolumes,{ (cAliasSB)->(B1_COD) , cNumIte , cVolume , val(cQtdIte) })
				nQtdVol += val(cQtdIte)
				If Substr(cInfProd, nTamStr+2, 1) != ";"
					cInfProd := substr(cInfProd,nTamStr+3) // String continuando ( demais Volumes )
					If Empty(cInfProd)
						Exit // Sair da TAG dos Volumes
					EndIf
				Else
					Exit
				EndIf
			Else
				Exit // Sair da TAG dos Volumes
			EndIf
		EndDo
	
		If nQuant <> nQtdVol // Se existir Diferenca entre a Quantidade TOTAL do Item com as Quantidades dos Volumes
			AADD(aItemErro,{ (cAliasSB)->(B1_COD) ,cDescP,"A SOMA DAS QUANTIDADES DOS VOLUMES DIVERGE DA QUANTIDADE TOTAL DO PRODUTO"})
		EndIf

	EndIf

	(cAliasSB)->(DBCloseArea())
endif

Return .t.

/*
================================================================================
################################################################################
##+----------+-------------+-------+-----------------------+------+----------+##
##|Função    | FS_TrataIcm | Autor | ??????????????        | Data | 29/05/15 |##
##+----------+-------------+-------+-----------------------+------+----------+##
##+ Criado para ser usado no pergunte                                        +##
##+----------+-------------+-------+-----------------------+------+----------+##
################################################################################
================================================================================
*/
Static Function FS_TrataIcm()

if XmlChildEx(oDET:_Imposto, "_ICMS" )!= Nil

	// Identifica a tag do xml
	SX5->( DbSetOrder(1) )
	SX5->( DbSeek( xFilial("SX5") + "S2" ) )

	Do While !SX5->(Eof()) .And. SX5->X5_FILIAL + SX5->X5_TABELA == xFilial("SX5") + "S2"

		nBasICM    := 0
		nPerICM    := 0
		nValICM    := 0
		nBasICMST  := 0
		nPerICMST  := 0
		nValICMST  := 0

		If XmlChildEx(oDET:_Imposto:_ICMS, "_ICMS"+Alltrim(SX5->X5_CHAVE) )!= Nil

			// ICMS
			If XmlChildEx( &("oDET:_Imposto:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)) , "_VICMS" )!= Nil
				nValICM    := Val( &("oDET:_Imposto:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)+":_VICMS:Text") )
			EndIf
			If XmlChildEx( &("oDET:_Imposto:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)) , "_PICMS" )!= Nil
				nPerICM    :=  Val( &("oDET:_Imposto:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)+":_PICMS:Text") )
			EndIf
			If XmlChildEx( &("oDET:_Imposto:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)) , "_VBC" )!= Nil
				nBasICM    := Val( &("oDET:_Imposto:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)+":_VBC:Text") )
			EndIf

			// ICMS ST
			If Alltrim(SX5->X5_CHAVE) == "10" .OR. Alltrim(SX5->X5_CHAVE) == "30" .OR.  Alltrim(SX5->X5_CHAVE)=="70"  // O conteudo 10/30 considera o ST

				If XmlChildEx( &("oDET:_Imposto:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)) , "_VICMSST" )!= Nil
					nValICMST  :=  Val( &("oDET:_Imposto:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)+":_VICMSST:Text") )
				EndIf

				If XmlChildEx( &("oDET:_Imposto:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)) , "_VBCST" )!= Nil
					nBasICMST  :=  Val( &("oDET:_Imposto:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)+":_VBCST:Text") )
				EndIf

				If XmlChildEx( &("oDET:_Imposto:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)) , "_PMVAST" )!= Nil
					nAlqSB1    := Val( &("oDET:_IMPOSTO:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)+":_PMVAST:Text"))
				EndIf

				If XmlChildEx( &("oDET:_Imposto:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)) , "_MODBCST" )!= Nil
					cModBCST   :=      &("oDET:_IMPOSTO:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)+":_MODBCST:Text")
				EndIf

				If XmlChildEx( &("oDET:_Imposto:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)) , "_PICMSST" )!= Nil
					nPerICMST   := Val(&("oDET:_IMPOSTO:_ICMS:_ICMS"+Alltrim(SX5->X5_CHAVE)+":_PICMSST:Text"))
				EndIf

			EndIf

			Exit

		EndIf

		SX5->(DbSkip())

	EndDo
Endif
return

/*
===============================================================================
###############################################################################
##+----------+------------+-------+-----------------------+------+----------+##
##|Fun‡…o    |FS_TIK      | Autor | Thiago                | Data | 03/09/15 |##
##+----------+------------+-------+-----------------------+------+----------+##
##|Descricao |Marca listbox.                                                |##
##+----------+--------------------------------------------------------------+##
###############################################################################
===============================================================================
*/
Static Function FS_TIK(lMarcar,nOpcao)
	Local ni := 0
	if nOpcao == "1"
		For ni := 1 to Len(aArquivos)
			aArquivos[ni,1] := lMarcar
		Next
	Else
		aArquivos[oLBoxArquivos:nAt,1] := !aArquivos[oLBoxArquivos:nAt,1]
	Endif
	oLBoxArquivos:Refresh()
Return(.t.)

Static Function FS_ItemErro()

oXmlDetHlp := Mil_XmlHelper():New(oDet)

cProduto   := oXmlDetHlp:GetValue('_PROD:_CPROD:Text')
cDescP     := oXmlDetHlp:GetValue('_PROD:_XPROD:Text')

nPosPedido := aScan(aVetPed,{|x| x[2]+x[8] == Padr(cProduto,len(SC7->C7_PRODUTO))+"usado"})
if nPosPedido > 0
	cNPedido := aVetPed[nPosPedido,4]
	dbSelectArea("SC7")
	dbSetOrder(4)
	if !dbSeek(xFilial("SC7")+Padr(cProduto,len(SC7->C7_PRODUTO))+cNPedido)
		aAdd( aItemErro, {cProduto,cDescP,"PRODUTO SEM PEDIDO"} )
	Endif
Endif

Return(.t.)