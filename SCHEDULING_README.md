# Vista de Agendamiento - Flutter Dashboard

## Descripción

Esta implementación incluye una vista completa de agendamiento para Flutter que permite a los usuarios seleccionar fechas y horas para reservar citas. La vista está integrada con Firebase Authentication y Cloud Firestore.

## Características Implementadas

### ✅ Diseño
- Vista de calendario a pantalla completa usando `table_calendar`
- Calendario contenido dentro de un `WhiteCard` con estilo moderno
- Interfaz responsiva con diseño en dos columnas
- Estilo minimalista y sobrio con colores profesionales

### ✅ Funcionalidad
- Selección de fechas en el calendario
- Selección de horarios disponibles en intervalos de 30 minutos
- Formulario para crear reservas
- Validación de horarios ya reservados
- Lista de reservas del día seleccionado

### ✅ Integración Firebase
- Conexión con Cloud Firestore colección "reservas"
- Autenticación con Firebase Auth para obtener el correo del usuario
- Guardado automático de reservas con:
  - `fecha` (Timestamp)
  - `hora` (String)
  - `correo` (String del usuario autenticado)
  - `fechaCreacion` (Timestamp)

### ✅ Patrón de Estado
- Implementado con Provider/ChangeNotifier
- `SchedulingProvider` maneja todo el estado de la aplicación
- Separación clara de responsabilidades (MVVM)

## Archivos Creados/Modificados

### Nuevos Archivos
1. **`lib/providers/scheduling_provider.dart`** - Provider principal para manejo de estado
2. **`lib/ui/views/scheduling_view.dart`** - Vista principal del calendario y agendamiento

### Archivos Modificados
1. **`pubspec.yaml`** - Agregada dependencia `table_calendar: ^3.0.9`
2. **`lib/router/router.dart`** - Agregada ruta `/dashboard/scheduling`
3. **`lib/router/admin_handlers.dart`** - Agregado handler para la vista
4. **`lib/ui/shared/sidebar.dart`** - Agregado menú "Agendamiento" en el sidebar

## Estructura de Datos en Firestore

### Colección: `reservas`
```javascript
{
  "fecha": Timestamp,          // Fecha de la reserva
  "hora": "14:30",            // Hora en formato HH:mm
  "correo": "user@email.com", // Email del usuario autenticado
  "fechaCreacion": Timestamp  // Timestamp de cuando se creó la reserva
}
```

## Componentes de la Vista

### 1. _CalendarWidget
- Calendario principal usando `TableCalendar`
- Muestra marcadores en días con reservas
- Permite seleccionar fechas futuras únicamente
- Estilo personalizado con colores de marca

### 2. _TimeSelectionWidget
- Grid de horarios disponibles (09:00 - 17:30)
- Intervalos de 30 minutos
- Muestra horarios ocupados en rojo
- Botón para crear reserva

### 3. _ReservationsListWidget
- Lista de reservas del día seleccionado
- Opción para eliminar reservas
- Estados de carga y vacío

## Estilo y Tema

### Colores Utilizados
```dart
Color(0xFF3498DB)  // Azul principal (selecciones)
Color(0xFF27AE60)  // Verde (botones de acción)
Color(0xFFE74C3C)  // Rojo (errores/ocupado)
Color(0xFF2C3E50)  // Texto principal
Color(0xFF7F8C8D)  // Texto secundario
Color(0xFFECF0F1)  // Fondo claro
Color(0xFFF8F9FA)  // Fondo de página
```

### Tipografía
- Google Fonts Roboto para toda la interfaz
- Pesos variables según importancia del texto

## Instalación y Uso

### 1. Dependencias
Asegúrate de que tu `pubspec.yaml` incluya:
```yaml
dependencies:
  table_calendar: ^3.0.9
  cloud_firestore: ^5.6.0
  firebase_auth: ^5.0.0
  provider: ^6.1.5
  google_fonts: ^6.2.1
```

### 2. Configuración Firebase
- Asegúrate de tener Firebase configurado en tu proyecto
- Cloud Firestore habilitado
- Firebase Authentication configurado

### 3. Navegación
La vista está disponible en la ruta `/dashboard/scheduling` y se puede acceder desde el menú lateral "Agendamiento".

### 4. Permisos Firestore
Asegúrate de que tus reglas de Firestore permitan leer y escribir en la colección `reservas`:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /reservas/{document} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Uso de la Vista

### Flujo de Usuario
1. **Seleccionar Fecha**: Click en cualquier fecha del calendario
2. **Elegir Hora**: Click en un horario disponible (no marcado en rojo)
3. **Crear Reserva**: Click en "Reservar Cita"
4. **Confirmación**: La reserva se guarda automáticamente
5. **Visualización**: La reserva aparece en la lista del día

### Validaciones
- No se pueden seleccionar fechas pasadas
- No se pueden reservar horarios ya ocupados
- Usuario debe estar autenticado
- Validación de horarios disponibles en tiempo real

## Funcionalidades Administrativas

### Eliminar Reservas
Los usuarios pueden eliminar reservas haciendo click en el ícono de papelera junto a cada reserva en la lista.

### Carga en Tiempo Real
Las reservas se cargan automáticamente al abrir la vista y se actualizan después de cada operación.

## Estados de la Aplicación

### Loading States
- Indicador de carga al crear/eliminar reservas
- Indicador de carga al cargar lista de reservas

### Empty States
- Mensaje cuando no hay reservas para el día seleccionado
- Iconografía apropiada para estados vacíos

### Error Handling
- Notificaciones de error usando `NotificationsService`
- Manejo de errores de red y Firebase

## Responsive Design

La vista está optimizada para:
- **Desktop**: Layout de dos columnas (calendario + panel lateral)
- **Tablet**: Se mantiene el layout pero con espaciado ajustado
- **Mobile**: El diseño se adapta automáticamente con el sistema de Flutter

## Extensibilidad

### Funciones Adicionales Posibles
1. **Filtros por usuario**: Ver solo las reservas del usuario actual
2. **Notificaciones**: Recordatorios de citas próximas
3. **Recurrencia**: Reservas que se repiten semanalmente
4. **Duración variable**: Citas de diferentes duraciones
5. **Categorías**: Diferentes tipos de citas con colores

### Personalización de Horarios
Los horarios están definidos en `_TimeSelectionWidget.timeSlots` y se pueden modificar fácilmente:

```dart
final List<String> timeSlots = [
  '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
  // Agregar/quitar horarios según necesidad
];
```

## Testing

Para probar la funcionalidad:
1. Inicia el proyecto con `flutter run`
2. Autentícate en la aplicación
3. Navega a "Agendamiento" en el menú lateral
4. Selecciona una fecha y hora
5. Crea una reserva
6. Verifica que aparezca en la lista y en Firestore

## Soporte

La implementación es compatible con:
- Flutter 3.8.1+
- Firebase SDK más reciente
- Web, iOS, Android
- Dart 3.0+

## Notas Importantes

- La vista requiere autenticación activa
- Los horarios se muestran en formato 24 horas
- Las fechas se guardan en UTC en Firestore
- El sistema previene reservas duplicadas automáticamente
