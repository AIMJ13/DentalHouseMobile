import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/models/user_model.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dental_logo.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/user_badge.dart';
import 'usuario_modal.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool _mostrarGestionUsuarios = false;
  String _filtroRol = 'Todos';
  final List<String> _filtros = ['Todos', 'Doctores', 'Recepcionistas', 'Administradores'];

  final TextEditingController _claveActualController = TextEditingController();
  final TextEditingController _claveNuevaController = TextEditingController();
  final TextEditingController _claveConfirmarController = TextEditingController();
  final TextEditingController _busquedaUsuarioController = TextEditingController();

  bool _ocultarClaveActual = true;
  bool _ocultarClaveNueva = true;
  bool _ocultarClaveConfirmar = true;
  bool _cambioClaveExpandido = false;


  @override
  void dispose() {
   
    _claveActualController.dispose();
    _claveNuevaController.dispose();
    _claveConfirmarController.dispose();
    _busquedaUsuarioController.dispose();
    super.dispose();
  }

  Future<void> _cambiarClave() async {
    final error = await context.read<UserProvider>().changePassword(
          _claveActualController.text,
          _claveNuevaController.text,
          _claveConfirmarController.text,
        );
    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    _claveActualController.clear();
    _claveNuevaController.clear();
    _claveConfirmarController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contraseña actualizada con éxito'), backgroundColor: Colors.green),
    );
  }

 

  void _mostrarModalUsuario(UserModel u) {
    final Map<String, dynamic> datosModal = {
      'id': u.id.toString(),
      'nombre': u.userName,
      'usuario': u.userName,
      'rol': u.rol,
      'email': u.email,
      'telefono': u.phone ?? '',
      'activo': u.state,
    };

    showDialog(
      context: context,
      builder: (dialogContext) {
        return UsuarioModal(
          usuario: datosModal,
          onGuardar: (nuevoActivo) async {
            final ok = await context.read<UserProvider>().setUserState(u.id, nuevoActivo);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(ok
                    ? (nuevoActivo ? 'Usuario reactivado con éxito' : 'Usuario desactivado')
                    : (context.read<UserProvider>().errorMessage ?? 'No se pudo cambiar el estado')),
                backgroundColor: ok ? (nuevoActivo ? Colors.green[600] : Colors.red[600]) : Colors.red,
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final String rol = auth.currentRole;
    final bool esAdmin = rol == 'Administrador';
    final int indexNav = (rol == 'Recepcionista') ? -1 : ((rol == 'Doctor') ? 3 : 4);

    return PopScope(
      canPop: !_mostrarGestionUsuarios,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_mostrarGestionUsuarios) {
          setState(() => _mostrarGestionUsuarios = false);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () {
              if (_mostrarGestionUsuarios) {
                setState(() => _mostrarGestionUsuarios = false);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: const DentalLogo(),
          actions: [
            UserBadge(
              onTap: _mostrarGestionUsuarios
                  ? () => setState(() => _mostrarGestionUsuarios = false)
                  : null,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!esAdmin || !_mostrarGestionUsuarios) _buildVistaMiPerfil(esAdmin),
              if (esAdmin && _mostrarGestionUsuarios) _buildVistaGestionUsuarios(),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNav(currentIndex: indexNav),
      ),
    );
  }

  Widget _buildVistaMiPerfil(bool esAdmin) {
     final auth = context.watch<AuthProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.blue[700],
                    child: Text(
                    auth.avatarLetra,
                      style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.userName, 
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          auth.email, 
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(6)),
                              child: Text(
                              auth.currentRole, 
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue[700]),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.green[600],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.check_circle, size: 12, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'Activo',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (esAdmin) ...[
                const SizedBox(height: 14),
                Divider(height: 1, color: Colors.grey[200]!),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                       setState(() => _mostrarGestionUsuarios = true);
                       context.read<UserProvider>().fetchUsers();
                    },
                    icon: const Icon(Icons.people_outline, size: 18, color: Colors.white),
                    label: const Text(
                      'Gestión de Usuarios',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => setState(() => _cambioClaveExpandido = !_cambioClaveExpandido),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lock_outline, size: 18, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        const Text('Cambio de Contraseña', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(_cambioClaveExpandido ? 'Ocultar' : 'Cambiar contraseña', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue[700])),
                        Icon(_cambioClaveExpandido ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.blue[700], size: 20),
                      ],
                    ),
                  ],
                ),
              ),
              if (_cambioClaveExpandido) ...[
                const SizedBox(height: 16),
                _buildInputClave('Contraseña Actual', _claveActualController, _ocultarClaveActual, () => setState(() => _ocultarClaveActual = !_ocultarClaveActual)),
                const SizedBox(height: 12),
                _buildInputClave('Nueva Contraseña', _claveNuevaController, _ocultarClaveNueva, () => setState(() => _ocultarClaveNueva = !_ocultarClaveNueva)),
                const SizedBox(height: 12),
                _buildInputClave('Confirmar Nueva Contraseña', _claveConfirmarController, _ocultarClaveConfirmar, () => setState(() => _ocultarClaveConfirmar = !_ocultarClaveConfirmar)),
                const SizedBox(height: 16),
                CustomButton(text: 'Actualizar Contraseña', onPressed: _cambiarClave, color: Colors.blue[700]),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInputClave(String label, TextEditingController controller, bool ocultar, VoidCallback onToggle) {
    return CustomTextField(
      label: label,
      hintText: '••••••••',
      controller: controller,
      obscureText: ocultar,
      prefixIcon: const Icon(Icons.lock_outline, size: 18, color: Colors.grey),
      suffixIcon: IconButton(
        icon: Icon(ocultar ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: Colors.grey),
        onPressed: onToggle,
      ),
    );
  }

  Widget _buildVistaGestionUsuarios() {
    final provider = context.watch<UserProvider>();
    final usuarios = provider.users;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)),
          child: TextField(
            controller: _busquedaUsuarioController,
            onChanged: (val) => context.read<UserProvider>().setSearchTerm(val),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
              hintText: 'Buscar usuario por nombre, email o rol...',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var filtro in _filtros)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                      onTap: () {
                      setState(() => _filtroRol = filtro);
                      context.read<UserProvider>().setRoleFilter(filtro);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _filtroRol == filtro ? Colors.blue[700] : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _filtroRol == filtro ? Colors.blue[700]! : Colors.grey[300]!),
                      ),
                      child: Text(filtro, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _filtroRol == filtro ? Colors.white : Colors.grey[700])),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('USUARIOS REGISTRADOS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700], letterSpacing: 0.5)),
            Text('${usuarios.length} mostrados', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
        ),
        const SizedBox(height: 12),
        if (provider.isLoading)
          const SizedBox(height: 240, child: LoadingView(message: 'Cargando usuarios...'))
        else if (provider.hasError)
          SizedBox(
            height: 240,
            child: ErrorView(
              message: provider.errorMessage ?? 'Error al cargar usuarios',
              onRetry: () => provider.fetchUsers(),
            ),
          )
        else if (usuarios.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No hay usuarios para mostrar')),
          )
        else
          for (var u in usuarios) _buildUsuarioCardReal(u),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildUsuarioCardReal(UserModel u) {
    final bool activo = u.state;
    final String rol = u.rol.isEmpty ? 'Sin rol' : u.rol;
    final String nombre = u.userName;
    final String email = u.email;
    final String telefono = (u.phone == null || u.phone!.trim().isEmpty)
        ? 'Sin teléfono registrado'
        : u.phone!;

    Color rolColor = Colors.blue[700]!;
    Color rolFondo = Colors.blue[50]!;

    if (rol == 'Doctor') {
      rolColor = Colors.teal[700]!;
      rolFondo = Colors.teal[50]!;
    } else if (rol == 'Recepcionista') {
      rolColor = Colors.blue[800]!;
      rolFondo = Colors.blue[50]!;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _mostrarModalUsuario(u),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: rolFondo, borderRadius: BorderRadius.circular(6)),
                  child: Text(rol, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: rolColor)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: activo ? Colors.green[50] : Colors.red[50], borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 6, height: 6, decoration: BoxDecoration(color: activo ? Colors.green[600] : Colors.red[600], shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text(activo ? 'Activo' : 'Inactivo', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: activo ? Colors.green[700] : Colors.red[700])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: rolFondo,
                  child: Text(nombre.isNotEmpty ? nombre.substring(0, 1).toUpperCase() : 'U', style: TextStyle(fontWeight: FontWeight.bold, color: rolColor, fontSize: 16)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                      const SizedBox(height: 2),
                      Text(email, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.phone_outlined, size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(telefono, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  } 
}
