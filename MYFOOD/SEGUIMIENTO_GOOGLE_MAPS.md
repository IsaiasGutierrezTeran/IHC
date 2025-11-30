# Configuración de Google Maps para Seguimiento en Tiempo Real

## 📍 Características Implementadas

- ✅ Seguimiento GPS en tiempo real de la moto de reparto
- ✅ Visualización en Google Maps
- ✅ Conexión Socket.IO para envío/recepción de ubicaciones
- ✅ Polilínea mostrando la ruta recorrida
- ✅ Cálculo de distancia y velocidad en tiempo real
- ✅ Permisos de ubicación configurados
- ✅ Marcadores para ubicación actual y destino

## 🔑 Configurar Google Maps API Key

### Paso 1: Obtener API Key de Google Cloud

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita las siguientes APIs:
   - **Maps SDK for Android**
   - **Geolocation API**
4. Ve a **Credenciales** → **Crear credenciales** → **Clave de API**
5. Copia la API Key generada

### Paso 2: Agregar la API Key al proyecto

Abre el archivo `android/app/src/main/AndroidManifest.xml` y reemplaza:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="TU_API_KEY_DE_GOOGLE_MAPS_AQUI"/>
```

Por tu API Key real:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSy...tu_clave_aqui"/>
```

### Paso 3: Restringir la API Key (Recomendado para producción)

En Google Cloud Console:
1. Edita tu API Key
2. En **Restricciones de aplicación**, selecciona **Apps de Android**
3. Agrega el nombre del paquete: `com.example.myfood`
4. Agrega tu huella digital SHA-1 (obtén con `keytool -list -v -keystore ~/.android/debug.keystore`)

## 🔌 Configurar Servidor Socket.IO

### Actualizar URL del servidor

En el archivo `lib/pages/ubicacion.dart`, línea ~155, actualiza la URL de tu servidor:

```dart
_socket = IO.io('http://tu-servidor.com:3000', <String, dynamic>{
  'transports': ['websocket'],
  'autoConnect': true,
});
```

### Eventos Socket.IO disponibles

**Emitir (desde la app):**
- `delivery-location`: Envía ubicación del repartidor
  ```dart
  {
    'latitude': double,
    'longitude': double,
    'timestamp': string (ISO8601),
    'speed': double,
    'heading': double
  }
  ```

**Escuchar (desde el servidor):**
- `location-update`: Recibe ubicación del cliente/restaurante
  ```dart
  {
    'latitude': double,
    'longitude': double
  }
  ```

### Ejemplo de servidor Node.js con Socket.IO

```javascript
const express = require('express');
const app = express();
const http = require('http').createServer(app);
const io = require('socket.io')(http);

io.on('connection', (socket) => {
  console.log('Cliente conectado:', socket.id);

  // Recibir ubicación del repartidor
  socket.on('delivery-location', (data) => {
    console.log('Ubicación del repartidor:', data);
    
    // Retransmitir a otros clientes (restaurante, cliente)
    socket.broadcast.emit('driver-location-update', data);
  });

  socket.on('disconnect', () => {
    console.log('Cliente desconectado:', socket.id);
  });
});

http.listen(3000, () => {
  console.log('Servidor Socket.IO corriendo en puerto 3000');
});
```

## 📱 Instalación y Ejecución

### 1. Instalar dependencias

```bash
cd "d:\PACK DE LA FICCT\IHC\MYFOOD"
flutter pub get
```

### 2. Verificar dispositivos disponibles

```bash
flutter devices
```

### 3. Ejecutar la aplicación

```bash
flutter run -d emulator-5554
```

O usa el dispositivo conectado.

## 🎯 Cómo usar el seguimiento

1. Desde el **Dashboard** del repartidor, ve a **"Mis Pedidos"**
2. Selecciona un pedido activo
3. Presiona el botón **"Seguimiento"** (naranja)
4. La app solicitará permisos de ubicación (acepta)
5. El mapa se abrirá mostrando:
   - 📍 Marcador naranja: Tu ubicación actual
   - 📍 Marcador rojo: Ubicación del destino
   - 🔴 Línea naranja: Ruta recorrida
   - 📊 Panel superior: Estado de conexión, velocidad y distancia

## 🔐 Permisos Configurados

### Android (AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
```

La aplicación solicitará estos permisos automáticamente en tiempo de ejecución.

## 📦 Dependencias Agregadas

```yaml
dependencies:
  google_maps_flutter: ^2.5.0  # Mapas de Google
  geolocator: ^10.1.0          # Servicios de ubicación GPS
  permission_handler: ^11.0.1   # Manejo de permisos
  socket_io_client: ^2.0.3+1   # Comunicación en tiempo real
```

## 🐛 Solución de Problemas

### El mapa no se muestra
- Verifica que agregaste correctamente la API Key en AndroidManifest.xml
- Asegúrate de habilitar "Maps SDK for Android" en Google Cloud Console

### "Location services disabled"
- En el emulador, activa la ubicación: Settings → Location → Enable
- O usa coordenadas simuladas: Settings → Developer options → Mock locations

### Socket.IO no conecta
- Verifica que la URL del servidor sea correcta
- Si usas localhost, reemplaza por la IP de tu computadora (no 127.0.0.1)
- Para emulador Android: usa `http://10.0.2.2:3000` en lugar de localhost

### Permisos denegados
- La app mostrará un diálogo para ir a configuración
- Manualmente: Settings → Apps → MyFood → Permissions → Location → Allow all the time

## 🚀 Próximos Pasos

- [ ] Agregar estimación de tiempo de llegada (ETA)
- [ ] Notificaciones push cuando el repartidor está cerca
- [ ] Geocodificación inversa para mostrar direcciones
- [ ] Modo offline con almacenamiento de ruta
- [ ] Compartir enlace de seguimiento con el cliente

## 📝 Notas Importantes

- **Consumo de batería**: El seguimiento GPS continuo consume batería. Considera ajustar `distanceFilter` en línea 186.
- **Privacidad**: El seguimiento solo está activo mientras la pantalla está abierta.
- **Producción**: Recuerda restringir tu API Key en Google Cloud Console antes de publicar.

---

**Desarrollado para MyFood Delivery** 🍔🏍️
