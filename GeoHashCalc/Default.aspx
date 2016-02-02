<%@ Page Language="VB" MasterPageFile="~/Site.Master" %>

<%@ Import Namespace="System.Security.Cryptography" %>

<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>

<%@ Register Src="~/map.ascx" TagPrefix="uc1" TagName="map" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script runat="server">
        Private Function GetDowValue(ByVal thisDate As DateTime, ByVal west As Boolean) As String
            Dim year = thisDate.Year.ToString
            Dim month = thisDate.Month.ToString
            Dim day = thisDate.Day.ToString
            Dim sURL As String
            sURL = "http://geo.crox.net/djia/" + year + "/" + month + "/" + day
            Dim wrGETURL As WebRequest = WebRequest.Create(sURL)
            Dim objStream As Stream
            Try
                objStream = wrGETURL.GetResponse.GetResponseStream()
            Catch ex As Exception
                Return GetDowValue(thisDate.Subtract(New TimeSpan(1, 0, 0, 0)), west)
            End Try
            Dim objReader As New StreamReader(objStream)
            Dim sReturn As String = ""
            sReturn += objReader.ReadLine
            
            If Not west Then
                thisDate = thisDate.Add(New TimeSpan(1, 0, 0, 0))
                year = thisDate.Year
                month = thisDate.Month
                day = thisDate.Day
            End If
            
            If month < 10 Then
                month = "0" + month
            End If
            If day < 10 Then
                day = "0" + day
            End If
            Return year + "-" + month + "-" + day + "-" + sReturn
        End Function
    
        Private Function GenerateHash(ByVal SourceText As String) As String
            Dim Md5 As New MD5CryptoServiceProvider()
            Dim bytes() As Byte = Encoding.Default.GetBytes(SourceText)
            Dim hashbytes = Md5.ComputeHash(bytes)
            Dim outStr = ""
            For Each hb In hashbytes
                Dim strByte = Hex(hb).ToString
                If strByte.Length = 1 Then
                    strByte = "0" + strByte
                End If
                outStr += strByte
            Next
            Return outStr.ToLower
        End Function
        
        Private useString As String
        Private fullHash As String
        Private tomorrow As String
        Private lat As String
        Private lon As String
        Private hash1 As String
        Private hash2 As String
        Private inthash1 As String
        Private inthash2 As String
        Private globalinthash1 As String
        Private globalinthash2 As String
        Private destLat As String
        Private destLon As String
        
        Protected Sub Page_Init() Handles Me.Init
            lat = Request.QueryString("lat")
            lon = Request.QueryString("lon")
            If lat = Nothing OrElse lat = "" Then
                Return
            End If
            If lon = Nothing OrElse lon = "" Then
                Return
            End If
            
            If lat.IndexOf(".") = -1 Then
                lat = lat + ".0"
            End If
            If lon.IndexOf(".") = -1 Then
                lon = lon + ".0"
            End If
            
            Dim dateUsedString = Request.QueryString("date")
            Dim dateUsed As DateTime = Nothing
            
            If Not dateUsedString = Nothing AndAlso Not dateUsedString = "" Then
                DateTime.TryParse(Request.QueryString("date"), dateUsed)
            End If
            If dateUsed = Nothing Then
                dateUsed = DateTime.Now
            End If
            
            tomorrow = Request.QueryString("tomorrow")
            If Not tomorrow = Nothing AndAlso tomorrow = "true" Then
                dateUsed = dateUsed.Add(New TimeSpan(1, 0, 0, 0))
            End If
            
            ' debug 
            'lat = "40.111"
            'lon = "-90.111"
            'dateUsed = New DateTime(2010,6,12)
            
            Dim westStartString = GetDowValue(dateUsed, True)
            Dim eastStartString = GetDowValue(dateUsed.Subtract(New TimeSpan(1, 0, 0, 0)), False)

            useString = westStartString
            If CType(lon, Double) > -30 Then
                useString = eastStartString
            End If
            
            fullHash = GenerateHash(useString)
            hash1 = fullHash.Substring(0, 16)
            hash2 = fullHash.Substring(16)
            Dim maxhash = "ffffffffffffffff"
            inthash1 = (Convert.ToUInt64(hash1, 16) / Convert.ToUInt64(maxhash, 16)).ToString.Substring(1)
            inthash2 = (Convert.ToUInt64(hash2, 16) / Convert.ToUInt64(maxhash, 16)).ToString.Substring(1)
            
            ' avoid truncation errors
            Dim desiredLength = 7
            inthash1 = "." + Math.Round(Convert.ToDouble(inthash1) * Math.Pow(10, desiredLength)).ToString
            inthash2 = "." + Math.Round(Convert.ToDouble(inthash2) * Math.Pow(10, desiredLength)).ToString
            
            destLat = lat.Substring(0, lat.IndexOf(".")) + inthash1
            destLon = lon.Substring(0, lon.IndexOf(".")) + inthash2
            
            If (useString = westStartString) Then
                ' West
                
                Dim globalhashstring = eastStartString
                Dim globalfullHash = GenerateHash(eastStartString)
                Dim globalhash1 = globalfullHash.Substring(0, 16)
                Dim globalhash2 = globalfullHash.Substring(16)
                globalinthash1 = (Convert.ToUInt64(globalhash1, 16) / Convert.ToUInt64(maxhash, 16)).ToString.Substring(1)
                globalinthash2 = (Convert.ToUInt64(globalhash2, 16) / Convert.ToUInt64(maxhash, 16)).ToString.Substring(1)
                globalinthash1 = "." + Math.Round(Convert.ToDouble(globalinthash1) * Math.Pow(10, desiredLength)).ToString
                globalinthash2 = "." + Math.Round(Convert.ToDouble(globalinthash2) * Math.Pow(10, desiredLength)).ToString
            Else
                ' East
                
                globalinthash1 = inthash1
                globalinthash2 = inthash2
                
                Dim tomorrowString = GetDowValue(dateUsed, False)
                If Not eastStartString = tomorrowString Then
                    Dim fullHashTomorrow = GenerateHash(tomorrowString)
                    Dim hash1tomorrow = fullHashTomorrow.Substring(0, 16)
                    Dim hash2tomorrow = fullHashTomorrow.Substring(16)
                    Dim inthash1tomorrow = (Convert.ToUInt64(hash1tomorrow, 16) / Convert.ToUInt64(maxhash, 16)).ToString.Substring(1)
                    Dim inthash2tomorrow = (Convert.ToUInt64(hash2tomorrow, 16) / Convert.ToUInt64(maxhash, 16)).ToString.Substring(1)
                    Dim destLattomorrow = lat.Substring(0, lat.IndexOf(".")) + inthash1tomorrow
                    Dim destLontomorrow = lon.Substring(0, lon.IndexOf(".")) + inthash2tomorrow
                    DrawMap.MarkLatTomorrow = destLattomorrow.Substring(destLat.IndexOf("."))
                    DrawMap.MarkLonTomorrow = destLontomorrow.Substring(destLon.IndexOf("."))
                End If
            End If
            
            DrawMap.QueryLat = lat
            DrawMap.QueryLon = lon
            DrawMap.MarkLat = destLat.Substring(destLat.IndexOf("."))
            DrawMap.MarkLon = destLon.Substring(destLon.IndexOf("."))
            DrawMap.GlobalLat = globalinthash1
            DrawMap.GlobalLon = globalinthash2
        End Sub
    </script>

    <div class="row">
        <div class="col">
            <h2>hello world</h2>
            <% If useString IsNot Nothing Then%>
                <% If Not String.IsNullOrEmpty(DrawMap.MarkLatTomorrow) Then%>
            <h4>Showing markers for <span style="color:#<%=DrawMap.HashColor%>">today</span> and <span style="color:#<%=DrawMap.TomorrowColor%>">tomorrow</span></h4>
                <% End If %>
            <h4>you are at (<%=Math.Round(Convert.ToDecimal(lat), 6)%>, <%=Math.Round(Convert.ToDecimal(lon), 6)%>)</h4>
            <% End If%>

            <uc1:map ID="DrawMap" runat="server"></uc1:map>

            <% If useString IsNot Nothing Then%>
            <br />
            <p><i>
                    Starting string: <%= useString%><br />
                    MD5 hash: <%= fullHash%><br />
                    In halves: <%= hash1%>, <%= hash2%><br />
                    In decimal: <%= inthash1%>, <%= inthash2%><br />
                    Check: <a href="http://wiki.xkcd.com/geohashing/<%=useString.Substring(0, 10)%>" target="_blank"><%=useString.Substring(0, 10)%></a><br />
                    Go: <%= destLat%>, <%=destLon%><br />
                    Check: <a href="http://wiki.xkcd.com/geohashing/<%=lat.Substring(0, lat.IndexOf("."))%>,<%=lon.Substring(0, lon.IndexOf("."))%>" target="_blank"><%=lat.Substring(0, lat.IndexOf("."))%>,<%=lon.Substring(0, lon.IndexOf("."))%></a><br />
                <br />
                    Globalhash: <%= Math.Round((Convert.ToDecimal("0" + globalinthash1) * 180) - 90, 7)%>, <%= Math.Round((Convert.ToDecimal("0" + globalinthash2) * 360) - 180, 7)%>
            </i></p>
            <% End If%>
        </div>
    </div>

</asp:Content>
