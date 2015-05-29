<%@ Page Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.vb" Inherits="GeoHashCalc._Default" %>

<%@ Register Src="~/map.ascx" TagPrefix="uc1" TagName="map" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="row">
        <div class="col">
            <h2>hello world</h2>
            <h4>have a map</h4>

            <uc1:map runat="server"></uc1:map>
        </div>
    </div>

</asp:Content>
