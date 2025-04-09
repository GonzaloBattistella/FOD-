{
   CrearArchivosAlfabetizacion.pas
   
   Copyright 2025 Gonzalo Battistella <Gonzalo Battistella@DESKTOP-JTIIAV6>
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   
}


program CrearArchivosAlfabetizacion;

type
  provincia = record
    nombreProvincia: string;
    cantidadAlfabetizados: LongInt;
    totalEncuestados: LongInt;
  end;

  localidad = record
    nombreProvincia: string;
    codigoLocalidad: Integer;
    cantidadAlfabetizados: LongInt;
    cantidadEncuestados: LongInt;
  end;

  tMaestroProvincias = file of provincia;
  tDetalleLocalidades = file of localidad;

var
  maestro: tMaestroProvincias;
  detalle1: tDetalleLocalidades;
  detalle2: tDetalleLocalidades;
  unaProvincia: provincia;
  unaLocalidad: localidad;

begin
  // Crear archivo maestro de provincias (maestro_provincias.dat)
  Assign(maestro, 'maestro_provincias.dat');
  Rewrite(maestro);

  // Agregar provincias de ejemplo (ordenadas por nombre)
  unaProvincia.nombreProvincia := 'Buenos Aires';
  unaProvincia.cantidadAlfabetizados := 12000;
  unaProvincia.totalEncuestados := 15000;
  Write(maestro, unaProvincia);

  unaProvincia.nombreProvincia := 'Catamarca';
  unaProvincia.cantidadAlfabetizados := 3500;
  unaProvincia.totalEncuestados := 4000;
  Write(maestro, unaProvincia);

  unaProvincia.nombreProvincia := 'Cordoba';
  unaProvincia.cantidadAlfabetizados := 30000;
  unaProvincia.totalEncuestados := 32000;
  Write(maestro, unaProvincia);

  unaProvincia.nombreProvincia := 'Santa Fe';
  unaProvincia.cantidadAlfabetizados := 28000;
  unaProvincia.totalEncuestados := 32000;
  Write(maestro, unaProvincia);

  Close(maestro);
  writeln('Archivo binario "maestro_provincias.dat" creado exitosamente.');

  // Crear archivo detalle 1 (detalle_agencia1.dat)
  Assign(detalle1, 'detalle_agencia1.dat');
  Rewrite(detalle1);

  // Agregar localidades de ejemplo para la Agencia 1 (ordenadas por nombre de provincia)
  unaLocalidad.nombreProvincia := 'Buenos Aires';
  unaLocalidad.codigoLocalidad := 1001;
  unaLocalidad.cantidadAlfabetizados := 6000;
  unaLocalidad.cantidadEncuestados := 7500;
  Write(detalle1, unaLocalidad);

  unaLocalidad.nombreProvincia := 'Buenos Aires';
  unaLocalidad.codigoLocalidad := 1002;
  unaLocalidad.cantidadAlfabetizados := 4000;
  unaLocalidad.cantidadEncuestados := 5000;
  Write(detalle1, unaLocalidad);

  unaLocalidad.nombreProvincia := 'Catamarca';
  unaLocalidad.codigoLocalidad := 2001;
  unaLocalidad.cantidadAlfabetizados := 20000;
  unaLocalidad.cantidadEncuestados := 25000;
  Write(detalle1, unaLocalidad);

  unaLocalidad.nombreProvincia := 'Cordoba';
  unaLocalidad.codigoLocalidad := 3001;
  unaLocalidad.cantidadAlfabetizados := 15000;
  unaLocalidad.cantidadEncuestados := 17500;
  Write(detalle1, unaLocalidad);

  unaLocalidad.nombreProvincia := 'Santa Fe';
  unaLocalidad.codigoLocalidad := 4001;
  unaLocalidad.cantidadAlfabetizados := 14000;
  unaLocalidad.cantidadEncuestados := 16000;
  Write(detalle1, unaLocalidad);

  Close(detalle1);
  writeln('Archivo binario "detalle_agencia1.dat" creado exitosamente.');

  // Crear archivo detalle 2 (detalle_agencia2.dat)
  Assign(detalle2, 'detalle_agencia2.dat');
  Rewrite(detalle2);

  // Agregar localidades de ejemplo para la Agencia 2 (ordenadas por nombre de provincia)
  unaLocalidad.nombreProvincia := 'Buenos Aires';
  unaLocalidad.codigoLocalidad := 1003;
  unaLocalidad.cantidadAlfabetizados := 20000;
  unaLocalidad.cantidadEncuestados := 25000;
  Write(detalle2, unaLocalidad);

  unaLocalidad.nombreProvincia := 'Catamarca';
  unaLocalidad.codigoLocalidad := 2002;
  unaLocalidad.cantidadAlfabetizados := 15000;
  unaLocalidad.cantidadEncuestados := 15000;
  Write(detalle2, unaLocalidad);

  unaLocalidad.nombreProvincia := 'Cordoba';
  unaLocalidad.codigoLocalidad := 3002;
  unaLocalidad.cantidadAlfabetizados := 10000;
  unaLocalidad.cantidadEncuestados := 12000;
  Write(detalle2, unaLocalidad);

  unaLocalidad.nombreProvincia := 'Cordoba';
  unaLocalidad.codigoLocalidad := 3003;
  unaLocalidad.cantidadAlfabetizados := 5000;
  unaLocalidad.cantidadEncuestados := 5500;
  Write(detalle2, unaLocalidad);

  unaLocalidad.nombreProvincia := 'Santa Fe';
  unaLocalidad.codigoLocalidad := 4002;
  unaLocalidad.cantidadAlfabetizados := 10000;
  unaLocalidad.cantidadEncuestados := 12000;
  Write(detalle2, unaLocalidad);

  unaLocalidad.nombreProvincia := 'Santa Fe';
  unaLocalidad.codigoLocalidad := 4003;
  unaLocalidad.cantidadAlfabetizados := 4000;
  unaLocalidad.cantidadEncuestados := 4000;
  Write(detalle2, unaLocalidad);

  Close(detalle2);
  writeln('Archivo binario "detalle_agencia2.dat" creado exitosamente.');

  readln;
end.
