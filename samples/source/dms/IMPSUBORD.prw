#INCLUDE "IMPSUBORD.CH"

// ÉÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍ»
// º Versao º 03     º
// ÈÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍ¼
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPSUBORD ºAutor  ³Fabio               º Data ³  12/28/99   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao da subordem de servico                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMPSUBORD()

Local nImp := 0 , nAgrupN := 0 , nix := 1 , i := 0 , nTotal := 0 , nLin   := 0 , nContMec := 0 , nLinTxt := 0
Local aString := {} 
local y:= 0
Local cSPF , nPos := 0 , nLBarra := 0, nCBarra := 0

Private aReturn  := { OemToAnsi(STR0001), 1,OemToAnsi(STR0002), 2, 2, 2,,1 } //"Requisitar"###"Alterar"
Private titulo,cabec1,cabec2,nLastKey:=0,wnrel,oPrinter,oFont
Private cAlias , cNomRel , cPerg , cTitulo , cDesc1 , cDesc2 , cDesc3 , lHabil := .f.
Private oPr
Private cTamanho  := "P"          // P/M/G
Private cAliasVO4   := "SQLVO4"
Private cVO4        := "SQLVO4"
Private Limite    := 80           // 80/132/220
Private nCaracter := 15
cNomRel := "SUBORDEM"                
lAchou := .f.                  

if FM_PILHA("OFIXX001")
	For y := 1 to Len(oGetServ:aCols)
		cQuery := "SELECT VO4.VO4_NUMOSV,VO4.VO4_NOSNUM,VO4.VO4_CODSEC,VO4.VO4_TIPSER,VO4.VO4_SEQUEN,VO4.VO4_GRUSER,VO4.VO4_TEMPAD,VO4.VO4_CODSER "
		cQuery += "FROM "
		cQuery += RetSqlName( "VO4" ) + " VO4 "
		cQuery += "WHERE "
		cQuery += "VO4.VO4_FILIAL='"+ xFilial("VO4")+ "' AND VO4.VO4_NUMOSV = '"+VO1->VO1_NUMOSV+"' AND VO4.VO4_GRUSER = '"+oGetServ:aCols[y,FG_POSVAR("VS4_GRUSER","aHeaderS")]+"' AND "+" VO4.VO4_CODSER = '"+oGetServ:aCols[y,FG_POSVAR("VS4_CODSER","aHeaderS")]+"' AND  VO4.VO4_TIPSER = '"+oGetServ:aCols[y,FG_POSVAR("VS4_TIPSER","aHeaderS")]+"' AND "
		cQuery += "VO4.D_E_L_E_T_=' '"
	
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cVO4, .T., .T. )
		DbSelectArea("VOK")
		DbSetOrder(1)
		DbSeek(xFilial("VOK")+( cVO4 )->VO4_TIPSER)
		if VOK->VOK_INCMOB == "2"
	      (cVO4)->(dbCloseArea())
		   Loop
		Endif   
	   lAchou := .t.
	   (cVO4)->(dbCloseArea())
	Next

	if lAchou == .f.
	   Return(.t.)
	Endif
	   
	if MsgYesNo(STR0004) //"Deseja imprimir sub-ordem de serviço"
		cAlias := "VO4"
		NomeRel:= "SUBORDEM"
		cPerg  := nil
		cTitulo:= STR0005 //"Requisicao de Servicos"
		cDesc1 := STR0006 //"Sub Ordem"
		cDesc2 := cDesc3 := ""
		//aOrdem := {"Nosso Numero","Codigo do Item"}
		lHabil := .f.
		                 
		NomeRel := SetPrint(cAlias,NomeRel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,lHabil,,,cTamanho)
		
		//NomeRel := GETMV("MV_SUBORDE")
		
		If nlastkey == 27
			Return(Allwaystrue())
		EndIf
		
		SetDefault(aReturn,cAlias)
		
		Set Printer to &NomeRel
		Set Printer On
		Set device to Printer
		
		/*
		cbTxt    := Space(10)
		cbCont   := 0
		cString  := "VO3"
		Li       := 80
		m_Pag    := 1
		
		wnRel    := "OFIOM030"
		
		cTitulo:= "Sub Ordem"
		cabec1 := "OS.: "+M->VO2_NUMOSV+Space(1)+"Nro Req.:"+M->VO2_NOSNUM+Space(1)+"Func: "+M->VO2_FUNREQ+"-"+Subs(M->VO2_NOMREQ,1,22)+Space(1)+"Box: "+VO1->VO1_NUMBOX
		cabec2 := "Cliente: "+M->VO2_PROVEI+"-"+Subs(M->VO2_NOMPRO,1,16)+Space(1)+"Chassi: "+M->VO2_CHASSI+Space(1)+"Frota:"+M->VO2_CODFRO
		//cabec2 := "--- -- ---- --------------------------- ---------------------------- ----- ------- --------- -------------- -------------- ------"
		nomeprog:="OFIOM030"
		tamanho:="P"
		nCaracter:=15
		*/
		
		nTotal := 0
		nLin   := 0
		
		//SetRegua( Len( aAgrupSer ) )
		
	//	Asort(aAgrupSer,,,{|x,y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3] } )
		
		cCodSrv := VO4->VO4_CODSER
		
	//	For nAgrupN := 1 to 2
			
	    	For y := 1 to Len(oGetServ:aCols)
				cQuery := "SELECT VO4.VO4_NUMOSV,VO4.VO4_NOSNUM,VO4.VO4_CODSEC,VO4.VO4_TIPSER,VO4.VO4_SEQUEN,VO4.VO4_GRUSER,VO4.VO4_TEMPAD,VO4.VO4_CODSER "
				cQuery += "FROM "
				cQuery += RetSqlName( "VO4" ) + " VO4 "
				cQuery += "WHERE "
				cQuery += "VO4.VO4_FILIAL='"+ xFilial("VO4")+ "' AND VO4.VO4_NUMOSV = '"+VO1->VO1_NUMOSV+"' AND VO4.VO4_GRUSER = '"+oGetServ:aCols[y,FG_POSVAR("VS4_GRUSER","aHeaderS")]+"' AND "+" VO4.VO4_CODSER = '"+oGetServ:aCols[y,FG_POSVAR("VS4_CODSER","aHeaderS")]+"' AND  VO4.VO4_TIPSER = '"+oGetServ:aCols[y,FG_POSVAR("VS4_TIPSER","aHeaderS")]+"' AND "
				cQuery += "VO4.D_E_L_E_T_=' '"
			
				dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVO4, .T., .T. )
	
				If nLin > 66 .Or. i # 0
					nLin := 0
				Else
					If nLin > 33
						nLin := 0
					ElseIf nLin # 0
						nLin := 34
					EndIf
				EndIf
					
				DbSelectArea("VO2")
	 			DbSetOrder(2)
				DbSeek(xFilial("VO2")+( cAliasVO4 )->VO4_NOSNUM)
				DbSelectArea("VAI")
				DbSetOrder(1)
				DbSeek(xFilial("VAI")+VO2->VO2_FUNREQ)
				DbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial("SA1")+VO1->VO1_PROVEI+VO1->VO1_LOJPRO)
				DbSelectArea("VV1")
				DbSetOrder(1)
				DbSeek(xFilial("VV1")+VO1->VO1_CHAINT)
				DbSelectArea("VO6")
				DbSetOrder(2)
				DbSeek(xFilial("VO6")+VV1->VV1_CODMAR+( cAliasVO4 )->VO4_CODSER)
				DbSelectArea("VOD")
				DbSetOrder(1)
				DbSeek(xFilial("VOD")+( cAliasVO4 )->VO4_CODSEC)
	   			DbSelectArea("VOK")
				DbSetOrder(1)
				DbSeek(xFilial("VOK")+( cAliasVO4 )->VO4_TIPSER)
				if VOK->VOK_INCMOB == "2"
	   			  (cAliasVO4)->(dbCloseArea())
				   Loop
				Endif   
		 
				//       nLin := cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter) + 1
					
				@ nLin++,0 PSAY Repl("_",80)
				@ nLin++,0 PSAY STR0006 +": "+ALLTRIM(( cAliasVO4 )->VO4_NOSNUM+( cAliasVO4 )->VO4_SEQUEN)+Space(27)+STR0007+" "+Dtoc(dDataBase)+" - "+left(Time(),5) //"Sub Ordem"###"Emissao: "
				@ nLin++,0 PSAY STR0008+" "+VO1->VO1_NUMOSV+Space(1)+STR0009+( cAliasVO4 )->VO4_NOSNUM+Space(1)+STR0010+" "+Dtoc(VO1->VO1_DATABE)+" "+STR0011+" "+Transform(VO1->VO1_HORABE,"@R 99:99")+" "+Subs(VAI->VAI_NOMTEC ,1,11)+" "+STR0012+" "+VO1->VO1_NUMBOX //"OS.: "###"Nro Req.:"###"Aberta em "###" as "###"Box: "
				@ nLin++,0 PSAY Repl("_",80)
				@ nLin++,0 PSAY VV1->VV1_CODMAR+" "+left(Posicione("VV2",1,xFilial("VV2")+VV1->VV1_CODMAR+VV1->VV1_MODVEI,"VV2_DESMOD"),29)+" "+STR0013+" "+Transform(VV1->VV1_PLAVEI,VV1->(x3Picture("VV1_PLAVEI")))+" "+Transform(VO1->VO1_KILOME,"@E 99,999,999,999")+" "+STR0014+" "+STR0015+VV1->VV1_CODFRO //"Marca: "###"Modelo: "###"Placa: "###" Km" ### Frota
				If !Empty(VO1->VO1_CODMOT)
					@ nLin++,0 PSAY STR0016+ " " +Posicione("VOG",1,xFilial("VOG")+VO1->VO1_CODMOT ,"VOG_NOMMOT") //"Motorista: "
				EndIf
				@ nLin++,0 PSAY STR0017+" "+VO1->VO1_PROVEI+"-"+VO1->VO1_LOJPRO+" "+left(SA1->A1_NOME,25)+Space(1)+STR0018+VV1->VV1_CHASSI //"Cliente: "###"Chassi: "###"Frota:"
				@ nLin++,0 PSAY Repl("_",80)
				
				If i == 0
					
					aString := {}
					
					DbSelectArea("VOC")
					DbSetOrder(2)
					DbSeek(xFilial("VOC")+VV1->VV1_CODMAR+( cAliasVO4 )->VO4_CODSER)
					
					For nContMec := 1 to 12
						
						If !Eof() .And. VOC->VOC_CODMAR == VV1->VV1_CODMAR .And. VOC->VOC_CODSER == ( cAliasVO4 )->VO4_CODSER
							
							Aadd(aString,{VOC->VOC_QTDEXE,VOC->VOC_CODPRO,Subs(Posicione("VAI",1,xFilial("VAI")+VOC->VOC_CODPRO,"VAI_NOMTEC"),1,09)  })
							
							DbSelectArea("VOC")
							DbSkip()
							
						Else
							
							Aadd(aString,{0,Space(6),Space(09) })
							
						EndIf
						
					Next
					
					Asort(aString,,,{|x,y| Str(x[1],6)+x[2] > Str(y[1],6)+y[2] })
					
					@ nLin++,0 PSAY Repl("-",5)+"[ "+STR0019+" ]"+Repl("-",15)+"[ "+STR0020+" ]"+Repl("-",13) //"Servico a Executar"###"Mecanicos Habilitados"
					@ nLin++,0 PSAY Space(30)+STR0021 //"Nr. Vezes Codigo Nome"
					@ nLin++,0 PSAY STR0022+" " +".: "+( cAliasVO4 )->VO4_CODSER+If(!Empty(aString[1,2]),Space(7)+Str(aString[1,1],6)+" "+aString[1,2]+" "+aString[1,3],"")+If(!Empty(aString[7,2]),Space(1)+Str(aString[7,1],6)+" "+aString[7,2]+" "+aString[7,3],"") //"Servico "
					@ nLin++,0 PSAY STR0023+": "+Subs(VO6->VO6_DESSER,1,20)+If(!Empty(aString[2,2]),Space(2)+Str(aString[2,1],6)+" "+aString[2,2]+" "+aString[2,3],"")+If(!Empty(aString[8,2]),Space(1)+Str(aString[8,1],6)+" "+aString[8,2]+" "+aString[8,3],"") //"Descricao"
					@ nLin++,0 PSAY STR0024+".....: "+( cAliasVO4 )->VO4_TIPSER+"-"+Subs(Posicione("VOK",1,xFilial("VOK")+( cAliasVO4 )->VO4_TIPSER,"VOK_DESSER"),1,17)+If(!Empty(aString[3,2]),Space(1)+Str(aString[3,1],6)+" "+aString[3,2]+" "+aString[3,3],"")+If(!Empty(aString[9,2]),Space(1)+Str(aString[9,1],6)+" "+aString[9,2]+" "+aString[9,3],"") //"Tipo"
					@ nLin++,0 PSAY STR0025+"....: "+substr(VOD->VOD_DESSEC,1,20)+If(!Empty(aString[4,2]),Space(2)+Str(aString[4,1],6)+" "+aString[4,2]+" "+aString[4,3],"")+If(!Empty(aString[10,2]),Space(1)+Str(aString[10,1],6)+" "+aString[10,2]+" "+aString[10,3],"") //"Secao"
					@ nLin++,0 PSAY STR0026+"....: "+( cAliasVO4 )->VO4_GRUSER+"-"+Subs(Posicione("VOS",1,xFilial("VOS")+VV1->VV1_CODMAR+( cAliasVO4 )->VO4_GRUSER,"VOS_DESGRU"),1,18)+If(!Empty(aString[5,2]),Space(1)+Str(aString[5,1],6)+" "+aString[5,2]+" "+aString[5,3],"")+If(!Empty(aString[11,2]),Space(1)+Str(aString[11,1],6)+" "+aString[11,2]+" "+aString[11,3],"") //"Grupo"
					@ nLin++,0 PSAY STR0027+": "+Transform(( cAliasVO4 )->VO4_TEMPAD,"@R 99:99")+If(!Empty(aString[6,2]),Space(17)+Str(aString[6,1],6)+" "+aString[6,2]+" "+aString[6,3],"")+If(!Empty(aString[12,2]),Space(1)+Str(aString[12,1],6)+" "+aString[12,2]+" "+aString[12,3],"") //"Tp Padrao"
					
				Else
					
					@ nLin++,0 PSAY STR0022+" "+" "+STR0028+": "+( cAliasVO4 )->VO4_CODSER+" "+STR0023+": "+VO6->VO6_DESSER //"Servico "###"Agrupado"###"Descricao"
					@ nLin++,0 PSAY STR0026+": "+( cAliasVO4 )->VO4_GRUSER+"-"+Subs(Posicione("VOS",1,xFilial("VOS")+VV1->VV1_CODMAR+( cAliasVO4 )->VO4_GRUSER,"VOS_DESGRU"),1,15)+Space(2)+STR0025+": "+VOD->VOD_DESSEC+Space(10)+STR0027+": "+Transform(( cAliasVO4 )->VO4_TEMPAD,"@R 99:99") //"Grupo"###"Secao"###"Tp Padrao"
					
				EndIf
				
				If i # 0
					cSPF := "4"
				EndIf
				
				If i # 0
					
					nLin := nLin+2
					@ nLin++,0 PSAY STR0029+Repl("_",26)+STR0030+Repl("_",26) //"Executado por:"###"Chefe Oficina:"
					
				Else
					
					nLinTxt := 0
					nLin++
					
					@ nLin++,0 PSAY STR0031 //"Detalhamento da Descricao"
					
					DbSelectArea("VO6")
					DbSetOrder(2)
					DbSeek(xFilial("VO6")+FG_MARSRV(VV1->VV1_CODMAR,( cAliasVO4 )->VO4_CODSER) +( cAliasVO4 )->VO4_CODSER )
						
					DbSelectArea("SYP")
					DbSeek(xFilial("SYP")+VO6->VO6_DESMEM )
						
					Do While !Eof() .And. SYP->YP_CHAVE == VO6->VO6_DESMEM .And. SYP->YP_FILIAL == xFilial("SYP")
							
						@ nLin++,0 PSAY Stuff(SYP->YP_TEXTO, If( (nPos:=At("\13\10",SYP->YP_TEXTO))<=0 ,80,nPos) ,6,Space(6))
							
						nLinTxt++
							
						DbSkip()
							
						If nLinTxt >= 14
							Exit
						EndIf
							
					EndDo
						
				EndIf
					
				If GetNewPar("MV_ICODBAR","S") == "S"
						
					nLBarra := 13.0
					nCBarra :=  3.5
					
					If SX6->(DbSeek(xFilial("SX6")+"MV_POSCBAR")) // "L:=13,0C:=03,5"
							
						nLBarra := Val( Substr(GetMv("MV_POSCBAR"), At("L:=",GetMv("MV_POSCBAR"))+3 ,4) )
						nCBarra := Val( Substr(GetMv("MV_POSCBAR"), At("C:=",GetMv("MV_POSCBAR"))+3 ,4) )
						if nLBarra == 0
							nLBarra := Val( Substr(GetMv("MV_POSCBAR"), At("l:=",GetMv("MV_POSCBAR"))+3 ,4) )
						Endif
						if nLBarra == 0
							nLBarra := 13.0
						Endif
					EndIf
					
					If nLin > 33
						nLBarra := (nLBarra*2)
					endif
					
					oPr := ReturnPrtObj()
					cCode := ALLTRIM(( cAliasVO4 )->VO4_NOSNUM+( cAliasVO4 )->VO4_SEQUEN)
					//		  MSBAR3("CODE128",nLBarra,0.5,Alltrim(cCode),oPr,Nil,Nil,Nil,nil ,1.5 ,Nil,Nil,Nil)
						
					MSBAR3("CODE128",nLBarra,nCBarra,Alltrim(cCode),oPr,Nil,Nil,Nil,0.045,1.5,Nil,Nil,Nil)
					//	      MSBAR3("CODE128", nLBarra , nCBarra , ALLTRIM(VO4->VO4_NOSNUM+VO4->VO4_SEQUEN) ,oPr,NIL,NIL,NIL,NIL,NIL, NIL,NIL, "A" )
					
				EndIf
				(cAliasVO4)->(dbCloseArea())
	
			Next
	Endif	
Else

	cAlias := "VO4"
	NomeRel:= "SUBORDEM"
	cPerg  := nil
	cTitulo:= STR0005 //"Requisicao de Servicos" 
	cDesc1 := STR0006 // Sub Ordem
	cDesc2 := cDesc3 := ""
	lHabil := .f.

	For nImp := 1 to Len(aColsSrv)
	
		If !aColsSrv[ nImp , Len(aColsSrv[nImp]) ] .And. (aColsSrv[nImp,FG_POSVAR("VO4_IMPSUB","aHeaderSrv")] == "1")
			Exit
		EndIf
	
		If nImp == Len(aColsSrv)
			Return
		EndIf
	
	Next

	NomeRel := SetPrint(cAlias,NomeRel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,lHabil,,,cTamanho)

	//NomeRel := GETMV("MV_SUBORDE")

	If nlastkey == 27
		Return(Allwaystrue())
	EndIf

	SetDefault(aReturn,cAlias)

	Set Printer to &NomeRel
	Set Printer On
	Set device to Printer

	/*
	cbTxt    := Space(10)
	cbCont   := 0
	cString  := "VO3"
	Li       := 80
	m_Pag    := 1
	
	wnRel    := "OFIOM030"
	
	cTitulo:= "Sub Ordem"
	cabec1 := "OS.: "+M->VO2_NUMOSV+Space(1)+"Nro Req.:"+M->VO2_NOSNUM+Space(1)+"Func: "+M->VO2_FUNREQ+"-"+Subs(M->VO2_NOMREQ,1,22)+Space(1)+"Box: "+VO1->VO1_NUMBOX
	cabec2 := "Cliente: "+M->VO2_PROVEI+"-"+Subs(M->VO2_NOMPRO,1,16)+Space(1)+"Chassi: "+M->VO2_CHASSI+Space(1)+"Frota:"+M->VO2_CODFRO
	//cabec2 := "--- -- ---- --------------------------- ---------------------------- ----- ------- --------- -------------- -------------- ------"
	nomeprog:="OFIOM030"
	tamanho:="P"
	nCaracter:=15
	*/
	
	nTotal := 0
	nLin   := 0
	
	//SetRegua( Len( aAgrupSer ) )
	
	Asort(aAgrupSer,,,{|x,y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3] } )
	
	cCodSrv := aColsSrv[1,FG_POSVAR("VO4_CODSER","aHeaderSrv")]
	
	For nAgrupN := 1 to 2
		
		For nix := 1 to Len(aColsSrv)
			
			If aColsSrv[ nix , Len(aColsSrv[nix]) ] .Or. (aColsSrv[nix,FG_POSVAR("VO4_IMPSUB","aHeaderSrv")] # "1")
				Loop
			EndIf
		
			i := Ascan(aAgrupSer,{|x| x[1] == aColsSrv[nix,FG_POSVAR("VO4_CODSER","aHeaderSrv")] })
		
			If nAgrupN == 1 .And. i # 0 .Or. nAgrupN == 2 .And. i == 0
				Loop
			EndIf
		
			If nLin > 66 .Or. i # 0
				nLin := 0
			Else
				If nLin > 33
					nLin := 0
				ElseIf nLin # 0
					nLin := 34
				EndIf
			EndIf
		
			DbSelectArea("VO4")
			DbSetOrder(1)
			DbSeek(xFilial("VO4")+M->VO2_NOSNUM+aColsSrv[nix,FG_POSVAR("VO4_TIPTEM","aHeaderSrv")]+aColsSrv[nix,FG_POSVAR("VO4_CODSER","aHeaderSrv") ])
			
			//       nLin := cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter) + 1
		
			@ nLin++,0 PSAY Repl("_",80)
			@ nLin++,0 PSAY STR0006+": "+ALLTRIM(VO4->VO4_NOSNUM+VO4->VO4_SEQUEN)+Space(27)+STR0007+" "+Dtoc(dDataBase)+" - "+left(Time(),5) //"Sub Ordem"###"Emissao: "
			@ nLin++,0 PSAY STR0008+" "+M->VO2_NUMOSV+Space(1)+STR0009+M->VO2_NOSNUM+Space(1)+STR0010+" "+Dtoc(VO1->VO1_DATABE)+" "+STR0011+" "+Transform(VO1->VO1_HORABE,"@R 99:99")+" "+Subs(M->VO2_NOMREQ,1,11)+" "+STR0012+" "+VO1->VO1_NUMBOX //"OS.: "###"Nro Req.:"###"Aberta em "###" as "###"Box: "
			@ nLin++,0 PSAY Repl("_",80)
			@ nLin++,0 PSAY VV1->VV1_CODMAR+" "+left(Posicione("VV2",1,xFilial("VV2")+VV1->VV1_CODMAR+VV1->VV1_MODVEI,"VV2_DESMOD"),29)+" "+STR0013+" "+Transform(VV1->VV1_PLAVEI,VV1->(x3Picture("VV1_PLAVEI")))+" "+Transform(VO1->VO1_KILOME,"@E 99,999,999,999")+" "+STR0014+" "+STR0015+M->VO2_CODFRO //"Marca: "###"Modelo: "###"Placa: "###" Km" ### Frota
			If !Empty(VO1->VO1_CODMOT)
				@ nLin++,0 PSAY STR0016+" "+Posicione("VOG",1,xFilial("VOG")+VO1->VO1_CODMOT ,"VOG_NOMMOT") //"Motorista: "
			EndIf
			@ nLin++,0 PSAY STR0017+" "+M->VO2_PROVEI+"-"+M->VO2_LJPVEI+" "+left(M->VO2_NOMPRO,25)+Space(1)+STR0018+M->VO2_CHASSI //"Cliente: "###"Chassi: "###"Frota:"
			@ nLin++,0 PSAY Repl("_",80)
			
			If i == 0
			
				aString := {}
			
				DbSelectArea("VOC")
				DbSetOrder(2)
				DbSeek(xFilial("VOC")+VV1->VV1_CODMAR+aColsSrv[nix,FG_POSVAR("VO4_CODSER","aHeaderSrv")])
			
				For nContMec := 1 to 12
				
					If !Eof() .And. VOC->VOC_CODMAR == VV1->VV1_CODMAR .And. VOC->VOC_CODSER == aColsSrv[nix,FG_POSVAR("VO4_CODSER","aHeaderSrv")]
					
						Aadd(aString,{VOC->VOC_QTDEXE,VOC->VOC_CODPRO,Subs(Posicione("VAI",1,xFilial("VAI")+VOC->VOC_CODPRO,"VAI_NOMTEC"),1,09)  })
						
						DbSelectArea("VOC")
						DbSkip()
					
					Else
					
						Aadd(aString,{0,Space(6),Space(09) })
						
					EndIf
				
				Next
			
				Asort(aString,,,{|x,y| Str(x[1],6)+x[2] > Str(y[1],6)+y[2] })
				
				@ nLin++,0 PSAY Repl("-",5)+"[ "+STR0019+" ]"+Repl("-",15)+"[ "+STR0020+" ]"+Repl("-",13) //"Servico a Executar"###"Mecanicos Habilitados"
				@ nLin++,0 PSAY Space(30)+STR0021 //"Nr. Vezes Codigo Nome"
				@ nLin++,0 PSAY STR0022+" "+".: "+aColsSrv[nix,FG_POSVAR("VO4_CODSER","aHeaderSrv")]+If(!Empty(aString[1,2]),Space(7)+Str(aString[1,1],6)+" "+aString[1,2]+" "+aString[1,3],"")+If(!Empty(aString[7,2]),Space(1)+Str(aString[7,1],6)+" "+aString[7,2]+" "+aString[7,3],"") //"Servico "
				@ nLin++,0 PSAY STR0023+": "+Subs(aColsSrv[nix,FG_POSVAR("VO4_DESSER","aHeaderSrv")],1,20)+If(!Empty(aString[2,2]),Space(2)+Str(aString[2,1],6)+" "+aString[2,2]+" "+aString[2,3],"")+If(!Empty(aString[8,2]),Space(1)+Str(aString[8,1],6)+" "+aString[8,2]+" "+aString[8,3],"") //"Descricao"
				@ nLin++,0 PSAY STR0024+".....: "+aColsSrv[nix,FG_POSVAR("VO4_TIPSER","aHeaderSrv")]+"-"+Subs(Posicione("VOK",1,xFilial("VOK")+aColsSrv[nix,FG_POSVAR("VO4_TIPSER","aHeaderSrv")],"VOK_DESSER"),1,17)+If(!Empty(aString[3,2]),Space(1)+Str(aString[3,1],6)+" "+aString[3,2]+" "+aString[3,3],"")+If(!Empty(aString[9,2]),Space(1)+Str(aString[9,1],6)+" "+aString[9,2]+" "+aString[9,3],"") //"Tipo"
				@ nLin++,0 PSAY STR0025+"....: "+substr(aColsSrv[nix,FG_POSVAR("VO4_DESSEC","aHeaderSrv")],1,20)+If(!Empty(aString[4,2]),Space(2)+Str(aString[4,1],6)+" "+aString[4,2]+" "+aString[4,3],"")+If(!Empty(aString[10,2]),Space(1)+Str(aString[10,1],6)+" "+aString[10,2]+" "+aString[10,3],"") //"Secao"
				@ nLin++,0 PSAY STR0026+"....: "+aColsSrv[nix,FG_POSVAR("VO4_GRUSER","aHeaderSrv")]+"-"+Subs(Posicione("VOS",1,xFilial("VOS")+VV1->VV1_CODMAR+aColsSrv[nix,FG_POSVAR("VO4_GRUSER","aHeaderSrv")],"VOS_DESGRU"),1,18)+If(!Empty(aString[5,2]),Space(1)+Str(aString[5,1],6)+" "+aString[5,2]+" "+aString[5,3],"")+If(!Empty(aString[11,2]),Space(1)+Str(aString[11,1],6)+" "+aString[11,2]+" "+aString[11,3],"") //"Grupo"
				@ nLin++,0 PSAY STR0027+": "+Transform(aColsSrv[nix,FG_POSVAR("VO4_TEMPAD","aHeaderSrv")],"@R 99:99")+If(!Empty(aString[6,2]),Space(17)+Str(aString[6,1],6)+" "+aString[6,2]+" "+aString[6,3],"")+If(!Empty(aString[12,2]),Space(1)+Str(aString[12,1],6)+" "+aString[12,2]+" "+aString[12,3],"") //"Tp Padrao"
			
			Else
			
				@ nLin++,0 PSAY STR0022+" "+STR0028+": "+aColsSrv[nix,FG_POSVAR("VO4_CODSER","aHeaderSrv")]+" "+STR0023+": "+aColsSrv[nix,FG_POSVAR("VO4_DESSER","aHeaderSrv")] //"Servico "###"Agrupado"###"Descricao"
				@ nLin++,0 PSAY STR0026+": "+aColsSrv[nix,FG_POSVAR("VO4_GRUSER","aHeaderSrv")]+"-"+Subs(Posicione("VOS",1,xFilial("VOS")+VV1->VV1_CODMAR+aColsSrv[nix,FG_POSVAR("VO4_GRUSER","aHeaderSrv")],"VOS_DESGRU"),1,15)+Space(2)+"Secao"+": "+aColsSrv[nix,FG_POSVAR("VO4_DESSEC","aHeaderSrv")]+Space(10)+"Tp Padrao"+": "+Transform(aColsSrv[nix,FG_POSVAR("VO4_TEMPAD","aHeaderSrv")],"@R 99:99") //"Grupo"###"Secao"###"Tp Padrao"
				
			EndIf
		
			If i # 0
				cSPF := "4"
			EndIf
		
			Do While i # 0 .And. i<= Len(aAgrupSer) .And. aAgrupSer[i,1] == aColsSrv[nix,FG_POSVAR("VO4_CODSER","aHeaderSrv")]
			
				If aAgrupSer[i,2] # cSPF
				
					If aAgrupSer[i,2] == "0"
						@ nLin++,0 PSAY STR0033+Repl("-",59) //"Ferramentas-Descricao"
					ElseIf aAgrupSer[i,2] == "1"
						@ nLin++,0 PSAY "-"+STR0035+"---"+STR0032+"-"+STR0034+Repl("-",27)+STR0027+Repl("-",09) //"AP"###"RP"###"Servico----------Descricao"###"Tp Padrao"
					Else
						@ nLin++,0 PSAY STR0036+Repl("-",29)+STR0023+Repl("-",27)+STR0003 //"Pecas"###"Descricao"###"Quantidade"
					EndIf
				
					cSPF := aAgrupSer[i,2]
				
				EndIf
			
				@ nLin++,0 PSAY If(cSPF == "1","( )  ( ) ","")+aAgrupSer[i,3]+" "+aAgrupSer[i,4]+If( cSPF == "2","  "+Transform(aAgrupSer[i,5],"@E 99,999,999,999"), If( cSPF == "1", If(Posicione("VOK",1,xFilial("VOK")+aColsSrv[nix,FG_POSVAR("VO4_TIPSER","aHeaderSrv")],"VOK_INCTEM")== "2", Space(9)+Transform(Posicione("VO6",2,xFilial("VO6")+FG_MARSRV(VV1->VV1_CODMAR,aAgrupSer[i,3])+aAgrupSer[i,3],"VO6_TEMCON"),"@R 99:99") , Space(9)+Transform(Posicione("VO6",2,xFilial("VO6")+FG_MARSRV(VV1->VV1_CODMAR,aAgrupSer[i,3])+aAgrupSer[i,3],"VO6_TEMFAB"),"@R 99:99") ) ," ")  )
			
				i++
			
				If nLin >= 66
					nLin := 1
				EndIf
			
			EndDo
		
			If i # 0
				
				nLin := nLin+2
				@ nLin++,0 PSAY STR0029+Repl("_",26)+STR0030+Repl("_",26) //"Executado por:"###"Chefe Oficina:"
				
			Else
				
				nLinTxt := 0
				nLin++
				
				@ nLin++,0 PSAY STR0031 // Detalhamento da Descricao
			
				DbSelectArea("VO6")
				DbSetOrder(2)
				DbSeek(xFilial("VO6")+FG_MARSRV(VV1->VV1_CODMAR,aColsSrv[nix,FG_POSVAR("VO4_CODSER","aHeaderSrv")]) +aColsSrv[nix,FG_POSVAR("VO4_CODSER","aHeaderSrv")] )
			
				DbSelectArea("SYP")
				DbSeek(xFilial("SYP")+VO6->VO6_DESMEM )
				
				Do While !Eof() .And. SYP->YP_CHAVE == VO6->VO6_DESMEM .And. SYP->YP_FILIAL == xFilial("SYP")
					
					@ nLin++,0 PSAY Stuff(SYP->YP_TEXTO, If( (nPos:=At("\13\10",SYP->YP_TEXTO))<=0 ,80,nPos) ,6,Space(6))
				
					nLinTxt++
				
					DbSkip()
				
					If nLinTxt >= 14
						Exit
					EndIf
				
				EndDo
			
			EndIf
		
			If GetNewPar("MV_ICODBAR","S") == "S"
			
				nLBarra := 13.0
				nCBarra :=  3.5
				
				If SX6->(DbSeek(xFilial("SX6")+"MV_POSCBAR")) // "L:=13,0C:=03,5"
					
					nLBarra := Val( Substr(GetMv("MV_POSCBAR"), At("L:=",GetMv("MV_POSCBAR"))+3 ,4) )
					nCBarra := Val( Substr(GetMv("MV_POSCBAR"), At("C:=",GetMv("MV_POSCBAR"))+3 ,4) )
					if nLBarra == 0
						nLBarra := Val( Substr(GetMv("MV_POSCBAR"), At("l:=",GetMv("MV_POSCBAR"))+3 ,4) )
					Endif
					if nLBarra == 0
						nLBarra := 13.0
					Endif
				EndIf
			
				If nLin > 33
					nLBarra := (nLBarra*2)
				endif
			
				oPr := ReturnPrtObj()
				cCode := ALLTRIM(VO4->VO4_NOSNUM+VO4->VO4_SEQUEN)
				//		  MSBAR3("CODE128",nLBarra,0.5,Alltrim(cCode),oPr,Nil,Nil,Nil,nil ,1.5 ,Nil,Nil,Nil)
			
				MSBAR3("CODE128",nLBarra,nCBarra,Alltrim(cCode),oPr,Nil,Nil,Nil,0.045,1.5,Nil,Nil,Nil)
				//	      MSBAR3("CODE128", nLBarra , nCBarra , ALLTRIM(VO4->VO4_NOSNUM+VO4->VO4_SEQUEN) ,oPr,NIL,NIL,NIL,NIL,NIL, NIL,NIL, "A" )
				
			EndIf
		
		Next
	
	Next

Endif
	
Set Printer to
Set device to Screen
If aReturn[5] == 1
   OurSpool( cNomRel )
EndIf
MS_FLUSH()

Return

