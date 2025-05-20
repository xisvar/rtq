import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/bus_provider.dart';
import '../models/bus.dart';
import '../widgets/bus_info_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  
  // Default center on Lagos, Nigeria
  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(6.5244, 3.3792),
    zoom: 13,
  );
  
  Bus? _selectedBus;
  
  @override
  void initState() {
    super.initState();
    _loadBusData();
  }
  
  Future<void> _loadBusData() async {
    await Provider.of<BusProvider>(context, listen: false).fetchNearbyBuses();
    _updateMapData();
  }
  
  void _updateMapData() {
    final busProvider = Provider.of<BusProvider>(context, listen: false);
    
    setState(() {
      _markers = busProvider.buses.map((bus) {
        return Marker(
          markerId: MarkerId(bus.id),
          position: LatLng(bus.latitude, bus.longitude),
          infoWindow: InfoWindow(title: bus.routeName),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          onTap: () {
            setState(() {
              _selectedBus = bus;
            });
          },
        );
      }).toSet();
      
      // Add routes as polylines
      _polylines = busProvider.routes.map((route) {
        return Polyline(
          polylineId: PolylineId(route.id),
          points: route.coordinates.map((coord) => LatLng(coord.latitude, coord.longitude)).toList(),
          color: Colors.blue,
          width: 5,
        );
      }).toSet();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Bus Tracking'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadBusData,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (_selectedBus != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: BusInfoCard(
                bus: _selectedBus!,
                onClose: () {
                  setState(() {
                    _selectedBus = null;
                  });
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.directions_bus),
        onPressed: () {
          // Show route selection dialog
          _showRouteSelectionDialog();
        },
      ),
    );
  }
  
  void _showRouteSelectionDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final busProvider = Provider.of<BusProvider>(context);
        
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Route',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: busProvider.routes.length,
                  itemBuilder: (context, index) {
                    final route = busProvider.routes[index];
                    return ListTile(
                      title: Text(route.name),
                      subtitle: Text('${route.startPoint} - ${route.endPoint}'),
                      trailing: Text('${route.estimatedTime} min'),
                      onTap: () {
                        Navigator.pop(context);
                        // Focus map on selected route
                        _focusOnRoute(route.id);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> _focusOnRoute(String routeId) async {
    final busProvider = Provider.of<BusProvider>(context, listen: false);
    final route = busProvider.routes.firstWhere((r) => r.id == routeId);
    
    // Calculate bounds of the route
    if (route.coordinates.isNotEmpty) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          _calculateBounds(route.coordinates.map((c) => LatLng(c.latitude, c.longitude)).toList()),
          50, // padding
        ),
      );
    }
  }
  
  LatLngBounds _calculateBounds(List<LatLng> points) {
    double? minLat, maxLat, minLng, maxLng;
    
    for (LatLng point in points) {
      minLat = minLat == null ? point.latitude : min(minLat, point.latitude);
      maxLat = maxLat == null ? point.latitude : max(maxLat, point.latitude);
      minLng = minLng == null ? point.longitude : min(minLng, point.longitude);
      maxLng = maxLng == null ? point.longitude : max(maxLng, point.longitude);
    }
    
    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }
  
  double min(double a, double b) => a < b ? a : b;
  double max(double a, double b) => a > b ? a : b;
}
