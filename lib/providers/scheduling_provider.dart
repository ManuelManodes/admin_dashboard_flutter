import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:admin_dashboard/services/notifications_service.dart';

class SchedulingProvider extends ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  TimeOfDay? _selectedTime;
  String _phoneNumber = '';
  bool _isLoading = false;
  bool _hasLoadedInitialData = false;
  List<Map<String, dynamic>> _reservations = [];

  // Getters
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  TimeOfDay? get selectedTime => _selectedTime;
  String get phoneNumber => _phoneNumber;
  bool get isLoading => _isLoading;
  bool get hasLoadedInitialData => _hasLoadedInitialData;
  List<Map<String, dynamic>> get reservations => _reservations;

  // Get current user email
  String? get currentUserEmail => FirebaseAuth.instance.currentUser?.email;

  // Firestore reference
  final CollectionReference _reservationsCollection = FirebaseFirestore.instance
      .collection('reservas');

  // Constructor
  SchedulingProvider() {
    _loadReservations();
  }

  // Setters
  void setSelectedDay(DateTime day) {
    _selectedDay = day;
    _selectedTime = null;
    notifyListeners();
  }

  void setFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  void setSelectedTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setPhoneNumber(String phone) {
    _phoneNumber = phone;
    notifyListeners();
  }

  // Load all reservations from Firestore
  Future<void> _loadReservations() async {
    try {
      _isLoading = true;
      notifyListeners();

      final QuerySnapshot snapshot = await _reservationsCollection.get();
      _reservations = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'fecha': (data['fecha'] as Timestamp).toDate(),
          'hora': data['hora'],
          'correo': data['correo'],
          'telefono': data['telefono'] ?? '',
        };
      }).toList();

      _hasLoadedInitialData = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _hasLoadedInitialData = true;
      _isLoading = false;
      notifyListeners();
      NotificationsService.showSnackbar(
        'Error al cargar reservas: ${e.toString()}',
      );
    }
  }

  // Check if a time slot is already reserved
  bool isTimeSlotReserved(DateTime date, String time) {
    return _reservations.any((reservation) {
      final reservationDate = reservation['fecha'] as DateTime;
      final reservationTime = reservation['hora'] as String;

      return reservationDate.year == date.year &&
          reservationDate.month == date.month &&
          reservationDate.day == date.day &&
          reservationTime == time;
    });
  }

  // Get reservations for a specific day
  List<Map<String, dynamic>> getReservationsForDay(DateTime day) {
    return _reservations.where((reservation) {
      final reservationDate = reservation['fecha'] as DateTime;
      return reservationDate.year == day.year &&
          reservationDate.month == day.month &&
          reservationDate.day == day.day;
    }).toList();
  }

  // Create a new reservation
  Future<bool> createReservation() async {
    if (_selectedTime == null) {
      NotificationsService.showSnackbar('Por favor selecciona una hora');
      return false;
    }

    if (_phoneNumber.trim().isEmpty) {
      NotificationsService.showSnackbar(
        'Por favor ingresa un número de teléfono',
      );
      return false;
    } // Validate phone number format (basic validation)
    if (!_isValidPhoneNumber(_phoneNumber.trim())) {
      NotificationsService.showSnackbar(
        'Por favor ingresa un número de teléfono válido',
      );
      return false;
    }

    // Validate that selected date is not in the past
    final DateTime now = DateTime.now();
    final DateTime selectedDateTime = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (selectedDateTime.isBefore(now)) {
      NotificationsService.showSnackbar(
        'No puedes reservar una fecha y hora en el pasado',
      );
      return false;
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Get current user email
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        NotificationsService.showSnackbar('Usuario no autenticado');
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final String timeString =
          '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

      // Check if time slot is already reserved
      if (isTimeSlotReserved(_selectedDay, timeString)) {
        NotificationsService.showSnackbar(
          'Esta fecha y hora ya está reservada',
        );
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Check if user already has a reservation for this day
      if (_hasUserReservationForDay(currentUser.email!, _selectedDay)) {
        NotificationsService.showSnackbar(
          'Ya tienes una reserva para este día',
        );
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Create reservation document with normalized date
      final normalizedDate = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
      );
      await _reservationsCollection.add({
        'fecha': Timestamp.fromDate(normalizedDate),
        'hora': timeString,
        'correo': currentUser.email,
        'telefono': _phoneNumber.trim(),
        'fechaCreacion': Timestamp.now(),
        'estado': 'activa', // New field for reservation status
      });

      // Reload reservations
      await _loadReservations();

      // Reset selected time and phone
      _selectedTime = null;
      _phoneNumber = '';

      NotificationsService.showSuccessSnackbar('¡Reserva creada exitosamente!');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      NotificationsService.showSnackbar(
        'Error al crear reserva: ${e.toString()}',
      );
      return false;
    }
  }

  // Helper method to validate phone number
  bool _isValidPhoneNumber(String phone) {
    // More permissive validation - just check it's not empty and has some digits
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    return cleaned.length >= 8 && cleaned.contains(RegExp(r'\d'));
  }

  // Helper method to check if user already has a reservation for a specific day
  bool _hasUserReservationForDay(String userEmail, DateTime day) {
    return _reservations.any((reservation) {
      final reservationDate = reservation['fecha'] as DateTime;
      final reservationEmail = reservation['correo'] as String;

      return reservationDate.year == day.year &&
          reservationDate.month == day.month &&
          reservationDate.day == day.day &&
          reservationEmail == userEmail;
    });
  }

  // Delete a reservation
  Future<bool> deleteReservation(String reservationId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _reservationsCollection.doc(reservationId).delete();
      await _loadReservations();

      NotificationsService.showSnackbar('Reserva eliminada exitosamente');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      NotificationsService.showSnackbar(
        'Error al eliminar reserva: ${e.toString()}',
      );
      return false;
    }
  }

  // Reset provider
  void reset() {
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _selectedTime = null;
    _phoneNumber = '';
    _isLoading = false;
    _reservations.clear();
    notifyListeners();
  }
}
