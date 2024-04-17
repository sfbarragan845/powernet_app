// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '/app/clases/cConfig_UI.dart';

class SobreNosotros extends StatelessWidget {
  const SobreNosotros({Key? key}) : super(key: key);

  Widget _addParrafo(String titulo, String contenido) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: titulo,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorFondo.PRIMARY,
                fontSize: 16),
          ),
          TextSpan(
            text: contenido,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _addText(String valor, double tamano, Color _color) {
    if (tamano <= 0) {
      tamano = 22;
    }
    return Center(
      child: Text(
        valor,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: tamano, fontWeight: FontWeight.bold, color: _color),
      ),
    );
  }

  Widget _saltoLinea(double cantidad) {
    return SizedBox(
      height: cantidad,
    );
  }

  Widget _quienesSomos() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: <Widget>[
          _saltoLinea(20),
          _addText('Historia', 0, ColorFondo.AUXILIAR),
          _saltoLinea(35),
          _addParrafo('ORIGIN ',
              'es una empresa de Enkador que nace para ser protagonista en el proceso de sostenibilidad en la cadena de valor del reciclaje inclusivo: es la primera marca en Ecuador que engloba a todo el proceso de la economía circular inclusiva, mediante la producción y puesta en el mercado de resina, preformas y botellas R-PET elaboradas con PET post consumo como materia prima trabajando de la mano con miles de recicladores de base.'),
          _saltoLinea(5),
          // _addParrafo('',
          //     'En 1975, nace Enkador S.A con sus operaciones en la producción de filamentos de poliéster. Fue fundado en asociación con fabricantes textileros ecuatorianos y el consorcio AKZO-NOBEL con sede en Ecuador. Nuestra planta industrial está ubicada en el Valle de los Chillos al sureste de la ciudad de Quito, con un entorno de hermosos paisajes y naturaleza única que preservamos continuamente.'),
          _saltoLinea(10),
          //  _addParrafo('',
          //      'La constante investigación y búsqueda por encontrar nuevos horizontes nos ha permitido ingresar en nuevos segmentos de negocios, es así como en el año 2006 Enkador lanza al mercado la línea de limpieza MICROLIMPIA ®, fabricados con microfibras. En el 2012 se inician las operaciones en la planta Recypet ®, de esta manera incursionó en el mercado de resinas plásticas a partir del reciclaje de las botellas PET post-consumo. Esta planta dispone de equipos de última generación para la fabricación de resina PET con tecnología FDA.'),
          //_imagen('$ROOT/app/imagenes/exclusivos/nosotross.png'),
          _saltoLinea(15),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Sobre Nosotros'),
            leading: IconButton(
              tooltip: 'Regresar',
              icon: const Icon(Icons.arrow_back_ios_outlined),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icons/MarcaAgua.png"),
            fit: BoxFit.scaleDown,
          ),
        ),
            child: 
              _quienesSomos(),
             /* Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 510.0, 8.0, 20.0),
                child: ListView(
                  children: <Widget>[
                    GestureDetector(
                      onTap: _launchUrl,
                      child: SvgPicture.asset(
                        'assets/images/logo_20.svg',
                        width: 250,
                      ),
                    )
                  ],
                ),
              )*/
            
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse('https://www.origin-recycle.com/');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {}
  }
}
