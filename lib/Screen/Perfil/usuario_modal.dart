import 'package:flutter/material.dart';
import '../../Widget/confirm_dialog.dart';
import '../../Widget/custom_bottom_modal.dart';
import '../../Widget/estado_toggle.dart';

class UsuarioModal extends StatefulWidget {
  final Map<String, dynamic> usuario;
  final ValueChanged<bool>? onGuardar;

  const UsuarioModal({
    super.key,
    required this.usuario,
    this.onGuardar,
  });

  @override
  State<UsuarioModal> createState() => _UsuarioModalState();
}

class _UsuarioModalState extends State<UsuarioModal> {
  late bool _esActivo;
  bool _confirmadoDesactivar = false;
  bool _confirmadoActivar = false;

  @override
  void initState() {
    super.initState();
    _esActivo = widget.usuario['activo'] as bool? ?? true;
  }

  void _mostrarDialogoResetClave(BuildContext context) {
    final String nombre = widget.usuario['nombre'] as String? ?? 'Usuario';
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.lock_reset, color: Colors.amber[800], size: 22),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Restablecer Clave',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Genera una contraseña temporal para $nombre:',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tempController,
                decoration: InputDecoration(
                  labelText: 'Contraseña Temporal',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancelar', style: TextStyle(color: Colors.grey[700])),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Contraseña temporal restablecida para $nombre'),
                    backgroundColor: Colors.blue[700],
                  ),
                );
              },
              child: const Text('Asignar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    ).then((_) => tempController.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final String id = widget.usuario['id'] as String? ?? '';
    final String nombre = widget.usuario['nombre'] as String? ?? '';
    final String usuario = widget.usuario['usuario'] as String? ?? '';
    final String rol = widget.usuario['rol'] as String? ?? '';
    final String email = widget.usuario['email'] as String? ?? '';
    final String telefono = widget.usuario['telefono'] as String? ?? '';

    Color rolColor = Colors.blue[700]!;
    Color rolFondo = Colors.blue[50]!;
    if (rol == 'Doctor') {
      rolColor = Colors.teal[700]!;
      rolFondo = Colors.teal[50]!;
    } else if (rol == 'Recepcionista') {
      rolColor = Colors.amber[900]!;
      rolFondo = Colors.amber[50]!;
    }

    return CustomBottomModal(
      icono: Icons.manage_accounts_outlined,
      titulo: 'Información de Usuario',
      badgeTexto: id,
      subtitulo: 'Consulta los datos del usuario y gestiona su estado de acceso.',
      textoConfirmar: 'Guardar Cambios',
      onConfirmar: () {
        Navigator.pop(context);
        if (widget.onGuardar != null) {
          widget.onGuardar!(_esActivo);
        }
      },
      contenido: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: rolFondo,
                  child: Text(
                    nombre.isNotEmpty ? nombre.substring(0, 1) : 'U',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: rolColor,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '@$usuario  •  $email',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: rolFondo,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              rol,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: rolColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.phone_outlined, size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            telefono,
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Estado de Acceso',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          EstadoToggle(
            valor: _esActivo,
            onChanged: (val) {
              if (!val) {
                if (!_confirmadoDesactivar) {
                  showDialog(
                    context: context,
                    builder: (ctx) => ConfirmDialog(
                      titulo: '¿Desactivar Usuario?',
                      subtitulo: 'Confirmar suspensión de acceso',
                      icono: Icons.person_off_outlined,
                      colorIcono: Colors.red[600],
                      colorFondoIcono: Colors.red[50],
                      colorAdvertencia: Colors.red[800],
                      colorFondoAdvertencia: Colors.red[50],
                      colorBotonConfirmar: Colors.red[500],
                      textoConfirmar: 'Sí, Desactivar',
                      advertencia: 'El usuario no podrá iniciar sesión en la aplicación móvil ni acceder al sistema.',
                      contenido: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Text(
                          '$nombre ($rol)',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      onConfirmar: () {
                        setState(() {
                          _esActivo = false;
                          _confirmadoDesactivar = true;
                        });
                      },
                    ),
                  );
                } else {
                  setState(() => _esActivo = false);
                }
              } else {
                if (!_confirmadoActivar) {
                  showDialog(
                    context: context,
                    builder: (ctx) => ConfirmDialog(
                      titulo: '¿Activar Usuario?',
                      subtitulo: 'Confirmar reactivación de acceso',
                      icono: Icons.person_add_alt_1_outlined,
                      colorIcono: Colors.teal[700],
                      colorFondoIcono: Colors.teal[50],
                      colorAdvertencia: Colors.teal[800],
                      colorFondoAdvertencia: Colors.teal[50],
                      colorBotonConfirmar: Colors.teal[700],
                      textoConfirmar: 'Sí, Activar',
                      advertencia: 'El usuario tendrá acceso inmediato nuevamente con sus credenciales habituales.',
                      contenido: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Text(
                          '$nombre ($rol)',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      onConfirmar: () {
                        setState(() {
                          _esActivo = true;
                          _confirmadoActivar = true;
                        });
                      },
                    ),
                  );
                } else {
                  setState(() => _esActivo = true);
                }
              }
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Seguridad de la Cuenta',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.lock_reset, size: 18),
              label: const Text('Restablecer Contraseña'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue[700],
                side: BorderSide(color: Colors.blue[200]!),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () => _mostrarDialogoResetClave(context),
            ),
          ),
        ],
      ),
    );
  }
}
