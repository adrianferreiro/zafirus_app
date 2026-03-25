import '../models/birthday_model.dart';
import 'birthday_datasource.dart';

class BirthdayMockDatasource implements BirthdayDatasource {
  @override
  Future<List<BirthdayModel>> getTodayBirthdays() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return const [
      BirthdayModel(
        id: 1002,
        fullName: 'Pedro López',
        firstName: 'Pedro',
        lastName: 'López',
        avatarUrl: null,
        position: 'Diseñador UX',
        department: 'Tecnología',
      ),
      BirthdayModel(
        id: 1003,
        fullName: 'Ana Martínez',
        firstName: 'Ana',
        lastName: 'Martínez',
        avatarUrl: null,
        position: 'Analista de RRHH',
        department: 'Recursos Humanos',
      ),
      BirthdayModel(
        id: 1004,
        fullName: 'Carlos Benítez',
        firstName: 'Carlos',
        lastName: 'Benítez',
        avatarUrl: null,
        position: 'Contador',
        department: 'Finanzas',
      ),
      BirthdayModel(
        id: 1005,
        fullName: 'Laura Giménez',
        firstName: 'Laura',
        lastName: 'Giménez',
        avatarUrl: null,
        position: 'Project Manager',
        department: 'Tecnología',
      ),
      BirthdayModel(
        id: 1006,
        fullName: 'Diego Romero',
        firstName: 'Diego',
        lastName: 'Romero',
        avatarUrl: null,
        position: 'Ejecutivo Comercial',
        department: 'Ventas',
      ),
    ];
  }
}
