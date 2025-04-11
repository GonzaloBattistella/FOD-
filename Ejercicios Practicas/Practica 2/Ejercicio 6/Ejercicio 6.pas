{
  6. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
  construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
  máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
  archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
  cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
  cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
  detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
  tiempo_total_de_sesiones_abiertas.
 
  Notas:
    ● Cada archivo detalle está ordenado por cod_usuario y fecha.
 
    ● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
      inclusive, en diferentes máquinas.
 
    ● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}


program Ejercicio6;

uses SysUtils; 

const
  N = 5;
  valorAlto = 9999;
type
  regDetalle = record
    codigo:integer;
    fecha: String[10];
    tiempo_sesion:integer;
  end;
  
  regMaestro = record
    cod_usuario:integer;
    fecha:String[10];
    tiempo_total_sesiones:integer;
  end;
  
  tdetalle = file of regDetalle;
  tMaestro = file of regMaestro;
  
  detalles = array [1.. N] of tDetalle;
  registros = array [1..N] of regDetalle;
  
//PROCESOS

//LEER
procedure leer(var det:tDetalle; var regD:regDetalle);
begin
  if not EOF(det) then
    read(det, regD)
  else
    regD.codigo:= valorAlto;
end;

//ASIGNAR ARCHIVOS DETALLES
procedure asignarArchivosDetalles(var d:detalles);
var
  i:integer;
begin
  for i := 1 to N do 
    assign(d[i], 'log_maquina_' + IntToStr(i) + '.dat');
end;

//ABRIR ARCHIVOS DETALLES
procedure abrirArchivosDetalles(var d:detalles; var r:registros);
var
  i:integer;
begin
  for i:= 1 to N do begin 
    reset(d[i]); //Abro el archivo
    leer(d[i], r[i]); //Leo el primer registro de cada uno de los archivos detalles.
  end;
end;

//CERRAR ARCHIVOS DETALLES.
procedure cerrarArchivosDetalles(var d:detalles);
var
  i:integer;
begin
  for i:= 1 to N do 
    close(d[i]);
end;

//ACTUALIZAR MAESTRO
procedure actualizarMaestro(var m: tMaestro; var d: detalles);

    //MINIMO
    procedure minimo(var d: detalles; var r: registros; var min: regDetalle);
    var
      i, posMin: integer;
    begin
      min.codigo := valorAlto;
      min.fecha := '9999-99-99';  // para garantizar orden correcto
      posMin := -1;

      for i := 1 to N do begin
        if (r[i].codigo < min.codigo) or((r[i].codigo = min.codigo) and (r[i].fecha < min.fecha)) then begin
          posMin := i;
        end;
      end;

      if posMin <> -1 then begin
        min := r[posMin];            
        leer(d[posMin], r[posMin]);
      end;
    end;


var
  r: registros;
  min: regDetalle;
  regM: regMaestro;
  codActual: integer;
  fechaAct: string;
  tiempoTotal: integer;
begin
  rewrite(m); // crear archivo maestro
  abrirArchivosDetalles(d, r); // abrir y leer primeros registros
  
  minimo(d, r, min); // obtener el primer mínimo
  while min.codigo <> valorAlto do begin
    codActual := min.codigo;
    while (min.codigo <> valorAlto) and (min.codigo = codActual) do begin
      fechaAct := min.fecha;
      tiempoTotal := 0;

      while (min.codigo <> valorAlto) and (min.codigo = codActual) and (min.fecha = fechaAct) do begin
        tiempoTotal := tiempoTotal + min.tiempo_sesion;
        minimo(d, r, min);
      end;

      // escribir el consolidado por (usuario, fecha)
      regM.cod_usuario := codActual;
      regM.fecha := fechaAct;
      regM.tiempo_total_sesiones := tiempoTotal;
      write(m, regM);
    end;
  end;

  close(m);
  cerrarArchivosDetalles(d);
  writeln('Archivo Maestro generado con exito.');
end;


//IMPRIMIR MAESTRO
procedure imprimirMaestro(var m:tMaestro);
var
  reg: regMaestro;
begin
  reset(m); //Abro el Archivo Maestro.
  
  writeln(' ');
  writeln('-----------------------------------------------------');
  writeln('ARCHIVO MAESTRO');
  writeln('-----------------------------------------------------');
  while not EOF (m) do begin
    read(m, reg); //Leo un registro del maestro.
    writeln('Codigo: ', reg.cod_usuario);
    writeln('Fecha: ', reg.fecha);
    writeln('Tiempo Total Sesiones: ', reg.tiempo_total_sesiones);
    writeln('-----------------------------------------------------');
  end;
  
  close(m); //Cierro el archivo maestro.
end;

//PROGRAMA PRINCIPAL.
var
  m:tMaestro;
  d:detalles; //Arreglo con archivos detalles.
BEGIN	
	assign(m, 'maestro_sesiones.dat'); //La ruta tendria que ser: /var/log/maestro_sesiones.dat
  asignarArchivosDetalles(d); 
  actualizarMaestro(m,d);
  imprimirMaestro(m);
END.

