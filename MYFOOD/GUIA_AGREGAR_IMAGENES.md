# 📸 Guía: Agregar y Personalizar Fotos de Productos

## ✅ Ya Implementado
He agregado **imágenes de productos** a todas las tarjetas de órdenes:
- ✅ Órdenes pendientes
- ✅ Órdenes activas
- ✅ Órdenes completadas

---

## 🎯 Dónde está el código de la imagen

**Archivo:** `lib/screens/delivery_orders_screen.dart`

### Código de la imagen (líneas ~170-185):
```dart
// Imagen del producto
if (order.items.isNotEmpty)
  ClipRRect(
    borderRadius: BorderRadius.circular(8),  // ← Bordes redondeados
    child: Container(
      width: double.infinity,  // ← Ancho 100%
      height: 150,  // ← AQUÍ: Cambiar altura de la imagen
      color: AppColors.primaryLight,  // ← Color de fondo si no carga
      child: Image.network(
        order.items.first.food.imageUrl,  // ← URL de la imagen
        fit: BoxFit.cover,  // ← Cómo se ajusta la imagen
        errorBuilder: (context, error, stackTrace) {
          return Container(  // ← Lo que muestra si hay error
            color: AppColors.primaryLight,
            child: Icon(
              Icons.restaurant,
              size: 60,
              color: AppColors.secondary,
            ),
          );
        },
      ),
    ),
  ),
```

---

## 🔧 Cómo personalizar

### 1️⃣ **Cambiar altura de la imagen**
```dart
height: 200,  // Cambiar de 150 a 200 (más grande)
```

### 2️⃣ **Cambiar cómo se ajusta la imagen**
```dart
fit: BoxFit.cover,  // Opciones:
  // cover = rellena y recorta
  // contain = encaja completa sin recortar
  // fill = rellena sin mantener proporción
  // fitWidth = ajusta al ancho
  // fitHeight = ajusta al alto
```

### 3️⃣ **Cambiar bordes redondeados**
```dart
borderRadius: BorderRadius.circular(16),  // Aumentar de 8 a 16
```

### 4️⃣ **Cambiar color de fondo**
```dart
color: Colors.grey[200],  // En lugar de AppColors.primaryLight
```

### 5️⃣ **Cambiar ícono si no carga la imagen**
```dart
Icon(
  Icons.fastfood,  // Otros iconos: restaurant, local_dining, room_service
  size: 80,  // Tamaño del ícono
  color: AppColors.secondary,
),
```

---

## 🖼️ Cómo agregar URLs de imágenes

La imagen viene de: `order.items.first.food.imageUrl`

Esto significa que vienen de tus datos en **`DeliveryController`** o **`Food` model**.

### Actualizar la URL de imagen en el controlador:

**Archivo:** `lib/controllers/delivery_controller.dart`

```dart
final mockFood = Food(
  id: '1',
  name: 'Shake de Frutilla',
  description: 'Delicioso shake casero',
  price: 20.00,
  imageUrl: 'https://via.placeholder.com/200',  // ← AQUÍ: Cambiar URL
  category: 'Bebidas',
  rating: 4.5,
  preparationTime: 10,
);
```

### Ejemplos de URLs de imágenes:

**Placeholder (para testing):**
```dart
imageUrl: 'https://via.placeholder.com/400x300?text=Shake+Frutilla',
```

**Imágenes reales (Unsplash):**
```dart
// Batidos
imageUrl: 'https://images.unsplash.com/photo-1553530666-ba2a8e36cd12?w=400',

// Hamburguesas
imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',

// Pizza
imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07f4ee?w=400',

// Comida China
imageUrl: 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=400',

// Ensaladas
imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
```

---

## 💡 Ejemplo completo de personalización

### Hacer imagen más grande con bordes más curvos:

En `lib/screens/delivery_orders_screen.dart`, función `_buildPendingOrderCard()`:

```dart
// Imagen del producto
if (order.items.isNotEmpty)
  ClipRRect(
    borderRadius: BorderRadius.circular(16),  // ← 16 en lugar de 8
    child: Container(
      width: double.infinity,
      height: 200,  // ← 200 en lugar de 150
      color: AppColors.primaryLight,
      child: Image.network(
        order.items.first.food.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.fastfood,
              size: 80,
              color: AppColors.secondary,
            ),
          );
        },
      ),
    ),
  ),
```

---

## 🎨 Agregar sombra a la imagen (bonus)

Si quieres agregar sombra para que resalte:

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Container(
      width: double.infinity,
      height: 200,
      color: AppColors.primaryLight,
      child: Image.network(
        order.items.first.food.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.primaryLight,
            child: Icon(
              Icons.restaurant,
              size: 60,
              color: AppColors.secondary,
            ),
          );
        },
      ),
    ),
  ),
),
```

---

## ⚡ Para probar en la app

1. Abre un terminal
2. Presiona `r` para Hot Reload
3. Los cambios aparecerán **instantáneamente** sin recompilar

¡Las imágenes aparecerán en la parte superior de cada tarjeta de pedido! 🎉
