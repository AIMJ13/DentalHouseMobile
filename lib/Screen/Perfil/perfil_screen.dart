import 'package:flutter/material.dart';
import '../../Data/dashboard_data.dart';
import '../../Widget/confirm_dialog.dart';
import '../../Widget/custom_button.dart';
import '../../Widget/custom_text_field.dart';
import '../../Widget/dental_logo.dart';
import '../../Widget/user_badge.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  int _pestanaSeleccionada = 0;
  String _filtroRol = 'Todos';
  final List<String> _filtros = ['Todos', 'Doctores', 'Recepcionistas', 'Administradores'];

  late final TextEditingController _emailController;
  late final TextEditingController _telefonoController;
  final TextEditingController _claveActualController = TextEditingController();
  final TextEditingController _claveNuevaController = TextEditingController();
  final TextEditingController _claveConfirmarController = TextEditingController();
  final TextEditingController _busquedaUsuarioController = TextEditingController();

  bool _ocultarClaveActual = true;
  bool _ocultarClaveNueva = true;
  bool _ocultarClaveConfirmar = true;
  bool _cambioClaveExpandido = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: perfilUsuarioActual['email'] as String);
    _telefonoController = TextEditingController(text: perfilUsuarioActual['telefono'] as String);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _telefonoController.dispose();
    _claveActualController.dispose();
    _claveNuevaController.dispose();
    _claveConfirmarController.dispose();
    _busquedaUsuarioController.dispose();
    super.dispose();
  }

  void _guardarContacto() {
    final nuevoEmail = _emailController.text.trim();
    final nuevoTelefono = _telefonoController.text.trim();

    if (nuevoEmail.isEmpty || nuevoTelefono.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos de contacto'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      perfilUsuarioActual['email'] = nuevoEmail;
      perfilUsuarioActual['telefono'] = nuevoTelefono;
      for (var u in listaUsuarios) {
        if (u['id'] == perfilUsuarioActual['id']) {
          u['email'] = nuevoEmail;
          u['telefono'] = nuevoTelefono;
          break;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos de contacto actualizados correctamente'), backgroundColor: Colors.green),
    );
  }

  void _cambiarClave() {
    final actual = _claveActualController.text.trim();
    final nueva = _claveNuevaController.text.trim();
    final confirmar = _claveConfirmarController.text.trim();

    if (actual.isEmpty || nueva.isEmpty || confirmar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos de contraseña'), backgroundColor: Colors.red),
      );
      return;
    }
    if (nueva != confirmar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La nueva contraseña y la confirmación no coinciden'), backgroundColor: Colors.red),
      );
      return;
    }
    if (nueva.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña debe tener al menos 6 caracteres'), backgroundColor: Colors.red),
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

  List<Map<String, dynamic>> _obtenerUsuariosFiltrados() {
    final query = _busquedaUsuarioController.text.trim().toLowerCase();
    List<Map<String, dynamic>> resultado = [];

    for (var usr in listaUsuarios) {
      final rol = usr['rol'] as String;
      if (_filtroRol == 'Doctores' && rol != 'Doctor') continue;
      if (_filtroRol == 'Recepcionistas' && rol != 'Recepcionista') continue;
      if (_filtroRol == 'Administradores' && rol != 'Administrador') continue;

      final nombre = (usr['nombre'] as String).toLowerCase();
      final usuario = (usr['usuario'] as String).toLowerCase();
      final email = (usr['email'] as String).toLowerCase();

      final coincide = query.isEmpty || nombre.contains(query) || usuario.contains(query) || email.contains(query);
      if (!coincide) continue;
      resultado.add(usr);
    }
    return resultado;
  }

  void _alternarEstadoUsuario(Map<String, dynamic> usuario) {
    final bool activo = usuario['activo'] as bool;
    final String nombre = usuario['nombre'] as String;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return ConfirmDialog(
          titulo: activo ? '¿Desactivar Usuario?' : '¿Reactivar Usuario?',
          subtitulo: 'Gestión de acceso al sistema',
          icono: activo ? Icons.person_off_outlined : Icons.person_add_alt_1_outlined,
          colorIcono: activo ? Colors.red[600] : Colors.teal[700],
          colorFondoIcono: activo ? Colors.red[50] : Colors.teal[50],
          colorAdvertencia: activo ? Colors.red[800] : Colors.teal[800],
          colorFondoAdvertencia: activo ? Colors.red[50] : Colors.teal[50],
          colorBotonConfirmar: activo ? Colors.red[500] : Colors.teal[700],
          textoConfirmar: activo ? 'Sí, Desactivar' : 'Sí, Reactivar',
          advertencia: activo
              ? 'El usuario $nombre no podrá iniciar sesión en la aplicación móvil ni acceder al sistema.'
              : 'El usuario $nombre tendrá acceso inmediato nuevamente con sus credenciales habituales.',
          contenido: _buildUsuarioPreview(usuario),
          onConfirmar: () {
            setState(() => usuario['activo'] = !activo);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(activo ? 'Usuario desactivado' : 'Usuario reactivado con éxito'),
                backgroundColor: activo ? Colors.red[600] : Colors.green[600],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUsuarioPreview(Map<String, dynamic> usuario) {
    final activo = usuario['activo'] as bool;
    final nombre = usuario['nombre'] as String;
    final rol = usuario['rol'] as String;
    final email = usuario['email'] as String;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: activo ? Colors.blue[50] : Colors.red[50],
            child: Text(nombre.isNotEmpty ? nombre.substring(0, 1) : 'U', style: TextStyle(fontWeight: FontWeight.bold, color: activo ? Colors.blue[700] : Colors.red[700])),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                Text('$rol  •  $email', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _restablecerClaveUsuario(Map<String, dynamic> usuario) {
    final String nombre = usuario['nombre'] as String;
    final TextEditingController tempController = TextEditingController(text: 'Dental2026#');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.amber[50], borderRadius: BorderRadius.circular(8)), child: Icon(Icons.lock_reset, color: Colors.amber[800], size: 22)),
              const SizedBox(width: 10),
              const Expanded(child: Text('Restablecer Clave', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Genera una contraseña temporal para $nombre:', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              const SizedBox(height: 12),
              TextField(
                controller: tempController,
                decoration: InputDecoration(labelText: 'Contraseña Temporal', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Cancelar', style: TextStyle(color: Colors.grey[700]))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700], elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contraseña temporal restablecida para $nombre'), backgroundColor: Colors.blue[700]));
              },
              child: const Text('Asignar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final bool esAdmin = (perfilUsuarioActual['rol'] as String? ?? '') == 'Administrador';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)),
        title: const DentalLogo(),
        actions: const [UserBadge()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (esAdmin) ...[
              Container(
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Expanded(child: _buildBotonPestana('Mi Perfil', 0)),
                    Expanded(child: _buildBotonPestana('Gestión de Usuarios', 1)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (!esAdmin || _pestanaSeleccionada == 0) _buildVistaMiPerfil(),
            if (esAdmin && _pestanaSeleccionada == 1) _buildVistaGestionUsuarios(),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonPestana(String texto, int index) {
    final seleccionada = _pestanaSeleccionada == index;
    return InkWell(
      onTap: () => setState(() => _pestanaSeleccionada = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: seleccionada ? Colors.blue[700] : Colors.transparent, borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(texto, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: seleccionada ? Colors.white : Colors.grey[700])),
        ),
      ),
    );
  }

  Widget _buildVistaMiPerfil() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.blue[700],
                child: Text(perfilUsuarioActual['avatarLetra'] as String, style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(perfilUsuarioActual['nombre'] as String, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 2),
                    Text('@${perfilUsuarioActual['usuario']}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(6)),
                      child: Text(perfilUsuarioActual['rol'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue[700])),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildResumenCard('Citas Hoy', '${perfilUsuarioActual['citasHoy']}', Colors.amber[700]!)),
            const SizedBox(width: 10),
            Expanded(child: _buildResumenCard('Atenciones', '${perfilUsuarioActual['totalAtenciones']}', Colors.teal[700]!)),
            const SizedBox(width: 10),
            Expanded(child: _buildResumenCard('Estado', 'Activo', Colors.green[600]!)),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Actualizar Datos de Contacto', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
          child: Column(
            children: [
              CustomTextField(label: 'Correo Electrónico', hintText: 'admin@dentalhouse.com', controller: _emailController, prefixIcon: const Icon(Icons.email_outlined, size: 18, color: Colors.grey)),
              const SizedBox(height: 12),
              CustomTextField(label: 'Teléfono Personal', hintText: '+505 8888-1111', controller: _telefonoController, prefixIcon: const Icon(Icons.phone_outlined, size: 18, color: Colors.grey)),
              const SizedBox(height: 16),
              CustomButton(text: 'Guardar Contacto', onPressed: _guardarContacto, color: Colors.blue[700]),
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

  Widget _buildResumenCard(String etiqueta, String valor, Color colorPunto) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 7, height: 7, decoration: BoxDecoration(color: colorPunto, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text(etiqueta, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 4),
          Text(valor, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildVistaGestionUsuarios() {
    final usuarios = _obtenerUsuariosFiltrados();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)),
          child: TextField(
            controller: _busquedaUsuarioController,
            onChanged: (val) => setState(() {}),
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
                    onTap: () => setState(() => _filtroRol = filtro),
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
        for (var usr in usuarios) _buildUsuarioCard(usr),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildUsuarioCard(Map<String, dynamic> usr) {
    final bool activo = usr['activo'] as bool;
    final String rol = usr['rol'] as String;
    final String nombre = usr['nombre'] as String;
    final String usuario = usr['usuario'] as String;
    final String email = usr['email'] as String;
    final String telefono = usr['telefono'] as String;

    Color rolColor = Colors.blue[700]!;
    Color rolFondo = Colors.blue[50]!;

    if (rol == 'Doctor') {
      rolColor = Colors.teal[700]!;
      rolFondo = Colors.teal[50]!;
    } else if (rol == 'Recepcionista') {
      rolColor = Colors.amber[900]!;
      rolFondo = Colors.amber[50]!;
    }

    return Container(
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
                child: Text(nombre.isNotEmpty ? nombre.substring(0, 1) : 'U', style: TextStyle(fontWeight: FontWeight.bold, color: rolColor, fontSize: 16)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 2),
                    Text('@$usuario  •  $email', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.lock_reset, size: 16),
                  label: const Text('Reset Clave', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue[700],
                    side: BorderSide(color: Colors.blue[200]!),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onPressed: () => _restablecerClaveUsuario(usr),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activo ? Colors.red[500] : Colors.teal[700],
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onPressed: () => _alternarEstadoUsuario(usr),
                  child: Text(activo ? 'Desactivar' : 'Reactivar', style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
