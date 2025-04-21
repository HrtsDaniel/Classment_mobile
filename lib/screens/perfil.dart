import 'package:classment_mobile/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:classment_mobile/screens/auth/login.dart';
import '../widgets/navbar.dart';
import '../widgets/sidebar.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  Map<String, String> userData = {
    'nombre': '',
    'apellido': '',
    'telefono': '',
    'correo': '',
    'imagen': '',
  };

  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginUsuario()),
      );
      return;
    }

    final user = await ApiService.validarToken(token);

    if (user != null) {
      setState(() {
        userData['nombre'] = user.userName;
        userData['apellido'] = user.userLastname;
        userData['telefono'] = user.userPhone;
        userData['correo'] = user.userEmail;
        userData['imagen'] = user.userImage;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al cargar el perfil o token inválido.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Color(0xFF1A1A1A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              const CustomNavbar(height: 80),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "MI PERFIL",
                        style: GoogleFonts.montserrat(
                          color: Colors.yellow.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Avatar del usuario
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey.shade800,
                            backgroundImage: userData['imagen']!.isEmpty
                                ? null
                                : NetworkImage(userData['imagen']!),
                            child: userData['imagen']!.isEmpty
                                ? Icon(Icons.person,
                                    size: 60, color: Colors.grey.shade400)
                                : null,
                          ),
                          if (isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt,
                                      color: Colors.black),
                                  onPressed: () => _changeProfileImage(),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      isEditing ? _buildEditForm() : _buildProfileInfo(),

                      const SizedBox(height: 30),

                      // Botones de acción
                      if (!isEditing)
                        Wrap(
                          spacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.black,
                              ),
                              label: Text(
                                "Editar Perfil",
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                setState(() {
                                  isEditing = true;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton.icon(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: Colors.red,
                              ),
                              label: Text(
                                "Eliminar Cuenta",
                                style: GoogleFonts.roboto(
                                  color: Colors.red,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                side: const BorderSide(
                                  color: Colors.red,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              onPressed: () => _confirmDeleteAccount(context),
                            ),
                          ],
                        ),

                      if (isEditing)
                        Wrap(
                          spacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.save,
                                size: 16,
                                color: Colors.black,
                              ),
                              label: Text(
                                "Guardar Cambios",
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  // Aquí deberías guardar los cambios en tu backend
                                  setState(() {
                                    isEditing = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Perfil actualizado correctamente'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton.icon(
                              icon: const Icon(
                                Icons.cancel_outlined,
                                size: 16,
                                color: Colors.yellow,
                              ),
                              label: Text(
                                "Cancelar",
                                style: GoogleFonts.roboto(
                                  color: Colors.yellow,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFFFFD54F),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isEditing = false;
                                });
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        Text(
          "${userData['nombre']} ${userData['apellido']}",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _buildInfoItem(Icons.phone, userData['telefono']!),
        _buildInfoItem(Icons.email, userData['correo']!),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.yellow.shade600, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.lato(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: userData['nombre'],
            style: GoogleFonts.lato(color: Colors.white),
            decoration: _buildInputDecoration('Nombre', Icons.person),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu nombre';
              }
              return null;
            },
            onSaved: (value) => userData['nombre'] = value!,
          ),
          const SizedBox(height: 15),
          TextFormField(
            initialValue: userData['apellido'],
            style: GoogleFonts.lato(color: Colors.white),
            decoration: _buildInputDecoration('Apellido', Icons.person_outline),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu apellido';
              }
              return null;
            },
            onSaved: (value) => userData['apellido'] = value!,
          ),
          const SizedBox(height: 15),
          TextFormField(
            initialValue: userData['telefono'],
            style: GoogleFonts.lato(color: Colors.white),
            decoration: _buildInputDecoration('Teléfono', Icons.phone),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu teléfono';
              }
              return null;
            },
            onSaved: (value) => userData['telefono'] = value!,
          ),
          const SizedBox(height: 15),
          TextFormField(
            initialValue: userData['correo'],
            style: GoogleFonts.lato(color: Colors.white),
            decoration: _buildInputDecoration('Correo', Icons.email),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu correo';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Por favor ingresa un correo válido';
              }
              return null;
            },
            onSaved: (value) => userData['correo'] = value!,
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.lato(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.yellow.shade600),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.yellow.shade600),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: Colors.grey.shade900.withOpacity(0.5),
    );
  }

  void _changeProfileImage() {
    // Aquí implementarías la lógica para cambiar la imagen
    // Podrías usar image_picker para seleccionar una imagen de la galería o cámara
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Cambiar imagen de perfil',
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.yellow),
              title: Text(
                'Tomar foto',
                style: GoogleFonts.lato(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                // Implementar toma de foto
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.yellow),
              title: Text(
                'Elegir de galería',
                style: GoogleFonts.lato(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                // Implementar selección de galería
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Eliminar cuenta',
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer.',
          style: GoogleFonts.lato(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancelar',
              style: GoogleFonts.roboto(color: Colors.yellow),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(
              'Eliminar',
              style: GoogleFonts.roboto(color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
          ),
        ],
      ),
    );
  }

  void _deleteAccount() async {
    // Aquí implementarías la lógica para eliminar la cuenta en tu backend
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // Navegar al login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginUsuario()),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tu cuenta ha sido eliminada'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
