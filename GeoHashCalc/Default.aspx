<%@ Page Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.vb" Inherits="GeoHashCalc._Default" %>

<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>

<%@ Register Src="~/map.ascx" TagPrefix="uc1" TagName="map" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
<script runat=server>
    Public Function GetDowValue(year As String, month As String, day As String) As String
        Dim sURL As String
        sURL = "http://geo.crox.net/djia/" + year + "/" + month + "/" + day

        Dim wrGETURL As WebRequest = WebRequest.Create(sURL)
        Dim objStream As Stream = wrGETURL.GetResponse.GetResponseStream()
        Dim objReader As New StreamReader(objStream)
        Dim sReturn As String = ""

        sReturn += objReader.ReadLine
        
        Return year+"-"+month+"-"+day+"-"+sReturn
    End Function
    </script>

    <div class="row">
        <div class="col">
            <h2>hello world</h2>

            <p><i>
                <%
                    Dim yesterday As Date = DateTime.Now.Subtract(New TimeSpan(1, 0, 0, 0))
                    Dim today As Date = DateTime.Now
                    %>
                Hash east of 30W: <%= GetDowValue(yesterday.Year, yesterday.Month, yesterday.Day)%><br />
                Hash west of 30W: <%= GetDowValue(today.Year, today.Month, today.Day)%>
               </i></p>

            <h4>you are at</h4>

            <uc1:map runat="server"></uc1:map>
        </div>
    </div>

</asp:Content>
