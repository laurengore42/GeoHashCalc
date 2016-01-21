<%@ Control Language="vb" %>

<script runat="server">
    Public Property QueryLat As String = ""
    Public Property QueryLon As String = ""
    
    Public Property MarkLat As String = ""
    Public Property MarkLon As String = ""
    
</script>

<style>
    #map-canvas {
    width: 100%;
    height: 360px;
    border: 1px solid black;
    }
</style>

<script src="https://maps.googleapis.com/maps/api/js"></script>
<script type="text/javascript">

    var map;
    var queries;

    function locateSuccess(position) {
        var whereLat = position.coords.latitude
        var whereLon = position.coords.longitude

        location.replace(location.origin + "?lat=" + whereLat + "&lon=" + whereLon)
    }

    function locateFail() {
        alert("Don't know where you are - sorry.")
    }

    function initialize(lat, lon) {
        var latlng = new google.maps.LatLng(lat, lon);
        var mapOptions = {
            zoom: 10,
            center: latlng
        };
        map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

        <% If QueryLat.Length > 0 AndAlso QueryLon.Length > 0 Then %>
        var intStartLat = <%=QueryLat.Substring(0,QueryLat.IndexOf("."))%>;
        var intStartLon = <%=QueryLon.Substring(0,QueryLon.IndexOf("."))%>;
        var hashLat = 0<%=MarkLat%>;
        var hashLon = 0<%=MarkLon%>;

        var pinImage;
        pinImage = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + "00FF00",
            new google.maps.Size(21, 34),
            new google.maps.Point(0,0),
            new google.maps.Point(10, 34));
        var homeMarker = new google.maps.Marker({
            position: new google.maps.LatLng(<%=Querylat%>, <%=Querylon%>),
            map: map,
            icon: pinImage
        });
        
        var latlng;
        var hashMarker;
        pinImage = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + "FF0000",
            new google.maps.Size(21, 34),
            new google.maps.Point(0,0),
            new google.maps.Point(10, 34));
        latlng = new google.maps.LatLng(intStartLat + hashLat, intStartLon - hashLon);
        hashMarker = new google.maps.Marker({
            position: latlng,
            map: map,
            icon: pinImage
        });

        var markerCount = 6;
        for (i=1-markerCount; i<markerCount; i++) {
            var newLat = intStartLat + i;
            for (j=1-markerCount; j<markerCount; j++) {
                var newLon = intStartLon + j;
                if (newLat > 0) {
                    if (newLon > 0) {
                        latlng = new google.maps.LatLng(newLat + hashLat, newLon + hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                    } else if (newLon < 0) {
                        latlng = new google.maps.LatLng(newLat + hashLat, newLon - hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                    } else {
                        // longitude zero
                        latlng = new google.maps.LatLng(newLat + hashLat, newLon - hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                        latlng = new google.maps.LatLng(newLat + hashLat, newLon + hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                    }
                } else if (newLat < 0) {
                    if (newLon > 0) {
                        latlng = new google.maps.LatLng(newLat + hashLat, newLon + hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                    } else if (newLon < 0) {
                        latlng = new google.maps.LatLng(newLat + hashLat, newLon - hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                    } else {
                        // longitude zero
                        latlng = new google.maps.LatLng(newLat + hashLat, newLon - hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                        latlng = new google.maps.LatLng(newLat + hashLat, newLon + hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                    }
                } else {
                    if (newLon > 0) {
                        // latitude zero
                        latlng = new google.maps.LatLng(newLat + hashLat, newLon + hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                        latlng = new google.maps.LatLng(newLat - hashLat, newLon + hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                    } else if (newLon < 0) {
                        // latitude zero
                        latlng = new google.maps.LatLng(newLat + hashLat, newLon - hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                        latlng = new google.maps.LatLng(newLat - hashLat, newLon - hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                    } else {
                        // both zeroes
                        latlng = new google.maps.LatLng(newLat + hashLat, newLon + hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                        latlng = new google.maps.LatLng(newLat + hashLat, newLon - hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                        latlng = new google.maps.LatLng(newLat - hashLat, newLon + hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                        latlng = new google.maps.LatLng(newLat - hashLat, newLon - hashLon);
                        hashMarker = new google.maps.Marker({
                            position: latlng,
                            map: map,
                            icon: pinImage
                        });
                    }
                }
            }
        }
    <% End If %>
    }


    $(document).ready(function () {
        queries = {};
        $.each(document.location.search.substr(1).split('&'), function (c, q) {
            var i = q.split('=')
            if (i[0] != undefined && i[1] != undefined) {
                queries[i[0].toString()] = i[1].toString()
            }
        })
        
        if (queries["lat"] == undefined || queries["lon"] == undefined) {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(locateSuccess, locateFail,
                {
                    enableHighAccuracy: true
                })
            } else {
                alert("Turn geolocation on.")
            }
        } else {
            initialize(queries["lat"], queries["lon"]);
        }
    });

</script>
<div id="map-canvas"></div>
