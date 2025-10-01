#Include "PROTHEUS.CH"
#Include "RPTDEF.CH"
#Include "FWPRINTSETUP.CH"
#Include "TOPCONN.CH"

/*/{Protheus.doc} ARGIMPORD
	Esta función está diseñada para imprimir la orden de reparación de los módulos DMS.	
@author	MIL - Maza Informática Ltda.
@type	function
@since	06/06/2024
/*/

User Function ARGIMPORD()
	Local oReport
	Private cNroOR := ParamIXB[1]
	Private cDesc := "Impresión de la orden de reparación"
	Private cPerg := ""
	Private cNombreInf := "ARGIMPORD"
	Private cTitulo := "ARGIMPORD"
	Private aEmp := FwLoadSM0()
	Private nEmp := aScan(aEmp, {|i| i[1] == cEmpAnt .AND. i[2] == cFilAnt})

	oReport := RptDefIO()
	oReport:nFontBody := 8
	oReport:oPage:nPaperSize := 9
	oReport:PrintDialog()

Return NIL


/*/{Protheus.doc} RPTDEFIO
	Esta función crea lo diseño a imprimir del informe de la orden de reparación.
@author	MIL - Maza Informática Ltda.
@type	function
@since	06/06/2024
@return	object, Objeto de la clase TReport
/*/
Static Function RptDefIO()
	Local oReport
	Local oSecTitulo
	Local oSecEmpres
	Local oSecClient
	Local oSecMaquin
	Local oSectAbert
	Local oSecRequer
	Local oSecSerRec
	Local oSecSerEfe
	Local oSecTotSer
	Local oSecProduc
	Local oSecTotPro
	Local oSecTotGen
	Local oSecMoneda

	oReport := TReport():New(cNombreInf,cTitulo,,{|oReport| ImpInforme(oReport)},cDesc)

	oReport:SetLineHeight(45)

	// Título de Sección
	oSecTitulo := TRSection():New(oReport, "Título de Sección")
	TrCell():New(oSecTitulo, "IZQUIERDA", "", "Col1",, 30,,, "CENTER")
	TrCell():New(oSecTitulo, "TITULO", "", "Numero Orç.",, 180,,, "CENTER")
	TrCell():New(oSecTitulo, "DERECHA", "", "Col3",, 30,,, "CENTER")
	oSecTitulo:SetHeaderSection(.F.)
	oSecTitulo:SetLinesBefore(1)

	//Datos del taller
	oSecEmpres := TRSection():New(oReport, "Datos del taller")
	TrCell():New(oSecEmpres, "M0_NOMECOM", "SM0", "Nombre",, 40) // Nombre Comercial
	If !Empty(SM0->M0_ENDENT) 
		TRCell():New(oSecEmpres, "M0_ENDENT", "SM0", "Direccion",, 30)
	EndIf
	If !Empty(SM0->M0_CIDENT) 
		TRCell():New(oSecEmpres, "M0_CIDENT", "SM0", "Ciudad",, 20)
	EndIf
	If !Empty(SM0->M0_ESTENT) 
		TRCell():New(oSecEmpres, "M0_ESTENT", "SM0", "Provincia",, 5)
	EndIf
	TRCell():New(oSecEmpres, "M0_TEL", "SM0", "Telefono",, 25)
	TRCell():New(oSecEmpres, "M0_CGC", "SM0", "CUIT/CUIL", PesqPict("SA1", "A1_CGC"), 25)
	oSecEmpres:SetLineStyle()
	oSecEmpres:SetHeaderSection(.T.)
	oSecEmpres:SetLinesBefore(1)

	// Datos del Cliente
	oSecClient := TRSection():New(oReport, "Datos del cliente")
	TrCell():New(oSecClient, "CODIGO", "", "Codigo",, 15)
	TrCell():New(oSecClient, "A1_NOME", "SA1", "Nombre",, 40)
	TrCell():New(oSecClient, "A1_END", "SA1", "Direccion",, 30)
	TrCell():New(oSecClient, "A1_BAIRRO", "SA1", "Barrio",, 15)
	TrCell():New(oSecClient, "A1_MUN", "SA1", "Ciudad",, 20)
	TrCell():New(oSecClient, "A1_EST", "SA1", "Provincia",, 5)
	TrCell():New(oSecClient, "A1_TEL", "SA1", "Telefono",, 15)
	TrCell():New(oSecClient, "A1_TIPO", "SA1", "IVA",, 25)
	TrCell():New(oSecClient, "A1_CGC", "SA1", "CUIT/CUIL", PesqPict("SA1", "A1_CGC"), 25)
	TrCell():New(oSecClient, "A1_EMAIL", "SA1", "email",, 40)
	oSecClient:SetLineStyle()
	oSecClient:SetHeaderSection(.T.)
	oSecClient:SetLinesBefore(1)

	// Datos del Maquinaria
	oSecMaquin := TRSection():New(oReport, "Datos del maquinaria/vehículo")
	TrCell():New(oSecMaquin, "VE1_DESMAR", "VE1", "Marca",, 15)
	TrCell():New(oSecMaquin, "VV2_DESMOD", "VV2", "Modelo",, 40)
	TrCell():New(oSecMaquin, "VV1_CHASSI", "VV1", "Chassi",, 30)
	TrCell():New(oSecMaquin, "VV1_NUMMOT", "VV1", "Motor",, 30)
	TrCell():New(oSecMaquin, "VV1_PLAVEI", "VV1", "Chapa",, 20)
	TrCell():New(oSecMaquin, "VVC_DESCRI", "VVC", "Color",, 15)
	TrCell():New(oSecMaquin, "VO1_KILOME", "VO1", "Km/Hr",, 20,,, "LEFT",, "LEFT")
	TrCell():New(oSecMaquin, "VV1_FABMOD", "VV1", "Año",, 15)
	TrCell():New(oSecMaquin, "VO1_TPATEN", "VO1", "Tipo Atención",, 20)
	TrCell():New(oSecMaquin, "VV1_DATVEN", "VV1", "Fch.1a.Venta",, 15)
	TrCell():New(oSecMaquin, "VO1_DATABE", "VV1", "Fch.Srv.Ant",, 15)
	oSecMaquin:SetHeaderSection(.T.)
	oSecMaquin:SetLineStyle()
	oSecMaquin:SetLinesBefore(1)

	// Datos Abertura y Entrega
	oSectAbert := TRSection():New(oReport, "Datos de apertura y entrega") 
	TrCell():New(oSectAbert, "VAI_CODTEC", "VAI", "Recepción",, 15)
	TrCell():New(oSectAbert, "VAI_NOMTEC", "VAI", "Nombre",, 30)
	TrCell():New(oSectAbert, "VO1_DATABE", "VO1", "Fch apertura",, 15)
	TrCell():New(oSectAbert, "VO1_HORABE", "VO1", "Hr apertura",, 15,,, "LEFT",, "LEFT")
	TrCell():New(oSectAbert, "VO1_DATENT", "VO1", "Fch Entrega",, 15)
	TrCell():New(oSectAbert, "VO1_HORENT", "VO1", "Hr Entrega",, 15,,, "LEFT",, "LEFT")
	oSectAbert:SetLineStyle()
	oSectAbert:SetLinesBefore(1)

	// Requerimientos del cliente
	oSecRequer:=TRSection():New(oReport, "Requerimientos del cliente")
	TrCell():New(oSecRequer, "COL1", "", "",, 160)
	oSecRequer:SetHeaderSection(.F.)

	// Servicios requeridos
	oSecSerRec := TRSection():New(oReport, "Servicios requeridos")
	TrCell():New(oSecSerRec, "VO6_CODSER", "VO6", "Código",, 30)
	TrCell():New(oSecSerRec, "VO6_DESSER", "VO6", "Descr. Servicio",, 30)
	TrCell():New(oSecSerRec, "VO4_KILROD", "VO4", "Hora/KM", "@E 99999.99", 20,,, "RIGHT")
	TrCell():New(oSecSerRec, "VO4_VALHOR", "VO4", "Vlr. Unit. Serv.", PesqPict("VO4", "VO4_VALDES"), 20)
	TrCell():New(oSecSerRec, "VOO_TOTSRV", "VOO", "Vlr. Total", PesqPict("VO4", "VO4_VALDES"), 20)
	oSecSerRec:SetLinesBefore(1)

	// Servicios efectuados
	oSecSerEfe := TRSection():New(oReport, "Servicios efectuados")
	TrCell():New(oSecSerEfe, "VO4_DATINI", "VO4", "Fch. Inic.",, 30)
	TrCell():New(oSecSerEfe, "VO4_HORINI", "VO4", "Hr. Inic.",, 30,,, "LEFT",, "LEFT")
	TrCell():New(oSecSerEfe, "VO4_DATFIN", "VO4", "Fch. Final",, 30)
	TrCell():New(oSecSerEfe, "VO4_HORFIN", "VO4", "Hr. Final",, 30,,, "LEFT",, "LEFT")
	TrCell():New(oSecSerEfe, "VAI_CODTEC", "VAI", "Tecnico",, 30)
	TrCell():New(oSecSerEfe, "VAI_NOMTEC", "VAI", "Nombre",, 30)

	// Valor total de los servicios
	oSecTotSer := TRSection():New(oReport, "Valor total de los servicios")
	TrCell():New(oSecTotSer, "VOO_TOTSRV", "VOO", "Subtotal de servicios", PesqPict("VO4", "VO4_VALDES"), 25,,, "CENTER",,,,,,,, .T.)
	TrCell():New(oSecTotSer, "VZ1_VALDES", "VZ1", "Descuentos", PesqPict("VO4", "VO4_VALDES"), 25,,, "CENTER",,,,,,,, .T.)
	TrCell():New(oSecTotSer, "VOO_TOTSRV", "VOO", "Total Servicios", PesqPict("VO4", "VO4_VALDES"), 25,,, "CENTER",,,,,,,, .T.)
	oSecTotSer:SetLinesBefore(1)
	oSecTotSer:SetLineStyle()

	// Partes solicitadas
	oSecProduc := TRSection():New(oReport, "Partes solicitadas")
	TrCell():New(oSecProduc, "BM_GRUPO", "SB1", "Grupo",, 30)
	TrCell():New(oSecProduc, "B1_CODITE", "SB1", "Cod Item",, 30)
	TrCell():New(oSecProduc, "B1_DESC", "SB1", "Descripcion",, 30)
	TrCell():New(oSecProduc, "VO3_QTDREQ", "VO3", "Cant Solicit",, 30)
	TrCell():New(oSecProduc, "VO3_VALPEC", "VO3", "Vl Pieza Ne", PesqPict("VO3", "VO3_VALLIQ"), 30)
	TrCell():New(oSecProduc, "VO3_VALLIQ", "VO3", "Vl Pieza", PesqPict("VO3", "VO3_VALLIQ"), 30,,, "RIGHT")
	oSecProduc:SetLinesBefore(1)

	// Valor total de las partes
	oSecTotPro := TRSection():New(oReport, "Valor total de las partes")
	TrCell():New(oSecTotPro, "VO3_VALPEC", "VO3", "Subtotal Piezas", PesqPict("VO3", "VO3_VALLIQ"), 25,,, "CENTER",,,,,,,, .T.)
	TrCell():New(oSecTotPro, "VZ1_VALDES", "VZ1", "Descuentos", PesqPict("VO3", "VO3_VALLIQ"), 25,,, "CENTER",,,,,,,, .T.)
	TrCell():New(oSecTotPro, "VO3_VALLIQ", "VO3", "Total Piezas", PesqPict("VO3", "VO3_VALLIQ"), 30,,, "CENTER",,,,,,,, .T.)
	oSecTotPro:SetLinesBefore(1)
	oSecTotPro:SetLineStyle()

	// Total general
	oSecTotGen := TRSection():New(oReport, "Total general")
	TrCell():New(oSecTotGen, "TOT1", "", " ",, 38)
	TrCell():New(oSecTotGen, "TOT2", "", " ",, 38)
	TrCell():New(oSecTotGen, "TOT3", "", " Total General ", PesqPict("VO3", "VO3_VALLIQ"), 30,,,"RIGHT",,,,,,,,.T.)
	oSecTotGen:SetLineStyle()

	// Tipo de moneda
	oSecMoneda := TRSection():New(oReport, "Moneda")
	TrCell():New(oSecMoneda, "BLANCO1", "", " ",, 38)
	TrCell():New(oSecMoneda, "BLANCO2", "", " ",, 38)
	TrCell():New(oSecMoneda, "MONEDA", "", " Valores en ",, 30,,,"RIGHT",,,,,,,,.T.)
	oSecMoneda:SetLineStyle()

Return oReport

/*/{Protheus.doc} ImpInforme
	Esta función imprime lo informe de orden de reparación.
@author	MIL - Maza Informática Ltda.
@type	function
@since	06/06/2024
@param oReport, object, Objeto de la clase TReport
/*/
Static Function ImpInforme(oReport)
	Local oSecTitulo := oReport:Section("Título de Sección")
	Local oSecEmpres := oReport:Section("Datos del taller")
	Local oSecClient := oReport:Section("Datos del cliente")
	Local oSecMaquin := oReport:Section("Datos del maquinaria/vehículo")
	Local oSectAbert := oReport:Section("Datos de apertura y entrega")
	Local oSecRequer := oReport:Section("Requerimientos del cliente")
	Local oSecSerRec := oReport:Section("Servicios requeridos")
	Local oSecSerEfe := oReport:Section("Servicios efectuados")
	Local oSecTotSer := oReport:Section("Valor total de los servicios")
	Local oSecProduc := oReport:Section("Partes solicitadas")
	Local oSecTotPro := oReport:Section("Valor total de las partes")
	Local oSecTotGen := oReport:Section("Total general")
	Local oSecMoneda := oReport:Section("Moneda")

	Local cTipTem := ""
	Local lApontSrv := .F.
	Local aOSTTPC := {}
	Local aOSTTSC := {}
	Local nCntFor := 0
	Local nLen := 0
	Local cReqCli := 0
	Local nSubTotSrv := 0
	Local nTotDesSrv := 0
	Local nCntAuxS := 0
	Local nLenAuxS := 0
	Local nTotDesPar := 0
	Local nTotServic := 0
	Local nSubTotPar := 0	
	Local nTotPartes := 0

	If Type("nFormul") != "U"
		If nFormul == 2
			If Type("ParamIXB") != "U"
				cTipTem := ParamIXB[03]
			EndIf
		EndIf
	EndIf

	lApontSrv := MsgYesNo("¿Desea imprimir las notas del servicio?", "Atención")

	// Cálculo de piezas
	aOSTTPC := FMX_CALPEC(cNroOR, cTipTem,,,, .T.,,,,,,,,, .F.)

	// Cálculo de servicios
	aOSTTSC := FMX_CALSER(cNroOR, cTipTem,,, lApontSrv, .T.)

	DBSelectArea("VO1")
	DbSetOrder(1)
	DbSeek(FWxFilial("VO1")+cNroOR)

	DbSelectArea("VAI")
	DBSetOrder(1)
	DbSeek(FWxFilial("VAI")+VO1->VO1_FUNABE)

	DBSelectArea("VV1")
	DBSetOrder(1)
	DBSeek(FWxFilial("VV1")+VO1->VO1_CHAINT)

	// Título
	oSecTitulo:Init()
	oSecTitulo:Cell("IZQUIERDA"):SetValue("")
	oSecTitulo:Cell("TITULO"):SetValue("***** O R D  R E P A R A C I O N - " + AllTrim(VO1->VO1_NUMOSV) + " *****")
	oSecTitulo:Cell("DERECHA"):SetValue("")
	oSecTitulo:PrintLine()
	oSecTitulo:Finish()

	// oReport:IncRow()

	// Dados da Empresa
	oSecEmpres:Init()
	oSecEmpres:Cell("M0_NOMECOM"):SetValue(aEmp[nEmp, SM0_NOMECOM]) // Nome Comercial 
	If !Empty(SM0->M0_ENDENT) // Direccion
		oSecEmpres:Cell("M0_ENDENT"):SetValue(SM0->M0_ENDENT) 
	EndIf
	If !Empty(SM0->M0_CIDENT) // Ciudad
		oSecEmpres:Cell("M0_CIDENT"):SetValue(SM0->M0_CIDENT) //Cidade de Entrega
	EndIf
	If !Empty(SM0->M0_ESTENT) // Provincia
		oSecEmpres:Cell("M0_ESTENT"):SetValue(SM0->M0_ESTENT) // Estado de Entrega
	EndIf
	oSecEmpres:Cell("M0_TEL"):SetValue(SM0->M0_TEL) //Telefone
	oSecEmpres:Cell("M0_CGC"):SetValue(aEmp[nEmp, SM0_CGC])
	oSecEmpres:PrintLine()
	oSecEmpres:Finish()

	// Seleccionar al propietario del vehículo o el responsable por el pago
	DbSelectArea("SA1")
	DBSetOrder(1)
	If !SA1->(DBSeek(FWxFilial("SA1")+VO1->VO1_FATPAR+VO1->VO1_LOJA))
		SA1->(DbSeek(FWxFilial("SA1")+VO1->VO1_PROVEI+VO1->VO1_LOJPRO))
	EndIf

	oReport:ThinLine()

	// Dados Cliente
	oSecTitulo:Init()
	oSecTitulo:Cell("IZQUIERDA"):SetValue("")
	oSecTitulo:Cell("TITULO"):SetValue("***** C L I E N T E *****")
	oSecTitulo:Cell("DERECHA"):SetValue("")
	oSecTitulo:PrintLine()
	oSecTitulo:Finish()

	// oReport:IncRow()

	oSecClient:Init()
	oSecClient:Cell("CODIGO"):SetValue(SA1->A1_COD+"-"+SA1->A1_LOJA)
	oSecClient:PrintLine()
	oSecClient:Finish()

	oReport:ThinLine()

	// Datos del Maquinaria
	oSecTitulo:Init()
	oSecTitulo:Cell("IZQUIERDA"):SetValue("")
	oSecTitulo:Cell("TITULO"):SetValue("***** U N I D A D  R E P A R A D A *****")
	oSecTitulo:Cell("DERECHA"):SetValue("")
	oSecTitulo:PrintLine()
	oSecTitulo:Finish()

	// oReport:IncRow()

	DbSelectArea("VV1")
	DbSetOrder(1)
	DbSeek(FWxFilial("VV1")+VO1->VO1_CHAINT)

	DbSelectArea("VV2")
	DbSetOrder(4)
	DbSeek(FWxFilial("VV2")+VV1->VV1_MODVEI)

	DbSelectArea("VE1")
	DbSetOrder(1)
	DbSeek(FWxFilial("VE1")+VV2->VV2_CODMAR)

	oSecMaquin:Init()
	If !Empty(VO1->VO1_TPATEN)
		oSecMaquin:Cell("VO1_TPATEN"):SetValue(VO1->VO1_TPATEN + ' - ' + OFIOA560DS("050",VO1->VO1_TPATEN) )
	Else
		oSecMaquin:Cell("VO1_TPATEN"):Hide()
	EndIf
	oSecMaquin:PrintLine()
	oSecMaquin:Finish()

	// Dados Abertura e Entrega
	oSectAbert:Init()
	oSectAbert:PrintLine()
	oSectAbert:Finish()

	oReport:ThinLine()

	If !Empty(VO1->VO1_OBSMEM)

		oSecTitulo:Init()
		oSecTitulo:Cell("IZQUIERDA"):SetValue("")
		oSecTitulo:Cell("TITULO"):SetValue("***** R E Q U E R I M I E N T O S  D E L  C L I E N T E *****")
		oSecTitulo:Cell("DERECHA"):SetValue("")
		oSecTitulo:PrintLine()
		oSecTitulo:Finish()

		// oReport:IncRow()

		// Requerimientos del cliente
		cReqCli := MSMM(VO1->VO1_OBSMEM, TamSX3('VO1_OBSERV')[1], , , 3, , , 'VO1', 'VO1_OBSMEM') // Los datos de la observación estan en la tabla SYP
		oSecRequer:Init()
		nLen := MLCount(cReqCli)
		For nCntFor := 1 To nLen
			oSecRequer:Cell("COL1"):SetValue(AllTrim(MemoLine(cReqCli,, nCntFor)))
			oSecRequer:PrintLine()
		Next
		oSecRequer:Finish()

	EndIf

	// Sección de servicios
	If Len(aOSTTSC) > 0
		oReport:ThinLine()

		// Servicios requeridos
		oSecTitulo:Init()
		oSecTitulo:Cell("IZQUIERDA"):SetValue("")
		oSecTitulo:Cell("TITULO"):SetValue("***** S E R V I C I O S *****")
		oSecTitulo:Cell("DERECHA"):SetValue("")
		oSecTitulo:PrintLine()
		oSecTitulo:Finish()

		oSecSerRec:Init()
		// Servicios efectuados
		For nCntFor := 1 To Len(aOSTTSC)
			
			oSecSerRec:Cell("VO6_CODSER"):SetValue(aOSTTSC[nCntFor, 2])
			oSecSerRec:Cell("VO6_DESSER"):SetValue(aOSTTSC[nCntFor, 15])
			If aOSTTSC[nCntFor, 19] > 0 // número de kilómetros recorridos
				oSecSerRec:Cell("VO4_KILROD"):SetValue(aOSTTSC[nCntFor, 19])
				oSecSerRec:Cell("VO4_VALHOR"):SetValue(aOSTTSC[nCntFor, 7] / aOSTTSC[nCntFor, 19])
				oSecSerRec:Cell("VOO_TOTSRV"):SetValue(aOSTTSC[nCntFor, 7])
			Else // número de horas trabajadas
				oSecSerRec:Cell("VO4_KILROD"):SetValue(aOSTTSC[nCntFor, 10] / 100)
				oSecSerRec:Cell("VO4_VALHOR"):SetValue(Iif(aOSTTSC[nCntFor, 10] == 0, 0, aOSTTSC[nCntFor, 7] / (aOSTTSC[nCntFor, 10] / 100)))
				oSecSerRec:Cell("VOO_TOTSRV"):SetValue(aOSTTSC[nCntFor, 7])
			EndIf
			nSubTotSrv += aOSTTSC[nCntFor, 7]
			nTotDesSrv += aOSTTSC[nCntFor, 8]

			oSecSerRec:PrintLine()

			If lApontSrv .AND. Len(aOSTTSC[nCntFor, 14]) > 0
				If aScan(aOSTTSC[nCntFor, 14], {|aMat| !Empty(aMat[2]) }) > 0

					// Imprimir las notas de servicio
					oSecSerEfe:Init()
					aSort(aOSTTSC[nCntFor, 14],,, {|x, y| DtoS(x[2]) + StrZero(x[3], 4) < DtoS(y[2]) + StrZero(y[3], 4)}) // Ordem: Data / Hora Inicial
					nLenAuxS := Len(aOSTTSC[nCntFor, 14])
					For nCntAuxS := 1 To nLenAuxS
						If !Empty(aOSTTSC[nCntFor, 14, nCntAuxS, 2])
							oSecSerEfe:Cell("VO4_DATINI"):SetValue(aOSTTSC[nCntFor, 14, nCntAuxS, 2])
							oSecSerEfe:Cell("VO4_HORINI"):SetValue(aOSTTSC[nCntFor, 14, nCntAuxS, 3])
							oSecSerEfe:Cell("VO4_DATFIN"):SetValue(aOSTTSC[nCntFor, 14, nCntAuxS, 4])
							oSecSerEfe:Cell("VO4_HORFIN"):SetValue(aOSTTSC[nCntFor, 14, nCntAuxS, 5])
							oSecSerEfe:Cell("VAI_CODTEC"):SetValue(aOSTTSC[nCntFor, 14, nCntAuxS, 1])
							oSecSerEfe:Cell("VAI_NOMTEC"):SetValue(aOSTTSC[nCntFor, 14, nCntAuxS, 12])
							oSecSerEfe:PrintLine()
						EndIf
					Next
					oSecSerEfe:Finish()
				EndIf
			EndIf
		Next
		oSecSerRec:Finish()

		nTotServic := nSubTotSrv - nTotDesSrv
		
		oSecTotSer:Init()
		oSecTotSer:Cell("VOO_TOTSRV"):SetValue(nSubTotSrv)
		oSecTotSer:Cell("VZ1_VALDES"):SetValue(nTotDesSrv)
		oSecTotSer:Cell("VOO_TOTSRV"):SetValue(nTotServic)
		oSecTotSer:PrintLine()
		oSecTotSer:Finish()
	EndIf

	// Partes solicitadas
	If Len(aOSTTPC) > 0

		oReport:ThinLine()

		oSecTitulo:Init()
		oSecTitulo:Cell("IZQUIERDA"):SetValue("")
		oSecTitulo:Cell("TITULO"):SetValue("****** P A R T E S ******")
		oSecTitulo:Cell("DERECHA"):SetValue("")
		oSecTitulo:PrintLine()
		oSecTitulo:Finish()

		oSecProduc:Init()
		nLen := Len(aOSTTPC)
		For nCntFor := 1 To nLen
			If aOSTTPC[nCntFor, 5] > 0
				oSecProduc:Cell("BM_GRUPO"):SetValue(aOSTTPC[nCntFor, 1])
				oSecProduc:Cell("B1_CODITE"):SetValue(aOSTTPC[nCntFor, 2])
				oSecProduc:Cell("B1_DESC"):SetValue(aOSTTPC[nCntFor, 13])
				oSecProduc:Cell("VO3_QTDREQ"):SetValue(aOSTTPC[nCntFor, 5])
				oSecProduc:Cell("VO3_VALPEC"):SetValue(aOSTTPC[nCntFor, 6])
				oSecProduc:Cell("VO3_VALLIQ"):SetValue(aOSTTPC[nCntFor, 10])
				oSecProduc:PrintLine()
				nSubTotPar += aOSTTPC[nCntFor, 10]
			EndIf
		Next
		oSecProduc:Finish()

		// Cálculo de descuentos de piezas
		DbSelectArea("VZ1")
		DbSetOrder(1)
		DbSeek(FWxFilial("VZ1")+VO1->VO1_NUMOSV)
		While !VZ1->(EOF()) .AND. VZ1->VZ1_FILIAL == FWxFilial("VZ1").AND. VZ1->VZ1_NUMOSV == VO1->VO1_NUMOSV
			If Alltrim(VZ1->VZ1_PECSER) == "P"
				nTotDesPar += VZ1->VZ1_VALDES
			EndIf
			VZ1->(DbSkip())
		End

		nTotPartes := nSubTotPar - nTotDesPar
		oSecTotPro:Init()
		oSecTotPro:Cell("VO3_VALPEC"):SetValue(nSubTotPar)
		oSecTotPro:Cell("VZ1_VALDES"):SetValue(nTotDesPar)
		oSecTotPro:Cell("VO3_VALLIQ"):SetValue(nTotPartes)
		oSecTotPro:PrintLine()
		oSecTotPro:Finish()
	EndIf

	// Total general
	oSecTotGen:Init()
	oSecTotGen:Cell("TOT1"):SetValue("")
	oSecTotGen:Cell("TOT2"):SetValue("")
	oSecTotGen:Cell("TOT3"):SetValue(nTotServic + nTotPartes)
	oSecTotGen:PrintLine()
	oSecTotGen:Finish()

	// Tipo de moneda
	oSecMoneda:Init()
	oSecMoneda:Cell("BLANCO1"):SetValue("")
	oSecMoneda:Cell("BLANCO2"):SetValue("")
	oSecMoneda:Cell("MONEDA"):SetValue(GetMV("MV_MOEDA"+AllTrim(Str(Iif(VO1->VO1_MOEDA == 0, 1, VO1->VO1_MOEDA)))))
	oSecMoneda:PrintLine()
	oSecMoneda:Finish()


Return NIL

/*/{Protheus.doc} TieneNota
	Esta función comprueba si existen notas para la orden de reparación.
@author	MIL - Maza Informática Ltda.
@type	function
@since	06/06/2024
@param	cNroOR, character, Número de la orden de reparación.
@param	cCodServ, character, Código del servicio.
@return	logical, .T. si existe una nota para la orden de reparación, .F. si no existe
/*/
Static Function TieneNota(cNroOR, cCodServ)
	Local aArea := FWGetArea()
	Local lTieneNota := .F.

	BeginSQL Alias "TCAPNT"

		SELECT VO4.VO4_DATINI
	 	  FROM %table:VO4% VO4
	     WHERE VO4.VO4_FILIAL = %xFilial:VO4%
	 	   AND VO4.VO4_NUMOSV = %exp:cNroOR%
	 	   AND VO4.VO4_CODSER = %exp:cCodServ%
		   AND VO4.VO4_DATINI <> '        '
	 	   AND VO4.%notDel%

	EndSQL

	If !TCAPNT->(EOF())
		lTieneNota := .T.
	End

	TCAPNT->(DBCloseArea())

	FWRestArea(aArea)
Return lTieneNota

/*{Protheus.doc} FchUltServ
	Esta función devuelve la fecha de la última orden de reparación liberada o cerrada de la máquina/vehículo 
	en la orden de reparacione passa por cNroOR o una fecha en blanco cuando no hay ninguna orden anterior. 
@author	MIL - Maza Informática Ltda.
@type	function
@since	06/06/2024
@param	cNroOR, character, Número de la orden de reparación.
@return	date, Fecha de la última orden de reparación liberada o cerrada de la máquina/vehículo.
*/
Static Function FchUltServ(cNroOR)
	Local aArea := FWGetArea()
	Local dFchUltSrv := SToD("")

	BeginSQL Alias "FCHULTSRV"

		SELECT MAX(VO1.VO1_DATABE) DATABE
		  FROM %table:VO1% VO1
		 WHERE VO1.VO1_FILIAL =  %xFilial:VO1%
		   AND VO1.VO1_NUMOSV <> %exp:cNroOR%
		   AND VO1.VO1_CHASSI = (
			   SELECT VO1.VO1_CHASSI
				 FROM %table:VO1% VO1
				WHERE VO1.VO1_FILIAL = %xFilial:VO1%
				  AND VO1.VO1_NUMOSV = %exp:cNroOR%
				  AND VO1.%notDel%
			   )
			AND VO1.VO1_STATUS in ('D', 'F') // D=Liberada;F=Cerrada
			AND VO1.%notDel%

	EndSQL

	If !FCHULTSRV->(EOF())
		dFchUltSrv := SToD(FCHULTSRV->DATABE)
	EndIf

	FCHULTSRV->(DBCloseArea())

	FWRestArea(aArea)
Return dFchUltSrv