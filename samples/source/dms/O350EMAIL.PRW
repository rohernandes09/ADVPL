/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ O350EMAILบ Autor ณ Andre Luis Almeida บ Data ณ  09/01/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Formatacao do e-mail de confirmacao do Agendamento Oficina บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ OFIOM350 - Agendamento Oficina                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function O350EMAIL()
Local nCount    := 0
Local cLembret1 := "Lembrete: Para seu melhor atendimento, solicitamos sua presenca com 5 minutos de antecedencia. Em caso de atraso superior"
Local cLembret2 := "a 15 minutos, liberaremos seu horario para outro atendimento. Solicitamos tambem, sua permanencia nos primeiros 20"
Local cLembret3 := "minutos do atendimento para realizar a inspecao visual dos componentes do seu veiculo junto ao Tecnico designado. Havendo"
Local cLembret4 := "necessidade de alteracao da data/hora do atendimento, favor entrar em contato com nosso centro de atendimento ao cliente, pelo telefone"
Local cLembret5 := ", atraves do Departamento de Atendimento ao Cliente, agradece a escolha por nossa empresa. Foi executado o O350EMAIL! Teste de FNC!"

///////////////////////////////////////////////////////////////////////////////////////////
// cMensagem ( variavel PRIVATE com toda a formatacao do E-mail do Agendamento Oficina ) //
///////////////////////////////////////////////////////////////////////////////////////////
cMensagem := ""
cMensagem += "<center><table border=0 width=80%><tr>"
If !Empty( GetNewPar("MV_ENDLOGO","") )
	cMensagem += "<td width=20%><img src='" + GetNewPar("MV_ENDLOGO","") + "'></td>"
EndIf
cMensagem += "<td align=center width=80%><font size=3 face='verdana,arial' Color=#0000cc><b>"
cMensagem += SM0->M0_NOMECOM+"<br></font></b><font size=1 face='verdana,arial' Color=black>"
cMensagem += SM0->M0_ENDENT+"<br>"
cMensagem += SM0->M0_CIDENT+" - "+SM0->M0_ESTENT+"<br>"
cMensagem += "Fone: "+SM0->M0_TEL+"</font></td></tr></table><hr width=80%>" // Fone
cMensagem += "<font size=3 face='verdana,arial' Color=black><b>"+cTitulo+"<br></font></b><hr width=80%><br>"
cMensagem += "<table border=0 width=80%><tr>"
cMensagem += "<td><font size=3 face='verdana,arial' Color=black>"+"Data:"+"</font></td>" // Data
cMensagem += "<td><font size=3 face='verdana,arial' Color=#0000cc><b>"+Transform(M->VSO_DATAGE,"@D")+" - "+FG_CDOW(M->VSO_DATAGE)+"</b></font></td>"
cMensagem += "<td><font size=3 face='verdana,arial' Color=black>"+"Hora:"+"</font></td>" // Hora
cMensagem += "<td><font size=3 face='verdana,arial' Color=#0000cc><b>"+Transform(M->VSO_HORAGE,"@R 99:99")+"hs</b></font></td>"
cMensagem += "</tr><tr>"
cMensagem += "<td><font size=3 face='verdana,arial' Color=black>"+"Tecnico:"+"</font></td>" // Tecnico
cMensagem += "<td><font size=3 face='verdana,arial' Color=#0000cc><b>"+VAI->VAI_NOMTEC+"</b></font></td>"
cMensagem += "<td><font size=3 face='verdana,arial' Color=black>"+"Box:"+"</font></td>" // Box
cMensagem += "<td><font size=3 face='verdana,arial' Color=#0000cc><b>"+M->VSO_NUMBOX+"</b></font></td>"
cMensagem += "</tr></table><br>"
cMensagem += "<table border=0 width=80%><tr>"
cMensagem += "<td><font size=3 face='verdana,arial' Color=black>"+"Chassi:"+"</font></td>" // Chassi
cMensagem += "<td><font size=3 face='verdana,arial' Color=#0000cc><b>"+M->VSO_GETKEY+"</b></font></td>"
cMensagem += "<td><font size=3 face='verdana,arial' Color=black>"+"Placa:"+"</font></td>" // Placa
cMensagem += "<td><font size=3 face='verdana,arial' Color=#0000cc><b>"+Transform(M->VSO_PLAVEI,VV1->(x3Picture("VV1_PLAVEI")))+"</b></font></td>"
cMensagem += "</tr><tr>"
cMensagem += "<td><font size=3 face='verdana,arial' Color=black>"+"Proprietario:"+"</font></td>" // Proprietario
cMensagem += "<td><font size=3 face='verdana,arial' Color=#0000cc><b>"+M->VSO_NOMPRO+"</b></font></td>"
cMensagem += "<td><font size=3 face='verdana,arial' Color=black>"+"Fone:"+"</font></td>" // Fone
cMensagem += "<td><font size=3 face='verdana,arial' Color=#0000cc><b>"+M->VSO_FONPRO+"</b></font></td>"
cMensagem += "</tr><tr>"
cMensagem += "<td><font size=3 face='verdana,arial' Color=black>"+"Endereco:"+"</font></td>" // Endereco
cMensagem += "<td><font size=3 face='verdana,arial' Color=#0000cc><b>"+M->VSO_ENDPRO+"</b></font></td>"
cMensagem += "<td><font size=3 face='verdana,arial' Color=black>"+"Cidade:"+"</font></td>" // Cidade
cMensagem += "<td><font size=3 face='verdana,arial' Color=#0000cc><b>"+M->VSO_CIDPRO+" - "+M->VSO_ESTPRO+"</b></font></td>"
cMensagem += "</tr></table><br>"
If GetNewPar("MV_MOBSEMA","N") == "S" .and. !Empty(M->VSO_OBSERV)
	cMensagem += "<table border=0 width=80%><tr><td>"
	cMensagem += "<pre><font size=3 face='verdana,arial' Color=black>"+"Observacao:"+"</font><br>" // Observacao
	cMensagem += "<font size=2 face='verdana,arial' Color=#0000cc><b>" + M->VSO_OBSERV + "</b></font></pre>"
	cMensagem += "</td></tr></table>"
EndIf
cMensagem += "<table border=1 width=80%><tr>"
cMensagem += "<td bgcolor=#0000cc><font size=1 face='verdana,arial' color=white><b>"+"Servicos Agendados"+"</font></b></td>" // Servicos Agendados
cMensagem += "</tr>"
For nCount := 1 to Len(oAuxGetDados:aCols)
	If !oAuxGetDados:aCols[nCount,Len(oAuxGetDados:aCols[nCount])]
		cMensagem += "<tr><td><font size=2 face='verdana,arial' color=#0000cc><b>"
		cMensagem += oAuxGetDados:aCols[nCount,FG_POSVAR("VST_DESINC","oAuxGetDados:aHeader")]
		cMensagem += "</font></b></td></tr>"
	EndIf
Next
cMensagem += "</table><br><hr width=80%><table border=0 width=80%><tr>"
cMensagem += "<td><p align=justify><font size=1 face='verdana,arial' Color=black>"
cMensagem += cLembret1+" "
cMensagem += cLembret2+" "
cMensagem += cLembret3+" "
cMensagem += cLembret4+" "+Alltrim(SM0->M0_TEL)+".<br>"
cMensagem += "A"+" "+Alltrim(SM0->M0_FILIAL)+cLembret5+"</p>"
cMensagem += "</font></td></tr></table><hr width=80%><table border=0 width=80%><tr>"
cMensagem += "<td><font size=1 face='verdana,arial' Color=black>"+"Agendado:"+"</font></td>" // Agendado
cMensagem += "<td><font size=1 face='verdana,arial' Color=black>"+M->VSO_NOMAGE+"</font></td>"
cMensagem += "<td><font size=1 face='verdana,arial' Color=black>"+"Data:"+"</font></td>" // Data
cMensagem += "<td><font size=1 face='verdana,arial' Color=black>"+Transform(M->VSO_DATREG,"@D")+"</font></td>"
cMensagem += "<td><font size=1 face='verdana,arial' Color=black>"+"Hora:"+"</font></td>" // Hora
cMensagem += "<td><font size=1 face='verdana,arial' Color=black>"+Transform(M->VSO_HORREG,"@R 999:99")+"hs</font></td>" // hs
cMensagem += "</tr></table><br></center>"
Return()