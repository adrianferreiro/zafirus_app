import '../models/employee_model.dart';
import 'employee_datasource.dart';

class EmployeeMockDatasource implements EmployeeDatasource {
  @override
  Future<EmployeeModel> getEmployee(int employeeId) async {
    await Future.delayed(const Duration(seconds: 1));

    return const EmployeeModel(
      id: 1001,
      access: true,
      fullName: 'Juan Carlos Pérez',
      firstName: 'Juan',
      middleName: 'Carlos',
      lastName: 'Pérez',
      avatarUrl: null,
      email: 'juan.perez@zafirus.com',
      personalEmail: 'juan@gmail.com',
      dateOfBirth: '1990-05-15',
      hiredOn: '2022-03-01',
      probationEndsOn: '2022-06-01',
      gender: NamedFieldModel(id: 'male', name: 'Masculino'),
      position: NamedFieldModel(id: 1, name: 'Desarrollador Mobile'),
      jobLevel: NamedFieldModel(id: 2, name: 'Senior'),
      location: NamedFieldModel(id: 1, name: 'Asunción'),
      employmentType: NamedFieldModel(id: 1, name: 'Tiempo completo'),
      division: NamedFieldModel(id: 1, name: 'Tecnología'),
      department: DepartmentModel(
        id: 1,
        name: 'Desarrollo',
        parentId: null,
        managerId: 1000,
        departmentLevelId: 1,
      ),
      reportingTo: PersonRefModel(
        id: 1000,
        firstName: 'María',
        lastName: 'González',
        email: 'maria.gonzalez@zafirus.com',
      ),
      directReports: [
        PersonRefModel(
          id: 1002,
          firstName: 'Pedro',
          lastName: 'López',
          email: 'pedro.lopez@zafirus.com',
        ),
      ],
      terminationEffectiveOn: null,
      terminationComment: null,
      terminationEligibleForRehire: null,
      terminationType: null,
      terminationReason: null,
      fields: {},
      createdAt: '2022-03-01T10:00:00.000Z',
      updatedAt: '2024-01-15T14:30:00.000Z',
    );
  }
}
