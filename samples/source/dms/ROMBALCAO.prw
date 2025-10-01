// �����������������ͻ
// � Versao � 003    �
// �����������������ͼ

#Include "PROTHEUS.Ch"
#INCLUDE "REPORT.CH"
#INCLUDE "ROMBALCAO.CH"

Static Function mil_ver()
	If .F.
		mil_ver()
	EndIf
Return "006428_003"

/*
===============================================================================
###############################################################################
##+----------+------------+-------+-----------------------+------+----------+##
##|Fun��o    | ROMBALCAO  | Autor | Renato Vinicius       | Data | 29/05/17 |##
##+----------+------------+-------+-----------------------+------+----------+##
##|Descri��o | Impress�o do Romaneio de Saida de pe�as balc�o               |##
##+----------+--------------------------------------------------------------+##
##|Uso       |                                                              |##
##+----------+--------------------------------------------------------------+##
###############################################################################
===============================================================================
*/

User Function ROMBALCAO()

Local oReport
Private lNaoAuto := Type("ParamIXB")=="U"

Private cSerie   := IIf( lNaoAuto , "" , ParamIXB[1]) //Serie
Private cNumNota := IIf( lNaoAuto , "" , ParamIXB[2]) //Nota

	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()

Return


Static Function ReportDef()

Local cAliasQry := GetNextAlias()

Local oReport	  := Nil
Local oSection1	:= Nil
Local oSection2	:= Nil

Local cPerg     := "ROMBAL"
Local lSBZ    := ( SuperGetMV("MV_ARQPROD",.F.,"SB1") == "SBZ" )


//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������

If lNaoAuto
	
	// AADD(aRegs,{"Nota Fiscal", "Nota Fiscal", "Nota Fiscal", "mv_ch1", "C", TamSx3("F2_DOC")[1]   , 0, 0, "G", '' , "mv_par01", "", "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SF2VEI" , "" , "" , "" , {"Informe o n�mero da nota fiscal"},{},{}})
	// AADD(aRegs,{"S�rie"      , "S�rie"      , "S�rie"      , "mv_ch2", "C", TamSx3("F2_SERIE")[1] , 0, 0, "G", '' , "mv_par02", "", "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , {"Informe a s�rie da nota fiscal"},{},{}})
	
	Pergunte(cPerg,.f.)
	cNumNota := mv_par01
	cSerie   := mv_par02
EndIf

oReport := TReport():New("ROMBALCAO",;
	STR0001,; // Romaneio de Sa�da de Pe�as
	IIf( lNaoAuto , cPerg , ),;
	{|oReport| ReportPrint(oReport,cAliasQry)},;
	STR0002) // Este relat�rio ir� imprimir as pe�as que foram vendidas
	
oReport:nFontBody := 8
oReport:SetPortrait() // Define orienta��o de p�gina do relat�rio como retrato.
oReport:SetTotalInLine(.F.) //Define se os totalizadores ser�o impressos em linha ou coluna.

If lNaoAuto
	Pergunte(oReport:uParam,.F.)
EndIf

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oSection1 := TRSection():New(oReport,STR0001,{"SF2","SA1","SA3"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Romaneio de Sa�da de Pe�as"
oReport:Section(1):SetLineStyle() //Define se imprime as c�lulas da se��o em linhas.
oReport:Section(1):SetCols(3) //Define a quantidade de colunas a serem impressas.

TRCell():New(oSection1,"cNUMORC"	,         ,STR0003                  ,                                                       ,120                                              ,/*lPixel*/,/*{|| FS_LEVORC()  }*/,,,,.t.)	// Or�amento(s)
TRCell():New(oSection1,"cNFSER"	    ,         ,IIF(cPaisloc="BRA",STR0004,STR0013)                  ,PesqPict("SD2","D2_DOC")+PesqPict("SD2","D2_SERIE")    ,(TamSx3("D2_DOC")[1]+TamSx3("D2_SERIE")[1])+1    ,/*lPixel*/,{|| (cAliasQry)->D2_DOC+"/"+(cAliasQry)->D2_SERIE  },,,,.t.)    // Nro Nota/ Serie
TRCell():New(oSection1,"cCLILOJ"    ,         ,STR0005                  ,PesqPict("SD2","D2_CLIENTE")+PesqPict("SD2","D2_LOJA") ,(TamSx3("D2_CLIENTE")[1]+TamSx3("D2_LOJA")[1])+1 ,/*lPixel*/,{|| (cAliasQry)->D2_CLIENTE+"/"+(cAliasQry)->D2_LOJA},,,,)      //Cliente / Loja
TRCell():New(oSection1,"A1_NOME"	,"SA1"    ,RetTitle("A1_NOME")      ,PesqPict("SA1","A1_NOME")                              ,TamSx3("A1_NOME")[1]                             ,/*lPixel*/,{|| SA1->A1_NOME  },,,,)
TRCell():New(oSection1,"A3_NOME"	,"SA3"    ,STR0006                  ,PesqPict("SA3","A3_NOME")                              ,TamSx3("A3_NOME")[1]                             ,/*lPixel*/,{|| SA3->A3_NOME  },,,,)	//Vendedor

oSection2 := TRSection():New(oSection1,STR0007,{"SD2","SB1"}) //Itens

TRCell():New(oSection2,"D2_ITEM"	,"SD2"		,RetTitle("D2_ITEM")	,PesqPict("SD2","D2_ITEM")		,TamSx3("D2_ITEM")[1]	,/*lPixel*/,{|| (cAliasQry)->D2_ITEM  },,,,)  	 	//Sequencial
TRCell():New(oSection2,"B1_GRUPO"	,"SB1"		,RetTitle("B1_GRUPO")	,PesqPict("SB1","B1_GRUPO")		,TamSx3("B1_GRUPO")[1]	,/*lPixel*/,{|| SB1->B1_GRUPO  },,,,)           	//Grupo do Item
TRCell():New(oSection2,"B1_CODITE"	,"SB1"		,RetTitle("B1_CODITE")	,PesqPict("SB1","B1_CODITE")	,TamSx3("B1_CODITE")[1]	,/*lPixel*/,{|| SB1->B1_CODITE  },,,,)          	// C�digo do Item
TRCell():New(oSection2,"B1_DESC"	,"SB1"		,RetTitle("B1_DESC")	,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]	,/*lPixel*/,{|| SB1->B1_DESC  },,,,)            	//Descri��o do Item
If cPaisloc == 'BRA'
	TRCell():New(oSection2,"CLOCALIZA"	,/*Tabela*/	,STR0008	            ,PesqPict("SB5","B5_LOCALI2")	,TamSx3("B5_LOCALI2")[1],/*lPixel*/,{|| (cAliasQry)->D2_LOCALIZ },,,,) 		// Localiza��o
	TRCell():New(oSection2,"CLOTE"	    ,/*Tabela*/	,STR0009	            ,PesqPict("SD2","D2_LOTECTL")	,TamSx3("D2_LOTECTL")[1],/*lPixel*/,{|| (cAliasQry)->D2_LOTECTL },,,,)  	// Lote
	TRCell():New(oSection2,"CSUBLOTE"	,/*Tabela*/	,STR0010				,PesqPict("SD2","D2_NUMLOTE")	,TamSx3("D2_NUMLOTE")[1],/*lPixel*/,{|| (cAliasQry)->D2_NUMLOTE },,,,)  	// SubLote
Else
	If lSBZ
		TRCell():New(oSection2,"CLOCALIZA"	,/*Tabela*/	,STR0008	            ,PesqPict("SBZ","BZ_LOCALI2")	,TamSx3("BZ_LOCALI2")[1],/*lPixel*/,{|| (cAliasQry)->BZ_LOCALI2 },,,,) 		// Localiza��o
	Else
		TRCell():New(oSection2,"CLOCALIZA"	,/*Tabela*/	,STR0008	            ,PesqPict("SB5","B5_LOCALI2")	,TamSx3("B5_LOCALI2")[1],/*lPixel*/,{|| (cAliasQry)->B5_LOCALI2 },,,,) 		// Localiza��o
	Endif
Endif
TRCell():New(oSection2,"NQUANTITE1"	,/*Tabela*/	,STR0011 				,PesqPict("SD2","D2_QUANT")		,TamSx3("D2_QUANT") [1]	,/*lPixel*/,{|| (cAliasQry)->D2_QUANT },,,"RIGHT",) // "Qtde"

Return(oReport)


Static Function ReportPrint(oReport,cAliasQry)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SF2")		// Cabecalho da Nota Fiscal de Saida
dbSetOrder(1)			// Doc,Serie,Cliente,Loja
//������������������������������������������������������������������������Ŀ
//�Query do relat�rio da secao 1                                           �
//��������������������������������������������������������������������������
If lNaoAuto
	cNumNota := mv_par01
	cSerie   := mv_par02
EndIf

lQuery := .T.

oSection1:BeginQuery()

BeginSql Alias cAliasQry
	SELECT D2_ITEM,D2_FILIAL,D2_DOC,D2_CLIENTE,D2_LOJA,D2_SERIE, F2_VEND1, D2_QUANT, D2_COD, D2_LOCALIZ, D2_LOTECTL, D2_NUMLOTE, BZ_LOCALI2 ,B5_LOCALI2
	FROM %Table:SD2% SD2
		INNER JOIN
			%Table:SF2% SF2 
		ON 
			SF2.F2_FILIAL = %xfilial:SF2% AND SD2.D2_DOC = SF2.F2_DOC AND 
			SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CLIENTE = SF2.F2_CLIENTE	AND 
			SD2.D2_LOJA = SF2.F2_LOJA AND SF2.%NotDel%
		
		LEFT JOIN
			%Table:SB5% SB5 
		ON 
			SB5.B5_FILIAL = %xfilial:SB5% AND SB5.%NotDel%
			AND SB5.B5_COD = SD2.D2_COD
		
		LEFT JOIN
			%Table:SBZ% SBZ 
		ON 
			SBZ.BZ_FILIAL = %xfilial:SBZ% AND SBZ.%NotDel%
			AND SBZ.BZ_COD = SD2.D2_COD

	WHERE D2_FILIAL = %xFilial:SD2% AND 
		D2_DOC = %Exp:cNumNota% AND D2_SERIE = %Exp:cSerie% AND
		SD2.%NotDel%
	ORDER BY D2_ITEM,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA
EndSql 
oSection1:EndQuery(/*Array com os parametros do tipo Range*/)


//������������������������������������������������������������������������Ŀ
//�Metodo TrPosition()                                                     �
//�                                                                        �
//�Posiciona em um registro de uma outra tabela. O posicionamento ser�     �
//�realizado antes da impressao de cada linha do relat�rio.                �
//�                                                                        �
//�                                                                        �
//�ExpO1 : Objeto Report da Secao                                          �
//�ExpC2 : Alias da Tabela                                                 �
//�ExpX3 : Ordem ou NickName de pesquisa                                   �
//�ExpX4 : String ou Bloco de c�digo para pesquisa. A string ser� macroexe-�
//�        cutada.                                                         �
//�                                                                        �
//��������������������������������������������������������������������������
TRPosition():New(oReport:Section(1),"SA1",1,{|| xFilial("SA1")+(cAliasQry)->D2_CLIENTE+(cAliasQry)->D2_LOJA})
TRPosition():New(oReport:Section(1),"SA3",1,{|| xFilial("SA3")+(cAliasQry)->F2_VEND1})
TRPosition():New(oReport:Section(1):Section(1),"SB1",1,{|| xFilial("SB1")+(cAliasQry)->D2_COD})

oSection1:Cell("cNUMORC"):SetBlock({ || FS_LEVORC(cNumNota,cSerie)}) //Insere o conteudo no espa�o destinado ao n�mero do or�amento

oSection2:SetParentQuery() // Define que a se��o filha utiliza a query da se��o pai na impress�o da se��o.
oSection1:Print()

Return

Static Function FS_LEVORC(cNumNota,cSerie)

cQuery :="SELECT VS1_NUMORC "
cQuery +="FROM " + RetSqlName("VS1") + " VS1 "
cQuery +=" WHERE VS1.VS1_FILIAL = '" + xFilial("VS1") +"' "
cQuery +="   AND VS1.VS1_NUMNFI = '" + cNumNota + "' "
cQuery +="   AND VS1.VS1_SERNFI = '" + cSerie + "' "
cQuery +="   AND VS1.D_E_L_E_T_ = ' '"

oLevOrc := DMS_SqlHelper():New()
aOrc := oLevOrc:GetSelectArray(cQuery,1)
oOrcmto := DMS_ArrayHelper():New()
cOrc := oOrcmto:JOIN(aOrc,"/")

If Empty(cOrc)
	cOrc := STR0012 // Nota fiscal sem or�amento relacionado
EndIf

Return cOrc