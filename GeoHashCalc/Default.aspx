<%@ Page Language="VB" MasterPageFile="~/Site.Master" %>

<%@ Import Namespace="System.Security.Cryptography" %>

<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>

<%@ Register Src="~/map.ascx" TagPrefix="uc1" TagName="map" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script runat="server">
        Private Function GetDowValue(ByVal thisDate As DateTime) As String
            Dim sReturn = IsAmericaAwakeYet(thisDate)
            If sReturn = Nothing Then
                sReturn = IsAmericaAwakeYet(thisDate.Subtract(New TimeSpan(1, 0, 0, 0)))
            End If
            Return sReturn
        End Function
        
        Private Function IsAmericaAwakeYet(ByVal thisDate As DateTime) As String
            Dim year = thisDate.Year.ToString
            Dim month = thisDate.Month.ToString
            If month < 10 Then
                month = "0" + month
            End If
            Dim day = thisDate.Day.ToString
            If day < 10 Then
                day = "0" + day
            End If
            Dim sURL As String
            sURL = "http://geo.crox.net/djia/" + year + "/" + month + "/" + day
            Dim wrGETURL As WebRequest = WebRequest.Create(sURL)
            Dim objStream As Stream
            Try
                objStream = wrGETURL.GetResponse.GetResponseStream()
            Catch ex As Exception
                Return Nothing
            End Try
            Dim objReader As New StreamReader(objStream)
            Dim sReturn As String = ""
            sReturn += objReader.ReadLine
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
        
        Private todayStartString As String
        Private yesterdayStartString As String
        Private fullHash As String
        Private lat As String
        Private lon As String
        Private hash1 As String
        Private hash2 As String
        Private inthash1 As String
        Private inthash2 As String
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
            
            Dim dateUsed = DateTime.Now
            
            ' debug 
            'lat = "0.111"
            'lon = "-0.111"
            'dateUsed = New DateTime(2005,5,26)
            
            todayStartString = GetDowValue(dateUsed)
            yesterdayStartString = GetDowValue(dateUsed.Subtract(New TimeSpan(1, 0, 0, 0)))

            Dim useString = todayStartString
            If CType(lat, Double) > -30 Then
                useString = yesterdayStartString
            End If
            
            fullHash = GenerateHash(useString)
            hash1 = fullHash.Substring(0, 16)
            hash2 = fullHash.Substring(16)
            Dim maxhash = "ffffffffffffffff"
            inthash1 = (Convert.ToUInt64(hash1, 16) / Convert.ToUInt64(maxhash, 16)).ToString.Substring(1)
            inthash2 = (Convert.ToUInt64(hash2, 16) / Convert.ToUInt64(maxhash, 16)).ToString.Substring(1)
            
            destLat = lat.Substring(0, lat.IndexOf(".")) + inthash1.ToString().Substring(0, 7)
            destLon = lon.Substring(0, lon.IndexOf(".")) + inthash2.ToString().Substring(0, 7)
            
            DrawMap.QueryLat = lat
            DrawMap.QueryLon = lon
            DrawMap.MarkLat = destLat.Substring(destLat.IndexOf("."))
            DrawMap.MarkLon = destLon.Substring(destLon.IndexOf("."))
        End Sub
    </script>

    <div class="row">
        <div class="col">
            <h2>hello world</h2>

            <p><i>
                Starting string west of 30W: <%= todayStartString%><br />
                    Starting string east of 30W: <%= yesterdayStartString%><br /><br />
                    MD5 hash: <%= fullHash%><br />
                    In halves: <%= hash1%>, <%= hash2%><br />
                    In decimal: <%= inthash1%>, <%= inthash2%><br />
                    Go: <%= destLat%>, <%=destLon%><br />
            </i></p>

            <h4>you are at (<%=Math.Round(Convert.ToDecimal(lat), 6)%>, <%=Math.Round(Convert.ToDecimal(lon), 6)%>)</h4>
            <uc1:map ID="DrawMap" runat="server"></uc1:map>
        </div>
    </div>

</asp:Content>
