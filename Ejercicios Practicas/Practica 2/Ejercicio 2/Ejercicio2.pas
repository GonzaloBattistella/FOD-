{
  2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
  cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
  (cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
  un archivo detalle con el código de alumno e información correspondiente a una materia
  (esta información indica si aprobó la cursada o aprobó el final).
 
  Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
  haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
  programa con opciones para:

  a. Actualizar el archivo maestro de la siguiente manera:
 
  i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado,
  y se decrementa en uno la cantidad de materias sin final aprobado.
 
  ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
  final.
 
  b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales
  aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
  es un reporte de salida (no se usa con fines de carga), debe informar todos los
  campos de cada alumno en una sola línea del archivo de texto.
 
  NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.
}


program Ejercicio2;
const
  valorAlto = 9999; 
type
  alumno = record
    codigo:integer;
    apellido:string;
    nombre:string;
    cursadasAprobadas:integer;
    finalesAprobados:integer;
  end;
  
  materia = record
    codigoAlumno:integer;
    estadoMateria:char;
  end;
  
  tMaestro = file of alumno;
  tDetalle = file of materia;
  
//PROCESOS

//LEER DETALLE
procedure leerDetalle(var det:tDetalle; var regD:materia);
begin
  if not EOF(det) then begin
    read(det, regD);
  end
  else 
    regD.codigoAlumno:= valorAlto;
end;

//LEER MAESTRO
procedure leerMaestro(var mae:tMaestro; var regM:alumno);
begin
  if not EOF(mae) then begin
    read(mae, regM);
  end;
end;

//ACTUALIZAR MAESTRO
procedure actualizarMaestro(var mae:tMaestro; var det:tDetalle);
var
  regM: alumno;
  regD: materia;
begin
  reset(mae); //Abro el archivo maestro.
  reset(det); //Abro el archivo detalle.
  
  leerDetalle(det, regD);
  while(regD.codigoAlumno <> valorAlto)do begin 
    leerMaestro(mae, regM); 
    
    while(regM.codigo <> regD.codigoAlumno)do
      leerMaestro(mae,  regM); //Busco al alumno a actualizar en el maestro.
      
    while(regM.codigo = regD.codigoAlumno)do begin 
      if(regD.estadoMateria = 'F')then begin
        regM.cursadasAprobadas:= regM.cursadasAprobadas - 1;
        regM.finalesAprobados:= regM.finalesAprobados + 1;
      end
      else if (regD.estadoMateria = 'C')then 
        regM.cursadasAprobadas:= regM.cursadasAprobadas + 1;
      leerDetalle(det, regD);
    end;
    
    seek(mae, filePos(mae) - 1); //Se reubica el puntero en el maestro.
    write(mae, regM); //Escribo en el archivo maestro.
  end;
  
  //Cierro los Archivos.
  close(det);
  close(mae);
  
  writeln('ARCHIVO MAESTRO ACTUALIZADO EXITOSAMENTE!');
end;

//IMPRIMIR MAESTRO
procedure imprimirMaestro(var mae:tMaestro);
var
  reg:alumno;
begin
  reset(mae);
  
  writeln(' ');
  writeln('---------------------------------------');
  writeln('ARCHIVO MAESTRO');
  writeln('---------------------------------------');
  
  while not EOF(mae) do begin
    read(mae, reg); //Leo un alumno
    writeln('Codigo: ', reg.codigo);
    writeln('Apellido: ', reg.apellido);
    writeln('Nombre: ', reg.nombre);
    writeln('Cursadas Aprobadas: ', reg.cursadasAprobadas);
    writeln('Finales Aprobados: ', reg.finalesAprobados);
    writeln('---------------------------------------');
  end;
end;

//LISTAR ALUMNOS TXT
procedure listarAlumnosEnTxt(var mae:tMaestro);
var
  reg:alumno;
  arch: Text;
begin
  assign(arch, 'listadoAlumnosConMasFinalesAprobados.txt');
  rewrite(arch); //Creo el archivo de texto.
  reset(mae); //Abro el archivo maestro.
  
  while not EOF(mae) do begin
    read(mae, reg); //Leo un alumno
    
    if(reg.finalesAprobados > reg.cursadasAprobadas)then
      writeln(arch, reg.codigo,' ', reg.apellido,' ', reg.nombre,' ', reg.cursadasAprobadas,' ', reg.finalesAprobados); //Escribo en una linea los datos del alumno que cumple la condicion.
  end;
  
  //Cierro los Archivos.
  close(arch);
  close(mae);
  
  writeln('Archivo TXT generado Correctamente!.');
end;

//PROGRAMA PRINCIPAL  
var
  det: tDetalle;
  mae: tMaestro;
BEGIN
  assign(det, 'detalle_materias.dat'); //Archivo detalle
  assign(mae, 'alumnos.dat'); //Archivo Maestro
  
  actualizarMaestro(mae, det);
  imprimirMaestro(mae);
  listarAlumnosEnTxt(mae); //Genero un archivo .txt con los alumnos que tienen mas finales aprobados que cursadas aprobadas.
END.

