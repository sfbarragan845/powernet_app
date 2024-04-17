library my_prj.globals;

import 'dart:async';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:powernet/app/models/instalation/Datos_Instalaciones.dart';
import 'package:powernet/app/models/migration/Datos_Migracion.dart';
import 'package:powernet/app/models/pdf/producto_Pdf.dart';
import 'package:powernet/app/models/products/series_prod.dart';
import 'package:powernet/app/models/statistic/tecnico_model.dart';
import 'package:powernet/app/models/support/Datos_Soportes.dart';
import 'package:powernet/app/models/transfer/Datos_Traslado.dart';

import '../pages/public/soporte/widgets/Datos_GarantiaSeries.dart';
import 'charges/Datos_Bancos.dart';
import 'charges/Datos_Documentos.dart';
import 'crm/CRM_Products.dart';
import 'instalation/Datos_prestacion.dart';
import 'products/listas_prod.dart';
import 'statistic/procesos.dart';
import 'withdrawal/Datos_CortadosImpago.dart';

String versionAPP = "";
String nombreCliente = "";
String idCliente = "";
LatLng ps = const LatLng(-0.2587083, -79.1639749);

//Para las ordenes
String nombreProyecto = "";
String idProyecto = "";
// MENSAJES APIS
String mensaje = "";
// PARA COORDENADAS UBICACION
List<String> LatClient = [''];

// PARA CREAR DIRECCIONES
String ref = "";
String lat = "";
String lng = "";
String nombre_dir = "";
String direc = "";
String latdir = "";
String lngdir = "";
String listbank12 = "";

//**TRACKING */
double trac_lat = 0.000;
double trac_lng = 0.00;
//** JWT */
String jwtToken = "";

bool ventana = true;

List<int> nrespuestas = [];
List<String> Stringrespuestas = [];
int block = 0;
String eventCodeScreens = '';
String historialScreens = '';
String tipotecnico = 'Seleccionar';

bool btnver = false;
List listarTecnicos = [];
//String? dropmenuTecnicos = '';
Map<String, String> MostrarListTecnico = {};
List<Datos_Instalaciones> ListadoInstalacion = [];
List<Datos_CortadosImpago> ListadoCortadosImpago = [];
List<Datos_CortadosImpago> ListadoSuspenciones = [];
List<Datos_Soportes> ListadoSoportes = [];
List<Datos_Migracion> ListadoMigraciones = [];
List<Datos_Traslados> ListadoTraslados = [];
List<Datos_Instalaciones> ListadoHomeInstalacion = [];
List<Datos_Soportes> ListadoHomeSoportes = [];
List<Datos_Migracion> ListadoHomeMigraciones = [];
List<Datos_Traslados> ListadoHomeTraslados = [];
List<lista_series_garantia> Listadogarantias = [];
List<Datos_Bancos> listaBancos = [];
List<DatosDocumentos> listaDocumentos = [];

String tipoRequerimiento = "";
String id_pk = "";
String id_cliente = "";
String tipo_actividad = "";
String id_tecnico = "";
int cantSoporte = 0;
int cantInstalacion = 0;
int cantMigracion = 0;
int cantTraslados = 0;

List tecnicoAcomp = [];
String selectAcomp = '';

//GENERALES
bool ischeckedCoord = true;
bool updateCoords = false;
bool btnUpdateCoords = false;
bool facturaOficina = false;
bool btnFacturaOficina = false;
bool btnFacturaOficinaAdicionales = false;
String persona_presente = '';
bool checkBoxValue = false;
bool ischecked = true;
bool btnRecibeProd = false;
String detalleEquiposRetirados = '';
bool visiblecuotasadi = false;
bool waiting = false;

// *AQUI VARIABLES PARA DETALLE SOPORTE* //
int itemDetSoporte = 0;
String codigoDetSoporte = '';
String identidadcodigoDetSoporte = '';
String clienteDetSoporte = '';
String codigo_servicioDetSoporte = '';
String fecha_visitarDetSoporte = '';
String registradoDetSoporte = '';
String incidenteDetSoporte = '';
String ancho_banda_subidaDetSoporte = '';
String ancho_banda_bajadaDetSoporte = '';
String comparticionDetSoporte = '';
String estado_servicioDetSoporte = '';
String latitudDetSoporte = '';
String longitudDetSoporte = '';
String estado_soporteDetSoporte = '';
String contactarDetSoporte = '';
String usuario_asignadoDetSoporte = '';
String fecha_asignacionDetSoporte = '';
String direccionDetSoporte = '';
String categoria_incidenteDetSoporte = '';
String prioridad_servicioDetSoporte = '';
String codigo_clienteSoporte = '';
String celular1_DetSoporte = '';
String celular2_DetSoporte = '';
String celular3_DetSoporte = '';
String celular_DetSoporte = '';
String foto_servicio_DetSoporte = '';
String observacion_soporte = '';
String tipo_factura_soporte = '';
String tipo_factura_soporteAdicional = '';
String vlan_soporte = '';

String ip_soporte = '';
String red_ip_soporte = '';
String mascara_ip_soporte = '';
String gateway_soporte = '';
String ProductAdiciSoport = 'NO';
String ProductAdiciInsta = 'NO';
bool ProductAdSoport = false;
bool isProcedenteSoporte = false;
String procedeSoporte = 'SI';
bool isRealizaSoporte = true;
String nCuotas = '1';
String nCuotasAdicionales = '1';
// *AQUI VARIABLES PARA DETALLE INSTALACION* //
String identificacionInstalacion = '';
int itemDetInstalacion = 0;
String codigoDetInstalacion = '';
String clienteDetInstalacion = '';
String codigo_servicioDetInstalacion = '';
String fecha_instalarDetInstalacion = '';
String registradoDetInstalacion = '';
String ancho_banda_subidaDetInstalacion = '';
String ancho_banda_bajadaDetInstalacion = '';
String comparticionDetInstalacion = '';
String estado_servicioDetInstalacion = '';
String estado_instalacionDetInstalacion = '';
String latitudDetInstalacion = '';
String longitudDetInstalacion = '';
String usuario_asignadoDetInstalacion = '';
String fecha_asignacionDetInstalacion = '';
String direccionDetInstalacion = '';
String codigo_clienteInstalacion = '';
String celular1_DetInstalacion = '';
String celular2_DetInstalacion = '';
String celular3_DetInstalacion = '';
String celular_DetInstalacion = '';
String codigo_PrestacionInst = '';
String nombre_PrestacionInst = '';
String precio_PrestacionInst = '';
List<Datos_Prestacion> arrayPrestacionInst = [];
String detalleSoluInstalacion = '';
String ip_instalacion = '';
String red_ip_instalacion = '';
String mascara_ip_instalacion = '';
String procedeInstalacion = 'SI';
bool isRealizaInstalacion = true;
String observacion_instalacion = '';
String frame_instalacion = '';
String slot_instalacion = '';
String puerto_instalacion = '';
String service_port_instalacion = '';
String vlan_instalacion = '';
String gateway_instalacion = '';
String vendedor = '';
// *AQUI VARIABLES PARA DETALLE MIGRACION* //
int item_DetMigracion = 0;
String codigo_DetMigracion = '';
String identificacion_DetMigracion = '';
String cliente_DetMigracion = '';
String codigo_servicio_DetMigracion = '';
String codigo_servicio_DetMigracion_mostrar = '';
String fechaMigracion_DetMigracion = '';
String registrado_DetMigracion = '';
String ancho_banda_subida_DetMigracion = '';
String ancho_banda_bajada_DetMigracion = '';
String comparticion_DetMigracion = '';
String estado_servicio_DetMigracion = '';
String latitud_Detmigracion = '';
String longitud_DetMigracion = '';
String estado_soporte_DetMigracion = '';
String id_tecnico_DetMigracion = '';
String usuario_asignado_DetMigracion = '';
String fecha_asignacion_DetMigracion = '';
String direccion_DetMigracion = '';
String id_cliente_DetMigracion = '';
String codigo_prestacionMigra = '';
String nombre_prestacionMigra = '';
String precio_prestacionMigra = '';
String detalleSoluMigracion = '';
String celular1_DetMigracion = '';
String celular2_DetMigracion = '';
String celular3_DetMigracion = '';
String celular_DetMigracion = '';
String persona_contactar_migracion = '';
String foto_servicio_DetMigracion = '';
String observacion_migracion = '';
String vlan_migracion = '';
String ip_migracion = '';
String red_ip_migracion = '';
String mascara_ip_migracion = '';
String procedeMigracion = 'SI';
bool isRealizaMigracion = true;
String tipo_factura_migracion = '';
String tipo_factura_migracionAdicional = '';
String gateway_migracion = '';

// *AQUI VARIABLES PARA DETALLE TRASLADOS* //
int item_DetTraslados = 0;
String codigo_DetTraslados = '';
String codigo_prestacionTraslados = '';
String nombre_prestacionTraslados = '';
String precio_prestacionTraslados = '';
String id_tecnico_DetTraslados = '';
String usuario_asignado_DetTraslados = '';
String fecha_asignacion_DetTraslados = '';
String latitud_actual_DetTraslados = '';
String longitud_actual_DetTraslados = '';
String latitud_nueva_DetTraslados = '';
String longitud_nueva_DetTraslados = '';
String identificacion_DetTraslados = '';
String cliente_DetTraslados = '';
String codigo_servicio_DetTraslados = '';
String codigo_servicio_DetTraslado_mostrar = '';
String fechaMigracion_DetTraslados = '';
String registrado_DetTraslados = '';
String ancho_banda_subida_DetTraslados = '';
String ancho_banda_bajada_DetTraslados = '';
String comparticion_DetTraslados = '';
String estado_servicio_DetTraslados = '';
String estado_soporte_DetTraslados = '';
String direccion_DetTraslados = '';
String id_cliente_DetTraslados = '';
String detalleSoluTraslados = '';
String celular1_DetTraslados = '';
String celular2_DetTraslados = '';
String celular3_DetTraslados = '';
String celular_DetTraslados = '';
String foto_servicio_DetTraslados = '';
String observacion_traslado = '';
String vlan_traslado = '';
String gateway_traslado = '';

String persona_contactar_traslados = '';
String ip_traslado = '';
String red_ip_traslado = '';
String mascara_ip_traslado = '';
String procedeTraslado = 'SI';
bool isRealizaTraslado = true;
String tipo_factura_traslado = '';

// *AQUI VARIABLES PARA DETALLE CORTADOS POR IMPAGO* //
int item_detCortados = 0;
String identidad_detCortados = '';
String cliente_detCortados = '';
String codigo_servicio_detCortados = '';
String ip_radio_detCortados = '';
String ancho_banda_subida_detCortados = '';
String ancho_banda_bajada_detCortados = '';
String comparticion_detCortados = '';
String estado_servicio_detCortados = '';
String latitud_detCortados = '';
String longitud_detCortados = '';
String contactar_detCortados = '';
String direccion_detCortados = '';
String id_cliente_detCortados = '';
String codigo_cliente_detCortados = '';
String ip_servicio_detCortados = '';
double saldo_servicio_detCortados = 0.00;
String fecha_factura_detCortados = '';
String fecha_corte_detCortados = '';
String meses_activos_detCortados = '';
String referencias_personales_detCortados = '';
String foto_servicio_detCortados = '';

String celular1_detCortados = '';
String celular2_detCortados = '';
String celular3_detCortados = '';
String celular_corteimpago_detCortados = '';

String factura_SI_NO = 'NO';
bool factura = false;
double totalFacturar = 0;
List<int> nTickets = [];
List<int> nTicketsAdicionales = [];
List<int> cantTickets = [];
String codigo_Serie = '';
String tipocondicion = 'Seleccionar';
String detalleSoluSoporte = '';
String colorFact = '2';

List<lista_producto> items = [];
List<lista_producto> itemsAdcionales = [];
List<Productos_PDF> itemsPDF = [];
List<lista_seriesProd> serieProducts = [];
List<lista_seriesProd> serieProductsAdicional = [];
int itemPro = 0;
String codigoPro = '';
String codigoProductoPro = '';
String nombrePro = '';
String stockPro = '';
String precioPro = '';
String categoriaPro = '';
String descripcionPro = '';
String fotoPro = '';
String tipoPro = '';
double totalPro = 0;
String seriePro = '';
String seriesPro = '';
String cobro = 'SI';
List<String> nfacturaSiNo = [];
List<String> nfacturaSiNoAdicional = [];
String nFactProduct = 'SI';
List nDescuento = [];
List nDescuentoAdicional = [];
Timer? miTimer;
int numAdicioanl = 0;
dynamic data_prestacion;
List listarSeriesGarantias = [];

List latitudMap = [];
List longitudMap = [];
List titleMap = [];
List iteMap = [];
List prioridadMap = [];

String clienteFactura = "";
String nomAuxiliar = "";
double valorCobrado = 0.0;
String numFactura = "";

//FOTOS
XFile? imageHouse, imageInstalation;
int numImageHouse = 0, numImageInstalation = 0;
File? fileImageHouse, fileImageInstalation;

bool deleteImg = true;

// ESTADISTICA
DateTime? startDate;
DateTime? endDate;
String processState = 'TODOS';
String id_technician = '0';
String selected_technician = 'TODOS';
String statistic_type_process = 'INSTALACION';
List<ProcesosModel> listProcessState = [];
List<TecnicoModel> listTecnicos = [];

//PROSPECTO
List<CRMProducts> crmProductsList = [];

//ONT LIBRES
List listarONTLIBRES = [];
