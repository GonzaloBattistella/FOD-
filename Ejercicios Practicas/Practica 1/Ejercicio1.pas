{
  1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
  incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
  cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
  archivo debe ser proporcionado por el usuario desde teclado.
}


program Ejercicio1;
type
  tArch = File of Integer;
  
  
//PROCESO CARGAR ARCHIVO
procedure cargarArchivo(var a:tArch);
var
  num:integer;
begin
  writeln('Ingrese un numero entero, (30000 para terminar): ');
  readln(num);
  writeln('-------------------------------------------------');
  
  while(num <> 30000)do begin
    write(a, num); //Escribo el numero entero ingresado en el archivo.
    writeln('Ingrese un numero entero, (30000 para terminar): ');
    readln(num);
    writeln('-------------------------------------------------');
  end;
  writeln(' ');
end;

//PROGRAMA PRINCIPAL    
var
  a: tArch;
  nomArch: String;
BEGIN
  writeln('Ingrese el Nombre del Archivo (Sin Extension): ');
  readln(nomArch); //Nombre fisico del archivo, Ingresado por el usuario.
  nomArch:= nomArch + '.dat'; //Agrego extension al archivo, recomendable.
  writeln(' ');
  
  assign(a, nomArch);
  rewrite(a); //Creo el archivo. 
  
  cargarArchivo(a); //Cargo el archivo co numeros enteros hasta que se ingresa el numero 30000.
  close(a); //Cierro el archivo.
  writeln('Archivo ', nomArch, ' creado Exitosamente!');
  writeln(' ');
END.

