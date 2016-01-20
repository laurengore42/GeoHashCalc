<%@ Page Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.vb" Inherits="GeoHashCalc._Default" %>

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
            Dim day = thisDate.Day.ToString
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
                outStr += Hex(hb).ToString
            Next
            Return outStr
        End Function
    </script>

    <div class="row">
        <div class="col">
            <h2>hello world</h2>

            <p><i>
                    <%
                        Dim todayStartString = GetDowValue(DateTime.Now)
                        Dim yesterdayStartString = GetDowValue(DateTime.Now.Subtract(New TimeSpan(1, 0, 0, 0)))
                        
                        Dim yesterdayFullHash = GenerateHash(yesterdayStartString)
                        Dim yesterdayHash1 = yesterdayFullHash.Substring(0, 16)
                        Dim yesterdayHash2 = yesterdayFullHash.Substring(16)
                    %>
                Starting string west of 30W: <%= todayStartString%><br />
                    <br />
                    Starting string east of 30W: <%= yesterdayStartString%><br />
                    MD5 hash of that: <%= yesterdayFullHash%><br />
                    First half: <%= yesterdayHash1%><br />
                    Second half: <%= yesterdayHash2%><br />
            </i></p>

            <h4>you are at</h4>

            <uc1:map runat="server"></uc1:map>
        </div>
    </div>

</asp:Content>
