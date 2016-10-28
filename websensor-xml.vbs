'
' Esensors Websensor XML - Solarwinds Windows Script monitor
'
' http://www.solarwinds.com/documentation/en/flarehelp/SAM/content/sam-windows-script-monitor-sw3335.htm
'
'

Option Explicit
On Error Resume Next

Dim cmdHost, cmdPort, cmdUrl, cmdDebug, cmdDecimalDelimiter, cmdSensor
cmdSensor = ""
cmdDecimalDelimiter = ""
cmdPort = "80"
cmdUrl = "ssetings.xml"

Dim args, arg
Dim expHost, expPort, expUrl, expDebug, expDecimalDelimiter, expSensor
Set args = Wscript.Arguments

If args.Count = 0 Then
	Wscript.Echo "usage: csript.exe websensor-xml.vbs --host <NAME> [options]" & vbCRLF & _
	    "" & vbCRLF & _
	    "Mandatory parameters:" & vbCRLF & _
	    "  --host <NAME>" & vbCRLF & _
	    "    address of device on network (name or IP)." & vbCRLF & _
	    "" & vbCRLF & _
	    "Optional parameters:" & vbCRLF & _
	    "  --port <N>, defaults to 80" & vbCRLF & _
	    "  --url <URL>, defaults to ssetings.xml" & vbCRLF & _
	    "  --debug, output a bit more information" & vbCRLF & _
	    "  --decimal-delimiter <char>" & vbCRLF & _
	    "    where char could be comma or any other char" & vbCRLF & _
	    "  --sensor <NAME>, outputs status of specific sensor" & vbCRLF & _
	    "" & vbCRLF
	Wscript.quit(4)
End If

For Each arg In args
	If StrComp(arg, "--host") = 0 Then
		expHost = True
	ElseIf StrComp(arg, "--port") = 0 Then
		expPort = True
	ElseIf StrComp(arg, "--url") = 0 Then
		expUrl = True
	ElseIf StrComp(arg, "--debug") = 0 Then
		cmdDebug = True
	ElseIf StrComp(arg, "--decimal-delimiter") = 0 Then
		expDecimalDelimiter = True
	ElseIf StrComp(arg, "--sensor") = 0 Then
		expSensor = True
	ElseIf expHost Then
		cmdHost = arg
		expHost = False
	ElseIf expPort Then
		cmdPort = arg
		expPort = False
	ElseIf expUrl Then
		cmdUrl = arg
		expUrl = False
	ElseIf expDecimalDelimiter Then
		cmdDecimalDelimiter = arg
		If Len(cmdDecimalDelimiter) > 1 Then
			WScript.Echo "--decimal-delimiter should be one character"
			Wscript.quit(4)
		End If
		expDecimalDelimiter = False
	ElseIf expSensor Then
		cmdSensor = arg
		expSensor = False
	End If
Next

Dim url
url = "http://" + cmdHost + ":" + cmdPort + "/" + cmdUrl

Dim XMLstructDef(7, 1)
XMLstructDef(0,0) = "tm0"
XMLstructDef(0,1) = "Temperature"
XMLstructDef(1,0) = "hu0"
XMLstructDef(1,1) = "Humidity"
XMLstructDef(2,0) = "il0"
XMLstructDef(2,1) = "Illumination"
XMLstructDef(3,0) = "vin"
XMLstructDef(3,1) = "Voltage"
XMLstructDef(4,0) = "thm"
XMLstructDef(4,1) = "Thermistor"
XMLstructDef(5,0) = "cin"
XMLstructDef(5,1) = "Contact"
XMLstructDef(6,0) = "fin"
XMLstructDef(6,1) = "Flood"
XMLstructDef(7,0) = "stu0"
XMLstructDef(7,1) = "Alarm"

Dim oXMLHTTP

If cmdDebug Then
	WScript.Echo "creating MSXML2.XMLHTTP.3.0 object"
End If
Set oXMLHTTP = CreateObject("MSXML2.XMLHTTP.3.0")

If cmdDebug Then
	WScript.Echo "sending HTTP request to [" + CStr(url) + "]"
End If
oXMLHTTP.Open "GET", url, False
oXMLHTTP.Send

If oXMLHTTP.Status <> 200 Then
	WScript.Echo "Message.Temperature: HTTP status " + CStr(oXMLHTTP.Status) + ": " + CStr(oXMLHTTP.StatusText)
	Wscript.quit(3)
End If

If cmdDebug Then
	WScript.Echo "got HTTP response: " + oXMLHTTP.ResponseText
End If

Dim maxDim0
maxDim0 = UBound(XMLstructDef, 1)

Dim i
For i = 0 to maxDim0
    Dim xmlTag, sensorName
    xmlTag = CStr(XMLstructDef(i, 0))
    sensorName = CStr(XMLstructDef(i, 1))

    if (StrComp(cmdSensor, "") = 0 OR StrComp(cmdSensor, "") <> 0 AND StrComp(sensorName, cmdSensor) = 0) Then
		If cmdDebug Then
			WScript.Echo xmlTag + " --> " + sensorName
		End If

		Dim re, targetString, colMatch, objMatch
		Set re = New regexp
		With re
		  .pattern = "<" + xmlTag + ">(.*)</" + xmlTag + ">"
		  .Global = True
		  .IgnoreCase = True
		End With
		Set colMatch = re.Execute(oXMLHTTP.ResponseText)
		For Each objMatch In colMatch
			Dim v
			v = CStr(objMatch.SubMatches.Item(0))

			If StrComp(v, "ok") = 0 Then
				v = 1
			End If
			If StrComp(v, "Alarm") = 0 Then
				v = 0
			End If

			If (StrComp(cmdDecimalDelimiter, "") <> 0) Then
				v = CStr(Replace(v, ",", ".")) ' do devices have regional settings?
				v = CStr(Replace(v, ".", cmdDecimalDelimiter))
			End If

			WScript.Echo "Statistic." + CStr(sensorName) + ": " + CStr(v)
		Next
	End If
Next

Wscript.quit(0)
