<%@ Page Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.vb" Inherits="GeoHashCalc._Default" %>

<%@ Import Namespace="System.Security.Cryptography" %>

<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>

<%@ Register Src="~/map.ascx" TagPrefix="uc1" TagName="map" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script runat="server">
        Public Function GetDowValue(ByVal year As String, ByVal month As String, ByVal day As String) As String
            Dim sURL As String
            sURL = "http://geo.crox.net/djia/" + year + "/" + month + "/" + day
            Dim wrGETURL As WebRequest = WebRequest.Create(sURL)
            Dim objStream As Stream = wrGETURL.GetResponse.GetResponseStream()
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
                        Dim yesterday As Date = DateTime.Now.Subtract(New TimeSpan(1, 0, 0, 0))
                        Dim today As Date = DateTime.Now

                        Dim todayStartString = GetDowValue(today.Year, today.Month, today.Day)
                    
                        Dim yesterdayStartString = GetDowValue(yesterday.Year, yesterday.Month, yesterday.Day)
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
