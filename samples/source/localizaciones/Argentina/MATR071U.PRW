#include "Protheus.ch"        
#include "MATR071U.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATR071  ³ Autor ³ Carlos E. Chigres         ³ Data ³ 11/07/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Entidades Bancarias                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ DATA   ³ Programador³   Manutencao efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Marco A.³16/04/18³ DMINA-2310 ³Se remueven sentencias CriaTrab y se apli-³±±
±±³          ³        ³            ³ca FWTemporaryTable(), para el manejo de  ³±±
±±³          ³        ³            ³las tablas temporales.                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MATR071U()

	Local oReport	:= Nil
	
	Private oTmpTable := Nil
	
	If FindFunction("TRepInUse") .And. TRepInUse()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Interface de impressao  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oReport	:= ReportDef()
		oReport:PrintDialog()
	EndIf
	
	If oTmpTable <> Nil
		oTmpTable:Delete()
		oTmpTable := Nil
	Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Paulo Augusto          ³ Data ³28/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport,oSection1
Local cReport := "MATR071"
Local cTitulo := STR0010     // "Listagem de Entidades Bancarias"
Local cDescri := STR0011     // "Este relatório apresenta uma relação das Entidades Bancarias cadastradas." 

//--- Tamanho de Celulas
Local nTamBanco   := TamSx3("FJN_COD")[1] + 1
Local nTamAgenci  := TamSx3("FJN_AGENCI")[1] + 1
Local nTamDigit   := 3
Local nTamNome    := TamSx3("FJN_NOMAGE")[1]
Local nTamPostal  := Iif(cPaisLoc == "ARG",TamSx3("FJN_POSTAL")[1],'')
Local nTamEnder   := TamSx3("FJN_END")[1]
Local nTamMunicip := TamSx3("FJN_MUN")[1]
Local nTamProvinc := 4

Pergunte( "MATR71" , .F. )
                   
oReport := TReport():New( cReport, cTitulo, "MATR71" , { |oReport| ReportPrint( oReport, "TRB" ) }, cDescri )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a 1a. secao do relatorio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New( oReport,STR0002, {"TRB","FJN","FJO"},,/*Campos do SX3*/,/*Campos do SIX*/)    
oSection1:SetTotalInLine(.T.)                                                                                                                                                                                                                                                       
oReport:SetTotalInLine(.F.)                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                   
TRCell():New( oSection1, "FJN_COD"   	,"FJN"  , /*X3Titulo()*/  , /*Picture*/ , nTamBanco , /*lPixel*/ ,  {|| TRB->BANCO } ) 
TRCell():New( oSection1, "FJN_AGENCI" 	,"FJN"  , /*X3Titulo()*/  , /*Picture*/ , nTamAgenci , /*lPixel*/ , {|| TRB->AGENCI } ) 
TRCell():New( oSection1, "FJN_DVAGE"	,"FJN"	, /*X3Titulo()*/  , /*Picture*/ , nTamDigit  , /*lPixel*/ , {|| TRB->DIGITO } )	  
TRCell():New( oSection1, "FJN_NOMAGE" 	,"FJN"	, /*X3Titulo()*/  , /*Picture*/ , nTamNome   , /*lPixel*/ , {|| TRB->NOMEAG } )	
If cPaisLoc == "ARG"
	TRCell():New( oSection1, "FJN_POSTAL"  	,"FJN"	, /*X3Titulo()*/  , /*Picture*/ , nTamPostal , /*lPixel*/ , {|| TRB->POSTAL } )	              
EndIf
TRCell():New( oSection1, "FJN_END"	    ,"FJN" 	, /*X3Titulo()*/  , /*Picture*/ , nTamEnder  , /*lPixel*/ , {|| TRB->ENDER  } )                                            
TRCell():New( oSection1, "FJN_MUN"  	,"FJN" 	, /*X3Titulo()*/  , /*Picture*/ , nTamMunicip , /*lPixel*/ , {|| TRB->MUNICI } ) 
TRCell():New( oSection1, "FJN_PROV" 	,"FJN" 	, /*X3Titulo()*/  , /*Picture*/ , nTamProvinc , /*lPixel*/ , {|| TRB->PROVIN } ) 
TRCell():New( oSection1, "Qtd"  		,"   " 	,                 ,"@E 99.999"  , 5           , /*lPixel*/ , {|| 1 } )    

oSection1:SetNoFilter( {'FJN'} ) 

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintºAutor  ³Paulo Augusto       º Data ³  27/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Query de impressao do relatorio                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport )

	Local oSection1	:= oReport:Section(1)
	Local oBreak1	:= Nil
	Local nOrder	:= oReport:Section(1):GetOrder()
	Local cDesFor	:= " "
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aCampos	:= {}
	Local aOrdem	:= {}
	
	Private cBancoDe  := mv_par01
	Private cBancoAte := mv_par02
	
	AADD( aCampos,{"AGENCI"  ,"C",TamSX3('FJN_AGENCI')[1],0 } )
	AADD( aCampos,{"DIGITO"  ,"C",TamSX3('FJN_DVAGE')[1] ,0 } )
	AADD( aCampos,{"NOMEAG"  ,"C",TamSX3('FJN_NOMAGE')[1],0 } )
	If cPaisLoc == "ARG"
		AADD( aCampos,{"POSTAL"  ,"C",TamSX3('FJN_POSTAL')[1],0 } )
	EndIf
	AADD( aCampos,{"ENDER"   ,"C",TamSX3('FJN_END')[1]   ,0 } )
	AADD( aCampos,{"MUNICI"  ,"C",TamSX3('FJN_MUN')[1]   ,0 } )
	AADD( aCampos,{"PROVIN"  ,"C",TamSX3('FJN_PROV')[1]  ,0 } )
	AADD( aCampos,{"BANCO"   ,"C",TamSX3('FJO_COD')[1]   ,0 } )
	AADD( aCampos,{"NOMBANK" ,"C",TamSX3('FJO_NOME')[1]  ,0 } )

	aOrdem := {"BANCO", "AGENCI"}
	
	//Creacion de Objeto
	oTmpTable := FWTemporaryTable():New("TRB")
	oTmpTable:SetFields( aCampos )
	oTmpTable:AddIndex("I1", aOrdem)

	//Creacion de la tabla
	oTmpTable:Create()

	Processa( {|lEnd| GrvFJN() },,OemToAnsi(STR0013) ) // "Preparando Temporario..."
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia rotina de impressao                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRB")
	dbGoTop()
	
	cDesFor := TRB->BANCO + " - " + TRB->NOMBANK
	
	oSection1:Cell("Qtd"):Hide()
	
	oSection1:SetOrder(1)
	oSection1:SetLineCondition( {|| .T. } )
	
	oBreak1 := TRBreak():New( oSection1, oSection1:Cell("BANCO"),,.F.)  
	
	oBreak1:SetTitle({|| STR0014 + cDesFor }) // "Resumo pelo Banco : "
	
	oBreak1:OnPrintTotal({|| cDesFor := TRB->BANCO + " - " + TRB->NOMBANK } )
	
	TRFunction():New(oSection1:Cell("Qtd"  )  , , "COUNT" , oBreak1, , , , .F. ,  )
	
	oSection1:NoUserFilter()
	
	oSection1:Print()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GrvSldClie³ Autor ³ Lucas                ³ Data ³ 05/02/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grabar uno archivo transit¢rio (TRB) con los salods de los ³±±
±±³          ³ Clientes. Baseado en las leyes y denificiones de Localiza- ³±±
±±³          ³ ciones de los paises del ConeSul y Andinos.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GrvSldClie(ExpC1,ExpC2,ExpN1,ExpL1,ExpC3)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := C¢digo Inicial del Cliente                        ³±±
±±³          ³ ExpC2 := C¢digo Final del Cliente                          ³±±
±±³          ³ ExpN1 := Selecci¢n del Tipo de T¡tulos                     ³±±
±±³          ³ ExpL1 := Identifica lo Cierre por Vendedor o Cliente		  ³±±
±±³          ³ ExpL2 := Imprimir con Historico o No (Saldo > 0)    		  ³±±
±±³          ³ ExpC3 := Nombre do Relat¢rio. Ejemplo: "FINR152"           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Localizacoes ConeSul y Andinos                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GrvFJN()

dbSelectArea("FJN")
dbSetOrder( 1 )

ProcRegua( FJN->( RecCount() ) )

If Empty( cBancoDe )
   dbGoTop()
Else
   dbSeek( xFilial("FJN")+cBancoDe , .T. )
EndIf

While !Eof() .And. ( FJN_FILIAL == xFilial("FJN") )

    dbSelectArea("TRB")

    RecLock("TRB",.T.)

    TRB->AGENCI  :=  FJN->FJN_AGENCI
    TRB->DIGITO  :=  FJN->FJN_DVAGE
    TRB->NOMEAG  :=  FJN->FJN_NOMAGE
    If cPaisLoc == "ARG"
    	TRB->POSTAL  :=  FJN->FJN_POSTAL
    EndIf
    TRB->ENDER   :=  FJN->FJN_END
    TRB->MUNICI  :=  FJN->FJN_MUN
    TRB->PROVIN  :=  FJN->FJN_PROV
    TRB->BANCO   :=  FJN->FJN_COD
    TRB->NOMBANK :=  Posicione( "FJO", 1, xFilial("FJO") + FJN->FJN_COD, "FJO_NOME" )
    
    MsUnLock()

    dbSelectArea("FJN")
    dbSkip()
    
    If FJN_COD > cBancoAte
       Exit
    EndIf
    
Enddo

Return
