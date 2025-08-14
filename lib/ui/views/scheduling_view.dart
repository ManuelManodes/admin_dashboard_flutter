import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_dashboard/ui/cards/white_card.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';
import 'package:admin_dashboard/ui/shared/responsive_utils.dart';
import 'package:admin_dashboard/providers/scheduling_provider.dart';

class SchedulingView extends StatelessWidget {
  const SchedulingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Agendamiento de Citas', style: CustomLabels.h1),
          SizedBox(height: 20),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (ResponsiveUtils.isLargeScreen(context)) {
      // Layout para pantallas grandes: Calendario arriba + Hora y Reservas abajo (50/50)
      return Column(
        children: [
          WhiteCard(
            title: 'Seleccionar Fecha',
            child: SizedBox(height: 400, child: _CalendarWidget()),
          ),
          SizedBox(height: 20),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: WhiteCard(
                    title: 'Seleccionar Hora',
                    child: SizedBox(height: 350, child: _TimeSelectionWidget()),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: WhiteCard(
                    title: 'Reservas del Día',
                    child: SizedBox(
                      height: 350,
                      child: _ReservationsListWidget(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (ResponsiveUtils.isMediumScreen(context)) {
      // Layout para pantallas medianas: Calendario arriba + Hora y Reservas abajo
      return Column(
        children: [
          WhiteCard(
            title: 'Seleccionar Fecha',
            child: SizedBox(height: 380, child: _CalendarWidget()),
          ),
          SizedBox(height: 20),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: WhiteCard(
                    title: 'Seleccionar Hora',
                    child: SizedBox(height: 380, child: _TimeSelectionWidget()),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: WhiteCard(
                    title: 'Reservas del Día',
                    child: SizedBox(
                      height: 380,
                      child: _ReservationsListWidget(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // Layout para pantallas pequeñas: Diseño compacto pero funcional
      return Column(
        children: [
          WhiteCard(
            title: 'Seleccionar Fecha',
            child: SizedBox(height: 360, child: _CalendarWidget()),
          ),
          SizedBox(height: 15),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: WhiteCard(
                    title: 'Seleccionar Hora',
                    child: SizedBox(height: 350, child: _TimeSelectionWidget()),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: WhiteCard(
                    title: 'Reservas del Día',
                    child: SizedBox(
                      height: 350,
                      child: _ReservationsListWidget(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}

class _CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final effectiveWidth = ResponsiveUtils.getScreenWidth(context);

    return Consumer<SchedulingProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.all(effectiveWidth > 1000 ? 12.0 : 8.0),
          child: Column(
            children: [
              // Calendario expandible que usa todo el espacio disponible
              Expanded(
                child: TableCalendar<Map<String, dynamic>>(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(Duration(days: 365)),
                  focusedDay: provider.focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(provider.selectedDay, day);
                  },
                  eventLoader: (day) {
                    return provider.getReservationsForDay(day);
                  },
                  // Configuración responsiva más simple
                  rowHeight: effectiveWidth > 1000 ? 42 : 36,
                  daysOfWeekHeight: effectiveWidth > 1000 ? 30 : 26,
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    cellMargin: EdgeInsets.all(
                      effectiveWidth > 1000 ? 2.0 : 1.0,
                    ),
                    cellPadding: EdgeInsets.all(
                      effectiveWidth > 1000 ? 4.0 : 2.0,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFF3498DB),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: effectiveWidth > 1000 ? 13 : 11,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Color(0xFF95A5A6),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: effectiveWidth > 1000 ? 13 : 11,
                    ),
                    defaultTextStyle: GoogleFonts.roboto(
                      fontSize: effectiveWidth > 1000 ? 13 : 11,
                      color: Color(0xFF2C3E50),
                    ),
                    weekendTextStyle: GoogleFonts.roboto(
                      fontSize: effectiveWidth > 1000 ? 13 : 11,
                      color: Color(0xFF7F8C8D),
                    ),
                    markerDecoration: BoxDecoration(
                      color: Color(0xFFE74C3C),
                      shape: BoxShape.circle,
                    ),
                    markerSize: effectiveWidth > 1000 ? 4.0 : 3.0,
                    markerMargin: EdgeInsets.symmetric(horizontal: 0.5),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    headerPadding: EdgeInsets.symmetric(
                      vertical: effectiveWidth > 1000 ? 8.0 : 6.0,
                    ),
                    titleTextStyle: GoogleFonts.roboto(
                      fontSize: effectiveWidth > 1000 ? 16 : 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Color(0xFF3498DB),
                      size: effectiveWidth > 1000 ? 20 : 18,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Color(0xFF3498DB),
                      size: effectiveWidth > 1000 ? 20 : 18,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: GoogleFonts.roboto(
                      fontSize: effectiveWidth > 1000 ? 11 : 9,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7F8C8D),
                    ),
                    weekdayStyle: GoogleFonts.roboto(
                      fontSize: effectiveWidth > 1000 ? 11 : 9,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    provider.setSelectedDay(selectedDay);
                    provider.setFocusedDay(focusedDay);
                  },
                  onPageChanged: (focusedDay) {
                    provider.setFocusedDay(focusedDay);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimeSelectionWidget extends StatelessWidget {
  final List<String> timeSlots = [
    '09:00',
    '09:45',
    '10:30',
    '11:15',
    '12:00',
    '12:45',
    '13:30',
    '14:15',
    '15:00',
    '15:45',
    '16:30',
    '17:15',
  ];

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = ResponsiveUtils.getScreenWidth(context);

    // Determinar el número de columnas según el ancho efectivo
    int crossAxisCount = 2;
    if (ResponsiveUtils.isLargeScreen(context)) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    return Consumer<SchedulingProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calcular altura disponible para el grid de forma más conservadora
              final availableHeight = constraints.maxHeight;
              final inputSectionHeight = effectiveWidth > 1000
                  ? 140
                  : 130; // Más espacio para input + botón
              final paddingAndSpacing = 48; // SizedBox + paddings
              final gridHeight =
                  (availableHeight - inputSectionHeight - paddingAndSpacing)
                      .clamp(120.0, 280.0); // Altura mínima más pequeña

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Show loading indicator while data is being loaded
                  if (!provider.hasLoadedInitialData)
                    Container(
                      height: gridHeight,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Cargando horarios disponibles...',
                              style: GoogleFonts.roboto(
                                color: Color(0xFF7F8C8D),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    // Time slots grid with responsive layout
                    Container(
                      height: gridHeight,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: effectiveWidth > 1000 ? 2.8 : 2.5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: timeSlots.length,
                        itemBuilder: (context, index) {
                          final timeSlot = timeSlots[index];
                          final isReserved = provider.isTimeSlotReserved(
                            provider.selectedDay,
                            timeSlot,
                          );
                          final isSelected =
                              provider.selectedTime != null &&
                              '${provider.selectedTime!.hour.toString().padLeft(2, '0')}:${provider.selectedTime!.minute.toString().padLeft(2, '0')}' ==
                                  timeSlot;

                          return GestureDetector(
                            onTap: isReserved
                                ? null
                                : () {
                                    final timeParts = timeSlot.split(':');
                                    final hour = int.parse(timeParts[0]);
                                    final minute = int.parse(timeParts[1]);
                                    provider.setSelectedTime(
                                      TimeOfDay(hour: hour, minute: minute),
                                    );
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isReserved
                                    ? Color(0xFFE74C3C).withOpacity(0.1)
                                    : isSelected
                                    ? Color(0xFF3498DB)
                                    : Color(0xFFECF0F1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isReserved
                                      ? Color(0xFFE74C3C)
                                      : isSelected
                                      ? Color(0xFF3498DB)
                                      : Color(0xFFBDC3C7),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  timeSlot,
                                  style: GoogleFonts.roboto(
                                    fontSize: effectiveWidth > 1000 ? 14 : 12,
                                    fontWeight: FontWeight.w500,
                                    color: isReserved
                                        ? Color(0xFFE74C3C)
                                        : isSelected
                                        ? Colors.white
                                        : Color(0xFF2C3E50),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  SizedBox(height: 16),

                  // Phone input section - responsive layout con protección contra overflow
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Phone input with TextFormField
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: effectiveWidth > 1000 ? 12 : 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0xFFBDC3C7)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Color(0xFF3498DB),
                                size: effectiveWidth > 1000 ? 20 : 18,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  onChanged: (value) =>
                                      provider.setPhoneNumber(value),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: 'Número de teléfono',
                                    border: InputBorder.none,
                                    isDense: true,
                                    hintStyle: GoogleFonts.roboto(
                                      color: Color(0xFF7F8C8D),
                                      fontSize: effectiveWidth > 1000 ? 16 : 14,
                                    ),
                                  ),
                                  style: GoogleFonts.roboto(
                                    fontSize: effectiveWidth > 1000 ? 16 : 14,
                                    color: Color(0xFF2C3E50),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 12),

                        // Reserve button - responsive size con protección contra overflow
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 44,
                            maxHeight: effectiveWidth > 1000 ? 52 : 48,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  provider.isLoading ||
                                      provider.selectedTime == null ||
                                      provider.phoneNumber.trim().isEmpty
                                  ? null
                                  : () async {
                                      await provider.createReservation();
                                      // Provider handles success message
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    provider.isLoading ||
                                        provider.selectedTime == null ||
                                        provider.phoneNumber.trim().isEmpty
                                    ? Color(0xFFBDC3C7)
                                    : Color(0xFF27AE60),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shadowColor: Colors.black26,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: effectiveWidth > 1000 ? 12 : 8,
                                ),
                              ),
                              child: provider.isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.event_available,
                                          size: effectiveWidth > 1000 ? 18 : 16,
                                        ),
                                        SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            'Agendar Cita',
                                            style: GoogleFonts.roboto(
                                              fontSize: effectiveWidth > 1000
                                                  ? 16
                                                  : 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _ReservationsListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Usar el ancho efectivo (mínimo 900px)
    final effectiveWidth = MediaQuery.of(context).size.width < 900
        ? 900
        : MediaQuery.of(context).size.width;

    return Consumer<SchedulingProvider>(
      builder: (context, provider, child) {
        final reservations = provider.getReservationsForDay(
          provider.selectedDay,
        );

        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFF3498DB)),
          );
        }

        if (reservations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_available_outlined,
                  size: effectiveWidth > 1000 ? 48 : 40,
                  color: Color(0xFF3498DB),
                ),
                SizedBox(height: effectiveWidth > 1000 ? 16 : 12),
                Text(
                  'Sin reservas',
                  style: GoogleFonts.roboto(
                    fontSize: effectiveWidth > 1000 ? 18 : 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  'No hay citas programadas para este día',
                  style: GoogleFonts.roboto(
                    fontSize: effectiveWidth > 1000 ? 16 : 14,
                    color: Color(0xFF7F8C8D),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(effectiveWidth > 1000 ? 16 : 12),
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index];
            return Container(
              margin: EdgeInsets.only(bottom: effectiveWidth > 1000 ? 12 : 8),
              padding: EdgeInsets.all(effectiveWidth > 1000 ? 16 : 12),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFE9ECEF)),
                boxShadow: effectiveWidth > 1000
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: effectiveWidth > 1000 ? 10 : 8,
                    height: effectiveWidth > 1000 ? 10 : 8,
                    decoration: BoxDecoration(
                      color: Color(0xFF27AE60),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: effectiveWidth > 1000 ? 16 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reservation['hora'],
                          style: GoogleFonts.roboto(
                            fontSize: effectiveWidth > 1000 ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          reservation['correo'],
                          style: GoogleFonts.roboto(
                            fontSize: effectiveWidth > 1000 ? 14 : 12,
                            color: Color(0xFF7F8C8D),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (reservation['telefono'] != null &&
                            reservation['telefono'].toString().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              reservation['telefono'],
                              style: GoogleFonts.roboto(
                                fontSize: effectiveWidth > 1000 ? 13 : 11,
                                color: Color(0xFF3498DB),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: effectiveWidth > 1000 ? 22 : 18,
                      color: Color(0xFFE74C3C),
                    ),
                    onPressed: () =>
                        _showDeleteDialog(context, provider, reservation['id']),
                    tooltip: 'Eliminar reserva',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    SchedulingProvider provider,
    String reservationId,
  ) {
    // Usar el ancho efectivo (mínimo 900px)
    final effectiveWidth = MediaQuery.of(context).size.width < 900
        ? 900
        : MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Eliminar Reserva',
            style: GoogleFonts.roboto(
              fontSize: effectiveWidth > 1000 ? 20 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar esta reserva?',
            style: GoogleFonts.roboto(
              fontSize: effectiveWidth > 1000 ? 16 : 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.roboto(
                  fontSize: effectiveWidth > 1000 ? 16 : 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await provider.deleteReservation(reservationId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE74C3C),
                padding: EdgeInsets.symmetric(
                  horizontal: effectiveWidth > 1000 ? 20 : 16,
                  vertical: effectiveWidth > 1000 ? 12 : 10,
                ),
              ),
              child: Text(
                'Eliminar',
                style: GoogleFonts.roboto(
                  fontSize: effectiveWidth > 1000 ? 16 : 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
