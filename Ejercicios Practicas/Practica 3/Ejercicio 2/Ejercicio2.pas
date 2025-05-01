{
  2. Definir un programa que genere un archivo con registros de longitud fija conteniendo 
  información de asistentes a un congreso a partir de la información obtenida por 
  teclado. 
  
  Se deberá almacenar la siguiente información: nro de asistente, apellido y 
  nombre, email, teléfono y D.N.I. 
  
  Implementar un procedimiento que, a partir del archivo de datos generado, elimine de forma lógica 
  todos los asistentes con nro de asistente inferior a 1000.
    
  Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo 
  String a su elección.  Ejemplo:  ‘@Saldaño’. 
}


program Ejercicio2;
type
  asistente = record
    numero:integer;
    apellidoynombre:string;
    email:string;
    tel:string;
    dni:Int64;
  end;
  
  tArch = file of asistente;

//PROCESOS

//LEER ASISTENTE.
procedure leerAsistente(var reg:asistente);
begin
  writeln(' ');
  writeln('Ingrese el numero de Asistente: ');
  readln(reg.numero);
  
  if(reg.numero <> 0)then begin
    writeln('Ingrese el Apellido y Nombre: ');
    readln(reg.apellidoynombre);
    writeln('Ingrese el Email del Asistente: ');
    readln(reg.email);
    writeln('Ingrese el Telefono del Asistente: ');
    readln(reg.tel);
    writeln('Ingrese el DNI del Asistente: ');
    readln(reg.dni);
  end;
  
  writeln('-------------------------------------------------');
end;

//CARGAR ARCHIVO ASISTENTES.
procedure cargarArchivoAsistentes(var a:tArch);
var
  reg:asistente;
begin
  rewrite(a); //Creo el Archivo, si existe se sobreescribe.
  
  leerAsistente(reg);
  while(reg.numero <> 0)do begin
    write(a, reg); //Escribo en el archivo.
    leerAsistente(reg); //Leo un nuevo empleado desde teclado.
  end;
  
  writeln('Archivo Cargado Exitosamente!');
  
  close(a); //Cierro el Archivo.
end;

//IMPRIMIR ARCHIVO
procedure imprimirArchivo(var a:tArch);
var
  r:asistente;
begin
  reset(a); //Abro el archivo.
  
  writeln(' ');
  writeln('-----------------------------------------');
  writeln('ARCHIVO ASISTENTES');
  writeln('-----------------------------------------');
  
  while not EOF (a) do begin
    read(a, r); //Leo un asistente.
    if(r.apellidoynombre[1] <> '*')then begin
      writeln('Numero Asistente: ', r.numero);
      writeln('Apellido y Nombre: ', r.apellidoynombre);
      writeln('Email: ', r.email);
      writeln('Telefono: ', r.tel);
      writeln('DNI: ', r.dni);
      writeln('------------------------------------------');
    end;
  end;
  
  close(a); //Cierro el archivo.
end;

//REALIZAR BAJA LOGICA
procedure realizarBajaLogica(var a:tArch);
var
  reg:asistente;
begin
  reset(a); //Abro el archivo.
  
  while not EOF (a) do begin
    read(a, reg); //Leo un Asistente
    
    if(reg.numero > 1000)then begin
      reg.apellidoyNombre:= '*' + reg.apellidoynombre; //Antepongo la marca de borrado logico en el nombre y apellido.
      seek(a, filePos(a) - 1); //Posiciono el puntero en el registro correcto.
      write(a, reg); //Escribo el registro actualizado con la marca de borrado.
    end;
  end;
  
  writeln('Asistentes Borrados Logicamente Con Exito!');
  
  close(a); //Cierro el archivo.
end;

//PROGRAMA PRINCIPAL  
var
  a:tArch;
  nomArch:string;
BEGIN	
  writeln('Ingrese el Nombre del Archivo: ');
  readln(nomArch);
  
  assign(a, nomArch);
  
  cargarArchivoAsistentes(a); //Leo de teclado los datos de los asistentes y los guardo en un archivo.
  imprimirArchivo(a);
  realizarBajaLogica(a); //Realizo la bnaja logica de los asistentes con numero dde asistente menor a 1000.
  imprimirArchivo(a);
END.

