<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="map.ascx.vb" Inherits="GeoHashCalc.map" %>

<script type="text/javascript">

    function locateSuccess(position) {
        var whereLat = position.coords.latitude
        var whereLong = position.coords.longitude

        location.replace(location.origin + "?lat=" + whereLat + "&long=" + whereLong)
    }

    function locateFail() {
        alert("Don't know where you are - sorry.")
    }

    $(document).ready(function () {
            var queries = {}
            $.each(document.location.search.substr(1).split('&'), function (c, q) {
                var i = q.split('=')
                if (i[0] != undefined && i[1] != undefined) {
                    queries[i[0].toString()] = i[1].toString()
                }
            })
        
            if (queries["lat"] == undefined || queries["long"] == undefined) {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(locateSuccess, locateFail,
                    {
                        enableHighAccuracy: true
                    })
                } else {
                    alert("Turn geolocation on.")
                }
            } else {
                document.getElementById("mapframe").src = "https://www.google.com/maps/embed/v1/place?q=" +
                    queries["lat"] + ", " + queries["long"] + "&key=AIzaSyD7THYGsLn7mmpoQ5GlI2lfU0-tZ8Tjqz8"
            }
    })

</script>
<iframe id="mapframe" width="600" height="450" frameborder="0" style="border:0"></iframe>