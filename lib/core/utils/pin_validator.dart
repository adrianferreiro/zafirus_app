class PinValidator {
  PinValidator._();

  static String? validate(String? pin) {
    if (pin == null || pin.length != 6) return 'El PIN debe tener 6 dígitos';
    if (_isDefault(pin)) return 'No podés usar el PIN por defecto';
    if (_isAllSame(pin)) return 'El PIN no puede tener todos los dígitos iguales';
    if (_isConsecutive(pin)) return 'El PIN no puede ser una secuencia consecutiva';
    return null;
  }

  static bool _isDefault(String pin) => pin == '123456';

  static bool _isAllSame(String pin) => pin.split('').toSet().length == 1;

  static bool _isConsecutive(String pin) {
    const ascending = '0123456789';
    const descending = '9876543210';
    return ascending.contains(pin) || descending.contains(pin);
  }
}
