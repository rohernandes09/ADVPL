#Include "PROTHEUS.CH"
#Include "FWCOMMAND.CH"

/*/{Protheus.doc} ReportDef

Impressao das PECAS solicitadas para a OS - Ordem de Busca para Conferencia

@author Andre Luis Almeida
@since 07/11/2019
@type function

/*/
User Function IMPOSOC()
Local cCodVM3 := ParamIXB[01] // Codigo do VM3
Local oReport

DbSelectArea("VM3")
DbSetOrder(1)
If DbSeek( xFilial("VM3") + cCodVM3 )
	oReport := ReportDef() // Nesta função nós definimos a estrutura do relatório, por exemplo as seções, campos, totalizadores e etc.
	oReport:PrintDialog()  // Essa função serve para disparar a impressão do TReport, ela que faz com que seja exibida a tela de configuração de impressora e os botões de parâmetros.
EndIf

Return

/*/{Protheus.doc} ReportDef

Função para criar as celulas que serão impressas

@author Andre Luis Almeida
@since 07/11/2019
@type function

/*/
Static Function ReportDef()

Local cTit_Imp := ""

If VM3->VM3_STATUS == "1" .or. VM3->VM3_STATUS == "2" // Conferencia Pendente OU Conferencia Parcial
	cTit_Imp := "Ordem de Busca para Conferencia"
Else
	cTit_Imp := "Itens Conferidos"
EndIf

oReport := TReport():New("IMPOSOC",;	// Nome do Relatório
	"Impressão Conferencia Oficina",;	// Impressão Conferencia Oficina
	"",;								// Nome da Pergunta
	{|oReport| ReportPrint(oReport)},;	// Bloco de código que será executado na confirmação
	cTit_Imp )							// Impressão dos Itens
	
oReport:SetTotalInLine(.F.) //Define se os totalizadores serão impressos em linha ou coluna.

oSection1 := TRSection():New(oReport,cTit_Imp,{"VM3"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// Cabeça
oSection1:SetAutoSize(.t.)
TRCell():New(oSection1, "FILIAL" , "", RetTitle("VM3_FILIAL") , "@!"     , 30,, {|| VM3->VM3_FILIAL } ,,, "LEFT" , .t.) // Filial
TRCell():New(oSection1, "NUMOSV" , "", RetTitle("VM3_NUMOSV") , "@!"     , 30,, {|| VM3->VM3_NUMOSV } ,,, "LEFT" , .t.) // Nro.OS
TRCell():New(oSection1, "CODIGO" , "", RetTitle("VM3_CODIGO") , "@!"     , 30,, {|| VM3->VM3_CODIGO } ,,, "LEFT" , .t.) // Cod.Conferencia
TRCell():New(oSection1, "dData"  , "", RetTitle("VO2_DATREQ") ,	"@!"     , 20,,                       ,,, "LEFT" , .t.,,.t.) // Data
TRCell():New(oSection1, "cHora"  , "", RetTitle("VO2_HORREQ") ,	"@!"     , 20,,                       ,,, "LEFT" , .t.,,.t.) // Hora

oSection2 := TRSection():New(oReport,"Itens",{"SB1","VM4"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// Itens
oSection2:SetAutoSize(.t.)
TRCell():New(oSection2, "GRUPO"  , "", RetTitle("B1_GRUPO")   , "@!"     , 20,, {|| SB1->B1_GRUPO   } ,,, "LEFT" , .t.) // Grupo
TRCell():New(oSection2, "CODITE" , "", RetTitle("B1_CODITE")  , "@!"     , 30,, {|| SB1->B1_CODITE  } ,,, "LEFT" , .t.) // Codigo Item
TRCell():New(oSection2, "DESC"   , "", RetTitle("B1_DESC")    , "@!"     , 40,, {|| SB1->B1_DESC    } ,,, "LEFT" , .t.) // Descricao
TRCell():New(oSection2, "cEnder" , "", RetTitle("B5_LOCALI2") ,	"@!"     , 30,,                       ,,, "LEFT" , .t.,,.t.) // Endereco
If VM3->VM3_STATUS == "1" .or. VM3->VM3_STATUS == "2" // Conferencia Pendente OU Conferencia Parcial
	TRCell():New(oSection2, "QTSOLI" , "", RetTitle("VM4_QTSOLI") , "@E 9999", 20,, {|| VM4->VM4_QTSOLI } ,,, "RIGHT", .t.) // Qtde.Solicitada
Else
	TRCell():New(oSection2, "QTCONF" , "", RetTitle("VM4_QTCONF") , "@E 9999", 20,, {|| VM4->VM4_QTCONF } ,,, "RIGHT", .t.) // Qtde.Conferida
EndIf

oSection3 := TRSection():New(oReport,"Produtivo Solicitante",/*{}*/,/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// Produtivo Solicitante
oSection3:SetAutoSize(.t.)
TRCell():New(oSection3, "cNome"  , "", RetTitle("VO3_PROREQ") ,	"@!"     , 50,,                       ,,, "LEFT" , .t.,,.t.) // Produtivo
TRCell():New(oSection3, "dData"  , "", RetTitle("VO2_DATREQ") ,	"@D"     , 20,,                       ,,, "LEFT" , .t.,,.t.) // Data
TRCell():New(oSection3, "cHora"  , "", RetTitle("VO2_HORREQ") ,	"@!"     , 20,,                       ,,, "LEFT" , .t.,,.t.) // Hora

Return oReport

/*/{Protheus.doc} ReportPrint

Função para adicionar as informações que serão impressas

@author Andre Luis Almeida
@since 07/11/2019
@type function

/*/
Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)
Local dDtImp    := ctod("")
Local cHrImp    := space(5)
Local cQuery    := ""

If VM3->VM3_STATUS == "1" .or. VM3->VM3_STATUS == "2" // Conferencia Pendente OU Conferencia Parcial
	dDtImp    := dDataBase
	cHrImp    := left(Time(),5)
Else //  VM3->VM3_STATUS $ '345' // Finalizado / Aprovado / Reprovado -> Pegar a Data/Hora da ultima Conferencia
	cQuery := "SELECT MAX(VM4_DATFIN)"
	cQuery += "  FROM " + RetSqlName("VM4")
	cQuery += " WHERE VM4_FILIAL = '"+VM3->VM3_FILIAL+"' "
	cQuery += "   AND VM4_CODVM3 = '"+VM3->VM3_CODIGO+"' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	dDtImp := stod(FM_SQL(cQuery))
	cQuery := "SELECT MAX(VM4_HORFIN)"
	cQuery += "  FROM " + RetSqlName("VM4")
	cQuery += " WHERE VM4_FILIAL = '"+VM3->VM3_FILIAL+"' "
	cQuery += "   AND VM4_CODVM3 = '"+VM3->VM3_CODIGO+"' "
	cQuery += "   AND VM4_DATFIN = '"+dtos(dDtImp)+"'"
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	cHrImp := FM_SQL(cQuery)
EndIf

SB1->(DbSetOrder(1))
SB5->(DbSetOrder(1))
VAI->(DbSetOrder(1))
VAI->(DbSeek(xFilial("VAI")+VM3->VM3_PROSOL)) // CODIGO TECNICO - MESMO A SER UTILIZADO NO VO3_PROREQ

oSection1:Init()
oSection1:Cell("dData"):SetValue( dDtImp ) //Insere o conteudo no espaço destinado
oSection1:Cell("cHora"):SetValue( cHrImp ) //Insere o conteudo no espaço destinado
oSection1:PrintLine()
oSection1:Finish()

oSection2:Init()
DbSelectArea("VM4")
DbSetOrder(1)
DbSeek( xFilial("VM4") + VM3->VM3_CODIGO )
Do While !Eof() .and. xFilial("VM4")==VM4->VM4_FILIAL .and. VM4->VM4_CODVM3 == VM3->VM3_CODIGO
	SB1->(DbSeek(xFilial("SB1")+VM4->VM4_COD))
	SB5->(DbSeek(xFilial("SB5")+VM4->VM4_COD))
	oSection2:Cell("cEnder"):SetValue( FM_PRODSBZ(SB1->B1_COD,"SB5->B5_LOCALI2") ) //Insere o conteudo no espaço destinado
	oSection2:PrintLine()
	DbSelectArea("VM4")
	DbSkip()
EndDo
oSection2:Finish()

oSection3:Init()
oSection3:Cell("cNome"):SetValue( VM3->VM3_PROSOL+" - "+VAI->VAI_NOMTEC ) //Insere o conteudo no espaço destinado
oSection3:Cell("dData"):SetValue( dDtImp ) //Insere o conteudo no espaço destinado
oSection3:Cell("cHora"):SetValue( cHrImp ) //Insere o conteudo no espaço destinado
oSection3:PrintLine()
oSection3:Finish()

Return