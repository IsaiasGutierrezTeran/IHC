# 📋 Guía de Modificación - Tarjetas de Pedidos Pendientes

## Ubicación del archivo
`lib/screens/delivery_orders_screen.dart` - Función: `_buildPendingOrderCard()` (líneas ~156-230)

---

## 🎨 Áreas que puedes modificar:

### 1. **CONTENEDOR PRINCIPAL** (Card - línea ~160)
```dart
Card(
  margin: const EdgeInsets.only(bottom: 12),  // ← Espacio entre tarjetas
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),  // ← Bordes redondeados
  child: Padding(
    padding: const EdgeInsets.all(16),  // ← Espaciado interno
```
**Modificar:**
- `margin` - Cambiar espaciado entre tarjetas
- `borderRadius` - Cambiar curvatura de esquinas
- `padding` - Cambiar espaciado interno

---

### 2. **HEADER - ID y Precio** (líneas ~167-178)
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      'Orden #${order.id}',
      style: TextStyles.heading3,  // ← Tamaño y estilo del título
    ),
    Text(
      '\$${order.total.toStringAsFixed(2)}',
      style: TextStyles.price,  // ← Color y estilo del precio
    ),
  ],
),
```
**Modificar:**
- `TextStyles.heading3` - Cambiar tamaño/fuente del ID de orden
- `TextStyles.price` - Cambiar color/tamaño del precio
- Agregar más información (fecha, estado, etc.)

---

### 3. **CAJA DE ITEMS** (líneas ~181-194)
```dart
Container(
  padding: const EdgeInsets.all(12),  // ← Espaciado dentro de la caja
  decoration: BoxDecoration(
    color: AppColors.primaryLight,  // ← Color amarillo #FEF3D9
    borderRadius: BorderRadius.circular(8),  // ← Curvatura
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: order.items.map((item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          '${item.food.name} x${item.quantity}',
          style: TextStyles.bodySmall,  // ← Tamaño de texto
        ),
      );
    }).toList(),
  ),
),
```
**Modificar:**
- `color: AppColors.primaryLight` - Cambiar color de fondo
- `borderRadius` - Cambiar curvatura
- `TextStyles.bodySmall` - Cambiar tamaño/estilo del texto
- Agregar precios individuales, imagen del producto, etc.

---

### 4. **DIRECCIÓN** (líneas ~197-206)
```dart
Row(
  children: [
    const Icon(Icons.location_on, color: AppColors.secondary, size: 20),  // ← Icono y color
    const SizedBox(width: 8),  // ← Espacio entre icono y texto
    Expanded(
      child: Text(
        order.deliveryAddress,
        style: TextStyles.bodySmall,  // ← Estilo del texto
        maxLines: 2,  // ← Máximo de líneas
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ],
),
```
**Modificar:**
- `Icons.location_on` - Cambiar icono
- `color: AppColors.secondary` - Cambiar color del icono
- `size: 20` - Cambiar tamaño del icono
- `maxLines: 2` - Cambiar cuántas líneas muestra
- `TextStyles.bodySmall` - Cambiar estilo del texto

---

### 5. **TELÉFONO** (líneas ~208-215)
```dart
Row(
  children: [
    const Icon(Icons.phone, color: AppColors.secondary, size: 20),  // ← Icono y color
    const SizedBox(width: 8),
    Text(
      order.phoneNumber,
      style: TextStyles.bodySmall,  // ← Estilo del texto
    ),
  ],
),
```
**Modificar:**
- Icono, color, tamaño (igual que dirección)
- Agregar botón para llamar
- Agregar botón para WhatsApp

---

### 6. **BOTONES** (líneas ~219-238)
```dart
Row(
  children: [
    Expanded(
      child: ElevatedButton(
        onPressed: () => controller.rejectOrder(order),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,  // ← Color del botón Rechazar
        ),
        child: const Text('Rechazar'),
      ),
    ),
    const SizedBox(width: 12),  // ← Espacio entre botones
    Expanded(
      child: ElevatedButton(
        onPressed: () => controller.acceptOrder(order),
        child: const Text('Aceptar'),  // ← Color por defecto (AppColors.secondary)
      ),
    ),
  ],
),
```
**Modificar:**
- `backgroundColor: Colors.grey` - Color del botón Rechazar
- `const SizedBox(width: 12)` - Espacio entre botones
- Textos de los botones
- Tamaño de los botones
- Agregar más botones

---

## 💡 EJEMPLOS DE PERSONALIZACIÓN:

### Ejemplo 1: Hacer los botones más grandes
```dart
Expanded(
  child: ElevatedButton(
    onPressed: () => controller.rejectOrder(order),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey,
      padding: const EdgeInsets.symmetric(vertical: 16),  // ← Más alto
    ),
    child: const Text('Rechazar', style: TextStyle(fontSize: 16)),  // ← Texto más grande
  ),
),
```

### Ejemplo 2: Cambiar color del botón Aceptar a rojo
```dart
child: ElevatedButton(
  onPressed: () => controller.acceptOrder(order),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,  // ← Cambiar color
  ),
  child: const Text('Aceptar'),
),
```

### Ejemplo 3: Agregar ícono en el botón
```dart
child: ElevatedButton.icon(
  onPressed: () => controller.acceptOrder(order),
  icon: const Icon(Icons.check),
  label: const Text('Aceptar'),
),
```

### Ejemplo 4: Cambiar color de la caja de items
```dart
decoration: BoxDecoration(
  color: Color(0xFFE8F5E9),  // ← Verde claro en lugar de amarillo
  borderRadius: BorderRadius.circular(8),
),
```

---

## 🎯 COLORES DISPONIBLES (AppColors):
- **primary**: #F5CB58 (Amarillo)
- **secondary**: #E95322 (Naranja/Rojo)
- **primaryLight**: #FEF3D9 (Amarillo claro)
- **secondaryLight**: #FFEAE0 (Naranja claro)
- **white**: #FFFFFF
- **darkGrey**: #333333
- **mediumGrey**: #666666
- **lightGrey**: #F5F5F5
- **success**: #4CAF50 (Verde)

---

## 📍 FLUJO RÁPIDO PARA EDITAR:
1. Abre: `lib/screens/delivery_orders_screen.dart`
2. Busca: Función `_buildPendingOrderCard()` 
3. Modifica los valores en el código anterior
4. Guarda (Ctrl+S)
5. La app recargará automáticamente con los cambios (Hot Reload: presiona `r` en terminal)
