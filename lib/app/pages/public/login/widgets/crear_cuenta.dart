import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../clases/cResponsive2.dart';
import '/app/clases/cConfig_UI.dart';
import '../../../../models/share_preferences.dart';
import '../../registro_kyc/screens/paso1.2.dart';

Widget crearCuenta(BuildContext context) {
  return ElevatedButton.icon(
      onPressed: () {
        Preferences.num_page = 2;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Registro12()));
      },
      icon: const Icon(
        Icons.person_add,
        color: ColorFondo.BTNUBI,
      ),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Registrar Cuenta',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: Responsive.isMobile_pequenio(context)
                ? 15
                : Responsive.isMobile_mediano(context)
                    ? 55
                    : Responsive.isMobile_grande(context)
                        ? 55
                        : Responsive.isMobile_extragrande(context)
                            ? 55
                            : Responsive.isMobile_extragrande2(context)
                                ? 55
                                : Responsive.isMobile_extragrande3(context)
                                    ? 55
                                    : Responsive.isTablet_pequenio(context)
                                        ? 55
                                        : Responsive.isTablet_mediano(context)
                                            ? 55
                                            : Responsive.isTablet_grande(
                                                    context)
                                                ? 55
                                                : Responsive.isDesktop(context)
                                                    ? 55
                                                    : 55,
          ),
          SvgPicture.asset(
            'assets/images/iconMundo.svg',
            width: 30,
          )
        ],
      ),
      style: ElevatedButton.styleFrom(
          fixedSize: const Size(260, 40), backgroundColor: Colors.white,
          shape: const StadiumBorder(),
          alignment: Alignment.centerLeft));
}
