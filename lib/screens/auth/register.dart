import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:classment_mobile/screens/auth/login.dart';
import 'package:classment_mobile/services/api_service.dart';

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  State<RegistroUsuario> createState() => _RegistroUsuario();
}

List<Map<String, dynamic>> _roles = [
  {'label': 'Estudiante', 'value': 1},
  {'label': 'Administrador', 'value': 3},
  {'label': 'Coordinador', 'value': 4},
];

class _RegistroUsuario extends State<RegistroUsuario> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  final List<String> _docTypes = ['CC', 'CE', 'TI', 'PPN', 'NIT', 'SSN', 'EIN'];
  String? _selectedDocType;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController documentoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  int? _selectedRole;

  @override
  void dispose() {
    _dateController.dispose();
    nombreController.dispose();
    apellidoController.dispose();
    documentoController.dispose();
    correoController.dispose();
    passwordController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  String? getFormattedBirthDate() {
    if (_dateController.text.isEmpty) return null;

    try {
      final parsedDate =
          DateFormat('dd/MM/yyyy').parseStrict(_dateController.text);
      final formatted = DateFormat('yyyy-MM-dd').format(parsedDate);
      debugPrint('Fecha convertida: $formatted');
      return formatted;
    } catch (e) {
      debugPrint('Error al convertir la fecha: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Registro de Usuario',
                      style: GoogleFonts.montserrat(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32, top: 8),
                      child: Text(
                        'Completa todos los campos para crear tu cuenta.',
                        style: GoogleFonts.roboto(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Documento
                  _buildFieldLabel('Tipo de Documento *', Icons.credit_card),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedDocType,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFFFDD835),
                        ),
                        dropdownColor: Colors.grey[900],
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        hint: Text(
                          'Selecciona tu tipo de documento',
                          style: GoogleFonts.roboto(color: Colors.grey[600]),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDocType = newValue!;
                          });
                        },
                        items: _docTypes.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildFieldLabel('Número de Documento *', Icons.numbers),
                  _buildTextField(
                    controller: documentoController,
                    hintText: 'Ingresa tu número de documento',
                    keyboardType: TextInputType.number,
                    icon: Icons.badge,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Nombre y Apellido
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Nombre *', Icons.person),
                            _buildTextField(
                              controller: nombreController,
                              hintText: 'Tu nombre',
                              icon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Requerido';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Apellido *', Icons.person),
                            _buildTextField(
                              controller: apellidoController,
                              hintText: 'Tu apellido',
                              icon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Requerido';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildFieldLabel('Correo Electrónico *', Icons.email),
                  _buildTextField(
                    controller: correoController,
                    hintText: 'ejemplo@correo.com',
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.alternate_email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu correo electrónico';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Ingresa un correo electrónico válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildFieldLabel('Contraseña *', Icons.lock),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      hintStyle: GoogleFonts.roboto(color: Colors.grey[600]),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    style: GoogleFonts.roboto(color: Colors.white),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu contraseña';
                      }
                      if (value.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Teléfono', Icons.phone),
                            _buildTextField(
                              controller: telefonoController,
                              hintText: 'Tu teléfono',
                              keyboardType: TextInputType.phone,
                              icon: Icons.phone_android,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel(
                                'Fecha de Nacimiento *', Icons.cake),
                            TextFormField(
                              controller: _dateController,
                              decoration: InputDecoration(
                                hintText: 'dd/mm/aaaa',
                                filled: true,
                                fillColor: Colors.grey[900],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                hintStyle: GoogleFonts.roboto(
                                  color: Colors.grey[600],
                                ),
                                prefixIcon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                              style: GoogleFonts.roboto(color: Colors.white),
                              readOnly: true,
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.dark(
                                          primary: Color(0xFFFDD835),
                                          onPrimary: Colors.black,
                                          surface: Colors.grey,
                                          onSurface: Colors.white,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  setState(() {
                                    _dateController.text = DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(picked);
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'La fecha de nacimeinto es requerida';
                                }
                                try {
                                  DateFormat('dd/MM/yyyy').parseStrict(value);
                                  return null;
                                } catch (e) {
                                  return 'Formato inválido (use dd/mm/aaaa)';
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Rol
                  _buildFieldLabel('Rol *', Icons.assignment_ind),
                  FormField<int>(
                    initialValue: _selectedRole,
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor seleccione un rol';
                      }
                      return null;
                    },
                    builder: (FormFieldState<int> field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _selectedRole,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xFFFDD835),
                                ),
                                dropdownColor: Colors.grey[900],
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                hint: Text(
                                  'Selecciona tu rol',
                                  style: GoogleFonts.roboto(
                                      color: Colors.grey[600]),
                                ),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    _selectedRole = newValue;
                                  });
                                  field.didChange(newValue);
                                },
                                items: _roles.map<DropdownMenuItem<int>>(
                                    (Map<String, dynamic> role) {
                                  return DropdownMenuItem<int>(
                                    value: role['value'],
                                    child: Text(
                                      role['label'],
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          if (field.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 16),
                              child: Text(
                                field.errorText!,
                                style: GoogleFonts.roboto(
                                  color: Colors.red[400],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.how_to_reg),
                    label: Text(
                      'Registrarse',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDD835),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Procesando registro...',
                              style: GoogleFonts.roboto(),
                            ),
                            backgroundColor: const Color(0xFFFDD835),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );

                        final datos = {
                          'user': {
                            'user_name': nombreController.text.trim(),
                            'user_lastname': apellidoController.text.trim(),
                            'user_document': documentoController.text.trim(),
                            'user_document_type': _selectedDocType,
                            'user_email': correoController.text.trim(),
                            'user_password': passwordController.text,
                            'user_phone': telefonoController.text.trim(),
                            'user_birth': getFormattedBirthDate(),
                            'role_id': _selectedRole,
                            'user_image':
                                'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'
                          }
                        };

                        final exito = await ApiService.registrarUsuario(datos);

                        if (exito) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Usuario registrado exitosamente'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );

                          await Future.delayed(Duration(seconds: 1));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginUsuario()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al registrar usuario'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿Ya tienes cuenta?',
                          style: GoogleFonts.roboto(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginUsuario(),
                              ),
                            );
                          },
                          child: Text(
                            'Inicia sesión aquí',
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFFFDD835),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFFFDD835)),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFDD835),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: GoogleFonts.roboto(color: Colors.grey[600]),
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
          size: 20,
        ),
      ),
      style: GoogleFonts.roboto(
        color: Colors.white,
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
