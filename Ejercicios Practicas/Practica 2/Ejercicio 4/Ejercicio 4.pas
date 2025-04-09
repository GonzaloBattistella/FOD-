{
  4. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
  archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
  alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
  agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
  localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
  necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
 
  NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
  pueden venir 0, 1 ó más registros por cada provincia
}


program Ejercicio4;
const
  valorNulo = 'null';
type
  provincia = record
    nombre:String;
    cantAlfabetizados:LongInt;
    totalEncuestados:LongInt;
  end;
  
  localidad = record
    nombreProv:string;
    codigoLocalidad:integer;
    cantAlfabetizados:LongInt;
    cantEncuestados:LongInt;
  end;
  
  tMaestro = file of provincia;
  tDetalle = file of localidad;

//PROCESOS

//IMPRIMIR DETALLE
procedure imprimirDetalle(var det:tDetalle);
var
  l:localidad;
begin
  reset(det); //Abro el archivo detalle.
  
  while not EOF(det) do begin
    read(det, l); //Leo una localidad.
    writeln('Nombre Provincia: ', l.nombreProv);
    writeln('Codigo Localidad: ', l.codigoLocalidad);
    writeln('Cantidad Alfabetizados: ', l.cantAlfabetizados);
    writeln('Cantidad Encuestados: ', l.cantEncuestados);
    writeln('------------------------------------------');
  end;
  
  close(det); //Cierro el archivo.
  
  writeln(' ');
end;

//IMPRIMIR MAESTRO
procedure imprimirMaestro(var m:tMaestro);
var
  p:provincia;
begin
  reset(m); //Abro el archivo detalle
  
  writeln(' ');
  writeln('-------------------------------------------');
  writeln('ARCHIVO MAESTRO');
  writeln('-------------------------------------------');
  
  while not EOF(m) do begin
    read(m, p); //Leo una provincia del maestro.
    writeln('Nombre: ', p.nombre);
    writeln('Cantidad Alfabetizados: ', p.cantAlfabetizados);
    writeln('Total Encuestados: ', p.totalEncuestados);
    writeln('-------------------------------------------');
  end;
  
  close(m); //Cierro el archivo maestro.
  
  writeln(' ');
end;


//LEER DETALLE 
procedure leerDetalle(var det: tDetalle; var reg: localidad);
begin
  if not EOF(det) then
    read(det, reg)
  else
    reg.nombreProv := valorNulo; // Marca de fin
end;

//MINIMO
procedure minimo(var det1, det2: tDetalle; var reg1, reg2, regMin: localidad);
begin
  if (reg1.nombreProv <= reg2.nombreProv) then
  begin
    regMin := reg1;
    leerDetalle(det1, reg1); // Avanzás el que "ganó"
  end
  else
  begin
    regMin := reg2;
    leerDetalle(det2, reg2);
  end;
end;


//ACTUALIZAR MAESTRO
procedure actualizarMaestro(var m: tMaestro; var det1, det2: tDetalle);
var
  regD, reg1, reg2: localidad;
  regM: provincia;
begin
  reset(m); reset(det1); reset(det2);

  leerDetalle(det1, reg1);
  leerDetalle(det2, reg2);
  minimo(det1, det2, reg1, reg2, regD);

  while regD.nombreProv <> valorNulo do
  begin
    // Buscar la provincia correspondiente en el maestro
    read(m, regM);
    while (regM.nombre <> regD.nombreProv) do
      read(m, regM);

    // Acumulamos todos los datos de la misma provincia
    while (regM.nombre = regD.nombreProv) do
    begin
      regM.cantAlfabetizados := regM.cantAlfabetizados + regD.cantAlfabetizados;
      regM.totalEncuestados := regM.totalEncuestados + regD.cantEncuestados;
      minimo(det1, det2, reg1, reg2, regD);
    end;

    // Volvemos una posición y escribimos el registro actualizado
    seek(m, filePos(m) - 1);
    write(m, regM);
  end;

  close(m);
  close(det1);
  close(det2);

  writeln('Archivo Maestro Actualizado Exitosamente!');
end;


//PROGRAMA PRINCIPAL
var
  m:tMaestro;
  det1, det2: tDetalle;
BEGIN
  assign(m, 'maestro_provincias.dat');
  assign(det1, 'detalle_agencia1.dat');
  assign(det2, 'detalle_agencia2.dat');
  
  writeln(' ');
  writeln('------------------------------------------');
  writeln('ARCHIVO DETALLE 1');
  writeln('------------------------------------------');
  imprimirDetalle(det1);
  writeln(' ');
  writeln('------------------------------------------');
  writeln('ARCHIVO DETALLE 2');
  writeln('------------------------------------------');
  imprimirDetalle(det2);
  writeln(' ');
  actualizarMaestro(m, det1, det2); //Actualizo el archivo maestro, con los archivos detalles.
  imprimirMaestro(m); //Muestro el Maestro Actualizado.
  writeln(' ');
  writeln('Programa Terminado!');
END.

