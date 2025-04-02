{
  1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
  empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
  nombre y monto de la comisión. La información del archivo se encuentra ordenada por
  código de empleado y cada empleado puede aparecer más de una vez en el archivo de
  comisiones.
 
  Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
  consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
  única vez con el valor total de sus comisiones.
 
  NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
  recorrido una única vez
  * 
  * 
  NOTA: No funciona, no carga correctamente el archivo maestro.
}


program Ejercicio1;
const
  valorAlto = 9999;
type
  empleado = record
    codigo:Integer;
    nombre:string;
    monto:real;
  end;
  
  tArch = File of empleado;

//PROCESOS

//PROCESO LEER
procedure leer(var det:tArch; var regD:empleado);
begin
  if(not EOF (det)) then 
    read(det, regD)
  else
    regD.codigo:= valorAlto;
end;


//PROCESO GENERAR MAESTRO
procedure generarMaestro(var det:tArch ; var m:tArch);
var
  regD, regM: empleado;
  suma: real;
begin
  reset(det); //Abro el archivo detalle
  rewrite(m); //Creo el archivo maestro, si existe se sobreescribe.

  leer(det, regD); //Leo el primer empleado.
  while(regD.codigo <> valorAlto) do begin
    suma := 0;
    regM := regD; // Asigno el primer registro del grupo a regM

    while(regD.codigo = regM.codigo) do begin
      suma := suma + regD.monto;
      leer(det, regD); // Leo el siguiente empleado
    end;

    regM.monto := suma; // Actualizo el monto en el registro maestro.
    write(m, regM); // Escribo el empleado en el maestro.
  end;

  //Cierro los archivos.
  close(det);
  close(m);

  writeln('Archivo Maestro Creado con Exito!.');
end;

//PROCESO EXPORTAR MAESTRO A TXT
procedure exportarMaestroATxt(var m:tArch);
var
  e:empleado;
  mae:Text; //Maestro .txt
begin
  reset(m); //Abro el archivo maestro
  assign(mae, 'comisiones_maestro.txt');
  rewrite(mae); //Creo el archivo maestro.txt, si existe se sobreescribe
  
  while not EOF(m) do begin
    read(m, e); //Leo un empleado
    writeln(mae, e.codigo,' ', e.monto:0:2,' ', e.nombre); //Escribo en el maestro.txt
  end;
  
  //Cierro los archivos.
  close(m); 
  close(mae);
  
  writeln('Archivo Maestro exportado a TXT Exitosamente!.');
end;

//PROCESO IMPRIMIR MAESTRO
procedure imprimirMaestro(var m:tArch);
var
  e:empleado;
begin
  reset(m); 
  
  writeln(' ');
  writeln('---------------------------------------');
  writeln('ARCHIVO MAESTRO');
  writeln('---------------------------------------');
  while not EOF (m) do begin
    read(m, e); //Leo un Empleado
    writeln('Codigo: ', e.codigo);
    writeln('Monto: ', e.monto:0:2);
    writeln('Nombre: ', e.nombre);
    writeln('---------------------------------------');
  end;
  
  close(m);
end;

//PROCESO IMPRIMIR DETALLE
procedure imprimirDetalle(var det:tArch);
var
  e:empleado;
begin
  reset(det);
  
  writeln(' ');
  writeln('------------------------------------------');
  writeln('ARCHIVO DETALLE');
  writeln('------------------------------------------');
  while not EOF(det) do begin
    read(det, e); //Leo un empleado.
    writeln(e.codigo);
    writeln(e.monto:0:2);
    writeln(e.nombre);
    writeln('------------------------------------------');
  end;
end;

//PROGRAMA PRINCIPAL  
var
  m, det:tArch;
BEGIN
  assign(m, 'comisiones_maestro.dat');
  assign(det, 'comisiones_detalle.dat');
  imprimirDetalle(det);
  generarMaestro(det, m); //Proceso que se va a encargar de compactar el archivo detalle.
  exportarMaestroATxt(m);
  imprimirMaestro(m);
END.

