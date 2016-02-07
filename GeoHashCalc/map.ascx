<%@ Control Language="vb" %>

<script runat="server">
    Public Property QueryLat As String = ""
    Public Property QueryLon As String = ""
    
    Public Property MarkLat As String = ""
    Public Property MarkLon As String = ""
    Public Property MarkLatTomorrow As String = ""
    Public Property MarkLonTomorrow As String = ""
    Public Property MarkLatDay3 As String = ""
    Public Property MarkLonDay3 As String = ""
    Public Property MarkLatDay4 As String = ""
    Public Property MarkLonDay4 As String = ""
    
    Public Property GlobalLat As String = ""
    Public Property GlobalLon As String = ""
    
    Public Property HomeColor As String = "008000" ' green
    Public Property HashColor As String = "CD5C5C" ' indianred
    Public Property GlobalColor As String = "FFFFFF" ' white
    Public Property TomorrowColor As String = "FFD700" ' gold
    Public Property Day3Color As String = "FFB6C1" ' lightpink
    Public Property Day4Color As String = "A9A9A9" ' darkgray
    Public Property LineColor As String = "FF00FF" ' fuchsia
    
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

        var locationString = location.origin + "?lat=" + whereLat + "&lon=" + whereLon;
        <% If Page.Request.QueryString("date") IsNot Nothing AndAlso Page.Request.QueryString("date") IsNot "" Then%>
        locationString += "&date=" + "<%=Page.Request.QueryString("date")%>";
        <% End If%>

        location.replace(locationString);
    }

    function locateFail() {
        alert("Don't know where you are - sorry.");
    }

    function drawLine(location, map, color, isLongitude) {
        var start;
        var middle;
        var end;
        var drawnLine;

        var line

        if (isLongitude) {
            // Mercator projection never actually reaches the poles
            // cuts off at just over 85 degrees in Google's depiction
            start = new google.maps.LatLng(-89, location);
            middle = new google.maps.LatLng(0, location);
            end = new google.maps.LatLng(89, location);
            
            drawnLine = new google.maps.Polyline({
                path: [start, middle, end],
                geodesic: true,
                map: map,
                strokeColor: "#" + color,
                strokeOpacity: 1.0,
                strokeWeight: 0.5
            });
        } else {
            start = new google.maps.LatLng(location, -180);
            middle = new google.maps.LatLng(location, 0);
            end = new google.maps.LatLng(location, 180);
            
            drawnLine = new google.maps.Polyline({
                path: [start, middle, end],
                geodesic: false,
                map: map,
                strokeColor: "#" + color,
                strokeOpacity: 1.0,
                strokeWeight: 0.5
            });
        }
    }

    function drawMarker(latlng, map, pinImage) {
        var marked = new google.maps.Marker({
            position: latlng,
            map: map,
            icon: pinImage
        });
        var labelled = new google.maps.InfoWindow({
            content: '<a href="http://maps.google.co.uk/maps?q=' + latlng.toString() +'" target="_blank">' + latlng.toString() + '</a>'
        });
        marked.addListener('click', function() {
            labelled.open(map,marked);
        });
    }

    function drawSetOfMarkers(intStartLat, intStartLon, hashLat, hashLon, markerCount, map, pinImage) {
        for (i=1-markerCount; i<markerCount; i++) {
            var newLat = intStartLat + i;
            for (j=1-markerCount; j<markerCount; j++) {
                var newLon = intStartLon + j;
                if (newLat > 0) {
                    if (newLon > 0) {
                        latlng = new google.maps.LatLng(newLat + hashLat, newLon + hashLon);
                        drawMarker(latlng, map, pinImage);
                    } else if (newLon < 0) {
                        latlng = new google.maps.LatLng(newLat + hashLat, newLon - hashLon);
                        drawMarker(latlng, map, pinImage);
                    } else {
                        // longitude zero
                        latlng = new google.maps.LatLng(newLat + hashLat, 0 - hashLon);
                        drawMarker(latlng, map, pinImage);
                        latlng = new google.maps.LatLng(newLat + hashLat, 0 + hashLon);
                        drawMarker(latlng, map, pinImage);
                    }
                } else if (newLat < 0) {
                    if (newLon > 0) {
                        latlng = new google.maps.LatLng(newLat - hashLat, newLon + hashLon);
                        drawMarker(latlng, map, pinImage);
                    } else if (newLon < 0) {
                        latlng = new google.maps.LatLng(newLat - hashLat, newLon - hashLon);
                        drawMarker(latlng, map, pinImage);
                    } else {
                        // longitude zero
                        latlng = new google.maps.LatLng(newLat - hashLat, 0 - hashLon);
                        drawMarker(latlng, map, pinImage);
                        latlng = new google.maps.LatLng(newLat - hashLat, 0 + hashLon);
                        drawMarker(latlng, map, pinImage);
                    }
                } else {
                    if (newLon > 0) {
                        // latitude zero
                        latlng = new google.maps.LatLng(0 + hashLat, newLon + hashLon);
                        drawMarker(latlng, map, pinImage);
                        latlng = new google.maps.LatLng(0 - hashLat, newLon + hashLon);
                        drawMarker(latlng, map, pinImage);
                    } else if (newLon < 0) {
                        // latitude zero
                        latlng = new google.maps.LatLng(0 + hashLat, newLon - hashLon);
                        drawMarker(latlng, map, pinImage);
                        latlng = new google.maps.LatLng(0 - hashLat, newLon - hashLon);
                        drawMarker(latlng, map, pinImage);
                    } else {
                        // both zeroes
                        latlng = new google.maps.LatLng(0 + hashLat, 0 + hashLon);
                        drawMarker(latlng, map, pinImage);
                        latlng = new google.maps.LatLng(0 + hashLat, 0 - hashLon);
                        drawMarker(latlng, map, pinImage);
                        latlng = new google.maps.LatLng(0 - hashLat, 0 + hashLon);
                        drawMarker(latlng, map, pinImage);
                        latlng = new google.maps.LatLng(0 - hashLat, 0 - hashLon);
                        drawMarker(latlng, map, pinImage);
                    }
                }
            }
        }
    }

    function initialize(lat, lon) {
        var latlng = new google.maps.LatLng(lat, lon);
        var mapOptions = {
            zoom: 7,
            center: latlng
        };
        map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

        <% If QueryLat.Length > 0 AndAlso QueryLon.Length > 0 Then %>
        var intStartLat = <%=QueryLat.Substring(0,QueryLat.IndexOf("."))%>;
        var intStartLon = <%=QueryLon.Substring(0,QueryLon.IndexOf("."))%>;
        var hashLat = 0<%=MarkLat%>;
        var hashLon = 0<%=MarkLon%>;
        var hashLatTomorrow = 0<%=MarkLatTomorrow%>;
        var hashLonTomorrow = 0<%=MarkLonTomorrow%>;
        var hashLatDay3 = 0<%=MarkLatDay3%>;
        var hashLonDay3 = 0<%=MarkLonDay3%>;
        var hashLatDay4 = 0<%=MarkLatDay4%>;
        var hashLonDay4 = 0<%=MarkLonDay4%>;
        var globalLat = <%=GlobalLat%>;
        var globalLon = <%=GlobalLon%>;

        var homeColor = "<%=HomeColor%>";
        var globalColor = "<%=GlobalColor%>";
        var hashColor = "<%=HashColor%>";
        var tomorrowColor = "<%=TomorrowColor%>";
        var day3Color = "<%=Day3Color%>";
        var day4Color = "<%=Day4Color%>";
        var lineColor = "<%=LineColor%>";

        // lines
        for (i=-180;i<180;i++) {
            drawLine(i,map,lineColor,true);
        }
        for (i=-90;i<90;i++) {
            drawLine(i,map,lineColor,false);
        }
        
        // home location
        var pinImage;
        pinImage = {
            url: "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + homeColor,
            size: new google.maps.Size(21, 34),
            origin: new google.maps.Point(0,0),
            anchor: new google.maps.Point(10, 34)
        };
        var homeMarker = new google.maps.Marker({
            position: new google.maps.LatLng(<%=Querylat%>, <%=Querylon%>),
            map: map,
            icon: pinImage
        });
        
        // globalhash
        var latlng;
        pinImage = {
            url: "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + globalColor,
            size: new google.maps.Size(21, 34),
            origin: new google.maps.Point(0,0),
            anchor: new google.maps.Point(10, 34)
        };
        latlng = new google.maps.LatLng(globalLat, globalLon);
        drawMarker(latlng, map, pinImage);
        
        var geocoder = new google.maps.Geocoder;
        geocoder.geocode({'location': latlng}, function(results, status) {
            if (status === google.maps.GeocoderStatus.OK && results[1]) {
                $('#globalHashLocation').text(results[1].formatted_address);
            } else if (status === "ZERO_RESULTS") {
                $('#globalHashLocation').text("Could not geocode - probably in the sea.");
            }
        });
        
        // regular hashes
        var markerCount = 6;

        // today
        pinImage = {
            url: "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + hashColor,
            size: new google.maps.Size(21, 34),
            origin: new google.maps.Point(0,0),
            anchor: new google.maps.Point(10, 34)
        };
        drawSetOfMarkers(intStartLat, intStartLon, hashLat, hashLon, markerCount, map, pinImage);

        // tomorrow
        if (hashLatTomorrow != 0 || hashLonTomorrow != 0) {
            pinImage = {
                url: "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + tomorrowColor,
                size: new google.maps.Size(21, 34),
                origin: new google.maps.Point(0,0),
                anchor: new google.maps.Point(10, 34)
            };
            drawSetOfMarkers(intStartLat, intStartLon, hashLatTomorrow, hashLonTomorrow, markerCount, map, pinImage);
        }

        // day 3
        if (hashLatDay3 != 0 || hashLonDay3 != 0) {
            pinImage = {
                url: "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + day3Color,
                size: new google.maps.Size(21, 34),
                origin: new google.maps.Point(0,0),
                anchor: new google.maps.Point(10, 34)
            };
            drawSetOfMarkers(intStartLat, intStartLon, hashLatDay3, hashLonDay3, markerCount, map, pinImage);
        }

        // day 4
        if (hashLatDay4 != 0 || hashLonDay4 != 0) {
            pinImage = {
                url: "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + day4Color,
                size: new google.maps.Size(21, 34),
                origin: new google.maps.Point(0,0),
                anchor: new google.maps.Point(10, 34)
            };
            drawSetOfMarkers(intStartLat, intStartLon, hashLatDay4, hashLonDay4, markerCount, map, pinImage);
        }
    <% End If %>
    }


    $(document).ready(function () {
        queries = {};
        $.each(document.location.search.substr(1).split('&'), function (c, q) {
            var i = q.split('=');
            if (i[0] != undefined && i[1] != undefined) {
                queries[i[0].toString()] = i[1].toString();
            }
        })
        
        if (queries["lat"] == undefined || queries["lon"] == undefined) {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(locateSuccess, locateFail,
                {
                    enableHighAccuracy: true
                });
            } else {
                alert("Turn geolocation on.");
            }
        } else {
            initialize(queries["lat"], queries["lon"]);
        }
    });

</script>
<div id="map-canvas"></div>
