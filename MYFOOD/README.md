# MyFood - Aplicación de Pedidos de Comida

Una aplicación Flutter moderna para pedir comida en línea, similar a PedidosYa, con listado de menú, carrito de compras, sistema de pago mockup y seguimiento de pedidos en tiempo real.

## 🎯 Características

- **Menú de Restaurante**: Listado completo de comidas con categorías y búsqueda
- **Carrito de Compras**: Agregar, eliminar y actualizar cantidades de productos
- **Sistema de Pago**: Formulario de pago mockup con validación de datos
- **Seguimiento de Pedido**: Rastreo en tiempo real del estado del pedido
- **Interfaz Moderna**: Diseño Material Design 3 con colores atractivos
- **Gestión de Estado**: Utiliza GetX para manejo eficiente del estado

## 📋 Requisitos

- Flutter SDK (versión 3.9.2 o superior)
- Dart SDK

## 🚀 Instalación

1. **Clonar o descargar el proyecto**
```bash
cd myfood
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Ejecutar la aplicación**
```bash
flutter run
```

## 📦 Dependencias Principales

- **get**: Gestión de estado y navegación
- **intl**: Internacionalización y formateo de fechas

## 📂 Estructura del Proyecto

```
lib/
├── controllers/       # Lógica de negocio (GetX controllers)
│   ├── menu_controller.dart
│   ├── cart_controller.dart
│   └── order_controller.dart
├── models/            # Modelos de datos
│   ├── food_model.dart
│   ├── cart_item_model.dart
│   └── order_model.dart
├── screens/           # Pantallas principales
│   ├── home_screen.dart
│   ├── cart_screen.dart
│   ├── checkout_screen.dart
│   └── tracking_screen.dart
├── widgets/           # Widgets reutilizables
│   ├── food_card.dart
│   └── order_status_indicator.dart
├── utils/             # Utilidades y helpers
└── main.dart          # Punto de entrada de la aplicación
```

## 🛣️ Navegación

La aplicación cuenta con 4 pantallas principales:

1. **Home Screen** (`/`): 
   - Listado de comidas
   - Búsqueda por nombre
   - Filtrado por categorías
   - Botón de carrito

2. **Cart Screen** (`/cart`):
   - Lista de items en el carrito
   - Modificar cantidades
   - Cálculo de totales (subtotal, envío, impuesto)
   - Botón para ir al checkout

3. **Checkout Screen** (`/checkout`):
   - Formulario de datos de entrega
   - Información de dirección y teléfono
   - Formulario de pago (tarjeta)
   - Confirmación de orden

4. **Tracking Screen** (`/tracking`):
   - Estado actual del pedido
   - Timeline de seguimiento
   - Información de entrega
   - Resumen de la orden

## 🍕 Datos Mock

La aplicación incluye datos de ejemplo con:
- 10 productos de comida variados
- Categorías diferentes
- Información de precios, ratings y tiempo de preparación

## 💡 Características Técnicas

### GetX Benefits
- Gestión reactiva del estado sin BuildContext
- Navegación simplificada con rutas nombradas
- Inyección de dependencias automática
- Performance optimizado

### Validación de Formularios
- Validación de campos requeridos
- Formato de teléfono y dirección
- Validación de datos de tarjeta de crédito

### Simulación de Estado del Pedido
- Los pedidos avanzan automáticamente de estado cada 8 segundos
- Estados: Confirmado → Preparando → En camino → Entregado

## 🎨 Tema de Colores

- **Color Primario**: Orange (`Colors.orange`)
- **Fondo**: Blanco
- **Acentos**: Verde para confirmaciones, Rojo para cancelaciones

## 📱 Plataformas Soportadas

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🔧 Comandos Útiles

```bash
# Ejecutar la app
flutter run

# Ejecutar en modo release
flutter run --release

# Generar APK
flutter build apk

# Generar IPA (iOS)
flutter build ios

# Ejecutar análisis de código
flutter analyze

# Ejecutar tests
flutter test
```

## 📝 Notas de Desarrollo

- Los datos de pedidos están almacenados en memoria
- El pago es un mockup - no procesa pagos reales
- Las imágenes están reemplazadas por emojis

## 🚀 Mejoras Futuras

- [ ] Integración con API backend
- [ ] Autenticación de usuarios
- [ ] Historial de pedidos persistente
- [ ] Integración con pasarelas de pago reales
- [ ] Mapas para seguimiento en vivo

---

**MyFood** - Hecho con ❤️ usando Flutter
