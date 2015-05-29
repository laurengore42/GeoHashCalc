<%@ Page Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.vb" Inherits="GeoHashCalc._Default" %>

<%@ Register Src="~/map.ascx" TagPrefix="uc1" TagName="map" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="row">
        <div class="col">
            <h2>hello world</h2>

            <h4>hashes are at</h4>

            <p><i>
                2015-05-28

                <script>
                    $(document).ready(function () {

                        var xhr = new XMLHttpRequest()
                        xhr.onreadystatechange = function () {
                            if (xhr.readyState == 4 && xhr.status == 200) {
                                alert(xhr.responseText)
                            } else if (xhr.readyState == 4) {
                                alert(xhr.status)
                            }
                        }
                        xhr.open("GET", "http://geo.crox.net/djia/2015/05/28", true)
                        xhr.send()

                        alert("hi")
                    })
                    
                </script>

               </i></p>
            <p>these places: (this only works for Europe, right now)</p>
            <p></p>
            <ul>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
            </ul>

            <h4>you are at</h4>

            <uc1:map runat="server"></uc1:map>
        </div>
    </div>

</asp:Content>
