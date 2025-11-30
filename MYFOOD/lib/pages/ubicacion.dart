import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../utils/app_theme.dart';

class UbicacionScreen extends StatefulWidget {
  const UbicacionScreen({super.key});

  @override
  State<UbicacionScreen> createState() => _UbicacionScreenState();
}

class _UbicacionScreenState extends State<UbicacionScreen> {
  GoogleMapController? _mapController;
  IO.Socket? _socket;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _routeCoordinates = [];
  
  // Ubicación inicial (La Paz, Bolivia como ejemplo)
  final LatLng _initialPosition = const LatLng(-16.5000, -68.1500);
  
  bool _isLoading = true;
  String _statusMessage = 'Iniciando seguimiento...';
  double _totalDistance = 0.0;
  
  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }
  
  @override
  void dispose() {
    _positionStream?.cancel();
    _socket?.disconnect();
    _mapController?.dispose();
    super.dispose();
  }
  
  Future<void> _initializeTracking() async {
    try {
      // Solicitar permisos de ubicación
      final permissionStatus = await _requestLocationPermission();
      
      if (!permissionStatus) {
        setState(() {
          _statusMessage = 'Permiso de ubicación denegado';
          _isLoading = false;
        });
        return;
      }
      
      // Obtener ubicación actual
      await _getCurrentLocation();
      
      // Inicializar Socket.IO
      _initializeSocket();
      
      // Comenzar seguimiento en tiempo real
      _startLocationTracking();
      
      setState(() {
        _isLoading = false;
        _statusMessage = 'Seguimiento activo';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error al iniciar seguimiento: $e';
        _isLoading = false;
      });
    }
  }
  
  Future<bool> _requestLocationPermission() async {
    final status = await Permission.location.request();
    
    if (status.isDenied || status.isPermanentlyDenied) {
      // Mostrar diálogo para abrir configuración
      _showPermissionDialog();
      return false;
    }
    
    return status.isGranted;
  }
  
  void _showPermissionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Permiso de Ubicación Requerido'),
        content: const Text(
          'Esta aplicación necesita acceso a tu ubicación para el seguimiento en tiempo real. '
          '¿Deseas abrir la configuración?'
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              openAppSettings();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
            ),
            child: const Text('Abrir Configuración'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _currentPosition = position;
        _addMarker(
          LatLng(position.latitude, position.longitude),
          'current',
          'Mi Ubicación',
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        );
      });
      
      // Centrar mapa en ubicación actual
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            16.0,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error obteniendo ubicación: $e');
    }
  }
  
  void _initializeSocket() {
    // Configurar conexión Socket.IO
    // IMPORTANTE: Reemplaza con la URL de tu servidor
    _socket = IO.io('https://sq4xxc3p-3000.brs.devtunnels.ms/tracking', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    
    _socket!.onConnect((_) {
      debugPrint('Socket conectado');
      setState(() {
        _statusMessage = 'Conectado al servidor';
      });
    });
    
    _socket!.onDisconnect((_) {
      debugPrint('Socket desconectado');
      setState(() {
        _statusMessage = 'Desconectado del servidor';
      });
    });
    
    _socket!.on('error', (data) {
      debugPrint('Socket error: $data');
    });
    
    // Escuchar actualizaciones de ubicación del cliente/restaurante
    _socket!.on('location-update', (data) {
      if (data != null && data['latitude'] != null && data['longitude'] != null) {
        _updateDestinationMarker(
          LatLng(data['latitude'], data['longitude']),
        );
      }
    });
  }
  
  void _startLocationTracking() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Actualizar cada 10 metros
    );
    
    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _updateLocation(position);
    });
  }
  
  void _updateLocation(Position position) {
    setState(() {
      _currentPosition = position;
      
      // Actualizar marcador de ubicación actual
      _addMarker(
        LatLng(position.latitude, position.longitude),
        'current',
        'Mi Ubicación',
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      );
      
      // Agregar punto a la ruta
      final newPoint = LatLng(position.latitude, position.longitude);
      _routeCoordinates.add(newPoint);
      
      // Calcular distancia
      if (_routeCoordinates.length > 1) {
        final lastPoint = _routeCoordinates[_routeCoordinates.length - 2];
        _totalDistance += Geolocator.distanceBetween(
          lastPoint.latitude,
          lastPoint.longitude,
          newPoint.latitude,
          newPoint.longitude,
        ) / 1000; // Convertir a kilómetros
      }
      
      // Actualizar polilínea de la ruta
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: _routeCoordinates,
          color: AppColors.secondary,
          width: 5,
        ),
      );
      
      // Enviar ubicación al servidor via Socket.IO
      _socket?.emit('driver_location_update', {
        'driverId': 1,
        'lat': position.latitude,
        'lng': position.longitude,
        'heading': position.heading,
      });
    });
    
    // Centrar mapa en ubicación actual
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );
  }
  
  void _addMarker(LatLng position, String id, String title, BitmapDescriptor icon) {
    _markers.removeWhere((marker) => marker.markerId.value == id);
    _markers.add(
      Marker(
        markerId: MarkerId(id),
        position: position,
        infoWindow: InfoWindow(title: title),
        icon: icon,
      ),
    );
  }
  
  void _updateDestinationMarker(LatLng position) {
    setState(() {
      _addMarker(
        position,
        'destination',
        'Destino',
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seguimiento en Tiempo Real',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary, size: 28),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.secondary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _statusMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.mediumGrey,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // Mapa de Google
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition != null
                        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                        : _initialPosition,
                    zoom: 16.0,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                ),
                
                // Panel de información
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _statusMessage,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoItem(
                              Icons.speed,
                              'Velocidad',
                              _currentPosition != null
                                  ? '${_currentPosition!.speed.toStringAsFixed(1)} m/s'
                                  : '0 m/s',
                            ),
                            _buildInfoItem(
                              Icons.straighten,
                              'Distancia',
                              '${_totalDistance.toStringAsFixed(2)} km',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Botón para centrar mapa
                Positioned(
                  right: 16,
                  bottom: 100,
                  child: FloatingActionButton(
                    backgroundColor: AppColors.secondary,
                    onPressed: () {
                      if (_currentPosition != null) {
                        _mapController?.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                            16.0,
                          ),
                        );
                      }
                    },
                    child: const Icon(Icons.my_location, color: Colors.white),
                  ),
                ),
              ],
            ),
    );
  }
  
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.mediumGrey),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.mediumGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
      ],
    );
  }
}
